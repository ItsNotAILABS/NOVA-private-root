"""
NOVA Network SDK — Phantom Encryption Layer

Copyright © 2024-2026 Alfredo Medina Hernandez
CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA

Seals messages with sovereign encryption before they enter the mesh.
Architecture: envelope encryption — a random symmetric key seals the
payload, and the key is sealed with the recipient's public key.

NOTE: This is a development implementation. Production deployment must
replace with X25519 ECDH key exchange + AES-256-GCM.
"""

import json
import time
from typing import Optional, Dict, Any

from .constants import PHI
from .identity import secure_id
from .messages import SovereignMessage


def network_seal(msg: SovereignMessage, recipient_public_key: Optional[str] = None) -> Dict[str, Any]:
    """
    Seal a SovereignMessage for network transmission.

    Uses envelope encryption: a random session key encrypts the payload,
    and the session key is sealed with the recipient's public key.

    Args:
        msg: The SovereignMessage to seal
        recipient_public_key: Recipient's public key (placeholder)

    Returns:
        Sealed network envelope dictionary

    Note:
        ⚠️ DEVELOPMENT PLACEHOLDER — NOT FOR PRODUCTION.
        Replace with proper AES-256-GCM + ECDH before deploying.
    """
    nonce = secure_id(12)
    session_key = secure_id(16)
    plaintext = json.dumps(msg.to_dict())

    # XOR cipher placeholder (replace with AES-256-GCM in production)
    ciphertext = "".join(
        format(ord(c) ^ ord(session_key[i % len(session_key)]), '02x')
        for i, c in enumerate(plaintext)
    )

    return {
        "envelopeId": f"NET-{secure_id(4).upper()[:8]}",
        "messageId": msg.message_id,
        "from": msg.from_node,
        "to": msg.to_node,
        "type": msg.msg_type.value,
        "nonce": nonce,
        "ciphertext": ciphertext,
        "sealedKey": session_key,  # placeholder — replace with RSA/ECDH encryption
        "phi": round(pow(PHI, msg.hop_count), 6),
        "protocol": "PROTOCOL-NETWORK",
        "sealedAt": time.time() * 1000,
    }


def network_unseal(envelope: Dict[str, Any]) -> Optional[Dict[str, Any]]:
    """
    Unseal a network envelope.

    Args:
        envelope: The sealed network envelope

    Returns:
        The original message dict, or None if unsealing fails
    """
    if not envelope or "ciphertext" not in envelope:
        return None

    key = envelope.get("sealedKey", "")
    ciphertext = envelope["ciphertext"]

    # Split into byte pairs
    byte_pairs = [ciphertext[i:i+2] for i in range(0, len(ciphertext), 2)]
    try:
        plaintext = "".join(
            chr(int(hex_byte, 16) ^ ord(key[i % len(key)]))
            for i, hex_byte in enumerate(byte_pairs)
        )
        return json.loads(plaintext)
    except (ValueError, json.JSONDecodeError):
        return None
