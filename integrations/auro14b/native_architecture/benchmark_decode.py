from __future__ import annotations

import argparse
import json
import platform
import statistics
import time

import torch
from torch import nn

from .fast_decode import HybridDeltaMemoryAttention
from .model import NativeConfig


def p50_ms(fn, warmup: int, iterations: int) -> float:
    for _ in range(warmup):
        fn()
    samples = []
    for _ in range(iterations):
        started = time.perf_counter_ns()
        fn()
        samples.append((time.perf_counter_ns() - started) / 1e6)
    return statistics.median(samples)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument('--output', default='native-decode-benchmark.json')
    parser.add_argument('--iterations', type=int, default=100)
    args = parser.parse_args()

    torch.manual_seed(11)
    torch.set_num_threads(1)
    config = NativeConfig(vocab_size=128, d_model=256, n_heads=8, n_layers=1, memory_slots=128, top_k=16)
    attention = HybridDeltaMemoryAttention(config).eval()
    state = attention.empty_state(1, torch.device('cpu'), torch.float32)
    state.keys.normal_(); state.values.normal_(); state.utility.fill_(1); state.last_key.normal_()
    x = torch.randn(1, 1, config.d_model)
    hybrid_ms = p50_ms(lambda: attention.decode_step(x, state), 20, args.iterations)

    heads = config.n_heads
    head_dim = config.d_model // heads
    q_proj = nn.Linear(config.d_model, config.d_model, bias=False).eval()
    k_proj = nn.Linear(config.d_model, config.d_model, bias=False).eval()
    v_proj = nn.Linear(config.d_model, config.d_model, bias=False).eval()
    o_proj = nn.Linear(config.d_model, config.d_model, bias=False).eval()
    rows = []
    for length in (128, 512, 2048, 8192, 32768):
        keys = torch.randn(1, heads, length, head_dim)
        values = torch.randn(1, heads, length, head_dim)
        def dense_step():
            query = q_proj(x).view(1, 1, heads, head_dim).transpose(1, 2)
            k_proj(x); v_proj(x)
            scores = torch.matmul(query, keys.transpose(-1, -2)) * head_dim ** -0.5
            weights = torch.softmax(scores, dim=-1)
            context = torch.matmul(weights, values).transpose(1, 2).contiguous().view(1, 1, config.d_model)
            return o_proj(context)
        dense_ms = p50_ms(dense_step, 10, args.iterations)
        rows.append({'context_tokens': length, 'dense_p50_ms': dense_ms, 'hybrid_p50_ms': hybrid_ms, 'hybrid_speedup_vs_dense': dense_ms / hybrid_ms})

    payload = {
        'schema': 'medina.auro.native_decode_benchmark.v1',
        'truth_boundary': 'CPU microbenchmark of one attention decode step; not end-to-end model tokens/sec.',
        'python': platform.python_version(),
        'torch': torch.__version__,
        'machine': platform.machine(),
        'memory_slots': config.memory_slots,
        'top_k': config.top_k,
        'd_model': config.d_model,
        'heads': config.n_heads,
        'rows': rows,
    }
    with open(args.output, 'w') as handle:
        json.dump(payload, handle, indent=2)
    print(json.dumps(payload, indent=2))


if __name__ == '__main__':
    main()
