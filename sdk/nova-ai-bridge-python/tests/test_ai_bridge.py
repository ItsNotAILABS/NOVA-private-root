"""NOVA AI Bridge SDK — Test Suite"""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from nova_ai_bridge import *

def test_registry():
    reg = ModelRegistry()
    reg.register("gpt-4", "GPT-4", ModelType.LLM, ["reasoning", "code"])
    assert reg.total == 1
    assert len(reg.find_by_capability("code")) == 1

def test_router():
    reg = ModelRegistry()
    m1 = reg.register("m1", "Model A", ModelType.LLM)
    m1.phi_score = 0.9
    m2 = reg.register("m2", "Model B", ModelType.LLM)
    m2.phi_score = 0.7
    router = InferenceRouter(reg)
    decision = router.route(ModelType.LLM)
    assert decision.model_id == "m1"  # highest phi

def test_gateway():
    gw = AIGateway()
    req = gw.request("Hello world", ModelType.LLM)
    resp = gw.respond(req.request_id, "Hi!", "model-1", tokens=5)
    assert resp.state == InferenceState.COMPLETED
    assert gw.total_tokens == 5

def test_ensemble():
    engine = EnsembleEngine()
    engine.add_model("m1", lambda p: "answer", weight=1.0)
    engine.add_model("m2", lambda p: "answer", weight=0.8)
    result = engine.infer("question")
    assert result.consensus == "answer"
    assert result.agreement_score == 1.0

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
