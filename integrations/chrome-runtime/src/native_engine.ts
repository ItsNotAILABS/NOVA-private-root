import { DeltaAttentionMemory, type DeltaAttentionResult } from './delta_attention.js';
import { AdaptiveResidualEngine, type ResidualDecision } from './residual_engine.js';
import { MESIEMultisenseFusion, type SensePacket, type FusedSenseState } from './mesie_multimodal.js';
import { NativeDeviceFabric, type PlacementDecision, type PlacementRequest } from './device_fabric.js';
import { HorizonMemory, type HorizonEvent, type HorizonState } from './horizon_memory.js';

export interface NativeDecodeInput { hidden: number[]; proposal: number[]; senses?: SensePacket[]; novelty: number; uncertainty: number; memoryKey?: number[]; memoryValue?: number[]; placement?: PlacementRequest; horizonEvent?: HorizonEvent; }
export interface EfficiencyReceipt { schema: 'medina.native.decode.efficiency.v1'; timestamp: number; memorySlots: number; memorySelected: number; skippedMemorySlots: number; residualUpdated: boolean; residualGate: number; denseAttentionOpsEstimate: number; deltaAttentionOpsEstimate: number; estimatedAttentionReduction: number; phase: FusedSenseState['phase']; coherence: number; placement?: { nodeId: string; kind: string; score: number }; }
export interface NativeDecodeResult { hidden: number[]; delta: DeltaAttentionResult; residual: ResidualDecision; senses: FusedSenseState; horizon: HorizonState; placement?: PlacementDecision; receipt: EfficiencyReceipt; }

export class NativeCognitionEngine {
  readonly delta = new DeltaAttentionMemory();
  readonly residual = new AdaptiveResidualEngine();
  readonly senses = new MESIEMultisenseFusion();
  readonly devices = new NativeDeviceFabric();
  readonly horizon = new HorizonMemory();

  step(input: NativeDecodeInput): NativeDecodeResult {
    const fused = this.senses.fuse(input.senses ?? []);
    if (input.horizonEvent) this.horizon.append(input.horizonEvent);
    if (input.memoryKey && input.memoryValue) this.delta.write(input.memoryKey, input.memoryValue);
    const query = fused.vector.length ? fused.vector : input.hidden;
    const delta = this.delta.attend(query);
    const proposal = input.proposal.map((value, index) => value + (delta.output[index] ?? 0));
    const residual = this.residual.route(input.hidden, proposal, input.novelty, input.uncertainty);
    const placement = input.placement ? this.devices.place(input.placement) : undefined;
    const width = Math.max(1, query.length), slots = Math.max(1, this.delta.size()), selected = Math.max(1, delta.selected.length);
    const denseOps = slots * width, deltaOps = selected * width;
    const receipt: EfficiencyReceipt = {
      schema: 'medina.native.decode.efficiency.v1', timestamp: Date.now(), memorySlots: this.delta.size(), memorySelected: delta.selected.length, skippedMemorySlots: delta.skippedTokens,
      residualUpdated: residual.updated, residualGate: residual.gate, denseAttentionOpsEstimate: denseOps, deltaAttentionOpsEstimate: deltaOps,
      estimatedAttentionReduction: Math.max(0, 1 - deltaOps / Math.max(1, denseOps)), phase: fused.phase, coherence: fused.coherence,
      placement: placement?.node ? { nodeId: placement.node.id, kind: placement.node.kind, score: placement.score } : undefined
    };
    return { hidden: residual.output, delta, residual, senses: fused, horizon: this.horizon.state(), placement, receipt };
  }
}
