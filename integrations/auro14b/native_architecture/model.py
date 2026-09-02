from __future__ import annotations

from dataclasses import dataclass
import math
from typing import Dict, Iterable, Optional

import torch
from torch import Tensor, nn
import torch.nn.functional as F


@dataclass
class DeltaKVState:
    keys: Tensor
    values: Tensor
    utility: Tensor
    last_key: Tensor
    cursor: int = 0


@dataclass
class NativeConfig:
    vocab_size: int = 4096
    d_model: int = 256
    n_heads: int = 8
    n_layers: int = 6
    ff_mult: int = 3
    memory_slots: int = 128
    top_k: int = 16
    novelty_threshold: float = 0.12
    residual_floor: float = 0.05
    modalities: tuple[str, ...] = ("vision", "audio", "telemetry", "code", "tool", "receipt")


class DeltaMemoryAttention(nn.Module):
    """Fixed-capacity recurrent attention for bounded decode memory.

    The decode path attends only to a bounded memory bank. New KV slots are
    written when the projected key differs enough from the previous key.
    Utility is updated Hebbian-style from attention mass and used for eviction.
    """

    def __init__(self, config: NativeConfig):
        super().__init__()
        if config.d_model % config.n_heads:
            raise ValueError("d_model must be divisible by n_heads")
        self.config = config
        self.head_dim = config.d_model // config.n_heads
        self.scale = self.head_dim ** -0.5
        self.q_proj = nn.Linear(config.d_model, config.d_model, bias=False)
        self.k_proj = nn.Linear(config.d_model, config.d_model, bias=False)
        self.v_proj = nn.Linear(config.d_model, config.d_model, bias=False)
        self.o_proj = nn.Linear(config.d_model, config.d_model, bias=False)

    def empty_state(self, batch: int, device: torch.device, dtype: torch.dtype) -> DeltaKVState:
        shape = (batch, self.config.n_heads, self.config.memory_slots, self.head_dim)
        return DeltaKVState(
            keys=torch.zeros(shape, device=device, dtype=dtype),
            values=torch.zeros(shape, device=device, dtype=dtype),
            utility=torch.zeros((batch, self.config.memory_slots), device=device, dtype=dtype),
            last_key=torch.zeros((batch, self.config.n_heads, self.head_dim), device=device, dtype=dtype),
            cursor=0,
        )

    def _heads(self, x: Tensor) -> Tensor:
        b, t, _ = x.shape
        return x.view(b, t, self.config.n_heads, self.head_dim).transpose(1, 2)

    def _merge(self, x: Tensor) -> Tensor:
        b, h, t, d = x.shape
        return x.transpose(1, 2).contiguous().view(b, t, h * d)

    @torch.no_grad()
    def _write(self, state: DeltaKVState, key: Tensor, value: Tensor, mass: Tensor) -> None:
        # key/value: [B,H,D], mass: [B,S]
        delta = 1.0 - F.cosine_similarity(key, state.last_key, dim=-1).mean(dim=-1)
        should_write = delta >= self.config.novelty_threshold
        if not bool(should_write.any()):
            state.utility.mul_(0.999).add_(0.01 * mass)
            state.last_key.copy_(key)
            return

        state.utility.mul_(0.999).add_(0.01 * mass)
        for batch_index in torch.where(should_write)[0].tolist():
            if bool((state.utility[batch_index] == 0).any()):
                slot = int(torch.where(state.utility[batch_index] == 0)[0][0])
            else:
                slot = int(torch.argmin(state.utility[batch_index]))
            state.keys[batch_index, :, slot].copy_(key[batch_index])
            state.values[batch_index, :, slot].copy_(value[batch_index])
            state.utility[batch_index, slot] = 1.0
        state.last_key.copy_(key)
        state.cursor += int(should_write.sum())

    def decode_step(self, x: Tensor, state: Optional[DeltaKVState] = None) -> tuple[Tensor, DeltaKVState, Dict[str, float]]:
        if x.ndim == 2:
            x = x[:, None, :]
        if x.shape[1] != 1:
            raise ValueError("decode_step expects exactly one token/state")
        b = x.shape[0]
        state = state or self.empty_state(b, x.device, x.dtype)
        q = self._heads(self.q_proj(x))[:, :, 0]
        k = self._heads(self.k_proj(x))[:, :, 0]
        v = self._heads(self.v_proj(x))[:, :, 0]

        valid = state.utility > 0
        scores = torch.einsum("bhd,bhsd->bhs", q, state.keys) * self.scale
        scores = scores.masked_fill(~valid[:, None, :], torch.finfo(scores.dtype).min)
        usable = min(self.config.top_k, self.config.memory_slots)
        top_scores, top_idx = torch.topk(scores, k=usable, dim=-1)
        top_valid = torch.gather(valid[:, None, :].expand(-1, self.config.n_heads, -1), -1, top_idx)
        top_scores = top_scores.masked_fill(~top_valid, -1e4)
        weights = torch.softmax(top_scores, dim=-1) * top_valid.to(top_scores.dtype)
        denom = weights.sum(dim=-1, keepdim=True).clamp_min(1e-6)
        weights = weights / denom
        gather_idx = top_idx[..., None].expand(-1, -1, -1, self.head_dim)
        selected_values = torch.gather(state.values, 2, gather_idx)
        context = (selected_values * weights[..., None]).sum(dim=2)
        no_memory = ~valid.any(dim=-1)
        context = torch.where(no_memory[:, None, None], v, context)
        output = self.o_proj(context.reshape(b, 1, -1))

        mass = torch.zeros_like(state.utility)
        mass.scatter_add_(1, top_idx.mean(dim=1).long().clamp_max(self.config.memory_slots - 1), weights.mean(dim=1))
        self._write(state, k.detach(), v.detach(), mass.detach())
        metrics = {
            "memory_slots": float(valid.sum(dim=-1).float().mean()),
            "selected_slots": float(top_valid.sum(dim=-1).float().mean()),
            "capacity": float(self.config.memory_slots),
        }
        return output, state, metrics

    def forward(self, x: Tensor) -> Tensor:
        # Streaming training path. Autograd flows through projections/residuals;
        # memory writes are detached to keep recurrent state bounded.
        state: Optional[DeltaKVState] = None
        outputs = []
        for token in x.unbind(dim=1):
            out, state, _ = self.decode_step(token, state)
            outputs.append(out)
        return torch.cat(outputs, dim=1)


class AdaptiveResidual(nn.Module):
    def __init__(self, d_model: int, floor: float = 0.05):
        super().__init__()
        self.floor = floor
        self.gate = nn.Sequential(nn.Linear(d_model * 2, d_model // 2), nn.SiLU(), nn.Linear(d_model // 2, 1))

    def forward(self, base: Tensor, update: Tensor) -> tuple[Tensor, Tensor]:
        delta = update - base
        gate = torch.sigmoid(self.gate(torch.cat([base, delta], dim=-1)))
        gate = self.floor + (1.0 - self.floor) * gate
        return base + gate * delta, gate


class PhaseCoupler(nn.Module):
    def __init__(self, d_model: int):
        super().__init__()
        self.phase = nn.Linear(d_model, 2)

    def forward(self, states: Iterable[Tensor]) -> tuple[Tensor, Tensor]:
        items = list(states)
        if not items:
            raise ValueError("at least one state is required")
        phases = []
        for state in items:
            xy = F.normalize(self.phase(state), dim=-1)
            phases.append(xy)
        stacked = torch.stack(phases, dim=0)
        order = stacked.mean(dim=0)
        coherence = order.square().sum(dim=-1).sqrt().clamp(0, 1)
        weights = torch.softmax(coherence.mean(dim=-1, keepdim=True).expand(-1, len(items)), dim=-1)
        fused = sum(item * weights[:, index:index+1, None] for index, item in enumerate(items))
        return fused, coherence


class MultisenseAdapter(nn.Module):
    def __init__(self, config: NativeConfig):
        super().__init__()
        self.adapters = nn.ModuleDict({name: nn.LazyLinear(config.d_model) for name in config.modalities})
        self.coupler = PhaseCoupler(config.d_model)

    def forward(self, text: Tensor, senses: Optional[Dict[str, Tensor]] = None) -> tuple[Tensor, Tensor]:
        states = [text]
        for name, value in (senses or {}).items():
            if name not in self.adapters:
                continue
            projected = self.adapters[name](value)
            if projected.shape[1] != text.shape[1]:
                projected = F.interpolate(projected.transpose(1, 2), size=text.shape[1], mode="linear", align_corners=False).transpose(1, 2)
            states.append(projected)
        if len(states) == 1:
            return text, torch.ones(text.shape[:2], device=text.device, dtype=text.dtype)
        return self.coupler(states)


class NativeBlock(nn.Module):
    def __init__(self, config: NativeConfig):
        super().__init__()
        self.norm1 = nn.RMSNorm(config.d_model)
        self.attn = DeltaMemoryAttention(config)
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


class NativeDeltaTransformer(nn.Module):
    def __init__(self, config: NativeConfig):
        super().__init__()
        self.config = config
        self.token_embedding = nn.Embedding(config.vocab_size, config.d_model)
        self.multisense = MultisenseAdapter(config)
        self.layers = nn.ModuleList([NativeBlock(config) for _ in range(config.n_layers)])
        self.norm = nn.RMSNorm(config.d_model)
        self.lm_head = nn.Linear(config.d_model, config.vocab_size, bias=False)
        self.lm_head.weight = self.token_embedding.weight

    def forward(self, token_ids: Tensor, senses: Optional[Dict[str, Tensor]] = None) -> Dict[str, Tensor]:
        x = self.token_embedding(token_ids)
        x, coherence = self.multisense(x, senses)
        gates = []
        for layer in self.layers:
            x, gate = layer(x)
            gates.append(gate)
        logits = self.lm_head(self.norm(x))
        return {"logits": logits, "coherence": coherence, "residual_gates": torch.stack(gates, dim=0)}

    def parameter_count(self) -> int:
        return sum(parameter.numel() for parameter in self.parameters())
