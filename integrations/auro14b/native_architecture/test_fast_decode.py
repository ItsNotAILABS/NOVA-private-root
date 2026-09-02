from __future__ import annotations

import unittest
import torch

from integrations.auro14b.native_architecture.fast_decode import HybridDeltaMemoryAttention, NativeFastTransformer
from integrations.auro14b.native_architecture.model import NativeConfig
from integrations.auro14b.native_architecture.training import NativeTrainingTransformer


class FastDecodeTests(unittest.TestCase):
    def setUp(self):
        self.config = NativeConfig(vocab_size=128, d_model=32, n_heads=4, n_layers=2, ff_mult=2, memory_slots=8, top_k=2)

    def test_small_bank_uses_dense_bounded_kernel(self):
        attention = HybridDeltaMemoryAttention(self.config, dense_threshold=16)
        state = attention.empty_state(1, torch.device("cpu"), torch.float32)
        state.keys.normal_(); state.values.normal_(); state.utility.fill_(1)
        _, _, metrics = attention.decode_step(torch.randn(1, self.config.d_model), state)
        self.assertEqual(metrics["strategy_sparse"], 0.0)

    def test_large_bank_uses_sparse_kernel(self):
        config = NativeConfig(vocab_size=128, d_model=32, n_heads=4, n_layers=1, memory_slots=64, top_k=2)
        attention = HybridDeltaMemoryAttention(config, dense_threshold=16)
        state = attention.empty_state(1, torch.device("cpu"), torch.float32)
        state.keys.normal_(); state.values.normal_(); state.utility.fill_(1)
        _, _, metrics = attention.decode_step(torch.randn(1, config.d_model), state)
        self.assertEqual(metrics["strategy_sparse"], 1.0)
        self.assertLessEqual(metrics["selected_slots"], config.top_k)

    def test_fast_decoder_loads_training_checkpoint(self):
        tokens = torch.randint(0, self.config.vocab_size, (1, 4))
        senses = {"vision": torch.randn(1, 4, 24)}
        training = NativeTrainingTransformer(self.config, window=4)
        fast = NativeFastTransformer(self.config, dense_threshold=16)
        training(tokens, senses)
        fast(tokens, senses)
        fast.load_state_dict(training.state_dict(), strict=True)


if __name__ == "__main__":
    unittest.main(verbosity=2)
