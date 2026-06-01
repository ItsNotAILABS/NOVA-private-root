"""NOVA Synapse — Constants"""
from enum import Enum
PHI = 1.6180339887498948482
PHI_INV = 0.6180339887498948482

class SynapseType(str, Enum):
    EXCITATORY = "EXCITATORY"
    INHIBITORY = "INHIBITORY"
    MODULATORY = "MODULATORY"

class SignalType(str, Enum):
    SPIKE = "SPIKE"
    GRADED = "GRADED"
    BURST = "BURST"
    TONIC = "TONIC"

class PlasticityMode(str, Enum):
    HEBBIAN = "HEBBIAN"       # fire together wire together
    ANTI_HEBBIAN = "ANTI_HEBBIAN"
    STDP = "STDP"             # spike-timing dependent
    HOMEOSTATIC = "HOMEOSTATIC"
