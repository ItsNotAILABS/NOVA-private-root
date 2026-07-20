#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

WEIGHTS = {
    "tokenizer": 0.10,
    "corpus": 0.10,
    "training": 0.12,
    "checkpoint": 0.12,
    "generation": 0.10,
    "api_chat": 0.10,
    "coding_execution": 0.08,
    "official_evaluation": 0.08,
    "safety_governance": 0.08,
    "browser_ui": 0.05,
    "beginner_launch": 0.07,
}
CRITICAL = {
    "tokenizer", "corpus", "training", "checkpoint", "generation",
    "api_chat", "safety_governance", "beginner_launch",
}


def score_readiness(payload: dict, threshold: float = 0.85) -> dict:
    gates = payload.get("gates", payload)
    if not isinstance(gates, dict):
        raise ValueError("gates must be an object")
    normalized: dict[str, float] = {}
    for name in WEIGHTS:
        value = gates.get(name, 0.0)
        if isinstance(value, dict):
            value = value.get("score", 0.0)
        score = float(value)
        if not 0.0 <= score <= 1.0:
            raise ValueError(f"{name} must be between 0 and 1")
        normalized[name] = score
    weighted = sum(normalized[name] * WEIGHTS[name] for name in WEIGHTS)
    blockers = [
        item for item in payload.get("blockers", [])
        if isinstance(item, dict)
        and item.get("severity") == "critical"
        and not item.get("resolved", False)
    ]
    critical_failures = sorted(name for name in CRITICAL if normalized[name] < threshold)
    return {
        "schema": "medina.mesie_model_promotion.v1",
        "threshold": threshold,
        "weighted_readiness": round(weighted, 6),
        "passed": weighted >= threshold and not critical_failures and not blockers,
        "critical_failures": critical_failures,
        "critical_blockers": blockers,
        "gates": normalized,
        "benchmark_accuracy_is_separate": True,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description="Gate Auro/MESIE model promotion for human users")
    parser.add_argument("input", type=Path)
    parser.add_argument("--threshold", type=float, default=0.85)
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    payload = json.loads(args.input.read_text(encoding="utf-8"))
    result = score_readiness(payload, args.threshold)
    text = json.dumps(result, indent=2, sort_keys=True)
    print(text)
    if args.output:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(text + "\n", encoding="utf-8")
    return 0 if result["passed"] else 2


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (OSError, ValueError, json.JSONDecodeError) as exc:
        print(json.dumps({"error": str(exc)}), file=sys.stderr)
        raise SystemExit(1)
