export * from './types.js';
export * from './queue.js';
export * from './mesh.js';
export * from './inference.js';
export * from './bridge.js';
export * from './delta_attention.js';
export * from './residual_engine.js';
export * from './mesie_multimodal.js';
export * from './device_fabric.js';
export * from './horizon_memory.js';
export * from './native_engine.js';

import { GovernedPythonBridge } from './bridge.js';
import { WebGPUInference } from './inference.js';
import { WorkerMesh } from './mesh.js';
import { NativeCognitionEngine } from './native_engine.js';

export class ChromeRuntime {
  readonly mesh = new WorkerMesh(['inference','tensor','python','capsula','matdaemon','office','wallet','receipt']);
  readonly inference = new WebGPUInference();
  readonly cognition = new NativeCognitionEngine();
  readonly bridge: GovernedPythonBridge;

  constructor(endpoint = 'http://127.0.0.1:8092', token?: string) {
    this.bridge = new GovernedPythonBridge(endpoint, token);
  }

  start(): void { this.mesh.start(); }
  stop(): void { this.mesh.stop(); }

  async workOnce(): Promise<boolean> {
    const task = await this.mesh.claim();
    if (!task) return false;
    try {
      if (task.kind === 'inference' || task.kind === 'tensor') {
        const result = await this.inference.generate(task.payload as any);
        await this.mesh.complete(task, result);
      } else {
        const { result, receipt } = await this.bridge.execute(task);
        if (!receipt.allowed) await this.mesh.queue.transition(task.id, 'denied', { result: receipt });
        else await this.mesh.complete(task, { result, receipt });
      }
    } catch (error) {
      await this.mesh.fail(task, error);
    }
    return true;
  }
}
