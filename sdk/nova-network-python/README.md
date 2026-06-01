# NOVA Network SDK — Python Internal SDK

**COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ**  
**CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA**

> *"Phantom it to our own solar networks. Start thinking about our network."*  
> — Alfredo Medina Hernandez, May 2026

## Overview

Pure-Python implementation of NOVA's sovereign peer-to-peer network. Zero external dependencies. Mirrors the architecture of `PROTOCOL-NETWORK.js` (BUILD №55).

## Architecture

```
NOVA Node  →  φ-DHT Discovery  →  Sovereign Mesh
           →  Phantom Encryption  →  Encrypted Routing
           →  Store-and-Forward Relay  (No-Drop Law compliant)
           →  Lyapunov Convergence Monitor  →  Anti-fragmentation Gossip
           →  Phantom Wallet Node Identity  →  Sovereign Address
```

## Key Properties

- **Zero central server** — every NOVA node is equal
- **φ-weighted routing** — messages take the most coherent path
- **Phantom encryption** — no plaintext leaves the sovereign layer
- **No-Drop Law** — messages persist until delivered (store-and-forward)
- **Lyapunov convergence** — network is provably stable (V̇ ≤ 0)
- **Fibonacci gossip intervals** — anti-fragmentation propagation

## Installation

```bash
# From the SDK directory:
pip install -e sdk/nova-network-python/

# Or directly:
pip install -e .
```

## Quick Start

```python
from nova_network import SovereignNovaNode, create_local_network, MessageType

# Create a 5-node local network
net = create_local_network(5)
nodes = net["nodes"]
deliver = net["deliver"]

# Send a message
nodes[0].send(
    to=nodes[2].node_id,
    payload={"hello": "sovereign world"},
    msg_type=MessageType.DATA,
)

# Deliver across the network
deliver()

# Check inbox
messages = nodes[2].inbox()
print(f"Node 2 received {len(messages)} messages")

# Check network status
status = nodes[0].network_status()
print(f"Lyapunov: {status['lyapunov']['label']}")
```

## Modules

| Module | Description |
|--------|-------------|
| `constants` | φ constants, DHT params, enumerations |
| `identity` | Sovereign node identity (wallet-derived) |
| `messages` | SovereignMessage format (TTL, hops, φ-nonce) |
| `dht` | φ-Distributed Hash Table (O(log N) routing) |
| `relay` | Store-and-Forward (No-Drop Law, Fibonacci retry) |
| `lyapunov` | Convergence monitor (V̇ ≤ 0 proof) |
| `gossip` | Fibonacci gossip engine (anti-fragmentation) |
| `encryption` | Phantom envelope encryption |
| `consensus` | Raft-like leader election + φ-weighted BFT |
| `heartbeat` | 873ms timing synchronization |
| `node` | Full SovereignNovaNode (integrates all above) |
| `bootstrap` | Network bootstrap & local simulation |

## Consensus

```python
from nova_network import ConsensusNode, VoteType

# Create consensus nodes
nodes = [ConsensusNode(f"node-{i}") for i in range(5)]

# Propose a value
proposal = nodes[0].propose("config/max_peers", 64)

# Other nodes vote
for node in nodes[1:4]:
    node._proposals[proposal.proposal_id] = proposal
    node.vote_on(proposal.proposal_id, VoteType.FOR, weight=0.618)

# Check resolution
decided = nodes[0].check_proposals(total_nodes=5)
print(f"Decided: {decided[0].state}")  # COMMITTED
```

## Heartbeat

```python
from nova_network import HeartbeatEngine

engine = HeartbeatEngine(node_id="my-node")
beat = engine.beat_once()
print(f"Beat #{beat.sequence}, drift={beat.drift}ms")
```

## Running Tests

```bash
cd sdk/nova-network-python
python -m pytest tests/ -v
```

## Dependencies

**None.** Pure Python 3.9+ standard library only.
