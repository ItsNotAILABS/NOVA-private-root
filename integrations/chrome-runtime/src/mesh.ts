import type { MeshPeer, MeshTask, TaskKind } from './types.js';
import { PersistentQueue } from './queue.js';

interface MeshMessage {
  type: 'hello' | 'heartbeat' | 'claim' | 'complete' | 'fail';
  peer: MeshPeer;
  task?: MeshTask;
}

export class WorkerMesh {
  readonly id = crypto.randomUUID();
  readonly queue = new PersistentQueue();
  private readonly channel = new BroadcastChannel('medina-chrome-worker-mesh-v1');
  private readonly peers = new Map<string, MeshPeer>();
  private timer?: number;

  constructor(private readonly capabilities: TaskKind[]) {
    this.channel.onmessage = (event: MessageEvent<MeshMessage>) => this.receive(event.data);
  }

  start(): void {
    this.broadcast('hello');
    this.timer = window.setInterval(() => {
      this.prune();
      this.broadcast('heartbeat');
    }, 2_000);
  }

  stop(): void {
    if (this.timer) window.clearInterval(this.timer);
    this.channel.close();
  }

  async enqueue(kind: TaskKind, payload: unknown, priority = 0): Promise<MeshTask> {
    const now = Date.now();
    const task: MeshTask = {
      id: crypto.randomUUID(), kind, payload, priority, attempts: 0,
      createdAt: now, updatedAt: now, state: 'queued'
    };
    await this.queue.put(task);
    this.broadcast('heartbeat');
    return task;
  }

  async claim(): Promise<MeshTask | undefined> {
    const task = await this.queue.lease(this.id);
    if (!task || !this.capabilities.includes(task.kind)) return undefined;
    await this.queue.transition(task.id, 'running', { leaseOwner: this.id });
    this.broadcast('claim', task);
    return task;
  }

  async complete(task: MeshTask, result: unknown): Promise<void> {
    const next = await this.queue.transition(task.id, 'completed', { result });
    this.broadcast('complete', next);
  }

  async fail(task: MeshTask, error: unknown): Promise<void> {
    const next = await this.queue.transition(task.id, 'failed', { error: String(error) });
    this.broadcast('fail', next);
  }

  snapshot(): MeshPeer[] {
    return [...this.peers.values()].sort((a, b) => a.id.localeCompare(b.id));
  }

  private peer(): MeshPeer {
    return {
      id: this.id,
      capabilities: this.capabilities,
      lastSeen: Date.now(),
      busy: false,
      webgpu: 'gpu' in navigator
    };
  }

  private broadcast(type: MeshMessage['type'], task?: MeshTask): void {
    this.channel.postMessage({ type, peer: this.peer(), task } satisfies MeshMessage);
  }

  private receive(message: MeshMessage): void {
    if (message.peer.id === this.id) return;
    this.peers.set(message.peer.id, { ...message.peer, lastSeen: Date.now() });
  }

  private prune(): void {
    const staleBefore = Date.now() - 10_000;
    for (const [id, peer] of this.peers) if (peer.lastSeen < staleBefore) this.peers.delete(id);
  }
}
