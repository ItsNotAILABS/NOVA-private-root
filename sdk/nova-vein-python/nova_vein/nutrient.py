"""NOVA Vein — Nutrient Transport"""
import time
import hashlib
from dataclasses import dataclass, field
from typing import Dict, List
from .constants import PHI_INV


@dataclass
class Nutrient:
    nutrient_id: str
    nutrient_type: str
    amount: float
    source: str
    destination: str
    delivered: bool = False


class NutrientTransport:
    """Transports computational nutrients (data, energy, config) through veins."""

    def __init__(self):
        self._nutrients: Dict[str, Nutrient] = {}
        self._delivered_count = 0

    def create(self, nutrient_type: str, amount: float, source: str, destination: str) -> Nutrient:
        nid = hashlib.sha256(f"{nutrient_type}{time.time()}".encode()).hexdigest()[:12]
        n = Nutrient(nutrient_id=nid, nutrient_type=nutrient_type,
                    amount=amount, source=source, destination=destination)
        self._nutrients[nid] = n
        return n

    def deliver(self, nutrient_id: str) -> bool:
        n = self._nutrients.get(nutrient_id)
        if n and not n.delivered:
            n.delivered = True
            self._delivered_count += 1
            return True
        return False

    @property
    def pending(self) -> int:
        return sum(1 for n in self._nutrients.values() if not n.delivered)

    @property
    def delivered_count(self) -> int:
        return self._delivered_count
