"""
NOVA Network SDK — Test Suite

Tests all major network components:
  - Identity creation
  - Message creation and expiry
  - φ-DHT routing
  - Relay store (No-Drop Law)
  - Lyapunov convergence
  - Gossip engine
  - Phantom encryption (seal/unseal)
  - Consensus protocol
  - Heartbeat engine
  - Full node integration
  - Local network simulation
"""

import time
import sys
import os

# Add parent to path for direct execution
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from nova_network import (
    # Constants
    PHI, PHI_INV, AMOR, HEARTBEAT_MS, DHT_SHARDS,
    # Enums
    NodeType, MessageType, NodeState, ProposalState, VoteType, BeatType, RhythmState,
    # Identity
    create_node_identity, secure_id, SovereignNodeIdentity,
    # Messages
    create_message, SovereignMessage,
    # DHT
    PhiDHT,
    # Relay
    RelayStore,
    # Lyapunov
    LyapunovMonitor,
    # Gossip
    GossipEngine,
    # Encryption
    network_seal, network_unseal,
    # Consensus
    ConsensusNode, Proposal,
    # Heartbeat
    HeartbeatEngine, Beat,
    # Node
    SovereignNovaNode,
    # Bootstrap
    bootstrap_node, create_local_network,
)


# ═══════════════════════════════════════════════════════════════════════════════
# §1 — CONSTANTS TESTS
# ═══════════════════════════════════════════════════════════════════════════════

def test_phi_constants():
    """Verify φ constants are correct."""
    assert abs(PHI - 1.618033988) < 1e-6
    assert abs(PHI_INV - 0.618033988) < 1e-6
    assert abs(AMOR - 0.381966011) < 1e-6
    assert abs(PHI * PHI_INV - 1.0) < 1e-10
    assert abs(PHI - PHI_INV - 1.0) < 1e-10


def test_heartbeat_derivation():
    """Verify 873ms heartbeat from φ⁴ × Schumann."""
    assert HEARTBEAT_MS == 873


def test_dht_shards():
    """Verify DHT parameters."""
    assert DHT_SHARDS == 16


# ═══════════════════════════════════════════════════════════════════════════════
# §2 — IDENTITY TESTS
# ═══════════════════════════════════════════════════════════════════════════════

def test_create_node_identity():
    """Test sovereign node identity creation."""
    identity = create_node_identity()
    assert identity.node_id.startswith("NOVA-NODE-")
    assert identity.node_type == NodeType.SOVEREIGN
    assert 0 <= identity.shard < DHT_SHARDS
    assert identity.freq > 0
    assert identity.sovereignty == PHI_INV
    assert "ROUTE" in identity.capabilities


def test_node_identity_custom():
    """Test custom identity parameters."""
    identity = create_node_identity(
        node_type=NodeType.RELAY,
        region="US-EAST",
        capabilities=["RELAY", "STORE"],
    )
    assert identity.node_type == NodeType.RELAY
    assert identity.region == "US-EAST"
    assert identity.capabilities == ["RELAY", "STORE"]


def test_identity_to_dict():
    """Test identity serialization."""
    identity = create_node_identity()
    d = identity.to_dict()
    assert "nodeId" in d
    assert "type" in d
    assert "shard" in d


def test_secure_id():
    """Test secure ID generation."""
    id1 = secure_id(16)
    id2 = secure_id(16)
    assert len(id1) == 32  # 16 bytes = 32 hex chars
    assert id1 != id2  # Should be unique


# ═══════════════════════════════════════════════════════════════════════════════
# §3 — MESSAGE TESTS
# ═══════════════════════════════════════════════════════════════════════════════

def test_create_message():
    """Test message creation."""
    msg = create_message(
        from_node="NODE-A",
        to_node="NODE-B",
        msg_type=MessageType.DATA,
        payload={"key": "value"},
    )
    assert msg.message_id.startswith("MSG-")
    assert msg.from_node == "NODE-A"
    assert msg.to_node == "NODE-B"
    assert msg.msg_type == MessageType.DATA
    assert msg.hop_count == 0
    assert not msg.is_expired()


def test_message_hop():
    """Test message hop counting."""
    msg = create_message(max_hops=3)
    assert msg.hop()  # hop 1
    assert msg.hop()  # hop 2
    assert msg.hop()  # hop 3
    assert not msg.hop()  # exceeds max


def test_message_expiry():
    """Test message expiration."""
    msg = create_message(ttl_ms=1)  # 1ms TTL
    time.sleep(0.01)
    assert msg.is_expired()


def test_message_priority_clamping():
    """Test priority is clamped to [0, 1]."""
    msg = create_message(priority=5.0)
    assert msg.priority == 1.0
    msg2 = create_message(priority=-1.0)
    assert msg2.priority == 0.0


# ═══════════════════════════════════════════════════════════════════════════════
# §4 — φ-DHT TESTS
# ═══════════════════════════════════════════════════════════════════════════════

def test_phi_dht_add_remove():
    """Test DHT node addition and removal."""
    local = create_node_identity()
    dht = PhiDHT(local)
    assert dht.size == 0

    peer = {"nodeId": "PEER-001", "shard": 3, "type": "SOVEREIGN", "freq": 1.8, "region": "US", "capabilities": ["ROUTE"]}
    dht.add_node(peer)
    assert dht.size == 1

    dht.remove_node("PEER-001")
    assert dht.size == 0


def test_phi_dht_next_hop():
    """Test φ-jump routing."""
    local = create_node_identity()
    dht = PhiDHT(local)

    for i in range(10):
        dht.add_node({"nodeId": f"PEER-{i:03d}", "shard": i % DHT_SHARDS, "type": "SOVEREIGN", "freq": PHI, "region": "US", "capabilities": []})

    hop = dht.next_hop("TARGET-NODE")
    assert hop is not None
    assert hop.node_id.startswith("PEER-")


def test_phi_dht_k_closest():
    """Test k-closest node lookup."""
    local = create_node_identity()
    dht = PhiDHT(local)

    for i in range(20):
        dht.add_node({"nodeId": f"PEER-{i:03d}", "shard": i % DHT_SHARDS, "type": "SOVEREIGN", "freq": PHI, "region": "US", "capabilities": []})

    closest = dht.k_closest("TARGET", k=5)
    assert len(closest) == 5


def test_phi_dht_eviction():
    """Test φ-score based eviction when table is full."""
    local = create_node_identity()
    dht = PhiDHT(local)

    # Add more than capacity
    from nova_network.constants import ROUTING_TABLE_SIZE
    max_cap = ROUTING_TABLE_SIZE * 4
    for i in range(max_cap + 10):
        dht.add_node({"nodeId": f"PEER-{i:05d}", "shard": i % DHT_SHARDS, "type": "EDGE", "freq": PHI, "region": "US", "capabilities": []})

    assert dht.size <= max_cap


# ═══════════════════════════════════════════════════════════════════════════════
# §5 — RELAY STORE TESTS
# ═══════════════════════════════════════════════════════════════════════════════

def test_relay_store_basic():
    """Test store and retrieve."""
    relay = RelayStore(capacity=10)
    msg = create_message(from_node="A", to_node="B", ttl_ms=60000)
    assert relay.store(msg)
    assert relay.size == 1
    assert relay.no_drop_ok


def test_relay_store_capacity():
    """Test capacity limit."""
    relay = RelayStore(capacity=3)
    for i in range(5):
        msg = create_message(from_node="A", to_node=f"B-{i}", ttl_ms=60000)
        relay.store(msg)
    assert relay.size == 3  # capped at capacity


def test_relay_store_expired():
    """Test that expired messages are not stored."""
    relay = RelayStore()
    msg = create_message(ttl_ms=1)
    time.sleep(0.01)
    assert not relay.store(msg)


def test_relay_store_evict():
    """Test eviction of expired messages."""
    relay = RelayStore()
    msg = create_message(ttl_ms=1)
    # Force store before expiry
    relay._store[msg.message_id] = type('Entry', (), {'msg': msg, 'attempts': 0, 'next_retry': 0})()
    time.sleep(0.01)
    relay.evict()
    assert relay.size == 0


# ═══════════════════════════════════════════════════════════════════════════════
# §6 — LYAPUNOV MONITOR TESTS
# ═══════════════════════════════════════════════════════════════════════════════

def test_lyapunov_convergence():
    """Test that decreasing disagreement leads to convergence."""
    monitor = LyapunovMonitor()
    # Feed decreasing disagreement
    for d in [0.8, 0.6, 0.4, 0.3, 0.2, 0.1]:
        state = monitor.update(d)
    assert monitor.is_converged
    assert state.label == "CONVERGED — V̇ ≤ 0 (Lyapunov stable)"


def test_lyapunov_divergence():
    """Test that increasing disagreement is detected."""
    monitor = LyapunovMonitor()
    monitor.update(0.1)
    monitor.update(0.1)
    monitor.update(0.1)
    # Now increase
    state = monitor.update(0.9)
    assert not monitor.is_stable or state.dV > 0  # should detect divergence on jump


def test_lyapunov_bounds():
    """Test V stays in [0, 1]."""
    monitor = LyapunovMonitor()
    monitor.update(5.0)  # out of range
    assert 0.0 <= monitor.V <= 1.0
    monitor.update(-1.0)
    assert 0.0 <= monitor.V <= 1.0


# ═══════════════════════════════════════════════════════════════════════════════
# §7 — GOSSIP ENGINE TESTS
# ═══════════════════════════════════════════════════════════════════════════════

def test_gossip_round():
    """Test gossip round generation."""
    local = create_node_identity()
    dht = PhiDHT(local)
    for i in range(5):
        dht.add_node({"nodeId": f"PEER-{i}", "shard": i, "type": "SOVEREIGN", "freq": PHI, "region": "US", "capabilities": []})

    gossip = GossipEngine(dht, local)
    msgs = gossip.gossip_round()
    assert len(msgs) <= 3  # GOSSIP_FAN_OUT = 3
    assert all(m.msg_type == MessageType.GOSSIP for m in msgs)


def test_gossip_receive():
    """Test receiving gossip and learning new peers."""
    local = create_node_identity()
    dht = PhiDHT(local)
    gossip = GossipEngine(dht, local)

    msg = create_message(
        from_node="REMOTE-NODE",
        to_node=local.node_id,
        msg_type=MessageType.GOSSIP,
        payload={"peers": [
            {"nodeId": "NEW-PEER-1", "shard": 2, "type": "SOVEREIGN", "freq": PHI},
            {"nodeId": "NEW-PEER-2", "shard": 5, "type": "RELAY", "freq": PHI},
        ], "round": 1},
    )
    result = gossip.receive_gossip(msg)
    assert result["new_peers"] == 2
    assert dht.size == 2


# ═══════════════════════════════════════════════════════════════════════════════
# §8 — ENCRYPTION TESTS
# ═══════════════════════════════════════════════════════════════════════════════

def test_seal_unseal():
    """Test Phantom encryption round-trip."""
    msg = create_message(
        from_node="ALICE",
        to_node="BOB",
        payload={"secret": "sovereign data"},
    )
    envelope = network_seal(msg)
    assert "ciphertext" in envelope
    assert envelope["from"] == "ALICE"
    assert envelope["to"] == "BOB"

    # Unseal
    recovered = network_unseal(envelope)
    assert recovered is not None
    assert recovered["from"] == "ALICE"
    assert recovered["payload"]["secret"] == "sovereign data"


def test_unseal_invalid():
    """Test unsealing invalid envelopes."""
    assert network_unseal(None) is None
    assert network_unseal({}) is None
    assert network_unseal({"ciphertext": "invalid", "sealedKey": "k"}) is None


# ═══════════════════════════════════════════════════════════════════════════════
# §9 — CONSENSUS TESTS
# ═══════════════════════════════════════════════════════════════════════════════

def test_consensus_propose():
    """Test proposal creation."""
    node = ConsensusNode("node-0")
    proposal = node.propose("key", "value")
    assert proposal.state == ProposalState.PENDING
    assert proposal.proposer == "node-0"


def test_consensus_voting():
    """Test φ-weighted voting and commit."""
    node = ConsensusNode("node-0", quorum=0.5)
    proposal = node.propose("config", 42)

    # More votes
    proposal.vote("node-1", VoteType.FOR, PHI_INV)
    proposal.vote("node-2", VoteType.FOR, PHI_INV)

    decided = node.check_proposals(total_nodes=5)
    assert len(decided) == 1
    assert decided[0].state == ProposalState.COMMITTED
    assert node.get_committed("config") == 42


def test_consensus_rejection():
    """Test proposal rejection."""
    node = ConsensusNode("node-0", quorum=0.3)
    proposal = node.propose("key", "bad-value")

    # Majority AGAINST (need enough total votes to be "decided")
    proposal.vote("node-1", VoteType.AGAINST, 1.0)
    proposal.vote("node-2", VoteType.AGAINST, 1.0)
    proposal.vote("node-3", VoteType.AGAINST, 1.0)

    decided = node.check_proposals(total_nodes=5)
    assert len(decided) >= 1
    assert decided[0].state == ProposalState.REJECTED


def test_consensus_election():
    """Test leader election."""
    node = ConsensusNode("node-0")
    term = node.start_election()
    assert node.state == NodeState.CANDIDATE
    assert term == 1

    node.become_leader()
    assert node.state == NodeState.LEADER
    assert node.leader == "node-0"


def test_consensus_accept_leader():
    """Test accepting another leader."""
    node = ConsensusNode("node-1")
    node.accept_leader("node-0", term=3)
    assert node.state == NodeState.FOLLOWER
    assert node.leader == "node-0"
    assert node.term == 3


# ═══════════════════════════════════════════════════════════════════════════════
# §10 — HEARTBEAT TESTS
# ═══════════════════════════════════════════════════════════════════════════════

def test_heartbeat_beat_once():
    """Test single beat generation."""
    engine = HeartbeatEngine("test-node")
    beat = engine.beat_once()
    assert beat.sequence == 1
    assert beat.beat_type == BeatType.SYSTOLE
    assert beat.actual_time is not None


def test_heartbeat_alternating():
    """Test systole/diastole alternation."""
    engine = HeartbeatEngine("test-node")
    b1 = engine.beat_once()
    b2 = engine.beat_once()
    assert b1.beat_type == BeatType.SYSTOLE
    assert b2.beat_type == BeatType.DIASTOLE


def test_heartbeat_status():
    """Test heartbeat status reporting."""
    engine = HeartbeatEngine("test-node")
    engine.beat_once()
    status = engine.status()
    assert status["nodeId"] == "test-node"
    assert status["sequence"] == 1


# ═══════════════════════════════════════════════════════════════════════════════
# §11 — SOVEREIGN NODE TESTS
# ═══════════════════════════════════════════════════════════════════════════════

def test_sovereign_node_creation():
    """Test full node creation."""
    node = SovereignNovaNode()
    assert node.node_id.startswith("NOVA-NODE-")
    assert 0 <= node.shard < DHT_SHARDS


def test_sovereign_node_send_receive():
    """Test message send and receive between nodes."""
    node_a = SovereignNovaNode()
    node_b = SovereignNovaNode()

    # Wire peers
    node_a.add_peer(node_b.identity)
    node_b.add_peer(node_a.identity)

    # Send
    msg = node_a.send(to=node_b.node_id, payload={"hello": "world"})
    assert msg.from_node == node_a.node_id

    # Deliver
    outbox = node_a.flush_outbox()
    assert len(outbox) >= 1

    # Receive
    received = node_b.receive(outbox[0]["envelope"])
    assert received is not None
    assert received.payload["hello"] == "world"


def test_sovereign_node_broadcast():
    """Test broadcasting."""
    node = SovereignNovaNode()
    for i in range(5):
        peer = create_node_identity()
        node.add_peer(peer)

    msg = node.broadcast({"announcement": "test"})
    assert msg.to_node == "BROADCAST"
    outbox = node.flush_outbox()
    assert len(outbox) == 5


def test_sovereign_node_handlers():
    """Test message handlers."""
    node = SovereignNovaNode()
    received_msgs = []
    node.on("DATA", lambda msg: received_msgs.append(msg))

    sender = SovereignNovaNode()
    sender.add_peer(node.identity)
    node.add_peer(sender.identity)

    sender.send(to=node.node_id, payload={"test": True})
    outbox = sender.flush_outbox()
    node.receive(outbox[0]["envelope"])

    assert len(received_msgs) == 1
    assert received_msgs[0].payload["test"] is True


def test_sovereign_node_status():
    """Test network status reporting."""
    node = SovereignNovaNode()
    status = node.network_status()
    assert "nodeId" in status
    assert "lyapunov" in status
    assert "relay" in status
    assert status["relay"]["noDropOK"] is True


# ═══════════════════════════════════════════════════════════════════════════════
# §12 — LOCAL NETWORK SIMULATION TESTS
# ═══════════════════════════════════════════════════════════════════════════════

def test_create_local_network():
    """Test local network creation."""
    net = create_local_network(5)
    nodes = net["nodes"]
    deliver = net["deliver"]
    assert len(nodes) == 5
    # Each node knows 4 peers
    for node in nodes:
        assert len(node.peers()) == 4


def test_local_network_delivery():
    """Test message delivery across local network."""
    net = create_local_network(3)
    nodes = net["nodes"]
    deliver = net["deliver"]

    # Node 0 sends to Node 2
    nodes[0].send(to=nodes[2].node_id, payload={"data": 42})
    deliver()

    inbox = nodes[2].inbox()
    assert len(inbox) >= 1
    assert inbox[0].payload["data"] == 42


def test_local_network_gossip():
    """Test gossip propagation in local network."""
    net = create_local_network(4)
    nodes = net["nodes"]

    # Trigger gossip on node 0
    msgs = nodes[0]._gossip.gossip_round()
    assert len(msgs) > 0


# ═══════════════════════════════════════════════════════════════════════════════
# §13 — BOOTSTRAP TESTS
# ═══════════════════════════════════════════════════════════════════════════════

def test_bootstrap_node():
    """Test bootstrapping a node from a known peer."""
    node = SovereignNovaNode()
    bootstrap_peer = {"nodeId": "BOOT-001", "shard": 5, "type": "SOVEREIGN", "freq": PHI}
    bootstrap_node(node, bootstrap_peer)
    assert len(node.peers()) >= 1


# ═══════════════════════════════════════════════════════════════════════════════
# RUNNER
# ═══════════════════════════════════════════════════════════════════════════════

def run_all_tests():
    """Run all tests and report results."""
    tests = [
        # Constants
        test_phi_constants,
        test_heartbeat_derivation,
        test_dht_shards,
        # Identity
        test_create_node_identity,
        test_node_identity_custom,
        test_identity_to_dict,
        test_secure_id,
        # Messages
        test_create_message,
        test_message_hop,
        test_message_expiry,
        test_message_priority_clamping,
        # DHT
        test_phi_dht_add_remove,
        test_phi_dht_next_hop,
        test_phi_dht_k_closest,
        test_phi_dht_eviction,
        # Relay
        test_relay_store_basic,
        test_relay_store_capacity,
        test_relay_store_expired,
        test_relay_store_evict,
        # Lyapunov
        test_lyapunov_convergence,
        test_lyapunov_divergence,
        test_lyapunov_bounds,
        # Gossip
        test_gossip_round,
        test_gossip_receive,
        # Encryption
        test_seal_unseal,
        test_unseal_invalid,
        # Consensus
        test_consensus_propose,
        test_consensus_voting,
        test_consensus_rejection,
        test_consensus_election,
        test_consensus_accept_leader,
        # Heartbeat
        test_heartbeat_beat_once,
        test_heartbeat_alternating,
        test_heartbeat_status,
        # Sovereign Node
        test_sovereign_node_creation,
        test_sovereign_node_send_receive,
        test_sovereign_node_broadcast,
        test_sovereign_node_handlers,
        test_sovereign_node_status,
        # Local Network
        test_create_local_network,
        test_local_network_delivery,
        test_local_network_gossip,
        # Bootstrap
        test_bootstrap_node,
    ]

    passed = 0
    failed = 0
    errors = []

    print("=" * 72)
    print("  NOVA NETWORK SDK — PYTHON TEST SUITE")
    print("=" * 72)
    print()

    for test_fn in tests:
        try:
            test_fn()
            passed += 1
            print(f"  ✓ {test_fn.__name__}")
        except Exception as e:
            failed += 1
            errors.append((test_fn.__name__, str(e)))
            print(f"  ✗ {test_fn.__name__} — {e}")

    print()
    print("=" * 72)
    print(f"  RESULTS: {passed} passed, {failed} failed, {passed + failed} total")
    print("=" * 72)

    if errors:
        print("\n  FAILURES:")
        for name, err in errors:
            print(f"    • {name}: {err}")

    return failed == 0


if __name__ == "__main__":
    success = run_all_tests()
    sys.exit(0 if success else 1)
