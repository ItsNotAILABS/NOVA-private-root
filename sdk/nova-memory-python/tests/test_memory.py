"""NOVA Memory SDK — Test Suite"""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from nova_memory import (
    PHI, PHI_INV, MemoryTier, MemoryState, ConsolidationMode,
    MemoryStore, Memory, MemoryQuery,
    ConsolidationEngine, ConsolidationResult,
    RecallEngine, RecallResult,
    PersistenceLayer, Snapshot,
)

def test_store():
    store = MemoryStore()
    m = store.store("hello world", tags=["greeting"])
    assert store.size == 1
    assert m.tier == MemoryTier.WORKING

def test_recall():
    store = MemoryStore()
    m = store.store("test data")
    recalled = store.recall(m.memory_id)
    assert recalled is not None
    assert recalled.access_count == 1

def test_search():
    store = MemoryStore()
    store.store("alpha", tags=["greek"])
    store.store("beta", tags=["greek"])
    store.store("gamma", tags=["other"])
    results = store.search(MemoryQuery(tags=["greek"]))
    assert len(results) == 2

def test_decay():
    store = MemoryStore()
    store.store("weak", strength=0.005)
    decayed = store.decay(rate=0.5)
    assert decayed >= 1

def test_promote():
    store = MemoryStore()
    m = store.store("important")
    store.promote(m.memory_id, MemoryTier.SOVEREIGN)
    assert store._memories[m.memory_id].state == MemoryState.PROTECTED

def test_consolidation():
    store = MemoryStore()
    store.store("data1", strength=0.8)
    store.store("data2", strength=0.3)
    engine = ConsolidationEngine(store)
    result = engine.consolidate()
    assert result.consolidated >= 1

def test_sleep_cycle():
    store = MemoryStore()
    store.store("dream data", strength=0.5)
    engine = ConsolidationEngine(store)
    result = engine.sleep_cycle()
    assert isinstance(result, ConsolidationResult)

def test_persistence():
    store = MemoryStore()
    store.store("persist me")
    layer = PersistenceLayer(store)
    snap = layer.snapshot()
    assert snap.memory_count == 1
    json_str = layer.export_json()
    assert len(json_str) > 0

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
