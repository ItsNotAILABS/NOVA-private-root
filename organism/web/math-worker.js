// ═══════════════════════════════════════════════════════════════════════════════
// NUMERUS OPERANS — Mathematical Computation Worker
// STRICT PROTOTYPE / CONFIDENTIAL — Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
// Self-hosted dfx local only. No IC mainnet. No external deployment.
//
// Fibonacci, primes, golden spiral, statistics, matrix multiply, φ series.
// Pure vanilla JS Web Worker — no DOM, no imports.
// ═══════════════════════════════════════════════════════════════════════════════

/* eslint-env worker */
'use strict';

// ─── MATH CONSTANTS ─────────────────────────────────────────────────────────────
const PHI          = 1.618033988749895;
const INV_PHI      = 0.618033988749895;
const TAU          = 6.283185307179586;
const HEARTBEAT_MS = 873;

// ─── MINI HEART — Kuramoto Phase Oscillator ─────────────────────────────────────
const MiniHeart = {
  phase: Math.random() * TAU,
  freq: TAU / HEARTBEAT_MS,
  tick() {
    this.phase = (this.phase + this.freq * HEARTBEAT_MS * 0.001) % TAU;
    return { phase: this.phase, pulse: Math.sin(this.phase) };
  }
};

// ─── STATE ──────────────────────────────────────────────────────────────────────
let tickCount = 0;
let opsCompleted = 0;

// ─── FIBONACCI ──────────────────────────────────────────────────────────────────
// Iterative O(n) computation; returns nth Fibonacci number
function fibonacci(n) {
  if (n < 0) return 0;
  if (n <= 1) return n;
  let a = 0, b = 1;
  for (let i = 2; i <= n; i++) {
    const t = a + b;
    a = b;
    b = t;
  }
  opsCompleted++;
  return b;
}

// ─── PRIME CHECK ────────────────────────────────────────────────────────────────
function isPrime(n) {
  if (n < 2) return false;
  if (n < 4) return true;
  if (n % 2 === 0 || n % 3 === 0) return false;
  for (let i = 5; i * i <= n; i += 6) {
    if (n % i === 0 || n % (i + 2) === 0) return false;
  }
  opsCompleted++;
  return true;
}

// ─── GOLDEN SPIRAL ──────────────────────────────────────────────────────────────
// Generates n points on a golden spiral (Fermat's spiral with golden angle)
function goldenSpiral(n) {
  const goldenAngle = TAU * INV_PHI;
  const points = [];
  for (let i = 0; i < n; i++) {
    const r = Math.sqrt(i);
    const theta = i * goldenAngle;
    points.push({ x: r * Math.cos(theta), y: r * Math.sin(theta), r, theta });
  }
  opsCompleted++;
  return points;
}

// ─── STATISTICS ─────────────────────────────────────────────────────────────────
function statistics(data) {
  if (!Array.isArray(data) || data.length === 0) return { error: 'Empty data' };
  const n = data.length;
  const sorted = data.slice().sort((a, b) => a - b);
  const sum = data.reduce((a, b) => a + b, 0);
  const mean = sum / n;
  const variance = data.reduce((s, x) => s + (x - mean) * (x - mean), 0) / n;
  const std = Math.sqrt(variance);
  const median = n % 2 === 1 ? sorted[Math.floor(n / 2)] : (sorted[n / 2 - 1] + sorted[n / 2]) / 2;
  const min = sorted[0];
  const max = sorted[n - 1];
  opsCompleted++;
  return { mean, std, median, min, max, sum, count: n, variance };
}

// ─── MATRIX MULTIPLY ────────────────────────────────────────────────────────────
// A (m×p) × B (p×n) → C (m×n)
function matrixMultiply(A, B) {
  if (!Array.isArray(A) || !Array.isArray(B)) return { error: 'Invalid matrices' };
  const m = A.length;
  const p = A[0] ? A[0].length : 0;
  if (p === 0 || B.length !== p) return { error: 'Dimension mismatch: A cols (' + p + ') != B rows (' + B.length + ')' };
  const n = B[0] ? B[0].length : 0;
  const C = [];
  for (let i = 0; i < m; i++) {
    C[i] = new Array(n).fill(0);
    for (let j = 0; j < n; j++) {
      for (let k = 0; k < p; k++) {
        C[i][j] += A[i][k] * B[k][j];
      }
    }
  }
  opsCompleted++;
  return { result: C, dimensions: [m, n] };
}

// ─── PRIME FACTORS ──────────────────────────────────────────────────────────────
function primeFactors(n) {
  if (n < 2) return [];
  const factors = [];
  let val = Math.abs(Math.floor(n));
  for (let d = 2; d * d <= val; d++) {
    while (val % d === 0) {
      factors.push(d);
      val /= d;
    }
  }
  if (val > 1) factors.push(val);
  opsCompleted++;
  return factors;
}

// ─── PHI POWER SERIES ───────────────────────────────────────────────────────────
// Computes φ^0, φ^1, ... φ^(n-1) and their sum (approaches φ^n * φ / (φ-1))
function phiSeries(n) {
  const terms = [];
  let sum = 0;
  let power = 1;
  for (let i = 0; i < n; i++) {
    terms.push(power);
    sum += power;
    power *= PHI;
  }
  opsCompleted++;
  return { terms, sum, ratio: n > 1 ? terms[n - 1] / terms[n - 2] : PHI };
}

// ─── MESSAGE HANDLER ────────────────────────────────────────────────────────────
self.onmessage = function (e) {
  const { cmd, n, data, A, B } = e.data || {};
  switch (cmd) {
    case 'FIBONACCI':
      self.postMessage({ cmd, n, result: fibonacci(n || 0) });
      break;
    case 'PRIME_CHECK':
      self.postMessage({ cmd, n, isPrime: isPrime(n || 0) });
      break;
    case 'GOLDEN_SPIRAL':
      self.postMessage({ cmd, n, points: goldenSpiral(n || 100) });
      break;
    case 'STATISTICS':
      self.postMessage({ cmd, result: statistics(data || []) });
      break;
    case 'MATRIX_MULTIPLY':
      self.postMessage({ cmd, result: matrixMultiply(A, B) });
      break;
    case 'PRIME_FACTORS':
      self.postMessage({ cmd, n, factors: primeFactors(n || 0) });
      break;
    case 'PHI_SERIES':
      self.postMessage({ cmd, n, result: phiSeries(n || 10) });
      break;
    case 'GET_STATUS': {
      const heart = MiniHeart.tick();
      self.postMessage({
        cmd, status: {
          worker: 'NUMERUS_OPERANS', tickCount, heartPhase: heart.phase,
          opsCompleted, phi: PHI, invPhi: INV_PHI
        }
      });
      break;
    }
    default:
      self.postMessage({ cmd, error: 'Unknown command: ' + cmd });
  }
};

// ─── HEARTBEAT ──────────────────────────────────────────────────────────────────
setInterval(() => {
  tickCount++;
  const heart = MiniHeart.tick();
  self.postMessage({ type: 'heartbeat', worker: 'NUMERUS_OPERANS', tick: tickCount, heart });
}, HEARTBEAT_MS);
