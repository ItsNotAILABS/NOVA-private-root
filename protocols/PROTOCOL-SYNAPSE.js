/**
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * PROTOCOL-SYNAPSE — NEURAL CONNECTION PROTOCOL
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * 
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ
 * PROPRIETARY — SOVEREIGN INFRASTRUCTURE
 * 
 * The SYNAPSE protocol manages neural connections between entities. Like biological synapses,
 * these connections can strengthen (LTP) or weaken (LTD) based on activity.
 * 
 * Biological Inspiration:
 *   - Synapses strengthen with use (Hebbian learning)
 *   - Synapses weaken without use (forgetting)
 *   - Multiple neurotransmitter types for different signals
 *   - Plasticity allows learning and adaptation
 * 
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 */

// ═══════════════════════════════════════════════════════════════════════════════
// §1 — CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

const PHI = 1.6180339887498948482;
const PHI_INV = 0.6180339887498948482;
const HEARTBEAT_MS = 873;

const SYNAPSE_TYPES = {
  EXCITATORY: 'EXCITATORY',   // Increases target activity
  INHIBITORY: 'INHIBITORY',   // Decreases target activity
  MODULATORY: 'MODULATORY',   // Modifies other synapses
};

const NEUROTRANSMITTERS = {
  GLUTAMATE: 'GLUTAMATE',     // Main excitatory
  GABA: 'GABA',               // Main inhibitory
  DOPAMINE: 'DOPAMINE',       // Reward/motivation
  SEROTONIN: 'SEROTONIN',     // Mood/regulation
  ACETYLCHOLINE: 'ACETYLCHOLINE', // Learning/attention
};

const PLASTICITY_RULES = {
  HEBBIAN: 'HEBBIAN',         // Fire together, wire together
  ANTI_HEBBIAN: 'ANTI_HEBBIAN', // Decorrelation
  STDP: 'STDP',               // Spike timing dependent
  HOMEOSTATIC: 'HOMEOSTATIC', // Maintain stability
};

// ═══════════════════════════════════════════════════════════════════════════════
// §2 — SYNAPSE
// ═══════════════════════════════════════════════════════════════════════════════

class Synapse {
  constructor(presynaptic, postsynaptic, config = {}) {
    this.id = config.id || `syn_${presynaptic}_${postsynaptic}_${Date.now()}`;
    this.presynaptic = presynaptic;
    this.postsynaptic = postsynaptic;
    this.type = config.type || SYNAPSE_TYPES.EXCITATORY;
    this.neurotransmitter = config.neurotransmitter || NEUROTRANSMITTERS.GLUTAMATE;
    
    this.weight = config.weight || 0.5;
    this.minWeight = config.minWeight || 0.0;
    this.maxWeight = config.maxWeight || 1.0;
    this.delay = config.delay || 0;
    
    this.plasticityRule = config.plasticityRule || PLASTICITY_RULES.HEBBIAN;
    this.learningRate = config.learningRate || 0.01;
    
    this.createdAt = Date.now();
    this.lastActive = null;
    this.transmissionCount = 0;
    
    this._potentiated = false;
    this._depressed = false;
  }
  
  /**
   * Transmit a signal
   */
  transmit(signal) {
    const weighted = signal * this.weight;
    
    this.lastActive = Date.now();
    this.transmissionCount++;
    
    // Apply synapse type
    let output;
    switch (this.type) {
      case SYNAPSE_TYPES.EXCITATORY:
        output = weighted;
        break;
      case SYNAPSE_TYPES.INHIBITORY:
        output = -weighted;
        break;
      case SYNAPSE_TYPES.MODULATORY:
        output = { type: 'modulation', value: weighted };
        break;
      default:
        output = weighted;
    }
    
    return {
      from: this.presynaptic,
      to: this.postsynaptic,
      signal: output,
      neurotransmitter: this.neurotransmitter,
      delay: this.delay,
      timestamp: Date.now(),
    };
  }
  
  /**
   * Strengthen the synapse (LTP)
   */
  potentiate(amount = null) {
    const delta = amount || this.learningRate * PHI;
    this.weight = Math.min(this.maxWeight, this.weight + delta);
    this._potentiated = true;
    return this;
  }
  
  /**
   * Weaken the synapse (LTD)
   */
  depress(amount = null) {
    const delta = amount || this.learningRate * PHI_INV;
    this.weight = Math.max(this.minWeight, this.weight - delta);
    this._depressed = true;
    return this;
  }
  
  /**
   * Apply plasticity based on activity
   */
  applyPlasticity(preActivity, postActivity, timing = 0) {
    switch (this.plasticityRule) {
      case PLASTICITY_RULES.HEBBIAN:
        // Fire together, wire together
        if (preActivity > 0.5 && postActivity > 0.5) {
          this.potentiate(this.learningRate * preActivity * postActivity);
        }
        break;
        
      case PLASTICITY_RULES.ANTI_HEBBIAN:
        // Decorrelation
        if (preActivity > 0.5 && postActivity > 0.5) {
          this.depress(this.learningRate * preActivity * postActivity);
        }
        break;
        
      case PLASTICITY_RULES.STDP:
        // Spike timing dependent plasticity
        if (timing > 0) {
          // Pre before post -> LTP
          this.potentiate(this.learningRate * Math.exp(-timing / 20));
        } else if (timing < 0) {
          // Post before pre -> LTD
          this.depress(this.learningRate * Math.exp(timing / 20));
        }
        break;
        
      case PLASTICITY_RULES.HOMEOSTATIC:
        // Maintain average activity
        const target = 0.5;
        if (postActivity > target) {
          this.depress(this.learningRate * (postActivity - target));
        } else {
          this.potentiate(this.learningRate * (target - postActivity));
        }
        break;
    }
    
    return this;
  }
  
  /**
   * Decay weight over time (forgetting)
   */
  decay(rate = 0.001) {
    const timeSinceActive = this.lastActive 
      ? Date.now() - this.lastActive 
      : Date.now() - this.createdAt;
    
    const decayFactor = Math.exp(-rate * timeSinceActive / 1000);
    this.weight = this.weight * decayFactor;
    
    return this;
  }
  
  toJSON() {
    return {
      id: this.id,
      presynaptic: this.presynaptic,
      postsynaptic: this.postsynaptic,
      type: this.type,
      neurotransmitter: this.neurotransmitter,
      weight: this.weight,
      delay: this.delay,
      plasticityRule: this.plasticityRule,
      transmissionCount: this.transmissionCount,
      lastActive: this.lastActive,
      createdAt: this.createdAt,
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §3 — NEURON
// ═══════════════════════════════════════════════════════════════════════════════

class Neuron {
  constructor(id, config = {}) {
    this.id = id;
    this.type = config.type || 'standard';
    this.threshold = config.threshold || 0.5;
    this.restingPotential = config.restingPotential || 0.0;
    this.decayRate = config.decayRate || 0.1;
    
    this.potential = this.restingPotential;
    this.activity = 0;
    this.refractoryPeriod = config.refractoryPeriod || 10;
    this.lastFired = null;
    
    this._inputSynapses = [];
    this._outputSynapses = [];
    this._pendingInputs = [];
  }
  
  /**
   * Receive input from synapse
   */
  receive(transmission) {
    // Apply delay
    setTimeout(() => {
      this._pendingInputs.push(transmission);
    }, transmission.delay || 0);
    
    return this;
  }
  
  /**
   * Process inputs and potentially fire
   */
  process() {
    // Check refractory period
    if (this.lastFired && Date.now() - this.lastFired < this.refractoryPeriod) {
      this._pendingInputs = [];
      return { fired: false, reason: 'refractory' };
    }
    
    // Sum inputs
    let totalInput = 0;
    for (const input of this._pendingInputs) {
      if (typeof input.signal === 'number') {
        totalInput += input.signal;
      }
    }
    this._pendingInputs = [];
    
    // Update potential
    this.potential = this.potential + totalInput;
    
    // Decay towards resting
    this.potential = this.potential * (1 - this.decayRate) + 
                     this.restingPotential * this.decayRate;
    
    // Check if should fire
    if (this.potential >= this.threshold) {
      return this._fire();
    }
    
    return { fired: false, potential: this.potential };
  }
  
  /**
   * Fire the neuron
   */
  _fire() {
    this.lastFired = Date.now();
    this.activity = 1.0;
    
    // Reset potential
    const output = this.potential;
    this.potential = this.restingPotential;
    
    // Transmit to output synapses
    const transmissions = [];
    for (const synapse of this._outputSynapses) {
      transmissions.push(synapse.transmit(output));
    }
    
    return {
      fired: true,
      output,
      transmissions,
      timestamp: this.lastFired,
    };
  }
  
  /**
   * Add input synapse
   */
  addInputSynapse(synapse) {
    this._inputSynapses.push(synapse);
    return this;
  }
  
  /**
   * Add output synapse
   */
  addOutputSynapse(synapse) {
    this._outputSynapses.push(synapse);
    return this;
  }
  
  /**
   * Get current state
   */
  getState() {
    return {
      id: this.id,
      type: this.type,
      potential: this.potential,
      threshold: this.threshold,
      activity: this.activity,
      inputCount: this._inputSynapses.length,
      outputCount: this._outputSynapses.length,
      lastFired: this.lastFired,
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §4 — SYNAPSE PROTOCOL
// ═══════════════════════════════════════════════════════════════════════════════

class SynapseProtocol {
  constructor(config = {}) {
    this._neurons = new Map();
    this._synapses = new Map();
    
    this._heartbeatInterval = null;
    this._running = false;
    
    this._stats = {
      totalTransmissions: 0,
      totalFirings: 0,
      potentiations: 0,
      depressions: 0,
    };
  }
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // §4.1 — NEURON MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /**
   * Create a neuron
   */
  createNeuron(id, config = {}) {
    const neuron = new Neuron(id, config);
    this._neurons.set(id, neuron);
    return neuron;
  }
  
  /**
   * Get a neuron
   */
  getNeuron(id) {
    return this._neurons.get(id);
  }
  
  /**
   * Remove a neuron
   */
  removeNeuron(id) {
    const neuron = this._neurons.get(id);
    if (neuron) {
      // Remove associated synapses
      for (const synapse of this._synapses.values()) {
        if (synapse.presynaptic === id || synapse.postsynaptic === id) {
          this._synapses.delete(synapse.id);
        }
      }
      this._neurons.delete(id);
    }
    return neuron;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // §4.2 — SYNAPSE MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /**
   * Connect two neurons
   */
  connect(preId, postId, config = {}) {
    const preNeuron = this._neurons.get(preId);
    const postNeuron = this._neurons.get(postId);
    
    if (!preNeuron || !postNeuron) {
      throw new Error('Both neurons must exist');
    }
    
    const synapse = new Synapse(preId, postId, config);
    this._synapses.set(synapse.id, synapse);
    
    preNeuron.addOutputSynapse(synapse);
    postNeuron.addInputSynapse(synapse);
    
    return synapse;
  }
  
  /**
   * Disconnect two neurons
   */
  disconnect(preId, postId) {
    for (const [id, synapse] of this._synapses) {
      if (synapse.presynaptic === preId && synapse.postsynaptic === postId) {
        this._synapses.delete(id);
        return synapse;
      }
    }
    return null;
  }
  
  /**
   * Get synapse between two neurons
   */
  getSynapse(preId, postId) {
    for (const synapse of this._synapses.values()) {
      if (synapse.presynaptic === preId && synapse.postsynaptic === postId) {
        return synapse;
      }
    }
    return null;
  }
  
  /**
   * Get all synapses for a neuron
   */
  getSynapsesFor(neuronId) {
    const input = [];
    const output = [];
    
    for (const synapse of this._synapses.values()) {
      if (synapse.presynaptic === neuronId) {
        output.push(synapse);
      }
      if (synapse.postsynaptic === neuronId) {
        input.push(synapse);
      }
    }
    
    return { input, output };
  }
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // §4.3 — SIGNAL PROPAGATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /**
   * Inject a signal into a neuron
   */
  inject(neuronId, signal) {
    const neuron = this._neurons.get(neuronId);
    if (!neuron) {
      throw new Error(`Neuron not found: ${neuronId}`);
    }
    
    neuron.receive({
      signal,
      timestamp: Date.now(),
      delay: 0,
    });
    
    return this;
  }
  
  /**
   * Process all neurons (single tick)
   */
  tick() {
    const results = [];
    
    for (const neuron of this._neurons.values()) {
      const result = neuron.process();
      
      if (result.fired) {
        this._stats.totalFirings++;
        
        // Deliver transmissions
        for (const transmission of result.transmissions) {
          this._stats.totalTransmissions++;
          
          const target = this._neurons.get(transmission.to);
          if (target) {
            target.receive(transmission);
          }
        }
        
        results.push(result);
      }
      
      // Update activity decay
      neuron.activity = neuron.activity * 0.9;
    }
    
    return results;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // §4.4 — LEARNING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /**
   * Apply plasticity to all synapses
   */
  learn() {
    for (const synapse of this._synapses.values()) {
      const preNeuron = this._neurons.get(synapse.presynaptic);
      const postNeuron = this._neurons.get(synapse.postsynaptic);
      
      if (preNeuron && postNeuron) {
        const prevWeight = synapse.weight;
        synapse.applyPlasticity(preNeuron.activity, postNeuron.activity);
        
        if (synapse.weight > prevWeight) {
          this._stats.potentiations++;
        } else if (synapse.weight < prevWeight) {
          this._stats.depressions++;
        }
      }
    }
    
    return this;
  }
  
  /**
   * Apply decay to all synapses
   */
  applyDecay(rate = 0.001) {
    for (const synapse of this._synapses.values()) {
      synapse.decay(rate);
    }
    return this;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // §4.5 — LIFECYCLE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /**
   * Start the protocol
   */
  start() {
    if (this._running) return this;
    
    this._running = true;
    
    this._heartbeatInterval = setInterval(() => {
      this.tick();
      this.learn();
    }, HEARTBEAT_MS);
    
    return this;
  }
  
  /**
   * Stop the protocol
   */
  stop() {
    this._running = false;
    
    if (this._heartbeatInterval) {
      clearInterval(this._heartbeatInterval);
      this._heartbeatInterval = null;
    }
    
    return this;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // §4.6 — STATS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  getStats() {
    return {
      running: this._running,
      neuronCount: this._neurons.size,
      synapseCount: this._synapses.size,
      ...this._stats,
    };
  }
  
  getTopology() {
    return {
      neurons: Array.from(this._neurons.values()).map(n => n.getState()),
      synapses: Array.from(this._synapses.values()).map(s => s.toJSON()),
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §5 — EXPORTS
// ═══════════════════════════════════════════════════════════════════════════════

export {
  // Constants
  PHI,
  PHI_INV,
  HEARTBEAT_MS,
  SYNAPSE_TYPES,
  NEUROTRANSMITTERS,
  PLASTICITY_RULES,
  
  // Classes
  Synapse,
  Neuron,
  SynapseProtocol,
};

export default SynapseProtocol;
