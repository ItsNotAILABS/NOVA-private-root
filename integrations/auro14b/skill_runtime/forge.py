from __future__ import annotations
import argparse, json
from pathlib import Path
from core import Library, sha, cj
from curriculum import CURATED, CODE_DRILLS, curriculum_records

FIX = [
    ("derive a quantitative benchmark score and validate the formula", {"matdaemon-math-verification"}),
    ("run this Python worker safely in an isolated sandbox and give me a receipt", {"capsula-governed-execution"}),
    ("preserve identity and memory continuity across recurrent cognitive cycles", {"brain-ai-cognitive-continuity"}),
    ("analyze MESIE phase coherence and spectral consolidation", {"mesie-spectral-reasoning"}),
    ("patch this GitHub repository, run tests, and debug the API", {"nova-code-execution"}),
    ("train the Auro tokenizer and evaluate the checkpoint", {"auro-model-production"}),
    ("route this request to the best internal skill and dependency plan", {"skill-library-routing"}),
    ("train Auro and execute generated code in a sandbox", {"auro-model-production", "capsula-governed-execution"}),
    ("use brain memory with MESIE coherence", {"brain-ai-cognitive-continuity", "mesie-spectral-reasoning"}),
    ("create a proof-backed test workflow for a repository", {"nova-code-execution", "matdaemon-math-verification"}),
    ("deploy a canister worker with governed execution", {"capsula-governed-execution"}),
    ("measure latency, score accuracy, and verify results", {"matdaemon-math-verification"}),
    ("design salience and homeostasis for the brain atlas", {"brain-ai-cognitive-continuity"}),
    ("serve a checkpoint behind an OpenAI-compatible API", {"auro-model-production"}),
    ("compose worker skills and delegate a plan", {"skill-library-routing"}),
]

def parse_repo(value):
    name, path = value.split("=", 1)
    return name, Path(path)

def build(args):
    lib, receipt = Library.build(dict(parse_repo(value) for value in args.repo))
    lib.save(args.output, receipt)
    print(json.dumps(receipt, indent=2))
    return 0

def evaluate(args):
    lib = Library.load(args.library); tp = fp = fn = top = 0; rows = []
    for query, expected in FIX:
        decision = lib.route(query, 4)
        actual = {match.name for match in decision.matches}
        direct = {match.name for match in decision.matches if not any(reason.startswith("dependency:") for reason in match.reasons)}
        primary = decision.matches[0].name if decision.matches else None
        hit = len(expected & actual); extra = len(direct - expected); miss = len(expected - actual)
        tp += hit; fp += extra; fn += miss; top += int(primary in expected)
        rows.append({"query": query, "expected": sorted(expected), "actual": sorted(actual), "primary": primary, "tp": hit, "fp": extra, "fn": miss})
    precision = tp / max(1, tp + fp); recall = tp / max(1, tp + fn)
    f1 = 2 * precision * recall / max(1e-12, precision + recall); top1 = top / len(FIX)
    score = .55 * recall + .25 * precision + .2 * top1
    payload = {"schema": "medina.auro.skill_router_eval.v2", "library_hash": lib.library_hash, "fixtures": len(FIX), "precision": precision, "recall": recall, "f1": f1, "top1_accuracy": top1, "weighted_score": score, "threshold": args.threshold, "passed": score >= args.threshold and recall >= args.threshold, "rows": rows}
    payload["receipt_hash"] = sha(cj(payload))
    output = Path(args.output); output.parent.mkdir(parents=True, exist_ok=True); output.write_text(json.dumps(payload, indent=2))
    print(json.dumps(payload, indent=2)); return 0 if payload["passed"] else 2

def corpus(args):
    lib = Library.load(args.library); output = Path(args.output); output.mkdir(parents=True, exist_ok=True); manifest = []
    for index, (system, user, assistant, skill, kind) in enumerate(curriculum_records(lib)):
        text = f"<|system|>\n{system}\n<|user|>\n{user}\n<|assistant|>\n{assistant}\n<|eos|>\n"
        path = output / f"skill-training-{index:04d}.md"; path.write_text(text)
        manifest.append({"path": path.name, "sha256": sha(text), "skill": skill, "kind": kind, "chars": len(text)})
    kinds = {}
    for item in manifest: kinds[item["kind"]] = kinds.get(item["kind"], 0) + 1
    payload = {"schema": "medina.auro.skill_training_corpus.v2", "library_hash": lib.library_hash, "records": len(manifest), "kinds": kinds, "manifest": manifest}
    payload["receipt_hash"] = sha(cj(payload)); (output / "training-corpus-receipt.json").write_text(json.dumps(payload, indent=2))
    print(json.dumps({key: value for key, value in payload.items() if key != "manifest"}, indent=2)); return 0

def main():
    parser = argparse.ArgumentParser(); sub = parser.add_subparsers(dest="cmd", required=True)
    command = sub.add_parser("build"); command.add_argument("--repo", action="append", default=[]); command.add_argument("--output", required=True); command.set_defaults(fn=build)
    command = sub.add_parser("evaluate"); command.add_argument("--library", required=True); command.add_argument("--output", required=True); command.add_argument("--threshold", type=float, default=.85); command.set_defaults(fn=evaluate)
    command = sub.add_parser("corpus"); command.add_argument("--library", required=True); command.add_argument("--output", required=True); command.set_defaults(fn=corpus)
    args = parser.parse_args(); raise SystemExit(args.fn(args))

if __name__ == "__main__": main()
