import type { BridgeReceipt, MeshTask, TaskKind } from './types.js';

const PRIVILEGED = new Set<TaskKind>(['python','capsula','matdaemon','office','wallet','receipt']);

async function digest(value: unknown): Promise<string> {
  const bytes = new TextEncoder().encode(JSON.stringify(value));
  const hash = await crypto.subtle.digest('SHA-256', bytes);
  return [...new Uint8Array(hash)].map((item) => item.toString(16).padStart(2, '0')).join('');
}

export class GovernedPythonBridge {
  constructor(
    private readonly endpoint: string,
    private readonly token?: string,
    private readonly allowed: TaskKind[] = [...PRIVILEGED]
  ) {}

  async execute(task: MeshTask): Promise<{ result?: unknown; receipt: BridgeReceipt }> {
    const permitted = PRIVILEGED.has(task.kind) && this.allowed.includes(task.kind);
    const requestHash = await digest({ id: task.id, kind: task.kind, payload: task.payload });
    if (!permitted) {
      return {
        receipt: {
          schema: 'medina.chrome.bridge.receipt.v1', taskId: task.id, capability: task.kind,
          allowed: false, status: 'denied_capability', requestHash, timestamp: Date.now()
        }
      };
    }
    const response = await fetch(`${this.endpoint}/v1/tasks/execute`, {
      method: 'POST',
      headers: {
        'content-type': 'application/json',
        ...(this.token ? { authorization: `Bearer ${this.token}` } : {})
      },
      body: JSON.stringify({ task_id: task.id, capability: task.kind, payload: task.payload })
    });
    const body = await response.json();
    const responseHash = await digest(body);
    return {
      result: body.result,
      receipt: {
        schema: 'medina.chrome.bridge.receipt.v1', taskId: task.id, capability: task.kind,
        allowed: response.ok, status: String(body.status ?? response.status), requestHash,
        responseHash, timestamp: Date.now()
      }
    };
  }
}
