"""NOVA Health SDK — Test Suite"""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from nova_health import *

def test_monitor():
    mon = HealthMonitor()
    mon.register_check("net", SubsystemType.NETWORK, lambda: True)
    report = mon.run_checks()
    assert report.overall_state == HealthState.HEALTHY

def test_monitor_failure():
    mon = HealthMonitor()
    mon.register_check("bad", SubsystemType.MEMORY, lambda: False)
    report = mon.run_checks()
    assert report.checks_failed == 1

def test_diagnostics():
    engine = DiagnosticEngine()
    engine.add("check1", lambda: True)
    results = engine.run_all()
    assert results[0].passed

def test_anomaly_detector():
    det = AnomalyDetector(window_size=10)
    for i in range(10):
        det.record("cpu", 50.0)
    anomaly = det.record("cpu", 200.0)  # big spike (constant baseline → any deviation is huge)
    assert anomaly is not None

def test_self_healer():
    healer = SelfHealer()
    healer.register_action("restart", SubsystemType.NETWORK, lambda: None)
    results = healer.heal(SubsystemType.NETWORK)
    assert len(results) == 1
    assert results[0].success

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
