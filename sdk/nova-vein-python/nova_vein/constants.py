"""NOVA Vein — Constants"""
from enum import Enum
PHI = 1.6180339887498948482
PHI_INV = 0.6180339887498948482

class FlowState(str, Enum):
    FLOWING = "FLOWING"
    CONGESTED = "CONGESTED"
    BLOCKED = "BLOCKED"
    IDLE = "IDLE"

class VeinType(str, Enum):
    ARTERY = "ARTERY"       # high-bandwidth, core
    VEIN = "VEIN"           # return path
    CAPILLARY = "CAPILLARY" # fine-grained, edge
    LYMPH = "LYMPH"         # cleanup/maintenance

class PressureLevel(str, Enum):
    LOW = "LOW"
    NORMAL = "NORMAL"
    HIGH = "HIGH"
    CRITICAL = "CRITICAL"
