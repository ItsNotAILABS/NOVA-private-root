export type SenseKind = 'text' | 'vision' | 'audio' | 'telemetry' | 'code' | 'tool' | 'receipt';

export interface SensePacket {
  kind: SenseKind;
  embedding: number[];
  confidence: number;
  salience: number;
  timestamp: number;
  source: string;
}

export interface FusedSenseState {
  vector: number[];
  coherence: number;
  dominant: SenseKind[];
  phase: 'latent' | 'attentive' | 'burst' | 'integration' | 'consolidation' | 'recovery';
  senses: Record<SenseKind, number>;
}

const kinds: SenseKind[] = ['text','vision','audio','telemetry','code','tool','receipt'];

const cosine = (a: readonly number[], b: readonly number[]): number => {
  let dot = 0, aa = 0, bb = 0;
  const n = Math.min(a.length, b.length);
  for (let i = 0; i < n; i += 1) { dot += a[i] * b[i]; aa += a[i] * a[i]; bb += b[i] * b[i]; }
  return dot / Math.sqrt(Math.max(1e-12, aa * bb));
};

export class MESIEMultisenseFusion {
  fuse(packets: SensePacket[]): FusedSenseState {
    if (!packets.length) return { vector: [], coherence: 1, dominant: [], phase: 'latent', senses: Object.fromEntries(kinds.map((k) => [k,0])) as Record<SenseKind,number> };
    const width = Math.max(...packets.map((p) => p.embedding.length));
    const vector = new Array(width).fill(0);
    const senses = Object.fromEntries(kinds.map((k) => [k,0])) as Record<SenseKind,number>;
    let total = 0;
    for (const packet of packets) {
      const weight = Math.max(0, packet.confidence) * Math.max(0, packet.salience);
      senses[packet.kind] += weight;
      total += weight;
      for (let i = 0; i < packet.embedding.length; i += 1) vector[i] += packet.embedding[i] * weight;
    }
    const denominator = total || 1;
    for (let i = 0; i < vector.length; i += 1) vector[i] /= denominator;

    let pairs = 0, coherenceSum = 0;
    for (let i = 0; i < packets.length; i += 1) for (let j = i + 1; j < packets.length; j += 1) {
      coherenceSum += Math.max(-1, cosine(packets[i].embedding, packets[j].embedding)); pairs += 1;
    }
    const coherence = pairs ? (coherenceSum / pairs + 1) / 2 : 1;
    const dominant = [...kinds].sort((a,b) => senses[b] - senses[a]).filter((k) => senses[k] > 0).slice(0,3);
    const peak = Math.max(...Object.values(senses), 0);
    const phase: FusedSenseState['phase'] = coherence < 0.25 ? 'recovery' : peak > 1.5 && coherence > 0.65 ? 'burst' : packets.length >= 3 ? 'integration' : packets.length >= 2 ? 'attentive' : 'latent';
    return { vector, coherence, dominant, phase, senses };
  }
}
