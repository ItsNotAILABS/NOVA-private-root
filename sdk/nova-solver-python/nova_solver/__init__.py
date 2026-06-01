"""
NOVA Solver SDK — Constraint & Optimization Solver

Copyright © 2024-2026 Alfredo Medina Hernandez
Medina Tech | Dallas, Texas, USA
CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA
"""
__version__ = "1.0.0"
__build__ = 68

from .constants import PHI, PHI_INV, SolverState, OptimMethod
from .optimizer import PhiOptimizer, OptimResult
from .constraint_solver import ConstraintSolver, ConstraintSet, Solution
from .gradient import PhiGradientDescent, GradientConfig
from .annealing import SimulatedAnnealing, AnnealConfig

__all__ = [
    "__version__", "__build__",
    "PHI", "PHI_INV", "SolverState", "OptimMethod",
    "PhiOptimizer", "OptimResult",
    "ConstraintSolver", "ConstraintSet", "Solution",
    "PhiGradientDescent", "GradientConfig",
    "SimulatedAnnealing", "AnnealConfig",
]
