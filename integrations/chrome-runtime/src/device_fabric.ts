export type DeviceClass = 'browser-webgpu' | 'browser-wasm' | 'python-cpu' | 'python-gpu' | 'mobile' | 'edge';

export interface DeviceNode {
  id: string;
  kind: DeviceClass;
  memoryMB: number;
  compute: number;
  latencyMs: number;
  battery?: number;
  thermal?: number;
  capabilities: string[];
  lastSeen: number;
}

export interface PlacementRequest {
  capability: string;
  memoryMB: number;
  compute: number;
  preferLocal?: boolean;
  maxLatencyMs?: number;
}

export interface PlacementDecision {
  node?: DeviceNode;
  score: number;
  reasons: string[];
}

export class NativeDeviceFabric {
  private readonly nodes = new Map<string, DeviceNode>();

  upsert(node: DeviceNode): void { this.nodes.set(node.id, { ...node, capabilities: [...node.capabilities] }); }
  remove(id: string): void { this.nodes.delete(id); }
  snapshot(): DeviceNode[] { return [...this.nodes.values()].map((node) => ({ ...node, capabilities: [...node.capabilities] })); }

  place(request: PlacementRequest): PlacementDecision {
    const ranked = this.snapshot().map((node) => {
      const reasons: string[] = [];
      if (!node.capabilities.includes(request.capability)) return { node, score: -1e9, reasons: ['missing-capability'] };
      if (node.memoryMB < request.memoryMB) return { node, score: -1e9, reasons: ['insufficient-memory'] };
      let score = Math.min(2, node.compute / Math.max(0.01, request.compute));
      score += Math.min(1, node.memoryMB / Math.max(1, request.memoryMB)) * 0.25;
      score -= Math.min(2, node.latencyMs / Math.max(1, request.maxLatencyMs ?? 1000)) * 0.5;
      if (request.preferLocal && node.kind.startsWith('browser')) { score += 0.4; reasons.push('locality'); }
      if (node.battery !== undefined && node.battery < 0.2) { score -= 0.5; reasons.push('battery-protection'); }
      if (node.thermal !== undefined && node.thermal > 0.8) { score -= 0.75; reasons.push('thermal-protection'); }
      if (node.kind === 'browser-webgpu') reasons.push('webgpu');
      reasons.push('capability-fit');
      return { node, score, reasons };
    }).sort((a,b) => b.score - a.score);
    const best = ranked[0];
    return best && best.score > -1e8 ? { node: best.node, score: best.score, reasons: best.reasons } : { score: 0, reasons: ['no-fit'] };
  }
}
