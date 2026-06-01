"""
NOVA Network SDK — Constants & Types

Copyright © 2024-2026 Alfredo Medina Hernandez
Medina Tech | Dallas, Texas, USA
CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA

φ-weighted sovereign network constants derived from PROTOCOL-NETWORK.
"""

import math
from enum import Enum

# ═══ Golden Ratio Constants ════════════════════════════════════════════════════

PHI = 1.6180339887498948482
PHI_INV = 0.6180339887498948482
AMOR = 0.3819660112501051518
PHI_SQUARED = PHI * PHI
PHI_CUBED = PHI_SQUARED * PHI
PHI_FOURTH = PHI_CUBED * PHI

# ═══ Timing ════════════════════════════════════════════════════════════════════

SCHUMANN_FREQUENCY = 7.83  # Hz
SCHUMANN_PERIOD_MS = 1000.0 / SCHUMANN_FREQUENCY  # ≈127.7ms
HEARTBEAT_MS = 873  # φ⁴ × Schumann period (canonical value)

# ═══ DHT Parameters ═══════════════════════════════════════════════════════════

DHT_SHARDS = 16
ROUTING_TABLE_SIZE = math.floor(PHI * math.log2(1024))  # 16 entries for N=1024
GOSSIP_FAN_OUT = 3
RELAY_TTL_MS = 3600000 * PHI  # ~5.8 hours max relay persistence
LYAPUNOV_ALPHA = 0.1
MAX_HOPS = 8  # Fibonacci: 8

# Fibonacci gossip intervals (ms)
GOSSIP_SCHEDULE_MS = [1000, 2000, 3000, 5000, 8000, 13000, 21000, 34000]


# ═══ Enumerations ═════════════════════════════════════════════════════════════

class NodeType(str, Enum):
    """Node types in the NOVA sovereign mesh."""
    SOVEREIGN = "SOVEREIGN"   # full node: routes, stores, relays
    RELAY = "RELAY"           # relay only: store-and-forward
    EDGE = "EDGE"             # edge node: connects but doesn't relay
    PHANTOM = "PHANTOM"       # phantom node: fully hidden, receive-only


class MessageType(str, Enum):
    """Sovereign message types."""
    DATA = "DATA"
    GOSSIP = "GOSSIP"
    RELAY = "RELAY"
    SYNC = "SYNC"
    HEARTBEAT = "HEARTBEAT"
    REVOKE = "REVOKE"


class NodeState(str, Enum):
    """Consensus node states (Raft-like)."""
    FOLLOWER = "FOLLOWER"
    CANDIDATE = "CANDIDATE"
    LEADER = "LEADER"
    OBSERVER = "OBSERVER"


class ProposalState(str, Enum):
    """Consensus proposal states."""
    PENDING = "PENDING"
    ACCEPTED = "ACCEPTED"
    COMMITTED = "COMMITTED"
    REJECTED = "REJECTED"
    EXPIRED = "EXPIRED"


class VoteType(str, Enum):
    """Consensus vote types."""
    FOR = "FOR"
    AGAINST = "AGAINST"
    ABSTAIN = "ABSTAIN"


class BeatType(str, Enum):
    """Heartbeat pulse types."""
    SYSTOLE = "SYSTOLE"      # Contraction (primary beat)
    DIASTOLE = "DIASTOLE"    # Relaxation (secondary beat)
    SYNC = "SYNC"            # Synchronization pulse


class RhythmState(str, Enum):
    """Heartbeat rhythm states."""
    NORMAL = "NORMAL"
    TACHYCARDIA = "TACHYCARDIA"
    BRADYCARDIA = "BRADYCARDIA"
    ARRHYTHMIA = "ARRHYTHMIA"
    ASYSTOLE = "ASYSTOLE"


class PeerState(str, Enum):
    """Peer connection states."""
    UNKNOWN = "UNKNOWN"
    DISCOVERING = "DISCOVERING"
    CONNECTED = "CONNECTED"
    DISCONNECTED = "DISCONNECTED"
    UNREACHABLE = "UNREACHABLE"
