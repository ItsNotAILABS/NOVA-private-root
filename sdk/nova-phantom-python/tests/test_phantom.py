"""NOVA Phantom SDK — Test Suite"""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from nova_phantom import *

def test_envelope():
    engine = EnvelopeEngine()
    env = engine.create("alice", "bob", {"secret": "data"})
    assert env.state == EnvelopeState.OPEN

def test_seal_deliver():
    engine = EnvelopeEngine()
    env = engine.create("alice", "bob", "payload")
    assert engine.seal(env.envelope_id, "secret_key")
    assert env.state == EnvelopeState.SEALED
    assert engine.deliver(env.envelope_id)
    assert env.state == EnvelopeState.DELIVERED

def test_stealth():
    gen = StealthGenerator()
    addr = gen.generate("alice", uses=2)
    assert addr.address.startswith("0xPHANTOM_")
    assert gen.consume(addr.address)
    assert gen.resolve_owner(addr.address) == "alice"

def test_transfer():
    engine = TransferEngine()
    t = engine.initiate("alice", "bob", 100.0)
    assert engine.execute(t.transfer_id)
    assert engine.total_transferred == 100.0

def test_keys():
    mgr = KeyManager()
    kp = mgr.generate(KeyType.EPHEMERAL)
    assert mgr.active_count == 1
    pub = mgr.get_public(kp.key_id)
    assert pub.startswith("PUB_")
    mgr.revoke(kp.key_id)
    assert mgr.active_count == 0

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
