"""NOVA Solver — Simulated Annealing"""
import math
import time
import random
from dataclasses import dataclass
from typing import Callable, List
from .constants import *


@dataclass
class AnnealConfig:
    initial_temp: float = 100.0
    cooling_rate: float = PHI_INV * 0.01
    min_temp: float = 0.001
    max_iter: int = 10000


class SimulatedAnnealing:
    """Simulated annealing with φ-weighted cooling."""

    def __init__(self, config: AnnealConfig = None):
        self.config = config or AnnealConfig()

    def minimize(self, objective: Callable, x0: List[float],
                 neighbor_fn: Callable = None) -> 'OptimResult':
        from .optimizer import OptimResult
        start = time.time() * 1000
        
        x = list(x0)
        best_x = list(x)
        current_val = objective(x)
        best_val = current_val
        temp = self.config.initial_temp

        for i in range(self.config.max_iter):
            if temp < self.config.min_temp:
                break
            # Generate neighbor
            if neighbor_fn:
                x_new = neighbor_fn(x)
            else:
                x_new = [xi + random.gauss(0, temp * 0.1) for xi in x]
            
            new_val = objective(x_new)
            delta = new_val - current_val

            if delta < 0 or random.random() < math.exp(-delta / temp):
                x = x_new
                current_val = new_val
                if current_val < best_val:
                    best_x = list(x)
                    best_val = current_val

            temp *= (1.0 - self.config.cooling_rate)

        return OptimResult(
            x=best_x, value=best_val, iterations=i + 1,
            converged=temp < self.config.min_temp,
            state=SolverState.CONVERGED,
            duration_ms=time.time() * 1000 - start,
        )
