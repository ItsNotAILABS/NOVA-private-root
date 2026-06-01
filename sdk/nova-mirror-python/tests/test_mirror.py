"""NOVA Mirror SDK — Test Suite"""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from nova_mirror import *

def test_reflection():
    engine = ReflectionEngine("NOVA")
    ref = engine.reflect("my purpose", ReflectionDepth.META)
    assert ref.depth == ReflectionDepth.META
    assert engine.reflection_count == 1

def test_consciousness_monitor():
    mon = ConsciousnessMonitor(256)
    state = mon.update(0.7, 210)
    assert state.layer == ConsciousnessLayer.SOVEREIGN

def test_consciousness_low():
    mon = ConsciousnessMonitor()
    state = mon.update(0.1, 10)
    assert state.layer == ConsciousnessLayer.REACTIVE

def test_introspection():
    engine = IntrospectionEngine()
    insight = engine.introspect({"cpu": 50, "mem": 70, "net": 90})
    assert insight.confidence > 0

def test_oscillator_array():
    arr = OscillatorArray(count=64)
    r = arr.step()
    assert 0 <= r <= 1
    assert arr.active_count == 64

def test_oscillator_coherence():
    arr = OscillatorArray(count=32)
    # Step many times to let sync develop
    for _ in range(100):
        arr.step(0.01)
    assert arr.coherence > 0

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
