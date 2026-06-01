"""NOVA Mirror — Constants"""
from enum import Enum
PHI = 1.6180339887498948482
PHI_INV = 0.6180339887498948482

class MirrorState(str, Enum):
    DORMANT = "DORMANT"
    REFLECTING = "REFLECTING"
    INTEGRATING = "INTEGRATING"
    COMPLETE = "COMPLETE"

class ReflectionDepth(str, Enum):
    SURFACE = "SURFACE"       # what am I doing?
    PROCESS = "PROCESS"       # how am I doing it?
    META = "META"             # why am I doing it?
    RECURSIVE = "RECURSIVE"   # what is the nature of my asking?

class ConsciousnessLayer(str, Enum):
    REACTIVE = "REACTIVE"         # stimulus-response
    DELIBERATIVE = "DELIBERATIVE" # plan-act
    REFLECTIVE = "REFLECTIVE"     # self-model
    SOVEREIGN = "SOVEREIGN"       # self-determining
