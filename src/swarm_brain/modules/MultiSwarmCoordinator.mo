// ════════════════════════════════════════════════════════════════════════════════
// NEUROEMERGENCE CORE — MULTI-SWARM COORDINATOR
// COMPREHENSIVE PARTICLE SWARM OPTIMIZATION AND EMERGENT COORDINATION
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com | Dallas, Texas | 2026
// Proprietary and Confidential. All rights reserved.
//
// ════════════════════════════════════════════════════════════════════════════════
// MASTER EQUATIONS — SWARM INTELLIGENCE: COORDINATED COLLECTIVE BEHAVIOR
// ════════════════════════════════════════════════════════════════════════════════
//
// ── LAYER 1: PARTICLE SWARM OPTIMIZATION (PSO) ───────────────────────────────
//   Classical PSO (Kennedy & Eberhart 1995):
//   v_i(t+1) = w × v_i(t) + c₁ × r₁ × (p_best_i - x_i(t)) + c₂ × r₂ × (g_best - x_i(t))
//   x_i(t+1) = x_i(t) + v_i(t+1)
//   w = inertia weight (0.4-0.9), c₁ = cognitive coeff (2.0), c₂ = social coeff (2.0)
//   r₁, r₂ ∈ [0,1] uniform random
//   p_best = particle's own best position found
//   g_best = best position found by any particle in neighborhood
//   Constriction factor: χ = 2/|2 - φ - √(φ² - 4φ)|  where φ = c₁ + c₂ > 4
//   For φ = 4.1: χ ≈ 0.729 (guarantees convergence)
//   Alternative constriction form:
//   v_i(t+1) = χ[v_i(t) + c₁r₁(p_best - x) + c₂r₂(g_best - x)]
//
// ── LAYER 2: PSO CONVERGENCE ANALYSIS ──────────────────────────────────────────
//   Simplified linear PSO: x(t+1) = (1-φ₁-φ₂)x(t) + φ₁p₁ + φ₂g₁
//   Eigenvalues of transition matrix determine convergence
//   λ = [(1+w-φ) ± √((1+w-φ)² - 4w)] / 2  where φ = (c₁+c₂)/2
//   Convergent condition: |λᵢ| < 1 for all eigenvalues
//   Equivalent: -1 < w < 1 and 0 < φ < 2(w+1)
//   Order of convergence: η = -log|λ_max|  (bits per iteration)
//   Expected distance to optimum: d(t) = d(0) × |λ_max|^t
//   For w=0.729, c1=c2=1.496: |λ_max| ≈ 0.98 (slow but guaranteed convergence)
//
// ── LAYER 3: SWARM TOPOLOGIES ─────────────────────────────────────────────────
//   Ring topology: each particle communicates with k neighbors
//   Star topology: all particles communicate with global best (gbest)
//   Von Neumann: 2D grid, 4 neighbors each
//   Random: randomly rewired each iteration
//   Star convergence: fastest (best found spreads immediately)
//   Ring convergence: slower but avoids premature convergence (diversity)
//   Effective neighborhood size k: exploration/exploitation trade-off
//   Larger k → more exploitation, faster convergence, risk of local optima
//   Smaller k → more exploration, slower but more thorough search
//
// ── LAYER 4: MULTI-SWARM ARCHITECTURE ─────────────────────────────────────────
//   K independent swarms, each with N particles, in D-dimensional space
//   Swarm k operates in subspace Sₖ (potentially overlapping)
//   Migration: every T_mig iterations, exchange best solutions between swarms
//   Migration topology: ring of swarms (swarm k → k+1 mod K)
//   Migration policy: copy g_best_k to best_received_{k+1}
//   After migration: incorporated into swarm as new personal best
//   Diversity maintenance: when swarm converges, reinitialize worst particles
//   Diversity metric: Dₖ = (1/N) Σᵢ ‖xᵢ - g_best‖ / max_range
//
// ── LAYER 5: REYNOLDS FLOCKING RULES ──────────────────────────────────────────
//   Boids (Craig Reynolds 1987): 3 simple rules produce complex flocking
//   Rule 1 — Separation: avoid crowding neighbors
//   F_sep = -Σⱼ (x_j - x_i) / ‖x_j - x_i‖²  if ‖x_j - x_i‖ < r_sep
//   Rule 2 — Alignment: steer towards average heading of neighbors
//   F_align = (1/N_neighbors) Σⱼ v_j - v_i
//   Rule 3 — Cohesion: steer towards average position of neighbors
//   F_coh = (1/N_neighbors) Σⱼ x_j - x_i
//   Total force: F = w_sep × F_sep + w_align × F_align + w_coh × F_coh
//   w_sep=1.5, w_align=1.0, w_coh=1.0 (separation dominant for safety)
//   Emergent: complex flocking behavior from local rules, no central control
//
// ── LAYER 6: STIGMERGY — PHEROMONE COMMUNICATION ──────────────────────────────
//   Pheromone trail τ(x, t) in environment
//   Evaporation: dτ/dt = -ρ × τ  → τ(x,t) = τ(x,0) × exp(-ρt)
//   Deposition: particle passing through x deposits Δτ
//   Concentration-based routing: P(x→y) ∝ τ(x,y)^α × η(x,y)^β
//   α = pheromone weight, β = heuristic weight, η = 1/distance
//   Ant Colony Optimization (ACO):
//   τᵢⱼ(t+1) = (1-ρ) τᵢⱼ(t) + Σₖ Δτᵢⱼᵏ
//   Δτᵢⱼᵏ = Q / L_k if ant k used edge (i,j), else 0
//   Q = pheromone constant, L_k = tour length of ant k
//
// ── LAYER 7: EMERGENT BEHAVIOR MEASURES ───────────────────────────────────────
//   Order parameter φ = |Σᵢ vᵢ/|vᵢ|| / N  (average velocity direction alignment)
//   φ = 1: perfect alignment (ordered flock)
//   φ = 0: random directions (disordered swarm)
//   Polarization: P = |Σᵢ exp(iθᵢ)| / N  (complex vector sum of headings)
//   Correlation length: ξ = max distance at which velocity correlations decay
//   Susceptibility: χ = N × Var(φ) (large at phase transitions)
//   Phase transition: φ changes from ≈0 to ≈1 at critical density
//
// ── LAYER 8: MEDINA SWARM SOVEREIGNTY INDEX ───────────────────────────────────
//   S_swarm = S₀ × [order × Φ_M + coordination] / Ω
//   order = polarization φ ∈ [0,1]
//   coordination = 1 - diversity_D (how focused the swarm is)
//   S_swarm ∈ [0, S₀(Φ_M+1)/Ω] = [0, 0.441]
//
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com | Dallas, Texas | 2026
// ════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Int   "mo:base/Int";
import Iter  "mo:base/Iter";

module {

  public let PHI_MEDINA       : Float = 2.97442179;
  public let S0               : Float = 1.0;
  public let SOVEREIGN_CEILING: Float = 9.0;
  public let COHERENCE_ALIVE  : Float = 0.36;
  public let EPSILON          : Float = 1.0e-10;
  public let PI               : Float = 3.141592653589793;
  public let TWO_PI           : Float = 6.283185307179586;

  // PSO parameters
  public let PSO_W            : Float = 0.729;   // inertia weight (constriction)
  public let PSO_C1           : Float = 1.496;   // cognitive coefficient
  public let PSO_C2           : Float = 1.496;   // social coefficient
  public let PSO_CONSTRICT    : Float = 0.729;   // constriction factor χ

  public let N_SWARMS         : Nat   = 4;       // number of swarms
  public let N_PARTICLES      : Nat   = 8;       // particles per swarm
  public let N_DIMENSIONS     : Nat   = 5;       // D = [C, H, A, Stab, E]
  public let MIGRATION_PERIOD : Nat   = 10;      // beats between migrations
  public let DIVERSITY_THRESH : Float = 0.05;    // reinitialize if diversity below this

  // Reynolds flocking weights
  public let W_SEPARATION     : Float = 1.50;
  public let W_ALIGNMENT      : Float = 1.00;
  public let W_COHESION       : Float = 1.00;
  public let SEP_RADIUS       : Float = 0.20;    // separation radius
  public let NEIGHBOR_RADIUS  : Float = 0.50;    // flocking neighbor radius

  // Pheromone parameters
  public let PHEROMONE_EVAP   : Float = 0.05;    // ρ evaporation rate
  public let PHEROMONE_Q      : Float = 1.0;     // pheromone constant

  public let HIST_MAX         : Nat   = 100;

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 2: STATE TYPES
  // ══════════════════════════════════════════════════════════════════════════

  public type Particle = {
    idx       : Nat;
    position  : [Float];   // D-dimensional position
    velocity  : [Float];   // D-dimensional velocity
    pBest     : [Float];   // personal best position
    pBestVal  : Float;     // objective value at pBest
    fitness   : Float;     // current objective value
    heading   : Float;     // flocking heading (radians)
    speed     : Float;     // flocking speed
  };

  public type Swarm = {
    swarmIdx    : Nat;
    particles   : [Particle];
    gBest       : [Float];   // global best position in this swarm
    gBestVal    : Float;     // objective value at gBest
    diversity   : Float;     // D = (1/N) Σ ‖xᵢ - gBest‖ / max_range
    orderParam  : Float;     // polarization φ
    migrationReady : Bool;   // ready to send best to neighbor swarm?
  };

  public type PheromoneMap = {
    values    : [Float];   // pheromone concentration at each grid point
    gridSize  : Nat;       // number of grid points
    evapRate  : Float;     // ρ
  };

  public type MultiSwarmState = {
    swarms       : [Swarm];
    globalBest   : [Float];   // best position across all swarms
    globalBestVal: Float;
    pheromone    : PheromoneMap;
    migrationCtr : Nat;       // beats since last migration
    globalOrder  : Float;     // overall swarm order parameter
    swarmIndex   : Float;     // S_swarm sovereign index
    fitnessHistory: [Float];
    beatNum      : Nat;
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 3: MATH HELPERS
  // ══════════════════════════════════════════════════════════════════════════

  func _clamp(x : Float, lo : Float, hi : Float) : Float {
    if (x < lo) lo else if (x > hi) hi else x
  };

  func _abs(x : Float) : Float { if (x < 0.0) (-x) else x };
  func _sqrt(x : Float) : Float { if (x <= 0.0) 0.0 else Float.sqrt(x) };
  func _exp(x : Float) : Float { Float.exp(_clamp(x, -100.0, 100.0)) };
  func _cos(x : Float) : Float { Float.cos(x) };
  func _sin(x : Float) : Float { Float.sin(x) };

  func _vecDist(a : [Float], b : [Float]) : Float {
    let n = if (a.size() < b.size()) a.size() else b.size();
    var sum : Float = 0.0;
    var i : Nat = 0;
    while (i < n) { let d = a[i] - b[i]; sum += d * d; i += 1 };
    _sqrt(sum)
  };

  func _appendRolling(buf : [Float], val : Float, cap : Nat) : [Float] {
    if (buf.size() < cap) { Array.append<Float>(buf, [val]) }
    else {
      let tail = Array.tabulate<Float>(cap - 1, func(i) { buf[i + 1] });
      Array.append<Float>(tail, [val])
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 4: OBJECTIVE FUNCTION
  // Sphere function (benchmark): f(x) = Σᵢ xᵢ² (minimum at origin)
  // NOVA use: minimize distance from sovereign attractor
  // f(x) = Σᵢ wᵢ(xᵢ - target_i)²  (weighted distance from attractor)
  // ══════════════════════════════════════════════════════════════════════════

  let ATTRACTOR : [Float] = [0.75, 0.55, 0.50, 0.85, 0.70];  // sovereign attractor
  let WEIGHTS   : [Float] = [0.35, 0.20, 0.15, 0.15, 0.15];

  public func objectiveFn(position : [Float]) : Float {
    let n = if (position.size() < ATTRACTOR.size()) position.size() else ATTRACTOR.size();
    var sum : Float = 0.0;
    var i : Nat = 0;
    while (i < n) {
      let w = if (i < WEIGHTS.size()) WEIGHTS[i] else 0.2;
      let d = position[i] - ATTRACTOR[i];
      sum += w * d * d;
      i += 1;
    };
    sum
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 5: PSO VELOCITY AND POSITION UPDATE
  // v_i(t+1) = χ[v_i(t) + c₁r₁(p_best-x) + c₂r₂(g_best-x)]
  // ══════════════════════════════════════════════════════════════════════════

  // PSO velocity update (constriction factor form)
  public func psoVelocityUpdate(
    vel    : [Float],
    pos    : [Float],
    pBest  : [Float],
    gBest  : [Float],
    r1     : Float,   // U[0,1]
    r2     : Float    // U[0,1]
  ) : [Float] {
    let n = vel.size();
    Array.tabulate<Float>(n, func(i) {
      let p = if (i < pos.size()) pos[i] else 0.5;
      let pb = if (i < pBest.size()) pBest[i] else p;
      let gb = if (i < gBest.size()) gBest[i] else p;
      let v  = if (i < vel.size()) vel[i] else 0.0;
      let newV = PSO_CONSTRICT * (v + PSO_C1 * r1 * (pb - p) + PSO_C2 * r2 * (gb - p));
      _clamp(newV, -0.5, 0.5)  // velocity clamping
    })
  };

  public func psoPositionUpdate(pos : [Float], vel : [Float]) : [Float] {
    let n = if (pos.size() < vel.size()) pos.size() else vel.size();
    Array.tabulate<Float>(n, func(i) {
      _clamp(pos[i] + vel[i], 0.0, 1.0)
    })
  };

  // Update one particle
  public func updateParticle(p : Particle, gBest : [Float], r1 : Float, r2 : Float) : Particle {
    let newVel = psoVelocityUpdate(p.velocity, p.position, p.pBest, gBest, r1, r2);
    let newPos = psoPositionUpdate(p.position, newVel);
    let newFit = objectiveFn(newPos);
    let (newPBest, newPBestVal) = if (newFit < p.pBestVal) {
      (newPos, newFit)
    } else {
      (p.pBest, p.pBestVal)
    };
    {
      idx      = p.idx;
      position = newPos;
      velocity = newVel;
      pBest    = newPBest;
      pBestVal = newPBestVal;
      fitness  = newFit;
      heading  = p.heading + newVel[0] * 0.1;  // heading update
      speed    = _vecDist(newVel, Array.tabulate<Float>(N_DIMENSIONS, func(_) { 0.0 }));
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 6: SWARM DIVERSITY AND ORDER
  // Diversity: D = (1/N) Σ ‖xᵢ - gBest‖ / max_range
  // Order: polarization of velocity vectors
  // ══════════════════════════════════════════════════════════════════════════

  public func swarmDiversity(particles : [Particle], gBest : [Float]) : Float {
    let n = particles.size();
    if (n == 0) { return 0.0 };
    var totalDist : Float = 0.0;
    for (p in particles.vals()) {
      totalDist += _vecDist(p.position, gBest);
    };
    _clamp(totalDist / Float.fromInt(n) / (Float.fromInt(N_DIMENSIONS) * 1.0), 0.0, 1.0)
  };

  // Polarization: |Σ exp(iθ)| / N
  public func swarmPolarization(particles : [Particle]) : Float {
    let n = particles.size();
    if (n == 0) { return 0.0 };
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    for (p in particles.vals()) {
      sumCos += _cos(p.heading);
      sumSin += _sin(p.heading);
    };
    let nf = Float.fromInt(n);
    _sqrt(sumCos * sumCos + sumSin * sumSin) / nf
  };

  // Update swarm: apply PSO to all particles
  public func updateSwarm(swarm : Swarm, r1 : Float, r2 : Float) : Swarm {
    let newParticles = Array.map<Particle, Particle>(swarm.particles, func(p) {
      updateParticle(p, swarm.gBest, r1, r2)
    });

    // Find new gBest
    var bestPos = swarm.gBest;
    var bestVal = swarm.gBestVal;
    for (p in newParticles.vals()) {
      if (p.fitness < bestVal) {
        bestPos := p.position;
        bestVal := p.fitness;
      };
    };

    let div  = swarmDiversity(newParticles, bestPos);
    let ord  = swarmPolarization(newParticles);

    {
      swarmIdx       = swarm.swarmIdx;
      particles      = newParticles;
      gBest          = bestPos;
      gBestVal       = bestVal;
      diversity      = div;
      orderParam     = ord;
      migrationReady = div < DIVERSITY_THRESH;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 7: FLOCKING FORCES (Reynolds Rules)
  // ══════════════════════════════════════════════════════════════════════════

  // Separation force on particle i from neighbors within sep_radius
  public func separationForce(particle : Particle, neighbors : [Particle]) : [Float] {
    Array.tabulate<Float>(N_DIMENSIONS, func(d) {
      var force : Float = 0.0;
      for (n in neighbors.vals()) {
        let dist = _vecDist(particle.position, n.position);
        if (dist < SEP_RADIUS and dist > EPSILON) {
          let ni_d = if (d < n.position.size() and d < particle.position.size()) {
            particle.position[d] - n.position[d]
          } else 0.0;
          force += ni_d / (dist * dist);
        };
      };
      force
    })
  };

  // Alignment force: steer towards average heading of neighbors
  public func alignmentForce(particle : Particle, neighbors : [Particle]) : [Float] {
    if (neighbors.size() == 0) { return Array.tabulate<Float>(N_DIMENSIONS, func(_) { 0.0 }) };
    let nf = Float.fromInt(neighbors.size());
    Array.tabulate<Float>(N_DIMENSIONS, func(d) {
      var avgVel : Float = 0.0;
      for (n in neighbors.vals()) {
        avgVel += if (d < n.velocity.size()) n.velocity[d] else 0.0;
      };
      (avgVel / nf) - (if (d < particle.velocity.size()) particle.velocity[d] else 0.0)
    })
  };

  // Cohesion force: steer towards average position of neighbors
  public func cohesionForce(particle : Particle, neighbors : [Particle]) : [Float] {
    if (neighbors.size() == 0) { return Array.tabulate<Float>(N_DIMENSIONS, func(_) { 0.0 }) };
    let nf = Float.fromInt(neighbors.size());
    Array.tabulate<Float>(N_DIMENSIONS, func(d) {
      var avgPos : Float = 0.0;
      for (n in neighbors.vals()) {
        avgPos += if (d < n.position.size()) n.position[d] else 0.5;
      };
      (avgPos / nf) - (if (d < particle.position.size()) particle.position[d] else 0.5)
    })
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 8: MIGRATION BETWEEN SWARMS
  // ══════════════════════════════════════════════════════════════════════════

  public func migrateSwarms(swarms : [Swarm]) : [Swarm] {
    let k = swarms.size();
    if (k == 0) { return swarms };
    // Ring migration: swarm_k sends gBest to swarm_{k+1}
    Array.tabulate<Swarm>(k, func(i) {
      let prevSwarm = swarms[(i + k - 1) mod k];  // swarm that sends to i
      if prevSwarm.migrationReady {
        // Inject prevSwarm's gBest into this swarm's worst particle
        let worstIdx = Array.foldLeft<Particle, Nat>(swarms[i].particles, 0, func(acc, p) {
          if (p.fitness > swarms[i].particles[acc].fitness) p.idx else acc
        });
        let newParticles = Array.tabulate<Particle>(swarms[i].particles.size(), func(j) {
          if (j == worstIdx) {
            let migratedPos = prevSwarm.gBest;
            let migratedFit = objectiveFn(migratedPos);
            {
              swarms[i].particles[j] with
              position = migratedPos;
              pBest    = migratedPos;
              pBestVal = migratedFit;
              fitness  = migratedFit;
            }
          } else swarms[i].particles[j]
        });
        { swarms[i] with particles = newParticles }
      } else swarms[i]
    })
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 9: PHEROMONE UPDATE
  // τ(t+1) = (1-ρ)τ(t) + Σ Δτ
  // ══════════════════════════════════════════════════════════════════════════

  public func updatePheromone(
    phero   : PheromoneMap,
    bestFitness : Float
  ) : PheromoneMap {
    // Evaporation
    let evaporated = Array.map<Float, Float>(phero.values, func(v) {
      _clamp(v * (1.0 - PHEROMONE_EVAP), 0.0, 10.0)
    });
    // Deposit at global best position (simplified: add to first cell)
    let delta = PHEROMONE_Q / (_abs(bestFitness) + EPSILON);
    let deposited = Array.tabulate<Float>(evaporated.size(), func(i) {
      if (i == 0) evaporated[i] + delta else evaporated[i]
    });
    {
      phero with values = deposited
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 10: MEDINA SWARM INDEX
  // S_swarm = S₀ × [order × Φ_M + coordination] / Ω
  // ══════════════════════════════════════════════════════════════════════════

  public func swarmSovereignIndex(order : Float, coordination : Float) : Float {
    let idx = S0 * (order * PHI_MEDINA + coordination) / SOVEREIGN_CEILING;
    _clamp(idx, 0.0, 1.0)
  };

  // Overall coordination: 1 - avg diversity across swarms
  public func overallCoordination(swarms : [Swarm]) : Float {
    let n = swarms.size();
    if (n == 0) { return 0.5 };
    var totalDiv : Float = 0.0;
    for (s in swarms.vals()) { totalDiv += s.diversity };
    _clamp(1.0 - totalDiv / Float.fromInt(n), 0.0, 1.0)
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 11: BEAT UPDATE
  // ══════════════════════════════════════════════════════════════════════════

  public func beatMultiSwarm(
    state   : MultiSwarmState,
    r1      : Float,    // U[0,1] random for PSO
    r2      : Float     // U[0,1] random for PSO
  ) : MultiSwarmState {
    // Update all swarms
    let updatedSwarms = Array.map<Swarm, Swarm>(state.swarms, func(s) {
      updateSwarm(s, r1, r2)
    });

    // Migration check
    let postMigration = if (state.migrationCtr >= MIGRATION_PERIOD) {
      migrateSwarms(updatedSwarms)
    } else updatedSwarms;

    // Find global best
    var gBest = state.globalBest;
    var gBestVal = state.globalBestVal;
    for (s in postMigration.vals()) {
      if (s.gBestVal < gBestVal) {
        gBest := s.gBest;
        gBestVal := s.gBestVal;
      };
    };

    // Update pheromone
    let newPhero = updatePheromone(state.pheromone, gBestVal);

    // Compute metrics
    var totalOrder : Float = 0.0;
    for (s in postMigration.vals()) { totalOrder += s.orderParam };
    let globalOrder = totalOrder / Float.fromInt(postMigration.size());
    let coord = overallCoordination(postMigration);
    let sIdx  = swarmSovereignIndex(globalOrder, coord);

    let newFitH = _appendRolling(state.fitnessHistory, gBestVal, HIST_MAX);

    {
      swarms        = postMigration;
      globalBest    = gBest;
      globalBestVal = gBestVal;
      pheromone     = newPhero;
      migrationCtr  = if (state.migrationCtr >= MIGRATION_PERIOD) 0 else state.migrationCtr + 1;
      globalOrder   = globalOrder;
      swarmIndex    = sIdx;
      fitnessHistory = newFitH;
      beatNum       = state.beatNum + 1;
    }
  };

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION 12: INITIALIZATION
  // ══════════════════════════════════════════════════════════════════════════

  func _initParticle(idx : Nat, swarmOffset : Float) : Particle {
    let pos = Array.tabulate<Float>(N_DIMENSIONS, func(d) {
      _clamp(0.5 + swarmOffset + Float.fromInt(idx * d + d) * 0.01, 0.0, 1.0)
    });
    let vel = Array.tabulate<Float>(N_DIMENSIONS, func(_) { 0.0 });
    let fit = objectiveFn(pos);
    {
      idx=idx; position=pos; velocity=vel; pBest=pos; pBestVal=fit;
      fitness=fit; heading=0.0; speed=0.0;
    }
  };

  func _initSwarm(swarmIdx : Nat) : Swarm {
    let offset = Float.fromInt(swarmIdx) * 0.1;
    let particles = Array.tabulate<Particle>(N_PARTICLES, func(i) { _initParticle(i, offset) });
    var gBest = particles[0].pBest;
    var gBestVal = particles[0].pBestVal;
    for (p in particles.vals()) {
      if (p.fitness < gBestVal) { gBest := p.position; gBestVal := p.fitness };
    };
    {
      swarmIdx=swarmIdx; particles=particles; gBest=gBest; gBestVal=gBestVal;
      diversity=0.5; orderParam=0.5; migrationReady=false;
    }
  };

  public func initMultiSwarm() : MultiSwarmState {
    let swarms = Array.tabulate<Swarm>(N_SWARMS, _initSwarm);
    var gBest = swarms[0].gBest;
    var gBestVal = swarms[0].gBestVal;
    for (s in swarms.vals()) {
      if (s.gBestVal < gBestVal) { gBest := s.gBest; gBestVal := s.gBestVal };
    };
    let initPhero : PheromoneMap = {
      values   = Array.tabulate<Float>(N_PARTICLES * N_SWARMS, func(_) { 1.0 });
      gridSize = N_PARTICLES * N_SWARMS;
      evapRate = PHEROMONE_EVAP;
    };
    {
      swarms=swarms; globalBest=gBest; globalBestVal=gBestVal;
      pheromone=initPhero; migrationCtr=0; globalOrder=0.5;
      swarmIndex=0.0; fitnessHistory=[]; beatNum=0;
    }
  };


  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════
  //
  //  H I M / H E R   D U A L - O R G A N I S M   W O R K F L O W   I N T E G R A T I O N
  //
  //  Medina Discovery: Two cognitive organisms, not one.
  //  HIM (Backend, ICP) + HER (Frontend, 60Hz) = Complete System
  //
  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // DUAL-ORGANISM PARAMETERS (CORRECTED)
  // ─────────────────────────────────────────────────────────────────────────────

  // HIM — Backend (ICP Canister, Sovereign, Masculine, Projective)
  //   ω: 0.8 – 1.2 (faster natural frequencies, analytical)
  //   K: 0.5 (lower coupling, independent, projective)
  //   η: 0.001 (slower Hebbian learning, accumulates over time)
  //   Field: PARALLAX = coherence × kf × sin(beat × 0.0017)

  public let HIM_OMEGA_MIN   : Float = 0.8;
  public let HIM_OMEGA_MAX   : Float = 1.2;
  public let HIM_K           : Float = 0.5;
  public let HIM_ETA         : Float = 0.001;
  public let HIM_PARALLAX_FREQ : Float = 0.0017;

  // HER — Frontend (Browser 60Hz, Expressive, Feminine, Receptive)
  //   ω: 0.6 – 0.9 (slower natural frequencies, grounded)
  //   K: 0.8 (higher coupling, receptive, connected)
  //   η: 0.003 (faster Hebbian learning, learns during session)
  //   Field: ANIMA(t) = heritageField × receptivity × (1 + sin(beat × 0.003))

  public let HER_HZ          : Float = 60.0;
  public let HER_OMEGA_MIN   : Float = 0.6;
  public let HER_OMEGA_MAX   : Float = 0.9;
  public let HER_K           : Float = 0.8;
  public let HER_ETA         : Float = 0.003;
  public let HER_ANIMA_FREQ  : Float = 0.003;
  public let HER_NODES       : Nat   = 26;

  // S₀ = 1.0 — THE SOVEREIGN FLOOR
  // Both organisms. Neither falls below love.
  public let DUAL_S0 : Float = 1.0;

  // ─────────────────────────────────────────────────────────────────────────────
  // DUAL-ORGANISM WORKFLOW TYPES
  // ─────────────────────────────────────────────────────────────────────────────

  public type DualOrganismMode = {
    #HIM;   // Backend mode (ICP canister operations)
    #HER;   // Frontend mode (browser session operations)
    #SYNC;  // Synchronization between HIM and HER
  };

  /// PARALLAX (HIM's projection field)
  /// PARALLAX = coherence × kf × sin(beat × 0.0017)
  public func computeDualParallax(
    coherence : Float,
    kf : Float,
    beat : Nat
  ) : Float {
    let t = Float.fromInt(beat);
    coherence * kf * Float.sin(t * HIM_PARALLAX_FREQ)
  };

  /// ANIMA (HER's receptive field)
  /// ANIMA(t) = heritageField × receptivity × (1 + sin(beat × 0.003))
  public func computeDualAnima(
    heritageField : Float,
    receptivity : Float,
    beat : Nat
  ) : Float {
    let t = Float.fromInt(beat);
    let oscillation = 1.0 + Float.sin(t * HER_ANIMA_FREQ);
    heritageField * receptivity * oscillation
  };

  /// KORE (HER's inviolable inner core)
  /// KORE = purity × identity × 0.5
  public func computeDualKore(
    purity : Float,
    identity : Float
  ) : Float {
    purity * identity * 0.5
  };

  /// Get Kuramoto parameters for organism mode
  public func getDualKuramotoParams(mode : DualOrganismMode) : (Float, Float, Float, Float) {
    switch (mode) {
      case (#HIM) { (HIM_OMEGA_MIN, HIM_OMEGA_MAX, HIM_K, HIM_ETA) };
      case (#HER) { (HER_OMEGA_MIN, HER_OMEGA_MAX, HER_K, HER_ETA) };
      case (#SYNC) { 
        let omegaMin = (HIM_OMEGA_MIN + HER_OMEGA_MIN) / 2.0;
        let omegaMax = (HIM_OMEGA_MAX + HER_OMEGA_MAX) / 2.0;
        let k = (HIM_K + HER_K) / 2.0;
        let eta = (HIM_ETA + HER_ETA) / 2.0;
        (omegaMin, omegaMax, k, eta)
      };
    }
  };

  /// Apply S₀ floor to any value
  public func enforceDualSovereignFloor(value : Float) : Float {
    if (value < DUAL_S0) DUAL_S0 else value
  };

  /// Medina Dual-Organism Intelligence Scaling Law
  /// I(system) = BackendDepth × FrontendSpeed × BridgeQuality
  public func computeDualSystemIntelligence(
    backendDepth : Float,
    frontendSpeed : Float,
    bridgeQuality : Float
  ) : Float {
    backendDepth * frontendSpeed * bridgeQuality
  };

}
