"""NOVA Sovereignty — Certificates"""
import time
import hashlib
from dataclasses import dataclass, field
from typing import Dict, List, Optional
from .constants import *


@dataclass
class Certificate:
    cert_id: str
    subject: str
    issuer: str = "SVA"
    state: CertState = CertState.ACTIVE
    phi_score: float = 0.0
    issued_ms: float = field(default_factory=lambda: time.time() * 1000)
    expires_ms: float = 0.0
    claims: List[str] = field(default_factory=list)


class CertificateAuthority:
    """Sovereign Validation Authority certificate management."""

    def __init__(self, authority_id: str = "SVA-PRIMARY"):
        self.authority_id = authority_id
        self._certs: Dict[str, Certificate] = {}

    def issue(self, subject: str, phi_score: float, claims: List[str] = None,
              ttl_hours: float = 8760) -> Optional[Certificate]:
        if phi_score < CERT_THRESHOLD:
            return None
        cid = hashlib.sha256(f"{subject}{time.time()}".encode()).hexdigest()[:16]
        now = time.time() * 1000
        cert = Certificate(
            cert_id=cid, subject=subject, issuer=self.authority_id,
            phi_score=phi_score, expires_ms=now + ttl_hours * 3600000,
            claims=claims or [],
        )
        self._certs[cid] = cert
        return cert

    def revoke(self, cert_id: str) -> bool:
        if cert_id in self._certs:
            self._certs[cert_id].state = CertState.REVOKED
            return True
        return False

    def verify(self, cert_id: str) -> bool:
        cert = self._certs.get(cert_id)
        if not cert:
            return False
        if cert.state != CertState.ACTIVE:
            return False
        if cert.expires_ms > 0 and time.time() * 1000 > cert.expires_ms:
            cert.state = CertState.EXPIRED
            return False
        return True

    @property
    def active_count(self) -> int:
        return sum(1 for c in self._certs.values() if c.state == CertState.ACTIVE)
