"""NOVA Synapse SDK — Test Suite"""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from nova_synapse import *

def test_network():
    net = SynapseNetwork()
    s = net.connect("A", "B")
    assert net.synapse_count == 1
    assert net.node_count == 2

def test_signal_propagation():
    net = SynapseNetwork()
    net.connect("A", "B", weight=0.8)
    net.connect("B", "C", weight=0.6)
    prop = SignalPropagator(net)
    signal = Signal(source="A", signal_type=SignalType.SPIKE)
    deliveries = prop.propagate(signal)
    assert len(deliveries) >= 2

def test_hebbian():
    net = SynapseNetwork()
    syn = net.connect("X", "Y", weight=0.5)
    learner = HebbianLearner(net)
    events = learner.learn("X", "Y", correlation=1.0)
    assert len(events) == 1
    assert events[0].new_weight > 0.5

def test_topology():
    net = SynapseNetwork()
    net.connect("A", "B")
    net.connect("B", "C")
    net.connect("A", "C")
    topo = NetworkTopology(net)
    stats = topo.stats()
    assert stats.nodes == 3
    assert stats.synapses == 3

if __name__ == "__main__":
    tests = [f for f in dir() if f.startswith("test_")]
    passed = 0
    for t in tests:
        try:
            eval(f"{t}()")
            passed += 1
            print(f"  ✓ {t}")
        except Exception as e:
            print(f"  ✗ {t}: {e}")
    print(f"\n{passed}/{len(tests)} tests passed")
