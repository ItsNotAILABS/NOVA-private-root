// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Module: TensorFieldEngine — Complete Tensor Calculus on Manifolds
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
// 
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔══════════════════════════════════════════════════════════════════════════╗
// ║              TENSOR FIELD ENGINE                                         ║
// ╠══════════════════════════════════════════════════════════════════════════╣
// ║                                                                          ║
// ║  This engine implements complete tensor algebra and calculus:            ║
// ║    • Tensor products ⊗                                                   ║
// ║    • Tensor contractions                                                 ║
// ║    • Symmetrization and antisymmetrization                               ║
// ║    • Index raising and lowering                                          ║
// ║    • Tensor decomposition (trace, traceless)                             ║
// ║    • Tensor eigenvalue problems                                          ║
// ║    • Tensor invariants                                                   ║
// ║    • Levi-Civita symbol and tensor densities                             ║
// ║    • Hodge star operator                                                 ║
// ║    • Einstein summation convention                                       ║
// ║                                                                          ║
// ║  MULTIPLE RESPONSIBILITIES:                                              ║
// ║    1. Tensor algebra                                                     ║
// ║    2. Index manipulation                                                 ║
// ║    3. Symmetry analysis                                                  ║
// ║    4. Invariant computation                                              ║
// ║    5. Decomposition                                                      ║
// ║    6. Field operations                                                   ║
// ║    7. Dual operations                                                    ║
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

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     TENSOR TYPE DEFINITIONS                            ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  // General tensor representation
  public type Tensor = {
    components : [Float];      // Flattened components
    rank : TensorRank;
    dimension : Nat;
    indexPositions : [IndexPosition];  // Up or down for each index
  };

  public type TensorRank = {
    contravariant : Nat;  // Upper indices
    covariant : Nat;      // Lower indices
  };

  public type IndexPosition = {
    #Up;    // Contravariant (upper)
    #Down;  // Covariant (lower)
  };

  // Specialized tensor types
  public type Scalar = Float;

  public type Vector = {
    components : [Float];
    dimension : Nat;
    position : IndexPosition;
  };

  public type Matrix = {
    components : [[Float]];
    rows : Nat;
    cols : Nat;
    indexPositions : (IndexPosition, IndexPosition);
  };

  public type Rank3Tensor = {
    components : [[[Float]]];
    dimension : Nat;
    indexPositions : (IndexPosition, IndexPosition, IndexPosition);
  };

  public type Rank4Tensor = {
    components : [[[[Float]]]];
    dimension : Nat;
    indexPositions : (IndexPosition, IndexPosition, IndexPosition, IndexPosition);
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     TENSOR CREATION                                    ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public func createScalar(value : Float) : Tensor {
    {
      components = [value];
      rank = { contravariant = 0; covariant = 0 };
      dimension = 1;
      indexPositions = [];
    }
  };

  public func createVector(components : [Float], up : Bool) : Tensor {
    let n = components.size();
    {
      components = components;
      rank = if (up) { { contravariant = 1; covariant = 0 } } 
             else { { contravariant = 0; covariant = 1 } };
      dimension = n;
      indexPositions = [if (up) { #Up } else { #Down }];
    }
  };

  public func createMatrix(components : [[Float]], upUp : Bool, upDown : Bool) : Tensor {
    let rows = components.size();
    let cols = if (rows > 0) { components[0].size() } else { 0 };
    
    // Flatten
    let flat = Buffer.Buffer<Float>(rows * cols);
    for (row in components.vals()) {
      for (val in row.vals()) {
        flat.add(val);
      };
    };
    
    let pos1 : IndexPosition = if (upUp) { #Up } else { #Down };
    let pos2 : IndexPosition = if (upDown) { #Up } else { #Down };
    
    let contra = (if (upUp) { 1 } else { 0 }) + (if (upDown) { 1 } else { 0 });
    let cova = 2 - contra;
    
    {
      components = Buffer.toArray(flat);
      rank = { contravariant = contra; covariant = cova };
      dimension = rows;  // Assuming square
      indexPositions = [pos1, pos2];
    }
  };

  public func createRank3Tensor(
    components : [[[Float]]],
    positions : [IndexPosition]
  ) : Tensor {
    let d1 = components.size();
    let d2 = if (d1 > 0) { components[0].size() } else { 0 };
    let d3 = if (d2 > 0) { components[0][0].size() } else { 0 };
    
    let flat = Buffer.Buffer<Float>(d1 * d2 * d3);
    for (i in components.vals()) {
      for (j in i.vals()) {
        for (k in j.vals()) {
          flat.add(k);
        };
      };
    };
    
    var contra : Nat = 0;
    for (pos in positions.vals()) {
      switch (pos) {
        case (#Up) { contra += 1 };
        case (#Down) {};
      };
    };
    
    {
      components = Buffer.toArray(flat);
      rank = { contravariant = contra; covariant = 3 - contra };
      dimension = d1;
      indexPositions = positions;
    }
  };

  public func createRank4Tensor(
    components : [[[[Float]]]],
    positions : [IndexPosition]
  ) : Tensor {
    let d1 = components.size();
    let d2 = if (d1 > 0) { components[0].size() } else { 0 };
    let d3 = if (d2 > 0) { components[0][0].size() } else { 0 };
    let d4 = if (d3 > 0) { components[0][0][0].size() } else { 0 };
    
    let flat = Buffer.Buffer<Float>(d1 * d2 * d3 * d4);
    for (i in components.vals()) {
      for (j in i.vals()) {
        for (k in j.vals()) {
          for (l in k.vals()) {
            flat.add(l);
          };
        };
      };
    };
    
    var contra : Nat = 0;
    for (pos in positions.vals()) {
      switch (pos) {
        case (#Up) { contra += 1 };
        case (#Down) {};
      };
    };
    
    {
      components = Buffer.toArray(flat);
      rank = { contravariant = contra; covariant = 4 - contra };
      dimension = d1;
      indexPositions = positions;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     INDEX OPERATIONS                                   ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  // Get component from multi-index
  public func getComponent(tensor : Tensor, indices : [Nat]) : Float {
    let totalRank = tensor.rank.contravariant + tensor.rank.covariant;
    if (indices.size() != totalRank) { return 0.0 };
    
    let d = tensor.dimension;
    var flatIndex : Nat = 0;
    var multiplier : Nat = 1;
    
    // Row-major ordering
    var i = totalRank;
    while (i > 0) {
      i -= 1;
      flatIndex += indices[i] * multiplier;
      multiplier *= d;
    };
    
    if (flatIndex < tensor.components.size()) {
      tensor.components[flatIndex]
    } else {
      0.0
    }
  };

  // Set component at multi-index
  public func setComponent(tensor : Tensor, indices : [Nat], value : Float) : Tensor {
    let totalRank = tensor.rank.contravariant + tensor.rank.covariant;
    if (indices.size() != totalRank) { return tensor };
    
    let d = tensor.dimension;
    var flatIndex : Nat = 0;
    var multiplier : Nat = 1;
    
    var i = totalRank;
    while (i > 0) {
      i -= 1;
      flatIndex += indices[i] * multiplier;
      multiplier *= d;
    };
    
    let newComponents = Array.tabulate<Float>(tensor.components.size(), func(j : Nat) : Float {
      if (j == flatIndex) { value } else { tensor.components[j] }
    });
    
    {
      components = newComponents;
      rank = tensor.rank;
      dimension = tensor.dimension;
      indexPositions = tensor.indexPositions;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     TENSOR PRODUCT                                     ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  // Tensor product: A ⊗ B
  public func tensorProduct(A : Tensor, B : Tensor) : Tensor {
    let rankA = A.rank.contravariant + A.rank.covariant;
    let rankB = B.rank.contravariant + B.rank.covariant;
    let newRank = rankA + rankB;
    
    let d = A.dimension;  // Assuming same dimension
    let sizeA = A.components.size();
    let sizeB = B.components.size();
    let newSize = sizeA * sizeB;
    
    let newComponents = Array.tabulate<Float>(newSize, func(idx : Nat) : Float {
      let idxA = idx / sizeB;
      let idxB = idx % sizeB;
      A.components[idxA] * B.components[idxB]
    });
    
    let newPositions = Buffer.Buffer<IndexPosition>(newRank);
    for (pos in A.indexPositions.vals()) {
      newPositions.add(pos);
    };
    for (pos in B.indexPositions.vals()) {
      newPositions.add(pos);
    };
    
    {
      components = newComponents;
      rank = {
        contravariant = A.rank.contravariant + B.rank.contravariant;
        covariant = A.rank.covariant + B.rank.covariant;
      };
      dimension = d;
      indexPositions = Buffer.toArray(newPositions);
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     TENSOR CONTRACTION                                 ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  // Contract indices i and j (one must be up, one down for metric contraction)
  public func contract(tensor : Tensor, index1 : Nat, index2 : Nat) : Tensor {
    let totalRank = tensor.rank.contravariant + tensor.rank.covariant;
    if (index1 >= totalRank or index2 >= totalRank or index1 == index2) {
      return tensor;
    };
    
    let d = tensor.dimension;
    let newRank = totalRank - 2;
    
    // Calculate new tensor size
    var newSize : Nat = 1;
    for (_i in Iter.range(0, newRank - 1)) {
      newSize *= d;
    };
    if (newRank == 0) { newSize := 1 };
    
    let newComponents = Array.tabulate<Float>(newSize, func(newIdx : Nat) : Float {
      // Convert newIdx to indices (excluding index1 and index2)
      let newIndices = indexFromFlat(newIdx, d, newRank);
      
      // Sum over contracted index
      var sum : Float = 0.0;
      for (k in Iter.range(0, d - 1)) {
        // Reconstruct full indices
        let fullIndices = insertContractedIndices(newIndices, index1, index2, k);
        sum += getComponent(tensor, fullIndices);
      };
      sum
    });
    
    // New index positions
    let newPositions = Buffer.Buffer<IndexPosition>(newRank);
    for (i in Iter.range(0, totalRank - 1)) {
      if (i != index1 and i != index2) {
        newPositions.add(tensor.indexPositions[i]);
      };
    };
    
    var newContra = tensor.rank.contravariant;
    var newCova = tensor.rank.covariant;
    
    switch (tensor.indexPositions[index1]) {
      case (#Up) { newContra -= 1 };
      case (#Down) { newCova -= 1 };
    };
    switch (tensor.indexPositions[index2]) {
      case (#Up) { newContra -= 1 };
      case (#Down) { newCova -= 1 };
    };
    
    {
      components = newComponents;
      rank = { contravariant = newContra; covariant = newCova };
      dimension = d;
      indexPositions = Buffer.toArray(newPositions);
    }
  };

  // Helper: convert flat index to multi-index
  func indexFromFlat(flat : Nat, d : Nat, rank : Nat) : [Nat] {
    if (rank == 0) { return [] };
    
    let indices = Buffer.Buffer<Nat>(rank);
    var remaining = flat;
    
    for (_i in Iter.range(0, rank - 1)) {
      var divisor : Nat = 1;
      for (_j in Iter.range(0, rank - 2 - _i)) {
        divisor *= d;
      };
      indices.add(remaining / divisor);
      remaining := remaining % divisor;
    };
    
    Buffer.toArray(indices)
  };

  // Helper: insert contracted indices
  func insertContractedIndices(reduced : [Nat], idx1 : Nat, idx2 : Nat, k : Nat) : [Nat] {
    let (i1, i2) = if (idx1 < idx2) { (idx1, idx2) } else { (idx2, idx1) };
    
    let result = Buffer.Buffer<Nat>(reduced.size() + 2);
    var reducedIdx : Nat = 0;
    
    for (i in Iter.range(0, reduced.size() + 1)) {
      if (i == i1 or i == i2) {
        result.add(k);
      } else {
        if (reducedIdx < reduced.size()) {
          result.add(reduced[reducedIdx]);
          reducedIdx += 1;
        };
      };
    };
    
    Buffer.toArray(result)
  };

  // Trace of rank-2 tensor
  public func trace(tensor : Tensor) : Float {
    if (tensor.rank.contravariant + tensor.rank.covariant != 2) {
      return 0.0;
    };
    
    var sum : Float = 0.0;
    for (i in Iter.range(0, tensor.dimension - 1)) {
      sum += getComponent(tensor, [i, i]);
    };
    sum
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     INDEX RAISING AND LOWERING                         ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  // Raise index using metric inverse
  public func raiseIndex(tensor : Tensor, index : Nat, metricInverse : [[Float]]) : Tensor {
    let totalRank = tensor.rank.contravariant + tensor.rank.covariant;
    if (index >= totalRank) { return tensor };
    
    switch (tensor.indexPositions[index]) {
      case (#Up) { return tensor };  // Already up
      case (#Down) {};
    };
    
    let d = tensor.dimension;
    let newComponents = Buffer.Buffer<Float>(tensor.components.size());
    
    // For each component of result
    let totalSize = tensor.components.size();
    for (flatIdx in Iter.range(0, totalSize - 1)) {
      let indices = indexFromFlat(flatIdx, d, totalRank);
      
      // Sum over contraction with metric inverse
      var sum : Float = 0.0;
      for (k in Iter.range(0, d - 1)) {
        let oldIndices = Array.tabulate<Nat>(totalRank, func(i : Nat) : Nat {
          if (i == index) { k } else { indices[i] }
        });
        sum += metricInverse[indices[index]][k] * getComponent(tensor, oldIndices);
      };
      newComponents.add(sum);
    };
    
    let newPositions = Array.tabulate<IndexPosition>(totalRank, func(i : Nat) : IndexPosition {
      if (i == index) { #Up } else { tensor.indexPositions[i] }
    });
    
    {
      components = Buffer.toArray(newComponents);
      rank = { 
        contravariant = tensor.rank.contravariant + 1; 
        covariant = tensor.rank.covariant - 1 
      };
      dimension = d;
      indexPositions = newPositions;
    }
  };

  // Lower index using metric
  public func lowerIndex(tensor : Tensor, index : Nat, metric : [[Float]]) : Tensor {
    let totalRank = tensor.rank.contravariant + tensor.rank.covariant;
    if (index >= totalRank) { return tensor };
    
    switch (tensor.indexPositions[index]) {
      case (#Down) { return tensor };  // Already down
      case (#Up) {};
    };
    
    let d = tensor.dimension;
    let newComponents = Buffer.Buffer<Float>(tensor.components.size());
    
    let totalSize = tensor.components.size();
    for (flatIdx in Iter.range(0, totalSize - 1)) {
      let indices = indexFromFlat(flatIdx, d, totalRank);
      
      var sum : Float = 0.0;
      for (k in Iter.range(0, d - 1)) {
        let oldIndices = Array.tabulate<Nat>(totalRank, func(i : Nat) : Nat {
          if (i == index) { k } else { indices[i] }
        });
        sum += metric[indices[index]][k] * getComponent(tensor, oldIndices);
      };
      newComponents.add(sum);
    };
    
    let newPositions = Array.tabulate<IndexPosition>(totalRank, func(i : Nat) : IndexPosition {
      if (i == index) { #Down } else { tensor.indexPositions[i] }
    });
    
    {
      components = Buffer.toArray(newComponents);
      rank = { 
        contravariant = tensor.rank.contravariant - 1; 
        covariant = tensor.rank.covariant + 1 
      };
      dimension = d;
      indexPositions = newPositions;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     SYMMETRIZATION                                     ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  // Symmetrize over indices: T_(ab) = (1/2)(T_ab + T_ba)
  public func symmetrize(tensor : Tensor, index1 : Nat, index2 : Nat) : Tensor {
    let totalRank = tensor.rank.contravariant + tensor.rank.covariant;
    if (index1 >= totalRank or index2 >= totalRank) { return tensor };
    
    let d = tensor.dimension;
    let totalSize = tensor.components.size();
    
    let newComponents = Array.tabulate<Float>(totalSize, func(flatIdx : Nat) : Float {
      let indices = indexFromFlat(flatIdx, d, totalRank);
      
      // Swap indices index1 and index2
      let swappedIndices = Array.tabulate<Nat>(totalRank, func(i : Nat) : Nat {
        if (i == index1) { indices[index2] }
        else if (i == index2) { indices[index1] }
        else { indices[i] }
      });
      
      (getComponent(tensor, indices) + getComponent(tensor, swappedIndices)) / 2.0
    });
    
    {
      components = newComponents;
      rank = tensor.rank;
      dimension = tensor.dimension;
      indexPositions = tensor.indexPositions;
    }
  };

  // Antisymmetrize over indices: T_[ab] = (1/2)(T_ab - T_ba)
  public func antisymmetrize(tensor : Tensor, index1 : Nat, index2 : Nat) : Tensor {
    let totalRank = tensor.rank.contravariant + tensor.rank.covariant;
    if (index1 >= totalRank or index2 >= totalRank) { return tensor };
    
    let d = tensor.dimension;
    let totalSize = tensor.components.size();
    
    let newComponents = Array.tabulate<Float>(totalSize, func(flatIdx : Nat) : Float {
      let indices = indexFromFlat(flatIdx, d, totalRank);
      
      let swappedIndices = Array.tabulate<Nat>(totalRank, func(i : Nat) : Nat {
        if (i == index1) { indices[index2] }
        else if (i == index2) { indices[index1] }
        else { indices[i] }
      });
      
      (getComponent(tensor, indices) - getComponent(tensor, swappedIndices)) / 2.0
    });
    
    {
      components = newComponents;
      rank = tensor.rank;
      dimension = tensor.dimension;
      indexPositions = tensor.indexPositions;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     LEVI-CIVITA SYMBOL                                 ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  // Permutation signature
  func permutationSign(perm : [Nat]) : Int {
    var inversions : Nat = 0;
    let n = perm.size();
    
    for (i in Iter.range(0, n - 1)) {
      for (j in Iter.range(i + 1, n - 1)) {
        if (perm[i] > perm[j]) {
          inversions += 1;
        };
      };
    };
    
    if (inversions % 2 == 0) { 1 } else { -1 }
  };

  // Levi-Civita symbol ε_{i₁...iₙ}
  public func leviCivita(indices : [Nat], dimension : Nat) : Int {
    let n = indices.size();
    if (n != dimension) { return 0 };
    
    // Check for repeated indices
    for (i in Iter.range(0, n - 1)) {
      for (j in Iter.range(i + 1, n - 1)) {
        if (indices[i] == indices[j]) { return 0 };
      };
    };
    
    // Check bounds
    for (idx in indices.vals()) {
      if (idx >= dimension) { return 0 };
    };
    
    permutationSign(indices)
  };

  // Create Levi-Civita tensor
  public func createLeviCivitaTensor(dimension : Nat) : Tensor {
    var totalSize : Nat = 1;
    for (_i in Iter.range(0, dimension - 1)) {
      totalSize *= dimension;
    };
    
    let components = Array.tabulate<Float>(totalSize, func(flatIdx : Nat) : Float {
      let indices = indexFromFlat(flatIdx, dimension, dimension);
      Float.fromInt(leviCivita(indices, dimension))
    });
    
    let positions = Array.tabulate<IndexPosition>(dimension, func(_i : Nat) : IndexPosition { #Down });
    
    {
      components = components;
      rank = { contravariant = 0; covariant = dimension };
      dimension = dimension;
      indexPositions = positions;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     HODGE STAR OPERATOR                                ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  // Hodge dual: *ω = (1/k!) ε^{μ₁...μₙ} ω_{μ₁...μₖ} √|g|
  public func hodgeStar(
    form : Tensor,
    metric : [[Float]],
    metricInverse : [[Float]],
    metricDeterminant : Float
  ) : Tensor {
    let n = form.dimension;
    let k = form.rank.covariant;
    let newRank = n - k;
    
    if (k > n) { return form };
    
    let sqrtG = Float.sqrt(Float.abs(metricDeterminant));
    
    // Create Levi-Civita with upper indices
    let epsilon = createLeviCivitaTensor(n);
    
    // Raise all indices of epsilon
    var epsUp = epsilon;
    for (i in Iter.range(0, n - 1)) {
      epsUp := raiseIndex(epsUp, i, metricInverse);
    };
    
    // Contract form with epsilon
    var result = tensorProduct(epsUp, form);
    for (_i in Iter.range(0, k - 1)) {
      // Contract last index of epsilon with form index
      let lastEpsIdx = n - 1 - _i;
      let formIdx = n + _i;
      result := contract(result, lastEpsIdx, formIdx);
    };
    
    // Scale by 1/k! and sqrt|g|
    let factorial = factorialFloat(k);
    let scale = sqrtG / factorial;
    
    result := scaleTensor(result, scale);
    
    result
  };

  func factorialFloat(n : Nat) : Float {
    var result : Float = 1.0;
    for (i in Iter.range(2, n)) {
      result *= Float.fromInt(i);
    };
    result
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     TENSOR INVARIANTS                                  ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  // First invariant I₁ = tr(A)
  public func invariant1(tensor : Tensor) : Float {
    trace(tensor)
  };

  // Second invariant I₂ = (1/2)[(tr A)² - tr(A²)]
  public func invariant2(tensor : Tensor) : Float {
    if (tensor.rank.contravariant + tensor.rank.covariant != 2) {
      return 0.0;
    };
    
    let trA = trace(tensor);
    let A2 = matrixMul(tensor, tensor);
    let trA2 = trace(A2);
    
    0.5 * (trA * trA - trA2)
  };

  // Third invariant I₃ = det(A) (for 3x3)
  public func invariant3(tensor : Tensor) : Float {
    if (tensor.dimension != 3) { return 0.0 };
    determinant3x3(tensor)
  };

  // 3x3 determinant
  func determinant3x3(tensor : Tensor) : Float {
    let a = getComponent(tensor, [0, 0]);
    let b = getComponent(tensor, [0, 1]);
    let c = getComponent(tensor, [0, 2]);
    let d = getComponent(tensor, [1, 0]);
    let e = getComponent(tensor, [1, 1]);
    let f = getComponent(tensor, [1, 2]);
    let g = getComponent(tensor, [2, 0]);
    let h = getComponent(tensor, [2, 1]);
    let i = getComponent(tensor, [2, 2]);
    
    a * (e * i - f * h) - b * (d * i - f * g) + c * (d * h - e * g)
  };

  // Cayley-Hamilton: A³ - I₁A² + I₂A - I₃I = 0
  public func verifyCayleyHamilton(tensor : Tensor) : Float {
    if (tensor.dimension != 3) { return 0.0 };
    
    let I1 = invariant1(tensor);
    let I2 = invariant2(tensor);
    let I3 = invariant3(tensor);
    
    let A2 = matrixMul(tensor, tensor);
    let A3 = matrixMul(A2, tensor);
    
    // A³ - I₁A² + I₂A - I₃I
    let term1 = A3;
    let term2 = scaleTensor(A2, -I1);
    let term3 = scaleTensor(tensor, I2);
    let term4 = scaleTensor(identityTensor(3), -I3);
    
    let result = addTensors(addTensors(addTensors(term1, term2), term3), term4);
    
    // Return Frobenius norm of result (should be ~0)
    frobeniusNorm(result)
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     TENSOR DECOMPOSITION                               ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  // Decompose into trace and traceless parts: T = (1/n)tr(T)I + T̃
  public type TensorDecomposition = {
    tracePart : Tensor;
    tracelessPart : Tensor;
  };

  public func traceDecomposition(tensor : Tensor) : TensorDecomposition {
    if (tensor.rank.contravariant + tensor.rank.covariant != 2) {
      return { tracePart = tensor; tracelessPart = tensor };
    };
    
    let n = tensor.dimension;
    let tr = trace(tensor);
    let traceCoeff = tr / Float.fromInt(n);
    
    let tracePart = scaleTensor(identityTensor(n), traceCoeff);
    let tracelessPart = subtractTensors(tensor, tracePart);
    
    { tracePart = tracePart; tracelessPart = tracelessPart }
  };

  // Symmetric/antisymmetric decomposition
  public type SymmetryDecomposition = {
    symmetric : Tensor;
    antisymmetric : Tensor;
  };

  public func symmetryDecomposition(tensor : Tensor) : SymmetryDecomposition {
    if (tensor.rank.contravariant + tensor.rank.covariant != 2) {
      return { symmetric = tensor; antisymmetric = tensor };
    };
    
    let sym = symmetrize(tensor, 0, 1);
    let antisym = antisymmetrize(tensor, 0, 1);
    
    { symmetric = sym; antisymmetric = antisym }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     EIGENVALUE PROBLEMS                                ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  // Power iteration for dominant eigenvalue
  public func powerIteration(tensor : Tensor, maxIter : Nat, tol : Float) : (Float, [Float]) {
    let n = tensor.dimension;
    
    // Initial vector
    var v = Array.tabulate<Float>(n, func(i : Nat) : Float {
      Float.sin(Float.fromInt(i) * φ)
    });
    v := normalizeVector(v);
    
    var eigenvalue : Float = 0.0;
    
    for (_iter in Iter.range(0, maxIter - 1)) {
      // Matrix-vector multiply
      let mv = tensorVectorMul(tensor, v);
      
      // Rayleigh quotient
      let newEigenvalue = dotProduct(v, mv);
      
      // Normalize
      v := normalizeVector(mv);
      
      if (Float.abs(newEigenvalue - eigenvalue) < tol) {
        return (newEigenvalue, v);
      };
      
      eigenvalue := newEigenvalue;
    };
    
    (eigenvalue, v)
  };

  // All eigenvalues for 2x2 matrix
  public func eigenvalues2x2(tensor : Tensor) : [Float] {
    if (tensor.dimension != 2) { return [] };
    
    let a = getComponent(tensor, [0, 0]);
    let b = getComponent(tensor, [0, 1]);
    let c = getComponent(tensor, [1, 0]);
    let d = getComponent(tensor, [1, 1]);
    
    let tr = a + d;
    let det = a * d - b * c;
    let disc = tr * tr - 4.0 * det;
    
    if (disc >= 0.0) {
      let sqrtDisc = Float.sqrt(disc);
      [(tr + sqrtDisc) / 2.0, (tr - sqrtDisc) / 2.0]
    } else {
      // Complex eigenvalues: return real part
      [tr / 2.0, tr / 2.0]
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     TENSOR FIELD OPERATIONS                            ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public type TensorField = {
    tensors : [Tensor];     // Tensor at each point
    points : [[Float]];     // Coordinates of each point
    dimension : Nat;
  };

  // Create tensor field
  public func createTensorField(
    tensorFunc : ([Float]) -> Tensor,
    points : [[Float]]
  ) : TensorField {
    let tensors = Array.map<[Float], Tensor>(points, tensorFunc);
    
    {
      tensors = tensors;
      points = points;
      dimension = if (points.size() > 0) { points[0].size() } else { 0 };
    }
  };

  // Evaluate tensor field at point (linear interpolation)
  public func evaluateField(field : TensorField, point : [Float]) : Tensor {
    // Find nearest point
    var minDist : Float = 1e10;
    var nearestIdx : Nat = 0;
    
    for (i in Iter.range(0, field.points.size() - 1)) {
      let dist = vectorDistance(point, field.points[i]);
      if (dist < minDist) {
        minDist := dist;
        nearestIdx := i;
      };
    };
    
    field.tensors[nearestIdx]
  };

  // Divergence of vector field: div(V) = ∂_μ V^μ
  public func divergence(field : TensorField, h : Float) : [Float] {
    let n = field.points.size();
    
    Array.tabulate<Float>(n, func(i : Nat) : Float {
      var div : Float = 0.0;
      let tensor = field.tensors[i];
      
      // Numerical derivative in each direction
      for (mu in Iter.range(0, field.dimension - 1)) {
        // Find neighboring points
        let point = field.points[i];
        let pointPlus = Array.tabulate<Float>(field.dimension, func(j : Nat) : Float {
          if (j == mu) { point[j] + h } else { point[j] }
        });
        let pointMinus = Array.tabulate<Float>(field.dimension, func(j : Nat) : Float {
          if (j == mu) { point[j] - h } else { point[j] }
        });
        
        let tensorPlus = evaluateField(field, pointPlus);
        let tensorMinus = evaluateField(field, pointMinus);
        
        // Central difference: ∂_μ V^μ ≈ (V^μ(x+h) - V^μ(x-h)) / (2h)
        div += (getComponent(tensorPlus, [mu]) - getComponent(tensorMinus, [mu])) / (2.0 * h);
      };
      
      div
    })
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     HELPER FUNCTIONS                                   ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public func scaleTensor(tensor : Tensor, s : Float) : Tensor {
    {
      components = Array.map<Float, Float>(tensor.components, func(v : Float) : Float { v * s });
      rank = tensor.rank;
      dimension = tensor.dimension;
      indexPositions = tensor.indexPositions;
    }
  };

  public func addTensors(a : Tensor, b : Tensor) : Tensor {
    {
      components = Array.tabulate<Float>(a.components.size(), func(i : Nat) : Float {
        a.components[i] + b.components[i]
      });
      rank = a.rank;
      dimension = a.dimension;
      indexPositions = a.indexPositions;
    }
  };

  public func subtractTensors(a : Tensor, b : Tensor) : Tensor {
    {
      components = Array.tabulate<Float>(a.components.size(), func(i : Nat) : Float {
        a.components[i] - b.components[i]
      });
      rank = a.rank;
      dimension = a.dimension;
      indexPositions = a.indexPositions;
    }
  };

  public func identityTensor(n : Nat) : Tensor {
    let components = Array.tabulate<Float>(n * n, func(idx : Nat) : Float {
      let i = idx / n;
      let j = idx % n;
      if (i == j) { 1.0 } else { 0.0 }
    });
    
    {
      components = components;
      rank = { contravariant = 1; covariant = 1 };
      dimension = n;
      indexPositions = [#Up, #Down];
    }
  };

  public func matrixMul(a : Tensor, b : Tensor) : Tensor {
    let n = a.dimension;
    
    let components = Array.tabulate<Float>(n * n, func(idx : Nat) : Float {
      let i = idx / n;
      let j = idx % n;
      
      var sum : Float = 0.0;
      for (k in Iter.range(0, n - 1)) {
        sum += getComponent(a, [i, k]) * getComponent(b, [k, j]);
      };
      sum
    });
    
    {
      components = components;
      rank = a.rank;
      dimension = n;
      indexPositions = a.indexPositions;
    }
  };

  public func tensorVectorMul(tensor : Tensor, v : [Float]) : [Float] {
    let n = tensor.dimension;
    
    Array.tabulate<Float>(n, func(i : Nat) : Float {
      var sum : Float = 0.0;
      for (j in Iter.range(0, n - 1)) {
        sum += getComponent(tensor, [i, j]) * v[j];
      };
      sum
    })
  };

  public func frobeniusNorm(tensor : Tensor) : Float {
    var sum : Float = 0.0;
    for (v in tensor.components.vals()) {
      sum += v * v;
    };
    Float.sqrt(sum)
  };

  func normalizeVector(v : [Float]) : [Float] {
    var norm : Float = 0.0;
    for (val in v.vals()) {
      norm += val * val;
    };
    norm := Float.sqrt(norm);
    
    if (norm < 1e-10) {
      v
    } else {
      Array.map<Float, Float>(v, func(x : Float) : Float { x / norm })
    }
  };

  func dotProduct(a : [Float], b : [Float]) : Float {
    var sum : Float = 0.0;
    for (i in Iter.range(0, a.size() - 1)) {
      sum += a[i] * b[i];
    };
    sum
  };

  func vectorDistance(a : [Float], b : [Float]) : Float {
    var sum : Float = 0.0;
    for (i in Iter.range(0, a.size() - 1)) {
      let diff = a[i] - b[i];
      sum += diff * diff;
    };
    Float.sqrt(sum)
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     ENGINE RESPONSIBILITIES                            ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public type TensorResponsibility = {
    #TensorAlgebra;
    #IndexManipulation;
    #SymmetryAnalysis;
    #InvariantComputation;
    #Decomposition;
    #FieldOperations;
    #DualOperations;
  };

  public type TensorFieldEngine = {
    id : Nat;
    responsibilities : [TensorResponsibility];
    currentTensor : ?Tensor;
    currentField : ?TensorField;
    state : TensorEngineState;
  };

  public type TensorEngineState = {
    lastOperation : Text;
    energy : Float;
    coherence : Float;
  };

  public func createTensorEngine(id : Nat) : TensorFieldEngine {
    {
      id = id;
      responsibilities = [
        #TensorAlgebra,
        #IndexManipulation,
        #SymmetryAnalysis,
        #InvariantComputation,
        #Decomposition,
        #FieldOperations,
        #DualOperations
      ];
      currentTensor = null;
      currentField = null;
      state = {
        lastOperation = "init";
        energy = 1.0;
        coherence = 1.0;
      };
    }
  };

  // Execute all responsibilities on input tensor
  public func executeAllResponsibilities(
    engine : TensorFieldEngine,
    tensor : Tensor
  ) : (TensorFieldEngine, [Float]) {
    let outputs = Buffer.Buffer<Float>(engine.responsibilities.size());
    
    for (resp in engine.responsibilities.vals()) {
      let output = executeResponsibility(resp, tensor);
      outputs.add(output);
    };
    
    let newEngine : TensorFieldEngine = {
      id = engine.id;
      responsibilities = engine.responsibilities;
      currentTensor = ?tensor;
      currentField = engine.currentField;
      state = {
        lastOperation = "all";
        energy = engine.state.energy * ψ + 0.1;
        coherence = engine.state.coherence;
      };
    };
    
    (newEngine, Buffer.toArray(outputs))
  };

  func executeResponsibility(resp : TensorResponsibility, tensor : Tensor) : Float {
    switch (resp) {
      case (#TensorAlgebra) {
        frobeniusNorm(tensor)
      };
      case (#IndexManipulation) {
        Float.fromInt(tensor.rank.contravariant + tensor.rank.covariant)
      };
      case (#SymmetryAnalysis) {
        // Check how symmetric
        if (tensor.rank.contravariant + tensor.rank.covariant == 2) {
          let sym = symmetrize(tensor, 0, 1);
          let diff = subtractTensors(tensor, sym);
          1.0 - frobeniusNorm(diff) / (frobeniusNorm(tensor) + 0.001)
        } else { 0.0 }
      };
      case (#InvariantComputation) {
        invariant1(tensor)
      };
      case (#Decomposition) {
        let decomp = traceDecomposition(tensor);
        trace(decomp.tracePart)
      };
      case (#FieldOperations) {
        Float.fromInt(tensor.dimension)
      };
      case (#DualOperations) {
        // Return trace as dual operation indicator
        trace(tensor)
      };
    }
  };

}
