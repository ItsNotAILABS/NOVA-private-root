"""NOVA AI Bridge — Ensemble"""
from dataclasses import dataclass, field
from typing import Any, Callable, Dict, List
from .constants import PHI, PHI_INV


@dataclass
class EnsembleResult:
    outputs: List[Any]
    consensus: Any
    agreement_score: float
    model_count: int


class EnsembleEngine:
    """Multi-model ensemble with φ-weighted consensus."""

    def __init__(self):
        self._models: List[Dict[str, Any]] = []

    def add_model(self, model_id: str, inference_fn: Callable, weight: float = 1.0) -> None:
        self._models.append({"id": model_id, "fn": inference_fn, "weight": weight})

    def infer(self, prompt: str) -> EnsembleResult:
        """Run all models and compute consensus."""
        outputs = []
        for model in self._models:
            try:
                result = model["fn"](prompt)
                outputs.append({"id": model["id"], "output": result, "weight": model["weight"]})
            except Exception:
                outputs.append({"id": model["id"], "output": None, "weight": 0})

        # Simple consensus: majority or weighted best
        valid = [o for o in outputs if o["output"] is not None]
        if not valid:
            return EnsembleResult(outputs=[], consensus=None, agreement_score=0.0, model_count=0)

        # Take highest weighted output as consensus
        best = max(valid, key=lambda o: o["weight"])
        consensus = best["output"]

        # Agreement: how many agree with consensus
        agreement = sum(1 for o in valid if o["output"] == consensus) / len(valid)

        return EnsembleResult(
            outputs=[o["output"] for o in valid],
            consensus=consensus,
            agreement_score=agreement,
            model_count=len(valid),
        )

    @property
    def model_count(self) -> int:
        return len(self._models)
