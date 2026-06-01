"""NOVA Swarm — Constants"""
from enum import Enum
PHI = 1.6180339887498948482
PHI_INV = 0.6180339887498948482
GOLDEN_ANGLE = 137.5  # degrees

class SwarmRole(str, Enum):
    SCOUT = "SCOUT"
    WORKER = "WORKER"
    GUARD = "GUARD"
    QUEEN = "QUEEN"
    DRONE = "DRONE"

class SwarmState(str, Enum):
    FORMING = "FORMING"
    ACTIVE = "ACTIVE"
    DISPERSING = "DISPERSING"
    REFORMING = "REFORMING"
    DORMANT = "DORMANT"

class FormationType(str, Enum):
    GOLDEN_SPIRAL = "GOLDEN_SPIRAL"
    FIBONACCI_LATTICE = "FIBONACCI_LATTICE"
    PHI_CLUSTER = "PHI_CLUSTER"
    LINEAR = "LINEAR"
    RADIAL = "RADIAL"
