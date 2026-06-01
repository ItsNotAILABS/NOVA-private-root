"""NOVA AI Bridge — Model Registry"""
import time
from dataclasses import dataclass, field
from typing import Dict, List, Optional
from .constants import *


@dataclass
class ModelConfig:
    max_tokens: int = 4096
    temperature: float = PHI_INV
    top_p: float = 0.95
    timeout_ms: float = 30000


@dataclass
class ModelInfo:
    model_id: str
    name: str
    model_type: ModelType
    config: ModelConfig = field(default_factory=ModelConfig)
    capabilities: List[str] = field(default_factory=list)
    phi_score: float = PHI_INV  # quality/reliability score
    active: bool = True
    requests_served: int = 0


class ModelRegistry:
    """Registry of available AI models."""

    def __init__(self):
        self._models: Dict[str, ModelInfo] = {}

    def register(self, model_id: str, name: str, model_type: ModelType,
                 capabilities: List[str] = None, config: ModelConfig = None) -> ModelInfo:
        info = ModelInfo(
            model_id=model_id, name=name, model_type=model_type,
            capabilities=capabilities or [], config=config or ModelConfig(),
        )
        self._models[model_id] = info
        return info

    def unregister(self, model_id: str) -> bool:
        return self._models.pop(model_id, None) is not None

    def get(self, model_id: str) -> Optional[ModelInfo]:
        return self._models.get(model_id)

    def find_by_type(self, model_type: ModelType) -> List[ModelInfo]:
        return [m for m in self._models.values() if m.model_type == model_type and m.active]

    def find_by_capability(self, capability: str) -> List[ModelInfo]:
        return [m for m in self._models.values()
                if capability in m.capabilities and m.active]

    @property
    def total(self) -> int:
        return len(self._models)

    @property
    def active_count(self) -> int:
        return sum(1 for m in self._models.values() if m.active)
