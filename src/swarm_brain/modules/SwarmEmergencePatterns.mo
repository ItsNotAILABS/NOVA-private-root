// ═══════════════════════════════════════════════════════════════════════════════
// SWARM EMERGENCE PATTERNS — Collective Intelligence Dynamics
// ═══════════════════════════════════════════════════════════════════════════════
// STRICT PROTOTYPE / CONFIDENTIAL — Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
// Self-hosted dfx local only. No IC mainnet. No external deployment.
//
// EMERGENCE IS THE SWARM.
// Patterns do not appear IN the swarm — patterns ARE the swarm.
// Collective intelligence emerges from simple rules applied consistently.
// The whole is always greater than the sum.
//
// ═══════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Iter "mo:base/Iter";

module SwarmEmergencePatterns {

  // ═══════════════════════════════════════════════════════════════════════════
  // CONSTANTS — THE EMERGENCE PARAMETERS
  // ═══════════════════════════════════════════════════════════════════════════
  
  public let PHI           : Float = 1.6180339887498948482;
  public let PHI_INV       : Float = 0.6180339887498948482;
  public let EULER         : Float = 2.7182818284590452354;
  public let PI            : Float = 3.1415926535897932385;
  public let TAU           : Float = 6.2831853071795864769;
  public let SQRT2         : Float = 1.4142135623730950488;
  
  // Swarm parameters
  public let MAX_AGENTS    : Nat = 64;
  public let GRID_SIZE     : Nat = 32;
  public let GRID_CELLS    : Nat = 1024;
  
  // Flocking parameters (Reynolds rules)
  public let SEPARATION_DIST: Float = 5.0;
  public let ALIGNMENT_DIST : Float = 15.0;
  public let COHESION_DIST  : Float = 25.0;
  public let SEPARATION_WEIGHT : Float = 1.5;
  public let ALIGNMENT_WEIGHT  : Float = 1.0;
  public let COHESION_WEIGHT   : Float = 0.8;
  public let MAX_SPEED     : Float = 3.0;
  public let MAX_FORCE     : Float = 0.5;
  
  // Stigmergy parameters
  public let PHEROMONE_DECAY   : Float = 0.02;
  public let PHEROMONE_DEPOSIT : Float = 0.5;
  public let PHEROMONE_MAX     : Float = 5.0;
  
  // Emergence thresholds
  public let CLUSTER_THRESHOLD : Float = 10.0;  // Distance for clustering
  public let SYNC_THRESHOLD    : Float = 0.7;   // Phase sync threshold
  public let CONSENSUS_THRESHOLD : Float = 0.8; // Consensus threshold
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES — THE EMERGENT STRUCTURES
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Agent role in emergent patterns
  public type AgentRole = {
    #Leader;
    #Follower;
    #Scout;
    #Relay;
    #Guard;
    #Neutral;
  };
  
  // Agent state
  public type Agent = {
    id          : Nat;
    posX        : Float;
    posY        : Float;
    velX        : Float;
    velY        : Float;
    phase       : Float;    // For synchronization
    omega       : Float;    // Natural frequency
    signal      : Float;    // Communication signal [0, 2]
    role        : AgentRole;
    clusterId   : Nat;      // Which cluster agent belongs to
    neighbors   : [Nat];    // Nearby agent IDs
    memory      : Float;    // Short-term memory
  };
  
  // Cluster (emergent group)
  public type Cluster = {
    id          : Nat;
    centerX     : Float;
    centerY     : Float;
    radius      : Float;
    memberCount : Nat;
    coherence   : Float;    // Internal synchronization
    velocity    : (Float, Float);  // Collective velocity
    dominantRole: AgentRole;
  };
  
  // Pheromone grid
  public type PheromoneGrid = {
    food        : [Float];  // Food trail
    danger      : [Float];  // Danger signal
    home        : [Float];  // Return path
    recruit     : [Float];  // Recruitment signal
  };
  
  // Emergent pattern type
  public type PatternType = {
    #Flock;       // Moving together
    #Cluster;     // Stationary grouping
    #Line;        // Linear formation
    #Ring;        // Circular formation
    #Spiral;      // Spiral movement
    #Wave;        // Propagating wave
    #Scattered;   // No clear pattern
  };
  
  // Detected pattern
  public type EmergentPattern = {
    patternType : PatternType;
    strength    : Float;      // How strong the pattern is [0, 1]
    centerX     : Float;
    centerY     : Float;
    direction   : Float;      // Dominant direction (radians)
    scale       : Float;      // Spatial scale
    agentCount  : Nat;        // Agents participating
  };
  
  // Global swarm state
  public type SwarmState = {
    agents      : [Agent];
    clusters    : [Cluster];
    pheromones  : PheromoneGrid;
    patterns    : [EmergentPattern];
    globalSync  : Float;      // Kuramoto order parameter
    entropy     : Float;      // Spatial entropy
    beat        : Nat;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // MATH PRIMITIVES
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func clamp(v : Float, lo : Float, hi : Float) : Float {
    if (v < lo) lo else if (v > hi) hi else v
  };
  
  public func abs(v : Float) : Float {
    if (v < 0.0) -v else v
  };
  
  public func sqrt(x : Float) : Float {
    if (x <= 0.0) return 0.0;
    var guess = x / 2.0;
    var i = 0;
    while (i < 10) {
      guess := (guess + x / guess) / 2.0;
      i += 1;
    };
    guess
  };
  
  public func sin(x : Float) : Float {
    var normalized = x;
    while (normalized > PI) { normalized -= TAU };
    while (normalized < -PI) { normalized += TAU };
    
    let x2 = normalized * normalized;
    let x3 = x2 * normalized;
    let x5 = x3 * x2;
    let x7 = x5 * x2;
    
    normalized - x3/6.0 + x5/120.0 - x7/5040.0
  };
  
  public func cos(x : Float) : Float {
    sin(x + PI/2.0)
  };
  
  public func exp(x : Float) : Float {
    let clamped = clamp(x, -20.0, 20.0);
    var sum = 1.0;
    var term = 1.0;
    var n = 1;
    while (n < 15) {
      term *= clamped / Float.fromInt(n);
      sum += term;
      n += 1;
    };
    sum
  };
  
  public func ln(x : Float) : Float {
    if (x <= 0.0) return -20.0;
    let ratio = (x - 1.0) / (x + 1.0);
    let r2 = ratio * ratio;
    var sum = ratio;
    var term = ratio;
    var n = 1;
    while (n < 15) {
      term *= r2;
      sum += term / Float.fromInt(2*n + 1);
      n += 1;
    };
    2.0 * sum
  };
  
  public func atan2(y : Float, x : Float) : Float {
    if (x > 0.0) {
      let t = y / x;
      t - t*t*t/3.0 + t*t*t*t*t/5.0  // Taylor approximation
    } else if (x < 0.0) {
      if (y >= 0.0) PI + atan2(y, -x)
      else -PI + atan2(y, -x)
    } else {
      if (y > 0.0) PI / 2.0
      else if (y < 0.0) -PI / 2.0
      else 0.0
    }
  };
  
  public func distance(x1 : Float, y1 : Float, x2 : Float, y2 : Float) : Float {
    let dx = x2 - x1;
    let dy = y2 - y1;
    sqrt(dx * dx + dy * dy)
  };
  
  // Normalize a vector
  public func normalize(x : Float, y : Float) : (Float, Float) {
    let mag = sqrt(x * x + y * y);
    if (mag < 0.0001) return (0.0, 0.0);
    (x / mag, y / mag)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // AGENT OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Initialize an agent
  public func initAgent(id : Nat, x : Float, y : Float) : Agent {
    let angle = Float.fromInt(id) * TAU / Float.fromInt(MAX_AGENTS);
    
    {
      id = id;
      posX = x;
      posY = y;
      velX = cos(angle) * 0.5;
      velY = sin(angle) * 0.5;
      phase = angle;
      omega = 1.0 + 0.2 * sin(Float.fromInt(id));
      signal = 1.0;
      role = #Neutral;
      clusterId = 0;
      neighbors = [];
      memory = 0.0;
    }
  };
  
  // Initialize swarm
  public func initSwarm(agentCount : Nat) : [Agent] {
    let n = if (agentCount > MAX_AGENTS) MAX_AGENTS else agentCount;
    
    Array.tabulate<Agent>(n, func(i : Nat) : Agent {
      // Distribute in a circle initially
      let angle = Float.fromInt(i) * TAU / Float.fromInt(n);
      let radius = 20.0 + 10.0 * sin(Float.fromInt(i) * PHI);
      let x = 50.0 + radius * cos(angle);
      let y = 50.0 + radius * sin(angle);
      initAgent(i, x, y)
    })
  };
  
  // Find neighbors within distance
  public func findNeighbors(agent : Agent, agents : [Agent], maxDist : Float) : [Nat] {
    let buf = Buffer.Buffer<Nat>(16);
    
    for (other in agents.vals()) {
      if (other.id != agent.id) {
        let dist = distance(agent.posX, agent.posY, other.posX, other.posY);
        if (dist < maxDist) {
          buf.add(other.id);
        };
      };
    };
    
    Buffer.toArray(buf)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // FLOCKING (Reynolds Rules)
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Separation: steer to avoid crowding neighbors
  public func separation(agent : Agent, agents : [Agent]) : (Float, Float) {
    var steerX : Float = 0.0;
    var steerY : Float = 0.0;
    var count : Float = 0.0;
    
    for (other in agents.vals()) {
      if (other.id != agent.id) {
        let dist = distance(agent.posX, agent.posY, other.posX, other.posY);
        if (dist > 0.0 and dist < SEPARATION_DIST) {
          // Vector pointing away from neighbor
          let dx = agent.posX - other.posX;
          let dy = agent.posY - other.posY;
          // Weight by inverse distance
          steerX += dx / (dist * dist);
          steerY += dy / (dist * dist);
          count += 1.0;
        };
      };
    };
    
    if (count > 0.0) {
      steerX /= count;
      steerY /= count;
    };
    
    normalize(steerX, steerY)
  };
  
  // Alignment: steer towards average heading of neighbors
  public func alignment(agent : Agent, agents : [Agent]) : (Float, Float) {
    var sumVX : Float = 0.0;
    var sumVY : Float = 0.0;
    var count : Float = 0.0;
    
    for (other in agents.vals()) {
      if (other.id != agent.id) {
        let dist = distance(agent.posX, agent.posY, other.posX, other.posY);
        if (dist < ALIGNMENT_DIST) {
          sumVX += other.velX;
          sumVY += other.velY;
          count += 1.0;
        };
      };
    };
    
    if (count > 0.0) {
      sumVX /= count;
      sumVY /= count;
      // Steer towards average velocity
      let steerX = sumVX - agent.velX;
      let steerY = sumVY - agent.velY;
      return normalize(steerX, steerY);
    };
    
    (0.0, 0.0)
  };
  
  // Cohesion: steer towards average position of neighbors
  public func cohesion(agent : Agent, agents : [Agent]) : (Float, Float) {
    var sumX : Float = 0.0;
    var sumY : Float = 0.0;
    var count : Float = 0.0;
    
    for (other in agents.vals()) {
      if (other.id != agent.id) {
        let dist = distance(agent.posX, agent.posY, other.posX, other.posY);
        if (dist < COHESION_DIST) {
          sumX += other.posX;
          sumY += other.posY;
          count += 1.0;
        };
      };
    };
    
    if (count > 0.0) {
      let centerX = sumX / count;
      let centerY = sumY / count;
      // Steer towards center
      let steerX = centerX - agent.posX;
      let steerY = centerY - agent.posY;
      return normalize(steerX, steerY);
    };
    
    (0.0, 0.0)
  };
  
  // Combined flocking behavior
  public func flock(agent : Agent, agents : [Agent]) : (Float, Float) {
    let (sepX, sepY) = separation(agent, agents);
    let (aliX, aliY) = alignment(agent, agents);
    let (cohX, cohY) = cohesion(agent, agents);
    
    let forceX = sepX * SEPARATION_WEIGHT + aliX * ALIGNMENT_WEIGHT + cohX * COHESION_WEIGHT;
    let forceY = sepY * SEPARATION_WEIGHT + aliY * ALIGNMENT_WEIGHT + cohY * COHESION_WEIGHT;
    
    // Limit force
    let mag = sqrt(forceX * forceX + forceY * forceY);
    if (mag > MAX_FORCE) {
      (forceX * MAX_FORCE / mag, forceY * MAX_FORCE / mag)
    } else {
      (forceX, forceY)
    }
  };
  
  // Update agent position with flocking
  public func updateAgentFlocking(agent : Agent, agents : [Agent], dt : Float) : Agent {
    let (fx, fy) = flock(agent, agents);
    
    // Update velocity
    var newVX = agent.velX + fx * dt;
    var newVY = agent.velY + fy * dt;
    
    // Limit speed
    let speed = sqrt(newVX * newVX + newVY * newVY);
    if (speed > MAX_SPEED) {
      newVX := newVX * MAX_SPEED / speed;
      newVY := newVY * MAX_SPEED / speed;
    };
    
    // Update position
    var newX = agent.posX + newVX * dt;
    var newY = agent.posY + newVY * dt;
    
    // Wrap around boundaries (toroidal space)
    if (newX < 0.0) newX += 100.0;
    if (newX > 100.0) newX -= 100.0;
    if (newY < 0.0) newY += 100.0;
    if (newY > 100.0) newY -= 100.0;
    
    // Update neighbors
    let newNeighbors = findNeighbors({ agent with posX = newX; posY = newY }, agents, COHESION_DIST);
    
    {
      id = agent.id;
      posX = newX;
      posY = newY;
      velX = newVX;
      velY = newVY;
      phase = agent.phase;
      omega = agent.omega;
      signal = agent.signal;
      role = agent.role;
      clusterId = agent.clusterId;
      neighbors = newNeighbors;
      memory = agent.memory;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // SYNCHRONIZATION (Kuramoto Model)
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Update phase with Kuramoto coupling
  public func updatePhase(agent : Agent, agents : [Agent], couplingK : Float, dt : Float) : Float {
    var phaseSum : Float = 0.0;
    var count : Float = 0.0;
    
    for (nId in agent.neighbors.vals()) {
      if (nId < agents.size()) {
        let neighbor = agents[nId];
        phaseSum += sin(neighbor.phase - agent.phase);
        count += 1.0;
      };
    };
    
    let coupling = if (count > 0.0) couplingK * phaseSum / count else 0.0;
    var newPhase = agent.phase + dt * (agent.omega + coupling);
    
    // Wrap to [0, 2π)
    while (newPhase >= TAU) { newPhase -= TAU };
    while (newPhase < 0.0) { newPhase += TAU };
    
    newPhase
  };
  
  // Calculate global synchronization (order parameter)
  public func calculateSync(agents : [Agent]) : Float {
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    
    for (a in agents.vals()) {
      sumCos += cos(a.phase);
      sumSin += sin(a.phase);
    };
    
    let n = Float.fromInt(agents.size());
    if (n < 1.0) return 0.0;
    
    sumCos /= n;
    sumSin /= n;
    
    sqrt(sumCos * sumCos + sumSin * sumSin)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // STIGMERGY (Pheromone-based Communication)
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Initialize pheromone grids
  public func initPheromones() : PheromoneGrid {
    let zero = Array.tabulate<Float>(GRID_CELLS, func(_ : Nat) : Float { 0.0 });
    {
      food = zero;
      danger = zero;
      home = zero;
      recruit = zero;
    }
  };
  
  // Position to grid cell
  public func posToCell(x : Float, y : Float) : Nat {
    let gx = Int.abs(Float.toInt(clamp(x / 100.0, 0.0, 0.999) * Float.fromInt(GRID_SIZE)));
    let gy = Int.abs(Float.toInt(clamp(y / 100.0, 0.0, 0.999) * Float.fromInt(GRID_SIZE)));
    gy * GRID_SIZE + gx
  };
  
  // Decay pheromones
  public func decayPheromones(grid : [Float], decayRate : Float) : [Float] {
    Array.tabulate<Float>(GRID_CELLS, func(i : Nat) : Float {
      grid[i] * (1.0 - decayRate)
    })
  };
  
  // Deposit pheromone at position
  public func depositPheromone(grid : [Float], x : Float, y : Float, amount : Float) : [Float] {
    let cell = posToCell(x, y);
    Array.tabulate<Float>(GRID_CELLS, func(i : Nat) : Float {
      if (i == cell) {
        clamp(grid[i] + amount, 0.0, PHEROMONE_MAX)
      } else grid[i]
    })
  };
  
  // Read pheromone at position
  public func readPheromone(grid : [Float], x : Float, y : Float) : Float {
    let cell = posToCell(x, y);
    if (cell < GRID_CELLS) grid[cell] else 0.0
  };
  
  // Follow pheromone gradient
  public func followGradient(grid : [Float], x : Float, y : Float) : (Float, Float) {
    let cell = posToCell(x, y);
    let gx = cell % GRID_SIZE;
    let gy = cell / GRID_SIZE;
    
    // Sample neighboring cells
    var maxVal : Float = 0.0;
    var bestDX : Float = 0.0;
    var bestDY : Float = 0.0;
    
    var dy = -1;
    while (dy <= 1) {
      var dx = -1;
      while (dx <= 1) {
        if (dx != 0 or dy != 0) {
          let nx = Int.abs(gx + dx) % GRID_SIZE;
          let ny = Int.abs(gy + dy) % GRID_SIZE;
          let nCell = ny * GRID_SIZE + nx;
          let val = grid[nCell];
          if (val > maxVal) {
            maxVal := val;
            bestDX := Float.fromInt(dx);
            bestDY := Float.fromInt(dy);
          };
        };
        dx += 1;
      };
      dy += 1;
    };
    
    normalize(bestDX, bestDY)
  };
  
  // Update pheromone grid
  public func updatePheromones(pheromones : PheromoneGrid, agents : [Agent]) : PheromoneGrid {
    // Decay all grids
    var food = decayPheromones(pheromones.food, PHEROMONE_DECAY);
    var danger = decayPheromones(pheromones.danger, PHEROMONE_DECAY * 1.5);
    var home = decayPheromones(pheromones.home, PHEROMONE_DECAY * 0.5);
    var recruit = decayPheromones(pheromones.recruit, PHEROMONE_DECAY * 2.0);
    
    // Agents deposit based on role
    for (a in agents.vals()) {
      switch (a.role) {
        case (#Scout) {
          food := depositPheromone(food, a.posX, a.posY, PHEROMONE_DEPOSIT * 0.5);
        };
        case (#Leader) {
          recruit := depositPheromone(recruit, a.posX, a.posY, PHEROMONE_DEPOSIT);
        };
        case (#Guard) {
          danger := depositPheromone(danger, a.posX, a.posY, PHEROMONE_DEPOSIT * 0.3);
        };
        case _ {
          home := depositPheromone(home, a.posX, a.posY, PHEROMONE_DEPOSIT * 0.2);
        };
      };
    };
    
    { food = food; danger = danger; home = home; recruit = recruit }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // CLUSTERING
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Simple distance-based clustering
  public func detectClusters(agents : [Agent]) : [Cluster] {
    // Mark which agents are assigned to clusters
    let assigned = Array.init<Bool>(agents.size(), false);
    let clusters = Buffer.Buffer<Cluster>(8);
    var clusterId : Nat = 0;
    
    var i = 0;
    while (i < agents.size()) {
      if (not assigned[i]) {
        // Start new cluster with this agent
        let seed = agents[i];
        assigned[i] := true;
        
        // Find all agents within cluster distance
        var sumX : Float = seed.posX;
        var sumY : Float = seed.posY;
        var sumVX : Float = seed.velX;
        var sumVY : Float = seed.velY;
        var count : Nat = 1;
        var maxDist : Float = 0.0;
        
        var j = i + 1;
        while (j < agents.size()) {
          if (not assigned[j]) {
            let other = agents[j];
            let dist = distance(seed.posX, seed.posY, other.posX, other.posY);
            if (dist < CLUSTER_THRESHOLD) {
              assigned[j] := true;
              sumX += other.posX;
              sumY += other.posY;
              sumVX += other.velX;
              sumVY += other.velY;
              count += 1;
              if (dist > maxDist) maxDist := dist;
            };
          };
          j += 1;
        };
        
        // Create cluster if it has multiple members
        if (count >= 2) {
          let n = Float.fromInt(count);
          clusters.add({
            id = clusterId;
            centerX = sumX / n;
            centerY = sumY / n;
            radius = maxDist / 2.0 + 1.0;
            memberCount = count;
            coherence = 0.5;  // Will be calculated separately
            velocity = (sumVX / n, sumVY / n);
            dominantRole = #Neutral;
          });
          clusterId += 1;
        };
      };
      i += 1;
    };
    
    Buffer.toArray(clusters)
  };
  
  // Assign agents to clusters
  public func assignClusters(agents : [Agent], clusters : [Cluster]) : [Agent] {
    Array.tabulate<Agent>(agents.size(), func(i : Nat) : Agent {
      let a = agents[i];
      var bestCluster : Nat = 0;
      var minDist : Float = 999999.0;
      
      for (c in clusters.vals()) {
        let dist = distance(a.posX, a.posY, c.centerX, c.centerY);
        if (dist < c.radius * 1.5 and dist < minDist) {
          minDist := dist;
          bestCluster := c.id;
        };
      };
      
      { a with clusterId = bestCluster }
    })
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // PATTERN DETECTION
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Detect flock pattern (moving coherent group)
  public func detectFlock(agents : [Agent]) : ?EmergentPattern {
    if (agents.size() < 3) return null;
    
    // Calculate mean velocity
    var sumVX : Float = 0.0;
    var sumVY : Float = 0.0;
    var sumX : Float = 0.0;
    var sumY : Float = 0.0;
    
    for (a in agents.vals()) {
      sumVX += a.velX;
      sumVY += a.velY;
      sumX += a.posX;
      sumY += a.posY;
    };
    
    let n = Float.fromInt(agents.size());
    let meanVX = sumVX / n;
    let meanVY = sumVY / n;
    let meanX = sumX / n;
    let meanY = sumY / n;
    
    // Calculate velocity alignment (how much agents agree on direction)
    var alignment : Float = 0.0;
    for (a in agents.vals()) {
      let dot = a.velX * meanVX + a.velY * meanVY;
      let magA = sqrt(a.velX * a.velX + a.velY * a.velY);
      let magM = sqrt(meanVX * meanVX + meanVY * meanVY);
      if (magA > 0.1 and magM > 0.1) {
        alignment += dot / (magA * magM);
      };
    };
    alignment /= n;
    
    // Strong alignment indicates flock
    if (alignment > 0.6) {
      ?{
        patternType = #Flock;
        strength = alignment;
        centerX = meanX;
        centerY = meanY;
        direction = atan2(meanVY, meanVX);
        scale = 20.0;
        agentCount = agents.size();
      }
    } else null
  };
  
  // Detect ring pattern (circular formation)
  public func detectRing(agents : [Agent]) : ?EmergentPattern {
    if (agents.size() < 5) return null;
    
    // Calculate centroid
    var sumX : Float = 0.0;
    var sumY : Float = 0.0;
    for (a in agents.vals()) {
      sumX += a.posX;
      sumY += a.posY;
    };
    let n = Float.fromInt(agents.size());
    let cx = sumX / n;
    let cy = sumY / n;
    
    // Calculate distances from centroid
    var sumDist : Float = 0.0;
    var sumDistSq : Float = 0.0;
    for (a in agents.vals()) {
      let d = distance(a.posX, a.posY, cx, cy);
      sumDist += d;
      sumDistSq += d * d;
    };
    
    let meanDist = sumDist / n;
    let varDist = sumDistSq / n - meanDist * meanDist;
    
    // Low variance in distance from center indicates ring
    let ringStrength = if (meanDist > 5.0) 1.0 / (1.0 + varDist / (meanDist * meanDist)) else 0.0;
    
    if (ringStrength > 0.7) {
      ?{
        patternType = #Ring;
        strength = ringStrength;
        centerX = cx;
        centerY = cy;
        direction = 0.0;
        scale = meanDist;
        agentCount = agents.size();
      }
    } else null
  };
  
  // Detect line pattern (linear formation)
  public func detectLine(agents : [Agent]) : ?EmergentPattern {
    if (agents.size() < 4) return null;
    
    // Simple PCA-like: find variance in x and y
    var sumX : Float = 0.0;
    var sumY : Float = 0.0;
    for (a in agents.vals()) {
      sumX += a.posX;
      sumY += a.posY;
    };
    let n = Float.fromInt(agents.size());
    let mx = sumX / n;
    let my = sumY / n;
    
    var varXX : Float = 0.0;
    var varYY : Float = 0.0;
    var varXY : Float = 0.0;
    for (a in agents.vals()) {
      let dx = a.posX - mx;
      let dy = a.posY - my;
      varXX += dx * dx;
      varYY += dy * dy;
      varXY += dx * dy;
    };
    varXX /= n;
    varYY /= n;
    varXY /= n;
    
    // Eccentricity of the variance ellipse
    let trace = varXX + varYY;
    let det = varXX * varYY - varXY * varXY;
    let disc = trace * trace - 4.0 * det;
    if (disc < 0.0) return null;
    
    let lambda1 = (trace + sqrt(disc)) / 2.0;
    let lambda2 = (trace - sqrt(disc)) / 2.0;
    
    let eccentricity = if (lambda1 > 0.01) sqrt(1.0 - lambda2 / lambda1) else 0.0;
    
    if (eccentricity > 0.85) {
      let angle = atan2(2.0 * varXY, varXX - varYY) / 2.0;
      ?{
        patternType = #Line;
        strength = eccentricity;
        centerX = mx;
        centerY = my;
        direction = angle;
        scale = sqrt(lambda1);
        agentCount = agents.size();
      }
    } else null
  };
  
  // Detect all patterns
  public func detectPatterns(agents : [Agent]) : [EmergentPattern] {
    let patterns = Buffer.Buffer<EmergentPattern>(4);
    
    switch (detectFlock(agents)) {
      case (?p) patterns.add(p);
      case null {};
    };
    
    switch (detectRing(agents)) {
      case (?p) patterns.add(p);
      case null {};
    };
    
    switch (detectLine(agents)) {
      case (?p) patterns.add(p);
      case null {};
    };
    
    // If no patterns detected, mark as scattered
    if (patterns.size() == 0) {
      patterns.add({
        patternType = #Scattered;
        strength = 0.5;
        centerX = 50.0;
        centerY = 50.0;
        direction = 0.0;
        scale = 50.0;
        agentCount = agents.size();
      });
    };
    
    Buffer.toArray(patterns)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // ROLE ASSIGNMENT
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Assign roles based on local context
  public func assignRole(agent : Agent, agents : [Agent], pheromones : PheromoneGrid) : AgentRole {
    // Check local conditions
    let neighborCount = agent.neighbors.size();
    let foodLevel = readPheromone(pheromones.food, agent.posX, agent.posY);
    let dangerLevel = readPheromone(pheromones.danger, agent.posX, agent.posY);
    
    // Role assignment rules
    if (dangerLevel > 1.0) {
      #Guard  // High danger -> become guard
    } else if (agent.signal > 1.5 and neighborCount > 5) {
      #Leader  // High signal and many neighbors -> leader
    } else if (neighborCount < 2) {
      #Scout  // Few neighbors -> scout
    } else if (foodLevel > 1.0) {
      #Relay  // On food trail -> relay
    } else if (neighborCount > 3) {
      #Follower
    } else {
      #Neutral
    }
  };
  
  // Update all agent roles
  public func updateRoles(agents : [Agent], pheromones : PheromoneGrid) : [Agent] {
    Array.tabulate<Agent>(agents.size(), func(i : Nat) : Agent {
      let a = agents[i];
      let newRole = assignRole(a, agents, pheromones);
      { a with role = newRole }
    })
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // ENTROPY & INFORMATION
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Calculate spatial entropy (how spread out agents are)
  public func spatialEntropy(agents : [Agent]) : Float {
    // Bin agents into grid cells and calculate entropy
    let histogram = Array.init<Nat>(GRID_CELLS, 0);
    
    for (a in agents.vals()) {
      let cell = posToCell(a.posX, a.posY);
      histogram[cell] += 1;
    };
    
    var entropy : Float = 0.0;
    let total = Float.fromInt(agents.size());
    
    for (count in histogram.vals()) {
      if (count > 0) {
        let p = Float.fromInt(count) / total;
        entropy -= p * ln(p) / ln(2.0);
      };
    };
    
    // Normalize by maximum entropy (log2 of number of cells used)
    let maxEntropy = ln(total) / ln(2.0);
    if (maxEntropy > 0.0) entropy / maxEntropy else 0.0
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // FULL SWARM UPDATE
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Initialize swarm state
  public func initSwarmState(agentCount : Nat) : SwarmState {
    let agents = initSwarm(agentCount);
    {
      agents = agents;
      clusters = [];
      pheromones = initPheromones();
      patterns = [];
      globalSync = 0.5;
      entropy = 0.5;
      beat = 0;
    }
  };
  
  // Full swarm step
  public func stepSwarm(state : SwarmState, couplingK : Float, dt : Float) : SwarmState {
    // 1. Update flocking behavior
    let flocked = Array.tabulate<Agent>(state.agents.size(), func(i : Nat) : Agent {
      updateAgentFlocking(state.agents[i], state.agents, dt)
    });
    
    // 2. Update synchronization
    let synced = Array.tabulate<Agent>(flocked.size(), func(i : Nat) : Agent {
      let a = flocked[i];
      let newPhase = updatePhase(a, flocked, couplingK, dt);
      { a with phase = newPhase }
    });
    
    // 3. Update roles
    let roled = updateRoles(synced, state.pheromones);
    
    // 4. Update pheromones
    let newPheromones = updatePheromones(state.pheromones, roled);
    
    // 5. Detect clusters
    let clusters = detectClusters(roled);
    let clustered = assignClusters(roled, clusters);
    
    // 6. Detect patterns
    let patterns = detectPatterns(clustered);
    
    // 7. Calculate global metrics
    let sync = calculateSync(clustered);
    let entropy = spatialEntropy(clustered);
    
    {
      agents = clustered;
      clusters = clusters;
      pheromones = newPheromones;
      patterns = patterns;
      globalSync = sync;
      entropy = entropy;
      beat = state.beat + 1;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // DIAGNOSTICS
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func getDiagnostics(state : SwarmState) : {
    agentCount   : Nat;
    clusterCount : Nat;
    patternCount : Nat;
    globalSync   : Float;
    entropy      : Float;
    dominantPattern : Text;
  } {
    let dominant = if (state.patterns.size() > 0) {
      switch (state.patterns[0].patternType) {
        case (#Flock) "FLOCK";
        case (#Cluster) "CLUSTER";
        case (#Line) "LINE";
        case (#Ring) "RING";
        case (#Spiral) "SPIRAL";
        case (#Wave) "WAVE";
        case (#Scattered) "SCATTERED";
      }
    } else "NONE";
    
    {
      agentCount = state.agents.size();
      clusterCount = state.clusters.size();
      patternCount = state.patterns.size();
      globalSync = state.globalSync;
      entropy = state.entropy;
      dominantPattern = dominant;
    }
  };
};
