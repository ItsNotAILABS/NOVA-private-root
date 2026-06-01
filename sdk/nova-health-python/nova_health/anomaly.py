"""NOVA Health — Anomaly Detection"""
import time
import math
from dataclasses import dataclass, field
from typing import Dict, List
from typing import Optional
from .constants import *


@dataclass
class Anomaly:
    anomaly_id: str
    metric: str
    value: float
    expected: float
    deviation: float
    severity: Severity
    timestamp_ms: float = field(default_factory=lambda: time.time() * 1000)


class AnomalyDetector:
    """Statistical anomaly detection using φ-based thresholds."""

    def __init__(self, window_size: int = 50):
        self.window_size = window_size
        self._series: Dict[str, List[float]] = {}
        self._anomalies: List[Anomaly] = []
        self._counter = 0

    def record(self, metric: str, value: float) -> Optional[Anomaly]:
        series = self._series.setdefault(metric, [])

        if len(series) >= 5:
            # Compute stats BEFORE adding the new value
            mean = sum(series) / len(series)
            variance = sum((x - mean)**2 for x in series) / len(series)
            std = math.sqrt(variance) if variance > 0 else 0.001
            deviation = abs(value - mean) / std
        else:
            deviation = 0.0

        series.append(value)
        if len(series) > self.window_size:
            self._series[metric] = series[-self.window_size:]

        if deviation > PHI * 2:  # >3.2σ
            self._counter += 1
            severity = Severity.HIGH if deviation > PHI * 3 else Severity.MEDIUM
            anomaly = Anomaly(
                anomaly_id=f"ANO-{self._counter:06d}",
                metric=metric, value=value, expected=mean,
                deviation=deviation, severity=severity,
            )
            self._anomalies.append(anomaly)
            return anomaly
        return None

    @property
    def anomaly_count(self) -> int:
        return len(self._anomalies)

    @property
    def recent_anomalies(self) -> List[Anomaly]:
        return self._anomalies[-10:]
