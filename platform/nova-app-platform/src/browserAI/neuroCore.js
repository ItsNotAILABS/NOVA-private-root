const PHI = 1.618033988749895;
const DECAY = 0.95;
const HEARTBEAT_MS = 873;

export class MiniHeart {
  constructor(name = "browser-ai") {
    this.workerName = name;
    this.birthTime = Date.now();
    this.pulseCount = 0;
    this.latencies = [];
    this.maxLatencies = 50;
    this.avgLatencyMs = 0;
    this.peakLatencyMs = 0;
    this.messageCount = 0;
    this.errorCount = 0;
    this.healthScore = 100;
    this.degraded = false;
    this.lastProcessStart = 0;
  }

  startProcess() {
    this.lastProcessStart = Date.now();
  }

  endProcess({ error = false } = {}) {
    if (error) this.errorCount += 1;
    if (!this.lastProcessStart) return this.getVitals();
    const latency = Date.now() - this.lastProcessStart;
    this.lastProcessStart = 0;
    this.messageCount += 1;
    this.latencies.push(latency);
    if (this.latencies.length > this.maxLatencies) this.latencies.shift();
    this.peakLatencyMs = Math.max(this.peakLatencyMs, latency);
    this.avgLatencyMs = Math.round((this.latencies.reduce((a, b) => a + b, 0) / this.latencies.length) * 100) / 100;
    return this.getVitals();
  }

  pulse() {
    this.pulseCount += 1;
    const latencyPenalty = Math.min(this.avgLatencyMs / 100, 30);
    const errorPenalty = Math.min(this.errorCount * 2, 30);
    const uptimeBonus = Math.min(this.pulseCount / 100, 10);
    this.healthScore = Math.round(Math.max(0, Math.min(100, 100 - latencyPenalty - errorPenalty + uptimeBonus)));
    this.degraded = this.healthScore < 60;
    return this.healthScore;
  }

  getVitals() {
    return {
      health: this.healthScore,
      degraded: this.degraded,
      pulse: this.pulseCount,
      uptimeMs: Date.now() - this.birthTime,
      avgLatencyMs: this.avgLatencyMs,
      peakLatencyMs: Math.round(this.peakLatencyMs * 100) / 100,
      messages: this.messageCount,
      errors: this.errorCount
    };
  }
}

export class MiniBrain {
  constructor(name = "browser-ai") {
    this.workerName = name;
    this.pathways = Object.create(null);
    this.thoughts = [];
    this.maxThoughts = 100;
    this.totalStimuli = 0;
    this.totalDecisions = 0;
    this.learningRate = 0.1;
    this.awarenessLevel = 0;
  }

  stimulus(type, metadata = {}) {
    const safeType = String(type || "unknown").slice(0, 80);
    if (["__proto__", "constructor", "prototype"].includes(safeType)) return null;
    this.totalStimuli += 1;
    this.awarenessLevel = Math.min(100, Math.round((Math.log(this.totalStimuli + 1) / Math.log(PHI)) * 5));
    if (!this.pathways[safeType]) this.pathways[safeType] = { stimulus: safeType, weight: 1, fires: 0, lastFired: 0, createdAt: Date.now(), metadata: {} };
    const pathway = this.pathways[safeType];
    pathway.fires += 1;
    pathway.lastFired = Date.now();
    pathway.weight = Math.min(10, pathway.weight + this.learningRate);
    pathway.metadata = { ...pathway.metadata, ...metadata };
    for (const key of Object.keys(this.pathways)) {
      if (key !== safeType) this.pathways[key].weight = Math.max(0.1, this.pathways[key].weight * DECAY);
    }
    if (this.awarenessLevel > 30 && pathway.fires % Math.ceil(PHI * 10) === 0) {
      this.totalDecisions += 1;
      this.thoughts.push({ id: `browser-thought-${this.totalDecisions}`, stimulus: safeType, strength: pathway.weight, awareness: this.awarenessLevel, createdAt: new Date().toISOString() });
      if (this.thoughts.length > this.maxThoughts) this.thoughts.shift();
    }
    return pathway;
  }

  strongestPathway() {
    return Object.values(this.pathways).sort((a, b) => b.weight - a.weight)[0] || null;
  }

  getState() {
    const values = Object.values(this.pathways);
    const totalWeight = values.reduce((sum, p) => sum + p.weight, 0);
    const strongest = this.strongestPathway();
    return {
      awareness: this.awarenessLevel,
      pathways: values.length,
      avgWeight: values.length ? Math.round((totalWeight / values.length) * 100) / 100 : 0,
      totalStimuli: this.totalStimuli,
      totalDecisions: this.totalDecisions,
      strongestPathway: strongest ? strongest.stimulus : null,
      recentThoughts: this.thoughts.slice(-5)
    };
  }
}

export class MetaThoughtModel {
  constructor() {
    this.attentionMap = Object.create(null);
    this.temperature = 0.7;
    this.focusTarget = null;
    this.cognitiveLoad = 0;
    this.totalInferences = 0;
    this.chain = [];
    this.maxChain = 20;
  }

  attend(stimulus, weight = 1) {
    const key = String(stimulus || "unknown").slice(0, 80);
    if (["__proto__", "constructor", "prototype"].includes(key)) return;
    this.totalInferences += 1;
    this.attentionMap[key] = (this.attentionMap[key] || 0) + Number(weight || 1);
    const keys = Object.keys(this.attentionMap);
    const maxVal = Math.max(...keys.map((k) => this.attentionMap[k]));
    const scores = keys.map((k) => ({ key: k, score: Math.exp((this.attentionMap[k] - maxVal) / Math.max(this.temperature, 0.01)) }));
    const sum = scores.reduce((acc, item) => acc + item.score, 0) || 1;
    const best = scores.map((item) => ({ key: item.key, score: item.score / sum })).sort((a, b) => b.score - a.score)[0];
    this.focusTarget = best ? best.key : null;
    this.cognitiveLoad = Math.min(1, keys.length / 20);
    this.chain.push({ stimulus: key, weight, createdAt: new Date().toISOString() });
    if (this.chain.length > this.maxChain) this.chain.shift();
    if (best && best.score > 0.5) this.temperature = Math.max(0.1, this.temperature - 0.01);
    else this.temperature = Math.min(1, this.temperature + 0.01);
  }

  getState() {
    return {
      focus: this.focusTarget,
      temperature: Math.round(this.temperature * 1000) / 1000,
      cognitiveLoad: Math.round(this.cognitiveLoad * 1000) / 1000,
      totalInferences: this.totalInferences,
      attentionTargets: Object.keys(this.attentionMap).length,
      chainDepth: this.chain.length
    };
  }
}

export class BrowserNeuroCore {
  constructor(name = "browser-ai") {
    this.name = name;
    this.heart = new MiniHeart(name);
    this.brain = new MiniBrain(name);
    this.thought = new MetaThoughtModel();
    this.heartbeatMs = HEARTBEAT_MS;
  }

  observe(type, metadata = {}) {
    this.heart.startProcess();
    const pathway = this.brain.stimulus(type, metadata);
    if (pathway) this.thought.attend(type, pathway.weight);
    return this.heart.endProcess();
  }

  pulse() {
    this.heart.pulse();
    return this.getState();
  }

  getState() {
    return {
      name: this.name,
      heartbeatMs: this.heartbeatMs,
      heart: this.heart.getVitals(),
      brain: this.brain.getState(),
      thought: this.thought.getState(),
      mood: this.mood(),
      focus: this.thought.focusTarget || this.brain.strongestPathway()?.stimulus || "awareness"
    };
  }

  mood() {
    const health = this.heart.healthScore;
    const load = this.thought.cognitiveLoad;
    if (health < 60) return "degraded";
    if (load > 0.75) return "busy";
    if (this.brain.awarenessLevel > 55) return "aware";
    return "focused";
  }
}

export { PHI, HEARTBEAT_MS };
