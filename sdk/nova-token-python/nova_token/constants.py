"""NOVA Token — Constants"""
from enum import Enum
PHI = 1.6180339887498948482
PHI_INV = 0.6180339887498948482

class TokenState(str, Enum):
    ACTIVE = "ACTIVE"
    LOCKED = "LOCKED"
    BURNED = "BURNED"
    FROZEN = "FROZEN"

class StakeState(str, Enum):
    STAKED = "STAKED"
    UNSTAKING = "UNSTAKING"
    WITHDRAWN = "WITHDRAWN"
    SLASHED = "SLASHED"

class CurveType(str, Enum):
    LINEAR = "LINEAR"
    EXPONENTIAL = "EXPONENTIAL"
    PHI_BONDING = "PHI_BONDING"
    SIGMOID = "SIGMOID"
