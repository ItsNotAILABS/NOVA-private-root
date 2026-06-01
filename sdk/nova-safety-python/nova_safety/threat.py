"""NOVA Safety — Threat Detection"""

import time
import hashlib
from dataclasses import dataclass, field
from typing import Any, Dict, List, Optional
from .constants import *


@dataclass
class Threat:
    """A detected threat."""
    threat_id: str
    threat_class: ThreatClass
    source: str
    description: str
    confidence: float  # 0..1
    timestamp_ms: float = 0.0
    mitigated: bool = False


@dataclass
class ThreatResponse:
    """Response action for a threat."""
    threat_id: str
    action: str
    success: bool
    details: str = ""


class ThreatDetector:
    """
    Detects and classifies threats using φ-weighted scoring.
    Maintains threat history and response log.
    """

    def __init__(self):
        self._threats: List[Threat] = []
        self._responses: List[ThreatResponse] = []
        self._patterns: List[Dict[str, Any]] = []

    def add_pattern(self, name: str, detector_fn, threat_class: ThreatClass = ThreatClass.MEDIUM) -> None:
        """Register a threat detection pattern."""
        self._patterns.append({"name": name, "detect": detector_fn, "class": threat_class})

    def scan(self, context: Dict[str, Any]) -> List[Threat]:
        """Scan context for threats."""
        found = []
        for pattern in self._patterns:
            try:
                confidence = pattern["detect"](context)
                if confidence and confidence > 0:
                    tid = hashlib.sha256(f"{pattern['name']}{time.time()}".encode()).hexdigest()[:16]
                    threat = Threat(
                        threat_id=tid,
                        threat_class=pattern["class"],
                        source=pattern["name"],
                        description=f"Detected by pattern: {pattern['name']}",
                        confidence=min(1.0, float(confidence)),
                        timestamp_ms=time.time() * 1000,
                    )
                    found.append(threat)
                    self._threats.append(threat)
            except Exception:
                pass
        return found

    def mitigate(self, threat_id: str, action: str) -> ThreatResponse:
        """Record mitigation of a threat."""
        for t in self._threats:
            if t.threat_id == threat_id:
                t.mitigated = True
                break
        response = ThreatResponse(threat_id=threat_id, action=action, success=True)
        self._responses.append(response)
        return response

    @property
    def active_threats(self) -> List[Threat]:
        return [t for t in self._threats if not t.mitigated]

    @property
    def threat_level(self) -> ThreatClass:
        active = self.active_threats
        if not active:
            return ThreatClass.NONE
        return max(active, key=lambda t: list(ThreatClass).index(t.threat_class)).threat_class
