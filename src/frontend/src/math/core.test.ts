// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  CORE MATH TEST SUITE                                                                                     ║
// ║  Tests for core mathematical functions mirroring Motoko backend                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

import { describe, it, expect } from 'vitest';
import {
  PHI, PHI_INV, EULER_E, PI, TAU, SQRT2, SQRT3, LN2,
  SOVEREIGN_FLOOR, KURAMOTO_K,
  clamp, sf, sigmoid, tanh, softmax, relu, norm, dot, vadd, vscale,
  wrapPhase, phaseDiff, logisticStep, ema, mahalanobisApprox, zScore,
  landauFreeEnergy, fisherInfo, klDivergence, computeJasmineDrift,
} from '../math/core';

// ═══════════════════════════════════════════════════════════════════════════════
// SACRED CONSTANTS TESTS
// ═══════════════════════════════════════════════════════════════════════════════

describe('Sacred Constants', () => {
  it('should have correct golden ratio φ', () => {
    expect(PHI).toBeCloseTo(1.6180339887498948482, 10);
  });

  it('should have correct inverse golden ratio 1/φ', () => {
    expect(PHI_INV).toBeCloseTo(0.6180339887498948482, 10);
  });

  it('should satisfy φ * (1/φ) = 1', () => {
    expect(PHI * PHI_INV).toBeCloseTo(1.0, 10);
  });

  it('should have correct Euler number e', () => {
    expect(EULER_E).toBeCloseTo(2.7182818284590452354, 10);
  });

  it('should have correct π', () => {
    expect(PI).toBeCloseTo(Math.PI, 10);
  });

  it('should have τ = 2π', () => {
    expect(TAU).toBeCloseTo(2 * Math.PI, 10);
  });

  it('should have correct √2', () => {
    expect(SQRT2).toBeCloseTo(Math.sqrt(2), 10);
  });

  it('should have correct √3', () => {
    expect(SQRT3).toBeCloseTo(Math.sqrt(3), 10);
  });

  it('should have correct ln(2)', () => {
    expect(LN2).toBeCloseTo(Math.log(2), 10);
  });

  it('should have sovereign floor = 1.0', () => {
    expect(SOVEREIGN_FLOOR).toBe(1.0);
  });

  it('should have Kuramoto K = φ^(-1)', () => {
    expect(KURAMOTO_K).toBeCloseTo(PHI_INV, 10);
  });
});

// ═══════════════════════════════════════════════════════════════════════════════
// PRIMITIVE MATH TESTS
// ═══════════════════════════════════════════════════════════════════════════════

describe('Primitive Math Functions', () => {
  describe('clamp', () => {
    it('should return value when within range', () => {
      expect(clamp(5, 0, 10)).toBe(5);
    });

    it('should clamp to minimum when below range', () => {
      expect(clamp(-5, 0, 10)).toBe(0);
    });

    it('should clamp to maximum when above range', () => {
      expect(clamp(15, 0, 10)).toBe(10);
    });

    it('should handle edge case at boundaries', () => {
      expect(clamp(0, 0, 10)).toBe(0);
      expect(clamp(10, 0, 10)).toBe(10);
    });
  });

  describe('sf (sovereign floor)', () => {
    it('should enforce minimum S₀ = 1.0', () => {
      expect(sf(0.5)).toBe(1.0);
    });

    it('should return value when above floor', () => {
      expect(sf(2.5)).toBe(2.5);
    });

    it('should handle exact floor value', () => {
      expect(sf(1.0)).toBe(1.0);
    });

    it('should handle negative values', () => {
      expect(sf(-5.0)).toBe(1.0);
    });
  });

  describe('sigmoid', () => {
    it('should return 0.5 at x=0', () => {
      expect(sigmoid(0)).toBeCloseTo(0.5, 5);
    });

    it('should approach 1 for large positive x', () => {
      expect(sigmoid(10)).toBeGreaterThan(0.999);
    });

    it('should approach 0 for large negative x', () => {
      expect(sigmoid(-10)).toBeLessThan(0.001);
    });

    it('should be monotonically increasing', () => {
      expect(sigmoid(1)).toBeGreaterThan(sigmoid(0));
      expect(sigmoid(2)).toBeGreaterThan(sigmoid(1));
    });
  });

  describe('tanh', () => {
    it('should return 0 at x=0', () => {
      expect(tanh(0)).toBeCloseTo(0, 5);
    });

    it('should approach 1 for large positive x', () => {
      expect(tanh(10)).toBeGreaterThan(0.999);
    });

    it('should approach -1 for large negative x', () => {
      expect(tanh(-10)).toBeLessThan(-0.999);
    });

    it('should be symmetric: tanh(-x) = -tanh(x)', () => {
      expect(tanh(-2)).toBeCloseTo(-tanh(2), 5);
    });
  });

  describe('softmax', () => {
    it('should return probabilities summing to 1', () => {
      const result = softmax([1, 2, 3]);
      const sum = result.reduce((a, b) => a + b, 0);
      expect(sum).toBeCloseTo(1.0, 5);
    });

    it('should give highest probability to largest input', () => {
      const result = softmax([1, 2, 3]);
      expect(result[2]).toBeGreaterThan(result[1]);
      expect(result[1]).toBeGreaterThan(result[0]);
    });

    it('should handle uniform inputs', () => {
      const result = softmax([1, 1, 1]);
      expect(result[0]).toBeCloseTo(result[1], 5);
      expect(result[1]).toBeCloseTo(result[2], 5);
    });
  });

  describe('relu', () => {
    it('should return x for positive x', () => {
      expect(relu(5)).toBe(5);
    });

    it('should return 0 for negative x', () => {
      expect(relu(-5)).toBe(0);
    });

    it('should return 0 for x=0', () => {
      expect(relu(0)).toBe(0);
    });

    it('should support leaky ReLU', () => {
      expect(relu(-5, 0.01)).toBeCloseTo(-0.05, 5);
    });
  });
});

// ═══════════════════════════════════════════════════════════════════════════════
// VECTOR OPERATIONS TESTS
// ═══════════════════════════════════════════════════════════════════════════════

describe('Vector Operations', () => {
  describe('norm', () => {
    it('should compute Euclidean norm', () => {
      expect(norm([3, 4])).toBe(5);
    });

    it('should return 0 for zero vector', () => {
      expect(norm([0, 0, 0])).toBe(0);
    });

    it('should handle single-element vector', () => {
      expect(norm([5])).toBe(5);
    });
  });

  describe('dot', () => {
    it('should compute dot product', () => {
      expect(dot([1, 2, 3], [4, 5, 6])).toBe(32);
    });

    it('should return 0 for orthogonal vectors', () => {
      expect(dot([1, 0], [0, 1])).toBe(0);
    });

    it('should handle unequal lengths gracefully', () => {
      expect(dot([1, 2], [3])).toBe(3);
    });
  });

  describe('vadd', () => {
    it('should add vectors element-wise', () => {
      expect(vadd([1, 2], [3, 4])).toEqual([4, 6]);
    });

    it('should handle unequal lengths', () => {
      expect(vadd([1, 2, 3], [4, 5])).toEqual([5, 7, 3]);
    });
  });

  describe('vscale', () => {
    it('should scale vector by scalar', () => {
      expect(vscale([1, 2, 3], 2)).toEqual([2, 4, 6]);
    });

    it('should handle scaling by 0', () => {
      expect(vscale([1, 2, 3], 0)).toEqual([0, 0, 0]);
    });

    it('should handle negative scalar', () => {
      expect(vscale([1, 2], -1)).toEqual([-1, -2]);
    });
  });
});

// ═══════════════════════════════════════════════════════════════════════════════
// PHASE AND KURAMOTO TESTS
// ═══════════════════════════════════════════════════════════════════════════════

describe('Phase Functions', () => {
  describe('wrapPhase', () => {
    it('should wrap phase into [-π, π]', () => {
      expect(wrapPhase(0)).toBeCloseTo(0, 5);
      expect(wrapPhase(PI)).toBeCloseTo(PI, 5);
      expect(wrapPhase(-PI)).toBeCloseTo(-PI, 5);
    });

    it('should wrap phase > π', () => {
      expect(wrapPhase(TAU)).toBeCloseTo(0, 5);
      expect(wrapPhase(PI + 0.5)).toBeCloseTo(-(PI - 0.5), 5);
    });

    it('should wrap phase < -π', () => {
      expect(wrapPhase(-TAU)).toBeCloseTo(0, 5);
    });
  });

  describe('phaseDiff', () => {
    it('should compute wrapped phase difference', () => {
      expect(phaseDiff(0, 0)).toBeCloseTo(0, 5);
      expect(phaseDiff(PI, 0)).toBeCloseTo(PI, 5);
    });

    it('should handle wrapping', () => {
      expect(phaseDiff(TAU, 0)).toBeCloseTo(0, 5);
    });
  });
});

// ═══════════════════════════════════════════════════════════════════════════════
// DYNAMICAL SYSTEMS TESTS
// ═══════════════════════════════════════════════════════════════════════════════

describe('Dynamical Systems', () => {
  describe('logisticStep', () => {
    it('should grow population when below carrying capacity', () => {
      const n0 = 10;
      const n1 = logisticStep(n0, 0.1, 100, 1);
      expect(n1).toBeGreaterThan(n0);
    });

    it('should stabilize at carrying capacity', () => {
      const n0 = 100;
      const n1 = logisticStep(n0, 0.1, 100, 1);
      expect(n1).toBeCloseTo(n0, 5);
    });

    it('should decrease when above carrying capacity', () => {
      const n0 = 150;
      const n1 = logisticStep(n0, 0.1, 100, 1);
      expect(n1).toBeLessThan(n0);
    });
  });

  describe('ema (exponential moving average)', () => {
    it('should weight recent values', () => {
      const result = ema(0, 10, 1);
      expect(result).toBeGreaterThan(0);
      expect(result).toBeLessThan(10);
    });

    it('should approach current value with small tau', () => {
      const result = ema(0, 10, 0.01);
      expect(result).toBeCloseTo(10, 0);
    });

    it('should approach previous value with large tau', () => {
      const result = ema(0, 10, 100);
      expect(result).toBeLessThan(1);
    });
  });
});

// ═══════════════════════════════════════════════════════════════════════════════
// STATISTICAL TESTS
// ═══════════════════════════════════════════════════════════════════════════════

describe('Statistical Functions', () => {
  describe('mahalanobisApprox', () => {
    it('should return 0 for values at mean', () => {
      expect(mahalanobisApprox([0], [0], [1])).toBeCloseTo(0, 5);
    });

    it('should return higher distance for outliers', () => {
      const normal = mahalanobisApprox([1], [0], [1]);
      const outlier = mahalanobisApprox([5], [0], [1]);
      expect(outlier).toBeGreaterThan(normal);
    });
  });

  describe('zScore', () => {
    it('should return 0 for value at mean', () => {
      expect(zScore(5, 5, 1)).toBeCloseTo(0, 5);
    });

    it('should return positive for value above mean', () => {
      expect(zScore(7, 5, 1)).toBeCloseTo(2, 5);
    });

    it('should return negative for value below mean', () => {
      expect(zScore(3, 5, 1)).toBeCloseTo(-2, 5);
    });
  });

  describe('klDivergence', () => {
    it('should return 0 for identical distributions', () => {
      expect(klDivergence([0.5, 0.5], [0.5, 0.5])).toBeCloseTo(0, 5);
    });

    it('should be positive for different distributions', () => {
      expect(klDivergence([0.9, 0.1], [0.5, 0.5])).toBeGreaterThan(0);
    });
  });
});

// ═══════════════════════════════════════════════════════════════════════════════
// PHYSICS AND FREE ENERGY TESTS
// ═══════════════════════════════════════════════════════════════════════════════

describe('Physics Functions', () => {
  describe('landauFreeEnergy', () => {
    it('should compute Landau free energy', () => {
      expect(landauFreeEnergy(0, 1, 1)).toBe(0);
      expect(landauFreeEnergy(1, 1, 1)).toBe(2);
    });

    it('should be symmetric in m', () => {
      expect(landauFreeEnergy(1, 1, 1)).toBeCloseTo(landauFreeEnergy(-1, 1, 1), 5);
    });
  });

  describe('fisherInfo', () => {
    it('should be high at p=0.5', () => {
      expect(fisherInfo(0.5)).toBeCloseTo(4, 5);
    });

    it('should be lower near boundaries', () => {
      expect(fisherInfo(0.9)).toBeLessThan(fisherInfo(0.5));
    });
  });
});

// ═══════════════════════════════════════════════════════════════════════════════
// JASMINE DRIFT TESTS
// ═══════════════════════════════════════════════════════════════════════════════

describe('Jasmine Drift', () => {
  describe('computeJasmineDrift', () => {
    it('should return 0 for perfectly synchronized system', () => {
      const phases = [0, 0, 0];
      const cortisols = [1, 1, 1];
      const signals = [0.5, 0.5, 0.5];
      expect(computeJasmineDrift(phases, cortisols, signals)).toBeCloseTo(0, 5);
    });

    it('should return positive for desynchronized system', () => {
      const phases = [0, PI / 2, PI];
      const cortisols = [0.5, 1.0, 1.5];
      const signals = [0.3, 0.5, 0.7];
      expect(computeJasmineDrift(phases, cortisols, signals)).toBeGreaterThan(0);
    });

    it('should increase with phase variance', () => {
      const lowVar = computeJasmineDrift([0, 0.1, 0.2], [1, 1, 1], [0.5, 0.5, 0.5]);
      const highVar = computeJasmineDrift([0, PI, 2*PI], [1, 1, 1], [0.5, 0.5, 0.5]);
      expect(highVar).toBeGreaterThan(lowVar);
    });
  });
});
