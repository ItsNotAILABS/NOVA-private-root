"""NOVA Embedding SDK — Test Suite"""
import sys, os, random
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from nova_embedding import *

def test_vector_store():
    store = VectorStore(dimensions=4)
    v = store.add([1.0, 0.0, 0.0, 0.0])
    assert store.size == 1
    assert v.dimensions == 4

def test_search():
    store = VectorStore(dimensions=4)
    store.add([1.0, 0.0, 0.0, 0.0])
    store.add([0.0, 1.0, 0.0, 0.0])
    results = store.search([1.0, 0.1, 0.0, 0.0], k=1)
    assert len(results) == 1

def test_similarity():
    store = VectorStore(dimensions=4)
    v1 = store.add([1.0, 0.0, 0.0, 0.0])
    v2 = store.add([0.9, 0.1, 0.0, 0.0])
    engine = SimilarityEngine(store)
    result = engine.similar(v1.vector_id, k=1)
    assert len(result.matches) == 1

def test_reducer():
    reducer = DimensionReducer(target_dims=2)
    vectors = [[random.random() for _ in range(8)] for _ in range(5)]
    result = reducer.transform(vectors)
    assert result.target_dims == 2
    assert len(result.vectors) == 5

def test_phi_index():
    store = VectorStore(dimensions=4)
    for _ in range(20):
        store.add([random.random() for _ in range(4)])
    index = PhiIndex(store)
    count = index.build()
    assert count == 20
    results = index.search([0.5, 0.5, 0.5, 0.5], k=3)
    assert len(results) <= 3

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
