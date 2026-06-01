"""
NOVA Synapse SDK — Neural Connections & Signal Propagation

Copyright © 2024-2026 Alfredo Medina Hernandez
Medina Tech | Dallas, Texas, USA
CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA
"""
__version__ = "1.0.0"
__build__ = 68

from .constants import PHI, PHI_INV, SynapseType, SignalType, PlasticityMode
from .synapse import Synapse, SynapseNetwork
from .signal import Signal, SignalPropagator
from .hebbian import HebbianLearner, LearningEvent
from .topology import NetworkTopology, TopologyStats

__all__ = [
    "__version__", "__build__",
    "PHI", "PHI_INV", "SynapseType", "SignalType", "PlasticityMode",
    "Synapse", "SynapseNetwork",
    "Signal", "SignalPropagator",
    "HebbianLearner", "LearningEvent",
    "NetworkTopology", "TopologyStats",
]
