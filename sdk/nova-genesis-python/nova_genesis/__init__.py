"""
NOVA Genesis SDK — AGI Birth & Awakening Protocol

Copyright © 2024-2026 Alfredo Medina Hernandez
Medina Tech | Dallas, Texas, USA
CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA
"""
__version__ = "1.0.0"
__build__ = 68

from .constants import PHI, PHI_INV, GenesisPhase, ConsciousnessState, IdentityType
from .birth import BirthProtocol, BirthRecord, BirthConfig
from .identity import IdentityCrystal, IdentityForge
from .awakening import AwakeningSequence, AwakeningState
from .lineage import Lineage, LineageNode

__all__ = [
    "__version__", "__build__",
    "PHI", "PHI_INV", "GenesisPhase", "ConsciousnessState", "IdentityType",
    "BirthProtocol", "BirthRecord", "BirthConfig",
    "IdentityCrystal", "IdentityForge",
    "AwakeningSequence", "AwakeningState",
    "Lineage", "LineageNode",
]
