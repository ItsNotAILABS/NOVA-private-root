"""NOVA AI Bridge — Inference Router"""
import time
from dataclasses import dataclass, field
from typing import List, Optional
from .constants import *
from .model import ModelRegistry, ModelInfo


@dataclass
class RoutingDecision:
    model_id: str
    strategy: RoutingStrategy
    reason: str
    latency_ms: float = 0.0


class InferenceRouter:
    """Routes inference requests to optimal models."""

    def __init__(self, registry: ModelRegistry, strategy: RoutingStrategy = RoutingStrategy.PHI_WEIGHTED):
        self._registry = registry
        self.strategy = strategy
        self._rr_index = 0

    def route(self, model_type: ModelType = None, capability: str = None) -> Optional[RoutingDecision]:
        """Select best model for the request."""
        start = time.time() * 1000
        
        if capability:
            candidates = self._registry.find_by_capability(capability)
        elif model_type:
            candidates = self._registry.find_by_type(model_type)
        else:
            candidates = [m for m in self._registry._models.values() if m.active]

        if not candidates:
            return None

        if self.strategy == RoutingStrategy.ROUND_ROBIN:
            model = candidates[self._rr_index % len(candidates)]
            self._rr_index += 1
            reason = "round-robin"
        elif self.strategy == RoutingStrategy.LEAST_LOADED:
            model = min(candidates, key=lambda m: m.requests_served)
            reason = "least loaded"
        elif self.strategy == RoutingStrategy.PHI_WEIGHTED:
            model = max(candidates, key=lambda m: m.phi_score)
            reason = f"highest φ-score: {model.phi_score:.3f}"
        else:
            model = candidates[0]
            reason = "first available"

        model.requests_served += 1
        return RoutingDecision(
            model_id=model.model_id, strategy=self.strategy,
            reason=reason, latency_ms=time.time() * 1000 - start,
        )
