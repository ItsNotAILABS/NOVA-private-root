import test from 'node:test';
import assert from 'node:assert/strict';
import { DeltaAttentionMemory } from './delta_attention.js';
import { AdaptiveResidualEngine } from './residual_engine.js';
import { MESIEMultisenseFusion } from './mesie_multimodal.js';
import { NativeDeviceFabric } from './device_fabric.js';
import { HorizonMemory } from './horizon_memory.js';
import { NativeCognitionEngine } from './native_engine.js';

test('delta attention retrieves a sparse subset', () => {
  const memory = new DeltaAttentionMemory({ capacity: 64, topK: 2, decay: 0.999, noveltyThreshold: 0.01, learningRate: 0.08 });
  for (let i = 0; i < 8; i += 1) memory.write([Math.cos(i), Math.sin(i), i / 8], [i, i + 1, i + 2]);
  const result = memory.attend([1, 0, 0]);
  assert.ok(memory.size() >= 4);
  assert.ok(result.selected.length <= 2);
  assert.ok(result.skippedTokens > 0);
});

test('adaptive residual can bypass low-value updates', () => {
  const engine = new AdaptiveResidualEngine();
  const result = engine.route([1,1,1], [1.001,1.001,1.001], 0.01, 0.01);
  assert.equal(result.updated, false);
  assert.ok(result.state.bypassRate > 0);
});

test('MESIE fuses multiple senses into a coherent state', () => {
  const fusion = new MESIEMultisenseFusion().fuse([
    { kind:'text', embedding:[1,0,0], confidence:1, salience:1, timestamp:1, source:'chat' },
    { kind:'vision', embedding:[0.9,0.1,0], confidence:0.9, salience:1, timestamp:1, source:'camera' },
    { kind:'audio', embedding:[0.8,0.2,0], confidence:0.8, salience:0.8, timestamp:1, source:'mic' }
  ]);
  assert.ok(fusion.coherence > 0.5);
  assert.ok(fusion.dominant.includes('text'));
  assert.ok(['integration','burst'].includes(fusion.phase));
});

test('device fabric prefers capable local WebGPU nodes', () => {
  const fabric = new NativeDeviceFabric();
  fabric.upsert({ id:'cpu', kind:'python-cpu', memoryMB:8192, compute:1, latencyMs:80, capabilities:['decode'], lastSeen:1 });
  fabric.upsert({ id:'tab', kind:'browser-webgpu', memoryMB:4096, compute:2, latencyMs:20, capabilities:['decode'], lastSeen:1 });
  const decision = fabric.place({ capability:'decode', memoryMB:1024, compute:1, preferLocal:true, maxLatencyMs:100 });
  assert.equal(decision.node?.id, 'tab');
});

test('horizon memory retains unresolved goals across compaction', () => {
  const memory = new HorizonMemory(2, 4);
  memory.append({ id:'goal', kind:'goal', text:'finish repository release', salience:1, unresolved:true, timestamp:1 });
  for (let i = 0; i < 10; i += 1) memory.append({ id:`obs-${i}`, kind:'observation', text:`observation ${i}`, salience:0.1, timestamp:i+2 });
  memory.compact();
  assert.ok(memory.state().unresolved.some((event) => event.id === 'goal'));
});

test('native engine emits efficiency receipt versus dense replay', () => {
  const engine = new NativeCognitionEngine();
  for (let i = 0; i < 32; i += 1) engine.delta.write([Math.cos(i), Math.sin(i), i / 32], [0.1,0.2,0.3]);
  const result = engine.step({ hidden:[0,0,0], proposal:[0.2,0.1,0.3], novelty:0.3, uncertainty:0.2 });
  assert.equal(result.receipt.schema, 'medina.native.decode.efficiency.v1');
  assert.ok(result.receipt.deltaAttentionOpsEstimate <= result.receipt.denseAttentionOpsEstimate);
  assert.ok(result.receipt.estimatedAttentionReduction >= 0);
});
