#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FRONTEND_DIR="$ROOT_DIR/src/frontend"

HOST_IP="${AURO_HOST_IP:-$(hostname -I 2>/dev/null | awk '{print $1}')}"
if [[ -z "${HOST_IP:-}" ]]; then
  HOST_IP="127.0.0.1"
fi

BRIDGE_PORT="${AURO_BRIDGE_PORT:-8787}"
FRONTEND_PORT="${AURO_FRONTEND_PORT:-5173}"
ALLOW_EXEC="${AURO_ALLOW_EXEC:-0}"
TOKEN="${AURO_BRIDGE_TOKEN:-$(node -e "console.log(require('crypto').randomBytes(16).toString('hex'))")}"

echo "[AURO] Root: $ROOT_DIR"
echo "[AURO] Host IP: $HOST_IP"
echo "[AURO] Frontend port: $FRONTEND_PORT"
echo "[AURO] Bridge port: $BRIDGE_PORT"
echo "[AURO] Exec mode: $ALLOW_EXEC"

if ! command -v npm >/dev/null 2>&1; then
  echo "[AURO] npm not found. Install Node.js first."
  exit 1
fi

if ! command -v node >/dev/null 2>&1; then
  echo "[AURO] node not found. Install Node.js first."
  exit 1
fi

if [[ -z "$TOKEN" ]]; then
  TOKEN="$(node -e 'console.log(require("node:crypto").randomBytes(18).toString("hex"))')"
  echo "[AURO] Generated AURO_BRIDGE_TOKEN for this session."
fi

cd "$FRONTEND_DIR"

if [[ ! -d node_modules ]]; then
  echo "[AURO] Installing frontend dependencies..."
  npm install
fi

API_BASE="http://${HOST_IP}:${BRIDGE_PORT}"
echo "[AURO] Writing runtime env for mobile bridge routing..."
cat > "$FRONTEND_DIR/.env.local" <<EOF
VITE_AURO_API_BASE=${API_BASE}
VITE_AURO_BRIDGE_TOKEN=${TOKEN}
EOF

echo "[AURO] Starting AURO companion bridge..."
(
  cd "$ROOT_DIR"
  AURO_BRIDGE_HOST=0.0.0.0 \
  AURO_BRIDGE_PORT="$BRIDGE_PORT" \
  AURO_ALLOW_EXEC="$ALLOW_EXEC" \
  AURO_BRIDGE_TOKEN="$TOKEN" \
  node scripts/auro-companion-bridge.mjs
) >/tmp/auro-bridge.log 2>&1 &
BRIDGE_PID=$!

echo "[AURO] Starting frontend dev server..."
(
  cd "$FRONTEND_DIR"
  npm exec -- vite --host 0.0.0.0 --port "$FRONTEND_PORT"
) >/tmp/auro-frontend.log 2>&1 &
FRONTEND_PID=$!

cleanup() {
  echo "[AURO] Stopping services..."
  kill "$BRIDGE_PID" >/dev/null 2>&1 || true
  kill "$FRONTEND_PID" >/dev/null 2>&1 || true
}
trap cleanup EXIT

sleep 3

echo
echo "=== AURO READY FOR PHONE TEST ==="
echo "Frontend URL: http://${HOST_IP}:${FRONTEND_PORT}"
echo "Bridge health: http://${HOST_IP}:${BRIDGE_PORT}/health"
if [[ -n "$TOKEN" ]]; then
  echo "Bridge token: $TOKEN"
  echo "Companion auto-sends this via VITE_AURO_BRIDGE_TOKEN."
else
  echo "Bridge token: not set (local trusted network only)"
fi
echo
echo "On phone:"
echo "1) Open Frontend URL"
echo "2) Go to Companion tab"
echo "3) Run /status, then /voice on"
echo "4) Optional: /shell on and /run date"
echo
echo "Logs:"
echo "- tail -f /tmp/auro-bridge.log"
echo "- tail -f /tmp/auro-frontend.log"
echo
echo "Press Ctrl+C to stop both services."

wait
