from __future__ import annotations

import argparse
import json
import time
from pathlib import Path

import lm_eval
from lm_eval.utils import handle_non_serializable

from auro_lm_eval import AuroHarnessLM


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--checkpoint", required=True)
    parser.add_argument("--output", required=True)
    parser.add_argument("--limit", type=int, default=3)
    parser.add_argument(
        "--tasks",
        default="hellaswag,arc_easy,winogrande,gsm8k,mmlu_abstract_algebra",
    )
    args = parser.parse_args()
    output = Path(args.output)
    output.mkdir(parents=True, exist_ok=True)
    tasks = [item.strip() for item in args.tasks.split(",") if item.strip()]
    started = time.time()
    model = AuroHarnessLM(args.checkpoint, device="cpu")
    results = lm_eval.simple_evaluate(
        model=model,
        tasks=tasks,
        limit=args.limit,
        batch_size=1,
        device="cpu",
        log_samples=True,
    )
    payload = {
        "schema": "medina.auro.real_benchmark.v1",
        "checkpoint": str(Path(args.checkpoint).resolve()),
        "checkpoint_metadata": model.metadata,
        "tasks": tasks,
        "limit_per_task": args.limit,
        "duration_seconds": round(time.time() - started, 3),
        "results": results,
    }
    (output / "lm-eval-results.json").write_text(
        json.dumps(payload, default=handle_non_serializable, indent=2, sort_keys=True),
        encoding="utf-8",
    )
    summary = {
        task: {key: value for key, value in metrics.items() if ",stderr" not in key}
        for task, metrics in (results.get("results") or {}).items()
    }
    (output / "benchmark-summary.json").write_text(
        json.dumps(summary, default=handle_non_serializable, indent=2, sort_keys=True),
        encoding="utf-8",
    )
    print(json.dumps(summary, default=handle_non_serializable, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
