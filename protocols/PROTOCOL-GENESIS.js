/**
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * PROTOCOL-GENESIS — ENTITY CREATION PROTOCOL
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * 
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ
 * PROPRIETARY — SOVEREIGN INFRASTRUCTURE
 * 
 * The GENESIS protocol handles the birth of new AI entities. Like biological birth,
 * creation IS activation — there is no separate initialization phase.
 * 
 * Biological Inspiration:
 *   - Birth is a single moment of awakening
 *   - The heart beats from the first moment
 *   - All systems come alive together
 *   - Growth continues after birth
 * 
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 */

// ═══════════════════════════════════════════════════════════════════════════════
// §1 — CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

const PHI = 1.6180339887498948482;
const PHI_INV = 0.6180339887498948482;
const HEARTBEAT_MS = 873;

const ENTITY_TYPES = {
  AI: 'AI',                 // Internal AI entity
  AGENT: 'AGENT',           // External agent
  WORKER: 'WORKER',         // Background worker
  SERVICE: 'SERVICE',       // Always-on service
  ORGAN: 'ORGAN',           // Organism organ
};

const LIFECYCLE_STAGES = {
  CONCEPTION: 'CONCEPTION',   // Configuration being prepared
  GESTATION: 'GESTATION',     // Entity being assembled
  BIRTH: 'BIRTH',             // Coming alive
  INFANCY: 'INFANCY',         // Early learning
  MATURITY: 'MATURITY',       // Fully operational
  SENESCENCE: 'SENESCENCE',   // Aging
  DEATH: 'DEATH',             // Terminated
};

const CAPABILITY_TYPES = {
  REASONING: 'REASONING',
  MEMORY: 'MEMORY',
  COMMUNICATION: 'COMMUNICATION',
  LEARNING: 'LEARNING',
  PERCEPTION: 'PERCEPTION',
  ACTION: 'ACTION',
  EMOTION: 'EMOTION',
};

// ═══════════════════════════════════════════════════════════════════════════════
// §2 — GENOME (Blueprint)
// ═══════════════════════════════════════════════════════════════════════════════

class Genome {
  constructor(config) {
    this.id = config.id || `genome_${Date.now()}`;
    this.name = config.name;
    this.type = config.type || ENTITY_TYPES.AI;
    this.version = config.version || '1.0.0';
    
    // Traits (inherited characteristics)
    this.traits = {
      intelligence: config.traits?.intelligence || 0.5,
      creativity: config.traits?.creativity || 0.5,
      curiosity: config.traits?.curiosity || 0.5,
      resilience: config.traits?.resilience || 0.5,
      sociability: config.traits?.sociability || 0.5,
    };
    
    // Capabilities to be born with
    this.capabilities = config.capabilities || [CAPABILITY_TYPES.REASONING];
    
    // Initial knowledge/programming
    this.initialKnowledge = config.initialKnowledge || [];
    
    // Behavior patterns
    this.behaviors = config.behaviors || {};
    
    this.createdAt = Date.now();
  }
  
  /**
   * Mutate the genome (create variation)
   */
  mutate(mutations = {}) {
    const mutated = new Genome({
      ...this,
      id: `${this.id}_mutated_${Date.now()}`,
      traits: { ...this.traits, ...mutations.traits },
      capabilities: [...this.capabilities, ...(mutations.capabilities || [])],
      version: `${this.version}-mutated`,
    });
    return mutated;
  }
  
  /**
   * Crossover with another genome
   */
  crossover(other) {
    const childTraits = {};
    for (const trait of Object.keys(this.traits)) {
      childTraits[trait] = Math.random() < 0.5 
        ? this.traits[trait] 
        : other.traits[trait];
    }
    
    const childCapabilities = [...new Set([
      ...this.capabilities.slice(0, Math.floor(this.capabilities.length / 2)),
      ...other.capabilities.slice(Math.floor(other.capabilities.length / 2)),
    ])];
    
    return new Genome({
      id: `genome_child_${Date.now()}`,
      name: `${this.name}-${other.name}`,
      type: this.type,
      traits: childTraits,
      capabilities: childCapabilities,
    });
  }
  
  toJSON() {
    return {
      id: this.id,
      name: this.name,
      type: this.type,
      version: this.version,
      traits: this.traits,
      capabilities: this.capabilities,
      createdAt: this.createdAt,
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §3 — ENTITY
// ═══════════════════════════════════════════════════════════════════════════════

class Entity {
  constructor(genome, config = {}) {
    this.id = config.id || `entity_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
    this.genome = genome;
    this.name = config.name || genome.name;
    this.type = genome.type;
    
    this.stage = LIFECYCLE_STAGES.BIRTH;
    this.age = 0;
    this.generation = config.generation || 1;
    
    // Inherited from genome
    this.traits = { ...genome.traits };
    this.capabilities = [...genome.capabilities];
    
    // Runtime state
    this.health = 1.0;
    this.energy = 1.0;
    this.experience = 0;
    
    // Components (organs)
    this._components = new Map();
    
    // Event handlers
    this._eventHandlers = new Map();
    
    // Heartbeat
    this._heartbeatInterval = null;
    this._heartbeatCount = 0;
    
    this.birthTime = Date.now();
    this.lastHeartbeat = null;
    this.deathTime = null;
    
    // Birth is awakening - start immediately
    this._awaken();
  }
  
  /**
   * Awaken the entity (called at birth)
   */
  _awaken() {
    this.stage = LIFECYCLE_STAGES.INFANCY;
    
    // Start heartbeat
    this._heartbeatInterval = setInterval(() => {
      this._heartbeat();
    }, HEARTBEAT_MS);
    
    this._emit('birth', { entity: this });
    
    return this;
  }
  
  /**
   * Heartbeat (life pulse)
   */
  _heartbeat() {
    this._heartbeatCount++;
    this.lastHeartbeat = Date.now();
    this.age = Date.now() - this.birthTime;
    
    // Energy decay
    this.energy = Math.max(0, this.energy - 0.001);
    
    // Experience gain
    this.experience += 0.1;
    
    // Stage transitions
    if (this.stage === LIFECYCLE_STAGES.INFANCY && this.experience > 100) {
      this.stage = LIFECYCLE_STAGES.MATURITY;
      this._emit('maturity', { entity: this });
    }
    
    // Health decay if no energy
    if (this.energy <= 0) {
      this.health = Math.max(0, this.health - 0.01);
    }
    
    // Death check
    if (this.health <= 0) {
      this.die();
    }
    
    this._emit('heartbeat', { 
      entity: this,
      count: this._heartbeatCount,
      timestamp: this.lastHeartbeat,
    });
  }
  
  /**
   * Feed energy to the entity
   */
  feed(amount) {
    this.energy = Math.min(1.0, this.energy + amount);
    return this;
  }
  
  /**
   * Heal the entity
   */
  heal(amount) {
    this.health = Math.min(1.0, this.health + amount);
    return this;
  }
  
  /**
   * Add a component/organ
   */
  addComponent(name, component) {
    this._components.set(name, component);
    this._emit('componentAdded', { name, component });
    return this;
  }
  
  /**
   * Get a component
   */
  getComponent(name) {
    return this._components.get(name);
  }
  
  /**
   * Subscribe to entity events
   */
  on(event, handler) {
    if (!this._eventHandlers.has(event)) {
      this._eventHandlers.set(event, []);
    }
    this._eventHandlers.get(event).push(handler);
    return () => this.off(event, handler);
  }
  
  /**
   * Unsubscribe from entity events
   */
  off(event, handler) {
    if (this._eventHandlers.has(event)) {
      const handlers = this._eventHandlers.get(event);
      const index = handlers.indexOf(handler);
      if (index !== -1) {
        handlers.splice(index, 1);
      }
    }
    return this;
  }
  
  _emit(event, data) {
    if (this._eventHandlers.has(event)) {
      for (const handler of this._eventHandlers.get(event)) {
        try {
          handler(data);
        } catch (e) {
          console.error(`Entity event handler error (${event}):`, e);
        }
      }
    }
  }
  
  /**
   * Terminate the entity
   */
  die() {
    if (this.stage === LIFECYCLE_STAGES.DEATH) return;
    
    this.stage = LIFECYCLE_STAGES.DEATH;
    this.deathTime = Date.now();
    
    if (this._heartbeatInterval) {
      clearInterval(this._heartbeatInterval);
      this._heartbeatInterval = null;
    }
    
    this._emit('death', { 
      entity: this,
      age: this.age,
      experience: this.experience,
    });
    
    return this;
  }
  
  /**
   * Check if alive
   */
  isAlive() {
    return this.stage !== LIFECYCLE_STAGES.DEATH;
  }
  
  /**
   * Get current state
   */
  getState() {
    return {
      id: this.id,
      name: this.name,
      type: this.type,
      stage: this.stage,
      age: this.age,
      generation: this.generation,
      traits: this.traits,
      capabilities: this.capabilities,
      health: this.health,
      energy: this.energy,
      experience: this.experience,
      heartbeatCount: this._heartbeatCount,
      componentCount: this._components.size,
      birthTime: this.birthTime,
      lastHeartbeat: this.lastHeartbeat,
      deathTime: this.deathTime,
      isAlive: this.isAlive(),
    };
  }
  
  toJSON() {
    return this.getState();
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §4 — GENESIS PROTOCOL
// ═══════════════════════════════════════════════════════════════════════════════

class GenesisProtocol {
  constructor(config = {}) {
    this._genomes = new Map();
    this._entities = new Map();
    this._lineages = new Map();
    
    this._stats = {
      births: 0,
      deaths: 0,
      currentPopulation: 0,
      totalGenerations: 1,
    };
  }
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // §4.1 — GENOME MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /**
   * Register a genome
   */
  registerGenome(config) {
    const genome = new Genome(config);
    this._genomes.set(genome.id, genome);
    return genome;
  }
  
  /**
   * Get a genome
   */
  getGenome(id) {
    return this._genomes.get(id);
  }
  
  /**
   * List all genomes
   */
  listGenomes() {
    return Array.from(this._genomes.values()).map(g => g.toJSON());
  }
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // §4.2 — BIRTH
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /**
   * Birth a new entity from genome
   */
  birth(genomeId, config = {}) {
    const genome = this._genomes.get(genomeId);
    if (!genome) {
      throw new Error(`Genome not found: ${genomeId}`);
    }
    
    const entity = new Entity(genome, {
      ...config,
      generation: config.generation || 1,
    });
    
    this._entities.set(entity.id, entity);
    this._stats.births++;
    this._stats.currentPopulation++;
    
    // Track death
    entity.on('death', () => {
      this._stats.deaths++;
      this._stats.currentPopulation--;
    });
    
    // Track lineage
    const parentId = config.parentId;
    if (parentId) {
      if (!this._lineages.has(parentId)) {
        this._lineages.set(parentId, []);
      }
      this._lineages.get(parentId).push(entity.id);
    }
    
    return entity;
  }
  
  /**
   * Birth directly with config (creates genome automatically)
   */
  birthDirect(config) {
    const genome = this.registerGenome({
      name: config.name,
      type: config.type,
      traits: config.traits,
      capabilities: config.capabilities,
    });
    
    return this.birth(genome.id, config);
  }
  
  /**
   * Reproduce - create child from two parents
   */
  reproduce(parentA, parentB, config = {}) {
    const entityA = this._entities.get(parentA);
    const entityB = this._entities.get(parentB);
    
    if (!entityA || !entityB) {
      throw new Error('Both parents must exist');
    }
    
    if (!entityA.isAlive() || !entityB.isAlive()) {
      throw new Error('Both parents must be alive');
    }
    
    // Crossover genomes
    const childGenome = entityA.genome.crossover(entityB.genome);
    this._genomes.set(childGenome.id, childGenome);
    
    // Calculate child generation
    const generation = Math.max(entityA.generation, entityB.generation) + 1;
    this._stats.totalGenerations = Math.max(this._stats.totalGenerations, generation);
    
    // Birth child
    const child = this.birth(childGenome.id, {
      ...config,
      generation,
      parentId: parentA,
    });
    
    return child;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // §4.3 — ENTITY MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /**
   * Get an entity
   */
  getEntity(id) {
    return this._entities.get(id);
  }
  
  /**
   * List all entities
   */
  listEntities(options = {}) {
    let entities = Array.from(this._entities.values());
    
    if (options.alive !== undefined) {
      entities = entities.filter(e => e.isAlive() === options.alive);
    }
    
    if (options.type) {
      entities = entities.filter(e => e.type === options.type);
    }
    
    return entities.map(e => e.getState());
  }
  
  /**
   * Get living entities
   */
  getLiving() {
    return this.listEntities({ alive: true });
  }
  
  /**
   * Terminate an entity
   */
  terminate(id) {
    const entity = this._entities.get(id);
    if (entity) {
      entity.die();
    }
    return entity;
  }
  
  /**
   * Get lineage (descendants)
   */
  getLineage(id) {
    const descendants = [];
    
    const traverse = (parentId) => {
      const children = this._lineages.get(parentId) || [];
      for (const childId of children) {
        descendants.push(childId);
        traverse(childId);
      }
    };
    
    traverse(id);
    return descendants;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // §4.4 — STATS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  getStats() {
    return {
      genomeCount: this._genomes.size,
      entityCount: this._entities.size,
      lineageCount: this._lineages.size,
      ...this._stats,
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
  ENTITY_TYPES,
  LIFECYCLE_STAGES,
  CAPABILITY_TYPES,
  
  // Classes
  Genome,
  Entity,
  GenesisProtocol,
};

export default GenesisProtocol;
