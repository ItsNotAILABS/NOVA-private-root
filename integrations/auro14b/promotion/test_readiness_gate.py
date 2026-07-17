from __future__ import annotations

import importlib.util
from pathlib import Path
import unittest

MODULE_PATH = Path(__file__).with_name("readiness_gate.py")
spec = importlib.util.spec_from_file_location("readiness_gate", MODULE_PATH)
module = importlib.util.module_from_spec(spec)
assert spec.loader is not None
spec.loader.exec_module(module)


class ReadinessGateTests(unittest.TestCase):
    def complete(self, value: float) -> dict:
        return {"gates": {name: value for name in module.WEIGHTS}}

    def test_weights_sum_to_one(self) -> None:
        self.assertAlmostEqual(sum(module.WEIGHTS.values()), 1.0)

    def test_full_release_passes(self) -> None:
        result = module.score_readiness(self.complete(1.0))
        self.assertTrue(result["passed"])
        self.assertEqual(result["critical_failures"], [])
        self.assertEqual(result["weighted_readiness"], 1.0)

    def test_empty_release_fails(self) -> None:
        result = module.score_readiness({"gates": {}})
        self.assertFalse(result["passed"])
        self.assertEqual(result["weighted_readiness"], 0.0)

    def test_every_gate_is_bounded_and_preserved(self) -> None:
        for index, name in enumerate(module.WEIGHTS):
            for step in range(10):
                value = step / 10
                payload = self.complete(0.85)
                payload["gates"][name] = value
                result = module.score_readiness(payload)
                self.assertEqual(result["gates"][name], value, f"{index}:{name}:{step}")

    def test_each_critical_gate_blocks_below_threshold(self) -> None:
        for name in module.CRITICAL:
            payload = self.complete(1.0)
            payload["gates"][name] = 0.849
            result = module.score_readiness(payload)
            self.assertFalse(result["passed"])
            self.assertIn(name, result["critical_failures"])

    def test_unresolved_critical_blocker_blocks(self) -> None:
        payload = self.complete(1.0)
        payload["blockers"] = [{"severity": "critical", "resolved": False, "id": "noise-output"}]
        result = module.score_readiness(payload)
        self.assertFalse(result["passed"])
        self.assertEqual(result["critical_blockers"][0]["id"], "noise-output")

    def test_resolved_blocker_does_not_block(self) -> None:
        payload = self.complete(1.0)
        payload["blockers"] = [{"severity": "critical", "resolved": True}]
        self.assertTrue(module.score_readiness(payload)["passed"])

    def test_benchmark_accuracy_is_separate(self) -> None:
        self.assertTrue(module.score_readiness(self.complete(1.0))["benchmark_accuracy_is_separate"])

    def test_invalid_gate_values_raise(self) -> None:
        for bad in (-0.01, 1.01, 10):
            payload = self.complete(1.0)
            payload["gates"]["training"] = bad
            with self.assertRaises(ValueError):
                module.score_readiness(payload)


if __name__ == "__main__":
    unittest.main()
