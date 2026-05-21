/// <reference types="vite/client" />

interface ImportMetaEnv {
  // ── ICP Canister IDs ────────────────────────────────────────────────────
  readonly VITE_IC_HOST?: string;
  readonly VITE_SWARM_BRAIN_CANISTER_ID?: string;
  readonly VITE_PARALLAX_CANISTER_ID?: string;
  readonly VITE_NOVA_BUILDER_CANISTER_ID?: string;
  readonly VITE_NOVA_STUDENT_CANISTER_ID?: string;
  readonly VITE_DALLAS_ISD_CANISTER_ID?: string;
  readonly VITE_SKYHI_CANISTER_ID?: string;
  // ── AURO Companion ─────────────────────────────────────────────────────
  readonly VITE_AURO_API_BASE?: string;
  readonly VITE_AURO_BRIDGE_TOKEN?: string;
}

interface ImportMeta {
  readonly env: ImportMetaEnv;
}
