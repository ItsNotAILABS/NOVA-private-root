#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "[1/6] Checking dfx"
if ! command -v dfx >/dev/null 2>&1; then
  echo "dfx not found. Run: ./scripts/install_dfx_local.sh"
  exit 1
fi

echo "[2/6] Checking node/npm"
if ! command -v npm >/dev/null 2>&1; then
  echo "npm not found. Install Node.js first."
  exit 1
fi

echo "[3/6] Installing frontend dependencies"
cd "$ROOT_DIR/src/frontend"
npm install

echo "[4/6] Building frontend assets"
npm run build

echo "[5/6] Starting local replica"
cd "$ROOT_DIR"
dfx start --clean --background

echo "[6/6] Deploying canisters"
dfx deploy

echo "Local stack is up."
echo "- IC local: http://127.0.0.1:8000"
echo "- Frontend canister should be available via dfx output URLs."
