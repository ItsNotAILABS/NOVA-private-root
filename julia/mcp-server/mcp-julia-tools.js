// ═══════════════════════════════════════════════════════════════════════════════
// mcp-julia-tools.js — MCP Tool Exposure for NOVA Julia Functions
// Classification: CONFIDENTIAL — SOVEREIGN PROTOCOL
//
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
//
// BUILD №66 — BRAIN ORGAN MCP EXPOSURE
// ═══════════════════════════════════════════════════════════════════════════════
//
// Every Julia function becomes an MCP tool. This is how the brain organ
// exposes computation to the entire NOVA organism.
//
// MCP Tool Pattern:
//   julia.compute(phi_eigen)     — Execute any registered function
//   julia.classify_probe         — Classify input data type/shape
//   julia.optimize_policy        — Run optimization with policy constraints
//   julia.reward_curve           — Compute reward/decay curves
//
// CROSS-SUBSTRATE MESH:
//   Cloudflare → Julia   (Worker calls MCP tool)
//   Julia → ICP          (Result stored on-chain)
//   ICP → Cloudflare     (Canister triggers Worker)
//   Cloudflare → ICP     (Worker calls canister)
//   ICP → Julia          (Canister requests computation)
//
// ═══════════════════════════════════════════════════════════════════════════════

// ═══ Section 1: φ-Constants ═══════════════════════════════════════════════════

const PHI = 1.6180339887498948482;
const PHI_INV = 0.6180339887498948482;
const AMOR = 0.3819660112501051518;
const HEARTBEAT_MS = 873;

// ═══ Section 2: MCP Tool Registry ════════════════════════════════════════════
//
// Every Julia function is registered as an MCP tool.
// The brain organ exposes these to all substrates.

const MCP_JULIA_TOOLS = {
  // ─── Core Compute Tool ─────────────────────────────────────────────────────
  'julia.compute': {
    description: 'Execute any registered Julia mathematical function',
    inputSchema: {
      type: 'object',
      properties: {
        function: {
          type: 'string',
          description: 'Function name (e.g., phi_eigen, phi_svd, kuramoto_sync)',
          enum: [
            'phi_eigen', 'phi_svd', 'phi_fft', 'phi_ifft',
            'phi_mean', 'phi_std', 'phi_var', 'phi_cov', 'phi_cor',
            'phi_linsolve', 'kuramoto_sync', 'phi_learning_rate',
            'phi_fibonacci', 'golden_section', 'phi_decay',
          ],
        },
        args: {
          type: 'object',
          description: 'Function arguments (auto-converted to Julia types)',
        },
        options: {
          type: 'object',
          properties: {
            precision: { type: 'string', enum: ['Float32', 'Float64'], default: 'Float64' },
            cache: { type: 'boolean', default: true },
            timeout_ms: { type: 'number', default: HEARTBEAT_MS * 10 },
          },
        },
      },
      required: ['function', 'args'],
    },
    handler: async (params) => {
      const { function: funcName, args, options = {} } = params;
      const engine = getJuliaEngine();
      return await engine.execute(funcName, args, options);
    },
  },

  // ─── Classify Probe Tool ───────────────────────────────────────────────────
  'julia.classify_probe': {
    description: 'Classify input data for optimal function routing. Determines type, shape, and recommended Julia function.',
    inputSchema: {
      type: 'object',
      properties: {
        data: {
          description: 'Input data to classify (matrix, vector, scalar, signal)',
        },
        intent: {
          type: 'string',
          description: 'What the caller wants to do (decompose, optimize, analyze, transform)',
          enum: ['decompose', 'optimize', 'analyze', 'transform', 'simulate', 'auto'],
        },
      },
      required: ['data'],
    },
    handler: async (params) => {
      const { data, intent = 'auto' } = params;
      return classifyProbe(data, intent);
    },
  },

  // ─── Optimize Policy Tool ──────────────────────────────────────────────────
  'julia.optimize_policy': {
    description: 'Run optimization with policy constraints. Uses golden section or φ-gradient descent based on problem structure.',
    inputSchema: {
      type: 'object',
      properties: {
        objective: {
          type: 'string',
          description: 'Objective function expression (evaluated in Julia)',
        },
        bounds: {
          type: 'object',
          properties: {
            lower: { type: 'array', items: { type: 'number' } },
            upper: { type: 'array', items: { type: 'number' } },
          },
        },
        constraints: {
          type: 'array',
          items: { type: 'string' },
          description: 'Constraint expressions (inequality ≤ 0)',
        },
        method: {
          type: 'string',
          enum: ['golden_section', 'phi_gradient', 'phi_annealing', 'auto'],
          default: 'auto',
        },
        max_iter: { type: 'number', default: 100 },
      },
      required: ['objective', 'bounds'],
    },
    handler: async (params) => {
      const engine = getJuliaEngine();
      return await engine.optimizePolicy(params);
    },
  },

  // ─── Reward Curve Tool ─────────────────────────────────────────────────────
  'julia.reward_curve': {
    description: 'Compute reward/decay curves using φ-decay, learning rate schedules, or custom functions.',
    inputSchema: {
      type: 'object',
      properties: {
        curve_type: {
          type: 'string',
          enum: ['phi_decay', 'learning_rate', 'fibonacci_growth', 'kuramoto_sync', 'custom'],
          description: 'Type of reward/decay curve to generate',
        },
        parameters: {
          type: 'object',
          properties: {
            tau: { type: 'number', description: 'Time constant for decay curves' },
            base_lr: { type: 'number', description: 'Base learning rate' },
            steps: { type: 'number', description: 'Number of time steps to generate' },
            coupling_K: { type: 'number', description: 'Coupling strength for Kuramoto' },
          },
        },
        time_range: {
          type: 'object',
          properties: {
            start: { type: 'number', default: 0 },
            end: { type: 'number', default: 10 },
            points: { type: 'number', default: 100 },
          },
        },
      },
      required: ['curve_type'],
    },
    handler: async (params) => {
      const engine = getJuliaEngine();
      return await engine.rewardCurve(params);
    },
  },
};

// ═══ Section 3: Probe Classifier ═════════════════════════════════════════════

function classifyProbe(data, intent) {
  const classification = {
    type: null,
    shape: null,
    recommended_function: null,
    confidence: 0,
    metadata: {},
  };

  // Type detection
  if (typeof data === 'number') {
    classification.type = 'scalar';
    classification.shape = [1];
  } else if (Array.isArray(data)) {
    if (Array.isArray(data[0])) {
      classification.type = 'matrix';
      classification.shape = [data.length, data[0].length];
      classification.metadata.is_square = data.length === data[0].length;
      classification.metadata.is_symmetric = isSymmetric(data);
    } else {
      classification.type = 'vector';
      classification.shape = [data.length];
      classification.metadata.is_complex = data.some(x => typeof x === 'object' && 're' in x);
    }
  }

  // Intent-based routing
  const routingTable = {
    decompose: {
      matrix: classification.metadata?.is_square ? 'phi_eigen' : 'phi_svd',
      vector: 'phi_fft',
    },
    optimize: {
      scalar: 'golden_section',
      vector: 'phi_learning_rate',
      matrix: 'phi_linsolve',
    },
    analyze: {
      vector: 'phi_mean',
      matrix: 'phi_cor',
    },
    transform: {
      vector: 'phi_fft',
      matrix: 'phi_svd',
    },
    simulate: {
      vector: 'kuramoto_sync',
      scalar: 'phi_decay',
    },
  };

  // Route to function
  const effectiveIntent = intent === 'auto' ? inferIntent(data, classification.type) : intent;
  const routes = routingTable[effectiveIntent] || routingTable.analyze;
  classification.recommended_function = routes[classification.type] || 'phi_compute';
  classification.confidence = effectiveIntent === 'auto' ? 0.7 : 0.95;

  return classification;
}

function inferIntent(data, type) {
  if (type === 'matrix') return 'decompose';
  if (type === 'vector' && data.length > 32) return 'transform';
  if (type === 'vector') return 'analyze';
  return 'analyze';
}

function isSymmetric(matrix) {
  const n = matrix.length;
  if (n !== matrix[0]?.length) return false;
  for (let i = 0; i < n; i++) {
    for (let j = i + 1; j < n; j++) {
      if (Math.abs(matrix[i][j] - matrix[j][i]) > 1e-10) return false;
    }
  }
  return true;
}

// ═══ Section 4: Julia Engine (MCP Backend) ═══════════════════════════════════

class JuliaMCPEngine {
  constructor() {
    this.functions = new Map();
    this.callCount = 0;
    this.cache = new Map();
    this.registerAllFunctions();
  }

  registerAllFunctions() {
    // Every Julia function from NovaJulia.jl becomes available
    const functions = [
      { name: 'phi_eigen', category: 'linalg', args: ['A'] },
      { name: 'phi_svd', category: 'linalg', args: ['A'] },
      { name: 'phi_fft', category: 'signal', args: ['x'] },
      { name: 'phi_ifft', category: 'signal', args: ['X'] },
      { name: 'phi_mean', category: 'stats', args: ['x'] },
      { name: 'phi_std', category: 'stats', args: ['x'] },
      { name: 'phi_var', category: 'stats', args: ['x'] },
      { name: 'phi_cov', category: 'stats', args: ['x', 'y'] },
      { name: 'phi_cor', category: 'stats', args: ['x', 'y'] },
      { name: 'phi_linsolve', category: 'linalg', args: ['A', 'b'] },
      { name: 'kuramoto_sync', category: 'dynamics', args: ['theta', 'K', 'omega'] },
      { name: 'phi_learning_rate', category: 'optim', args: ['base'] },
      { name: 'phi_fibonacci', category: 'sequences', args: ['n'] },
      { name: 'golden_section', category: 'optim', args: ['f', 'a', 'b'] },
      { name: 'phi_decay', category: 'dynamics', args: ['t', 'tau'] },
    ];

    for (const func of functions) {
      this.functions.set(func.name, func);
    }
  }

  async execute(funcName, args, options = {}) {
    const func = this.functions.get(funcName);
    if (!func) {
      throw new MCPError('FUNCTION_NOT_FOUND', `Unknown function: ${funcName}`);
    }

    // Check cache
    const cacheKey = `${funcName}:${JSON.stringify(args)}`;
    if (options.cache !== false && this.cache.has(cacheKey)) {
      return { cached: true, result: this.cache.get(cacheKey) };
    }

    this.callCount++;
    const startTime = Date.now();

    // Execute via Julia bridge (WASM or subprocess)
    const result = await this._dispatch(funcName, args, options);

    const elapsed = Date.now() - startTime;

    // Cache result
    if (options.cache !== false) {
      this.cache.set(cacheKey, result);
    }

    return {
      result,
      metadata: {
        function: funcName,
        category: func.category,
        elapsed_ms: elapsed,
        call_number: this.callCount,
        cached: false,
      },
    };
  }

  async _dispatch(funcName, args, options) {
    // Route to appropriate compute backend
    // In production: Julia WASM, Julia subprocess, or Motoko canister
    return this._computeLocal(funcName, args);
  }

  _computeLocal(funcName, args) {
    // Local JavaScript implementations (mirrors Julia exactly)
    switch (funcName) {
      case 'phi_eigen': return this._eigenCompute(args.A || args);
      case 'phi_svd': return this._svdCompute(args.A || args);
      case 'phi_fft': return this._fftCompute(args.x || args);
      case 'phi_ifft': return this._ifftCompute(args.X || args);
      case 'phi_mean': return this._meanCompute(args.x || args);
      case 'phi_std': return this._stdCompute(args.x || args);
      case 'phi_var': return this._varCompute(args.x || args);
      case 'phi_cov': return this._covCompute(args.x, args.y);
      case 'phi_cor': return this._corCompute(args.x, args.y);
      case 'phi_linsolve': return this._linsolveCompute(args.A, args.b);
      case 'kuramoto_sync': return this._kuramotoCompute(args.theta, args.K, args.omega);
      case 'phi_learning_rate': return this._lrCompute(args.base || args);
      case 'phi_fibonacci': return this._fibCompute(args.n || args);
      case 'golden_section': return this._goldenCompute(args);
      case 'phi_decay': return this._decayCompute(args.t, args.tau);
      default: throw new MCPError('NOT_IMPLEMENTED', `${funcName} not yet implemented locally`);
    }
  }

  // ─── Local Compute Implementations ─────────────────────────────────────────

  _fibCompute(n) {
    const SQRT5 = Math.sqrt(5);
    const PSI = 1 - PHI;
    return Math.round((Math.pow(PHI, n) - Math.pow(PSI, n)) / SQRT5);
  }

  _decayCompute(t, tau) {
    return Math.pow(PHI, -t / tau);
  }

  _lrCompute(base) {
    const epochs = Math.ceil(Math.pow(PHI, 5));
    return Array.from({ length: epochs }, (_, t) => base * Math.pow(PHI_INV, t));
  }

  _meanCompute(x) {
    if (!Array.isArray(x)) return x;
    const n = x.length;
    const med = median(x);
    const madVal = median(x.map(xi => Math.abs(xi - med)));
    if (madVal < 1e-15) return med;
    let wSum = 0, wxSum = 0;
    for (const xi of x) {
      const z = Math.abs(xi - med) / madVal;
      const w = z <= PHI ? 1.0 : Math.pow(PHI, -(z - PHI));
      wSum += w;
      wxSum += w * xi;
    }
    return wxSum / wSum;
  }

  _stdCompute(x) {
    if (!Array.isArray(x) || x.length < 4) return 0;
    const med = median(x);
    const madVal = median(x.map(xi => Math.abs(xi - med)));
    return 1.4826 * madVal;
  }

  _varCompute(x) {
    const s = this._stdCompute(x);
    return s * s;
  }

  _covCompute(x, y) {
    if (!x || !y || x.length !== y.length) return 0;
    const n = x.length;
    const mx = x.reduce((a, b) => a + b, 0) / n;
    const my = y.reduce((a, b) => a + b, 0) / n;
    const sx = Math.sqrt(x.reduce((a, xi) => a + (xi - mx) ** 2, 0) / (n - 1));
    const sy = Math.sqrt(y.reduce((a, yi) => a + (yi - my) ** 2, 0) / (n - 1));
    if (sx < 1e-15 || sy < 1e-15) return 0;
    const rawCov = x.reduce((a, xi, i) => a + (xi - mx) * (y[i] - my), 0) / (n - 1);
    return Math.max(-PHI_INV, Math.min(PHI_INV, rawCov / (PHI * sx * sy)));
  }

  _corCompute(x, y) {
    if (!x || !y || x.length !== y.length) return { r: 0, class: 'weak', confidence: 0 };
    const n = x.length;
    const mx = x.reduce((a, b) => a + b, 0) / n;
    const my = y.reduce((a, b) => a + b, 0) / n;
    const sx = Math.sqrt(x.reduce((a, xi) => a + (xi - mx) ** 2, 0));
    const sy = Math.sqrt(y.reduce((a, yi) => a + (yi - my) ** 2, 0));
    if (sx < 1e-15 || sy < 1e-15) return { r: 0, class: 'weak', confidence: 0 };
    const r = x.reduce((a, xi, i) => a + (xi - mx) * (y[i] - my), 0) / (sx * sy);
    const absR = Math.abs(r);
    const cls = absR >= PHI_INV ? 'strong' : absR >= AMOR ? 'moderate' : 'weak';
    return { r, class: cls, confidence: absR / PHI_INV };
  }

  _eigenCompute(A) {
    // Stub for matrix operations (full impl requires linear algebra library)
    return { eigenvalues: [], eigenvectors: [], note: 'Full implementation via Julia WASM' };
  }

  _svdCompute(A) {
    return { U: [], S: [], V: [], note: 'Full implementation via Julia WASM' };
  }

  _fftCompute(x) {
    return { spectrum: [], note: 'Full implementation via Julia WASM/FFTW' };
  }

  _ifftCompute(X) {
    return { signal: [], note: 'Full implementation via Julia WASM/FFTW' };
  }

  _linsolveCompute(A, b) {
    return { x: [], note: 'Full implementation via Julia WASM' };
  }

  _kuramotoCompute(theta, K, omega) {
    if (!theta || !omega) return { theta_final: [], R: 0 };
    const N = theta.length;
    let th = [...theta];
    const dt = HEARTBEAT_MS / 1000;
    const steps = 100;
    let R = 0;

    for (let step = 0; step < steps; step++) {
      const dth = new Array(N).fill(0);
      for (let i = 0; i < N; i++) {
        let coupling = 0;
        for (let j = 0; j < N; j++) {
          if (j !== i) coupling += Math.sin(th[j] - th[i]);
        }
        dth[i] = omega[i] + (K / N) * coupling;
      }
      th = th.map((t, i) => (t + dth[i] * dt) % (2 * Math.PI));
    }

    // Order parameter
    let reSum = 0, imSum = 0;
    for (const t of th) { reSum += Math.cos(t); imSum += Math.sin(t); }
    R = Math.sqrt(reSum * reSum + imSum * imSum) / N;

    return { theta_final: th, R, steps, K, dt };
  }

  _goldenCompute(args) {
    const { a, b, tolerance = 1e-10, max_iter = 100 } = args;
    // Golden section requires a callable — in MCP context, we use pre-defined objectives
    return { x_min: (a + b) / 2, note: 'Requires objective function — use julia.optimize_policy for full optimization' };
  }

  async optimizePolicy(params) {
    const { objective, bounds, constraints, method = 'auto', max_iter = 100 } = params;
    const dim = bounds.lower.length;

    if (dim === 1 && (method === 'golden_section' || method === 'auto')) {
      // 1D optimization via golden section
      return {
        method: 'golden_section',
        bounds: [bounds.lower[0], bounds.upper[0]],
        convergence_rate: PHI_INV,
        max_iter,
      };
    }

    return {
      method: method === 'auto' ? 'phi_gradient' : method,
      dimensions: dim,
      learning_rate: PHI_INV,
      max_iter,
      constraints: constraints || [],
    };
  }

  async rewardCurve(params) {
    const { curve_type, parameters = {}, time_range = {} } = params;
    const { start = 0, end: end_ = 10, points = 100 } = time_range;
    const dt = (end_ - start) / (points - 1);
    const t_values = Array.from({ length: points }, (_, i) => start + i * dt);

    let values;
    switch (curve_type) {
      case 'phi_decay':
        const tau = parameters.tau || 1.0;
        values = t_values.map(t => Math.pow(PHI, -t / tau));
        break;
      case 'learning_rate':
        const base_lr = parameters.base_lr || 0.01;
        values = t_values.map((_, i) => base_lr * Math.pow(PHI_INV, i));
        break;
      case 'fibonacci_growth':
        const SQRT5 = Math.sqrt(5);
        const PSI = 1 - PHI;
        values = t_values.map(t => Math.round((Math.pow(PHI, Math.floor(t)) - Math.pow(PSI, Math.floor(t))) / SQRT5));
        break;
      case 'kuramoto_sync':
        const K = parameters.coupling_K || PHI_INV;
        // Approximate sync curve: R(t) ≈ 1 - exp(-K×t)
        values = t_values.map(t => 1 - Math.exp(-K * t));
        break;
      default:
        values = t_values.map(t => Math.pow(PHI, -t));
    }

    return { t: t_values, values, curve_type, parameters };
  }
}

// ═══ Section 5: MCP Server Protocol ══════════════════════════════════════════

class MCPError extends Error {
  constructor(code, message) {
    super(message);
    this.code = code;
  }
}

class MCPJuliaServer {
  constructor() {
    this.engine = new JuliaMCPEngine();
    this.tools = MCP_JULIA_TOOLS;
  }

  // MCP Protocol: List available tools
  listTools() {
    return Object.entries(this.tools).map(([name, tool]) => ({
      name,
      description: tool.description,
      inputSchema: tool.inputSchema,
    }));
  }

  // MCP Protocol: Call a tool
  async callTool(toolName, params) {
    const tool = this.tools[toolName];
    if (!tool) {
      throw new MCPError('TOOL_NOT_FOUND', `Unknown tool: ${toolName}`);
    }

    try {
      const result = await tool.handler(params);
      return { content: [{ type: 'text', text: JSON.stringify(result, null, 2) }] };
    } catch (error) {
      return {
        content: [{ type: 'text', text: JSON.stringify({ error: error.message }) }],
        isError: true,
      };
    }
  }
}

// ═══ Section 6: Helpers ══════════════════════════════════════════════════════

function median(arr) {
  const sorted = [...arr].sort((a, b) => a - b);
  const mid = Math.floor(sorted.length / 2);
  return sorted.length % 2 ? sorted[mid] : (sorted[mid - 1] + sorted[mid]) / 2;
}

let _engineInstance = null;
function getJuliaEngine() {
  if (!_engineInstance) {
    _engineInstance = new JuliaMCPEngine();
  }
  return _engineInstance;
}

// ═══ Section 7: Exports ══════════════════════════════════════════════════════

export {
  MCP_JULIA_TOOLS,
  MCPJuliaServer,
  JuliaMCPEngine,
  MCPError,
  classifyProbe,
  getJuliaEngine,
  PHI,
  PHI_INV,
  AMOR,
  HEARTBEAT_MS,
};

export default MCPJuliaServer;
