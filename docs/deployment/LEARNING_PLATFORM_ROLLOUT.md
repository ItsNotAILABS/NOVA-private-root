# NOVA Shared Learning Platform Rollout

**Build:** №69  
**Scope:** shared `learning_core` + `agent_orchestrator` production rollout across 3 platforms

---

## 1) Shared ICP Learning Canister (Canonical Core)

`learning_core` is the single sovereign memory/learning substrate for all NOVA agents.

### Included products
- **Training/fine-tune input pipeline**
  - canonical `LearningRecord` intake
  - quality/provenance/policy checks
  - promotion to trusted training examples
- **RAG context pipeline**
  - trusted RAG record promotion
  - indexed retrieval chunks via `getRagContext`
- **Evaluation pipeline**
  - benchmark case registry
  - benchmark score telemetry
  - versioned suite progression

### Governance + economics
- producer/consumer ACL
- record quota control
- retention window pruning
- storage cost accounting per KB

---

## 2) Agent Orchestration Canister (Control Plane)

`agent_orchestrator` separates control-plane orchestration from learning storage.

### Core responsibilities
- register/disable autonomous agents
- spawn/manage lifecycle jobs (`QUEUED → RUNNING → COMPLETED/FAILED`)
- track per-agent reputation + yield score
- route agent evidence into `learning_core` through inter-canister calls

### Chain Fusion lane
- chain-fusion policy registry (limits, risk tier, approval requirement)
- intent submission by registered agents
- auditable status flow (`PENDING → APPROVED/REJECTED → EXECUTED`)
- evidence logging of intents into `learning_core`

---

## 3) Three Production Platforms

### Platform A — Frontend Sovereign Surface
- ICP asset canister (`frontend`)
- canister dependencies now include:
  - `learning_core`
  - `agent_orchestrator`
- purpose: sovereign UI + agent console surface

### Platform B — Edge Resilience Surface
- Cloudflare Worker / edge relay pattern remains boundary-facing ingress
- role: resilient request pathing to ICP boundary nodes and canister APIs
- integrates with orchestration + learning APIs as edge client

### Platform C — Autonomous Coordination Surface
- `agent_orchestrator` + `learning_core` + existing core NOVA canisters
- role: autonomous execution + memory + governance closed loop

---

## 4) Launch Waves

### Wave 1
- deploy `learning_core`
- activate universal record contract
- enable training/RAG/eval baseline pipelines

### Wave 2
- deploy `agent_orchestrator`
- register major agent producers
- route job/evidence flow to shared learning core

### Wave 3
- activate edge hardening around orchestration routes
- enforce chain-fusion policy lifecycle
- operationalize governance and cost controls at scale

---

## 5) Success Criteria

- **Training:** trusted promotion ratio and dataset freshness
- **RAG:** retrieval relevance and response latency
- **Evaluation:** benchmark pass trend and regression detection speed
- **Platform:** orchestrator uptime, inter-canister reliability, cost per active agent cycle
