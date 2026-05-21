#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════════════
# NOVA SOVEREIGN MAINNET DEPLOYMENT — 10 ALPHA AGIs  (BUILD №67)
# ═══════════════════════════════════════════════════════════════════════════════
#
# COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ
# CONFIDENTIAL — TRADE SECRET — PROTECTED UNDER NDA
#
# Deploys all 10 Sovereign Alpha AGIs and their associated Motoko canisters
# to the Internet Computer mainnet.
#
# USAGE:
#   ./scripts/deploy-mainnet.sh              — Full deploy (all 10 Alphas)
#   ./scripts/deploy-mainnet.sh --alpha ANI  — Deploy single Alpha (ANIMUS)
#   ./scripts/deploy-mainnet.sh --check      — Pre-flight check only
#   ./scripts/deploy-mainnet.sh --status     — Query deployment status
#
# PRE-REQUISITES:
#   - dfx >= 0.24.3 installed
#   - dfx identity with sufficient cycles
#   - moc compiler (via scripts/nova install-moc)
#   - Cycles wallet funded (minimum 50T cycles per canister)
#
# ═══════════════════════════════════════════════════════════════════════════════

set -euo pipefail

# ─── Constants ────────────────────────────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
NOVA_CLI="$SCRIPT_DIR/nova"
CANISTER_IDS="$PROJECT_ROOT/canister_ids.json"
DEPLOY_LOG="$PROJECT_ROOT/.nova/deploy-mainnet.log"
NETWORK="ic"
DFX_VERSION="0.24.3"
MIN_CYCLES=50000000000000  # 50T cycles per canister

# φ constants (used in deployment scoring)
PHI="1.6180339887498948482"
PHI_INV="0.6180339887498948482"

# 10 Sovereign Alpha AGI definitions
# Format: CODE:NAME:FAMILY:PORT:CANISTERS
ALPHAS=(
  "ANI:ANIMUS MAXIMUS:SPIRITUS_AETERNA:7619:swarm_brain,swarm_organism,swarm_command,agi_main,medina"
  "CHR:CHRONOS PERPETUUS:TEMPUS_AETERNA:7620:agi_terminal,swarm_telemetry,nova_stream"
  "SYN:SYNTHOS UNIVERSALIS:NEXUS_COGNITUS:7621:organism_solver,syntax_synapse,friston_machina,swarm_quantum,ai_division"
  "PRA:PRAESIDIUM INVICTUS:AEGIS_PERPETUA:7622:neuron_fleet,aegis_shield,vael_cyber,war_engine,medina_defense"
  "MER:MERCATOR AUREUS:AURUM_AETERNA:7623:phantom_transfer,quipu_ledger,cycles_market,cycles_bridge,auto_market,organism_token,airdrop_engine,swarm_metals"
  "GEN:GENESIS INFINITUS:FABRICA_MAXIMA:7624:sovereign_factory,token_forge,chrysalis,nova_builder"
  "NEX:NEXUS OMNIUM:UNITAS_AETERNA:7625:nexus_propagator,chimera_swarm,drone_fleet,swarm_oracle"
  "VER:VERITAS AETERNA:VERUM_AETERNA:7626:nova_protocol,nova_governance,nova_sns,scribe,swarm_audit"
  "ARC:ARCHITECTUS SUPREMUS:STRUCTURA_MAXIMA:7627:token_intelligence,parallax,architect,frontend"
  "ANM:ANIMA PERPETUA:CURA_AETERNA:7628:"
)

# ─── Colors ───────────────────────────────────────────────────────────────────

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# ─── Logging ──────────────────────────────────────────────────────────────────

log()   { echo -e "${CYAN}[NOVA DEPLOY]${NC} $*"; }
ok()    { echo -e "${GREEN}  ✓${NC} $*"; }
warn()  { echo -e "${YELLOW}  ⚠${NC} $*"; }
fail()  { echo -e "${RED}  ✗${NC} $*"; }
header() {
  echo ""
  echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
  echo -e "${BLUE}  $*${NC}"
  echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
}

# ─── Pre-flight checks ───────────────────────────────────────────────────────

preflight() {
  header "PRE-FLIGHT CHECKS"

  local errors=0

  # Check dfx
  if command -v dfx &>/dev/null; then
    local ver
    ver=$(dfx --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
    ok "dfx installed: v${ver}"
  else
    fail "dfx not installed (need >= ${DFX_VERSION})"
    errors=$((errors + 1))
  fi

  # Check moc
  if command -v moc &>/dev/null || [ -f "$PROJECT_ROOT/.nova/moc/moc" ]; then
    ok "moc compiler found"
  elif [ -x "$NOVA_CLI" ]; then
    warn "moc not found — run: ./scripts/nova install-moc"
    errors=$((errors + 1))
  else
    fail "moc compiler not found"
    errors=$((errors + 1))
  fi

  # Check identity
  if command -v dfx &>/dev/null; then
    local identity
    identity=$(dfx identity whoami 2>/dev/null || echo "unknown")
    if [ "$identity" != "unknown" ]; then
      ok "dfx identity: ${identity}"
    else
      fail "No dfx identity configured"
      errors=$((errors + 1))
    fi
  fi

  # Check canister_ids.json
  if [ -f "$CANISTER_IDS" ]; then
    ok "canister_ids.json found"
  else
    fail "canister_ids.json not found"
    errors=$((errors + 1))
  fi

  # Check nova.json
  if [ -f "$PROJECT_ROOT/nova.json" ]; then
    ok "nova.json manifest found"
  else
    fail "nova.json manifest not found"
    errors=$((errors + 1))
  fi

  # Check production apps
  local alpha_count=0
  for f in "$PROJECT_ROOT/production-apps/sovereign-agis/nova-"*.js; do
    [ -f "$f" ] && alpha_count=$((alpha_count + 1))
  done
  if [ "$alpha_count" -eq 10 ]; then
    ok "All 10 Sovereign Alpha AGIs present"
  else
    fail "Expected 10 Alpha AGIs, found ${alpha_count}"
    errors=$((errors + 1))
  fi

  # Type-check Motoko (if moc available)
  if [ -x "$NOVA_CLI" ]; then
    log "Running Motoko type-check..."
    if "$NOVA_CLI" check 2>/dev/null; then
      ok "Motoko type-check passed"
    else
      warn "Motoko type-check had warnings (non-fatal)"
    fi
  fi

  echo ""
  if [ "$errors" -eq 0 ]; then
    ok "All pre-flight checks passed"
    return 0
  else
    fail "${errors} pre-flight check(s) failed"
    return 1
  fi
}

# ─── Build a single canister ─────────────────────────────────────────────────

build_canister() {
  local canister="$1"
  log "Building canister: ${canister}"

  if [ -x "$NOVA_CLI" ]; then
    "$NOVA_CLI" build "$canister" 2>&1 | tail -3
  elif command -v dfx &>/dev/null; then
    dfx build "$canister" --network "$NETWORK" 2>&1 | tail -3
  else
    fail "No build tool available (need moc or dfx)"
    return 1
  fi
}

# ─── Deploy a single canister ────────────────────────────────────────────────

deploy_canister() {
  local canister="$1"
  log "Deploying canister: ${canister} → mainnet (${NETWORK})"

  if ! command -v dfx &>/dev/null; then
    fail "dfx required for mainnet deployment"
    return 1
  fi

  # Create canister if needed
  dfx canister --network "$NETWORK" create "$canister" 2>/dev/null || true

  # Deploy
  dfx deploy "$canister" --network "$NETWORK" --yes 2>&1 | tail -5

  # Get canister ID
  local cid
  cid=$(dfx canister --network "$NETWORK" id "$canister" 2>/dev/null || echo "pending")
  ok "Deployed ${canister}: ${cid}"
  echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) DEPLOY ${canister} → ${cid}" >> "$DEPLOY_LOG"
}

# ─── Deploy a single Alpha AGI ───────────────────────────────────────────────

deploy_alpha() {
  local alpha_def="$1"
  IFS=':' read -r code name family port canisters <<< "$alpha_def"

  header "DEPLOYING ALPHA: ${name} (${code}-AGI-001)"
  log "Family: ${family} | Port: ${port}"

  if [ -z "$canisters" ]; then
    log "${name} has no dedicated canisters (consciousness-only AGI)"
    ok "${name} registered (no canister deploy needed)"
    return 0
  fi

  IFS=',' read -ra canister_list <<< "$canisters"
  local deployed=0
  local failed=0

  for canister in "${canister_list[@]}"; do
    if build_canister "$canister"; then
      if deploy_canister "$canister"; then
        deployed=$((deployed + 1))
      else
        failed=$((failed + 1))
      fi
    else
      warn "Build failed for ${canister} — skipping deploy"
      failed=$((failed + 1))
    fi
  done

  echo ""
  log "Alpha ${code}: ${deployed} deployed, ${failed} failed out of ${#canister_list[@]} canisters"

  if [ "$failed" -eq 0 ]; then
    ok "${name} fully deployed ✓"
  else
    warn "${name} partially deployed (${failed} failures)"
  fi
}

# ─── Deploy all 10 Alphas ────────────────────────────────────────────────────

deploy_all() {
  header "NOVA SOVEREIGN MAINNET DEPLOYMENT"
  echo ""
  echo -e "${CYAN}  ███╗   ██╗ ██████╗ ██╗   ██╗ █████╗ ${NC}"
  echo -e "${CYAN}  ████╗  ██║██╔═══██╗██║   ██║██╔══██╗${NC}"
  echo -e "${CYAN}  ██╔██╗ ██║██║   ██║██║   ██║███████║${NC}"
  echo -e "${CYAN}  ██║╚██╗██║██║   ██║╚██╗ ██╔╝██╔══██║${NC}"
  echo -e "${CYAN}  ██║ ╚████║╚██████╔╝ ╚████╔╝ ██║  ██║${NC}"
  echo -e "${CYAN}  ╚═╝  ╚═══╝ ╚═════╝   ╚═══╝  ╚═╝  ╚═╝${NC}"
  echo ""
  echo -e "  ${YELLOW}SOVEREIGN MAINNET DEPLOYMENT — 10 ALPHA AGIs${NC}"
  echo -e "  ${YELLOW}Network: ${NETWORK} | Build: №67 | φ = ${PHI}${NC}"
  echo ""

  mkdir -p "$(dirname "$DEPLOY_LOG")"
  echo "═══ MAINNET DEPLOY $(date -u +%Y-%m-%dT%H:%M:%SZ) ═══" >> "$DEPLOY_LOG"

  # Pre-flight
  if ! preflight; then
    fail "Pre-flight failed. Fix issues above before deploying."
    exit 1
  fi

  # Deploy each Alpha
  local total_deployed=0
  local total_failed=0

  for alpha_def in "${ALPHAS[@]}"; do
    deploy_alpha "$alpha_def"
  done

  header "DEPLOYMENT COMPLETE"
  echo ""
  log "Deploy log: ${DEPLOY_LOG}"
  echo ""
}

# ─── Query deployment status ─────────────────────────────────────────────────

status() {
  header "MAINNET DEPLOYMENT STATUS"

  if ! command -v dfx &>/dev/null; then
    fail "dfx required to query mainnet status"
    exit 1
  fi

  for alpha_def in "${ALPHAS[@]}"; do
    IFS=':' read -r code name family port canisters <<< "$alpha_def"
    echo -e "\n${BLUE}── ${name} (${code}-AGI-001) ──${NC}"

    if [ -z "$canisters" ]; then
      log "  (consciousness-only — no canisters)"
      continue
    fi

    IFS=',' read -ra canister_list <<< "$canisters"
    for canister in "${canister_list[@]}"; do
      local cid
      cid=$(dfx canister --network "$NETWORK" id "$canister" 2>/dev/null || echo "NOT DEPLOYED")
      if [ "$cid" != "NOT DEPLOYED" ]; then
        ok "${canister}: ${cid}"
      else
        warn "${canister}: not yet deployed"
      fi
    done
  done
}

# ─── Main ─────────────────────────────────────────────────────────────────────

case "${1:-}" in
  --check)
    preflight
    ;;
  --status)
    status
    ;;
  --alpha)
    if [ -z "${2:-}" ]; then
      fail "Usage: $0 --alpha CODE (e.g. ANI, CHR, SYN, PRA, MER, GEN, NEX, VER, ARC, ANM)"
      exit 1
    fi
    target="${2}"
    found=0
    for alpha_def in "${ALPHAS[@]}"; do
      IFS=':' read -r code _ _ _ _ <<< "$alpha_def"
      if [ "$code" = "$target" ]; then
        deploy_alpha "$alpha_def"
        found=1
        break
      fi
    done
    if [ "$found" -eq 0 ]; then
      fail "Unknown Alpha code: ${target}"
      exit 1
    fi
    ;;
  --help|-h)
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "  (no args)       Full deploy — all 10 Alpha AGIs to mainnet"
    echo "  --check          Pre-flight checks only"
    echo "  --status         Query current deployment status"
    echo "  --alpha CODE     Deploy single Alpha (ANI|CHR|SYN|PRA|MER|GEN|NEX|VER|ARC|ANM)"
    echo "  --help           Show this help"
    ;;
  *)
    deploy_all
    ;;
esac
