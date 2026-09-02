export interface DeltaAttentionConfig {
  capacity: number;
  topK: number;
  decay: number;
  noveltyThreshold: number;
  learningRate: number;
}

export interface DeltaMemoryEntry {
  key: number[];
  value: number[];
  utility: number;
  novelty: number;
  lastUsed: number;
  uses: number;
}

export interface DeltaAttentionResult {
  output: number[];
  selected: number[];
  attentionMass: number;
  memoryWrites: number;
  skippedTokens: number;
}

const dot = (a: readonly number[], b: readonly number[]): number => {
  let value = 0;
  const length = Math.min(a.length, b.length);
  for (let i = 0; i < length; i += 1) value += a[i] * b[i];
  return value;
};

const norm = (a: readonly number[]): number => Math.sqrt(Math.max(1e-12, dot(a, a)));

const cosine = (a: readonly number[], b: readonly number[]): number => dot(a, b) / (norm(a) * norm(b));

const softmax = (values: number[]): number[] => {
  if (!values.length) return [];
  const max = Math.max(...values);
  const exp = values.map((value) => Math.exp(value - max));
  const total = exp.reduce((sum, value) => sum + value, 0) || 1;
  return exp.map((value) => value / total);
};

export class DeltaAttentionMemory {
  private readonly entries: DeltaMemoryEntry[] = [];
  private writes = 0;

  constructor(private readonly config: DeltaAttentionConfig = {
    capacity: 2048,
    topK: 16,
    decay: 0.999,
    noveltyThreshold: 0.16,
    learningRate: 0.08
  }) {}

  size(): number { return this.entries.length; }

  snapshot(): DeltaMemoryEntry[] {
    return this.entries.map((entry) => ({ ...entry, key: [...entry.key], value: [...entry.value] }));
  }

  restore(entries: DeltaMemoryEntry[]): void {
    this.entries.length = 0;
    for (const entry of entries.slice(0, this.config.capacity)) {
      this.entries.push({ ...entry, key: [...entry.key], value: [...entry.value] });
    }
  }

  attend(query: readonly number[]): DeltaAttentionResult {
    if (!this.entries.length) {
      return { output: new Array(query.length).fill(0), selected: [], attentionMass: 0, memoryWrites: this.writes, skippedTokens: 0 };
    }

    const ranked = this.entries
      .map((entry, index) => ({ index, score: cosine(query, entry.key) * (0.75 + 0.25 * entry.utility) }))
      .sort((a, b) => b.score - a.score)
      .slice(0, this.config.topK);

    const weights = softmax(ranked.map((item) => item.score));
    const width = ranked.length ? this.entries[ranked[0].index].value.length : query.length;
    const output = new Array(width).fill(0);
    ranked.forEach((item, position) => {
      const entry = this.entries[item.index];
      const weight = weights[position];
      entry.lastUsed = Date.now();
      entry.uses += 1;
      entry.utility = Math.min(1.5, entry.utility * this.config.decay + this.config.learningRate * weight);
      for (let i = 0; i < Math.min(width, entry.value.length); i += 1) output[i] += entry.value[i] * weight;
    });

    return {
      output,
      selected: ranked.map((item) => item.index),
      attentionMass: weights.reduce((sum, value) => sum + value, 0),
      memoryWrites: this.writes,
      skippedTokens: Math.max(0, this.entries.length - ranked.length)
    };
  }

  write(key: readonly number[], value: readonly number[]): boolean {
    const bestSimilarity = this.entries.length
      ? Math.max(...this.entries.map((entry) => cosine(key, entry.key)))
      : 0;
    const novelty = 1 - Math.max(-1, Math.min(1, bestSimilarity));
    if (this.entries.length && novelty < this.config.noveltyThreshold) return false;

    if (this.entries.length >= this.config.capacity) {
      let victim = 0;
      let victimScore = Number.POSITIVE_INFINITY;
      const now = Date.now();
      this.entries.forEach((entry, index) => {
        const age = Math.max(1, now - entry.lastUsed);
        const score = entry.utility * Math.log2(entry.uses + 2) / Math.log2(age + 2);
        if (score < victimScore) { victim = index; victimScore = score; }
      });
      this.entries.splice(victim, 1);
    }

    this.entries.push({
      key: [...key],
      value: [...value],
      utility: 1,
      novelty,
      lastUsed: Date.now(),
      uses: 0
    });
    this.writes += 1;
    return true;
  }
}
