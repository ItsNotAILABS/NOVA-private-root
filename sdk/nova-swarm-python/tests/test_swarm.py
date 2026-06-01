"""NOVA Swarm SDK — Test Suite"""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from nova_swarm import *

def test_agent_pool():
    pool = SwarmAgentPool()
    pool.spawn("scout-1", SwarmRole.SCOUT, [1.0, 2.0])
    pool.spawn("worker-1", SwarmRole.WORKER)
    assert pool.count == 2

def test_coordinator():
    pool = SwarmAgentPool()
    for i in range(10):
        pool.spawn(f"agent-{i}", position=[float(i), float(i*2)])
    coord = SwarmCoordinator(pool)
    result = coord.coordinate(iterations=5)
    assert result.agents_coordinated == 10
    assert result.avg_coherence > 0

def test_kuramoto():
    ks = KuramotoSync(n=20, coupling=PHI_INV)
    for _ in range(500):
        r = ks.step(0.05)
    assert r > 0.2  # Should sync somewhat

def test_formation_spiral():
    fe = FormationEngine()
    f = fe.golden_spiral(10)
    assert f.agent_count == 10
    assert len(f.positions) == 10

def test_formation_lattice():
    fe = FormationEngine()
    f = fe.fibonacci_lattice(20)
    assert f.agent_count == 20

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
