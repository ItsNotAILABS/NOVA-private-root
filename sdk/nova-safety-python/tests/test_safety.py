"""NOVA Safety SDK — Test Suite"""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from nova_safety import (
    PHI, PHI_INV, SafetyLevel, ComplianceState, ThreatClass, ControlCategory,
    TOTAL_CONTROLS, SafetyValidator, ValidationResult,
    ComplianceEngine, ComplianceReport, Control,
    ThreatDetector, Threat, ThreatResponse,
    ConstraintEngine, Constraint, ConstraintViolation,
)

def test_constants():
    assert TOTAL_CONTROLS == 481
    assert abs(PHI_INV - 0.618) < 0.001

def test_validator_pass():
    v = SafetyValidator()
    v.add_rule("always_pass", lambda a: True)
    result = v.validate({"action": "test"})
    assert result.valid
    assert result.score == 1.0

def test_validator_fail():
    v = SafetyValidator(strict=True)
    v.add_rule("always_fail", lambda a: False, SafetyLevel.WARNING)
    result = v.validate({"action": "test"})
    assert not result.valid
    assert len(result.violations) == 1

def test_compliance_engine():
    engine = ComplianceEngine()
    assert engine.total_controls == 481

def test_compliance_check_category():
    engine = ComplianceEngine()
    count = engine.check_category(ControlCategory.ACCESS, True)
    assert count == 52

def test_compliance_report():
    engine = ComplianceEngine()
    engine.check_category(ControlCategory.ACCESS, True)
    report = engine.report()
    assert report.passed >= 52

def test_threat_detector():
    detector = ThreatDetector()
    detector.add_pattern("high_load", lambda c: 0.9 if c.get("load", 0) > 80 else 0, ThreatClass.HIGH)
    threats = detector.scan({"load": 90})
    assert len(threats) == 1
    assert threats[0].threat_class == ThreatClass.HIGH

def test_threat_mitigate():
    detector = ThreatDetector()
    detector.add_pattern("test", lambda c: 1.0, ThreatClass.LOW)
    threats = detector.scan({"x": 1})
    response = detector.mitigate(threats[0].threat_id, "restart")
    assert response.success
    assert len(detector.active_threats) == 0

def test_constraint_engine():
    engine = ConstraintEngine()
    engine.add("positive", lambda c: c.get("value", 0) > 0)
    assert engine.is_safe({"value": 5})
    assert not engine.is_safe({"value": -1})

def test_constraint_violations():
    engine = ConstraintEngine()
    engine.add("min_size", lambda c: c.get("size", 0) >= 10, SafetyLevel.CRITICAL)
    violations = engine.enforce({"size": 5})
    assert len(violations) == 1
    assert violations[0].level == SafetyLevel.CRITICAL

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
