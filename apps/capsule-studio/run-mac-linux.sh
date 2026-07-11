#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
if [ ! -f .env ]; then
  cp .env.example .env
  echo "Created .env from .env.example. Paste OPENAI_API_KEY into apps/capsule-studio/.env, then run this again."
  exit 0
fi
echo "Starting NOVA Capsule Studio at http://127.0.0.1:8787"
npm start
