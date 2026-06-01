"""NOVA Wellness SDK — Test Suite"""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from nova_wellness import *

def test_vitality():
    mon = VitalityMonitor()
    mon.update(VitalSign.HEARTBEAT, 0.9)
    score = mon.score()
    assert score.overall > 0

def test_sleep_cycle():
    engine = SleepCycleEngine()
    cycles = engine.full_cycle()
    assert len(cycles) == 4
    assert engine.phase == SleepPhase.AWAKE

def test_homeostasis():
    ctrl = HomeostasisController()
    ctrl.set_target("temperature", 0.7)
    reading = ctrl.regulate("temperature", 0.5)
    assert reading.correction > 0

def test_energy():
    mgr = EnergyManager()
    pool = mgr.create_pool("compute", 100.0)
    assert mgr.consume("compute", 30.0)
    assert pool.current == 70.0
    mgr.regenerate()
    assert pool.current > 70.0

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
