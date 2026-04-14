// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Module: DifferentialGeometryEngine — Complete Differential Geometry on Manifolds
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
// 
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔══════════════════════════════════════════════════════════════════════════╗
// ║              DIFFERENTIAL GEOMETRY ENGINE                                ║
// ╠══════════════════════════════════════════════════════════════════════════╣
// ║                                                                          ║
// ║  This engine implements:                                                 ║
// ║    • Metric tensors g_μν                                                 ║
// ║    • Christoffel symbols Γ^λ_μν                                          ║
// ║    • Riemann curvature tensor R^ρ_σμν                                    ║
// ║    • Ricci tensor R_μν and scalar R                                      ║
// ║    • Geodesic equations                                                  ║
// ║    • Covariant derivatives ∇_μ                                           ║
// ║    • Lie derivatives L_X                                                 ║
// ║    • Differential forms and exterior calculus                            ║
// ║    • Cartan structure equations                                          ║
// ║    • Gauss-Bonnet theorem                                                ║
// ║                                                                          ║
// ║  MULTIPLE RESPONSIBILITIES:                                              ║
// ║    1. Curvature computation                                              ║
// ║    2. Geodesic calculation                                               ║
// ║    3. Parallel transport                                                 ║
// ║    4. Connection theory                                                  ║
// ║    5. Form integration                                                   ║
// ║    6. Topology detection                                                 ║
// ║    7. Metric analysis                                                    ║
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

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     COORDINATE SYSTEMS                                 ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public type CoordinateSystem = {
    #Cartesian;
    #Spherical;
    #Cylindrical;
    #Toroidal;
    #Hyperbolic;
    #Custom;
  };

  public type Point = {
    coords : [Float];
    dimension : Nat;
    system : CoordinateSystem;
  };

  public func createPoint(coords : [Float], system : CoordinateSystem) : Point {
    { coords = coords; dimension = coords.size(); system = system }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     TENSOR TYPES                                       ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  // Rank (p, q) tensor: p contravariant, q covariant indices
  public type Tensor = {
    components : [Float];
    rank : (Nat, Nat);  // (contravariant, covariant)
    dimension : Nat;
  };

  // Metric tensor g_μν (rank 0,2)
  public type MetricTensor = {
    g : [[Float]];        // Covariant components g_μν
    gInverse : [[Float]]; // Contravariant components g^μν
    determinant : Float;
    dimension : Nat;
  };

  // Christoffel symbols Γ^λ_μν
  public type ChristoffelSymbols = {
    gamma : [[[Float]]];  // Γ^λ_μν indexed as [λ][μ][ν]
    dimension : Nat;
  };

  // Riemann curvature tensor R^ρ_σμν
  public type RiemannTensor = {
    R : [[[[Float]]]];    // R^ρ_σμν indexed as [ρ][σ][μ][ν]
    dimension : Nat;
  };

  // Ricci tensor R_μν
  public type RicciTensor = {
    R : [[Float]];
    scalar : Float;       // Ricci scalar R = g^μν R_μν
    dimension : Nat;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     METRIC TENSOR OPERATIONS                           ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  // Flat Euclidean metric
  public func euclideanMetric(n : Nat) : MetricTensor {
    let g = Array.tabulate<[Float]>(n, func(i : Nat) : [Float] {
      Array.tabulate<Float>(n, func(j : Nat) : Float {
        if (i == j) { 1.0 } else { 0.0 }
      })
    });
    
    { g = g; gInverse = g; determinant = 1.0; dimension = n }
  };

  // Minkowski metric (special relativity)
  public func minkowskiMetric() : MetricTensor {
    let g = [
      [-1.0, 0.0, 0.0, 0.0],
      [0.0, 1.0, 0.0, 0.0],
      [0.0, 0.0, 1.0, 0.0],
      [0.0, 0.0, 0.0, 1.0]
    ];
    
    { g = g; gInverse = g; determinant = -1.0; dimension = 4 }
  };

  // Spherical metric (r, θ, φ)
  public func sphericalMetric(r : Float, theta : Float) : MetricTensor {
    let sinTheta = Float.sin(theta);
    let sinTheta2 = sinTheta * sinTheta;
    let r2 = r * r;
    
    let g = [
      [1.0, 0.0, 0.0],
      [0.0, r2, 0.0],
      [0.0, 0.0, r2 * sinTheta2]
    ];
    
    let gInv = [
      [1.0, 0.0, 0.0],
      [0.0, 1.0 / r2, 0.0],
      [0.0, 0.0, 1.0 / (r2 * sinTheta2)]
    ];
    
    let det = r2 * r2 * sinTheta2;
    
    { g = g; gInverse = gInv; determinant = det; dimension = 3 }
  };

  // Unit sphere metric (θ, φ) - induced from R³
  public func unitSphereMetric(theta : Float) : MetricTensor {
    let sinTheta = Float.sin(theta);
    let sinTheta2 = sinTheta * sinTheta;
    
    let g = [
      [1.0, 0.0],
      [0.0, sinTheta2]
    ];
    
    let gInv = [
      [1.0, 0.0],
      [0.0, if (sinTheta2 > 1e-10) { 1.0 / sinTheta2 } else { 1e10 }]
    ];
    
    { g = g; gInverse = gInv; determinant = sinTheta2; dimension = 2 }
  };

  // Schwarzschild metric (general relativity, black hole)
  public func schwarzschildMetric(r : Float, M : Float) : MetricTensor {
    let rs = 2.0 * M;  // Schwarzschild radius (G = c = 1)
    let f = 1.0 - rs / r;
    
    let g = [
      [-f, 0.0, 0.0, 0.0],
      [0.0, 1.0 / f, 0.0, 0.0],
      [0.0, 0.0, r * r, 0.0],
      [0.0, 0.0, 0.0, r * r]  // Simplified: at θ = π/2
    ];
    
    let gInv = [
      [-1.0 / f, 0.0, 0.0, 0.0],
      [0.0, f, 0.0, 0.0],
      [0.0, 0.0, 1.0 / (r * r), 0.0],
      [0.0, 0.0, 0.0, 1.0 / (r * r)]
    ];
    
    let det = -r * r * r * r;
    
    { g = g; gInverse = gInv; determinant = det; dimension = 4 }
  };

  // Torus metric (R + r·cos(v), v) where R is major radius, r is minor
  public func torusMetric(R : Float, r : Float, v : Float) : MetricTensor {
    let cosV = Float.cos(v);
    let rPlusCos = R + r * cosV;
    
    let g = [
      [rPlusCos * rPlusCos, 0.0],
      [0.0, r * r]
    ];
    
    let gInv = [
      [1.0 / (rPlusCos * rPlusCos), 0.0],
      [0.0, 1.0 / (r * r)]
    ];
    
    let det = rPlusCos * rPlusCos * r * r;
    
    { g = g; gInverse = gInv; determinant = det; dimension = 2 }
  };

  // Hyperbolic plane (Poincaré disk model)
  public func hyperbolicMetric(x : Float, y : Float) : MetricTensor {
    let r2 = x * x + y * y;
    let denom = (1.0 - r2) * (1.0 - r2);
    let scale = 4.0 / denom;
    
    let g = [
      [scale, 0.0],
      [0.0, scale]
    ];
    
    let gInv = [
      [1.0 / scale, 0.0],
      [0.0, 1.0 / scale]
    ];
    
    { g = g; gInverse = gInv; determinant = scale * scale; dimension = 2 }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     CHRISTOFFEL SYMBOLS                                ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  // Compute Christoffel symbols from metric: Γ^λ_μν = (1/2) g^λρ (∂_μ g_νρ + ∂_ν g_ρμ - ∂_ρ g_μν)
  public func computeChristoffel(
    metric : MetricTensor,
    metricDerivatives : [[[Float]]]  // ∂_λ g_μν indexed as [λ][μ][ν]
  ) : ChristoffelSymbols {
    let n = metric.dimension;
    
    let gamma = Array.tabulate<[[Float]]>(n, func(lambda : Nat) : [[Float]] {
      Array.tabulate<[Float]>(n, func(mu : Nat) : [Float] {
        Array.tabulate<Float>(n, func(nu : Nat) : Float {
          var sum : Float = 0.0;
          for (rho in Iter.range(0, n - 1)) {
            let term = metricDerivatives[mu][nu][rho] + 
                       metricDerivatives[nu][rho][mu] - 
                       metricDerivatives[rho][mu][nu];
            sum += metric.gInverse[lambda][rho] * term;
          };
          0.5 * sum
        })
      })
    });
    
    { gamma = gamma; dimension = n }
  };

  // Christoffel symbols for unit sphere
  public func sphereChristoffel(theta : Float) : ChristoffelSymbols {
    let sinTheta = Float.sin(theta);
    let cosTheta = Float.cos(theta);
    let cotTheta = if (Float.abs(sinTheta) > 1e-10) { cosTheta / sinTheta } else { 0.0 };
    
    // Only non-zero components:
    // Γ^θ_φφ = -sin(θ)cos(θ)
    // Γ^φ_θφ = Γ^φ_φθ = cot(θ)
    
    let gamma : [[[Float]]] = [
      // Γ^θ_μν
      [
        [0.0, 0.0],              // Γ^θ_θθ, Γ^θ_θφ
        [0.0, -sinTheta * cosTheta]  // Γ^θ_φθ, Γ^θ_φφ
      ],
      // Γ^φ_μν
      [
        [0.0, cotTheta],         // Γ^φ_θθ, Γ^φ_θφ
        [cotTheta, 0.0]          // Γ^φ_φθ, Γ^φ_φφ
      ]
    ];
    
    { gamma = gamma; dimension = 2 }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     RIEMANN CURVATURE TENSOR                           ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  // Compute Riemann tensor: R^ρ_σμν = ∂_μ Γ^ρ_νσ - ∂_ν Γ^ρ_μσ + Γ^ρ_μλ Γ^λ_νσ - Γ^ρ_νλ Γ^λ_μσ
  public func computeRiemann(
    christoffel : ChristoffelSymbols,
    christoffelDerivatives : [[[[Float]]]]  // ∂_λ Γ^ρ_μν indexed as [λ][ρ][μ][ν]
  ) : RiemannTensor {
    let n = christoffel.dimension;
    let gamma = christoffel.gamma;
    
    let R = Array.tabulate<[[[Float]]]>(n, func(rho : Nat) : [[[Float]]] {
      Array.tabulate<[[Float]]>(n, func(sigma : Nat) : [[Float]] {
        Array.tabulate<[Float]>(n, func(mu : Nat) : [Float] {
          Array.tabulate<Float>(n, func(nu : Nat) : Float {
            // ∂_μ Γ^ρ_νσ - ∂_ν Γ^ρ_μσ
            var result = christoffelDerivatives[mu][rho][nu][sigma] - 
                        christoffelDerivatives[nu][rho][mu][sigma];
            
            // + Γ^ρ_μλ Γ^λ_νσ - Γ^ρ_νλ Γ^λ_μσ
            for (lambda in Iter.range(0, n - 1)) {
              result += gamma[rho][mu][lambda] * gamma[lambda][nu][sigma];
              result -= gamma[rho][nu][lambda] * gamma[lambda][mu][sigma];
            };
            
            result
          })
        })
      })
    });
    
    { R = R; dimension = n }
  };

  // Riemann tensor for unit sphere (constant curvature = 1)
  public func sphereRiemann(theta : Float) : RiemannTensor {
    let sinTheta = Float.sin(theta);
    let sinTheta2 = sinTheta * sinTheta;
    
    // R^θ_φθφ = sin²(θ), R^φ_θφθ = 1
    // Other components related by symmetries
    
    let R : [[[[Float]]]] = [
      // R^θ_σμν
      [
        // R^θ_θμν
        [[0.0, 0.0], [0.0, 0.0]],
        // R^θ_φμν
        [[0.0, sinTheta2], [-sinTheta2, 0.0]]
      ],
      // R^φ_σμν
      [
        // R^φ_θμν
        [[0.0, -1.0], [1.0, 0.0]],
        // R^φ_φμν
        [[0.0, 0.0], [0.0, 0.0]]
      ]
    ];
    
    { R = R; dimension = 2 }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     RICCI TENSOR AND SCALAR                            ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  // Compute Ricci tensor: R_μν = R^λ_μλν (contraction of Riemann)
  public func computeRicci(riemann : RiemannTensor, metric : MetricTensor) : RicciTensor {
    let n = riemann.dimension;
    
    let Ric = Array.tabulate<[Float]>(n, func(mu : Nat) : [Float] {
      Array.tabulate<Float>(n, func(nu : Nat) : Float {
        var sum : Float = 0.0;
        for (lambda in Iter.range(0, n - 1)) {
          sum += riemann.R[lambda][mu][lambda][nu];
        };
        sum
      })
    });
    
    // Ricci scalar R = g^μν R_μν
    var scalar : Float = 0.0;
    for (mu in Iter.range(0, n - 1)) {
      for (nu in Iter.range(0, n - 1)) {
        scalar += metric.gInverse[mu][nu] * Ric[mu][nu];
      };
    };
    
    { R = Ric; scalar = scalar; dimension = n }
  };

  // Ricci tensor and scalar for unit sphere
  public func sphereRicci(theta : Float) : RicciTensor {
    let sinTheta2 = Float.sin(theta) * Float.sin(theta);
    
    // R_θθ = 1, R_φφ = sin²(θ)
    let Ric = [
      [1.0, 0.0],
      [0.0, sinTheta2]
    ];
    
    // R = 2 (constant positive curvature)
    { R = Ric; scalar = 2.0; dimension = 2 }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     GAUSSIAN AND MEAN CURVATURE                        ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  // Gaussian curvature K = det(shape operator) = R/2 for 2D surfaces
  public func gaussianCurvature(ricci : RicciTensor) : Float {
    ricci.scalar / 2.0
  };

  // Principal curvatures from shape operator
  public type PrincipalCurvatures = {
    k1 : Float;
    k2 : Float;
    gaussian : Float;  // K = k1 * k2
    mean : Float;      // H = (k1 + k2) / 2
  };

  // Compute principal curvatures from shape operator (second fundamental form)
  public func computePrincipalCurvatures(shapeOperator : [[Float]]) : PrincipalCurvatures {
    // For 2x2 shape operator S, eigenvalues are principal curvatures
    let a = shapeOperator[0][0];
    let b = shapeOperator[0][1];
    let c = shapeOperator[1][0];
    let d = shapeOperator[1][1];
    
    let trace = a + d;
    let det = a * d - b * c;
    let disc = trace * trace - 4.0 * det;
    
    let sqrtDisc = if (disc >= 0.0) { Float.sqrt(disc) } else { 0.0 };
    
    let k1 = (trace + sqrtDisc) / 2.0;
    let k2 = (trace - sqrtDisc) / 2.0;
    
    {
      k1 = k1;
      k2 = k2;
      gaussian = k1 * k2;
      mean = (k1 + k2) / 2.0;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     GEODESIC EQUATIONS                                 ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public type GeodesicState = {
    position : [Float];
    velocity : [Float];
  };

  // Geodesic equation: d²x^μ/dτ² + Γ^μ_νρ dx^ν/dτ dx^ρ/dτ = 0
  public func geodesicDerivative(state : GeodesicState, christoffel : ChristoffelSymbols) : GeodesicState {
    let n = christoffel.dimension;
    let x = state.position;
    let v = state.velocity;
    
    // dx/dτ = v
    let dxdt = v;
    
    // dv^μ/dτ = -Γ^μ_νρ v^ν v^ρ
    let dvdt = Array.tabulate<Float>(n, func(mu : Nat) : Float {
      var sum : Float = 0.0;
      for (nu in Iter.range(0, n - 1)) {
        for (rho in Iter.range(0, n - 1)) {
          sum += christoffel.gamma[mu][nu][rho] * v[nu] * v[rho];
        };
      };
      -sum
    });
    
    { position = dxdt; velocity = dvdt }
  };

  // Integrate geodesic using RK4
  public func integrateGeodesic(
    initial : GeodesicState,
    christoffelFunc : ([Float]) -> ChristoffelSymbols,
    dt : Float,
    steps : Nat
  ) : [GeodesicState] {
    let trajectory = Buffer.Buffer<GeodesicState>(steps + 1);
    trajectory.add(initial);
    
    var state = initial;
    
    for (_step in Iter.range(0, steps - 1)) {
      // RK4 integration
      let chris = christoffelFunc(state.position);
      
      let k1 = geodesicDerivative(state, chris);
      
      let state2 : GeodesicState = {
        position = addVectors(state.position, scaleVector(k1.position, dt / 2.0));
        velocity = addVectors(state.velocity, scaleVector(k1.velocity, dt / 2.0));
      };
      let chris2 = christoffelFunc(state2.position);
      let k2 = geodesicDerivative(state2, chris2);
      
      let state3 : GeodesicState = {
        position = addVectors(state.position, scaleVector(k2.position, dt / 2.0));
        velocity = addVectors(state.velocity, scaleVector(k2.velocity, dt / 2.0));
      };
      let chris3 = christoffelFunc(state3.position);
      let k3 = geodesicDerivative(state3, chris3);
      
      let state4 : GeodesicState = {
        position = addVectors(state.position, scaleVector(k3.position, dt));
        velocity = addVectors(state.velocity, scaleVector(k3.velocity, dt));
      };
      let chris4 = christoffelFunc(state4.position);
      let k4 = geodesicDerivative(state4, chris4);
      
      // Combine
      let newPos = Array.tabulate<Float>(state.position.size(), func(i : Nat) : Float {
        state.position[i] + (dt / 6.0) * (k1.position[i] + 2.0 * k2.position[i] + 2.0 * k3.position[i] + k4.position[i])
      });
      
      let newVel = Array.tabulate<Float>(state.velocity.size(), func(i : Nat) : Float {
        state.velocity[i] + (dt / 6.0) * (k1.velocity[i] + 2.0 * k2.velocity[i] + 2.0 * k3.velocity[i] + k4.velocity[i])
      });
      
      state := { position = newPos; velocity = newVel };
      trajectory.add(state);
    };
    
    Buffer.toArray(trajectory)
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     COVARIANT DERIVATIVE                               ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  // Covariant derivative of vector field: ∇_μ V^ν = ∂_μ V^ν + Γ^ν_μλ V^λ
  public func covariantDerivativeVector(
    vectorField : [[Float]],        // V^ν at each point
    partialDerivatives : [[[Float]]], // ∂_μ V^ν at each point, indexed [point][μ][ν]
    christoffelAtPoints : [ChristoffelSymbols]
  ) : [[[Float]]] {  // ∇_μ V^ν at each point
    let numPoints = vectorField.size();
    
    Array.tabulate<[[Float]]>(numPoints, func(p : Nat) : [[Float]] {
      let n = christoffelAtPoints[p].dimension;
      let V = vectorField[p];
      let dV = partialDerivatives[p];
      let gamma = christoffelAtPoints[p].gamma;
      
      Array.tabulate<[Float]>(n, func(mu : Nat) : [Float] {
        Array.tabulate<Float>(n, func(nu : Nat) : Float {
          var result = dV[mu][nu];
          for (lambda in Iter.range(0, n - 1)) {
            result += gamma[nu][mu][lambda] * V[lambda];
          };
          result
        })
      })
    })
  };

  // Covariant derivative of covector: ∇_μ ω_ν = ∂_μ ω_ν - Γ^λ_μν ω_λ
  public func covariantDerivativeCovector(
    covector : [Float],
    partialDerivatives : [[Float]],  // ∂_μ ω_ν
    christoffel : ChristoffelSymbols
  ) : [[Float]] {
    let n = christoffel.dimension;
    let gamma = christoffel.gamma;
    
    Array.tabulate<[Float]>(n, func(mu : Nat) : [Float] {
      Array.tabulate<Float>(n, func(nu : Nat) : Float {
        var result = partialDerivatives[mu][nu];
        for (lambda in Iter.range(0, n - 1)) {
          result -= gamma[lambda][mu][nu] * covector[lambda];
        };
        result
      })
    })
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     LIE DERIVATIVE                                     ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  // Lie derivative of function: L_X f = X^μ ∂_μ f
  public func lieDerivativeFunction(
    X : [Float],           // Vector field X^μ
    gradF : [Float]        // ∂_μ f
  ) : Float {
    var sum : Float = 0.0;
    for (mu in Iter.range(0, X.size() - 1)) {
      sum += X[mu] * gradF[mu];
    };
    sum
  };

  // Lie derivative of vector: L_X Y^μ = X^ν ∂_ν Y^μ - Y^ν ∂_ν X^μ
  public func lieDerivativeVector(
    X : [Float],
    Y : [Float],
    dX : [[Float]],  // ∂_ν X^μ
    dY : [[Float]]   // ∂_ν Y^μ
  ) : [Float] {
    let n = X.size();
    
    Array.tabulate<Float>(n, func(mu : Nat) : Float {
      var sum : Float = 0.0;
      for (nu in Iter.range(0, n - 1)) {
        sum += X[nu] * dY[nu][mu] - Y[nu] * dX[nu][mu];
      };
      sum
    })
  };

  // Lie bracket [X, Y] = L_X Y
  public func lieBracket(
    X : [Float],
    Y : [Float],
    dX : [[Float]],
    dY : [[Float]]
  ) : [Float] {
    lieDerivativeVector(X, Y, dX, dY)
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     DIFFERENTIAL FORMS                                 ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public type DifferentialForm = {
    degree : Nat;
    components : [Float];  // Antisymmetric tensor components
    dimension : Nat;
  };

  // 0-form (scalar function)
  public func form0(value : Float) : DifferentialForm {
    { degree = 0; components = [value]; dimension = 1 }
  };

  // 1-form from components ω = ω_μ dx^μ
  public func form1(components : [Float]) : DifferentialForm {
    { degree = 1; components = components; dimension = components.size() }
  };

  // 2-form from antisymmetric components ω = ω_μν dx^μ ∧ dx^ν
  public func form2(components : [[Float]], n : Nat) : DifferentialForm {
    // Flatten to upper triangular (antisymmetric)
    let numComponents = n * (n - 1) / 2;
    let flat = Buffer.Buffer<Float>(numComponents);
    
    for (i in Iter.range(0, n - 1)) {
      for (j in Iter.range(i + 1, n - 1)) {
        flat.add(components[i][j]);
      };
    };
    
    { degree = 2; components = Buffer.toArray(flat); dimension = n }
  };

  // Exterior derivative d: Ω^k → Ω^(k+1)
  public func exteriorDerivative(form : DifferentialForm, partials : [[Float]]) : DifferentialForm {
    let n = form.dimension;
    
    switch (form.degree) {
      case (0) {
        // df = ∂_μ f dx^μ
        { degree = 1; components = partials[0]; dimension = n }
      };
      case (1) {
        // dω = (∂_μ ω_ν - ∂_ν ω_μ) dx^μ ∧ dx^ν
        let numComponents = n * (n - 1) / 2;
        let components = Buffer.Buffer<Float>(numComponents);
        
        for (mu in Iter.range(0, n - 1)) {
          for (nu in Iter.range(mu + 1, n - 1)) {
            let comp = partials[mu][nu] - partials[nu][mu];
            components.add(comp);
          };
        };
        
        { degree = 2; components = Buffer.toArray(components); dimension = n }
      };
      case (_) {
        // Higher degree forms
        form  // Simplified: return unchanged
      };
    }
  };

  // Wedge product: α ∧ β
  public func wedgeProduct(alpha : DifferentialForm, beta : DifferentialForm) : DifferentialForm {
    let newDegree = alpha.degree + beta.degree;
    
    if (alpha.degree == 1 and beta.degree == 1) {
      // ω ∧ η = ω_μ η_ν dx^μ ∧ dx^ν
      let n = alpha.dimension;
      let numComponents = n * (n - 1) / 2;
      let components = Buffer.Buffer<Float>(numComponents);
      
      for (mu in Iter.range(0, n - 1)) {
        for (nu in Iter.range(mu + 1, n - 1)) {
          let comp = alpha.components[mu] * beta.components[nu] - 
                     alpha.components[nu] * beta.components[mu];
          components.add(comp);
        };
      };
      
      { degree = 2; components = Buffer.toArray(components); dimension = n }
    } else {
      // Generic case
      { degree = newDegree; components = []; dimension = alpha.dimension }
    }
  };

  // Interior product: ι_X ω
  public func interiorProduct(X : [Float], form : DifferentialForm) : DifferentialForm {
    switch (form.degree) {
      case (0) {
        // ι_X f = 0
        { degree = 0; components = [0.0]; dimension = form.dimension }
      };
      case (1) {
        // ι_X ω = X^μ ω_μ (scalar)
        var sum : Float = 0.0;
        for (mu in Iter.range(0, X.size() - 1)) {
          sum += X[mu] * form.components[mu];
        };
        { degree = 0; components = [sum]; dimension = form.dimension }
      };
      case (2) {
        // ι_X ω = X^μ ω_μν dx^ν
        let n = form.dimension;
        let components = Array.tabulate<Float>(n, func(nu : Nat) : Float {
          var sum : Float = 0.0;
          // Reconstruct antisymmetric tensor
          var idx : Nat = 0;
          for (mu in Iter.range(0, n - 1)) {
            for (rho in Iter.range(mu + 1, n - 1)) {
              if (rho == nu) {
                sum += X[mu] * form.components[idx];
              } else if (mu == nu) {
                sum -= X[rho] * form.components[idx];
              };
              idx += 1;
            };
          };
          sum
        });
        { degree = 1; components = components; dimension = n }
      };
      case (_) {
        { degree = form.degree - 1; components = []; dimension = form.dimension }
      };
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     CARTAN STRUCTURE EQUATIONS                         ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public type CartanConnection = {
    connectionForms : [[Float]];   // ω^i_j (matrix of 1-forms)
    torsionForms : [[Float]];      // T^i = de^i + ω^i_j ∧ e^j
    curvatureForms : [[Float]];    // Ω^i_j = dω^i_j + ω^i_k ∧ ω^k_j
  };

  // First Cartan structure equation: T^i = de^i + ω^i_j ∧ e^j
  public func computeTorsion(
    coframe : [[Float]],           // e^i (basis 1-forms)
    dCoframe : [[[Float]]],        // de^i (exterior derivatives)
    connectionForms : [[[Float]]]  // ω^i_j
  ) : [[Float]] {
    let n = coframe.size();
    
    Array.tabulate<[Float]>(n, func(i : Nat) : [Float] {
      Array.tabulate<Float>(n, func(mu : Nat) : Float {
        var sum = dCoframe[i][mu][mu];  // de^i component
        for (j in Iter.range(0, n - 1)) {
          sum += connectionForms[i][j][mu] * coframe[j][mu];
        };
        sum
      })
    })
  };

  // Second Cartan structure equation: Ω^i_j = dω^i_j + ω^i_k ∧ ω^k_j
  public func computeCurvatureForm(
    connectionForms : [[[Float]]],
    dConnectionForms : [[[[Float]]]]
  ) : [[[Float]]] {
    let n = connectionForms.size();
    
    Array.tabulate<[[Float]]>(n, func(i : Nat) : [[Float]] {
      Array.tabulate<[Float]>(n, func(j : Nat) : [Float] {
        Array.tabulate<Float>(n, func(mu : Nat) : Float {
          var sum = dConnectionForms[i][j][mu][mu];
          for (k in Iter.range(0, n - 1)) {
            sum += connectionForms[i][k][mu] * connectionForms[k][j][mu];
          };
          sum
        })
      })
    })
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     GAUSS-BONNET THEOREM                               ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  // For 2D surface: ∫∫ K dA + ∫ κ_g ds = 2π χ
  // Where K = Gaussian curvature, κ_g = geodesic curvature, χ = Euler characteristic

  public func gaussBonnetIntegral(
    gaussianCurvatures : [Float],  // K at sample points
    areas : [Float],               // Area elements
    boundaryGeodesicCurvatures : [Float],
    boundaryLengths : [Float]
  ) : Float {
    // ∫∫ K dA
    var areaIntegral : Float = 0.0;
    for (i in Iter.range(0, gaussianCurvatures.size() - 1)) {
      areaIntegral += gaussianCurvatures[i] * areas[i];
    };
    
    // ∫ κ_g ds
    var boundaryIntegral : Float = 0.0;
    for (i in Iter.range(0, boundaryGeodesicCurvatures.size() - 1)) {
      boundaryIntegral += boundaryGeodesicCurvatures[i] * boundaryLengths[i];
    };
    
    areaIntegral + boundaryIntegral
  };

  // Compute Euler characteristic from Gauss-Bonnet
  public func eulerCharacteristicFromCurvature(gaussBonnetValue : Float) : Int {
    let chi = gaussBonnetValue / τ;
    Int.abs(Float.toInt(chi + 0.5))  // Round to nearest integer
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     PARALLEL TRANSPORT                                 ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  // Parallel transport equation: DV^μ/dτ = dV^μ/dτ + Γ^μ_νρ V^ν dx^ρ/dτ = 0
  public func parallelTransportStep(
    vector : [Float],
    velocity : [Float],
    christoffel : ChristoffelSymbols,
    dt : Float
  ) : [Float] {
    let n = christoffel.dimension;
    let gamma = christoffel.gamma;
    
    // dV^μ/dτ = -Γ^μ_νρ V^ν (dx^ρ/dτ)
    let dV = Array.tabulate<Float>(n, func(mu : Nat) : Float {
      var sum : Float = 0.0;
      for (nu in Iter.range(0, n - 1)) {
        for (rho in Iter.range(0, n - 1)) {
          sum += gamma[mu][nu][rho] * vector[nu] * velocity[rho];
        };
      };
      -sum
    });
    
    // Euler step
    Array.tabulate<Float>(n, func(mu : Nat) : Float {
      vector[mu] + dV[mu] * dt
    })
  };

  // Parallel transport along a curve
  public func parallelTransportAlongCurve(
    initialVector : [Float],
    curve : [GeodesicState],
    christoffelFunc : ([Float]) -> ChristoffelSymbols
  ) : [[Float]] {
    let trajectory = Buffer.Buffer<[Float]>(curve.size());
    trajectory.add(initialVector);
    
    var vector = initialVector;
    
    for (i in Iter.range(0, curve.size() - 2)) {
      let chris = christoffelFunc(curve[i].position);
      let dt = 1.0 / Float.fromInt(curve.size());
      
      vector := parallelTransportStep(vector, curve[i].velocity, chris, dt);
      trajectory.add(vector);
    };
    
    Buffer.toArray(trajectory)
  };

  // Holonomy: rotation after parallel transport around closed loop
  public func computeHolonomyMatrix(
    loop : [GeodesicState],
    christoffelFunc : ([Float]) -> ChristoffelSymbols
  ) : [[Float]] {
    let n = loop[0].position.size();
    
    // Transport each basis vector
    let holonomy = Array.tabulate<[Float]>(n, func(i : Nat) : [Float] {
      var basis = Array.tabulate<Float>(n, func(j : Nat) : Float {
        if (i == j) { 1.0 } else { 0.0 }
      });
      
      let transported = parallelTransportAlongCurve(basis, loop, christoffelFunc);
      transported[transported.size() - 1]
    });
    
    holonomy
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     EXPONENTIAL MAP                                    ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  // Exponential map: exp_p(v) follows geodesic from p with initial velocity v
  public func exponentialMap(
    basePoint : [Float],
    tangentVector : [Float],
    christoffelFunc : ([Float]) -> ChristoffelSymbols,
    t : Float,
    steps : Nat
  ) : [Float] {
    let initial : GeodesicState = {
      position = basePoint;
      velocity = tangentVector;
    };
    
    let dt = t / Float.fromInt(steps);
    let trajectory = integrateGeodesic(initial, christoffelFunc, dt, steps);
    
    trajectory[steps].position
  };

  // Logarithmic map (inverse of exponential): log_p(q) = v such that exp_p(v) = q
  // Uses iterative method
  public func logarithmicMap(
    basePoint : [Float],
    targetPoint : [Float],
    christoffelFunc : ([Float]) -> ChristoffelSymbols,
    maxIter : Nat,
    tol : Float
  ) : [Float] {
    let n = basePoint.size();
    
    // Initial guess: straight line in coordinate space
    var v = Array.tabulate<Float>(n, func(i : Nat) : Float {
      targetPoint[i] - basePoint[i]
    });
    
    for (_iter in Iter.range(0, maxIter - 1)) {
      let result = exponentialMap(basePoint, v, christoffelFunc, 1.0, 20);
      
      // Error
      var error : Float = 0.0;
      for (i in Iter.range(0, n - 1)) {
        let diff = result[i] - targetPoint[i];
        error += diff * diff;
      };
      
      if (Float.sqrt(error) < tol) {
        return v;
      };
      
      // Update (gradient descent step)
      v := Array.tabulate<Float>(n, func(i : Nat) : Float {
        v[i] + 0.5 * (targetPoint[i] - result[i])
      });
    };
    
    v
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     KILLING VECTOR FIELDS                              ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  // Killing equation: ∇_μ X_ν + ∇_ν X_μ = 0
  // X is a Killing vector if the Lie derivative of the metric vanishes

  public func killingEquationResidual(
    X : [Float],
    metric : MetricTensor,
    covariantDerivX : [[Float]]  // ∇_μ X_ν
  ) : [[Float]] {
    let n = metric.dimension;
    
    Array.tabulate<[Float]>(n, func(mu : Nat) : [Float] {
      Array.tabulate<Float>(n, func(nu : Nat) : Float {
        covariantDerivX[mu][nu] + covariantDerivX[nu][mu]
      })
    })
  };

  // Check if vector field is approximately Killing
  public func isKillingField(residual : [[Float]], tol : Float) : Bool {
    var maxResidual : Float = 0.0;
    for (row in residual.vals()) {
      for (val in row.vals()) {
        if (Float.abs(val) > maxResidual) {
          maxResidual := Float.abs(val);
        };
      };
    };
    maxResidual < tol
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     WEYL TENSOR                                        ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  // Weyl tensor (trace-free part of Riemann) - measures conformal curvature
  // C^ρ_σμν = R^ρ_σμν - (terms involving Ricci)
  public func computeWeyl(
    riemann : RiemannTensor,
    ricci : RicciTensor,
    metric : MetricTensor
  ) : [[[[Float]]]] {
    let n = riemann.dimension;
    let R = ricci.scalar;
    
    Array.tabulate<[[[Float]]]>(n, func(rho : Nat) : [[[Float]]] {
      Array.tabulate<[[Float]]>(n, func(sigma : Nat) : [[Float]] {
        Array.tabulate<[Float]>(n, func(mu : Nat) : [Float] {
          Array.tabulate<Float>(n, func(nu : Nat) : Float {
            // C^ρ_σμν = R^ρ_σμν 
            //   + 1/(n-2) (δ^ρ_μ R_σν - δ^ρ_ν R_σμ + g_σν R^ρ_μ - g_σμ R^ρ_ν)
            //   + R/((n-1)(n-2)) (δ^ρ_ν g_σμ - δ^ρ_μ g_σν)
            
            var result = riemann.R[rho][sigma][mu][nu];
            
            let factor1 = 1.0 / Float.fromInt(n - 2);
            let factor2 = R / Float.fromInt((n - 1) * (n - 2));
            
            // δ^ρ_μ term
            if (rho == mu) {
              result += factor1 * ricci.R[sigma][nu];
            };
            // δ^ρ_ν term
            if (rho == nu) {
              result -= factor1 * ricci.R[sigma][mu];
            };
            
            // Metric terms (using inverse metric to raise index)
            for (alpha in Iter.range(0, n - 1)) {
              result += factor1 * metric.g[sigma][nu] * metric.gInverse[rho][alpha] * ricci.R[alpha][mu];
              result -= factor1 * metric.g[sigma][mu] * metric.gInverse[rho][alpha] * ricci.R[alpha][nu];
            };
            
            // Scalar curvature terms
            if (rho == nu) {
              result += factor2 * metric.g[sigma][mu];
            };
            if (rho == mu) {
              result -= factor2 * metric.g[sigma][nu];
            };
            
            result
          })
        })
      })
    })
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     SECTIONAL CURVATURE                                ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  // Sectional curvature K(X,Y) = R(X,Y,X,Y) / (|X|²|Y|² - <X,Y>²)
  public func sectionalCurvature(
    X : [Float],
    Y : [Float],
    riemann : RiemannTensor,
    metric : MetricTensor
  ) : Float {
    let n = metric.dimension;
    
    // R(X,Y,X,Y) = R_ρσμν X^ρ Y^σ X^μ Y^ν
    var numerator : Float = 0.0;
    for (rho in Iter.range(0, n - 1)) {
      for (sigma in Iter.range(0, n - 1)) {
        for (mu in Iter.range(0, n - 1)) {
          for (nu in Iter.range(0, n - 1)) {
            // Lower first index
            var Rdown : Float = 0.0;
            for (alpha in Iter.range(0, n - 1)) {
              Rdown += metric.g[rho][alpha] * riemann.R[alpha][sigma][mu][nu];
            };
            numerator += Rdown * X[rho] * Y[sigma] * X[mu] * Y[nu];
          };
        };
      };
    };
    
    // |X|² = g_μν X^μ X^ν
    var Xnorm2 : Float = 0.0;
    var Ynorm2 : Float = 0.0;
    var XdotY : Float = 0.0;
    for (mu in Iter.range(0, n - 1)) {
      for (nu in Iter.range(0, n - 1)) {
        Xnorm2 += metric.g[mu][nu] * X[mu] * X[nu];
        Ynorm2 += metric.g[mu][nu] * Y[mu] * Y[nu];
        XdotY += metric.g[mu][nu] * X[mu] * Y[nu];
      };
    };
    
    let denominator = Xnorm2 * Ynorm2 - XdotY * XdotY;
    
    if (Float.abs(denominator) < 1e-10) { 0.0 } else { numerator / denominator }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     HELPER FUNCTIONS                                   ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  func addVectors(a : [Float], b : [Float]) : [Float] {
    Array.tabulate<Float>(a.size(), func(i : Nat) : Float { a[i] + b[i] })
  };

  func scaleVector(v : [Float], s : Float) : [Float] {
    Array.tabulate<Float>(v.size(), func(i : Nat) : Float { v[i] * s })
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

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     ENGINE RESPONSIBILITIES                            ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public type DiffGeoResponsibility = {
    #CurvatureComputation;
    #GeodesicCalculation;
    #ParallelTransport;
    #ConnectionTheory;
    #FormIntegration;
    #TopologyDetection;
    #MetricAnalysis;
  };

  public type DiffGeoEngine = {
    id : Nat;
    responsibilities : [DiffGeoResponsibility];
    currentMetric : ?MetricTensor;
    currentChristoffel : ?ChristoffelSymbols;
    currentRiemann : ?RiemannTensor;
    currentRicci : ?RicciTensor;
    state : DiffGeoState;
  };

  public type DiffGeoState = {
    position : [Float];
    tangent : [Float];
    energy : Float;
    coherence : Float;
  };

  // Create engine with all responsibilities
  public func createDiffGeoEngine(id : Nat) : DiffGeoEngine {
    {
      id = id;
      responsibilities = [
        #CurvatureComputation,
        #GeodesicCalculation,
        #ParallelTransport,
        #ConnectionTheory,
        #FormIntegration,
        #TopologyDetection,
        #MetricAnalysis
      ];
      currentMetric = null;
      currentChristoffel = null;
      currentRiemann = null;
      currentRicci = null;
      state = {
        position = [0.0, 0.0];
        tangent = [1.0, 0.0];
        energy = 1.0;
        coherence = 1.0;
      };
    }
  };

  // Execute all responsibilities
  public func executeResponsibilities(
    engine : DiffGeoEngine,
    point : [Float],
    direction : [Float]
  ) : DiffGeoEngine {
    var updatedEngine = engine;
    
    for (resp in engine.responsibilities.vals()) {
      updatedEngine := executeResponsibility(updatedEngine, resp, point, direction);
    };
    
    updatedEngine
  };

  func executeResponsibility(
    engine : DiffGeoEngine,
    resp : DiffGeoResponsibility,
    point : [Float],
    direction : [Float]
  ) : DiffGeoEngine {
    switch (resp) {
      case (#CurvatureComputation) {
        // Compute curvature at point
        let theta = if (point.size() >= 2) { point[0] } else { π / 2.0 };
        let metric = unitSphereMetric(theta);
        let chris = sphereChristoffel(theta);
        let riemann = sphereRiemann(theta);
        let ricci = sphereRicci(theta);
        
        {
          id = engine.id;
          responsibilities = engine.responsibilities;
          currentMetric = ?metric;
          currentChristoffel = ?chris;
          currentRiemann = ?riemann;
          currentRicci = ?ricci;
          state = engine.state;
        }
      };
      case (#GeodesicCalculation) {
        engine  // Would integrate geodesic
      };
      case (#ParallelTransport) {
        engine  // Would transport vectors
      };
      case (#ConnectionTheory) {
        engine  // Would analyze connection
      };
      case (#FormIntegration) {
        engine  // Would integrate forms
      };
      case (#TopologyDetection) {
        engine  // Would detect topology
      };
      case (#MetricAnalysis) {
        engine  // Would analyze metric
      };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════
  // ║                                                                                                 ║
  // ║  SECTION II: DEEP INTERWEAVING — GEOMETRY AS ORGANISM SUBSTRATE CONNECTOR                      ║
  // ║  Geometry is the language of space; all engines live in geometric space.                       ║
  // ║  Alfredo Medina Hernandez | MedinaSITech@outlook.com | Dallas, Texas | 2026                   ║
  // ║                                                                                                 ║
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // GEOMETRY ↔ KURAMOTO COUPLING — Phase space geometry
  // Oscillator phases live on S¹; coupling defines metric on phase space
  // ─────────────────────────────────────────────────────────────────────────────

  public type KuramotoGeometryCoupling = {
    // From Kuramoto
    phases: [Float];                    // θ_i on circle S¹
    couplingMatrix: [[Float]];          // K_ij defines metric structure
    orderParameter: Float;              // r determines geometry
    
    // Phase space geometry
    phaseSpaceMetric: [[Float]];        // g_ij on T^N (N-torus)
    phaseSpaceChristoffel: [[[Float]]]; // Connection on torus
    phaseSpaceCurvature: Float;         // Scalar curvature of phase space
    
    // Geodesics in phase space
    synchronizationGeodesic: [[Float]]; // Path to sync (geodesic)
    geodesicLength: Float;              // Distance to synchronization
    
    // Geometric order parameter
    geometricOrderParameter: Float;     // r as curvature-weighted measure
    
    // Bidirectional coupling
    geometryToKuramotoCoupling: [[Float]]; // Metric determines coupling
    kuramotoToGeometryCurvature: Float;    // Sync affects curvature
  };

  /// Compute phase space metric from coupling
  /// g_ij = δ_ij + K_ij (coupling modifies flat metric)
  public func computePhaseSpaceMetric(couplingMatrix: [[Float]]) : [[Float]] {
    let n = couplingMatrix.size();
    Array.tabulate<[Float]>(n, func(i) {
      let row = if (i < couplingMatrix.size()) { couplingMatrix[i] } else { [] };
      Array.tabulate<Float>(n, func(j) {
        let kij = if (j < row.size()) { row[j] } else { 0.0 };
        let delta = if (i == j) { 1.0 } else { 0.0 };
        delta + 0.1 * kij // Small perturbation from flat
      })
    })
  };

  /// Compute geodesic distance in phase space
  public func computePhaseSpaceGeodesicDistance(
    phase1: [Float],
    phase2: [Float],
    metric: [[Float]]
  ) : Float {
    var distSq : Float = 0.0;
    var i = 0;
    for (p1 in phase1.vals()) {
      var j = 0;
      for (p2 in phase2.vals()) {
        let dp1 = if (i < phase1.size() and i < phase2.size()) { phase1[i] - phase2[i] } else { 0.0 };
        let dp2 = if (j < phase1.size() and j < phase2.size()) { phase1[j] - phase2[j] } else { 0.0 };
        let gij = if (i < metric.size() and j < metric[i].size()) { metric[i][j] } else {
          if (i == j) { 1.0 } else { 0.0 }
        };
        distSq += gij * dp1 * dp2;
        j += 1;
      };
      i += 1;
    };
    Float.sqrt(Float.abs(distSq))
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // GEOMETRY ↔ FRISTON COUPLING — Information geometry
  // Belief space has natural Fisher-Rao metric; free energy is geometric
  // ─────────────────────────────────────────────────────────────────────────────

  public type FristonGeometryCoupling = {
    // From Friston
    beliefs: [Float];                   // q(x) on probability simplex
    precision: Float;                   // π - Inverse variance
    
    // Information geometry
    fisherRaoMetric: [[Float]];         // I_ij - Fisher information metric
    amariChentsovConnection: [[[Float]]]; // α-connection family
    informationCurvature: Float;        // Curvature of statistical manifold
    
    // Free energy landscape geometry
    freeEnergyGradient: [Float];        // ∇F - Gradient in belief space
    freeEnergyHessian: [[Float]];       // ∇²F - Hessian (local curvature)
    naturalGradient: [Float];           // g^(-1) · ∇F
    
    // Geodesics in belief space
    inferenceGeodesic: [[Float]];       // Natural gradient path
    beliefSpaceVolume: Float;           // √det(g) - Volume element
    
    // Bidirectional coupling
    geometryToInferencePath: [[Float]]; // Metric determines inference
    inferenceToGeometryDeformation: Float; // Learning deforms metric
  };

  /// Compute Fisher-Rao metric
  /// I_ij = E[(∂ln p/∂θ_i)(∂ln p/∂θ_j)]
  public func computeFisherRaoMetric(probabilities: [Float]) : [[Float]] {
    let n = probabilities.size();
    // For categorical distribution: I_ij = δ_ij/p_i
    Array.tabulate<[Float]>(n, func(i) {
      Array.tabulate<Float>(n, func(j) {
        if (i == j) {
          let pi = if (i < probabilities.size()) { probabilities[i] } else { 1e-10 };
          if (pi < 1e-10) { 1e10 } else { 1.0 / pi }
        } else { 0.0 }
      })
    })
  };

  /// Compute natural gradient
  /// ∇̃F = g^(-1) · ∇F
  public func computeNaturalGradient(
    gradient: [Float],
    inverseMetric: [[Float]]
  ) : [Float] {
    let n = gradient.size();
    Array.tabulate<Float>(n, func(i) {
      var sum : Float = 0.0;
      var j = 0;
      for (gj in gradient.vals()) {
        let gInvIJ = if (i < inverseMetric.size() and j < inverseMetric[i].size()) {
          inverseMetric[i][j]
        } else {
          if (i == j) { 1.0 } else { 0.0 }
        };
        sum += gInvIJ * gj;
        j += 1;
      };
      sum
    })
  };

  /// Compute belief space volume element √det(g)
  public func computeBeliefSpaceVolume(metric: [[Float]]) : Float {
    // For 2x2: det = ad - bc
    let n = metric.size();
    if (n == 0) { return 0.0 };
    if (n == 1) {
      let g00 = if (metric[0].size() > 0) { metric[0][0] } else { 1.0 };
      return Float.sqrt(Float.abs(g00))
    };
    if (n == 2) {
      let a = if (metric[0].size() > 0) { metric[0][0] } else { 1.0 };
      let b = if (metric[0].size() > 1) { metric[0][1] } else { 0.0 };
      let c = if (metric[1].size() > 0) { metric[1][0] } else { 0.0 };
      let d = if (metric[1].size() > 1) { metric[1][1] } else { 1.0 };
      return Float.sqrt(Float.abs(a * d - b * c))
    };
    // Larger: product of diagonal (approximation)
    var prod : Float = 1.0;
    var i = 0;
    for (row in metric.vals()) {
      let gii = if (i < row.size()) { row[i] } else { 1.0 };
      prod *= Float.abs(gii);
      i += 1;
    };
    Float.sqrt(prod)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // GEOMETRY ↔ HEBBIAN COUPLING — Weight space geometry
  // Synaptic weights form a manifold; learning is geodesic flow
  // ─────────────────────────────────────────────────────────────────────────────

  public type HebbianGeometryCoupling = {
    // From Hebbian
    weights: [[Float]];                 // W_ij - Synaptic weights
    learningRate: Float;                // η
    
    // Weight space geometry
    weightSpaceMetric: [[Float]];       // Metric on weight manifold
    weightSpaceConnection: [[[Float]]]; // Connection/Christoffel
    weightSpaceCurvature: [[Float]];    // Ricci tensor of weight space
    
    // Learning trajectory geometry
    learningVelocity: [[Float]];        // dW/dt - Velocity in weight space
    learningAcceleration: [[Float]];    // d²W/dt² - Acceleration
    trajectoryGeodesicDeviation: Float; // How far from geodesic
    
    // Loss landscape geometry
    lossGradient: [[Float]];            // ∇L - Loss gradient
    lossHessian: [[[[Float]]]];         // ∇²L - Loss Hessian
    saddlePointIndex: Nat;              // Number of negative eigenvalues
    
    // Bidirectional coupling
    geometryToLearningPath: [[Float]];  // Metric constrains learning
    learningToGeometryAdaptation: Float; // Learning adapts metric
  };

  /// Compute weight space metric (Euclidean in flat case)
  public func computeWeightSpaceMetric(weights: [[Float]]) : [[Float]] {
    // Flatten weights and compute identity metric
    var totalSize = 0;
    for (row in weights.vals()) {
      totalSize += row.size();
    };
    // Identity metric
    Array.tabulate<[Float]>(totalSize, func(i) {
      Array.tabulate<Float>(totalSize, func(j) {
        if (i == j) { 1.0 } else { 0.0 }
      })
    })
  };

  /// Check if learning trajectory is geodesic
  /// Geodesic: d²x^μ/dt² + Γ^μ_νρ dx^ν/dt dx^ρ/dt = 0
  public func computeGeodesicDeviation(
    acceleration: [[Float]],
    velocity: [[Float]],
    christoffel: [[[Float]]]
  ) : Float {
    // Simplified: check if acceleration is small relative to velocity
    var accNorm : Float = 0.0;
    var velNorm : Float = 0.0;
    
    for (row in acceleration.vals()) {
      for (val in row.vals()) {
        accNorm += val * val;
      };
    };
    for (row in velocity.vals()) {
      for (val in row.vals()) {
        velNorm += val * val;
      };
    };
    
    if (velNorm < 1e-10) { return 0.0 };
    Float.sqrt(accNorm) / Float.sqrt(velNorm)
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // GEOMETRY ↔ ATTRACTOR COUPLING — Basin geometry
  // Attractor basins have geometric structure; separatrices are geometric
  // ─────────────────────────────────────────────────────────────────────────────

  public type AttractorGeometryCoupling = {
    // From Attractor
    attractorPositions: [[Float]];      // Fixed points
    basinBoundaries: [[Float]];         // Separatrices
    
    // Basin geometry
    basinMetric: [[Float]];             // Metric within basin
    basinCurvature: Float;              // Average curvature
    basinVolume: Float;                 // Riemannian volume
    
    // Separatrix geometry
    separatrixNormal: [[Float]];        // Normal vectors to separatrix
    separatrixCurvature: Float;         // Mean curvature of separatrix
    
    // Geodesics to attractors
    attractorGeodesics: [[[Float]]];    // Geodesic paths to each attractor
    geodesicDistances: [Float];         // Distances to attractors
    
    // Bidirectional coupling
    geometryToBasinShape: [[Float]];    // Metric determines basin
    basinToGeometryDeformation: Float;  // Basin structure affects metric
  };

  /// Compute geodesic distance to nearest attractor
  public func computeDistanceToNearestAttractor(
    state: [Float],
    attractors: [[Float]],
    metric: [[Float]]
  ) : Float {
    var minDist : Float = 1e10;
    
    for (attractor in attractors.vals()) {
      var distSq : Float = 0.0;
      var i = 0;
      for (si in state.vals()) {
        var j = 0;
        for (sj in state.vals()) {
          let ai = if (i < attractor.size()) { attractor[i] } else { 0.0 };
          let aj = if (j < attractor.size()) { attractor[j] } else { 0.0 };
          let gij = if (i < metric.size() and j < metric[i].size()) {
            metric[i][j]
          } else {
            if (i == j) { 1.0 } else { 0.0 }
          };
          distSq += gij * (si - ai) * (sj - aj);
          j += 1;
        };
        i += 1;
      };
      let dist = Float.sqrt(Float.abs(distSq));
      if (dist < minDist) { minDist := dist };
    };
    minDist
  };

  /// Compute basin volume (approximate)
  public func computeBasinVolume(
    basinRadius: Float,
    dimension: Nat,
    metric: [[Float]]
  ) : Float {
    // V = V_Euclidean × √det(g)
    let volumeElement = computeBeliefSpaceVolume(metric);
    
    // Euclidean ball volume: V_n(r) = π^(n/2) r^n / Γ(n/2 + 1)
    let n = Float.fromInt(dimension);
    var euclideanVolume = Float.pow(π, n / 2.0);
    euclideanVolume *= Float.pow(basinRadius, n);
    // Approximate Γ(n/2 + 1) ≈ (n/2)!
    var gamma : Float = 1.0;
    var k = 1;
    while (Float.fromInt(k) < n / 2.0 + 1.0) {
      gamma *= Float.fromInt(k);
      k += 1;
    };
    euclideanVolume /= gamma;
    
    euclideanVolume * volumeElement
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // GEOMETRY ↔ PHYSICS COUPLING — General relativity
  // Physics is geometry: Einstein equation G_μν = 8πT_μν
  // ─────────────────────────────────────────────────────────────────────────────

  public type PhysicsGeometryCoupling = {
    // Spacetime geometry
    spacetimeMetric: [[Float]];         // g_μν - Metric tensor
    spacetimeConnection: [[[Float]]];   // Γ^λ_μν - Levi-Civita
    riemannCurvature: [[[[Float]]]];    // R^ρ_σμν
    ricciCurvature: [[Float]];          // R_μν
    ricciScalar: Float;                 // R
    einsteinTensor: [[Float]];          // G_μν = R_μν - (1/2)g_μν R
    
    // Matter coupling
    stressEnergyTensor: [[Float]];      // T_μν
    energyMomentumCurrent: [[Float]];   // J^μ
    
    // Geodesic motion
    geodesicEquation: [[Float]];        // d²x^μ/dτ² + Γ^μ_νρ u^ν u^ρ = 0
    fourVelocity: [Float];              // u^μ = dx^μ/dτ
    properTime: Float;                  // τ
    
    // Gravitational effects
    gravitationalPotential: Float;      // Newtonian limit
    tidalForces: [[Float]];             // Geodesic deviation
    
    // Bidirectional coupling
    geometryToGravity: [[Float]];       // Curvature is gravity
    matterToGeometry: [[Float]];        // Matter curves spacetime
  };

  /// Compute Einstein tensor
  /// G_μν = R_μν - (1/2)g_μν R
  public func computeEinsteinTensor(
    ricci: [[Float]],
    metric: [[Float]],
    ricciScalar: Float
  ) : [[Float]] {
    let n = ricci.size();
    Array.tabulate<[Float]>(n, func(mu) {
      let ricciRow = if (mu < ricci.size()) { ricci[mu] } else { [] };
      let metricRow = if (mu < metric.size()) { metric[mu] } else { [] };
      Array.tabulate<Float>(n, func(nu) {
        let rMuNu = if (nu < ricciRow.size()) { ricciRow[nu] } else { 0.0 };
        let gMuNu = if (nu < metricRow.size()) { metricRow[nu] } else {
          if (mu == nu) { 1.0 } else { 0.0 }
        };
        rMuNu - 0.5 * gMuNu * ricciScalar
      })
    })
  };

  /// Compute geodesic acceleration
  /// a^μ = -Γ^μ_νρ u^ν u^ρ
  public func computeGeodesicAcceleration(
    velocity: [Float],
    christoffel: [[[Float]]]
  ) : [Float] {
    let n = velocity.size();
    Array.tabulate<Float>(n, func(mu) {
      var acc : Float = 0.0;
      var nu = 0;
      for (uNu in velocity.vals()) {
        var rho = 0;
        for (uRho in velocity.vals()) {
          let gamma = if (mu < christoffel.size() and nu < christoffel[mu].size() and rho < christoffel[mu][nu].size()) {
            christoffel[mu][nu][rho]
          } else { 0.0 };
          acc -= gamma * uNu * uRho;
          rho += 1;
        };
        nu += 1;
      };
      acc
    })
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // UNIFIED GEOMETRY ORCHESTRATION — Master geometric state
  // ─────────────────────────────────────────────────────────────────────────────

  public type UnifiedGeometricState = {
    // Core metric
    fundamentalMetric: [[Float]];
    fundamentalConnection: [[[Float]]];
    fundamentalCurvature: [[Float]];
    scalarCurvature: Float;
    
    // Cross-engine geometries
    kuramotoCoupling: KuramotoGeometryCoupling;
    fristonCoupling: FristonGeometryCoupling;
    hebbianCoupling: HebbianGeometryCoupling;
    attractorCoupling: AttractorGeometryCoupling;
    physicsCoupling: PhysicsGeometryCoupling;
    
    // Global geometric measures
    totalVolume: Float;                 // ∫√det(g) dV
    averageCurvature: Float;            // Average scalar curvature
    geometricComplexity: Float;         // Measure of geometric complexity
    
    // Beat tracking
    currentBeat: Nat;
    lastGeometryUpdate: Nat;
  };

  /// Compute geometric complexity
  public func computeGeometricComplexity(state: UnifiedGeometricState) : Float {
    // Complexity ~ curvature × volume
    Float.abs(state.scalarCurvature) * state.totalVolume
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // CROSS-ENGINE INTERFACES — Connection points
  // ─────────────────────────────────────────────────────────────────────────────

  /// Receive Kuramoto update and compute geometric coupling
  public func receiveKuramotoUpdate(
    phases: [Float],
    coupling: [[Float]]
  ) : {
    phaseMetric: [[Float]];
    geodesicDistance: Float;
  } {
    let metric = computePhaseSpaceMetric(coupling);
    // Compute distance from current phases to synchronized state
    let syncPhases = Array.tabulate<Float>(phases.size(), func(_) { 0.0 });
    let dist = computePhaseSpaceGeodesicDistance(phases, syncPhases, metric);
    { phaseMetric = metric; geodesicDistance = dist }
  };

  /// Receive Friston update and compute geometric coupling
  public func receiveFristonUpdate(
    beliefs: [Float],
    gradient: [Float]
  ) : {
    fisherMetric: [[Float]];
    naturalGradient: [Float];
    volumeElement: Float;
  } {
    let metric = computeFisherRaoMetric(beliefs);
    // Inverse metric for natural gradient
    let invMetric = Array.tabulate<[Float]>(metric.size(), func(i) {
      Array.tabulate<Float>(metric.size(), func(j) {
        if (i == j and i < beliefs.size() and beliefs[i] > 1e-10) { beliefs[i] } else { 0.0 }
      })
    });
    let natGrad = computeNaturalGradient(gradient, invMetric);
    let vol = computeBeliefSpaceVolume(metric);
    { fisherMetric = metric; naturalGradient = natGrad; volumeElement = vol }
  };

  /// Send geometry update to other engines
  public func sendGeometryUpdate(state: UnifiedGeometricState) : {
    scalarCurvature: Float;
    totalVolume: Float;
    complexity: Float;
  } {
    {
      scalarCurvature = state.scalarCurvature;
      totalVolume = state.totalVolume;
      complexity = state.geometricComplexity;
    }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // MEDINA GEOMETRY DOCTRINE — Sovereign geometric laws
  // ─────────────────────────────────────────────────────────────────────────────

  public type MedinaGeometryDoctrine = {
    // Metric requirements
    metricSignature: [Int];             // Required signature
    metricPositiveDefinite: Bool;       // Must be positive definite?
    
    // Curvature bounds
    minScalarCurvature: Float;          // Minimum scalar curvature
    maxScalarCurvature: Float;          // Maximum scalar curvature
    
    // Volume bounds
    minVolume: Float;                   // Minimum total volume
    maxVolume: Float;                   // Maximum total volume
    
    // Sacred geometry
    goldenRatioCurvature: Float;        // φ-related curvature target
    
    // Compliance
    geometryComplianceScore: Float;
    violationCount: Nat;
  };

  /// Enforce Medina geometry doctrine
  public func enforceMedinaGeometry(
    scalarCurvature: Float,
    volume: Float,
    doctrine: MedinaGeometryDoctrine
  ) : (Bool, Float) {
    var compliance : Float = 1.0;
    var compliant = true;
    
    // Check curvature bounds
    if (scalarCurvature < doctrine.minScalarCurvature) {
      compliance *= 0.9;
      compliant := false;
    };
    if (scalarCurvature > doctrine.maxScalarCurvature) {
      compliance *= 0.9;
      compliant := false;
    };
    
    // Check volume bounds
    if (volume < doctrine.minVolume) {
      compliance *= 0.95;
    };
    if (volume > doctrine.maxVolume) {
      compliance *= 0.95;
    };
    
    (compliant, compliance)
  };

  /// Initialize Medina geometry doctrine
  public func initMedinaGeometryDoctrine() : MedinaGeometryDoctrine {
    {
      metricSignature = [1, 1, 1]; // Euclidean 3D
      metricPositiveDefinite = true;
      minScalarCurvature = -100.0;
      maxScalarCurvature = 100.0;
      minVolume = 0.0;
      maxVolume = 1e10;
      goldenRatioCurvature = φ;
      geometryComplianceScore = 1.0;
      violationCount = 0;
    }
  };

  // ─────────────────────────────────────────────────────────────────────────────
  // BEAT EXECUTION — Full organism geometry update
  // ─────────────────────────────────────────────────────────────────────────────

  /// Execute complete geometry computation at organism beat
  public func executeOrganismBeat(
    state: UnifiedGeometricState,
    doctrine: MedinaGeometryDoctrine,
    beat: Nat
  ) : (UnifiedGeometricState, MedinaGeometryDoctrine) {
    // 1. Compute geometric complexity
    let complexity = computeGeometricComplexity(state);
    
    // 2. Enforce doctrine
    let (compliant, complianceScore) = enforceMedinaGeometry(
      state.scalarCurvature,
      state.totalVolume,
      doctrine
    );
    
    // 3. Update states
    let newState : UnifiedGeometricState = {
      fundamentalMetric = state.fundamentalMetric;
      fundamentalConnection = state.fundamentalConnection;
      fundamentalCurvature = state.fundamentalCurvature;
      scalarCurvature = state.scalarCurvature;
      kuramotoCoupling = state.kuramotoCoupling;
      fristonCoupling = state.fristonCoupling;
      hebbianCoupling = state.hebbianCoupling;
      attractorCoupling = state.attractorCoupling;
      physicsCoupling = state.physicsCoupling;
      totalVolume = state.totalVolume;
      averageCurvature = state.averageCurvature;
      geometricComplexity = complexity;
      currentBeat = beat;
      lastGeometryUpdate = state.currentBeat;
    };
    
    let newDoctrine : MedinaGeometryDoctrine = {
      metricSignature = doctrine.metricSignature;
      metricPositiveDefinite = doctrine.metricPositiveDefinite;
      minScalarCurvature = doctrine.minScalarCurvature;
      maxScalarCurvature = doctrine.maxScalarCurvature;
      minVolume = doctrine.minVolume;
      maxVolume = doctrine.maxVolume;
      goldenRatioCurvature = doctrine.goldenRatioCurvature;
      geometryComplianceScore = complianceScore;
      violationCount = if (compliant) { doctrine.violationCount } else { doctrine.violationCount + 1 };
    };
    
    (newState, newDoctrine)
  };


  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════
  //
  //  PHASE 211: DEEP DIFFERENTIAL GEOMETRY
  //
  //  Differential geometry is the language of PHYSICS.
  //  Einstein's general relativity IS differential geometry.
  //  Gauge theories ARE fiber bundle geometry.
  //  The organism's value landscape IS a Riemannian manifold.
  //
  //  Not metaphor. IS.
  //
  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════


  // ═══════════════════════════════════════════════════════════════════════════════
  // FIBER BUNDLE STRUCTURE
  // ═══════════════════════════════════════════════════════════════════════════════
  // A fiber bundle E → B with fiber F:
  //   E = total space (organism's full state)
  //   B = base space (organism's position/configuration)
  //   F = fiber (internal degrees of freedom at each point)
  //   π: E → B = projection (forget internal state, keep position)
  //
  // Connection: tells you how to move "horizontally" (parallel transport)
  // Curvature: measures how much parallel transport depends on path
  //
  // In the organism:
  //   Base = 12 layers (-6 to +5) × spatial web
  //   Fiber = coherence state at each point (phase, amplitude)
  //   Connection = how coherence propagates between nodes
  //   Curvature = information geometry (how meaning curves space)
  // ═══════════════════════════════════════════════════════════════════════════════

  public type FiberBundleState = {
    baseCoordinates : [Float];       // position on base manifold
    fiberCoordinates : [Float];      // internal state in fiber
    connectionForm : [Float];        // A_μ (gauge field)
    curvatureForm : [Float];         // F_μν = dA + A∧A
    holonomy : [Float];              // parallel transport around loop
    baseDimension : Nat;
    fiberDimension : Nat;
    structureGroup : Text;           // symmetry group of fiber
    chernClass : [Float];            // topological invariants
  };

  /// Initialize fiber bundle state
  public func initFiberBundle(baseDim : Nat, fiberDim : Nat) : FiberBundleState {
    {
      baseCoordinates = Array.tabulate<Float>(baseDim, func(_ : Nat) : Float { 0.0 });
      fiberCoordinates = Array.tabulate<Float>(fiberDim, func(_ : Nat) : Float { 1.0 });
      connectionForm = Array.tabulate<Float>(baseDim * fiberDim * fiberDim, func(_ : Nat) : Float { 0.0 });
      curvatureForm = Array.tabulate<Float>(baseDim * baseDim * fiberDim * fiberDim, func(_ : Nat) : Float { 0.0 });
      holonomy = Array.tabulate<Float>(fiberDim * fiberDim, func(i : Nat) : Float {
        if (i / fiberDim == i % fiberDim) { 1.0 } else { 0.0 } // identity
      });
      baseDimension = baseDim;
      fiberDimension = fiberDim;
      structureGroup = "U(1)"; // simplest non-trivial
      chernClass = [0.0]; // trivial bundle initially
    }
  };

  /// Covariant derivative: D_μ ψ = ∂_μ ψ + A_μ ψ
  /// This IS how the organism differentiates while respecting symmetry
  public func covariantDerivative(
    field : [Float],              // ψ
    fieldGradient : [Float],      // ∂_μ ψ
    connection : [Float],         // A_μ
    direction : Nat,              // μ
    fiberDim : Nat
  ) : [Float] {
    Array.tabulate<Float>(fiberDim, func(a : Nat) : Float {
      let partialDerivative = if (a < fieldGradient.size()) { fieldGradient[a] } else { 0.0 };
      // A_μ^a_b ψ^b sum
      var connectionTerm : Float = 0.0;
      var b = 0;
      while (b < fiberDim) {
        let aIdx = direction * fiberDim * fiberDim + a * fiberDim + b;
        let connVal = if (aIdx < connection.size()) { connection[aIdx] } else { 0.0 };
        let fieldVal = if (b < field.size()) { field[b] } else { 0.0 };
        connectionTerm += connVal * fieldVal;
        b += 1;
      };
      partialDerivative + connectionTerm
    })
  };

  /// Curvature 2-form: F_μν = ∂_μ A_ν - ∂_ν A_μ + [A_μ, A_ν]
  /// For abelian (U(1)): F_μν = ∂_μ A_ν - ∂_ν A_μ (no commutator)
  public func computeCurvature2Form(
    connectionGradient : [Float],  // ∂_μ A_ν
    baseDim : Nat,
    fiberDim : Nat
  ) : [Float] {
    let fDim2 = fiberDim * fiberDim;
    Array.tabulate<Float>(baseDim * baseDim * fDim2, func(idx : Nat) : Float {
      let mu = idx / (baseDim * fDim2);
      let rest = idx % (baseDim * fDim2);
      let nu = rest / fDim2;
      let ab = rest % fDim2;
      
      // F_μν = ∂_μ A_ν - ∂_ν A_μ (abelian part)
      let gradMuNu = mu * baseDim * fDim2 + nu * fDim2 + ab;
      let gradNuMu = nu * baseDim * fDim2 + mu * fDim2 + ab;
      let g1 = if (gradMuNu < connectionGradient.size()) { connectionGradient[gradMuNu] } else { 0.0 };
      let g2 = if (gradNuMu < connectionGradient.size()) { connectionGradient[gradNuMu] } else { 0.0 };
      g1 - g2
    })
  };


  // ═══════════════════════════════════════════════════════════════════════════════
  // GAUSS-BONNET THEOREM
  // ═══════════════════════════════════════════════════════════════════════════════
  // ∫_M K dA = 2π χ(M)
  //
  // The integral of curvature over a closed surface equals 2π times
  // the Euler characteristic. TOPOLOGY CONSTRAINS GEOMETRY.
  //
  // Sphere: ∫ K dA = 4π (χ = 2)
  // Torus: ∫ K dA = 0 (χ = 0)
  // Genus-g surface: ∫ K dA = 2π(2 - 2g)
  //
  // In the organism: no matter how the organism deforms its geometry,
  // the total curvature is FIXED by topology. The organism can change
  // shape but not topology (without cutting or gluing).
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Gauss-Bonnet: ∫ K dA = 2π χ
  public func gaussBonnetIntegral(eulerCharacteristic : Int) : Float {
    2.0 * 3.14159265358979 * Float.fromInt(eulerCharacteristic)
  };

  /// Verify Gauss-Bonnet: does integrated curvature match topology?
  public func verifyGaussBonnet(
    curvatureValues : [Float],
    areaElements : [Float],
    eulerCharacteristic : Int
  ) : (Float, Bool) {
    var integral : Float = 0.0;
    let n = if (curvatureValues.size() < areaElements.size()) { curvatureValues.size() } else { areaElements.size() };
    var i = 0;
    while (i < n) {
      integral += curvatureValues[i] * areaElements[i];
      i += 1;
    };
    let expected = gaussBonnetIntegral(eulerCharacteristic);
    let error = Float.abs(integral - expected);
    (error, error < 0.01 * Float.abs(expected))
  };

  /// Gaussian curvature at a point: K = κ₁ · κ₂ (product of principal curvatures)
  public func gaussianCurvature(kappa1 : Float, kappa2 : Float) : Float {
    kappa1 * kappa2
  };

  /// Mean curvature: H = (κ₁ + κ₂)/2
  /// Mean curvature flow: ∂X/∂t = H·n̂ (evolves toward sphere)
  public func meanCurvature(kappa1 : Float, kappa2 : Float) : Float {
    (kappa1 + kappa2) / 2.0
  };

  /// Minimal surface: H = 0 everywhere (soap films)
  /// Area-minimizing surfaces with given boundary
  public func isMinimalSurface(kappa1 : Float, kappa2 : Float) : Bool {
    Float.abs(kappa1 + kappa2) < 0.001
  };

  /// Willmore energy: W = ∫ H² dA
  /// Measure of surface "smoothness" — conformally invariant
  public func willmoreEnergy(meanCurvatures : [Float], areaElements : [Float]) : Float {
    var W : Float = 0.0;
    let n = if (meanCurvatures.size() < areaElements.size()) { meanCurvatures.size() } else { areaElements.size() };
    var i = 0;
    while (i < n) {
      W += meanCurvatures[i] * meanCurvatures[i] * areaElements[i];
      i += 1;
    };
    W
  };

  /// Geodesic curvature: how much a curve deviates from being a geodesic
  /// κ_g = 0 for geodesics (shortest paths)
  public func geodesicCurvature(
    tangent : [Float],
    acceleration : [Float],
    normal : [Float]
  ) : Float {
    // κ_g = acceleration · normal
    var kappa : Float = 0.0;
    let n = acceleration.size();
    var i = 0;
    while (i < n) {
      let acc = acceleration[i];
      let norm = if (i < normal.size()) { normal[i] } else { 0.0 };
      kappa += acc * norm;
      i += 1;
    };
    kappa
  };

}
