from __future__ import annotations

from typing import Dict, Optional

import torch
from torch import Tensor, nn

from .model import AdaptiveResidual, DeltaKVState, DeltaMemoryAttention, MultisenseAdapter, NativeConfig


class HybridDeltaMemoryAttention(DeltaMemoryAttention):
    """Use the cheapest bounded attention kernel for the current memory size.

    Small fixed banks avoid top-k overhead and attend directly. Larger banks use
    sparse top-k selection. Both paths keep decode memory bounded.
    """

    def __init__(self, config: NativeConfig, dense_threshold: int = 256):
        super().__init__(config)
        self.dense_threshold = dense_threshold

    def decode_step(self, x: Tensor, state: Optional[DeltaKVState] = None) -> tuple[Tensor, DeltaKVState, Dict[str, float]]:
        if x.ndim == 2:
            x = x[:, None, :]
        if x.ndim != 3 or x.shape[1] != 1:
            raise ValueError("decode_step expects one token/state")
        batch = x.shape[0]
        state = state or self.empty_state(batch, x.device, x.dtype)
        q = self._heads(self.q_proj(x))[:, :, 0]
        k = self._heads(self.k_proj(x))[:, :, 0]
        v = self._heads(self.v_proj(x))[:, :, 0]
        valid = state.utility > 0
        active_max = int(valid.sum(dim=-1).max()) if valid.numel() else 0
        use_dense = self.config.memory_slots <= self.dense_threshold or active_max <= self.config.top_k * 2

        scores = torch.einsum("bhd,bhsd->bhs", q, state.keys) * self.scale
        scores = scores.masked_fill(~valid[:, None, :], torch.finfo(scores.dtype).min)
        mass = torch.zeros_like(state.utility)

        if use_dense:
            weights = torch.softmax(scores, dim=-1) * valid[:, None, :].to(scores.dtype)
            weights = weights / weights.sum(dim=-1, keepdim=True).clamp_min(1e-6)
            context = torch.einsum("bhs,bhsd->bhd", weights, state.values)
            mass.copy_(weights.mean(dim=1))
            selected_slots = float(valid.sum(dim=-1).float().mean())
            strategy = 0.0
        else:
            top_k = min(self.config.top_k, self.config.memory_slots)
            top_scores, top_idx = torch.topk(scores, k=top_k, dim=-1)
            top_valid = torch.gather(valid[:, None, :].expand(-1, self.config.n_heads, -1), -1, top_idx)
            top_scores = top_scores.masked_fill(~top_valid, -1e4)
            weights = torch.softmax(top_scores, dim=-1) * top_valid.to(top_scores.dtype)
            weights = weights / weights.sum(dim=-1, keepdim=True).clamp_min(1e-6)
            gather_idx = top_idx[..., None].expand(-1, -1, -1, self.head_dim)
            context = (torch.gather(state.values, 2, gather_idx) * weights[..., None]).sum(dim=2)
            mass.scatter_add_(1, top_idx.reshape(batch, -1), weights.reshape(batch, -1) / self.config.n_heads)
            selected_slots = float(top_valid.sum(dim=-1).float().mean())
            strategy = 1.0

        context = torch.where((~valid.any(dim=-1))[:, None, None], v, context)
        output = self.o_proj(context.reshape(batch, 1, -1))
        self._write(state, k.detach(), v.detach(), mass.detach())
        return output, state, {
            "memory_slots": float((state.utility > 0).sum(dim=-1).float().mean()),
            "selected_slots": selected_slots,
            "capacity": float(self.config.memory_slots),
            "writes": float(state.writes),
            "strategy_sparse": strategy,
        }


class NativeFastBlock(nn.Module):
    def __init__(self, config: NativeConfig, dense_threshold: int = 256):
        super().__init__()
        self.norm1 = nn.RMSNorm(config.d_model)
        self.attn = HybridDeltaMemoryAttention(config, dense_threshold)
        self.residual1 = AdaptiveResidual(config.d_model, config.residual_floor)
        self.norm2 = nn.RMSNorm(config.d_model)
        hidden = config.d_model * config.ff_mult
        self.ff = nn.Sequential(nn.Linear(config.d_model, hidden * 2, bias=False), nn.GLU(dim=-1), nn.SiLU(), nn.Linear(hidden, config.d_model, bias=False))
        self.residual2 = AdaptiveResidual(config.d_model, config.residual_floor)

    def forward(self, x: Tensor) -> tuple[Tensor, Tensor]:
        attention = self.attn(self.norm1(x))
        x, gate1 = self.residual1(x, x + attention)
        feedforward = self.ff(self.norm2(x))
        x, gate2 = self.residual2(x, x + feedforward)
        return x, torch.cat([gate1, gate2], dim=-1)


class NativeFastTransformer(nn.Module):
    """Decode-optimized model with state-dict keys compatible with training."""

    def __init__(self, config: NativeConfig, dense_threshold: int = 256):
        super().__init__()
        self.config = config
        self.token_embedding = nn.Embedding(config.vocab_size, config.d_model)
        self.multisense = MultisenseAdapter(config)
        self.layers = nn.ModuleList([NativeFastBlock(config, dense_threshold) for _ in range(config.n_layers)])
        self.norm = nn.RMSNorm(config.d_model)
        self.lm_head = nn.Linear(config.d_model, config.vocab_size, bias=False)
        self.lm_head.weight = self.token_embedding.weight

    def forward(self, token_ids: Tensor, senses=None):
        x = self.token_embedding(token_ids)
        x, coherence = self.multisense(x, senses)
        gates = []
        for layer in self.layers:
            x, gate = layer(x)
            gates.append(gate)
        return {"logits": self.lm_head(self.norm(x)), "coherence": coherence, "residual_gates": torch.stack(gates, dim=0)}
