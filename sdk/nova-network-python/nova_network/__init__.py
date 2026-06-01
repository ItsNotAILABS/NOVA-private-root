"""
NOVA Network SDK — Python Internal SDK for Sovereign Network

Copyright © 2024-2026 Alfredo Medina Hernandez
Medina Tech | Dallas, Texas, USA
CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA

A pure-Python implementation of NOVA's sovereign peer-to-peer network.
No external dependencies. φ-weighted routing, Phantom encryption,
No-Drop Law relay, Lyapunov convergence, Fibonacci gossip.

Usage:
    from nova_network import SovereignNovaNode, create_local_network
    from nova_network import PhiDHT, RelayStore, LyapunovMonitor
    from nova_network import ConsensusNode, HeartbeatEngine
    from nova_network import PHI, PHI_INV, AMOR, HEARTBEAT_MS
"""

__version__ = "1.0.0"
__build__ = 68

# Constants
from .constants import (
    PHI, PHI_INV, AMOR,
    PHI_SQUARED, PHI_CUBED, PHI_FOURTH,
    SCHUMANN_FREQUENCY, SCHUMANN_PERIOD_MS, HEARTBEAT_MS,
    DHT_SHARDS, ROUTING_TABLE_SIZE, GOSSIP_FAN_OUT, MAX_HOPS,
    RELAY_TTL_MS, LYAPUNOV_ALPHA, GOSSIP_SCHEDULE_MS,
    NodeType, MessageType, NodeState, ProposalState,
    VoteType, BeatType, RhythmState, PeerState,
)

# Identity
from .identity import (
    SovereignNodeIdentity,
    create_node_identity,
    secure_id,
)

# Messages
from .messages import (
    SovereignMessage,
    create_message,
)

# DHT
from .dht import PhiDHT, DHTEntry

# Relay
from .relay import RelayStore

# Lyapunov
from .lyapunov import LyapunovMonitor, LyapunovState

# Gossip
from .gossip import GossipEngine

# Encryption
from .encryption import network_seal, network_unseal

# Consensus
from .consensus import ConsensusNode, Proposal, Vote

# Heartbeat
from .heartbeat import HeartbeatEngine, Beat

# Node (full participant)
from .node import SovereignNovaNode, NetworkStats

# Bootstrap
from .bootstrap import bootstrap_node, create_local_network

__all__ = [
    # Version
    "__version__", "__build__",
    # Constants
    "PHI", "PHI_INV", "AMOR",
    "PHI_SQUARED", "PHI_CUBED", "PHI_FOURTH",
    "SCHUMANN_FREQUENCY", "SCHUMANN_PERIOD_MS", "HEARTBEAT_MS",
    "DHT_SHARDS", "ROUTING_TABLE_SIZE", "GOSSIP_FAN_OUT", "MAX_HOPS",
    "RELAY_TTL_MS", "LYAPUNOV_ALPHA", "GOSSIP_SCHEDULE_MS",
    # Enums
    "NodeType", "MessageType", "NodeState", "ProposalState",
    "VoteType", "BeatType", "RhythmState", "PeerState",
    # Identity
    "SovereignNodeIdentity", "create_node_identity", "secure_id",
    # Messages
    "SovereignMessage", "create_message",
    # DHT
    "PhiDHT", "DHTEntry",
    # Relay
    "RelayStore",
    # Lyapunov
    "LyapunovMonitor", "LyapunovState",
    # Gossip
    "GossipEngine",
    # Encryption
    "network_seal", "network_unseal",
    # Consensus
    "ConsensusNode", "Proposal", "Vote",
    # Heartbeat
    "HeartbeatEngine", "Beat",
    # Node
    "SovereignNovaNode", "NetworkStats",
    # Bootstrap
    "bootstrap_node", "create_local_network",
]
