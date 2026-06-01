"""
NOVA Trust SDK — Reputation & Trust Protocol

Copyright © 2024-2026 Alfredo Medina Hernandez
Medina Tech | Dallas, Texas, USA
CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA
"""
__version__ = "1.0.0"
__build__ = 68

from .constants import PHI, PHI_INV, TrustLevel, AttestationType, DecayMode
from .score import TrustScore, TrustScorer
from .attestation import Attestation, AttestationRegistry
from .reputation import ReputationEngine, PeerReputation
from .decay import DecayEngine

__all__ = [
    "__version__", "__build__",
    "PHI", "PHI_INV", "TrustLevel", "AttestationType", "DecayMode",
    "TrustScore", "TrustScorer",
    "Attestation", "AttestationRegistry",
    "ReputationEngine", "PeerReputation",
    "DecayEngine",
]
