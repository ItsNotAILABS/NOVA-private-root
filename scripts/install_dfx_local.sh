#!/usr/bin/env bash
set -euo pipefail

echo "[AURO] Installing DFX SDK locally (non-root)..."
sh -ci "$(curl -fsSL https://internetcomputer.org/install.sh)"

echo "[AURO] DFX install complete."
echo "[AURO] If this shell does not see dfx yet, run:"
echo "  source \"$HOME/.local/share/dfx/env\""
echo "or open a new terminal session."
