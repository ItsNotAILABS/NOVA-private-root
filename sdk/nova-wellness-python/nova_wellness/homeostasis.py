"""NOVA Wellness — Homeostasis Controller"""
import time
from dataclasses import dataclass, field
from typing import Dict, List
from .constants import PHI, PHI_INV


@dataclass
class HomeostasisReading:
    metric: str
    value: float
    setpoint: float
    error: float
    correction: float
    timestamp_ms: float = field(default_factory=lambda: time.time() * 1000)


class HomeostasisController:
    """Maintains system homeostasis using φ-proportional control."""

    def __init__(self):
        self._setpoints: Dict[str, float] = {}
        self._readings: List[HomeostasisReading] = []
        self._integral: Dict[str, float] = {}

    def set_target(self, metric: str, setpoint: float) -> None:
        self._setpoints[metric] = setpoint
        self._integral[metric] = 0.0

    def regulate(self, metric: str, current_value: float) -> HomeostasisReading:
        """Compute correction to bring metric toward setpoint."""
        setpoint = self._setpoints.get(metric, current_value)
        error = setpoint - current_value
        self._integral[metric] = self._integral.get(metric, 0.0) + error * 0.01

        # PI control with φ-weighted gains
        kp = PHI_INV * 0.5  # proportional gain
        ki = PHI_INV * 0.1  # integral gain
        correction = kp * error + ki * self._integral[metric]

        reading = HomeostasisReading(
            metric=metric, value=current_value, setpoint=setpoint,
            error=error, correction=correction,
        )
        self._readings.append(reading)
        return reading

    @property
    def metrics(self) -> List[str]:
        return list(self._setpoints.keys())
