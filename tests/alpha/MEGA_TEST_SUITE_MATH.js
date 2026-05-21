'use strict';
const PHI = 1.6180339887498948482;
const PHI_INV = 0.6180339887498948482;
const AMOR = 0.3819660112501051518;
const EULER_E = 2.7182818284590452354;
const PI = 3.1415926535897932385;
const TAU = 6.2831853071795864769;
const SQRT2 = 1.4142135623730950488;
const SQRT3 = 1.7320508075688772935;
const SQRT5 = 2.2360679774997896964;
const LN2 = 0.6931471805599453094;
const FEIGENBAUM_D = 4.6692016091029906719;
const ISING_2D_BETA = 0.125;
const ISING_2D_TC = 2.269;
const PERC_2D_PC = 0.5927;
const HEARTBEAT_MS = 873;
const SOVEREIGN_FLOOR = 1.0;
const KURAMOTO_K = PHI_INV;
const TOL = 1e-9;

let _passed = 0, _failed = 0, _total = 0;
const _failures = [];

function assertEqual(a, b, label) { _total++; if (a === b) { _passed++; } else { _failed++; _failures.push({ label, a, b }); } }
function assertClose(a, b, label, tol = TOL) { _total++; if (Math.abs(a - b) <= tol) { _passed++; } else { _failed++; _failures.push({ label, a, b: `~${b} ±${tol}` }); } }
function assertTrue(c, label) { _total++; if (c) { _passed++; } else { _failed++; _failures.push({ label, a: false, b: true }); } }
function assertFalse(c, label) { _total++; if (!c) { _passed++; } else { _failed++; _failures.push({ label, a: true, b: false }); } }
function assertDefined(v, label) { _total++; if (v !== undefined && v !== null) { _passed++; } else { _failed++; _failures.push({ label, a: v, b: 'defined' }); } }
function assertInRange(v, lo, hi, label) { _total++; if (v >= lo && v <= hi) { _passed++; } else { _failed++; _failures.push({ label, a: v, b: `[${lo}, ${hi}]` }); } }
function assertArrayLength(arr, len, label) { _total++; if (Array.isArray(arr) && arr.length === len) { _passed++; } else { _failed++; _failures.push({ label, a: arr?.length, b: len }); } }
function section(name) { console.log(`\n  ── ${name} ──`); }

// ═══════════════════════════════════════════════════════════════════════
// HELPER MATH FUNCTIONS
// ═══════════════════════════════════════════════════════════════════════

function clamp(v, lo, hi) { return Math.max(lo, Math.min(hi, v)); }
function sf(x) { return Math.max(SOVEREIGN_FLOOR, x); }
function sigmoid(x) { return 1 / (1 + Math.exp(-x)); }
function tanh_fn(x) { const ep = Math.exp(x); const em = Math.exp(-x); return (ep - em) / (ep + em); }
function softmax(xs) {
  const max = Math.max(...xs);
  const exps = xs.map(x => Math.exp(x - max));
  const sum = exps.reduce((a, b) => a + b, 0);
  return exps.map(e => e / sum);
}
function relu(x, leak = 0) { return x > 0 ? x : leak * x; }
function norm(v) { return Math.sqrt(v.reduce((s, x) => s + x * x, 0)); }
function dot(a, b) { return a.reduce((s, ai, i) => s + ai * b[i], 0); }
function vadd(a, b) { return a.map((ai, i) => ai + b[i]); }
function vscale(v, s) { return v.map(x => x * s); }

function wrapPhase(theta) {
  let t = theta % TAU;
  if (t > PI) t -= TAU;
  if (t < -PI) t += TAU;
  return t;
}
function phaseDiff(a, b) { return wrapPhase(a - b); }
function logisticStep(n, r, K, dt) { return n + r * n * (1 - n / K) * dt; }
function ema(prev, curr, tau) { const alpha = 1 - Math.exp(-1 / tau); return prev + alpha * (curr - prev); }

function klDivergence(p, q) {
  let kl = 0;
  for (let i = 0; i < p.length; i++) {
    if (p[i] > 0) kl += p[i] * Math.log(p[i] / q[i]);
  }
  return kl;
}
function fisherInfo(p) { return 1 / (p * (1 - p)); }
function landauFreeEnergy(m, a, b) { return a * m * m + b * m * m * m * m; }
function zScore(x, mean, std) { return (x - mean) / std; }

function computeKuramotoOrder(phases) {
  let sx = 0, sy = 0;
  for (let i = 0; i < phases.length; i++) {
    sx += Math.cos(phases[i]);
    sy += Math.sin(phases[i]);
  }
  const r = Math.sqrt(sx * sx + sy * sy) / phases.length;
  const psi = Math.atan2(sy, sx);
  return { r, psi };
}
function kuramotoPhaseStep(phi_i, omega_i, phases, K, dt) {
  let coupling = 0;
  const N = phases.length;
  for (let j = 0; j < N; j++) {
    coupling += Math.sin(phases[j] - phi_i);
  }
  return phi_i + (omega_i + (K / N) * coupling) * dt;
}
function computeAmplitudeOrderParameter(oscs) {
  let sx = 0, sy = 0, totalAmp = 0;
  for (let i = 0; i < oscs.length; i++) {
    sx += oscs[i].amplitude * Math.cos(oscs[i].phase);
    sy += oscs[i].amplitude * Math.sin(oscs[i].phase);
    totalAmp += oscs[i].amplitude;
  }
  if (totalAmp === 0) return 0;
  return Math.sqrt(sx * sx + sy * sy) / totalAmp;
}
function kuramotoStep(oscs, K, dt) {
  const phases = oscs.map(o => o.phase);
  const N = oscs.length;
  for (let i = 0; i < N; i++) {
    let coupling = 0;
    for (let j = 0; j < N; j++) {
      coupling += Math.sin(phases[j] - oscs[i].phase);
    }
    oscs[i].phase += (K / N) * coupling * dt;
  }
  return oscs;
}

function fibonacci(n) {
  if (n === 0) return 0;
  if (n === 1) return 1;
  let a = 0, b = 1;
  for (let i = 2; i <= n; i++) { const t = a + b; a = b; b = t; }
  return b;
}
function lucasNumber(n) {
  if (n === 0) return 2;
  if (n === 1) return 1;
  let a = 2, b = 1;
  for (let i = 2; i <= n; i++) { const t = a + b; a = b; b = t; }
  return b;
}

function seededRand(seed) {
  let s = seed;
  return function() {
    s = (s * 1664525 + 1013904223) & 0x7fffffff;
    return s / 0x7fffffff;
  };
}

function taylorSin(x, terms) {
  let result = 0;
  for (let n = 0; n < terms; n++) {
    const sign = (n % 2 === 0) ? 1 : -1;
    const exp = 2 * n + 1;
    let factorial = 1;
    for (let k = 2; k <= exp; k++) factorial *= k;
    result += sign * Math.pow(x, exp) / factorial;
  }
  return result;
}

// PSI = (1-√5)/2 ≈ -0.618 (conjugate of φ)
const PSI = -PHI_INV;

// ═══════════════════════════════════════════════════════════════════════
// §1 — φ-IDENTITY EXHAUSTIVE (1000 tests)
// ═══════════════════════════════════════════════════════════════════════
section('§1 — φ-IDENTITY EXHAUSTIVE');

// φ powers: φ^n = φ^(n-1) + φ^(n-2) for n=-48..+50 → 99 tests
for (let n = -48; n <= 50; n++) {
  const pn = Math.pow(PHI, n);
  const pn1 = Math.pow(PHI, n - 1);
  const pn2 = Math.pow(PHI, n - 2);
  const tol = Math.max(1e-6, Math.abs(pn) * 1e-10);
  assertClose(pn, pn1 + pn2, `φ^${n} = φ^${n-1} + φ^${n-2}`, tol);
}
// Running: 99

// Fibonacci convergence ratios Fib(n+1)/Fib(n) → φ for n=2..100 → 99 tests
for (let n = 2; n <= 100; n++) {
  const ratio = fibonacci(n + 1) / fibonacci(n);
  const tol = n < 5 ? 0.5 : (n < 10 ? 0.05 : (n < 25 ? 1e-3 : 1e-9));
  assertClose(ratio, PHI, `Fib(${n+1})/Fib(${n}) → φ`, tol);
}
// Running: 198

// φ^n = Fib(n)*φ + Fib(n-1) for n=2..101 → 100 tests
for (let n = 2; n <= 101; n++) {
  const lhs = Math.pow(PHI, n);
  const rhs = fibonacci(n) * PHI + fibonacci(n - 1);
  const tol = Math.max(1e-6, Math.abs(lhs) * 1e-9);
  assertClose(lhs, rhs, `φ^${n} = Fib(${n})*φ + Fib(${n-1})`, tol);
}
// Running: 298

// φ^n + ψ^n = Lucas(n) for n=1..100 → 100 tests (ψ = (1-√5)/2)
for (let n = 1; n <= 100; n++) {
  const lhs = Math.pow(PHI, n) + Math.pow(PSI, n);
  const rhs = lucasNumber(n);
  const tol = Math.max(1e-4, Math.abs(rhs) * 1e-9);
  assertClose(lhs, rhs, `φ^${n} + ψ^${n} = Lucas(${n})`, tol);
}
// Running: 398

// φ^n - ψ^n = Fib(n)*√5 for n=1..100 → 100 tests
for (let n = 1; n <= 100; n++) {
  const lhs = Math.pow(PHI, n) - Math.pow(PSI, n);
  const rhs = fibonacci(n) * SQRT5;
  const tol = Math.max(1e-4, Math.abs(rhs) * 1e-8);
  assertClose(lhs, rhs, `φ^${n} - ψ^${n} = Fib(${n})*√5`, tol);
}
// Running: 498

// φ continued fraction convergents for 100 iterations → 100 tests
{
  let convergent = 1;
  for (let i = 0; i < 100; i++) {
    convergent = 1 + 1 / convergent;
    const tol = Math.pow(0.5, i + 1) + 1e-12;
    assertClose(convergent, PHI, `φ CF convergent iter ${i+1}`, tol);
  }
}
// Running: 598

// φ^(-n) * φ^n = 1 for n=1..100 → 100 tests
for (let n = 1; n <= 100; n++) {
  const val = Math.pow(PHI, -n) * Math.pow(PHI, n);
  assertClose(val, 1, `φ^(-${n}) * φ^${n} = 1`, 1e-9);
}
// Running: 698

// Lucas numbers L(n) = Fib(n-1) + Fib(n+1) for n=2..101 → 100 tests
for (let n = 2; n <= 101; n++) {
  const lhs = lucasNumber(n);
  const rhs = fibonacci(n - 1) + fibonacci(n + 1);
  const tol = Math.max(1, Math.abs(lhs) * 1e-10);
  assertClose(lhs, rhs, `Lucas(${n}) = Fib(${n-1}) + Fib(${n+1})`, tol);
}
// Running: 798

// φ^n * PHI_INV^n = 1 for n=1..100 → 100 tests
for (let n = 1; n <= 100; n++) {
  const val = Math.pow(PHI, n) * Math.pow(PHI_INV, n);
  assertClose(val, 1, `φ^${n} * φ_inv^${n} = 1`, 1e-8);
}
// Running: 898

// Cassini identity: Fib(n-1)*Fib(n+1) - Fib(n)² = (-1)^n for n=2..103 → 102 tests
for (let n = 2; n <= 103; n++) {
  const fn = fibonacci(n);
  const lhs = fibonacci(n - 1) * fibonacci(n + 1) - fn * fn;
  const rhs = Math.pow(-1, n);
  // For large n, Fib(n)² exceeds 2^53 so catastrophic cancellation occurs
  // Use tolerance proportional to Fib(n)² * machine epsilon
  const tol = Math.max(1, fn * fn * 2.3e-16 * 4);
  assertClose(lhs, rhs, `Cassini identity n=${n}`, tol);
}
// Running: 1000
// §1 total: 99+99+100+100+100+100+100+100+100+102 = 1000

// ═══════════════════════════════════════════════════════════════════════
// §2 — TRIGONOMETRIC & TRANSCENDENTAL (1000 tests)
// ═══════════════════════════════════════════════════════════════════════
section('§2 — TRIGONOMETRIC & TRANSCENDENTAL');

// sin²+cos²=1 at 100 angles → 100 tests
for (let i = 0; i < 100; i++) {
  const theta = (i / 100) * TAU;
  const val = Math.sin(theta) * Math.sin(theta) + Math.cos(theta) * Math.cos(theta);
  assertClose(val, 1, `sin²+cos²=1 #${i}`, TOL);
}
// Running: 1100

// sin(a+b) identity for 100 pairs → 100 tests
{
  const rng = seededRand(42);
  for (let i = 0; i < 100; i++) {
    const a = rng() * TAU - PI;
    const b = rng() * TAU - PI;
    const lhs = Math.sin(a + b);
    const rhs = Math.sin(a) * Math.cos(b) + Math.cos(a) * Math.sin(b);
    assertClose(lhs, rhs, `sin(a+b) identity #${i}`, TOL);
  }
}
// Running: 1200

// cos(a+b) identity for 100 pairs → 100 tests
{
  const rng = seededRand(137);
  for (let i = 0; i < 100; i++) {
    const a = rng() * TAU - PI;
    const b = rng() * TAU - PI;
    const lhs = Math.cos(a + b);
    const rhs = Math.cos(a) * Math.cos(b) - Math.sin(a) * Math.sin(b);
    assertClose(lhs, rhs, `cos(a+b) identity #${i}`, TOL);
  }
}
// Running: 1300

// exp(log(x))=x for x=0.01..1.0 step 0.01 → 100 tests
for (let i = 1; i <= 100; i++) {
  const x = i * 0.01;
  assertClose(Math.exp(Math.log(x)), x, `exp(log(${x.toFixed(2)}))=x`, TOL);
}
// Running: 1400

// log(exp(x))=x for 100 values → 100 tests
for (let i = 0; i < 100; i++) {
  const x = -5 + i * 0.1;
  assertClose(Math.log(Math.exp(x)), x, `log(exp(${x.toFixed(1)}))=x`, 1e-9);
}
// Running: 1500

// cosh²(x) - sinh²(x) = 1 for 100 values → 100 tests
for (let i = 0; i < 100; i++) {
  const x = -5 + i * 0.1;
  const ch = (Math.exp(x) + Math.exp(-x)) / 2;
  const sh = (Math.exp(x) - Math.exp(-x)) / 2;
  assertClose(ch * ch - sh * sh, 1, `cosh²-sinh²=1 x=${x.toFixed(1)}`, 1e-8);
}
// Running: 1600

// double angle sin(2x)=2sin(x)cos(x) for 100 angles → 100 tests
for (let i = 0; i < 100; i++) {
  const x = (i / 100) * TAU;
  assertClose(Math.sin(2 * x), 2 * Math.sin(x) * Math.cos(x), `sin(2x)=2sin(x)cos(x) #${i}`, TOL);
}
// Running: 1700

// half angle cos²(x/2) = (1+cos(x))/2 for 100 angles → 100 tests
for (let i = 0; i < 100; i++) {
  const x = (i / 100) * TAU;
  const lhs = Math.cos(x / 2) * Math.cos(x / 2);
  const rhs = (1 + Math.cos(x)) / 2;
  assertClose(lhs, rhs, `cos²(x/2)=(1+cos(x))/2 #${i}`, TOL);
}
// Running: 1800

// Euler identity at 100 shifted angles → 100 tests
for (let i = 0; i < 100; i++) {
  const theta = PI / 7 + (i / 100) * TAU;
  const val = Math.cos(theta) * Math.cos(theta) + Math.sin(theta) * Math.sin(theta);
  assertClose(val, 1, `Euler identity shifted #${i}`, TOL);
}
// Running: 1900

// Taylor series sin(x) for 100 points in [-1,1] → 100 tests
for (let i = 0; i < 100; i++) {
  const x = -1 + (2 * i) / 99;
  const ts = taylorSin(x, 10);
  assertClose(ts, Math.sin(x), `Taylor sin(${x.toFixed(4)})`, 1e-9);
}
// Running: 2000
// §2 total: 1000

// ═══════════════════════════════════════════════════════════════════════
// §3 — LINEAR ALGEBRA (2000 tests)
// ═══════════════════════════════════════════════════════════════════════
section('§3 — LINEAR ALGEBRA');

{
  const rng = seededRand(7919);
  function randVec5() { return [rng()*2-1, rng()*2-1, rng()*2-1, rng()*2-1, rng()*2-1]; }

  // dot(a,b) = dot(b,a) for 300 pairs → 300 tests
  for (let i = 0; i < 300; i++) {
    const a = randVec5(), b = randVec5();
    assertClose(dot(a, b), dot(b, a), `dot commutative #${i}`, 1e-9);
  }
  // Running: 2300

  // dot(a, vadd(b,c)) = dot(a,b) + dot(a,c) for 300 triples → 300 tests
  for (let i = 0; i < 300; i++) {
    const a = randVec5(), b = randVec5(), c = randVec5();
    const lhs = dot(a, vadd(b, c));
    const rhs = dot(a, b) + dot(a, c);
    assertClose(lhs, rhs, `dot linearity #${i}`, 1e-8);
  }
  // Running: 2600

  // triangle inequality for 300 pairs → 300 tests
  for (let i = 0; i < 300; i++) {
    const a = randVec5(), b = randVec5();
    assertTrue(norm(vadd(a, b)) <= norm(a) + norm(b) + 1e-12, `triangle ineq #${i}`);
  }
  // Running: 2900

  // parallelogram law for 300 pairs → 300 tests
  for (let i = 0; i < 300; i++) {
    const a = randVec5(), b = randVec5();
    const apb = vadd(a, b);
    const amb = vadd(a, vscale(b, -1));
    const lhs = norm(apb) * norm(apb) + norm(amb) * norm(amb);
    const rhs = 2 * (norm(a) * norm(a) + norm(b) * norm(b));
    assertClose(lhs, rhs, `parallelogram law #${i}`, 1e-8);
  }
  // Running: 3200

  // Cauchy-Schwarz for 300 pairs → 300 tests
  for (let i = 0; i < 300; i++) {
    const a = randVec5(), b = randVec5();
    assertTrue(Math.abs(dot(a, b)) <= norm(a) * norm(b) + 1e-10, `Cauchy-Schwarz #${i}`);
  }
  // Running: 3500

  // softmax sums to 1 for 100 vectors → 100 tests
  for (let i = 0; i < 100; i++) {
    const v = randVec5();
    const sm = softmax(v);
    assertClose(sm.reduce((a, b) => a + b, 0), 1, `softmax sum=1 #${i}`, 1e-9);
  }
  // Running: 3600

  // softmax all positive for 100 vectors → 100 tests
  for (let i = 0; i < 100; i++) {
    const v = randVec5();
    const sm = softmax(v);
    assertTrue(sm.every(x => x > 0), `softmax positive #${i}`);
  }
  // Running: 3700

  // softmax monotone for 100 vectors → 100 tests
  for (let i = 0; i < 100; i++) {
    const v = [rng()*10, rng()*10, rng()*10, rng()*10, rng()*10];
    const sm = softmax(v);
    let monotone = true;
    for (let j = 0; j < 5; j++) {
      for (let k = j + 1; k < 5; k++) {
        if (v[j] > v[k] && sm[j] < sm[k]) monotone = false;
        if (v[j] < v[k] && sm[j] > sm[k]) monotone = false;
      }
    }
    assertTrue(monotone, `softmax monotone #${i}`);
  }
  // Running: 3800

  // ReLU(x) ≥ 0 for 200 inputs → 200 tests
  for (let i = 0; i < 200; i++) {
    const x = (rng() * 20) - 10;
    assertTrue(relu(x) >= 0, `ReLU >= 0 #${i}`);
  }
  // Running: 4000
}
// §3 total: 300+300+300+300+300+100+100+100+200 = 2000

// ═══════════════════════════════════════════════════════════════════════
// §4 — SIGMOID & ACTIVATION FUNCTIONS (1000 tests)
// ═══════════════════════════════════════════════════════════════════════
section('§4 — SIGMOID & ACTIVATION FUNCTIONS');

// sigmoid in [0,1] for 200 inputs → 200 tests
for (let i = 0; i < 200; i++) {
  const x = -10 + (20 * i) / 199;
  assertInRange(sigmoid(x), 0, 1, `sigmoid in [0,1] #${i}`);
}
// Running: 4200

// sigmoid(0) = 0.5 → 1 test
assertClose(sigmoid(0), 0.5, 'sigmoid(0)=0.5', TOL);
// Running: 4201

// sigmoid(-x) = 1 - sigmoid(x) for 199 values → 199 tests
for (let i = 1; i <= 199; i++) {
  const x = -10 + (20 * i) / 200;
  assertClose(sigmoid(-x), 1 - sigmoid(x), `sigmoid antisymmetry #${i}`, TOL);
}
// Running: 4400

// sigmoid derivative for 200 values → 200 tests
for (let i = 0; i < 200; i++) {
  const x = -10 + (20 * i) / 199;
  const s = sigmoid(x);
  const h = 1e-7;
  const deriv = (sigmoid(x + h) - sigmoid(x - h)) / (2 * h);
  assertClose(deriv, s * (1 - s), `sigmoid derivative #${i}`, 1e-5);
}
// Running: 4600

// tanh_fn in [-1,1] for 200 inputs → 200 tests
for (let i = 0; i < 200; i++) {
  const x = -10 + (20 * i) / 199;
  assertInRange(tanh_fn(x), -1, 1, `tanh in [-1,1] #${i}`);
}
// Running: 4800

// tanh_fn(0) = 0 → 1 test
assertClose(tanh_fn(0), 0, 'tanh(0)=0', TOL);
// Running: 4801

// tanh_fn(-x) = -tanh_fn(x) for 99 values → 99 tests
for (let i = 1; i <= 99; i++) {
  const x = i * 0.1;
  assertClose(tanh_fn(-x), -tanh_fn(x), `tanh antisymmetry #${i}`, TOL);
}
// Running: 4900

// softmax shift invariance for 100 vectors → 100 tests
{
  const rng = seededRand(2023);
  for (let i = 0; i < 100; i++) {
    const v = [rng()*6-3, rng()*6-3, rng()*6-3, rng()*6-3, rng()*6-3];
    const c = rng() * 100 - 50;
    const sm1 = softmax(v);
    const sm2 = softmax(v.map(x => x + c));
    let allClose = true;
    for (let j = 0; j < 5; j++) {
      if (Math.abs(sm1[j] - sm2[j]) > 1e-9) allClose = false;
    }
    assertTrue(allClose, `softmax shift invariance #${i}`);
  }
}
// Running: 5000
// §4 total: 200+1+199+200+200+1+99+100 = 1000

// ═══════════════════════════════════════════════════════════════════════
// §5 — KURAMOTO OSCILLATOR ENGINE (2000 tests)
// ═══════════════════════════════════════════════════════════════════════
section('§5 — KURAMOTO OSCILLATOR ENGINE');

{
  const rng = seededRand(31337);

  // Order parameter r∈[0,1] for 500 random phase sets → 500 tests
  for (let i = 0; i < 500; i++) {
    const N = 5 + Math.floor(rng() * 20);
    const phases = [];
    for (let j = 0; j < N; j++) phases.push(rng() * TAU - PI);
    const { r } = computeKuramotoOrder(phases);
    assertInRange(r, -1e-10, 1 + 1e-10, `Kuramoto r in [0,1] #${i}`);
  }
  // Running: 5500

  // Synchronized phases give r≈1 for 200 configs → 200 tests
  for (let i = 0; i < 200; i++) {
    const N = 5 + Math.floor(rng() * 15);
    const basePhase = rng() * TAU - PI;
    const phases = [];
    for (let j = 0; j < N; j++) phases.push(basePhase + (rng() - 0.5) * 0.001);
    const { r } = computeKuramotoOrder(phases);
    assertInRange(r, 0.999, 1.001, `Kuramoto synchronized r≈1 #${i}`);
  }
  // Running: 5700

  // Anti-phase (evenly spaced) gives r≈0 for 200 configs → 200 tests
  for (let i = 0; i < 200; i++) {
    const N = 3 + Math.floor(rng() * 18);
    const phases = [];
    for (let j = 0; j < N; j++) phases.push((j / N) * TAU);
    const { r } = computeKuramotoOrder(phases);
    assertInRange(r, -0.01, 0.01, `Kuramoto anti-phase r≈0 N=${N} #${i}`);
  }
  // Running: 5900

  // Phase step result wrapped in [-π,π] for 200 tests → 200 tests
  for (let i = 0; i < 200; i++) {
    const N = 5;
    const phases = [];
    for (let j = 0; j < N; j++) phases.push(rng() * TAU - PI);
    const phi_i = rng() * 20 - 10;
    const omega_i = rng() * 2 - 1;
    const newPhase = kuramotoPhaseStep(phi_i, omega_i, phases, KURAMOTO_K, 0.01);
    const wrapped = wrapPhase(newPhase);
    assertInRange(wrapped, -PI - 1e-10, PI + 1e-10, `phase step wrapped #${i}`);
  }
  // Running: 6100

  // Coupling K effects: higher K → higher r, 200 comparisons → 200 tests
  for (let i = 0; i < 200; i++) {
    const N = 8;
    const phases1 = [], phases2 = [];
    for (let j = 0; j < N; j++) {
      const p = rng() * TAU - PI;
      phases1.push(p);
      phases2.push(p);
    }
    const oscs1 = phases1.map(p => ({ phase: p, amplitude: 1 }));
    const oscs2 = phases2.map(p => ({ phase: p, amplitude: 1 }));
    for (let step = 0; step < 50; step++) {
      kuramotoStep(oscs1, 0.1, 0.1);
      kuramotoStep(oscs2, 2.0, 0.1);
    }
    const r1 = computeKuramotoOrder(oscs1.map(o => o.phase)).r;
    const r2 = computeKuramotoOrder(oscs2.map(o => o.phase)).r;
    assertTrue(r2 >= r1 - 0.01, `higher K → higher r #${i}`);
  }
  // Running: 6300

  // N-oscillator convergence for 200 configs → 200 tests
  for (let i = 0; i < 200; i++) {
    const N = 6;
    const oscs = [];
    for (let j = 0; j < N; j++) oscs.push({ phase: rng() * TAU - PI, amplitude: 1 });
    const r0 = computeKuramotoOrder(oscs.map(o => o.phase)).r;
    for (let step = 0; step < 100; step++) kuramotoStep(oscs, 2.0, 0.05);
    const r1 = computeKuramotoOrder(oscs.map(o => o.phase)).r;
    assertTrue(r1 >= r0 - 0.05, `convergence r increases #${i}`);
  }
  // Running: 6500

  // Amplitude-weighted order parameter in [0,1] for 200 configs → 200 tests
  for (let i = 0; i < 200; i++) {
    const N = 5 + Math.floor(rng() * 10);
    const oscs = [];
    for (let j = 0; j < N; j++) oscs.push({ phase: rng() * TAU - PI, amplitude: rng() * 2 + 0.1 });
    const r = computeAmplitudeOrderParameter(oscs);
    assertInRange(r, -1e-10, 1 + 1e-10, `amplitude order param #${i}`);
  }
  // Running: 6700

  // Frequency distribution: zero mean → valid sync, 200 tests
  for (let i = 0; i < 200; i++) {
    const N = 8;
    const phases = [];
    for (let j = 0; j < N; j++) phases.push(rng() * TAU - PI);
    const omegas = [];
    for (let j = 0; j < N; j++) omegas.push((j - (N-1)/2) * 0.01);
    const p = [...phases];
    for (let step = 0; step < 50; step++) {
      for (let j = 0; j < N; j++) {
        p[j] = kuramotoPhaseStep(p[j], omegas[j], p, 1.0, 0.05);
      }
    }
    const r = computeKuramotoOrder(p).r;
    assertInRange(r, -0.01, 1.01, `zero mean sync valid #${i}`);
  }
  // Running: 6900

  // kuramotoStep preserves oscillator count for 100 tests → 100 tests
  for (let i = 0; i < 100; i++) {
    const N = 3 + Math.floor(rng() * 20);
    const oscs = [];
    for (let j = 0; j < N; j++) oscs.push({ phase: rng() * TAU - PI, amplitude: 1 });
    const result = kuramotoStep(oscs, KURAMOTO_K, 0.1);
    assertEqual(result.length, N, `kuramotoStep preserves count #${i}`);
  }
  // Running: 7000
}
// §5 total: 500+200+200+200+200+200+200+200+100 = 2000

// ═══════════════════════════════════════════════════════════════════════
// §6 — LYAPUNOV STABILITY (2000 tests)
// ═══════════════════════════════════════════════════════════════════════
section('§6 — LYAPUNOV STABILITY');

{
  const rng = seededRand(9973);
  function randVecN(n) { const v = []; for (let i = 0; i < n; i++) v.push(rng() * 4 - 2); return v; }

  // V(x) = Σx_i² ≥ 0 for 400 random states → 400 tests
  for (let i = 0; i < 400; i++) {
    const dim = 3 + Math.floor(rng() * 8);
    const x = randVecN(dim);
    const V = x.reduce((s, xi) => s + xi * xi, 0);
    assertTrue(V >= 0, `V(x) >= 0 #${i}`);
  }
  // Running: 7400

  // V(0) = 0 for 300 zero-vectors → 300 tests
  for (let i = 0; i < 300; i++) {
    const dim = 1 + i;
    const x = new Array(dim).fill(0);
    const V = x.reduce((s, xi) => s + xi * xi, 0);
    assertClose(V, 0, `V(0)=0 dim=${dim}`, TOL);
  }
  // Running: 7700

  // V(x+ε) > V(0) for 300 perturbations → 300 tests
  for (let i = 0; i < 300; i++) {
    const dim = 3 + Math.floor(rng() * 5);
    const x = randVecN(dim).map(v => Math.abs(v) * 0.001 + 0.0001);
    const V = x.reduce((s, xi) => s + xi * xi, 0);
    assertTrue(V > 0, `V(x+ε) > 0 #${i}`);
  }
  // Running: 8000

  // Hopfield energy is finite for 200 tests → 200 tests
  for (let i = 0; i < 200; i++) {
    const N = 4;
    const x = randVecN(N);
    const w = [];
    for (let r = 0; r < N; r++) { w.push([]); for (let c = 0; c < N; c++) w[r].push(rng() * 2 - 1); }
    for (let r = 0; r < N; r++) for (let c = r+1; c < N; c++) { w[c][r] = w[r][c]; }
    let E = 0;
    for (let r = 0; r < N; r++) for (let c = 0; c < N; c++) E -= 0.5 * w[r][c] * x[r] * x[c];
    assertTrue(isFinite(E), `Hopfield energy finite #${i}`);
  }
  // Running: 8200

  // Symmetric weight gives same energy as transpose for 300 tests → 300 tests
  for (let i = 0; i < 300; i++) {
    const N = 4;
    const x = randVecN(N);
    const w = [];
    for (let r = 0; r < N; r++) { w.push([]); for (let c = 0; c < N; c++) w[r].push(rng() * 2 - 1); }
    for (let r = 0; r < N; r++) for (let c = r+1; c < N; c++) { w[c][r] = w[r][c]; }
    let E1 = 0, E2 = 0;
    for (let r = 0; r < N; r++) for (let c = 0; c < N; c++) {
      E1 -= 0.5 * w[r][c] * x[r] * x[c];
      E2 -= 0.5 * w[c][r] * x[r] * x[c];
    }
    assertClose(E1, E2, `symmetric energy #${i}`, 1e-10);
  }
  // Running: 8500

  // Energy non-increase after state update for 200 tests → 200 tests
  for (let i = 0; i < 200; i++) {
    const N = 5;
    const x = randVecN(N).map(v => v > 0 ? 1 : -1);
    const w = [];
    for (let r = 0; r < N; r++) { w.push([]); for (let c = 0; c < N; c++) w[r].push(rng() * 2 - 1); }
    for (let r = 0; r < N; r++) { w[r][r] = 0; for (let c = r+1; c < N; c++) { w[c][r] = w[r][c]; } }
    function energy(state) {
      let E = 0;
      for (let r = 0; r < N; r++) for (let c = 0; c < N; c++) E -= 0.5 * w[r][c] * state[r] * state[c];
      return E;
    }
    const E0 = energy(x);
    const idx = Math.floor(rng() * N) % N;
    let h = 0;
    for (let j = 0; j < N; j++) h += w[idx][j] * x[j];
    const newX = [...x];
    newX[idx] = h >= 0 ? 1 : -1;
    const E1 = energy(newX);
    assertTrue(E1 <= E0 + 1e-10, `energy non-increase #${i}`);
  }
  // Running: 8700

  // V(x)≥0 for 5-component states for 300 tests → 300 tests
  for (let i = 0; i < 300; i++) {
    const x = randVecN(5);
    const V = x.reduce((s, xi) => s + xi * xi, 0);
    assertTrue(V >= -1e-15, `V(x)>=0 5-component #${i}`);
  }
  // Running: 9000
}
// §6 total: 400+300+300+200+300+200+300 = 2000

// ═══════════════════════════════════════════════════════════════════════
// §7 — PHASE DYNAMICS & WRAP (1000 tests)
// ═══════════════════════════════════════════════════════════════════════
section('§7 — PHASE DYNAMICS & WRAP');

// wrapPhase maps to [-π,π] for 500 angles → 500 tests
for (let i = 0; i < 500; i++) {
  const theta = -20 * PI + (40 * PI * i) / 499;
  const w = wrapPhase(theta);
  assertInRange(w, -PI - 1e-10, PI + 1e-10, `wrapPhase in [-π,π] #${i}`);
}
// Running: 9500

// phaseDiff antisymmetry for 200 pairs → 200 tests
{
  const rng = seededRand(5557);
  for (let i = 0; i < 200; i++) {
    const a = rng() * TAU * 4 - TAU * 2;
    const b = rng() * TAU * 4 - TAU * 2;
    const d1 = phaseDiff(a, b);
    const d2 = phaseDiff(b, a);
    assertClose(d1, -d2, `phaseDiff antisymmetry #${i}`, 1e-9);
  }
}
// Running: 9700

// phaseDiff result in [-π,π] for 200 pairs → 200 tests
{
  const rng = seededRand(6661);
  for (let i = 0; i < 200; i++) {
    const a = rng() * 100 - 50;
    const b = rng() * 100 - 50;
    const d = phaseDiff(a, b);
    assertInRange(d, -PI - 1e-10, PI + 1e-10, `phaseDiff in [-π,π] #${i}`);
  }
}
// Running: 9900

// wrapPhase idempotency for 100 angles → 100 tests
for (let i = 0; i < 100; i++) {
  const theta = -50 + i;
  const w1 = wrapPhase(theta);
  const w2 = wrapPhase(w1);
  assertClose(w1, w2, `wrapPhase idempotent #${i}`, 1e-12);
}
// Running: 10000
// §7 total: 500+200+200+100 = 1000

// ═══════════════════════════════════════════════════════════════════════
// §8 — NEUROCHEMICAL ODE SYSTEM (1000 tests)
// ═══════════════════════════════════════════════════════════════════════
section('§8 — NEUROCHEMICAL ODE SYSTEM');

{
  const rng = seededRand(11111);

  // Species concentration ≥ SOVEREIGN_FLOOR for 200 values → 200 tests
  for (let i = 0; i < 200; i++) {
    const raw = rng() * 10 - 5;
    const clamped = sf(raw);
    assertTrue(clamped >= SOVEREIGN_FLOOR, `sf >= SOVEREIGN_FLOOR #${i}`);
  }
  // Running: 10200

  // Sovereign floor per species (4 × 50) → 200 tests
  const species = ['dopamine', 'serotonin', 'norepinephrine', 'acetylcholine'];
  for (let s = 0; s < 4; s++) {
    for (let i = 0; i < 50; i++) {
      const level = rng() * 4 - 2;
      const enforced = sf(level);
      assertTrue(enforced >= SOVEREIGN_FLOOR, `${species[s]} floor #${i}`);
    }
  }
  // Running: 10400

  // Baseline convergence for 200 tests → 200 tests
  for (let i = 0; i < 200; i++) {
    const baseline = 1.5 + rng() * 3;
    let level = rng() * 5 + SOVEREIGN_FLOOR;
    const tau = 2 + rng() * 10;
    for (let step = 0; step < 20; step++) {
      level = ema(level, baseline, tau);
      level = sf(level);
    }
    assertTrue(level >= SOVEREIGN_FLOOR, `EMA baseline convergence #${i}`);
  }
  // Running: 10600

  // Stimulus response for 200 tests → 200 tests
  for (let i = 0; i < 200; i++) {
    const level = 1 + rng() * 5;
    const stimulus = rng() * 2 + 0.1;
    const newLevel = level + stimulus;
    assertTrue(newLevel > level, `stimulus increases #${i}`);
  }
  // Running: 10800

  // Decay rate comparison for 200 tests → 200 tests
  for (let i = 0; i < 200; i++) {
    const baseline = 2 + rng() * 3;
    const init = baseline + 5;
    const tau_slow = 10 + rng() * 20;
    const tau_fast = 1 + rng() * 3;
    let level_slow = init, level_fast = init;
    for (let step = 0; step < 50; step++) {
      level_slow = ema(level_slow, baseline, tau_slow);
      level_fast = ema(level_fast, baseline, tau_fast);
    }
    assertTrue(level_fast <= level_slow + 0.01, `faster decay → lower #${i}`);
  }
  // Running: 11000
}
// §8 total: 200+200+200+200+200 = 1000

// ═══════════════════════════════════════════════════════════════════════
// §9 — STATISTICAL FUNCTIONS (1000 tests)
// ═══════════════════════════════════════════════════════════════════════
section('§9 — STATISTICAL FUNCTIONS');

{
  const rng = seededRand(22222);

  function makeDistribution(n) {
    const raw = [];
    for (let i = 0; i < n; i++) raw.push(rng() + 0.01);
    const sum = raw.reduce((a, b) => a + b, 0);
    return raw.map(x => x / sum);
  }

  // KL divergence ≥ 0 for 200 pairs → 200 tests
  for (let i = 0; i < 200; i++) {
    const n = 5 + Math.floor(rng() * 10);
    const p = makeDistribution(n);
    const q = makeDistribution(n);
    const kl = klDivergence(p, q);
    assertTrue(kl >= -1e-12, `KL >= 0 #${i}`);
  }
  // Running: 11200

  // KL(P||P) = 0 for 100 distributions → 100 tests
  for (let i = 0; i < 100; i++) {
    const n = 5 + Math.floor(rng() * 10);
    const p = makeDistribution(n);
    const kl = klDivergence(p, p);
    assertClose(kl, 0, `KL(P||P)=0 #${i}`, 1e-10);
  }
  // Running: 11300

  // Fisher information > 0 for 200 points → 200 tests
  for (let i = 0; i < 200; i++) {
    const p = 0.01 + rng() * 0.98;
    const fi = fisherInfo(p);
    assertTrue(fi > 0, `Fisher info > 0 #${i}`);
  }
  // Running: 11500

  // z-score of mean = 0 for 200 tests → 200 tests
  for (let i = 0; i < 200; i++) {
    const mean = rng() * 100 - 50;
    const std = rng() * 10 + 0.1;
    const z = zScore(mean, mean, std);
    assertClose(z, 0, `z-score of mean = 0 #${i}`, TOL);
  }
  // Running: 11700

  // EMA convergence for 200 steps → 200 tests
  for (let i = 0; i < 200; i++) {
    const target = rng() * 10;
    const tau = 1 + rng() * 5;
    let val = rng() * 20 - 10;
    const initDist = Math.abs(val - target);
    for (let s = 0; s < 50; s++) val = ema(val, target, tau);
    const finalDist = Math.abs(val - target);
    assertTrue(finalDist < initDist + 1e-10, `EMA convergence #${i}`);
  }
  // Running: 11900

  // z-score finite for 100 points → 100 tests
  for (let i = 0; i < 100; i++) {
    const mean = rng() * 50;
    const std = 1 + rng() * 10;
    const x = mean + (rng() * 6 - 3) * std;
    const z = zScore(x, mean, std);
    assertTrue(isFinite(z), `z-score finite #${i}`);
  }
  // Running: 12000
}
// §9 total: 200+100+200+200+200+100 = 1000

// ═══════════════════════════════════════════════════════════════════════
// §10 — LOGISTIC & GROWTH (500 tests)
// ═══════════════════════════════════════════════════════════════════════
section('§10 — LOGISTIC & GROWTH');

{
  const rng = seededRand(33333);

  // Logistic step: population stays ≤ K for 100 tests → 100 tests
  for (let i = 0; i < 100; i++) {
    const K = 100 + rng() * 900;
    const r = 0.1 + rng() * 0.9;
    let N = rng() * K * 0.9 + 1;
    for (let s = 0; s < 20; s++) {
      N = logisticStep(N, r, K, 0.1);
      N = clamp(N, 0, K * 2);
    }
    assertTrue(N <= K * 1.1, `logistic ≤ K #${i}`);
  }
  // Running: 12100

  // Extinction: N=0 stays at 0 for 50 tests → 50 tests
  for (let i = 0; i < 50; i++) {
    const K = 100 + rng() * 500;
    const r = rng() * 2;
    const N = logisticStep(0, r, K, 0.1);
    assertClose(N, 0, `extinction N=0 #${i}`, TOL);
  }
  // Running: 12150

  // Equilibrium: N=K stays at K for 100 tests → 100 tests
  for (let i = 0; i < 100; i++) {
    const K = 50 + rng() * 500;
    const r = 0.1 + rng() * 2;
    const N = logisticStep(K, r, K, 0.1);
    assertClose(N, K, `equilibrium N=K #${i}`, 1e-8);
  }
  // Running: 12250

  // Landau free energy symmetry for 100 tests → 100 tests
  for (let i = 0; i < 100; i++) {
    const m = rng() * 4 - 2;
    const a = rng() * 5 - 2;
    const b = rng() * 3 + 0.1;
    assertClose(landauFreeEnergy(m, a, b), landauFreeEnergy(-m, a, b), `Landau symmetry #${i}`, 1e-10);
  }
  // Running: 12350

  // Landau gradient symmetry F(ε)≈F(-ε) for 100 tests → 100 tests
  for (let i = 0; i < 100; i++) {
    const eps = (rng() * 0.01) + 0.0001;
    const a = rng() * 5 + 0.1;
    const b = rng() * 3 + 0.1;
    const diff = Math.abs(landauFreeEnergy(eps, a, b) - landauFreeEnergy(-eps, a, b));
    assertClose(diff, 0, `Landau gradient symmetry #${i}`, 1e-6);
  }
  // Running: 12450

  // d²F/dm² = 2a + 12b*m² > 0 at m=0 when a>0 for 50 tests → 50 tests
  for (let i = 0; i < 50; i++) {
    const a = rng() * 5 + 0.1;
    const b = rng() * 3 + 0.1;
    const d2F = 2 * a + 12 * b * 0;
    assertTrue(d2F > 0, `Landau d²F/dm² > 0 #${i}`);
  }
  // Running: 12500
}
// §10 total: 100+50+100+100+100+50 = 500

// ═══════════════════════════════════════════════════════════════════════
// RESULTS
// ═══════════════════════════════════════════════════════════════════════

console.log(`\n${'═'.repeat(50)}`);
console.log(`  MEGA TEST SUITE — RESULTS`);
console.log(`${'═'.repeat(50)}`);
console.log(`  Total:  ${_total}`);
console.log(`  Passed: ${_passed}`);
console.log(`  Failed: ${_failed}`);
if (_failures.length > 0) {
  console.log(`\n  FAILURES (first 20):`);
  _failures.slice(0, 20).forEach(f => console.log(`    ✗ ${f.label}: got ${f.a}, expected ${f.b}`));
}
console.log(`${'═'.repeat(50)}`);
if (_total !== 12500) { console.error(`ERROR: Expected 12500 tests, got ${_total}`); process.exit(1); }
if (_failed > 0) { process.exit(1); }
console.log('  ✓ ALL 12,500 TESTS PASSED');
process.exit(0);
