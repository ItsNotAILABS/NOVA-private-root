// ─── NOVA / PARALLAX — World Simulation Engines ──────────────────────────────
// MacroStateEngine, GradientFieldEngine, MorphogenesisEngine,
// MaterializationEngine, HistorySedimentEngine, DomainUnlockEngine,
// WorldGenerator — all math-first, causal order law→state→gradients→morph.
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026

import {
  clamp, ema, gaussianKernel, diffuseField, decayField,
  MORPHOGENESIS_RULES, materializationState, checkDomainUnlock,
  DOMAIN_UNLOCK_RULES,
  type GradientGrid,
  type WorldStructureClass,
  type MaterialState,
} from '../math/core';

import type {
  MacroState,
  WorldObject,
} from '../types/organism';

// ── MacroStateEngine ──────────────────────────────────────────────────────────
// Tracks the whole world's active internal simulation state.
// Causal position: #1 — law → STATE → ...
// Every field has a slow EMA (τ ≈ 20 beats) for inertia.

export class MacroStateEngine {
  private s: MacroState;

  constructor() {
    this.s = {
      beat:               0,
      coherence:          0.70,
      escalation:         0.10,
      pressure:           0.20,
      trust:              0.75,
      lawDensity:         0.40,
      damage:             0.05,
      memoryDensity:      0.50,
      stability:          0.80,
      energy:             1.30,
      trafficFlow:        0.30,
      anomalyDensity:     0.05,
      domainActivation:   0.10,
      infrastructureMaturity: 0.10,
      nodeMaturity:       0.05,
      worldAge:           0,
    };
  }

  get state(): MacroState { return { ...this.s }; }

  /**
   * Update macro-state from swarm metrics and drone aggregates.
   * Called once per beat BEFORE gradient computation.
   */
  tick(
    rSwarm:       number,   // Kuramoto order
    jDrift:       number,   // Jasmine drift
    meanEnergy:   number,
    meanCortisol: number,
    meanTrust:    number,
    meanAnomaly:  number,
    meanTraffic:  number,
    beat:         number
  ): MacroState {
    const TAU = 20.0;  // slow adaptation time constant

    const coherence  = ema(this.s.coherence,  rSwarm,                      TAU);
    const escalation = ema(this.s.escalation, clamp(jDrift / 3, 0, 1),     TAU);
    const pressure   = ema(this.s.pressure,   clamp(meanCortisol - 1, 0, 1), TAU);
    const trust      = ema(this.s.trust,      meanTrust,                    TAU);
    const anomaly    = ema(this.s.anomalyDensity, meanAnomaly,              TAU);
    const damage     = ema(this.s.damage,     clamp(escalation * 0.5 + anomaly * 0.3, 0, 1), TAU);
    const stability  = clamp(1 - escalation - damage * 0.5, 0, 1);
    const traffic    = ema(this.s.trafficFlow, meanTraffic,                 TAU);
    const energy     = ema(this.s.energy,     meanEnergy,                   TAU);
    const memory     = ema(this.s.memoryDensity, clamp(coherence * 0.8 + trust * 0.2, 0, 1), TAU);
    const lawDen     = ema(this.s.lawDensity,  clamp(trust * 0.7 + coherence * 0.3, 0, 1),   TAU);

    // Infra and node maturity grow very slowly from stable conditions
    const infraGrowth = stability > 0.6 ? 0.0005 : -0.0002;
    const nodeGrowth  = coherence > 0.7 && traffic > 0.5 ? 0.0003 : -0.0001;
    const infra = clamp(this.s.infrastructureMaturity + infraGrowth, 0, 1);
    const nodes = clamp(this.s.nodeMaturity + nodeGrowth, 0, 1);

    // Domain activation: fraction of DOMAIN_UNLOCK_RULES currently met
    const unlocked = DOMAIN_UNLOCK_RULES.filter(r =>
      checkDomainUnlock(r, coherence, stability, lawDen, beat)
    ).length;
    const domainAct = clamp(unlocked / DOMAIN_UNLOCK_RULES.length, 0, 1);

    this.s = {
      beat,
      coherence, escalation, pressure, trust,
      lawDensity: lawDen,
      damage, memoryDensity: memory, stability,
      energy, trafficFlow: traffic,
      anomalyDensity: anomaly,
      domainActivation: domainAct,
      infrastructureMaturity: infra,
      nodeMaturity: nodes,
      worldAge: beat,
    };

    return this.state;
  }
}

// ── GradientFieldEngine ───────────────────────────────────────────────────────
// Computes 8 spatial gradient fields from macro-state.
// Causal position: #3 — law → state → GRADIENTS → ...

export const GRID_W = 64;
export const GRID_H = 64;
export const GRID_SIZE = GRID_W * GRID_H;

export interface GradientFields {
  coherenceField:    GradientGrid;  // where coherence is high
  pressureField:     GradientGrid;  // conflict/stress zones
  damageField:       GradientGrid;  // structural damage
  lawDensityField:   GradientGrid;  // law-governed zones
  memoryField:       GradientGrid;  // memory-dense areas
  stabilityField:    GradientGrid;  // stable zones
  energyField:       GradientGrid;  // energy/resource concentration
  trafficField:      GradientGrid;  // movement/flow corridors
}

function emptyGrid(): GradientGrid {
  return new Array(GRID_SIZE).fill(0) as GradientGrid;
}

export class GradientFieldEngine {
  private fields: GradientFields;
  // Track "hot spots" — e.g., faction hubs, battle sites
  private hotSpots: Array<{ x: number; y: number; field: keyof GradientFields; magnitude: number }> = [];

  constructor() {
    this.fields = {
      coherenceField:  emptyGrid(),
      pressureField:   emptyGrid(),
      damageField:     emptyGrid(),
      lawDensityField: emptyGrid(),
      memoryField:     emptyGrid(),
      stabilityField:  emptyGrid(),
      energyField:     emptyGrid(),
      trafficField:    emptyGrid(),
    };
  }

  get snapshot(): GradientFields { return this.fields; }

  /** Add a hot spot that will influence gradient fields */
  addHotSpot(x: number, y: number, field: keyof GradientFields, magnitude: number): void {
    this.hotSpots.push({ x, y, field, magnitude });
    if (this.hotSpots.length > 200) this.hotSpots.shift();
  }

  /**
   * Update all gradient fields from macro-state.
   * Hot spots inject Gaussian kernels; then diffuse and decay.
   */
  tick(macro: MacroState): GradientFields {
    const DIFFUSE = 0.08;
    const DECAY   = 0.002;

    // Globally modulate fields from macro-state scalars
    // Coherence field: high where coherence is high
    const baseCoherence = emptyGrid();
    const cx = GRID_W / 2, cy = GRID_H / 2;
    let cf = gaussianKernel(baseCoherence, GRID_W, GRID_H, cx, cy,
      15 * macro.coherence + 5, macro.coherence * 0.8);

    // Pressure field: ring around edges (frontier conflict)
    let pf: GradientGrid = new Array(GRID_SIZE).fill(0);
    for (let r = 0; r < GRID_H; r++) {
      for (let c = 0; c < GRID_W; c++) {
        const dx = c - cx, dy = r - cy;
        const dist = Math.sqrt(dx * dx + dy * dy) / (GRID_W / 2);
        pf[r * GRID_W + c] = clamp(dist * macro.pressure, 0, 1);
      }
    }

    // Damage field: accumulates from escalation (persist from previous)
    let df = this.fields.damageField;
    df = decayField(df, DECAY * 0.5);
    df = diffuseField(df, GRID_W, GRID_H, DIFFUSE * 0.5);
    if (macro.escalation > 0.4) {
      // New damage at random battle sites
      const bx = cx + (Math.random() - 0.5) * GRID_W * 0.8;
      const by = cy + (Math.random() - 0.5) * GRID_H * 0.8;
      df = gaussianKernel(df, GRID_W, GRID_H, bx, by, 8, macro.escalation * 0.4);
    }

    // Law density field: concentrated in center/hubs
    let lf = gaussianKernel(emptyGrid(), GRID_W, GRID_H, cx, cy,
      20 * macro.lawDensity + 3, macro.lawDensity);

    // Memory field: matches coherence but slower
    let mf = gaussianKernel(emptyGrid(), GRID_W, GRID_H, cx, cy,
      18 * macro.memoryDensity + 4, macro.memoryDensity * 0.9);
    mf = diffuseField(
      this.fields.memoryField.map((v, i) => Math.max(v * 0.98, mf[i] ?? 0)),
      GRID_W, GRID_H, DIFFUSE * 0.3
    );

    // Stability field: inverse of escalation+damage
    const sf_: GradientGrid = new Array(GRID_SIZE).fill(0);
    for (let i = 0; i < GRID_SIZE; i++) {
      sf_[i] = clamp(macro.stability - (df[i] ?? 0) * 0.5, 0, 1);
    }

    // Energy field: radiates from center proportional to mean energy
    let ef = gaussianKernel(emptyGrid(), GRID_W, GRID_H, cx, cy,
      12 * (macro.energy / 2), macro.energy / 2);

    // Traffic field: main corridors — cross pattern
    let tf: GradientGrid = new Array(GRID_SIZE).fill(0);
    for (let r = 0; r < GRID_H; r++) {
      for (let c = 0; c < GRID_W; c++) {
        const hCorridor = Math.exp(-((r - cy) ** 2) / (8 ** 2));
        const vCorridor = Math.exp(-((c - cx) ** 2) / (8 ** 2));
        tf[r * GRID_W + c] = clamp((hCorridor + vCorridor) * macro.trafficFlow, 0, 1);
      }
    }

    // Apply hot spots
    for (const hs of this.hotSpots) {
      const gx = clamp(Math.round(hs.x), 0, GRID_W - 1);
      const gy = clamp(Math.round(hs.y), 0, GRID_H - 1);
      switch (hs.field) {
        case 'coherenceField':  cf = gaussianKernel(cf, GRID_W, GRID_H, gx, gy, 6, hs.magnitude); break;
        case 'pressureField':   pf = gaussianKernel(pf, GRID_W, GRID_H, gx, gy, 6, hs.magnitude); break;
        case 'damageField':     df = gaussianKernel(df, GRID_W, GRID_H, gx, gy, 5, hs.magnitude); break;
        case 'trafficField':    tf = gaussianKernel(tf, GRID_W, GRID_H, gx, gy, 4, hs.magnitude); break;
        default: break;
      }
    }

    // Diffuse all fields
    cf = diffuseField(cf, GRID_W, GRID_H, DIFFUSE);
    pf = diffuseField(pf, GRID_W, GRID_H, DIFFUSE);
    lf = diffuseField(lf, GRID_W, GRID_H, DIFFUSE * 0.5);
    ef = diffuseField(ef, GRID_W, GRID_H, DIFFUSE);
    tf = diffuseField(tf, GRID_W, GRID_H, DIFFUSE * 0.8);

    this.fields = {
      coherenceField:  cf,
      pressureField:   pf,
      damageField:     df,
      lawDensityField: lf,
      memoryField:     mf,
      stabilityField:  sf_,
      energyField:     ef,
      trafficField:    tf,
    };

    return this.fields;
  }
}

// ── MorphogenesisEngine ───────────────────────────────────────────────────────
// Translates gradient fields into world structure generation decisions.
// Causal position: #4 — law → state → gradients → MORPHOGENESIS → ...

export interface MorphogenesisDecision {
  structureClass: WorldStructureClass;
  gridX:          number;
  gridY:          number;
  magnitude:      number;
  confidence:     number;
}

export class MorphogenesisEngine {
  private readonly SAMPLE_STEP = 4;  // sample every N grid cells

  /**
   * Scan gradient fields and emit structure-generation decisions.
   * Applies MORPHOGENESIS_RULES (from math/core) at each sampled point.
   */
  tick(fields: GradientFields): MorphogenesisDecision[] {
    const decisions: MorphogenesisDecision[] = [];

    for (let r = 0; r < GRID_H; r += this.SAMPLE_STEP) {
      for (let c = 0; c < GRID_W; c += this.SAMPLE_STEP) {
        const idx = r * GRID_W + c;
        const coherence  = fields.coherenceField[idx]  ?? 0;
        const pressure   = fields.pressureField[idx]   ?? 0;
        const damage     = fields.damageField[idx]      ?? 0;
        const lawDensity = fields.lawDensityField[idx]  ?? 0;
        const stability  = fields.stabilityField[idx]   ?? 0;
        const traffic    = fields.trafficField[idx]     ?? 0;

        // Scars from high damage
        if (damage > 0.55) {
          decisions.push({ structureClass: 'scar', gridX: c, gridY: r, magnitude: damage, confidence: damage });
        }

        // Ruins from sustained damage + low coherence
        if (damage > 0.70 && coherence < 0.30) {
          decisions.push({ structureClass: 'ruin', gridX: c, gridY: r, magnitude: damage * 0.8, confidence: 0.85 });
        }

        // Apply all morphogenesis rules
        for (const rule of MORPHOGENESIS_RULES) {
          if (
            coherence  >= rule.coherenceMin &&
            pressure   >= rule.pressureMin &&
            stability  >= rule.stabilityMin &&
            damage     <= rule.damageMax &&
            lawDensity >= rule.lawDensityMin &&
            traffic    >= rule.trafficMin
          ) {
            // Confidence proportional to how far above threshold each field is
            const conf = clamp(
              (coherence - rule.coherenceMin) * 0.25 +
              (stability - rule.stabilityMin) * 0.25 +
              (traffic   - rule.trafficMin)   * 0.25 +
              (lawDensity - rule.lawDensityMin) * 0.25,
              0, 1
            );
            if (conf > 0.05) {
              decisions.push({
                structureClass: rule.structureClass,
                gridX: c, gridY: r,
                magnitude: conf,
                confidence: conf,
              });
            }
          }
        }
      }
    }

    return decisions;
  }
}

// ── MaterializationEngine ─────────────────────────────────────────────────────
// Determines the material state (fluid → sacred) of each generated structure.
// Causal position: #5

export class MaterializationEngine {
  determineMaterial(
    obj: Pick<WorldObject, 'coherence' | 'damage' | 'age'> & { lawDensity: number }
  ): MaterialState {
    return materializationState(obj.coherence, obj.damage, obj.age, obj.lawDensity);
  }
}

// ── HistorySedimentEngine ─────────────────────────────────────────────────────
// Stores structural residue (scars, monuments, ruins) over time.
// Causal position: #6

export interface HistorySediment {
  id:         string;
  type:       'scar' | 'monument' | 'ruin' | 'law-residue' | 'ghost-corridor';
  gridX:      number;
  gridY:      number;
  x:          number;  // alias for gridX (renderer convenience)
  y:          number;  // alias for gridY (renderer convenience)
  magnitude:  number;
  beat:       number;
  permanent:  boolean;  // if true, never decays
}

export class HistorySedimentEngine {
  private sediments: Map<string, HistorySediment> = new Map();
  private nextId = 1;

  deposit(
    type: HistorySediment['type'],
    gridX: number, gridY: number,
    magnitude: number, beat: number,
    permanent = false
  ): void {
    const key = `${Math.round(gridX)},${Math.round(gridY)}`;
    const existing = this.sediments.get(key);
    if (existing) {
      // Reinforce existing sediment
      this.sediments.set(key, {
        ...existing,
        magnitude: Math.min(1, existing.magnitude + magnitude * 0.3),
        beat,
      });
    } else {
      this.sediments.set(`${key}_${this.nextId++}`, {
        id:    `sed_${this.nextId}`,
        type, gridX, gridY,
        x: gridX, y: gridY,
        magnitude, beat, permanent,
      });
    }
    // Cap total sediments
    if (this.sediments.size > 500) {
      const oldest = [...this.sediments.entries()]
        .sort(([, a], [, b]) => a.beat - b.beat)[0];
      if (oldest && !oldest[1].permanent) {
        this.sediments.delete(oldest[0]);
      }
    }
  }

  /** Decay non-permanent sediments toward zero */
  tick(decayRate = 0.001): void {
    for (const [key, sed] of this.sediments) {
      if (sed.permanent) continue;
      const next = sed.magnitude - decayRate;
      if (next <= 0) {
        this.sediments.delete(key);
      } else {
        this.sediments.set(key, { ...sed, magnitude: next });
      }
    }
  }

  get all(): HistorySediment[] {
    return [...this.sediments.values()];
  }
}

// ── DomainUnlockEngine ────────────────────────────────────────────────────────
// Activates new world layers when macro-state thresholds are crossed.

export interface UnlockedDomain {
  ruleId:      string;
  label:       string;
  unlockedAt:  number;  // beat
  centerX:     number;  // world grid center
  centerY:     number;
}

export class DomainUnlockEngine {
  private unlocked: Map<string, UnlockedDomain> = new Map();

  tick(macro: MacroState): UnlockedDomain[] {
    for (const rule of DOMAIN_UNLOCK_RULES) {
      if (!this.unlocked.has(rule.domainId)) {
        if (checkDomainUnlock(rule, macro.coherence, macro.stability, macro.lawDensity, macro.worldAge)) {
          this.unlocked.set(rule.domainId, {
            ruleId:     rule.domainId,
            label:      rule.label,
            unlockedAt: macro.beat,
            centerX:    GRID_W / 2 + (Math.random() - 0.5) * GRID_W * 0.6,
            centerY:    GRID_H / 2 + (Math.random() - 0.5) * GRID_H * 0.6,
          });
        }
      }
    }
    return [...this.unlocked.values()];
  }

  get domains(): UnlockedDomain[] {
    return [...this.unlocked.values()];
  }
}

// ── WorldGenerator ────────────────────────────────────────────────────────────
// Composites all engines into the full world-generation pipeline.
// Causal order: macro-state → gradients → morphogenesis → materialization → sediment → unlock

export interface WorldSnapshot {
  beat:      number;
  macro:     MacroState;
  objects:   WorldObject[];
  sediments: HistorySediment[];
  domains:   UnlockedDomain[];
}

export class WorldGenerator {
  private macroEngine:    MacroStateEngine;
  private gradientEngine: GradientFieldEngine;
  private morphEngine:    MorphogenesisEngine;
  private materialEngine: MaterializationEngine;
  private sedimentEngine: HistorySedimentEngine;
  private domainEngine:   DomainUnlockEngine;

  private objects: Map<string, WorldObject> = new Map();
  private nextObjId = 1;

  constructor() {
    this.macroEngine    = new MacroStateEngine();
    this.gradientEngine = new GradientFieldEngine();
    this.morphEngine    = new MorphogenesisEngine();
    this.materialEngine = new MaterializationEngine();
    this.sedimentEngine = new HistorySedimentEngine();
    this.domainEngine   = new DomainUnlockEngine();
  }

  /**
   * Full pipeline tick.
   * Called once per simulation beat with swarm aggregates.
   */
  tick(
    beat: number,
    swarmAggregates: {
      rSwarm:       number;
      jDrift:       number;
      meanEnergy:   number;
      meanCortisol: number;
      meanTrust:    number;
      meanAnomaly:  number;
      meanTraffic:  number;
    }
  ): WorldSnapshot {
    // 1. Macro-state update
    const macro = this.macroEngine.tick(
      swarmAggregates.rSwarm, swarmAggregates.jDrift,
      swarmAggregates.meanEnergy, swarmAggregates.meanCortisol,
      swarmAggregates.meanTrust, swarmAggregates.meanAnomaly,
      swarmAggregates.meanTraffic, beat
    );

    // 2. Gradient fields
    const fields = this.gradientEngine.tick(macro);

    // 3. Morphogenesis decisions
    const decisions = this.morphEngine.tick(fields);

    // 4. Generate/update world objects from decisions
    for (const dec of decisions) {
      if (dec.confidence < 0.15 || Math.random() > dec.confidence * 0.08) continue;

      const objKey = `${dec.structureClass}_${Math.round(dec.gridX / 4)}_${Math.round(dec.gridY / 4)}`;
      const existing = this.objects.get(objKey);

      const idx = dec.gridY * GRID_W + dec.gridX;
      const coherence  = fields.coherenceField[idx]  ?? 0.5;
      const damage     = fields.damageField[idx]      ?? 0.0;
      const lawDensity = fields.lawDensityField[idx]  ?? 0.3;

      if (existing) {
        // Age and re-materialize
        const age = beat - existing.age;
        const mat = this.materialEngine.determineMaterial({ coherence, damage, age, lawDensity });
        this.objects.set(objKey, {
          ...existing,
          coherence: clamp(existing.coherence * 0.95 + coherence * 0.05, 0, 1),
          damage:    clamp(existing.damage    * 0.97 + damage    * 0.03, 0, 1),
          material:  mat,
          pulse:     dec.magnitude,
        });
      } else {
        const mat = this.materialEngine.determineMaterial({ coherence, damage, age: 0, lawDensity });
        const wObj: WorldObject = {
          id:             `obj_${this.nextObjId++}`,
          structureClass: dec.structureClass,
          geometry: {
            type:   dec.structureClass === 'road' ? 'line' : dec.structureClass === 'territory' ? 'polygon' : 'point',
            coords: [[dec.gridX, dec.gridY]],
            radius: dec.structureClass === 'hub' ? 6 : dec.structureClass === 'territory' ? 15 : 3,
          },
          material:     mat,
          faction:      null,
          coherence,
          damage,
          age:          beat,
          pulse:        dec.magnitude,
          emission:     dec.magnitude * (mat === 'sacred' ? 1.0 : mat === 'crystallized' ? 0.7 : 0.4),
          unlocked:     true,
          domainId:     null,
          historyRefs:  [],
        };
        this.objects.set(objKey, wObj);

        // Deposit sediment for scars and ruins
        if (dec.structureClass === 'scar' || dec.structureClass === 'ruin') {
          this.sedimentEngine.deposit(
            dec.structureClass === 'scar' ? 'scar' : 'ruin',
            dec.gridX, dec.gridY, dec.magnitude, beat,
            dec.magnitude > 0.85  // very heavy damage = permanent scar
          );
        }
      }
    }

    // Age existing objects
    for (const [key, obj] of this.objects) {
      const age = beat - obj.age;
      if (age > 200 && obj.material === 'fluid') {
        this.objects.delete(key);  // fluid structures evaporate
      }
    }

    // 5. History sediment tick
    this.sedimentEngine.tick(0.001);

    // 6. Domain unlocks
    const domains = this.domainEngine.tick(macro);

    return {
      beat,
      macro,
      objects:   [...this.objects.values()],
      sediments: this.sedimentEngine.all,
      domains,
    };
  }

  get macroState(): MacroState { return this.macroEngine.state; }
}
