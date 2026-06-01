"""NOVA Solver — φ-Gradient Descent"""
import time
from dataclasses import dataclass, field
from typing import Callable, List
from .constants import *


@dataclass
class GradientConfig:
    learning_rate: float = PHI_INV * 0.01  # φ⁻¹ learning rate
    max_iter: int = 1000
    tol: float = 1e-8
    momentum: float = PHI_INV


class PhiGradientDescent:
    """Gradient descent with φ⁻¹ learning rate scheduling."""

    def __init__(self, config: GradientConfig = None):
        self.config = config or GradientConfig()

    def minimize(self, gradient_fn: Callable, x0: List[float]) -> 'OptimResult':
        from .optimizer import OptimResult
        start = time.time() * 1000
        x = list(x0)
        velocity = [0.0] * len(x)
        lr = self.config.learning_rate

        for i in range(self.config.max_iter):
            grad = gradient_fn(x)
            max_grad = max(abs(g) for g in grad) if grad else 0
            if max_grad < self.config.tol:
                break
            for j in range(len(x)):
                velocity[j] = self.config.momentum * velocity[j] - lr * grad[j]
                x[j] += velocity[j]
            # φ-scheduled learning rate decay
            lr *= (1.0 - PHI_INV * 0.001)

        converged = max(abs(g) for g in gradient_fn(x)) < self.config.tol if gradient_fn(x) else True
        return OptimResult(
            x=x, value=0.0, iterations=i + 1,
            converged=converged,
            state=SolverState.CONVERGED if converged else SolverState.TIMEOUT,
            duration_ms=time.time() * 1000 - start,
        )
