"""
NOVA Sovereignty SDK — Sovereignty Validation Authority

Copyright © 2024-2026 Alfredo Medina Hernandez
Medina Tech | Dallas, Texas, USA
CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA
"""
__version__ = "1.0.0"
__build__ = 68

from .constants import PHI, PHI_INV, ClaimType, ClaimState, CertState, EvidenceGrade
from .claims import Claim, ClaimRegistry, ClaimVerdict
from .validator import SovereigntyValidator, ValidationResult
from .certificate import Certificate, CertificateAuthority
from .evidence import Evidence, EvidenceMatrix

__all__ = [
    "__version__", "__build__",
    "PHI", "PHI_INV", "ClaimType", "ClaimState", "CertState", "EvidenceGrade",
    "Claim", "ClaimRegistry", "ClaimVerdict",
    "SovereigntyValidator", "ValidationResult",
    "Certificate", "CertificateAuthority",
    "Evidence", "EvidenceMatrix",
]
