"""NOVA Wellness — Energy Management"""
import time
from dataclasses import dataclass, field
from typing import Dict
from .constants import PHI, PHI_INV


@dataclass
class EnergyPool:
    name: str
    capacity: float = 100.0
    current: float = 100.0
    regen_rate: float = PHI_INV  # per cycle

    @property
    def percentage(self) -> float:
        return self.current / self.capacity if self.capacity > 0 else 0.0

    @property
    def depleted(self) -> bool:
        return self.current <= 0.0


class EnergyManager:
    """Manages computational energy pools."""

    def __init__(self):
        self._pools: Dict[str, EnergyPool] = {}

    def create_pool(self, name: str, capacity: float = 100.0) -> EnergyPool:
        pool = EnergyPool(name=name, capacity=capacity, current=capacity)
        self._pools[name] = pool
        return pool

    def consume(self, pool_name: str, amount: float) -> bool:
        pool = self._pools.get(pool_name)
        if not pool or pool.current < amount:
            return False
        pool.current -= amount
        return True

    def regenerate(self) -> Dict[str, float]:
        """Regenerate all pools. Returns amount regenerated per pool."""
        regen = {}
        for name, pool in self._pools.items():
            amount = min(pool.regen_rate, pool.capacity - pool.current)
            pool.current += amount
            regen[name] = amount
        return regen

    def total_energy(self) -> float:
        return sum(p.current for p in self._pools.values())

    @property
    def pool_count(self) -> int:
        return len(self._pools)
