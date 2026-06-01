"""
NOVA Mirror SDK — Self-Reflection & Consciousness Protocol

Copyright © 2024-2026 Alfredo Medina Hernandez
Medina Tech | Dallas, Texas, USA
CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA
"""
__version__ = "1.0.0"
__build__ = 68

from .constants import PHI, PHI_INV, MirrorState, ReflectionDepth, ConsciousnessLayer
from .reflection import ReflectionEngine, Reflection, ReflectionReport
from .consciousness import ConsciousnessMonitor, ConsciousnessState
from .introspection import IntrospectionEngine, Insight
from .oscillator import PhiOscillator, OscillatorArray

__all__ = [
    "__version__", "__build__",
    "PHI", "PHI_INV", "MirrorState", "ReflectionDepth", "ConsciousnessLayer",
    "ReflectionEngine", "Reflection", "ReflectionReport",
    "ConsciousnessMonitor", "ConsciousnessState",
    "IntrospectionEngine", "Insight",
    "PhiOscillator", "OscillatorArray",
]
