"""
NOVA Vein SDK — Data Flow & Nutrient Transport

Copyright © 2024-2026 Alfredo Medina Hernandez
Medina Tech | Dallas, Texas, USA
CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA
"""
__version__ = "1.0.0"
__build__ = 68

from .constants import PHI, PHI_INV, FlowState, VeinType, PressureLevel
from .vein import Vein, VeinNetwork
from .flow import FlowEngine, FlowPacket, FlowStats
from .pressure import PressureRegulator, PressureReading
from .nutrient import NutrientTransport, Nutrient

__all__ = [
    "__version__", "__build__",
    "PHI", "PHI_INV", "FlowState", "VeinType", "PressureLevel",
    "Vein", "VeinNetwork",
    "FlowEngine", "FlowPacket", "FlowStats",
    "PressureRegulator", "PressureReading",
    "NutrientTransport", "Nutrient",
]
