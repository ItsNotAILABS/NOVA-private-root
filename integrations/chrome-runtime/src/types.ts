export type TaskKind = 'inference' | 'tensor' | 'python' | 'capsula' | 'matdaemon' | 'office' | 'wallet' | 'receipt';
export type TaskState = 'queued' | 'leased' | 'running' | 'completed' | 'failed' | 'denied';

export interface MeshTask {
  id: string;
  kind: TaskKind;
  payload: unknown;
  createdAt: number;
  updatedAt: number;
  state: TaskState;
  priority: number;
  attempts: number;
  leaseOwner?: string;
  leaseUntil?: number;
  result?: unknown;
  error?: string;
}

export interface MeshPeer {
  id: string;
  capabilities: TaskKind[];
  lastSeen: number;
  busy: boolean;
  webgpu: boolean;
}

export interface BridgeReceipt {
  schema: 'medina.chrome.bridge.receipt.v1';
  taskId: string;
  capability: TaskKind;
  allowed: boolean;
  status: string;
  requestHash: string;
  responseHash?: string;
  timestamp: number;
}

export interface InferenceRequest {
  modelId: string;
  prompt: string;
  maxNewTokens?: number;
  temperature?: number;
}

export interface InferenceResult {
  backend: 'webgpu' | 'wasm' | 'remote-python';
  text: string;
  latencyMs: number;
  modelId: string;
}
