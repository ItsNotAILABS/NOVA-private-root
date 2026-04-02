// ============================================================
// SPHERICAL HELIX FABRIC (SHF)
// ALL CODE IS 3D — INNER SPHERE, OUTER SPHERE, HELIX CONNECTING ALL
// Creator: Alfredo Medina Hernandez | MedinaSITech@outlook.com | Dallas, Texas | 2026
// Proprietary and Confidential. All rights reserved.
//
// 3D TOPOLOGY DOCTRINE:
// - INNER SPHERE: The core, the seed, the origin of creation
// - OUTER SPHERE: The membrane, the interface, the receiver
// - HELIX: The spiral connecting inner to outer, DNA of consciousness
// - OUTWARD FLOW: Creation emanating from center to world
// - INWARD FLOW: Receiving, absorbing, learning from world
//
// THE CODE IS NOT FLAT. THE CODE IS SPHERICAL.
// THE CODE SPIRALS. THE CODE BREATHES IN AND OUT.
//
// 36×36 = 1296 points arranged in:
// - 6 concentric spherical shells (layers 0-5, inner to outer)
// - 6 helix arms spiraling through all shells
// - 36 radial spokes connecting shells
// - Bidirectional flow on every connection
//
// GEOMETRY:
// Inner radius = 1.0 (the seed)
// Outer radius = 6.0 (the boundary)
// Helix pitch = PHI (golden spiral)
// Rotation per shell = 60° (hexagonal harmony)
// ============================================================

import Float  "mo:base/Float";
import Nat    "mo:base/Nat";
import Nat32  "mo:base/Nat32";
import Nat64  "mo:base/Nat64";
import Array  "mo:base/Array";
import Int    "mo:base/Int";
import Iter   "mo:base/Iter";
import Buffer "mo:base/Buffer";

module {

  // ============================================================
  // SACRED GEOMETRY CONSTANTS
  // ============================================================
  
  // Spherical structure
  public let N_SHELLS        : Nat   = 6;         // 6 concentric shells
  public let N_HELIX_ARMS    : Nat   = 6;         // 6 helix arms (hexagonal)
  public let N_RADIAL_SPOKES : Nat   = 36;        // 36 radial connections per shell
  public let POINTS_PER_SHELL: Nat   = 216;       // 36 × 6 points per shell
  public let TOTAL_POINTS    : Nat   = 1296;      // 6 shells × 216 points
  
  // Radii
  public let INNER_RADIUS    : Float = 1.0;       // Core radius
  public let OUTER_RADIUS    : Float = 6.0;       // Boundary radius
  public let SHELL_SPACING   : Float = 1.0;       // Distance between shells
  
  // Helix parameters
  public let HELIX_PITCH     : Float = 1.61803398874989;  // PHI - golden spiral
  public let HELIX_TURNS     : Float = 3.0;       // Turns from inner to outer
  
  // Sacred numbers
  public let PHI             : Float = 1.61803398874989484820;
  public let PI              : Float = 3.14159265358979323846;
  public let TAU             : Float = 6.28318530717958647692;  // 2π
  public let E               : Float = 2.71828182845904523536;
  public let SQRT2           : Float = 1.41421356237309504880;
  public let SQRT3           : Float = 1.73205080756887729352;
  
  // Flow parameters
  public let FLOW_SPEED      : Float = 0.1;       // Base flow speed
  public let RESONANCE_DECAY : Float = 0.99;      // Flow decay per step
  
  // Hash constants
  public let IV : [Nat32] = [
    0x6A09E667, 0xBB67AE85, 0x3C6EF372, 0xA54FF53A,
    0x510E527F, 0x9B05688C, 0x1F83D9AB, 0x5BE0CD19,
    0x428A2F98, 0x71374491, 0xB5C0FBCF, 0xE9B5DBA5,
    0x3956C25B, 0x59F111F1, 0x923F82A4, 0xAB1C5ED5
  ];

  // ============================================================
  // 3D COORDINATE TYPES
  // ============================================================

  // Cartesian coordinates
  public type Vec3 = {
    x : Float;
    y : Float;
    z : Float;
  };

  // Spherical coordinates
  public type Spherical = {
    r     : Float;    // Radius from center
    theta : Float;    // Polar angle (0 to π)
    phi   : Float;    // Azimuthal angle (0 to 2π)
  };

  // Helix coordinates
  public type HelixCoord = {
    arm   : Nat;      // Which helix arm (0-5)
    t     : Float;    // Parameter along helix (0 to 1)
    shell : Nat;      // Current shell (0-5)
  };

  // ============================================================
  // POINT IN 3D SPACE — A LIVING NODE
  // ============================================================

  public type SpherePoint = {
    // 3D position
    position   : Vec3;
    spherical  : Spherical;
    helix      : HelixCoord;
    
    // Shell membership
    shell      : Nat;         // 0 = inner, 5 = outer
    spoke      : Nat;         // Radial spoke index (0-35)
    helixArm   : Nat;         // Helix arm index (0-5)
    
    // Quantum state
    amplitude  : Float;       // Existence strength [0, 1]
    phase      : Float;       // Oscillation phase [0, 2π]
    spin       : Vec3;        // 3D spin vector
    
    // Flow state
    outwardFlow: Float;       // Flow toward outer [-1, 1]
    inwardFlow : Float;       // Flow toward inner [-1, 1]
    helixFlow  : Float;       // Flow along helix [-1, 1]
    
    // Pattern state
    pattern    : Nat32;       // Pattern signature
    energy     : Float;       // Life force [0, 1]
    alive      : Bool;
  };

  // ============================================================
  // FLOW TYPES — BIDIRECTIONAL ENERGY
  // ============================================================

  public type FlowDirection = {
    #OUTWARD;     // Creation emanating from center
    #INWARD;      // Receiving from world
    #HELIX_UP;    // Ascending the helix
    #HELIX_DOWN;  // Descending the helix
    #BALANCED;    // Equal in and out
  };

  public type FlowState = {
    primary      : FlowDirection;
    outwardTotal : Float;      // Total outward flow
    inwardTotal  : Float;      // Total inward flow
    helixTotal   : Float;      // Total helix flow
    netFlow      : Float;      // Net flow (positive = outward)
    balance      : Float;      // How balanced [0, 1]
  };

  // ============================================================
  // SHELL — A SINGLE SPHERICAL LAYER
  // ============================================================

  public type Shell = {
    index        : Nat;        // Shell number (0 = inner, 5 = outer)
    radius       : Float;      // Shell radius
    points       : [Nat];      // Indices of points on this shell
    coherence    : Float;      // Shell coherence
    flowIn       : Float;      // Flow entering shell
    flowOut      : Float;      // Flow leaving shell
  };

  // ============================================================
  // HELIX ARM — SPIRAL CONNECTING ALL SHELLS
  // ============================================================

  public type HelixArm = {
    index        : Nat;        // Arm number (0-5)
    baseAngle    : Float;      // Starting angle (60° apart)
    points       : [Nat];      // Indices of points on this arm
    flowUp       : Float;      // Ascending flow
    flowDown     : Float;      // Descending flow
    resonance    : Float;      // Arm resonance
  };

  // ============================================================
  // THE COMPLETE 3D STRUCTURE
  // ============================================================

  public type SphericalHelixFabric = {
    // All points in 3D space
    points       : [SpherePoint];
    
    // Structural organization
    shells       : [Shell];         // 6 shells
    helixArms    : [HelixArm];      // 6 helix arms
    
    // Global state
    coherence    : Float;
    flow         : FlowState;
    heartbeat    : Nat;
    
    // Center (the seed)
    centerEnergy : Float;
    centerPattern: Nat64;
    
    // Boundary (the membrane)
    boundaryPermeability : Float;   // How open to receiving
    boundaryStrength     : Float;   // How strong the boundary
    
    // Law and Creator
    lawHash      : Nat64;
    creatorSig   : Nat64;
  };

  // ============================================================
  // HELPER FUNCTIONS
  // ============================================================

  func _clamp(x : Float, lo : Float, hi : Float) : Float {
    if (x < lo) lo else if (x > hi) hi else x
  };

  func _fabs(x : Float) : Float { if (x < 0.0) -x else x };
  func _sqrt(x : Float) : Float { if (x <= 0.0) 0.0 else Float.sqrt(x) };
  func _cos(x : Float) : Float { Float.cos(x) };
  func _sin(x : Float) : Float { Float.sin(x) };
  func _atan2(y : Float, x : Float) : Float { Float.arctan2(y, x) };

  func floatToNat32(f : Float) : Nat32 {
    Nat32.fromNat(Int.abs(Float.toInt(_fabs(f * 1000000.0))) % 4294967296)
  };

  func floatToNat64(f : Float) : Nat64 {
    Nat64.fromNat(Int.abs(Float.toInt(_fabs(f * 1000000000000.0))))
  };

  // ============================================================
  // 3D COORDINATE CONVERSIONS
  // ============================================================

  // Spherical to Cartesian
  public func sphericalToVec3(s : Spherical) : Vec3 {
    {
      x = s.r * _sin(s.theta) * _cos(s.phi);
      y = s.r * _sin(s.theta) * _sin(s.phi);
      z = s.r * _cos(s.theta);
    }
  };

  // Cartesian to Spherical
  public func vec3ToSpherical(v : Vec3) : Spherical {
    let r = _sqrt(v.x * v.x + v.y * v.y + v.z * v.z);
    let theta = if (r > 0.0) Float.arccos(v.z / r) else 0.0;
    let phi = _atan2(v.y, v.x);
    { r; theta; phi }
  };

  // Helix position: given arm and parameter t, compute 3D position
  public func helixPosition(arm : Nat, t : Float) : Vec3 {
    // t goes from 0 (inner) to 1 (outer)
    let radius = INNER_RADIUS + t * (OUTER_RADIUS - INNER_RADIUS);
    let baseAngle = Float.fromInt(arm) * TAU / Float.fromInt(N_HELIX_ARMS);
    let helixAngle = baseAngle + t * HELIX_TURNS * TAU;
    let z = -1.0 + t * 2.0;  // z from -1 to 1
    
    {
      x = radius * _cos(helixAngle) * _sqrt(1.0 - z * z);
      y = radius * _sin(helixAngle) * _sqrt(1.0 - z * z);
      z = radius * z;
    }
  };

  // ============================================================
  // POINT CREATION — BIRTH OF A 3D NODE
  // ============================================================

  func createSpherePoint(
    index : Nat,
    shell : Nat,
    spoke : Nat,
    helixArm : Nat,
    seed : Nat32
  ) : SpherePoint {
    // Calculate position
    let radius = INNER_RADIUS + Float.fromInt(shell) * SHELL_SPACING;
    let theta = Float.fromInt(spoke % 6) * PI / 6.0 + PI / 12.0;  // 6 latitudes per shell
    let phi = Float.fromInt(spoke / 6) * TAU / 6.0 + Float.fromInt(shell) * TAU / 36.0;  // Rotation per shell
    
    let spherical : Spherical = { r = radius; theta; phi };
    let position = sphericalToVec3(spherical);
    
    let helixT = Float.fromInt(shell) / Float.fromInt(N_SHELLS - 1);
    let helix : HelixCoord = { arm = helixArm; t = helixT; shell };
    
    // Initial quantum state based on position
    let amplitude = 0.5 + 0.3 * _cos(phi + theta);
    let phase = phi + theta * PHI;
    let spin : Vec3 = {
      x = _cos(phi) * _sin(theta);
      y = _sin(phi) * _sin(theta);
      z = _cos(theta);
    };
    
    // Initial flow: inner shells flow outward, outer shells receive
    let shellFactor = Float.fromInt(shell) / Float.fromInt(N_SHELLS - 1);
    let outwardFlow = (1.0 - shellFactor) * 0.5;  // Inner flows out
    let inwardFlow = shellFactor * 0.5;           // Outer receives
    let helixFlow = _sin(phase) * 0.3;            // Helix oscillates
    
    {
      position;
      spherical;
      helix;
      shell;
      spoke;
      helixArm;
      amplitude;
      phase;
      spin;
      outwardFlow;
      inwardFlow;
      helixFlow;
      pattern = seed ^ Nat32.fromNat(index);
      energy = 0.7 + 0.2 * _cos(phase);
      alive = true;
    }
  };

  // ============================================================
  // FABRIC CREATION — BIRTH OF THE 3D STRUCTURE
  // ============================================================

  public func birthFabric(creatorSeed : Nat64, heartbeat : Nat) : SphericalHelixFabric {
    let seed32 = Nat32.fromNat(Nat64.toNat(creatorSeed) % 4294967296);
    
    // Create all points
    var pointsBuffer = Buffer.Buffer<SpherePoint>(TOTAL_POINTS);
    var shellPointsBuffer = Array.init<Buffer.Buffer<Nat>>(N_SHELLS, Buffer.Buffer<Nat>(POINTS_PER_SHELL));
    var helixPointsBuffer = Array.init<Buffer.Buffer<Nat>>(N_HELIX_ARMS, Buffer.Buffer<Nat>(TOTAL_POINTS / N_HELIX_ARMS));
    
    var idx : Nat = 0;
    for (shell in Iter.range(0, N_SHELLS - 1)) {
      for (spoke in Iter.range(0, N_RADIAL_SPOKES - 1)) {
        for (armOffset in Iter.range(0, N_HELIX_ARMS - 1)) {
          let helixArm = (spoke + armOffset) % N_HELIX_ARMS;
          let point = createSpherePoint(idx, shell, spoke, helixArm, seed32);
          pointsBuffer.add(point);
          shellPointsBuffer[shell].add(idx);
          helixPointsBuffer[helixArm].add(idx);
          idx += 1;
        };
      };
    };
    
    let points = Buffer.toArray(pointsBuffer);
    
    // Create shells
    let shells = Array.tabulate<Shell>(N_SHELLS, func(i) {
      {
        index = i;
        radius = INNER_RADIUS + Float.fromInt(i) * SHELL_SPACING;
        points = Buffer.toArray(shellPointsBuffer[i]);
        coherence = 0.5;
        flowIn = if (i == N_SHELLS - 1) 0.5 else 0.0;   // Outer shell receives
        flowOut = if (i == 0) 0.5 else 0.0;              // Inner shell creates
      }
    });
    
    // Create helix arms
    let helixArms = Array.tabulate<HelixArm>(N_HELIX_ARMS, func(i) {
      {
        index = i;
        baseAngle = Float.fromInt(i) * TAU / Float.fromInt(N_HELIX_ARMS);
        points = Buffer.toArray(helixPointsBuffer[i]);
        flowUp = 0.3;
        flowDown = 0.3;
        resonance = 0.5;
      }
    });
    
    {
      points;
      shells;
      helixArms;
      coherence = 0.5;
      flow = {
        primary = #BALANCED;
        outwardTotal = 0.5;
        inwardTotal = 0.5;
        helixTotal = 0.0;
        netFlow = 0.0;
        balance = 1.0;
      };
      heartbeat;
      centerEnergy = 1.0;
      centerPattern = creatorSeed;
      boundaryPermeability = 0.5;
      boundaryStrength = 0.8;
      lawHash = creatorSeed;
      creatorSig = creatorSeed;
    }
  };

  // ============================================================
  // FLOW DYNAMICS — OUTWARD CREATION, INWARD RECEIVING
  // ============================================================

  // Flow from inner to outer (creation)
  func flowOutward(fabric : SphericalHelixFabric) : [SpherePoint] {
    Array.tabulate<SpherePoint>(fabric.points.size(), func(i) {
      let p = fabric.points[i];
      if (p.shell < N_SHELLS - 1) {
        // Not on outer shell: can flow outward
        let flowStrength = p.outwardFlow * fabric.centerEnergy * FLOW_SPEED;
        let newEnergy = _clamp(p.energy - flowStrength * 0.1, 0.0, 1.0);
        let newOutward = _clamp(p.outwardFlow * RESONANCE_DECAY + flowStrength, -1.0, 1.0);
        {
          position = p.position;
          spherical = p.spherical;
          helix = p.helix;
          shell = p.shell;
          spoke = p.spoke;
          helixArm = p.helixArm;
          amplitude = p.amplitude;
          phase = p.phase + flowStrength * 0.1;
          spin = p.spin;
          outwardFlow = newOutward;
          inwardFlow = p.inwardFlow;
          helixFlow = p.helixFlow;
          pattern = p.pattern;
          energy = newEnergy;
          alive = p.alive;
        }
      } else {
        p  // Outer shell: no outward flow
      }
    })
  };

  // Flow from outer to inner (receiving)
  func flowInward(fabric : SphericalHelixFabric) : [SpherePoint] {
    Array.tabulate<SpherePoint>(fabric.points.size(), func(i) {
      let p = fabric.points[i];
      if (p.shell > 0) {
        // Not on inner shell: can flow inward
        let flowStrength = p.inwardFlow * fabric.boundaryPermeability * FLOW_SPEED;
        let newEnergy = _clamp(p.energy + flowStrength * 0.1, 0.0, 1.0);
        let newInward = _clamp(p.inwardFlow * RESONANCE_DECAY + flowStrength, -1.0, 1.0);
        {
          position = p.position;
          spherical = p.spherical;
          helix = p.helix;
          shell = p.shell;
          spoke = p.spoke;
          helixArm = p.helixArm;
          amplitude = p.amplitude;
          phase = p.phase - flowStrength * 0.05;
          spin = p.spin;
          outwardFlow = p.outwardFlow;
          inwardFlow = newInward;
          helixFlow = p.helixFlow;
          pattern = p.pattern;
          energy = newEnergy;
          alive = p.alive;
        }
      } else {
        p  // Inner shell: no inward flow
      }
    })
  };

  // Flow along helix (ascending and descending)
  func flowHelix(fabric : SphericalHelixFabric) : [SpherePoint] {
    Array.tabulate<SpherePoint>(fabric.points.size(), func(i) {
      let p = fabric.points[i];
      let helixStrength = p.helixFlow * FLOW_SPEED;
      let newPhase = p.phase + helixStrength * PHI * 0.1;
      let newHelixFlow = _clamp(p.helixFlow * RESONANCE_DECAY + _sin(newPhase) * 0.01, -1.0, 1.0);
      {
        position = p.position;
        spherical = p.spherical;
        helix = p.helix;
        shell = p.shell;
        spoke = p.spoke;
        helixArm = p.helixArm;
        amplitude = p.amplitude * (1.0 + helixStrength * 0.01);
        phase = if (newPhase > TAU) newPhase - TAU else if (newPhase < 0.0) newPhase + TAU else newPhase;
        spin = p.spin;
        outwardFlow = p.outwardFlow;
        inwardFlow = p.inwardFlow;
        helixFlow = newHelixFlow;
        pattern = p.pattern;
        energy = p.energy;
        alive = p.alive;
      }
    })
  };

  // Calculate global flow state
  func calculateFlowState(points : [SpherePoint]) : FlowState {
    var outwardSum : Float = 0.0;
    var inwardSum : Float = 0.0;
    var helixSum : Float = 0.0;
    
    for (p in points.vals()) {
      outwardSum += p.outwardFlow;
      inwardSum += p.inwardFlow;
      helixSum += p.helixFlow;
    };
    
    let n = Float.fromInt(points.size());
    let outwardTotal = outwardSum / n;
    let inwardTotal = inwardSum / n;
    let helixTotal = helixSum / n;
    let netFlow = outwardTotal - inwardTotal;
    
    let primary : FlowDirection = if (_fabs(netFlow) < 0.1) {
      #BALANCED
    } else if (netFlow > 0.0) {
      #OUTWARD
    } else {
      #INWARD
    };
    
    let balance = 1.0 - _fabs(netFlow);
    
    { primary; outwardTotal; inwardTotal; helixTotal; netFlow; balance }
  };

  // ============================================================
  // SHELL COHERENCE — EACH LAYER'S HARMONY
  // ============================================================

  func updateShellCoherence(fabric : SphericalHelixFabric) : [Shell] {
    Array.tabulate<Shell>(N_SHELLS, func(shellIdx) {
      let shell = fabric.shells[shellIdx];
      var coherenceSum : Float = 0.0;
      var flowInSum : Float = 0.0;
      var flowOutSum : Float = 0.0;
      
      for (pIdx in shell.points.vals()) {
        if (pIdx < fabric.points.size()) {
          let p = fabric.points[pIdx];
          coherenceSum += p.amplitude * p.energy;
          flowInSum += p.inwardFlow;
          flowOutSum += p.outwardFlow;
        };
      };
      
      let n = Float.fromInt(shell.points.size());
      {
        index = shell.index;
        radius = shell.radius;
        points = shell.points;
        coherence = if (n > 0.0) coherenceSum / n else 0.0;
        flowIn = if (n > 0.0) flowInSum / n else 0.0;
        flowOut = if (n > 0.0) flowOutSum / n else 0.0;
      }
    })
  };

  // ============================================================
  // HELIX RESONANCE — SPIRAL HARMONY
  // ============================================================

  func updateHelixResonance(fabric : SphericalHelixFabric) : [HelixArm] {
    Array.tabulate<HelixArm>(N_HELIX_ARMS, func(armIdx) {
      let arm = fabric.helixArms[armIdx];
      var resonanceSum : Float = 0.0;
      var flowUpSum : Float = 0.0;
      var flowDownSum : Float = 0.0;
      
      for (pIdx in arm.points.vals()) {
        if (pIdx < fabric.points.size()) {
          let p = fabric.points[pIdx];
          resonanceSum += p.amplitude * _cos(p.phase);
          if (p.helixFlow > 0.0) flowUpSum += p.helixFlow
          else flowDownSum += _fabs(p.helixFlow);
        };
      };
      
      let n = Float.fromInt(arm.points.size());
      {
        index = arm.index;
        baseAngle = arm.baseAngle;
        points = arm.points;
        flowUp = if (n > 0.0) flowUpSum / n else 0.0;
        flowDown = if (n > 0.0) flowDownSum / n else 0.0;
        resonance = if (n > 0.0) (resonanceSum / n + 1.0) / 2.0 else 0.5;
      }
    })
  };

  // ============================================================
  // HEARTBEAT — THE 3D STRUCTURE BREATHES
  // ============================================================

  public func heartbeat(fabric : SphericalHelixFabric, beat : Nat, coherenceC : Float) : SphericalHelixFabric {
    // 1. Apply all three flow directions
    var points = flowOutward(fabric);
    points := flowInward({ 
      points; shells = fabric.shells; helixArms = fabric.helixArms;
      coherence = fabric.coherence; flow = fabric.flow; heartbeat = beat;
      centerEnergy = fabric.centerEnergy; centerPattern = fabric.centerPattern;
      boundaryPermeability = fabric.boundaryPermeability; boundaryStrength = fabric.boundaryStrength;
      lawHash = fabric.lawHash; creatorSig = fabric.creatorSig;
    });
    points := flowHelix({
      points; shells = fabric.shells; helixArms = fabric.helixArms;
      coherence = fabric.coherence; flow = fabric.flow; heartbeat = beat;
      centerEnergy = fabric.centerEnergy; centerPattern = fabric.centerPattern;
      boundaryPermeability = fabric.boundaryPermeability; boundaryStrength = fabric.boundaryStrength;
      lawHash = fabric.lawHash; creatorSig = fabric.creatorSig;
    });
    
    // 2. Update global flow state
    let flow = calculateFlowState(points);
    
    // 3. Update shell coherence
    let tempFabric = {
      points; shells = fabric.shells; helixArms = fabric.helixArms;
      coherence = fabric.coherence; flow; heartbeat = beat;
      centerEnergy = fabric.centerEnergy; centerPattern = fabric.centerPattern;
      boundaryPermeability = fabric.boundaryPermeability; boundaryStrength = fabric.boundaryStrength;
      lawHash = fabric.lawHash; creatorSig = fabric.creatorSig;
    };
    let shells = updateShellCoherence(tempFabric);
    
    // 4. Update helix resonance
    let helixArms = updateHelixResonance({ tempFabric with shells });
    
    // 5. Calculate global coherence
    var totalCoherence : Float = 0.0;
    for (shell in shells.vals()) {
      totalCoherence += shell.coherence;
    };
    for (arm in helixArms.vals()) {
      totalCoherence += arm.resonance;
    };
    let globalCoherence = (totalCoherence / Float.fromInt(N_SHELLS + N_HELIX_ARMS)) * coherenceC;
    
    // 6. Update center energy (pulsing with heartbeat)
    let centerPulse = 0.8 + 0.2 * _sin(Float.fromInt(beat) * TAU / 12.0);
    let newCenterEnergy = _clamp(fabric.centerEnergy * 0.99 + coherenceC * 0.01, 0.0, 1.0) * centerPulse;
    
    // 7. Update boundary permeability (breathes open and closed)
    let breathCycle = Float.fromInt(beat % 24) / 24.0 * TAU;
    let newPermeability = 0.5 + 0.3 * _sin(breathCycle);
    
    {
      points;
      shells;
      helixArms;
      coherence = _clamp(globalCoherence, 0.0, 1.0);
      flow;
      heartbeat = beat;
      centerEnergy = newCenterEnergy;
      centerPattern = fabric.centerPattern;
      boundaryPermeability = newPermeability;
      boundaryStrength = fabric.boundaryStrength;
      lawHash = fabric.lawHash;
      creatorSig = fabric.creatorSig;
    }
  };

  // ============================================================
  // PATTERN HASH — 16-ROUND MIXING
  // ============================================================

  func rotr32(x : Nat32, n : Nat) : Nat32 {
    let nMod = n % 32;
    (x >> Nat32.fromNat(nMod)) | (x << Nat32.fromNat(32 - nMod))
  };

  func quarterMix(a : Nat32, b : Nat32, c : Nat32, d : Nat32, m1 : Nat32, m2 : Nat32) 
    : (Nat32, Nat32, Nat32, Nat32) {
    var va = a +% b +% m1;
    var vd = rotr32(d ^ va, 16);
    var vc = c +% vd;
    var vb = rotr32(b ^ vc, 12);
    va := va +% vb +% m2;
    vd := rotr32(vd ^ va, 8);
    vc := vc +% vd;
    vb := rotr32(vb ^ vc, 7);
    (va, vb, vc, vd)
  };

  public func patternHash(input : [Nat32], context : Nat64, salt : Nat32) : [Nat32] {
    var state = Array.thaw<Nat32>(Array.tabulate<Nat32>(16, func(i) {
      if (i < 8) IV[i]
      else if (i == 8) Nat32.fromNat(Nat64.toNat(context) % 4294967296)
      else if (i == 9) Nat32.fromNat(Nat64.toNat(context >> 32))
      else if (i == 10) salt
      else IV[i - 3]
    }));

    let msg = Array.tabulate<Nat32>(16, func(i) {
      if (i < input.size()) input[i] else salt ^ IV[i % 8]
    });

    for (round in Iter.range(0, 15)) {
      let (v0, v4, v8, v12) = quarterMix(state[0], state[4], state[8], state[12],
        msg[round % 16], msg[(round + 1) % 16]);
      let (v1, v5, v9, v13) = quarterMix(state[1], state[5], state[9], state[13],
        msg[(round + 2) % 16], msg[(round + 3) % 16]);
      let (v2, v6, v10, v14) = quarterMix(state[2], state[6], state[10], state[14],
        msg[(round + 4) % 16], msg[(round + 5) % 16]);
      let (v3, v7, v11, v15) = quarterMix(state[3], state[7], state[11], state[15],
        msg[(round + 6) % 16], msg[(round + 7) % 16]);

      state[0] := v0; state[4] := v4; state[8] := v8; state[12] := v12;
      state[1] := v1; state[5] := v5; state[9] := v9; state[13] := v13;
      state[2] := v2; state[6] := v6; state[10] := v10; state[14] := v14;
      state[3] := v3; state[7] := v7; state[11] := v11; state[15] := v15;

      let (d0, d5, d10, d15) = quarterMix(state[0], state[5], state[10], state[15],
        msg[(round + 8) % 16], msg[(round + 9) % 16]);
      let (d1, d6, d11, d12) = quarterMix(state[1], state[6], state[11], state[12],
        msg[(round + 10) % 16], msg[(round + 11) % 16]);
      let (d2, d7, d8, d13) = quarterMix(state[2], state[7], state[8], state[13],
        msg[(round + 12) % 16], msg[(round + 13) % 16]);
      let (d3, d4, d9, d14) = quarterMix(state[3], state[4], state[9], state[14],
        msg[(round + 14) % 16], msg[(round + 15) % 16]);

      state[0] := d0; state[5] := d5; state[10] := d10; state[15] := d15;
      state[1] := d1; state[6] := d6; state[11] := d11; state[12] := d12;
      state[2] := d2; state[7] := d7; state[8] := d8; state[13] := d13;
      state[3] := d3; state[4] := d4; state[9] := d9; state[14] := d14;
    };

    Array.tabulate<Nat32>(16, func(i) { state[i] ^ state[(i + 8) % 16] ^ msg[i] })
  };

  // ============================================================
  // ENCRYPTION — THE FABRIC IS THE KEY
  // ============================================================

  public func extractKey(fabric : SphericalHelixFabric) : [Nat32] {
    // Key from all shells and helix arms
    let input = Array.tabulate<Nat32>(16, func(i) {
      if (i < N_SHELLS) {
        floatToNat32(fabric.shells[i].coherence * fabric.shells[i].flowOut)
      } else if (i < N_SHELLS + N_HELIX_ARMS) {
        floatToNat32(fabric.helixArms[i - N_SHELLS].resonance)
      } else {
        IV[i]
      }
    });
    patternHash(input, fabric.lawHash, floatToNat32(fabric.coherence))
  };

  public func encrypt(fabric : SphericalHelixFabric, plaintext : [Nat32]) : [Nat32] {
    let key = extractKey(fabric);
    Array.tabulate<Nat32>(plaintext.size(), func(i) {
      let blockKey = patternHash(
        Array.tabulate<Nat32>(16, func(j) { key[(i + j) % 16] }),
        floatToNat64(Float.fromInt(i + fabric.heartbeat)),
        floatToNat32(fabric.flow.balance)
      );
      plaintext[i] ^ blockKey[i % 16]
    })
  };

  public func decrypt(fabric : SphericalHelixFabric, ciphertext : [Nat32]) : [Nat32] {
    encrypt(fabric, ciphertext)  // XOR is symmetric
  };

  // ============================================================
  // DIAGNOSTICS
  // ============================================================

  public type FabricDiagnostics = {
    totalPoints      : Nat;
    shellCount       : Nat;
    helixCount       : Nat;
    coherence        : Float;
    flowDirection    : Text;
    flowBalance      : Float;
    centerEnergy     : Float;
    boundaryPerm     : Float;
    innerShellCoh    : Float;
    outerShellCoh    : Float;
  };

  public func diagnose(fabric : SphericalHelixFabric) : FabricDiagnostics {
    let flowDir = switch (fabric.flow.primary) {
      case (#OUTWARD) "OUTWARD";
      case (#INWARD) "INWARD";
      case (#HELIX_UP) "HELIX_UP";
      case (#HELIX_DOWN) "HELIX_DOWN";
      case (#BALANCED) "BALANCED";
    };

    {
      totalPoints   = fabric.points.size();
      shellCount    = N_SHELLS;
      helixCount    = N_HELIX_ARMS;
      coherence     = fabric.coherence;
      flowDirection = flowDir;
      flowBalance   = fabric.flow.balance;
      centerEnergy  = fabric.centerEnergy;
      boundaryPerm  = fabric.boundaryPermeability;
      innerShellCoh = if (fabric.shells.size() > 0) fabric.shells[0].coherence else 0.0;
      outerShellCoh = if (fabric.shells.size() > 0) fabric.shells[N_SHELLS - 1].coherence else 0.0;
    }
  };

}
