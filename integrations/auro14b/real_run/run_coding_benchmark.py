from __future__ import annotations

import argparse
import hashlib
import json
import re
import subprocess
import sys
import tempfile
import time
from pathlib import Path

from auro_foundry.generation import TextGenerator

TASKS = [
    {"id": "add_integers", "prompt": "Write only Python code defining add_integers(a, b) that returns the sum of two integers.", "tests": "assert add_integers(2, 3) == 5\nassert add_integers(-4, 9) == 5"},
    {"id": "reverse_text", "prompt": "Write only Python code defining reverse_text(value) that returns the reversed string.", "tests": "assert reverse_text('auro') == 'orua'\nassert reverse_text('') == ''"},
    {"id": "factorial", "prompt": "Write only Python code defining factorial(n) for non-negative integers using an iterative implementation.", "tests": "assert factorial(0) == 1\nassert factorial(5) == 120"},
]


def extract_code(text: str) -> str:
    match = re.search(r"```(?:python)?\s*(.*?)```", text, flags=re.DOTALL | re.IGNORECASE)
    return (match.group(1) if match else text).strip()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--checkpoint", required=True)
    parser.add_argument("--output", required=True)
    args = parser.parse_args()
    output = Path(args.output)
    output.mkdir(parents=True, exist_ok=True)
    generator = TextGenerator(args.checkpoint, device="cpu")
    results = []
    for task in TASKS:
        started = time.time()
        generated = generator.generate(task["prompt"], max_new_tokens=160, temperature=0.0)
        code = extract_code(generated)
        program = code + "\n\n" + task["tests"] + "\nprint('PASS')\n"
        with tempfile.TemporaryDirectory(prefix="auro-code-") as directory:
            source = Path(directory) / "candidate.py"
            source.write_text(program, encoding="utf-8")
            try:
                completed = subprocess.run([sys.executable, "-I", str(source)], text=True, capture_output=True, timeout=10, shell=False, check=False)
                passed = completed.returncode == 0 and "PASS" in completed.stdout
                stdout, stderr, returncode = completed.stdout[-4000:], completed.stderr[-4000:], completed.returncode
            except subprocess.TimeoutExpired:
                passed, stdout, stderr, returncode = False, "", "execution timed out", 124
        results.append({"task_id": task["id"], "passed": passed, "generated_code": code, "source_sha256": hashlib.sha256(code.encode()).hexdigest(), "returncode": returncode, "stdout": stdout, "stderr": stderr, "duration_seconds": round(time.time() - started, 3)})
    receipt = {"schema": "medina.auro.coding_benchmark.v1", "checkpoint": str(Path(args.checkpoint).resolve()), "passed": sum(int(item["passed"]) for item in results), "total": len(results), "results": results}
    (output / "coding-results.json").write_text(json.dumps(receipt, indent=2, sort_keys=True), encoding="utf-8")
    print(json.dumps({"passed": receipt["passed"], "total": receipt["total"]}, indent=2))


if __name__ == "__main__":
    main()
