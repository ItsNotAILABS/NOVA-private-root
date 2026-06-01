"""NOVA Solver — φ-Optimizer"""
import math
import time
from dataclasses import dataclass, field
from typing import Callable, List, Optional, Tuple
from .constants import *


@dataclass
class OptimResult:
    x: List[float]
    value: float
    iterations: int
    converged: bool
    state: SolverState
    duration_ms: float


class PhiOptimizer:
    """Golden-section-based optimizer for 1D and multi-D problems."""

    def __init__(self, max_iter: int = 1000, tol: float = 1e-8):
        self.max_iter = max_iter
        self.tol = tol

    def golden_section(self, f: Callable, a: float, b: float) -> OptimResult:
        """1D golden section search for minimum."""
        start = time.time() * 1000
        gr = PHI_INV
        c = b - gr * (b - a)
        d = a + gr * (b - a)
        
        for i in range(self.max_iter):
            if abs(b - a) < self.tol:
                break
            if f(c) < f(d):
                b = d
            else:
                a = c
            c = b - gr * (b - a)
            d = a + gr * (b - a)

        x_min = (a + b) / 2
        converged = abs(b - a) < self.tol
        return OptimResult(
            x=[x_min], value=f(x_min), iterations=i + 1,
            converged=converged,
            state=SolverState.CONVERGED if converged else SolverState.TIMEOUT,
            duration_ms=time.time() * 1000 - start,
        )

    def minimize(self, f: Callable, x0: List[float], bounds: List[Tuple[float, float]] = None) -> OptimResult:
        """Multi-dimensional Nelder-Mead minimization."""
        start = time.time() * 1000
        n = len(x0)
        # Simple coordinate descent with φ step
        x = list(x0)
        step = [1.0] * n
        best_val = f(x)

        for iteration in range(self.max_iter):
            improved = False
            for i in range(n):
                for sign in [1, -1]:
                    x_new = list(x)
                    x_new[i] += sign * step[i]
                    if bounds:
                        x_new[i] = max(bounds[i][0], min(bounds[i][1], x_new[i]))
                    val = f(x_new)
                    if val < best_val:
                        x = x_new
                        best_val = val
                        improved = True
            if not improved:
                step = [s * PHI_INV for s in step]
                if max(step) < self.tol:
                    break

        converged = max(step) < self.tol
        return OptimResult(
            x=x, value=best_val, iterations=iteration + 1,
            converged=converged,
            state=SolverState.CONVERGED if converged else SolverState.TIMEOUT,
            duration_ms=time.time() * 1000 - start,
        )
