"""
NOVA Swarm SDK — Swarm Intelligence & Collective Coordination

Copyright © 2024-2026 Alfredo Medina Hernandez
Medina Tech | Dallas, Texas, USA
CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA
"""
__version__ = "1.0.0"
__build__ = 68

from .constants import PHI, PHI_INV, SwarmRole, SwarmState, FormationType
from .agent import SwarmAgent, SwarmAgentPool
from .coordinator import SwarmCoordinator, CoordinationResult
from .kuramoto import KuramotoSync, OscillatorState
from .formation import FormationEngine, Formation

__all__ = [
    "__version__", "__build__",
    "PHI", "PHI_INV", "SwarmRole", "SwarmState", "FormationType",
    "SwarmAgent", "SwarmAgentPool",
    "SwarmCoordinator", "CoordinationResult",
    "KuramotoSync", "OscillatorState",
    "FormationEngine", "Formation",
]
