import { describe, it, expect } from 'vitest';
import {
  LAW_COUNT,
  EMERGENCY_GATE,
  fnv1a32,
  fireLaws,
  tierComplianceScores,
  buildSnapshotFromSwarm,
  fireLaw121,
} from '../math/laws';

describe('Sovereign Laws Engine', () => {
  it('fires all 60 laws and returns full compliance for healthy snapshot', () => {
    const snapshot = buildSnapshotFromSwarm(0.9, 0.9, 0.9, 0.9, 0.1, 0.9, 0.9, true, 2000, 10);
    const result = fireLaws(snapshot);

    expect(result.results).toHaveLength(LAW_COUNT);
    expect(result.passingLaws).toBe(LAW_COUNT);
    expect(result.complianceScore).toBe(1);
    expect(result.emergencyState).toBe(false);
  });

  it('enters emergency state when passing laws fall below emergency gate', () => {
    const snapshot = {
      ...buildSnapshotFromSwarm(0.1, 0.1, 0.1, 0.1, 0.9, 0.1, 0.1, false, -10, 5),
      sovereignId: 'BROKEN_ID',
      aresAvailable: false,
      auditChainIntact: false,
      successionDefined: false,
      expansionReady: false,
      councilQuorum: false,
    };

    const result = fireLaws(snapshot);
    expect(result.passingLaws).toBeLessThan(EMERGENCY_GATE);
    expect(result.emergencyState).toBe(true);
  });

  it('computes deterministic FNV-1a fingerprints', () => {
    expect(fnv1a32([1, 2, 3, 4])).toBe(fnv1a32([1, 2, 3, 4]));
    expect(fnv1a32([1, 2, 3, 4])).not.toBe(fnv1a32([1, 2, 3, 5]));
  });

  it('returns six per-tier compliance scores', () => {
    const snapshot = buildSnapshotFromSwarm(0.8, 0.8, 0.8, 0.8, 0.2, 0.8, 0.9, true, 1500, 2);
    const result = fireLaws(snapshot);
    const scores = tierComplianceScores(result.results);
    expect(scores).toHaveLength(6);
    expect(scores.every((score) => score >= 0 && score <= 1)).toBe(true);
  });

  it('law 121 applies penalty when coherence is below threshold', () => {
    const passing = fireLaw121(0.8, 1);
    const failing = fireLaw121(0.2, 1);
    expect(passing.passed).toBe(true);
    expect(passing.penalty).toBe(0);
    expect(failing.passed).toBe(false);
    expect(failing.penalty).toBeGreaterThan(0);
  });
});
