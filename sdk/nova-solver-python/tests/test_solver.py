"""NOVA Solver SDK — Test Suite"""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from nova_solver import *

def test_golden_section():
    opt = PhiOptimizer()
    result = opt.golden_section(lambda x: (x - 2)**2, 0, 5)
    assert abs(result.x[0] - 2.0) < 0.001
    assert result.converged

def test_minimize():
    opt = PhiOptimizer(max_iter=500)
    result = opt.minimize(lambda x: (x[0]-1)**2 + (x[1]-2)**2, [0.0, 0.0])
    assert abs(result.x[0] - 1.0) < 0.5
    assert abs(result.x[1] - 2.0) < 0.5

def test_constraint_solver():
    cs = ConstraintSolver()
    constraints = ConstraintSet()
    constraints.add("positive", lambda v: v["x"] > 0)
    sol = cs.solve(constraints, {"x": 5})
    assert sol.feasible

def test_constraint_violation():
    cs = ConstraintSolver()
    constraints = ConstraintSet()
    constraints.add("positive", lambda v: v["x"] > 0)
    sol = cs.solve(constraints, {"x": -1})
    assert not sol.feasible

def test_gradient_descent():
    gd = PhiGradientDescent()
    result = gd.minimize(lambda x: [2*x[0]], [5.0])
    assert abs(result.x[0]) < 1.0

def test_annealing():
    sa = SimulatedAnnealing(AnnealConfig(max_iter=1000))
    result = sa.minimize(lambda x: (x[0]-3)**2, [10.0])
    assert abs(result.x[0] - 3.0) < 2.0

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
