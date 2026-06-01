"""NOVA AI Bridge — Gateway"""
import time
import hashlib
from dataclasses import dataclass, field
from typing import Any, Dict, List, Optional
from .constants import *


@dataclass
class InferenceRequest:
    request_id: str
    prompt: str
    model_type: ModelType = ModelType.LLM
    params: Dict[str, Any] = field(default_factory=dict)
    timestamp_ms: float = field(default_factory=lambda: time.time() * 1000)


@dataclass
class InferenceResponse:
    request_id: str
    output: Any
    model_id: str
    state: InferenceState
    tokens_used: int = 0
    latency_ms: float = 0.0


class AIGateway:
    """Central gateway for AI inference requests."""

    def __init__(self):
        self._requests: List[InferenceRequest] = []
        self._responses: List[InferenceResponse] = []
        self._counter = 0

    def request(self, prompt: str, model_type: ModelType = ModelType.LLM,
                params: Dict[str, Any] = None) -> InferenceRequest:
        self._counter += 1
        rid = hashlib.sha256(f"{prompt[:20]}{self._counter}".encode()).hexdigest()[:12]
        req = InferenceRequest(request_id=rid, prompt=prompt,
                              model_type=model_type, params=params or {})
        self._requests.append(req)
        return req

    def respond(self, request_id: str, output: Any, model_id: str,
                tokens: int = 0) -> InferenceResponse:
        resp = InferenceResponse(
            request_id=request_id, output=output, model_id=model_id,
            state=InferenceState.COMPLETED, tokens_used=tokens,
            latency_ms=time.time() * 1000 - self._requests[-1].timestamp_ms if self._requests else 0,
        )
        self._responses.append(resp)
        return resp

    @property
    def total_requests(self) -> int:
        return len(self._requests)

    @property
    def total_tokens(self) -> int:
        return sum(r.tokens_used for r in self._responses)
