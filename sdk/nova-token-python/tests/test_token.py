"""NOVA Token SDK — Test Suite"""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from nova_token import *

def test_ledger():
    token = Token("Nova Token", "NOVA", 1000000)
    ledger = TokenLedger(token)
    ledger.mint_to("alice", 1000)
    assert ledger.balance_of("alice") == 1000

def test_transfer():
    token = Token("Nova", "NOVA", 1000000)
    ledger = TokenLedger(token)
    ledger.mint_to("alice", 100)
    assert ledger.transfer("alice", "bob", 40)
    assert ledger.balance_of("bob") == 40
    assert ledger.balance_of("alice") == 60

def test_forge():
    forge = TokenForge()
    ledger = forge.create_token("NOVA", "NOV")
    forge.mint("NOV", "alice", 500)
    assert ledger.balance_of("alice") == 500

def test_staking():
    pool = StakingPool()
    s = pool.stake("alice", 100.0)
    assert pool.total_staked == 100.0
    rewards = pool.distribute_rewards()
    assert len(rewards) == 1
    assert rewards[0].amount > 0

def test_bonding_curve():
    curve = BondingCurve(CurveType.PHI_BONDING)
    p1 = curve.price_at(0)
    p2 = curve.price_at(1000)
    assert p2 > p1  # Price increases with supply

def test_bonding_cost():
    curve = BondingCurve()
    cost = curve.cost_to_buy(0, 100)
    assert cost > 0

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
