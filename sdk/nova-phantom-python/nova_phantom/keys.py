"""NOVA Phantom — Key Management"""
import hashlib
import time
from dataclasses import dataclass, field
from typing import Dict, Optional
from .constants import *


@dataclass
class KeyPair:
    key_id: str
    key_type: KeyType
    public_key: str
    private_hash: str  # We don't store actual private keys in plaintext
    created_ms: float = field(default_factory=lambda: time.time() * 1000)
    revoked: bool = False


class KeyManager:
    """Manages cryptographic keys for phantom operations."""

    def __init__(self):
        self._keys: Dict[str, KeyPair] = {}

    def generate(self, key_type: KeyType = KeyType.EPHEMERAL) -> KeyPair:
        seed = f"{key_type.value}{time.time()}{len(self._keys)}"
        kid = hashlib.sha256(seed.encode()).hexdigest()[:12]
        pub = "PUB_" + hashlib.sha256(f"pub{seed}".encode()).hexdigest()[:32]
        priv_hash = hashlib.sha256(f"priv{seed}".encode()).hexdigest()[:32]
        kp = KeyPair(key_id=kid, key_type=key_type, public_key=pub, private_hash=priv_hash)
        self._keys[kid] = kp
        return kp

    def revoke(self, key_id: str) -> bool:
        if key_id in self._keys:
            self._keys[key_id].revoked = True
            return True
        return False

    def get_public(self, key_id: str) -> Optional[str]:
        kp = self._keys.get(key_id)
        if kp and not kp.revoked:
            return kp.public_key
        return None

    @property
    def active_count(self) -> int:
        return sum(1 for k in self._keys.values() if not k.revoked)
