/// <reference types="vite/client" />

interface ImportMetaEnv {
  readonly VITE_AURO_API_BASE?: string;
  readonly VITE_AURO_BRIDGE_TOKEN?: string;
}

interface ImportMeta {
  readonly env: ImportMetaEnv;
}
