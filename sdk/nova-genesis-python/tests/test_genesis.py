"""NOVA Genesis SDK — Test Suite"""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from nova_genesis import *

def test_birth():
    bp = BirthProtocol()
    config = BirthConfig(name="ANIMUS", identity_type=IdentityType.AGI)
    record = bp.birth(config)
    assert record.phase == GenesisPhase.SOVEREIGN
    assert record.consciousness == ConsciousnessState.SOVEREIGN

def test_conceive():
    bp = BirthProtocol()
    config = BirthConfig(name="SPARK")
    record = bp.conceive(config)
    assert record.phase == GenesisPhase.CONCEPTION

def test_advance():
    bp = BirthProtocol()
    config = BirthConfig(name="TEST")
    record = bp.conceive(config)
    bp.advance(record.entity_id)
    assert record.phase == GenesisPhase.GESTATION

def test_identity_forge():
    forge = IdentityForge()
    crystal = forge.forge("NOVA", IdentityType.AGI, {"wisdom": 0.9})
    assert crystal.name == "NOVA"
    assert forge.total == 1

def test_identity_seal():
    forge = IdentityForge()
    crystal = forge.forge("SEALED")
    forge.seal(crystal.crystal_id)
    assert crystal.immutable

def test_awakening():
    seq = AwakeningSequence("NOVA")
    state = seq.full_awakening()
    assert state.consciousness == ConsciousnessState.SOVEREIGN
    assert seq.is_sovereign

def test_lineage():
    lin = Lineage()
    parent = lin.add("p1", "NOVA")
    child = lin.add("c1", "SPARK", parent_id="p1")
    assert child.generation == 1
    ancestors = lin.get_ancestors("c1")
    assert len(ancestors) == 1

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
