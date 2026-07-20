import type { MeshTask, TaskState } from './types.js';

const DB_NAME = 'medina-chrome-runtime';
const STORE = 'workflow-queue';
const VERSION = 1;

function openDb(): Promise<IDBDatabase> {
  return new Promise((resolve, reject) => {
    const request = indexedDB.open(DB_NAME, VERSION);
    request.onupgradeneeded = () => {
      const db = request.result;
      if (!db.objectStoreNames.contains(STORE)) {
        const store = db.createObjectStore(STORE, { keyPath: 'id' });
        store.createIndex('state', 'state');
        store.createIndex('priority', 'priority');
        store.createIndex('updatedAt', 'updatedAt');
      }
    };
    request.onsuccess = () => resolve(request.result);
    request.onerror = () => reject(request.error);
  });
}

export class PersistentQueue {
  async put(task: MeshTask): Promise<void> {
    const db = await openDb();
    await new Promise<void>((resolve, reject) => {
      const tx = db.transaction(STORE, 'readwrite');
      tx.objectStore(STORE).put(task);
      tx.oncomplete = () => resolve();
      tx.onerror = () => reject(tx.error);
    });
  }

  async get(id: string): Promise<MeshTask | undefined> {
    const db = await openDb();
    return new Promise((resolve, reject) => {
      const request = db.transaction(STORE).objectStore(STORE).get(id);
      request.onsuccess = () => resolve(request.result as MeshTask | undefined);
      request.onerror = () => reject(request.error);
    });
  }

  async list(states?: TaskState[]): Promise<MeshTask[]> {
    const db = await openDb();
    const tasks = await new Promise<MeshTask[]>((resolve, reject) => {
      const request = db.transaction(STORE).objectStore(STORE).getAll();
      request.onsuccess = () => resolve(request.result as MeshTask[]);
      request.onerror = () => reject(request.error);
    });
    return tasks
      .filter((task) => !states || states.includes(task.state))
      .sort((a, b) => b.priority - a.priority || a.createdAt - b.createdAt);
  }

  async lease(owner: string, ttlMs = 30_000): Promise<MeshTask | undefined> {
    const now = Date.now();
    const candidates = await this.list(['queued', 'leased']);
    const task = candidates.find((item) => item.state === 'queued' || (item.leaseUntil ?? 0) < now);
    if (!task) return undefined;
    task.state = 'leased';
    task.leaseOwner = owner;
    task.leaseUntil = now + ttlMs;
    task.updatedAt = now;
    task.attempts += 1;
    await this.put(task);
    return task;
  }

  async transition(id: string, state: TaskState, patch: Partial<MeshTask> = {}): Promise<MeshTask> {
    const task = await this.get(id);
    if (!task) throw new Error(`Unknown task: ${id}`);
    const next = { ...task, ...patch, state, updatedAt: Date.now() };
    await this.put(next);
    return next;
  }
}
