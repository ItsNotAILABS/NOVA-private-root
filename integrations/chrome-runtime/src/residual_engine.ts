export interface ResidualState {
  gain: number;
  confidence: number;
  updateRate: number;
  bypassRate: number;
  energy: number;
}

export interface ResidualDecision {
  output: number[];
  updated: boolean;
  gate: number;
  state: ResidualState;
}

const sigmoid = (value: number): number => 1 / (1 + Math.exp(-value));

const meanAbs = (values: readonly number[]): number => values.length ? values.reduce((sum, value) => sum + Math.abs(value), 0) / values.length : 0;

export class AdaptiveResidualEngine {
  private state: ResidualState = { gain: 1, confidence: 0.5, updateRate: 0, bypassRate: 0, energy: 1 };
  private updates = 0;
  private bypasses = 0;

  route(input: readonly number[], proposal: readonly number[], novelty: number, uncertainty: number): ResidualDecision {
    const delta = proposal.map((value, index) => value - (input[index] ?? 0));
    const deltaEnergy = meanAbs(delta);
    const gate = sigmoid(3.5 * novelty + 2.0 * uncertainty + 1.5 * deltaEnergy - 1.25);
    const updated = gate >= 0.35;

    if (updated) this.updates += 1;
    else this.bypasses += 1;

    const gain = Math.max(0.05, Math.min(1.5, this.state.gain * 0.995 + gate * 0.02));
    const output = input.map((base, index) => updated ? base + gain * gate * delta[index] : base);
    const total = Math.max(1, this.updates + this.bypasses);

    this.state = {
      gain,
      confidence: Math.max(0, Math.min(1, 1 - uncertainty)),
      updateRate: this.updates / total,
      bypassRate: this.bypasses / total,
      energy: deltaEnergy
    };
    return { output, updated, gate, state: { ...this.state } };
  }

  snapshot(): ResidualState { return { ...this.state }; }
}
