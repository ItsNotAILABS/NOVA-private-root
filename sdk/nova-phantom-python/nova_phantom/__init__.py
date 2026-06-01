"""
NOVA Phantom SDK — Phantom Transfer & Encryption

Copyright © 2024-2026 Alfredo Medina Hernandez
Medina Tech | Dallas, Texas, USA
CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA
"""
__version__ = "1.0.0"
__build__ = 68

from .constants import PHI, PHI_INV, EnvelopeState, KeyType, TransferState
from .envelope import PhantomEnvelope, EnvelopeEngine
from .stealth import StealthAddress, StealthGenerator
from .transfer import PhantomTransfer, TransferEngine
from .keys import KeyPair, KeyManager

__all__ = [
    "__version__", "__build__",
    "PHI", "PHI_INV", "EnvelopeState", "KeyType", "TransferState",
    "PhantomEnvelope", "EnvelopeEngine",
    "StealthAddress", "StealthGenerator",
    "PhantomTransfer", "TransferEngine",
    "KeyPair", "KeyManager",
]
