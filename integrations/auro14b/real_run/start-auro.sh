#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT"
python3 -m venv .venv
. .venv/bin/activate
python -m pip install --upgrade pip
python -m pip install "git+https://github.com/ItsNotAILABS/Auro14B.git@main#egg=mesie[foundry]"
auro-foundry serve --checkpoint model/final.pt --host 127.0.0.1 --port 8090 --open-browser
