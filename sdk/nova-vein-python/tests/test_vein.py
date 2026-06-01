"""NOVA Vein SDK — Test Suite"""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from nova_vein import *

def test_vein_network():
    net = VeinNetwork()
    net.add_vein("heart", "brain", VeinType.ARTERY)
    assert net.vein_count == 1
    assert net.node_count == 2

def test_flow():
    net = VeinNetwork()
    net.add_vein("A", "B")
    net.add_vein("B", "C")
    engine = FlowEngine(net)
    assert engine.send("A", "C", "data")
    stats = engine.stats()
    assert stats.packets_delivered == 1

def test_flow_no_path():
    net = VeinNetwork()
    net.add_vein("A", "B")
    engine = FlowEngine(net)
    assert not engine.send("A", "Z", "data")

def test_pressure():
    net = VeinNetwork()
    v = net.add_vein("A", "B", capacity=10)
    v.current_load = 8
    reg = PressureRegulator(net)
    readings = reg.measure_all()
    assert readings[0].level == PressureLevel.HIGH

def test_nutrient():
    transport = NutrientTransport()
    n = transport.create("energy", 50.0, "core", "edge")
    assert transport.pending == 1
    transport.deliver(n.nutrient_id)
    assert transport.pending == 0

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
