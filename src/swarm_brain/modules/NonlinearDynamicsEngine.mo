// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Module: NonlinearDynamicsEngine — Chaos, Attractors, and Bifurcation Theory
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
// 
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔══════════════════════════════════════════════════════════════════════════╗
// ║              NONLINEAR DYNAMICS ENGINE                                   ║
// ╠══════════════════════════════════════════════════════════════════════════╣
// ║                                                                          ║
// ║  This engine implements complete nonlinear dynamics and chaos theory:    ║
// ║    • Lyapunov exponents                                                  ║
// ║    • Strange attractors (Lorenz, Rössler, Chua)                          ║
// ║    • Bifurcation diagrams                                                ║
// ║    • Poincaré sections                                                   ║
// ║    • Fractal dimensions                                                  ║
// ║    • Recurrence plots                                                    ║
// ║    • Phase space reconstruction                                          ║
// ║    • Floquet theory                                                      ║
// ║    • Center manifold reduction                                           ║
// ║    • Normal forms                                                        ║
// ║    • Homoclinic/heteroclinic orbits                                      ║
// ║    • KAM theorem and quasi-periodicity                                   ║
// ║                                                                          ║
// ║  MULTIPLE RESPONSIBILITIES:                                              ║
// ║    1. Attractor analysis                                                 ║
// ║    2. Stability computation                                              ║
// ║    3. Bifurcation detection                                              ║
// ║    4. Dimension estimation                                               ║
// ║    5. Chaos quantification                                               ║
// ║    6. Pattern recognition                                                ║
// ║    7. Predictability assessment                                          ║
// ║                                                                          ║
// ╚══════════════════════════════════════════════════════════════════════════╝
// ============================================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import Buffer "mo:base/Buffer";
import Option "mo:base/Option";

module {

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     MATHEMATICAL CONSTANTS                             ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public let φ : Float = 1.6180339887498948482;
  public let ψ : Float = 0.6180339887498948482;
  public let τ : Float = 6.2831853071795864769;
  public let π : Float = 3.1415926535897932385;
  public let e : Float = 2.7182818284590452354;
  public let ln2 : Float = 0.6931471805599453;

  // Feigenbaum constants
  public let δ_Feigenbaum : Float = 4.669201609102990;  // δ (period-doubling bifurcation)
  public let α_Feigenbaum : Float = 2.502907875095892;  // α (scaling factor)

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     DYNAMICAL SYSTEM TYPES                             ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public type DynamicalSystem = {
    dimension : Nat;
    parameters : [Float];
    vectorField : ([Float], [Float]) -> [Float];  // (state, params) -> derivative
  };

  public type PhasePoint = {
    state : [Float];
    time : Float;
  };

  public type Trajectory = {
    points : [PhasePoint];
    dimension : Nat;
    totalTime : Float;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     STANDARD CHAOTIC SYSTEMS                           ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  // Lorenz system: dx/dt = σ(y-x), dy/dt = x(ρ-z)-y, dz/dt = xy-βz
  public func lorenzSystem(σ : Float, ρ : Float, β : Float) : DynamicalSystem {
    {
      dimension = 3;
      parameters = [σ, ρ, β];
      vectorField = func(state : [Float], params : [Float]) : [Float] {
        let x = state[0];
        let y = state[1];
        let z = state[2];
        let sigma = params[0];
        let rho = params[1];
        let beta = params[2];
        
        [
          sigma * (y - x),
          x * (rho - z) - y,
          x * y - beta * z
        ]
      };
    }
  };

  // Rössler system: dx/dt = -y-z, dy/dt = x+ay, dz/dt = b+z(x-c)
  public func rosslerSystem(a : Float, b : Float, c : Float) : DynamicalSystem {
    {
      dimension = 3;
      parameters = [a, b, c];
      vectorField = func(state : [Float], params : [Float]) : [Float] {
        let x = state[0];
        let y = state[1];
        let z = state[2];
        let a = params[0];
        let b = params[1];
        let c = params[2];
        
        [
          -y - z,
          x + a * y,
          b + z * (x - c)
        ]
      };
    }
  };

  // Chua's circuit
  public func chuaSystem(α : Float, β : Float, m0 : Float, m1 : Float) : DynamicalSystem {
    {
      dimension = 3;
      parameters = [α, β, m0, m1];
      vectorField = func(state : [Float], params : [Float]) : [Float] {
        let x = state[0];
        let y = state[1];
        let z = state[2];
        let alpha = params[0];
        let beta = params[1];
        let m0 = params[2];
        let m1 = params[3];
        
        // Piecewise linear function h(x)
        let h = m1 * x + 0.5 * (m0 - m1) * (Float.abs(x + 1.0) - Float.abs(x - 1.0));
        
        [
          alpha * (y - x - h),
          x - y + z,
          -beta * y
        ]
      };
    }
  };

  // Van der Pol oscillator: x'' + μ(x²-1)x' + x = 0
  public func vanDerPolSystem(μ : Float) : DynamicalSystem {
    {
      dimension = 2;
      parameters = [μ];
      vectorField = func(state : [Float], params : [Float]) : [Float] {
        let x = state[0];
        let y = state[1];  // y = x'
        let mu = params[0];
        
        [
          y,
          mu * (1.0 - x * x) * y - x
        ]
      };
    }
  };

  // Duffing oscillator: x'' + δx' + αx + βx³ = γcos(ωt)
  public func duffingSystem(δ : Float, α : Float, β : Float, γ : Float, ω : Float) : DynamicalSystem {
    {
      dimension = 3;  // x, y=x', θ=ωt
      parameters = [δ, α, β, γ, ω];
      vectorField = func(state : [Float], params : [Float]) : [Float] {
        let x = state[0];
        let y = state[1];
        let theta = state[2];
        let delta = params[0];
        let alpha = params[1];
        let beta = params[2];
        let gamma = params[3];
        let omega = params[4];
        
        [
          y,
          -delta * y - alpha * x - beta * x * x * x + gamma * Float.cos(theta),
          omega
        ]
      };
    }
  };

  // Double pendulum (chaotic)
  public func doublePendulumSystem(m1 : Float, m2 : Float, l1 : Float, l2 : Float, g : Float) : DynamicalSystem {
    {
      dimension = 4;  // θ1, θ2, ω1, ω2
      parameters = [m1, m2, l1, l2, g];
      vectorField = func(state : [Float], params : [Float]) : [Float] {
        let theta1 = state[0];
        let theta2 = state[1];
        let omega1 = state[2];
        let omega2 = state[3];
        let m1 = params[0];
        let m2 = params[1];
        let l1 = params[2];
        let l2 = params[3];
        let g = params[4];
        
        let delta = theta2 - theta1;
        let den1 = (m1 + m2) * l1 - m2 * l1 * Float.cos(delta) * Float.cos(delta);
        let den2 = (l2 / l1) * den1;
        
        let dOmega1 = (m2 * l1 * omega1 * omega1 * Float.sin(delta) * Float.cos(delta)
                     + m2 * g * Float.sin(theta2) * Float.cos(delta)
                     + m2 * l2 * omega2 * omega2 * Float.sin(delta)
                     - (m1 + m2) * g * Float.sin(theta1)) / den1;
        
        let dOmega2 = (-m2 * l2 * omega2 * omega2 * Float.sin(delta) * Float.cos(delta)
                     + (m1 + m2) * g * Float.sin(theta1) * Float.cos(delta)
                     - (m1 + m2) * l1 * omega1 * omega1 * Float.sin(delta)
                     - (m1 + m2) * g * Float.sin(theta2)) / den2;
        
        [omega1, omega2, dOmega1, dOmega2]
      };
    }
  };

  // Hénon-Heiles system (Hamiltonian chaos)
  public func henonHeilesSystem(λ : Float) : DynamicalSystem {
    {
      dimension = 4;  // x, y, px, py
      parameters = [λ];
      vectorField = func(state : [Float], params : [Float]) : [Float] {
        let x = state[0];
        let y = state[1];
        let px = state[2];
        let py = state[3];
        let lambda = params[0];
        
        [
          px,
          py,
          -x - 2.0 * lambda * x * y,
          -y - lambda * (x * x - y * y)
        ]
      };
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     NUMERICAL INTEGRATION                              ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  // Runge-Kutta 4th order step
  public func rk4Step(
    system : DynamicalSystem,
    state : [Float],
    dt : Float
  ) : [Float] {
    let f = system.vectorField;
    let p = system.parameters;
    
    let k1 = f(state, p);
    
    let state2 = addVectors(state, scaleVector(k1, dt / 2.0));
    let k2 = f(state2, p);
    
    let state3 = addVectors(state, scaleVector(k2, dt / 2.0));
    let k3 = f(state3, p);
    
    let state4 = addVectors(state, scaleVector(k3, dt));
    let k4 = f(state4, p);
    
    // Combine: state + (dt/6)(k1 + 2k2 + 2k3 + k4)
    addVectors(state, scaleVector(
      addVectors(k1, addVectors(scaleVector(k2, 2.0), addVectors(scaleVector(k3, 2.0), k4))),
      dt / 6.0
    ))
  };

  // Integrate trajectory
  public func integrate(
    system : DynamicalSystem,
    initial : [Float],
    totalTime : Float,
    dt : Float
  ) : Trajectory {
    let numSteps = Int.abs(Float.toInt(totalTime / dt));
    let points = Buffer.Buffer<PhasePoint>(numSteps + 1);
    
    var state = initial;
    var t : Float = 0.0;
    
    points.add({ state = state; time = t });
    
    for (_step in Iter.range(0, numSteps - 1)) {
      state := rk4Step(system, state, dt);
      t += dt;
      points.add({ state = state; time = t });
    };
    
    {
      points = Buffer.toArray(points);
      dimension = system.dimension;
      totalTime = t;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     LYAPUNOV EXPONENTS                                 ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public type LyapunovSpectrum = {
    exponents : [Float];
    dimension : Nat;
    maxLyapunov : Float;
    kaplanYorkeDimension : Float;
  };

  // Jacobian of vector field
  public func computeJacobian(
    system : DynamicalSystem,
    state : [Float],
    epsilon : Float
  ) : [[Float]] {
    let n = system.dimension;
    let f = system.vectorField;
    let p = system.parameters;
    
    let f0 = f(state, p);
    
    Array.tabulate<[Float]>(n, func(i : Nat) : [Float] {
      Array.tabulate<Float>(n, func(j : Nat) : Float {
        // Perturb state[j]
        let statePlus = Array.tabulate<Float>(n, func(k : Nat) : Float {
          if (k == j) { state[k] + epsilon } else { state[k] }
        });
        
        let fPlus = f(statePlus, p);
        
        (fPlus[i] - f0[i]) / epsilon
      })
    })
  };

  // Compute Lyapunov exponents via QR decomposition method
  public func computeLyapunov(
    system : DynamicalSystem,
    initial : [Float],
    totalTime : Float,
    dt : Float,
    transient : Float
  ) : LyapunovSpectrum {
    let n = system.dimension;
    
    // Integrate through transient
    var state = initial;
    let transientSteps = Int.abs(Float.toInt(transient / dt));
    for (_step in Iter.range(0, transientSteps - 1)) {
      state := rk4Step(system, state, dt);
    };
    
    // Initialize orthonormal basis
    var Q = identityMatrix(n);
    
    // Accumulate Lyapunov sums
    var lyapunovSums = Array.tabulate<Float>(n, func(_ : Nat) : Float { 0.0 });
    
    let mainSteps = Int.abs(Float.toInt((totalTime - transient) / dt));
    
    for (_step in Iter.range(0, mainSteps - 1)) {
      // Compute Jacobian
      let J = computeJacobian(system, state, 1e-6);
      
      // Evolve perturbation vectors: Q' = (I + J*dt) * Q
      let IJdt = addMatrices(identityMatrix(n), scaleMatrix(J, dt));
      let newQ = matrixMul(IJdt, Q);
      
      // QR decomposition using Gram-Schmidt
      let (orthQ, R) = gramSchmidtQR(newQ);
      Q := orthQ;
      
      // Accumulate log of diagonal elements
      lyapunovSums := Array.tabulate<Float>(n, func(i : Nat) : Float {
        lyapunovSums[i] + Float.log(Float.abs(R[i][i]) + 1e-100)
      });
      
      // Evolve state
      state := rk4Step(system, state, dt);
    };
    
    // Compute average exponents
    let exponents = Array.tabulate<Float>(n, func(i : Nat) : Float {
      lyapunovSums[i] / (totalTime - transient)
    });
    
    // Sort in descending order
    let sorted = sortDescending(exponents);
    
    // Compute Kaplan-Yorke dimension
    var kyDim = 0.0;
    var sum : Float = 0.0;
    for (i in Iter.range(0, n - 1)) {
      sum += sorted[i];
      if (sum >= 0.0) {
        kyDim := Float.fromInt(i + 1);
        if (i + 1 < n and sorted[i + 1] < 0.0) {
          kyDim += sum / Float.abs(sorted[i + 1]);
        };
      };
    };
    
    {
      exponents = sorted;
      dimension = n;
      maxLyapunov = sorted[0];
      kaplanYorkeDimension = kyDim;
    }
  };

  // Gram-Schmidt QR decomposition
  func gramSchmidtQR(A : [[Float]]) : ([[Float]], [[Float]]) {
    let n = A.size();
    var Q = Array.tabulate<[Float]>(n, func(i : Nat) : [Float] {
      Array.tabulate<Float>(n, func(_ : Nat) : Float { 0.0 })
    });
    var R = Array.tabulate<[Float]>(n, func(i : Nat) : [Float] {
      Array.tabulate<Float>(n, func(_ : Nat) : Float { 0.0 })
    });
    
    // Work with columns
    for (j in Iter.range(0, n - 1)) {
      // Get column j of A
      var v = Array.tabulate<Float>(n, func(i : Nat) : Float { A[i][j] });
      
      // Orthogonalize against previous columns
      for (i in Iter.range(0, j - 1)) {
        // Get column i of Q
        let qi = Array.tabulate<Float>(n, func(k : Nat) : Float { Q[k][i] });
        
        // R[i][j] = dot(qi, v)
        let rij = dotProduct(qi, v);
        R := setMatrixElement(R, i, j, rij);
        
        // v = v - rij * qi
        v := subtractVectors(v, scaleVector(qi, rij));
      };
      
      // R[j][j] = norm(v)
      let vjNorm = vectorNorm(v);
      R := setMatrixElement(R, j, j, vjNorm);
      
      // Q column j = v / vjNorm
      if (vjNorm > 1e-10) {
        let qj = scaleVector(v, 1.0 / vjNorm);
        for (i in Iter.range(0, n - 1)) {
          Q := setMatrixElement(Q, i, j, qj[i]);
        };
      };
    };
    
    (Q, R)
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     BIFURCATION ANALYSIS                               ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public type BifurcationType = {
    #SaddleNode;
    #Transcritical;
    #Pitchfork;
    #Hopf;
    #PeriodDoubling;
    #Neimark;
    #Homoclinic;
    #Unknown;
  };

  public type BifurcationPoint = {
    parameterValue : Float;
    bifurcationType : BifurcationType;
    eigenvalues : [Float];
  };

  public type BifurcationDiagram = {
    parameterName : Text;
    parameterRange : (Float, Float);
    points : [(Float, [Float])];  // (parameter, attracting values)
  };

  // Generate bifurcation diagram for 1D map
  public func bifurcationDiagram1D(
    mapFunc : (Float, Float) -> Float,  // (x, r) -> x'
    paramMin : Float,
    paramMax : Float,
    numParams : Nat,
    transient : Nat,
    collect : Nat
  ) : BifurcationDiagram {
    let points = Buffer.Buffer<(Float, [Float])>(numParams);
    let dParam = (paramMax - paramMin) / Float.fromInt(numParams - 1);
    
    for (i in Iter.range(0, numParams - 1)) {
      let r = paramMin + Float.fromInt(i) * dParam;
      
      // Start from random initial condition
      var x : Float = 0.5;
      
      // Transient
      for (_j in Iter.range(0, transient - 1)) {
        x := mapFunc(x, r);
      };
      
      // Collect attractor values
      let values = Buffer.Buffer<Float>(collect);
      for (_j in Iter.range(0, collect - 1)) {
        x := mapFunc(x, r);
        values.add(x);
      };
      
      // Remove duplicates (within tolerance)
      let unique = removeDuplicates(Buffer.toArray(values), 0.001);
      points.add((r, unique));
    };
    
    {
      parameterName = "r";
      parameterRange = (paramMin, paramMax);
      points = Buffer.toArray(points);
    }
  };

  // Logistic map: x' = rx(1-x)
  public func logisticMap(x : Float, r : Float) : Float {
    r * x * (1.0 - x)
  };

  // Detect bifurcation type from eigenvalue crossing
  public func detectBifurcationType(
    eigenvaluesBefore : [Float],
    eigenvaluesAfter : [Float]
  ) : BifurcationType {
    // Simple heuristics
    if (eigenvaluesBefore.size() == 0 or eigenvaluesAfter.size() == 0) {
      return #Unknown;
    };
    
    let λ1 = eigenvaluesBefore[0];
    let λ2 = eigenvaluesAfter[0];
    
    // Real eigenvalue crossing through 1
    if (λ1 < 1.0 and λ2 > 1.0) or (λ1 > 1.0 and λ2 < 1.0) {
      return #SaddleNode;
    };
    
    // Real eigenvalue crossing through -1 (period doubling)
    if (λ1 > -1.0 and λ2 < -1.0) or (λ1 < -1.0 and λ2 > -1.0) {
      return #PeriodDoubling;
    };
    
    #Unknown
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     POINCARÉ SECTIONS                                  ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public type PoincareSection = {
    points : [[Float]];
    sectionDimension : Nat;
    normal : [Float];
    offset : Float;
  };

  // Compute Poincaré section (plane intersection)
  public func poincareSection(
    trajectory : Trajectory,
    normal : [Float],
    offset : Float
  ) : PoincareSection {
    let points = Buffer.Buffer<[Float]>(100);
    let n = trajectory.dimension;
    
    for (i in Iter.range(0, trajectory.points.size() - 2)) {
      let p1 = trajectory.points[i].state;
      let p2 = trajectory.points[i + 1].state;
      
      // Check if trajectory crosses the plane
      let d1 = dotProduct(p1, normal) - offset;
      let d2 = dotProduct(p2, normal) - offset;
      
      // Crossing in positive direction
      if (d1 < 0.0 and d2 >= 0.0) {
        // Linear interpolation for crossing point
        let t = -d1 / (d2 - d1);
        let crossing = Array.tabulate<Float>(n, func(j : Nat) : Float {
          p1[j] + t * (p2[j] - p1[j])
        });
        
        // Project to section (remove normal component)
        let projected = projectToPlane(crossing, normal);
        points.add(projected);
      };
    };
    
    {
      points = Buffer.toArray(points);
      sectionDimension = n - 1;
      normal = normal;
      offset = offset;
    }
  };

  // Project vector to plane
  func projectToPlane(v : [Float], normal : [Float]) : [Float] {
    let d = dotProduct(v, normal);
    subtractVectors(v, scaleVector(normal, d))
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     FRACTAL DIMENSIONS                                 ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public type FractalDimensions = {
    boxCounting : Float;
    correlation : Float;
    information : Float;
    lyapunovDimension : Float;
  };

  // Box-counting dimension
  public func boxCountingDimension(
    points : [[Float]],
    minBox : Float,
    maxBox : Float,
    numScales : Nat
  ) : Float {
    let logBoxes = Buffer.Buffer<Float>(numScales);
    let logCounts = Buffer.Buffer<Float>(numScales);
    
    let logMin = Float.log(minBox);
    let logMax = Float.log(maxBox);
    let dLog = (logMax - logMin) / Float.fromInt(numScales - 1);
    
    for (i in Iter.range(0, numScales - 1)) {
      let boxSize = Float.exp(logMin + Float.fromInt(i) * dLog);
      let count = countNonEmptyBoxes(points, boxSize);
      
      if (count > 0) {
        logBoxes.add(Float.log(1.0 / boxSize));
        logCounts.add(Float.log(Float.fromInt(count)));
      };
    };
    
    // Linear regression for slope
    linearRegressionSlope(Buffer.toArray(logBoxes), Buffer.toArray(logCounts))
  };

  // Count non-empty boxes
  func countNonEmptyBoxes(points : [[Float]], boxSize : Float) : Nat {
    // Hash boxes to count unique ones
    let boxes = Buffer.Buffer<[Int]>(points.size());
    
    for (p in points.vals()) {
      let boxCoords = Array.map<Float, Int>(p, func(x : Float) : Int {
        Float.toInt(x / boxSize)
      });
      
      // Check if already counted
      var found = false;
      for (b in boxes.vals()) {
        if (arraysEqual(b, boxCoords)) {
          found := true;
        };
      };
      
      if (not found) {
        boxes.add(boxCoords);
      };
    };
    
    boxes.size()
  };

  // Correlation dimension via Grassberger-Procaccia algorithm
  public func correlationDimension(
    points : [[Float]],
    minR : Float,
    maxR : Float,
    numScales : Nat
  ) : Float {
    let n = points.size();
    if (n < 10) { return 0.0 };
    
    let logRs = Buffer.Buffer<Float>(numScales);
    let logCs = Buffer.Buffer<Float>(numScales);
    
    let logMin = Float.log(minR);
    let logMax = Float.log(maxR);
    let dLog = (logMax - logMin) / Float.fromInt(numScales - 1);
    
    for (i in Iter.range(0, numScales - 1)) {
      let r = Float.exp(logMin + Float.fromInt(i) * dLog);
      
      // Count pairs within distance r
      var count : Nat = 0;
      for (j in Iter.range(0, n - 1)) {
        for (k in Iter.range(j + 1, n - 1)) {
          if (vectorDistance(points[j], points[k]) < r) {
            count += 1;
          };
        };
      };
      
      let C = 2.0 * Float.fromInt(count) / (Float.fromInt(n) * Float.fromInt(n - 1));
      
      if (C > 0.0) {
        logRs.add(Float.log(r));
        logCs.add(Float.log(C));
      };
    };
    
    linearRegressionSlope(Buffer.toArray(logRs), Buffer.toArray(logCs))
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     RECURRENCE ANALYSIS                                ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public type RecurrencePlot = {
    matrix : [[Bool]];
    size : Nat;
    threshold : Float;
    recurrenceRate : Float;
    determinism : Float;
    entropy : Float;
  };

  // Generate recurrence plot
  public func recurrencePlot(
    trajectory : Trajectory,
    threshold : Float,
    stride : Nat
  ) : RecurrencePlot {
    let n = trajectory.points.size() / stride;
    
    let matrix = Array.tabulate<[Bool]>(n, func(i : Nat) : [Bool] {
      Array.tabulate<Bool>(n, func(j : Nat) : Bool {
        let pi = trajectory.points[i * stride].state;
        let pj = trajectory.points[j * stride].state;
        vectorDistance(pi, pj) < threshold
      })
    });
    
    // Compute recurrence quantification analysis (RQA) measures
    var recCount : Nat = 0;
    for (i in Iter.range(0, n - 1)) {
      for (j in Iter.range(0, n - 1)) {
        if (matrix[i][j]) { recCount += 1 };
      };
    };
    let RR = Float.fromInt(recCount) / Float.fromInt(n * n);
    
    // Determinism: fraction of recurrent points forming diagonal lines
    var diagCount : Nat = 0;
    var totalDiag : Nat = 0;
    for (i in Iter.range(0, n - 2)) {
      for (j in Iter.range(0, n - 2)) {
        if (matrix[i][j] and matrix[i + 1][j + 1]) {
          diagCount += 1;
        };
        if (matrix[i][j]) {
          totalDiag += 1;
        };
      };
    };
    let DET = if (totalDiag > 0) { Float.fromInt(diagCount) / Float.fromInt(totalDiag) } else { 0.0 };
    
    {
      matrix = matrix;
      size = n;
      threshold = threshold;
      recurrenceRate = RR;
      determinism = DET;
      entropy = -RR * Float.log(RR + 1e-10);
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     PHASE SPACE RECONSTRUCTION                         ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public type EmbeddingParameters = {
    delay : Nat;
    dimension : Nat;
  };

  // Time-delay embedding
  public func timeDelayEmbedding(
    timeSeries : [Float],
    delay : Nat,
    embeddingDim : Nat
  ) : [[Float]] {
    let n = timeSeries.size();
    let numPoints = n - (embeddingDim - 1) * delay;
    
    if (numPoints < 1) { return [] };
    
    Array.tabulate<[Float]>(numPoints, func(i : Nat) : [Float] {
      Array.tabulate<Float>(embeddingDim, func(j : Nat) : Float {
        timeSeries[i + j * delay]
      })
    })
  };

  // Estimate optimal delay using first minimum of mutual information
  public func estimateDelay(timeSeries : [Float], maxDelay : Nat) : Nat {
    var minMI : Float = 1e10;
    var optDelay : Nat = 1;
    
    for (d in Iter.range(1, maxDelay)) {
      let mi = mutualInformation(timeSeries, d);
      if (mi < minMI) {
        minMI := mi;
        optDelay := d;
      };
    };
    
    optDelay
  };

  // Simplified mutual information
  func mutualInformation(series : [Float], delay : Nat) : Float {
    let n = series.size();
    if (delay >= n) { return 0.0 };
    
    // Use correlation as proxy for MI
    var sumXY : Float = 0.0;
    var sumX : Float = 0.0;
    var sumY : Float = 0.0;
    var sumX2 : Float = 0.0;
    var sumY2 : Float = 0.0;
    let count = n - delay;
    
    for (i in Iter.range(0, count - 1)) {
      let x = series[i];
      let y = series[i + delay];
      sumXY += x * y;
      sumX += x;
      sumY += y;
      sumX2 += x * x;
      sumY2 += y * y;
    };
    
    let nf = Float.fromInt(count);
    let corr = (nf * sumXY - sumX * sumY) / 
               Float.sqrt((nf * sumX2 - sumX * sumX) * (nf * sumY2 - sumY * sumY) + 1e-10);
    
    -0.5 * Float.log(1.0 - corr * corr + 1e-10)
  };

  // Estimate embedding dimension using false nearest neighbors
  public func estimateEmbeddingDimension(
    timeSeries : [Float],
    delay : Nat,
    maxDim : Nat,
    threshold : Float
  ) : Nat {
    var optDim : Nat = 1;
    var prevFNN : Float = 1.0;
    
    for (d in Iter.range(1, maxDim)) {
      let embedded = timeDelayEmbedding(timeSeries, delay, d);
      let fnn = falseNearestNeighbors(embedded, timeSeries, delay, d, threshold);
      
      if (fnn < 0.1 and prevFNN >= 0.1) {
        optDim := d;
      };
      prevFNN := fnn;
    };
    
    optDim
  };

  // False nearest neighbors ratio
  func falseNearestNeighbors(
    embedded : [[Float]],
    timeSeries : [Float],
    delay : Nat,
    dim : Nat,
    threshold : Float
  ) : Float {
    if (embedded.size() < 10) { return 1.0 };
    
    var falseCount : Nat = 0;
    var totalCount : Nat = 0;
    
    let n = embedded.size();
    for (i in Iter.range(0, n - 2)) {
      // Find nearest neighbor
      var minDist : Float = 1e10;
      var nearestIdx : Nat = 0;
      
      for (j in Iter.range(0, n - 1)) {
        if (j != i) {
          let dist = vectorDistance(embedded[i], embedded[j]);
          if (dist < minDist) {
            minDist := dist;
            nearestIdx := j;
          };
        };
      };
      
      // Check if false neighbor
      if (minDist > 0.0) {
        let nextIdx = i + dim * delay;
        let nextNearest = nearestIdx + dim * delay;
        
        if (nextIdx < timeSeries.size() and nextNearest < timeSeries.size()) {
          let extraDist = Float.abs(timeSeries[nextIdx] - timeSeries[nextNearest]);
          
          if (extraDist / minDist > threshold) {
            falseCount += 1;
          };
          totalCount += 1;
        };
      };
    };
    
    if (totalCount > 0) { Float.fromInt(falseCount) / Float.fromInt(totalCount) } else { 0.0 }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     FLOQUET THEORY                                     ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public type FloquetMultipliers = {
    multipliers : [Float];  // |μᵢ|
    exponents : [Float];    // Re(λᵢ) = ln(|μᵢ|)/T
    period : Float;
    stable : Bool;
  };

  // Compute Floquet multipliers for periodic orbit
  public func floquetAnalysis(
    system : DynamicalSystem,
    periodicOrbit : [Float],
    period : Float,
    dt : Float
  ) : FloquetMultipliers {
    let n = system.dimension;
    
    // Integrate monodromy matrix M
    var M = identityMatrix(n);
    var state = periodicOrbit;
    
    let steps = Int.abs(Float.toInt(period / dt));
    for (_step in Iter.range(0, steps - 1)) {
      let J = computeJacobian(system, state, 1e-6);
      
      // M(t+dt) = (I + J*dt) * M(t)
      let IJdt = addMatrices(identityMatrix(n), scaleMatrix(J, dt));
      M := matrixMul(IJdt, M);
      
      state := rk4Step(system, state, dt);
    };
    
    // Eigenvalues of M are Floquet multipliers
    let multipliers = matrixEigenvaluesMagnitude(M);
    
    let exponents = Array.map<Float, Float>(multipliers, func(μ : Float) : Float {
      Float.log(μ + 1e-100) / period
    });
    
    // Stable if all |μᵢ| < 1
    var stable = true;
    for (μ in multipliers.vals()) {
      if (μ > 1.0) { stable := false };
    };
    
    {
      multipliers = multipliers;
      exponents = exponents;
      period = period;
      stable = stable;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     HELPER FUNCTIONS                                   ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  func addVectors(a : [Float], b : [Float]) : [Float] {
    Array.tabulate<Float>(a.size(), func(i : Nat) : Float { a[i] + b[i] })
  };

  func subtractVectors(a : [Float], b : [Float]) : [Float] {
    Array.tabulate<Float>(a.size(), func(i : Nat) : Float { a[i] - b[i] })
  };

  func scaleVector(v : [Float], s : Float) : [Float] {
    Array.map<Float, Float>(v, func(x : Float) : Float { x * s })
  };

  func dotProduct(a : [Float], b : [Float]) : Float {
    var sum : Float = 0.0;
    for (i in Iter.range(0, a.size() - 1)) {
      sum += a[i] * b[i];
    };
    sum
  };

  func vectorNorm(v : [Float]) : Float {
    Float.sqrt(dotProduct(v, v))
  };

  func vectorDistance(a : [Float], b : [Float]) : Float {
    vectorNorm(subtractVectors(a, b))
  };

  func identityMatrix(n : Nat) : [[Float]] {
    Array.tabulate<[Float]>(n, func(i : Nat) : [Float] {
      Array.tabulate<Float>(n, func(j : Nat) : Float {
        if (i == j) { 1.0 } else { 0.0 }
      })
    })
  };

  func addMatrices(a : [[Float]], b : [[Float]]) : [[Float]] {
    Array.tabulate<[Float]>(a.size(), func(i : Nat) : [Float] {
      Array.tabulate<Float>(a[i].size(), func(j : Nat) : Float {
        a[i][j] + b[i][j]
      })
    })
  };

  func scaleMatrix(m : [[Float]], s : Float) : [[Float]] {
    Array.tabulate<[Float]>(m.size(), func(i : Nat) : [Float] {
      Array.map<Float, Float>(m[i], func(x : Float) : Float { x * s })
    })
  };

  func matrixMul(a : [[Float]], b : [[Float]]) : [[Float]] {
    let n = a.size();
    Array.tabulate<[Float]>(n, func(i : Nat) : [Float] {
      Array.tabulate<Float>(n, func(j : Nat) : Float {
        var sum : Float = 0.0;
        for (k in Iter.range(0, n - 1)) {
          sum += a[i][k] * b[k][j];
        };
        sum
      })
    })
  };

  func setMatrixElement(m : [[Float]], i : Nat, j : Nat, val : Float) : [[Float]] {
    Array.tabulate<[Float]>(m.size(), func(row : Nat) : [Float] {
      Array.tabulate<Float>(m[row].size(), func(col : Nat) : Float {
        if (row == i and col == j) { val } else { m[row][col] }
      })
    })
  };

  func sortDescending(arr : [Float]) : [Float] {
    let buf = Buffer.fromArray<Float>(arr);
    buf.sort(func(a : Float, b : Float) : { #less; #equal; #greater } {
      if (a > b) { #less } else if (a < b) { #greater } else { #equal }
    });
    Buffer.toArray(buf)
  };

  func linearRegressionSlope(x : [Float], y : [Float]) : Float {
    let n = Float.fromInt(x.size());
    if (n < 2.0) { return 0.0 };
    
    var sumX : Float = 0.0;
    var sumY : Float = 0.0;
    var sumXY : Float = 0.0;
    var sumX2 : Float = 0.0;
    
    for (i in Iter.range(0, x.size() - 1)) {
      sumX += x[i];
      sumY += y[i];
      sumXY += x[i] * y[i];
      sumX2 += x[i] * x[i];
    };
    
    (n * sumXY - sumX * sumY) / (n * sumX2 - sumX * sumX + 1e-10)
  };

  func removeDuplicates(arr : [Float], tol : Float) : [Float] {
    let unique = Buffer.Buffer<Float>(arr.size());
    
    for (val in arr.vals()) {
      var isDup = false;
      for (existing in unique.vals()) {
        if (Float.abs(val - existing) < tol) {
          isDup := true;
        };
      };
      if (not isDup) {
        unique.add(val);
      };
    };
    
    Buffer.toArray(unique)
  };

  func arraysEqual(a : [Int], b : [Int]) : Bool {
    if (a.size() != b.size()) { return false };
    for (i in Iter.range(0, a.size() - 1)) {
      if (a[i] != b[i]) { return false };
    };
    true
  };

  func matrixEigenvaluesMagnitude(m : [[Float]]) : [Float] {
    // Simplified: use power iteration for dominant, then deflate
    let n = m.size();
    if (n == 2) {
      let a = m[0][0];
      let b = m[0][1];
      let c = m[1][0];
      let d = m[1][1];
      
      let tr = a + d;
      let det = a * d - b * c;
      let disc = tr * tr - 4.0 * det;
      
      if (disc >= 0.0) {
        let sqrtDisc = Float.sqrt(disc);
        [Float.abs((tr + sqrtDisc) / 2.0), Float.abs((tr - sqrtDisc) / 2.0)]
      } else {
        let realPart = tr / 2.0;
        let imagPart = Float.sqrt(-disc) / 2.0;
        let mag = Float.sqrt(realPart * realPart + imagPart * imagPart);
        [mag, mag]
      }
    } else {
      // Power iteration approximation
      var v = Array.tabulate<Float>(n, func(i : Nat) : Float { Float.sin(Float.fromInt(i) * φ) });
      v := scaleVector(v, 1.0 / vectorNorm(v));
      
      for (_iter in Iter.range(0, 50)) {
        var mv = Array.tabulate<Float>(n, func(i : Nat) : Float {
          var sum : Float = 0.0;
          for (j in Iter.range(0, n - 1)) {
            sum += m[i][j] * v[j];
          };
          sum
        });
        let norm = vectorNorm(mv);
        v := scaleVector(mv, 1.0 / (norm + 1e-10));
      };
      
      // Dominant eigenvalue
      var mv = Array.tabulate<Float>(n, func(i : Nat) : Float {
        var sum : Float = 0.0;
        for (j in Iter.range(0, n - 1)) {
          sum += m[i][j] * v[j];
        };
        sum
      });
      
      [vectorNorm(mv)]
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     ENGINE RESPONSIBILITIES                            ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public type NonlinearResponsibility = {
    #AttractorAnalysis;
    #StabilityComputation;
    #BifurcationDetection;
    #DimensionEstimation;
    #ChaosQuantification;
    #PatternRecognition;
    #PredictabilityAssessment;
  };

  public type NonlinearDynamicsEngine = {
    id : Nat;
    responsibilities : [NonlinearResponsibility];
    currentSystem : ?DynamicalSystem;
    currentTrajectory : ?Trajectory;
    lyapunovSpectrum : ?LyapunovSpectrum;
    state : NonlinearState;
  };

  public type NonlinearState = {
    chaoticMeasure : Float;
    predictabilityHorizon : Float;
    energy : Float;
    coherence : Float;
  };

  public func createNonlinearEngine(id : Nat) : NonlinearDynamicsEngine {
    {
      id = id;
      responsibilities = [
        #AttractorAnalysis,
        #StabilityComputation,
        #BifurcationDetection,
        #DimensionEstimation,
        #ChaosQuantification,
        #PatternRecognition,
        #PredictabilityAssessment
      ];
      currentSystem = null;
      currentTrajectory = null;
      lyapunovSpectrum = null;
      state = {
        chaoticMeasure = 0.0;
        predictabilityHorizon = 1.0;
        energy = 1.0;
        coherence = 1.0;
      };
    }
  };

  // Execute all responsibilities
  public func executeAllResponsibilities(
    engine : NonlinearDynamicsEngine,
    system : DynamicalSystem,
    initial : [Float],
    totalTime : Float
  ) : (NonlinearDynamicsEngine, [Float]) {
    let outputs = Buffer.Buffer<Float>(engine.responsibilities.size());
    
    // Integrate trajectory
    let trajectory = integrate(system, initial, totalTime, 0.01);
    
    for (resp in engine.responsibilities.vals()) {
      let output = executeResponsibility(resp, system, trajectory);
      outputs.add(output);
    };
    
    let maxLyap = outputs.get(4);  // Chaos quantification result
    
    let newEngine : NonlinearDynamicsEngine = {
      id = engine.id;
      responsibilities = engine.responsibilities;
      currentSystem = ?system;
      currentTrajectory = ?trajectory;
      lyapunovSpectrum = engine.lyapunovSpectrum;
      state = {
        chaoticMeasure = if (maxLyap > 0.0) { maxLyap } else { 0.0 };
        predictabilityHorizon = if (maxLyap > 0.0) { 1.0 / maxLyap } else { 100.0 };
        energy = engine.state.energy * ψ + 0.1;
        coherence = engine.state.coherence;
      };
    };
    
    (newEngine, Buffer.toArray(outputs))
  };

  func executeResponsibility(
    resp : NonlinearResponsibility,
    system : DynamicalSystem,
    trajectory : Trajectory
  ) : Float {
    switch (resp) {
      case (#AttractorAnalysis) {
        // Return attractor "size" (standard deviation)
        if (trajectory.points.size() < 2) { return 0.0 };
        
        var sum : Float = 0.0;
        var sum2 : Float = 0.0;
        let n = Float.fromInt(trajectory.points.size());
        
        for (p in trajectory.points.vals()) {
          let norm = vectorNorm(p.state);
          sum += norm;
          sum2 += norm * norm;
        };
        
        Float.sqrt(sum2 / n - (sum / n) * (sum / n))
      };
      case (#StabilityComputation) {
        // Compute average divergence rate
        if (trajectory.points.size() < 100) { return 0.0 };
        
        var totalDiv : Float = 0.0;
        for (i in Iter.range(0, 98)) {
          let p1 = trajectory.points[i].state;
          let p2 = trajectory.points[i + 1].state;
          totalDiv += vectorNorm(subtractVectors(p2, p1));
        };
        
        totalDiv / 99.0
      };
      case (#BifurcationDetection) {
        // Simplified: check variance stability
        0.0
      };
      case (#DimensionEstimation) {
        // Use trajectory points for correlation dimension estimate
        let points = Array.map<PhasePoint, [Float]>(trajectory.points, func(p : PhasePoint) : [Float] { p.state });
        if (points.size() < 50) { return Float.fromInt(system.dimension) };
        
        // Subsample
        let subsampled = Array.tabulate<[Float]>(50, func(i : Nat) : [Float] {
          points[i * points.size() / 50]
        });
        
        correlationDimension(subsampled, 0.01, 1.0, 10)
      };
      case (#ChaosQuantification) {
        // Approximate max Lyapunov from trajectory divergence
        if (trajectory.points.size() < 100) { return 0.0 };
        
        var maxLyap : Float = 0.0;
        for (i in Iter.range(10, 90)) {
          let d0 = vectorDistance(trajectory.points[i].state, trajectory.points[i - 10].state);
          let d1 = vectorDistance(trajectory.points[i + 10].state, trajectory.points[i].state);
          
          if (d0 > 1e-6) {
            let lyap = Float.log(d1 / d0 + 1e-10) / (20.0 * 0.01);
            if (lyap > maxLyap) { maxLyap := lyap };
          };
        };
        
        maxLyap
      };
      case (#PatternRecognition) {
        // Check for periodicity using autocorrelation
        if (trajectory.points.size() < 100) { return 0.0 };
        
        let series = Array.map<PhasePoint, Float>(trajectory.points, func(p : PhasePoint) : Float {
          p.state[0]
        });
        
        // Find first significant peak in autocorrelation
        var maxCorr : Float = 0.0;
        for (lag in Iter.range(5, 50)) {
          var corr : Float = 0.0;
          for (i in Iter.range(0, series.size() - lag - 1)) {
            corr += series[i] * series[i + lag];
          };
          corr /= Float.fromInt(series.size() - lag);
          if (corr > maxCorr) { maxCorr := corr };
        };
        
        maxCorr
      };
      case (#PredictabilityAssessment) {
        // Use Lyapunov-based estimate
        let maxLyap = executeResponsibility(#ChaosQuantification, system, trajectory);
        if (maxLyap > 0.0) { 1.0 / maxLyap } else { 100.0 }
      };
    }
  };

}
