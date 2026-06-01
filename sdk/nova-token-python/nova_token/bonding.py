"""NOVA Token — Bonding Curves"""
import math
from dataclasses import dataclass, field
from typing import List
from .constants import *


@dataclass
class PricePoint:
    supply: float
    price: float
    curve_type: CurveType


class BondingCurve:
    """φ-bonding curve for token pricing."""

    def __init__(self, curve_type: CurveType = CurveType.PHI_BONDING,
                 base_price: float = 1.0, slope: float = PHI_INV):
        self.curve_type = curve_type
        self.base_price = base_price
        self.slope = slope

    def price_at(self, supply: float) -> float:
        """Calculate token price at given supply."""
        if self.curve_type == CurveType.LINEAR:
            return self.base_price + self.slope * supply
        elif self.curve_type == CurveType.EXPONENTIAL:
            return self.base_price * math.exp(self.slope * supply / 1000)
        elif self.curve_type == CurveType.PHI_BONDING:
            return self.base_price * (PHI ** (supply / 1000))
        else:  # SIGMOID
            return self.base_price * (2.0 / (1.0 + math.exp(-self.slope * supply / 1000)))

    def cost_to_buy(self, current_supply: float, amount: float, steps: int = 100) -> float:
        """Calculate cost to buy `amount` tokens (integral of curve)."""
        step_size = amount / steps
        total_cost = 0.0
        for i in range(steps):
            s = current_supply + i * step_size
            total_cost += self.price_at(s) * step_size
        return total_cost

    def price_points(self, max_supply: float, steps: int = 20) -> List[PricePoint]:
        """Generate price points for visualization."""
        points = []
        for i in range(steps + 1):
            supply = max_supply * i / steps
            points.append(PricePoint(supply=supply, price=self.price_at(supply),
                                    curve_type=self.curve_type))
        return points
