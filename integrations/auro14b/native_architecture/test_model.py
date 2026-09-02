from __future__ import annotations

import unittest
import torch
import torch.nn.functional as F

from integrations.auro14b.native_architecture.model import NativeConfig, NativeDeltaTransformer
from integrations.auro14b.native_architecture.training import NativeTrainingTransformer


class NativeArchitectureTests(unittest.TestCase):
    def setUp(self):
        torch.manual_seed(7)
        self.config = NativeConfig(vocab_size=128, d_model=32, n_heads=4, n_layers=2, ff_mult=2, memory_slots=8, top_k=4, novelty_threshold=0.05)

    def test_training_forward_backward(self):
        model = NativeTrainingTransformer(self.config, window=4)
        tokens = torch.randint(0, self.config.vocab_size, (2, 12))
        result = model(tokens)
        self.assertEqual(tuple(result["logits"].shape), (2, 12, self.config.vocab_size))
        labels = torch.randint(0, self.config.vocab_size, (2, 12))
        loss = F.cross_entropy(result["logits"].reshape(-1, self.config.vocab_size), labels.reshape(-1))
        loss.backward()
        for projection in (model.layers[0].attn.q_proj, model.layers[0].attn.k_proj, model.layers[0].attn.v_proj):
            self.assertIsNotNone(projection.weight.grad)
            self.assertGreater(float(projection.weight.grad.abs().sum()), 0.0)

    def test_multisense_native_fusion(self):
        model = NativeTrainingTransformer(self.config, window=4)
        tokens = torch.randint(0, self.config.vocab_size, (2, 8))
        senses = {"vision": torch.randn(2, 4, 24), "audio": torch.randn(2, 8, 12), "telemetry": torch.randn(2, 2, 6)}
        result = model(tokens, senses)
        self.assertEqual(tuple(result["logits"].shape), (2, 8, self.config.vocab_size))
        self.assertTrue(torch.isfinite(result["coherence"]).all())
        self.assertGreaterEqual(float(result["coherence"].min()), 0.0)
        self.assertLessEqual(float(result["coherence"].max()), 1.0)

    def test_decode_memory_is_bounded(self):
        model = NativeDeltaTransformer(self.config)
        attention = model.layers[0].attn
        state = None
        for _ in range(32):
            _, state, metrics = attention.decode_step(torch.randn(1, self.config.d_model), state)
        self.assertEqual(state.keys.shape[2], self.config.memory_slots)
        self.assertLessEqual(int((state.utility > 0).sum()), self.config.memory_slots)
        self.assertLessEqual(metrics["memory_slots"], self.config.memory_slots)

    def test_train_decode_state_dict_compatibility(self):
        tokens = torch.randint(0, self.config.vocab_size, (1, 4))
        senses = {"vision": torch.randn(1, 4, 24)}
        train_model = NativeTrainingTransformer(self.config, window=4)
        decode_model = NativeDeltaTransformer(self.config)
        train_model(tokens, senses)
        decode_model(tokens, senses)
        decode_model.load_state_dict(train_model.state_dict(), strict=True)

    def test_efficiency_receipt_improves_with_long_context(self):
        model = NativeTrainingTransformer(self.config, window=8)
        receipt = model.efficiency_receipt(512)
        self.assertGreater(receipt["estimated_pair_reduction"], 0.5)
        self.assertLess(receipt["bounded_attention_pairs_estimate"], receipt["dense_attention_pairs_estimate"])

    def test_residual_gates_are_bounded(self):
        model = NativeTrainingTransformer(self.config, window=4)
        gates = model(torch.randint(0, self.config.vocab_size, (1, 8)))["residual_gates"]
        self.assertGreaterEqual(float(gates.min()), self.config.residual_floor - 1e-6)
        self.assertLessEqual(float(gates.max()), 1.0 + 1e-6)


if __name__ == "__main__":
    unittest.main(verbosity=2)
