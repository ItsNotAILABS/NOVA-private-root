"""NOVA Vein — Pressure Regulation"""
import time
from dataclasses import dataclass, field
from typing import Dict, List
from .constants import *
from .vein import Vein, VeinNetwork


@dataclass
class PressureReading:
    vein_id: str
    pressure: float
    level: PressureLevel
    timestamp_ms: float = field(default_factory=lambda: time.time() * 1000)


class PressureRegulator:
    """Monitors and regulates flow pressure across veins."""

    def __init__(self, network: VeinNetwork):
        self._network = network
        self._readings: List[PressureReading] = []

    def measure_all(self) -> List[PressureReading]:
        readings = []
        for vein in self._network._veins.values():
            pressure = vein.utilization
            level = self._classify(pressure)
            reading = PressureReading(vein_id=vein.vein_id, pressure=pressure, level=level)
            readings.append(reading)
        self._readings.extend(readings)
        return readings

    def _classify(self, utilization: float) -> PressureLevel:
        if utilization > 0.9:
            return PressureLevel.CRITICAL
        elif utilization > PHI_INV:
            return PressureLevel.HIGH
        elif utilization > PHI_INV ** 2:
            return PressureLevel.NORMAL
        else:
            return PressureLevel.LOW

    def relieve(self, vein_id: str) -> bool:
        """Relieve pressure on a congested vein."""
        vein = self._network._veins.get(vein_id)
        if vein:
            vein.current_load *= PHI_INV
            vein.state = FlowState.FLOWING if vein.utilization < 0.9 else FlowState.CONGESTED
            return True
        return False
