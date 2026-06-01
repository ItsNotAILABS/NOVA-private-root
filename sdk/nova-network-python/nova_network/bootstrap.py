"""
NOVA Network SDK — Bootstrap & Simulation Helpers

Copyright © 2024-2026 Alfredo Medina Hernandez
CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA

Helpers for bootstrapping nodes into the sovereign network
and creating local test networks.
"""

from typing import List, Dict, Callable, Optional

from .constants import PHI_INV, HEARTBEAT_MS, NodeType, MessageType
from .node import SovereignNovaNode
from .encryption import network_seal


def bootstrap_node(node: SovereignNovaNode, bootstrap_peer: dict) -> SovereignNovaNode:
    """
    Bootstrap a sovereign node from a known bootstrap node address.
    The bootstrap node shares its routing table → new node learns peers.

    Args:
        node: The new node to bootstrap
        bootstrap_peer: Known entry point {nodeId, shard, type, freq}

    Returns:
        The bootstrapped node
    """
    node.add_peer(bootstrap_peer)
    node.send(
        to=bootstrap_peer.get("nodeId", ""),
        msg_type=MessageType.HEARTBEAT,
        payload={"from": node.identity.to_dict(), "requestPeers": True},
        ttl_ms=30000,
        priority=PHI_INV,
    )
    return node


def create_local_network(n: int = 3) -> Dict:
    """
    Create a local sovereign network for testing / development.

    Args:
        n: Number of nodes (2–64)

    Returns:
        Dict with 'nodes' list and 'deliver' function
    """
    n = max(2, min(64, n))
    nodes: List[SovereignNovaNode] = []

    # Create nodes
    for _ in range(n):
        node = SovereignNovaNode(node_type=NodeType.SOVEREIGN, region="LOCAL")
        nodes.append(node)

    # Wire: each node knows all others (full mesh for local testing)
    for i, node_i in enumerate(nodes):
        for j, node_j in enumerate(nodes):
            if i != j:
                node_i.add_peer(node_j.identity)

    # Local transport: simulate delivery
    def deliver():
        """Deliver all outbox messages across the local network."""
        for sender in nodes:
            outbox = sender.flush_outbox()
            for item in outbox:
                target_id = item.get("nextHop") or item["msg"].to_node
                target = next((n for n in nodes if n.node_id == target_id), None)
                if target:
                    target.receive(item["envelope"])

    return {"nodes": nodes, "deliver": deliver}
