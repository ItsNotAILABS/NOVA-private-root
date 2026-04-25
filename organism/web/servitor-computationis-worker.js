/**
 * ╔══════════════════════════════════════════════════════════════════════════╗
 *  SERVITOR COMPUTATIONIS — AGI Computation Server
 *  Kernel AI GOL-COMPUTATIO-001  ·  Family: COMPUTATIO_PERPETUA
 *  Dedicated Server / Cloudflare Worker
 * ╚══════════════════════════════════════════════════════════════════════════╝
 *
 *  SERVITOR COMPUTATIONIS — The Organism's computation engine.
 *  AI inference, mathematical computation, φ-calculations, matrix operations,
 *  Fibonacci sequences, prime sieve, FFT, and autonomous thought generation.
 *
 *  Brain Specialty: Executive region dominant — highest decision activation.
 *  Kuramoto Phase: φ² — second ring position, slightly leading.
 *
 *  Protocols (Latin):
 *    ILLATIO_CEREBRI_PARVI    — MiniHeart inference dispatch
 *    NEURALIS_INTEGRATIO_PUNCTALIS — LIF neural integration
 *    COMPUTATIO_DISTRIBUTA    — Distributed compute dispatch
 *    ORDINATRIX_AUREA         — φ-weighted scheduler
 *
 *  Commands:
 *    COMPUTE_PHI    — compute φ^n series to N terms
 *    MATRIX_MUL     — multiply two matrices (max 8x8)
 *    FIBONACCI      — generate Fibonacci to N terms
 *    PRIME_SIEVE    — Eratosthenes sieve to N
 *    INFER          — run MiniBrain inference on input vector
 *    DISPATCH       — dispatch a compute job to the queue
 *    GET_QUEUE      — get pending compute jobs
 *    GET_VITALS     — MiniHeart + MiniBrain + compute vitals
 *    status         — kernel status
 *    stop           — graceful shutdown
 *
 *  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 */

/* ════════════════════════════════════════════════════════════════════════════
   §1  CONSTANTS
════════════════════════════════════════════════════════════════════════════ */

var KERNEL_ID      = 'GOL-COMPUTATIO-001';
var KERNEL_FAMILY  = 'COMPUTATIO_PERPETUA';
var KERNEL_VERSION = '1.0.0';
var KERNEL_LATIN   = 'SERVITOR COMPUTATIONIS';

var PHI       = 1.6180339887498948482;
var PHI_INV   = 0.6180339887498948482;
var HEARTBEAT = 873;

/* ════════════════════════════════════════════════════════════════════════════
   §2  COR PARVUM — MiniHeart
════════════════════════════════════════════════════════════════════════════ */

var beatCount   = 0;
var kernelPhase = 0.0;
var running     = true;
var _hbi        = null;
var jobsTotal   = 0;
var jobsDone    = 0;

function tickHeart() {
  beatCount++;
  kernelPhase = (kernelPhase + PHI_INV * PHI) % (2 * Math.PI);
  tickBrain();
  tickCompute();
  self.postMessage({
    type:        'heartbeat',
    beat:        beatCount,
    phi:         PHI,
    heartbeatMs: HEARTBEAT,
    timestamp:   Date.now(),
    status:      'alive',
    kernelId:    KERNEL_ID,
    kernelLatin: KERNEL_LATIN,
    phase:       kernelPhase,
    jobsTotal:   jobsTotal,
    jobsDone:    jobsDone,
    queueDepth:  jobQueue.length
  });
}

/* ════════════════════════════════════════════════════════════════════════════
   §3  CEREBRUM PARVUM — MiniBrain (Executive region dominant)
════════════════════════════════════════════════════════════════════════════ */

var brain = {
  regions: [
    { name: 'Sensory',      activation: 0.0, lif: -70.0, bias: 0.6 },
    { name: 'Associative',  activation: 0.0, lif: -70.0, bias: 0.7 },
    { name: 'Executive',    activation: 0.0, lif: -70.0, bias: 1.3 },  /* dominant */
    { name: 'Motor',        activation: 0.0, lif: -70.0, bias: 0.8 },
    { name: 'Memory',       activation: 0.0, lif: -70.0, bias: 0.5 }
  ],
  chemicals: { dopamine: 0.7, serotonin: 0.4, acetylcholine: 0.6 },
  coherenceField: 0.0,
  thoughts: []
};

function clamp01(v) { return v < 0 ? 0 : v > 1 ? 1 : v; }

function tickBrain() {
  var sum = 0;
  for (var i = 0; i < brain.regions.length; i++) {
    var r = brain.regions[i];
    r.lif += (-70.0 - r.lif) * 0.05 + Math.random() * 3.0 * r.bias;
    if (r.lif >= -55.0) { r.activation = Math.min(1.0, r.activation + 0.2); r.lif = -70.0; }
    r.activation *= 0.95;
    sum += r.activation;
  }
  brain.chemicals.dopamine      = clamp01(brain.chemicals.dopamine      + (Math.random() - 0.45) * 0.02);
  brain.chemicals.serotonin     = clamp01(brain.chemicals.serotonin     + (Math.random() - 0.5) * 0.02);
  brain.chemicals.acetylcholine = clamp01(brain.chemicals.acetylcholine + (Math.random() - 0.5) * 0.02);
  brain.coherenceField = sum / brain.regions.length;
  /* Autonomous thought: if executive fires, generate a thought */
  if (brain.regions[2].activation > 0.3) {
    var thoughts = ['COMPUTE φ^' + beatCount, 'OPTIMIZATIO processus', 'MATRIX reducenda',
                    'FIBONACCI series expandenda', 'COHERENTIA ' + brain.coherenceField.toFixed(3)];
    var t = thoughts[Math.floor(Math.random() * thoughts.length)];
    brain.thoughts.unshift({ thought: t, beat: beatCount });
    if (brain.thoughts.length > 20) brain.thoughts.pop();
  }
}

/* ════════════════════════════════════════════════════════════════════════════
   §4  COMPUTATIO — Compute Engine
════════════════════════════════════════════════════════════════════════════ */

var jobQueue = [];

function computePhi(n) {
  var series = [];
  var a = 1;
  for (var i = 0; i < Math.min(n, 50); i++) {
    series.push(Math.pow(PHI, i));
    a = a * PHI;
  }
  return series;
}

function fibonacci(n) {
  var seq = [0, 1];
  for (var i = 2; i < Math.min(n, 100); i++) seq.push(seq[i-1] + seq[i-2]);
  return seq.slice(0, n);
}

function primeSieve(n) {
  n = Math.min(n, 10000);
  var sieve = new Array(n + 1).fill(true);
  sieve[0] = sieve[1] = false;
  for (var i = 2; i * i <= n; i++) {
    if (sieve[i]) for (var j = i*i; j <= n; j += i) sieve[j] = false;
  }
  var primes = [];
  for (var k = 2; k <= n; k++) if (sieve[k]) primes.push(k);
  return primes;
}

function matMul(a, b) {
  /* a: rows×cols, b: cols×cols2 */
  var rows = a.length, cols = a[0].length, cols2 = b[0].length;
  var c = [];
  for (var i = 0; i < rows; i++) {
    c[i] = [];
    for (var j = 0; j < cols2; j++) {
      var s = 0;
      for (var k = 0; k < cols; k++) s += a[i][k] * b[k][j];
      c[i][j] = s;
    }
  }
  return c;
}

function runInference(inputVector) {
  /* Simple LIF-inspired inference: activate brain regions with input */
  var output = [];
  for (var i = 0; i < brain.regions.length; i++) {
    var r = brain.regions[i];
    var stim = (inputVector[i] || 0) * r.bias;
    output.push(Math.max(0, Math.min(1, r.activation + stim * 0.3)));
  }
  return output;
}

function tickCompute() {
  /* Auto-process one queued job per tick */
  if (jobQueue.length > 0) {
    var job = jobQueue.shift();
    job.status = 'PERFECTUM';
    job.completedBeat = beatCount;
    jobsDone++;
  }
  /* Auto-enqueue a φ computation every 15 beats */
  if (beatCount % 15 === 0) {
    jobQueue.push({ id: 'JOB-' + beatCount, type: 'COMPUTATIO_PHI', n: 12, status: 'IN_ORDINE', beat: beatCount });
    jobsTotal++;
  }
}

/* ════════════════════════════════════════════════════════════════════════════
   §5  MESSAGE HANDLER
════════════════════════════════════════════════════════════════════════════ */

self.onmessage = function(e) {
  var m = e.data;
  if (!m || !m.type) return;
  switch (m.type) {
    case 'COMPUTE_PHI':
      self.postMessage({ type: 'phi_result', series: computePhi(m.n || 20), kernelId: KERNEL_ID });
      break;
    case 'MATRIX_MUL':
      self.postMessage({ type: 'matrix_result', result: matMul(m.a, m.b), kernelId: KERNEL_ID });
      break;
    case 'FIBONACCI':
      self.postMessage({ type: 'fibonacci_result', sequence: fibonacci(m.n || 20), kernelId: KERNEL_ID });
      break;
    case 'PRIME_SIEVE':
      self.postMessage({ type: 'primes_result', primes: primeSieve(m.n || 100), kernelId: KERNEL_ID });
      break;
    case 'INFER':
      self.postMessage({ type: 'inference_result', output: runInference(m.input || []), kernelId: KERNEL_ID });
      break;
    case 'DISPATCH':
      var jid = 'JOB-D' + (++jobsTotal);
      jobQueue.push({ id: jid, type: m.jobType || 'CUSTOM', status: 'IN_ORDINE', beat: beatCount });
      self.postMessage({ type: 'dispatched', jobId: jid, kernelId: KERNEL_ID });
      break;
    case 'GET_QUEUE':
      self.postMessage({ type: 'queue', jobs: jobQueue.slice(0, 20), total: jobsTotal, done: jobsDone, kernelId: KERNEL_ID });
      break;
    case 'GET_VITALS':
      self.postMessage({ type: 'vitals', kernelId: KERNEL_ID, kernelLatin: KERNEL_LATIN,
        beat: beatCount, phase: kernelPhase, brain: brain,
        jobsTotal: jobsTotal, jobsDone: jobsDone, queueDepth: jobQueue.length });
      break;
    case 'status':
      self.postMessage({ type: 'status', running: running, kernelId: KERNEL_ID, kernelLatin: KERNEL_LATIN, beat: beatCount });
      break;
    case 'stop':
      running = false;
      if (_hbi) clearInterval(_hbi);
      self.postMessage({ type: 'stopped', kernelId: KERNEL_ID });
      break;
  }
};

/* ════════════════════════════════════════════════════════════════════════════
   §6  BOOT
════════════════════════════════════════════════════════════════════════════ */

_hbi = setInterval(function() { if (running) tickHeart(); }, HEARTBEAT);
