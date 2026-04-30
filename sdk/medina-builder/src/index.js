/**
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * @medina/medina-builder — SDK THAT BUILDS OTHER SDKs AND AI ENTITIES
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * 
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ
 * PROPRIETARY — SOVEREIGN INFRASTRUCTURE
 * 
 * This is the META SDK — it can:
 *   - Build other SDKs
 *   - Build AI entities
 *   - Parse instructions and generate implementations
 *   - Deploy to the organism
 *   - Generate code from natural language
 * 
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 */

// ═══════════════════════════════════════════════════════════════════════════════
// §1 — CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

const BUILD_TYPES = {
  SDK: 'SDK',
  AI_ENTITY: 'AI_ENTITY',
  WORKER: 'WORKER',
  SERVICE: 'SERVICE',
  CANISTER: 'CANISTER',
  COMPONENT: 'COMPONENT',
};

const BUILD_STATUS = {
  PENDING: 'PENDING',
  PARSING: 'PARSING',
  GENERATING: 'GENERATING',
  BUILDING: 'BUILDING',
  DEPLOYING: 'DEPLOYING',
  COMPLETED: 'COMPLETED',
  FAILED: 'FAILED',
};

// ═══════════════════════════════════════════════════════════════════════════════
// §2 — INSTRUCTION PARSER
// ═══════════════════════════════════════════════════════════════════════════════

class InstructionParser {
  constructor() {
    this._patterns = new Map();
    this._initPatterns();
  }
  
  _initPatterns() {
    // SDK patterns
    this._patterns.set('create_sdk', {
      regex: /create\s+(a\s+)?(?:new\s+)?sdk\s+(?:called\s+|named\s+)?['""]?(\w+)['""]?\s+(?:that\s+|to\s+)?(.+)/i,
      extract: (match) => ({
        type: BUILD_TYPES.SDK,
        name: match[2],
        description: match[3],
      }),
    });
    
    // AI Entity patterns
    this._patterns.set('create_ai', {
      regex: /(?:birth|create|make)\s+(a\s+)?(?:new\s+)?(?:ai|agent|entity)\s+(?:called\s+|named\s+)?['""]?(\w+)['""]?\s*(?:that\s+|to\s+|with\s+)?(.*)$/i,
      extract: (match) => ({
        type: BUILD_TYPES.AI_ENTITY,
        name: match[2],
        description: match[3] || '',
      }),
    });
    
    // Worker patterns
    this._patterns.set('create_worker', {
      regex: /create\s+(a\s+)?(?:new\s+)?worker\s+(?:called\s+|named\s+)?['""]?(\w+)['""]?\s+(?:that\s+|to\s+)?(.+)/i,
      extract: (match) => ({
        type: BUILD_TYPES.WORKER,
        name: match[2],
        description: match[3],
      }),
    });
    
    // Service patterns
    this._patterns.set('create_service', {
      regex: /create\s+(a\s+)?(?:new\s+)?service\s+(?:called\s+|named\s+)?['""]?(\w+)['""]?\s+(?:that\s+|to\s+)?(.+)/i,
      extract: (match) => ({
        type: BUILD_TYPES.SERVICE,
        name: match[2],
        description: match[3],
      }),
    });
    
    // Canister patterns
    this._patterns.set('create_canister', {
      regex: /create\s+(a\s+)?(?:new\s+)?canister\s+(?:called\s+|named\s+)?['""]?(\w+)['""]?\s+(?:that\s+|to\s+)?(.+)/i,
      extract: (match) => ({
        type: BUILD_TYPES.CANISTER,
        name: match[2],
        description: match[3],
      }),
    });
  }
  
  /**
   * Parse instructions into structured build specification
   */
  parse(instructions) {
    // Handle string instructions
    if (typeof instructions === 'string') {
      return this._parseString(instructions);
    }
    
    // Handle structured instructions
    if (typeof instructions === 'object') {
      return this._parseStructured(instructions);
    }
    
    throw new Error('Invalid instruction format');
  }
  
  _parseString(text) {
    // Try each pattern
    for (const [patternName, pattern] of this._patterns) {
      const match = text.match(pattern.regex);
      if (match) {
        const extracted = pattern.extract(match);
        return {
          ...extracted,
          originalInstruction: text,
          parsedFrom: patternName,
          capabilities: this._extractCapabilities(extracted.description),
        };
      }
    }
    
    // Fallback: treat as general build request
    return {
      type: BUILD_TYPES.SDK,
      name: this._generateName(text),
      description: text,
      originalInstruction: text,
      parsedFrom: 'fallback',
      capabilities: this._extractCapabilities(text),
    };
  }
  
  _parseStructured(obj) {
    return {
      type: obj.type || BUILD_TYPES.SDK,
      name: obj.name || this._generateName(obj.description || ''),
      description: obj.description || '',
      capabilities: obj.capabilities || [],
      config: obj.config || {},
      parsedFrom: 'structured',
    };
  }
  
  _generateName(text) {
    // Extract key words and create a name
    const words = text.toLowerCase()
      .replace(/[^a-z\s]/g, '')
      .split(/\s+/)
      .filter(w => w.length > 3 && !['that', 'with', 'from', 'this', 'will'].includes(w))
      .slice(0, 3);
    
    return words.length > 0 
      ? words.map(w => w.charAt(0).toUpperCase() + w.slice(1)).join('') + 'SDK'
      : `GeneratedSDK_${Date.now()}`;
  }
  
  _extractCapabilities(description) {
    const capabilities = [];
    const keywords = [
      'process', 'analyze', 'generate', 'transform', 'convert',
      'read', 'write', 'store', 'retrieve', 'search',
      'communicate', 'send', 'receive', 'listen', 'broadcast',
      'schedule', 'execute', 'run', 'manage', 'monitor',
    ];
    
    const lowerDesc = (description || '').toLowerCase();
    for (const kw of keywords) {
      if (lowerDesc.includes(kw)) {
        capabilities.push(kw);
      }
    }
    
    return capabilities;
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §3 — CODE GENERATOR
// ═══════════════════════════════════════════════════════════════════════════════

class CodeGenerator {
  constructor() {
    this._templates = new Map();
    this._initTemplates();
  }
  
  _initTemplates() {
    // SDK template
    this._templates.set(BUILD_TYPES.SDK, this._sdkTemplate);
    
    // AI Entity template
    this._templates.set(BUILD_TYPES.AI_ENTITY, this._aiEntityTemplate);
    
    // Worker template
    this._templates.set(BUILD_TYPES.WORKER, this._workerTemplate);
    
    // Service template
    this._templates.set(BUILD_TYPES.SERVICE, this._serviceTemplate);
    
    // Canister template
    this._templates.set(BUILD_TYPES.CANISTER, this._canisterTemplate);
  }
  
  /**
   * Generate code from build specification
   */
  generate(spec) {
    const template = this._templates.get(spec.type);
    if (!template) {
      throw new Error(`No template for type: ${spec.type}`);
    }
    
    return template.call(this, spec);
  }
  
  _sdkTemplate(spec) {
    const { name, description, capabilities } = spec;
    
    const methodDefs = capabilities.map(cap => `
  /**
   * ${cap.charAt(0).toUpperCase() + cap.slice(1)} operation
   */
  ${cap}(params = {}) {
    return this._execute('${cap}', params);
  }`).join('\n');
    
    return {
      filename: `${name.toLowerCase()}/src/index.js`,
      code: `/**
 * ${name} SDK
 * ${description}
 * 
 * AUTO-GENERATED BY @medina/medina-builder
 * Generated: ${new Date().toISOString()}
 */

class ${name} {
  constructor(config = {}) {
    this.config = config;
    this._history = [];
  }
  
  _execute(method, params) {
    const execution = {
      method,
      params,
      timestamp: Date.now(),
    };
    this._history.push(execution);
    
    // Method implementation placeholder
    console.log(\`[${name}] Executing \${method}\`, params);
    
    return { success: true, method, params };
  }
${methodDefs}
  
  getHistory() {
    return [...this._history];
  }
  
  getState() {
    return {
      name: '${name}',
      executionCount: this._history.length,
      capabilities: ${JSON.stringify(capabilities)},
    };
  }
}

const instance = new ${name}();

export { ${name}, instance as default${name.toLowerCase()} };
export default ${name};
`,
      packageJson: {
        name: `@medina/${name.toLowerCase()}`,
        version: '1.0.0',
        description: description,
        type: 'module',
        main: 'src/index.js',
        private: true,
        author: 'MEDINA Builder',
        license: 'PROPRIETARY',
      },
    };
  }
  
  _aiEntityTemplate(spec) {
    const { name, description, capabilities } = spec;
    
    return {
      filename: `${name.toLowerCase()}/src/index.js`,
      code: `/**
 * ${name} AI Entity
 * ${description}
 * 
 * AUTO-GENERATED BY @medina/medina-builder
 * Generated: ${new Date().toISOString()}
 * 
 * THIS ENTITY IS ALIVE UPON CREATION.
 * The constructor IS the bootstrap.
 */

import { birthAI } from '@medina/birth-ai';

const HEARTBEAT_MS = 873;

class ${name}Entity {
  constructor(config = {}) {
    this.name = '${name}';
    this.capabilities = ${JSON.stringify(capabilities)};
    this.born = Date.now();
    
    // IMMEDIATELY ALIVE
    this._bootstrap(config);
  }
  
  _bootstrap(config) {
    // Create the underlying AI
    this._ai = birthAI({
      name: '${name}',
      numHearts: config.numHearts || 1,
      numBrains: config.numBrains || 1,
    });
    
    // Start entity-specific loops
    this._startLoops();
    
    console.log(\`[${name}] Entity is ALIVE\`);
  }
  
  _startLoops() {
    this._mainLoop = setInterval(() => {
      this._tick();
    }, HEARTBEAT_MS);
  }
  
  _tick() {
    // Entity-specific processing
  }
  
  // AI interface methods
  speak(message) { return this._ai.speak(message); }
  hear(message) { return this._ai.hear(message); }
  setGoal(goal, priority) { return this._ai.setGoal(goal, priority); }
  learn(content) { return this._ai.learn(content); }
  recall(query) { return this._ai.recall(query); }
  
  getState() {
    return {
      name: this.name,
      capabilities: this.capabilities,
      born: this.born,
      uptime: Date.now() - this.born,
      ai: this._ai.getState(),
    };
  }
  
  stop() {
    if (this._mainLoop) {
      clearInterval(this._mainLoop);
    }
    this._ai.stop();
  }
}

// Factory function
function birth${name}(config = {}) {
  return new ${name}Entity(config);
}

export { ${name}Entity, birth${name} };
export default birth${name};
`,
      packageJson: {
        name: `@medina/${name.toLowerCase()}-entity`,
        version: '1.0.0',
        description: description || `${name} AI Entity`,
        type: 'module',
        main: 'src/index.js',
        private: true,
        author: 'MEDINA Builder',
        license: 'PROPRIETARY',
      },
    };
  }
  
  _workerTemplate(spec) {
    const { name, description, capabilities } = spec;
    
    return {
      filename: `${name.toLowerCase()}-worker.js`,
      code: `/**
 * ${name} Worker
 * ${description}
 * 
 * AUTO-GENERATED BY @medina/medina-builder
 * Generated: ${new Date().toISOString()}
 * 
 * NOVA SERVITOR — Part of the worker fleet.
 */

const HEARTBEAT = 873;
const PHI = 1.6180339887498948482;

// ═══ WORKER KERNEL ═══
const KERNEL_ID = 'GOL-${name.toUpperCase().slice(0,3)}-001';
const FAMILIA = '${name.toUpperCase()}_AETERNA';

// ═══ COR PARVUM (MiniHeart) ═══
const COR_PARVUM = {
  beats: 0,
  lastBeat: Date.now(),
  
  beat() {
    this.beats++;
    this.lastBeat = Date.now();
  },
};

// ═══ MACHINA VIRTUALIS (State Machine) ═══
const MACHINA = {
  state: 'IDLE',
  transitions: {
    IDLE: ['PROCESSING', 'ERROR'],
    PROCESSING: ['IDLE', 'ERROR'],
    ERROR: ['IDLE'],
  },
  
  transition(newState) {
    if (this.transitions[this.state]?.includes(newState)) {
      this.state = newState;
      return true;
    }
    return false;
  },
};

// ═══ WORKER STATE ═══
const state = {
  kernelId: KERNEL_ID,
  familia: FAMILIA,
  startedAt: Date.now(),
  processedTasks: 0,
  capabilities: ${JSON.stringify(capabilities)},
};

// ═══ MAIN LOOP ═══
function tick() {
  COR_PARVUM.beat();
  
  // Process messages if in Worker context
  if (typeof self !== 'undefined' && self.onmessage) {
    // Web Worker context
  }
}

// ═══ MESSAGE HANDLER ═══
if (typeof self !== 'undefined') {
  self.onmessage = function(e) {
    const { type, payload } = e.data;
    
    MACHINA.transition('PROCESSING');
    
    try {
      // Process based on type
      const result = processTask(type, payload);
      self.postMessage({ type: 'RESULT', payload: result });
    } catch (error) {
      MACHINA.transition('ERROR');
      self.postMessage({ type: 'ERROR', payload: error.message });
    }
    
    MACHINA.transition('IDLE');
    state.processedTasks++;
  };
}

function processTask(type, payload) {
  // Task processing implementation
  return { type, processed: true, timestamp: Date.now() };
}

// ═══ START HEARTBEAT ═══
setInterval(tick, HEARTBEAT);

console.log(\`[${name}Worker] KERNEL \${KERNEL_ID} is ALIVE\`);
`,
      type: 'worker',
    };
  }
  
  _serviceTemplate(spec) {
    const { name, description, capabilities } = spec;
    
    return {
      filename: `${name.toLowerCase()}/src/index.js`,
      code: `/**
 * ${name} Service
 * ${description}
 * 
 * AUTO-GENERATED BY @medina/medina-builder
 * Generated: ${new Date().toISOString()}
 * 
 * ALWAYS-ON SERVICE — Never stops running.
 */

const HEARTBEAT_MS = 873;

class ${name}Service {
  constructor() {
    this.name = '${name}Service';
    this.status = 'STARTING';
    this.born = Date.now();
    this.requestCount = 0;
    this._handlers = new Map();
    
    // Start immediately
    this._start();
  }
  
  _start() {
    this.status = 'RUNNING';
    
    // Heartbeat
    this._heartbeat = setInterval(() => {
      this._tick();
    }, HEARTBEAT_MS);
    
    console.log(\`[${name}Service] Service is RUNNING\`);
  }
  
  _tick() {
    // Service maintenance
  }
  
  /**
   * Register a handler
   */
  register(route, handler) {
    this._handlers.set(route, handler);
  }
  
  /**
   * Handle a request
   */
  async handle(route, request) {
    this.requestCount++;
    
    const handler = this._handlers.get(route);
    if (!handler) {
      throw new Error(\`No handler for route: \${route}\`);
    }
    
    return handler(request);
  }
  
  getState() {
    return {
      name: this.name,
      status: this.status,
      born: this.born,
      uptime: Date.now() - this.born,
      requestCount: this.requestCount,
      routes: Array.from(this._handlers.keys()),
    };
  }
  
  stop() {
    this.status = 'STOPPED';
    if (this._heartbeat) {
      clearInterval(this._heartbeat);
    }
  }
}

const service = new ${name}Service();

export { ${name}Service, service };
export default service;
`,
      packageJson: {
        name: `@medina/${name.toLowerCase()}-service`,
        version: '1.0.0',
        description: description,
        type: 'module',
        main: 'src/index.js',
        private: true,
      },
    };
  }
  
  _canisterTemplate(spec) {
    const { name, description, capabilities } = spec;
    
    return {
      filename: `${name.toLowerCase()}/main.mo`,
      code: `// ═══════════════════════════════════════════════════════════════════════════════
// ${name.toUpperCase()} CANISTER
// ${description}
// 
// AUTO-GENERATED BY @medina/medina-builder
// Generated: ${new Date().toISOString()}
// ═══════════════════════════════════════════════════════════════════════════════

import Time "mo:base/Time";
import Buffer "mo:base/Buffer";
import Nat "mo:base/Nat";

actor ${name} {
  
  // ═══ Section 1 — Constants ═══
  let HEARTBEAT_NS : Nat = 873_000_000; // 873ms in nanoseconds
  
  // ═══ Section 2 — State ═══
  stable var totalCalls : Nat = 0;
  stable var createdAt : Int = Time.now();
  
  // ═══ Section 3 — Public Query ═══
  public query func getState() : async {
    name : Text;
    totalCalls : Nat;
    createdAt : Int;
    uptime : Int;
  } {
    {
      name = "${name}";
      totalCalls = totalCalls;
      createdAt = createdAt;
      uptime = Time.now() - createdAt;
    }
  };
  
  // ═══ Section 4 — Public Update ═══
  public func call(method : Text, payload : Text) : async Text {
    totalCalls += 1;
    // Process call
    "OK: " # method
  };
  
  // ═══ Section 5 — Heartbeat ═══
  system func heartbeat() : async () {
    // Heartbeat processing
  };
};
`,
      type: 'canister',
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §4 — BUILD RECORD
// ═══════════════════════════════════════════════════════════════════════════════

class BuildRecord {
  constructor(spec) {
    this.id = `build_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
    this.spec = spec;
    this.status = BUILD_STATUS.PENDING;
    this.createdAt = Date.now();
    this.startedAt = null;
    this.completedAt = null;
    this.output = null;
    this.error = null;
    this.steps = [];
  }
  
  start() {
    this.status = BUILD_STATUS.PARSING;
    this.startedAt = Date.now();
    this._addStep('Started build process');
  }
  
  parsing() {
    this.status = BUILD_STATUS.PARSING;
    this._addStep('Parsing instructions');
  }
  
  generating() {
    this.status = BUILD_STATUS.GENERATING;
    this._addStep('Generating code');
  }
  
  building() {
    this.status = BUILD_STATUS.BUILDING;
    this._addStep('Building artifacts');
  }
  
  deploying() {
    this.status = BUILD_STATUS.DEPLOYING;
    this._addStep('Deploying');
  }
  
  complete(output) {
    this.status = BUILD_STATUS.COMPLETED;
    this.completedAt = Date.now();
    this.output = output;
    this._addStep('Build completed');
  }
  
  fail(error) {
    this.status = BUILD_STATUS.FAILED;
    this.completedAt = Date.now();
    this.error = error.message || error;
    this._addStep(`Build failed: ${this.error}`);
  }
  
  _addStep(description) {
    this.steps.push({
      description,
      timestamp: Date.now(),
      status: this.status,
    });
  }
  
  toJSON() {
    return {
      id: this.id,
      status: this.status,
      spec: this.spec,
      createdAt: this.createdAt,
      startedAt: this.startedAt,
      completedAt: this.completedAt,
      duration: this.completedAt && this.startedAt 
        ? this.completedAt - this.startedAt 
        : null,
      steps: this.steps,
      error: this.error,
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §5 — BUILDER
// ═══════════════════════════════════════════════════════════════════════════════

class Builder {
  constructor() {
    this._parser = new InstructionParser();
    this._generator = new CodeGenerator();
    this._builds = new Map();
    this._history = [];
  }
  
  /**
   * Build from instructions (string or structured)
   */
  async build(instructions, options = {}) {
    // Parse instructions
    const spec = this._parser.parse(instructions);
    
    // Create build record
    const build = new BuildRecord(spec);
    this._builds.set(build.id, build);
    
    build.start();
    
    try {
      // Generate code
      build.generating();
      const generated = this._generator.generate(spec);
      
      // Build artifacts
      build.building();
      const artifacts = this._buildArtifacts(generated, spec);
      
      // Optionally deploy
      if (options.deploy) {
        build.deploying();
        await this._deploy(artifacts, spec);
      }
      
      build.complete({
        spec,
        generated,
        artifacts,
        deployed: options.deploy || false,
      });
      
      this._history.push(build.toJSON());
      
      return build;
    } catch (error) {
      build.fail(error);
      this._history.push(build.toJSON());
      throw error;
    }
  }
  
  _buildArtifacts(generated, spec) {
    // In a real implementation, this would write files, compile, etc.
    return {
      type: spec.type,
      name: spec.name,
      files: [generated.filename],
      code: generated.code,
      packageJson: generated.packageJson,
      builtAt: Date.now(),
    };
  }
  
  async _deploy(artifacts, spec) {
    // In a real implementation, this would deploy to organism
    console.log(`[Builder] Deploying ${spec.name} to organism...`);
    
    return {
      deployed: true,
      deployedAt: Date.now(),
      location: `@medina/${spec.name.toLowerCase()}`,
    };
  }
  
  /**
   * Quick build an SDK
   */
  async buildSDK(name, description, capabilities = []) {
    return this.build({
      type: BUILD_TYPES.SDK,
      name,
      description,
      capabilities,
    });
  }
  
  /**
   * Quick build an AI entity
   */
  async buildAI(name, description = '', capabilities = []) {
    return this.build({
      type: BUILD_TYPES.AI_ENTITY,
      name,
      description,
      capabilities,
    });
  }
  
  /**
   * Quick build a worker
   */
  async buildWorker(name, description, capabilities = []) {
    return this.build({
      type: BUILD_TYPES.WORKER,
      name,
      description,
      capabilities,
    });
  }
  
  /**
   * Quick build a service
   */
  async buildService(name, description, capabilities = []) {
    return this.build({
      type: BUILD_TYPES.SERVICE,
      name,
      description,
      capabilities,
    });
  }
  
  /**
   * Quick build a canister
   */
  async buildCanister(name, description, capabilities = []) {
    return this.build({
      type: BUILD_TYPES.CANISTER,
      name,
      description,
      capabilities,
    });
  }
  
  /**
   * Get build by ID
   */
  getBuild(buildId) {
    return this._builds.get(buildId);
  }
  
  /**
   * Get build history
   */
  getHistory() {
    return [...this._history];
  }
  
  getState() {
    return {
      totalBuilds: this._builds.size,
      historySize: this._history.length,
      completed: this._history.filter(b => b.status === BUILD_STATUS.COMPLETED).length,
      failed: this._history.filter(b => b.status === BUILD_STATUS.FAILED).length,
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §6 — GLOBAL INSTANCE
// ═══════════════════════════════════════════════════════════════════════════════

const globalBuilder = new Builder();

// ═══════════════════════════════════════════════════════════════════════════════
// §7 — HELPER FUNCTIONS
// ═══════════════════════════════════════════════════════════════════════════════

async function build(instructions, options = {}) {
  return globalBuilder.build(instructions, options);
}

async function buildSDK(name, description, capabilities = []) {
  return globalBuilder.buildSDK(name, description, capabilities);
}

async function buildAI(name, description = '', capabilities = []) {
  return globalBuilder.buildAI(name, description, capabilities);
}

async function buildWorker(name, description, capabilities = []) {
  return globalBuilder.buildWorker(name, description, capabilities);
}

async function buildService(name, description, capabilities = []) {
  return globalBuilder.buildService(name, description, capabilities);
}

async function buildCanister(name, description, capabilities = []) {
  return globalBuilder.buildCanister(name, description, capabilities);
}

// ═══════════════════════════════════════════════════════════════════════════════
// EXPORTS
// ═══════════════════════════════════════════════════════════════════════════════

export {
  // Constants
  BUILD_TYPES,
  BUILD_STATUS,
  
  // Classes
  InstructionParser,
  CodeGenerator,
  BuildRecord,
  Builder,
  
  // Global instance
  globalBuilder,
  
  // Helper functions
  build,
  buildSDK,
  buildAI,
  buildWorker,
  buildService,
  buildCanister,
};

export default {
  BUILD_TYPES,
  BUILD_STATUS,
  Builder,
  globalBuilder,
  build,
  buildSDK,
  buildAI,
  buildWorker,
  buildService,
  buildCanister,
};
