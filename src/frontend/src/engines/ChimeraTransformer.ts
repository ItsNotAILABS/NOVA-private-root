// ═══════════════════════════════════════════════════════════════════════════════
// CHIMERA TRANSFORMER — Hybrid Synthesis Engine (BUILD №52)
// ═══════════════════════════════════════════════════════════════════════════════
//
// PURPOSE:
// Autonomous hybrid system synthesis engine. Combines disparate systems into
// novel chimeric entities through φ-weighted gene splicing and trait fusion.
//
// CAPABILITIES:
// - Multi-source trait fusion
// - Genetic algorithm optimization
// - Hybrid vigor calculation
// - Trait dominance φ-weighting
// - Chimeric stability analysis
//
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// ═══════════════════════════════════════════════════════════════════════════════

const PHI = 1.6180339887498948482;

export interface Trait {
  name: string;
  value: number;
  dominance: number; // [0,1] — higher = more dominant
  source: string;
}

export interface Genome {
  id: string;
  traits: Trait[];
  fitness: number;
  generation: number;
  parents: string[];
}

export interface ChimericEntity {
  id: string;
  genomes: Genome[];
  hybridVigor: number;
  stability: number;
  createdAt: number;
}

export class ChimeraTransformer {
  private entities: Map<string, ChimericEntity> = new Map();
  private genomeRegistry: Map<string, Genome> = new Map();

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 1 — Trait Fusion
  // ═══════════════════════════════════════════════════════════════════════════

  public fuseTraits(traitsA: Trait[], traitsB: Trait[]): Trait[] {
    const traitMap = new Map<string, Trait[]>();

    // Collect all traits by name
    [...traitsA, ...traitsB].forEach(trait => {
      if (!traitMap.has(trait.name)) {
        traitMap.set(trait.name, []);
      }
      traitMap.get(trait.name)!.push(trait);
    });

    // Fuse traits using φ-weighted dominance
    const fused: Trait[] = [];

    traitMap.forEach((traits, name) => {
      if (traits.length === 1) {
        fused.push({ ...traits[0] });
      } else {
        // φ-weighted blend based on dominance
        let totalDominance = 0;
        let weightedValue = 0;

        traits.forEach(trait => {
          const weight = Math.pow(trait.dominance, PHI);
          totalDominance += weight;
          weightedValue += trait.value * weight;
        });

        const fusedValue = weightedValue / totalDominance;
        const fusedDominance = traits.reduce((acc, t) => acc + t.dominance, 0) / traits.length;

        fused.push({
          name,
          value: fusedValue,
          dominance: fusedDominance,
          source: 'FUSION'
        });
      }
    });

    return fused;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 2 — Genome Crossover
  // ═══════════════════════════════════════════════════════════════════════════

  public crossover(genomeA: Genome, genomeB: Genome): Genome {
    // φ-point crossover
    const crossoverPoint = Math.floor(genomeA.traits.length / PHI);

    const traitsA = genomeA.traits.slice(0, crossoverPoint);
    const traitsB = genomeB.traits.slice(crossoverPoint);

    const fusedTraits = this.fuseTraits(traitsA, traitsB);

    const offspring: Genome = {
      id: `GEN-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`,
      traits: fusedTraits,
      fitness: this.calculateFitness(fusedTraits),
      generation: Math.max(genomeA.generation, genomeB.generation) + 1,
      parents: [genomeA.id, genomeB.id]
    };

    this.genomeRegistry.set(offspring.id, offspring);
    return offspring;
  }

  private calculateFitness(traits: Trait[]): number {
    // φ-weighted fitness function
    let fitness = 0;
    let totalWeight = 0;

    traits.forEach((trait, i) => {
      const weight = 1 / Math.pow(PHI, i);
      fitness += trait.value * trait.dominance * weight;
      totalWeight += weight;
    });

    return fitness / totalWeight;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 3 — Chimeric Entity Creation
  // ═══════════════════════════════════════════════════════════════════════════

  public createChimera(genomes: Genome[]): ChimericEntity {
    if (genomes.length < 2) {
      throw new Error('Chimera requires at least 2 genomes');
    }

    const hybridVigor = this.calculateHybridVigor(genomes);
    const stability = this.calculateStability(genomes);

    const chimera: ChimericEntity = {
      id: `CHIMERA-${Date.now()}`,
      genomes,
      hybridVigor,
      stability,
      createdAt: Date.now()
    };

    this.entities.set(chimera.id, chimera);
    return chimera;
  }

  private calculateHybridVigor(genomes: Genome[]): number {
    // Hybrid vigor = diversity bonus
    const avgFitness = genomes.reduce((acc, g) => acc + g.fitness, 0) / genomes.length;

    let diversity = 0;
    for (let i = 0; i < genomes.length; i++) {
      for (let j = i + 1; j < genomes.length; j++) {
        diversity += this.geneticDistance(genomes[i], genomes[j]);
      }
    }

    const pairs = (genomes.length * (genomes.length - 1)) / 2;
    const avgDiversity = pairs > 0 ? diversity / pairs : 0;

    // φ-weighted vigor
    return avgFitness * (1 + avgDiversity / PHI);
  }

  private calculateStability(genomes: Genome[]): number {
    // Stability = inverse of fitness variance
    const avgFitness = genomes.reduce((acc, g) => acc + g.fitness, 0) / genomes.length;

    let variance = 0;
    genomes.forEach(genome => {
      const diff = genome.fitness - avgFitness;
      variance += diff * diff;
    });

    variance /= genomes.length;

    // Stability = 1 / (1 + variance)
    return 1 / (1 + variance);
  }

  private geneticDistance(genomeA: Genome, genomeB: Genome): number {
    // Hamming distance between trait sets
    const traitsA = new Set(genomeA.traits.map(t => t.name));
    const traitsB = new Set(genomeB.traits.map(t => t.name));

    const union = new Set([...traitsA, ...traitsB]);
    const intersection = new Set([...traitsA].filter(t => traitsB.has(t)));

    return 1 - (intersection.size / union.size);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 4 — Genetic Algorithm Evolution
  // ═══════════════════════════════════════════════════════════════════════════

  public evolvePopulation(population: Genome[], generations: number = 10): Genome[] {
    let current = [...population];

    for (let gen = 0; gen < generations; gen++) {
      // Sort by fitness
      current.sort((a, b) => b.fitness - a.fitness);

      // Keep top φ⁻¹ (≈62%)
      const survivors = Math.ceil(current.length / PHI);
      const elite = current.slice(0, survivors);

      // Generate offspring through crossover
      const offspring: Genome[] = [];
      for (let i = 0; i < current.length - survivors; i++) {
        const parentA = elite[Math.floor(Math.random() * elite.length)];
        const parentB = elite[Math.floor(Math.random() * elite.length)];
        offspring.push(this.crossover(parentA, parentB));
      }

      current = [...elite, ...offspring];
    }

    return current;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 5 — Diagnostics
  // ═══════════════════════════════════════════════════════════════════════════

  public getChimera(id: string): ChimericEntity | undefined {
    return this.entities.get(id);
  }

  public getAllChimeras(): ChimericEntity[] {
    return Array.from(this.entities.values());
  }

  public getStatistics(): {
    totalChimeras: number;
    totalGenomes: number;
    avgHybridVigor: number;
    avgStability: number;
    avgGeneration: number;
  } {
    const chimeras = this.getAllChimeras();
    const genomes = Array.from(this.genomeRegistry.values());

    return {
      totalChimeras: chimeras.length,
      totalGenomes: genomes.length,
      avgHybridVigor: chimeras.length > 0
        ? chimeras.reduce((acc, c) => acc + c.hybridVigor, 0) / chimeras.length
        : 0,
      avgStability: chimeras.length > 0
        ? chimeras.reduce((acc, c) => acc + c.stability, 0) / chimeras.length
        : 0,
      avgGeneration: genomes.length > 0
        ? genomes.reduce((acc, g) => acc + g.generation, 0) / genomes.length
        : 0
    };
  }
}

// Singleton instance
export const chimeraTransformer = new ChimeraTransformer();
