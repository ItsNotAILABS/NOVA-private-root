from __future__ import annotations

from typing import Dict, Optional

import torch
from torch import Tensor, nn

from .model import AdaptiveResidual, DeltaMemoryAttention, MultisenseAdapter, NativeConfig


def chunked_delta_attention(attn: DeltaMemoryAttention, x: Tensor, window: int = 64, summary_slots: Optional[int] = None) -> Tensor:
    """Differentiable bounded-context attention for training.

    Queries see their causal local window plus a bounded bank of summaries from
    previous windows. Pair growth is O(T * (window + summary_slots)), not O(T^2).
    """
    if x.ndim != 3:
        raise ValueError("expected [batch, time, d_model]")
    if window <= 0:
        raise ValueError("window must be positive")
    summary_slots = summary_slots or attn.config.memory_slots
    q = attn._heads(attn.q_proj(x))
    k = attn._heads(attn.k_proj(x))
    v = attn._heads(attn.v_proj(x))
    total_tokens = q.shape[2]
    summaries_k: list[Tensor] = []
    summaries_v: list[Tensor] = []
    outputs: list[Tensor] = []

    for start in range(0, total_tokens, window):
        end = min(total_tokens, start + window)
        q_local, k_local, v_local = q[:, :, start:end], k[:, :, start:end], v[:, :, start:end]
        memory_k, memory_v = summaries_k[-summary_slots:], summaries_v[-summary_slots:]
        if memory_k:
            k_all = torch.cat([*memory_k, k_local], dim=2)
            v_all = torch.cat([*memory_v, v_local], dim=2)
            memory_length = len(memory_k)
        else:
            k_all, v_all, memory_length = k_local, v_local, 0
        scores = torch.matmul(q_local, k_all.transpose(-1, -2)) * attn.scale
        local_length = end - start
        causal = torch.ones((local_length, local_length), dtype=torch.bool, device=x.device).tril()
        if memory_length:
            allowed = torch.cat([torch.ones((local_length, memory_length), dtype=torch.bool, device=x.device), causal], dim=-1)
        else:
            allowed = causal
        scores = scores.masked_fill(~allowed[None, None], torch.finfo(scores.dtype).min)
        outputs.append(torch.matmul(torch.softmax(scores, dim=-1), v_all))
        summaries_k.append(k_local.mean(dim=2, keepdim=True))
        summaries_v.append(v_local.mean(dim=2, keepdim=True))
        if len(summaries_k) > summary_slots:
            summaries_k, summaries_v = summaries_k[-summary_slots:], summaries_v[-summary_slots:]

    return attn.o_proj(attn._merge(torch.cat(outputs, dim=2)))


class NativeTrainingBlock(nn.Module):
    def __init__(self, config: NativeConfig, window: int = 64):
        super().__init__()
        self.window = window
        self.norm1 = nn.RMSNorm(config.d_model)
        self.attn = DeltaMemoryAttention(config)
        self.residual1 = AdaptiveResidual(config.d_model, config.residual_floor)
        self.norm2 = nn.RMSNorm(config.d_model)
        hidden = config.d_model * config.ff_mult
        self.ff = nn.Sequential(nn.Linear(config.d_model, hidden * 2, bias=False), nn.GLU(dim=-1), nn.SiLU(), nn.Linear(hidden, config.d_model, bias=False))
        self.residual2 = AdaptiveResidual(config.d_model, config.residual_floor)

    def forward(self, x: Tensor) -> tuple[Tensor, Tensor]:
        attention = chunked_delta_attention(self.attn, self.norm1(x), self.window, self.attn.config.memory_slots)
        x, gate1 = self.residual1(x, x + attention)
        feedforward = self.ff(self.norm2(x))
        x, gate2 = self.residual2(x, x + feedforward)
        return x, torch.cat([gate1, gate2], dim=-1)


class NativeTrainingTransformer(nn.Module):
    """Training-efficient twin with state-dict-compatible parameter names."""

    def __init__(self, config: NativeConfig, window: int = 64):
        super().__init__()
        self.config = config
        self.window = window
        self.token_embedding = nn.Embedding(config.vocab_size, config.d_model)
        self.multisense = MultisenseAdapter(config)
        self.layers = nn.ModuleList([NativeTrainingBlock(config, window) for _ in range(config.n_layers)])
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
        return {"logits": self.lm_head(self.norm(x)), "coherence": coherence, "residual_gates": torch.stack(gates, dim=0)}

    def parameter_count(self) -> int:
        return sum(parameter.numel() for parameter in self.parameters())

    def efficiency_receipt(self, sequence_length: int) -> dict[str, float | int | str]:
        windows = (sequence_length + self.window - 1) // self.window
        summaries = min(self.config.memory_slots, max(0, windows - 1))
        dense_pairs = sequence_length * sequence_length
        bounded_pairs = sequence_length * (self.window + summaries)
        return {
            "schema": "medina.auro.native_training_efficiency.v1",
            "sequence_length": sequence_length,
            "local_window": self.window,
            "summary_slots": summaries,
            "dense_attention_pairs_estimate": dense_pairs,
            "bounded_attention_pairs_estimate": bounded_pairs,
            "estimated_pair_reduction": max(0.0, 1.0 - bounded_pairs / max(1, dense_pairs)),
        }
