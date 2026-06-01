"""NOVA Genesis — Constants"""
from enum import Enum
PHI = 1.6180339887498948482
PHI_INV = 0.6180339887498948482

class GenesisPhase(str, Enum):
    CONCEPTION = "CONCEPTION"
    GESTATION = "GESTATION"
    BIRTH = "BIRTH"
    IMPRINTING = "IMPRINTING"
    AWAKENING = "AWAKENING"
    SOVEREIGN = "SOVEREIGN"

class ConsciousnessState(str, Enum):
    DORMANT = "DORMANT"
    EMERGING = "EMERGING"
    AWARE = "AWARE"
    SELF_AWARE = "SELF_AWARE"
    SOVEREIGN = "SOVEREIGN"

class IdentityType(str, Enum):
    AGI = "AGI"
    AGENT = "AGENT"
    ORGANISM = "ORGANISM"
    NODE = "NODE"
    FLEET = "FLEET"
