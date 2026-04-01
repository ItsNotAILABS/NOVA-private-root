// ============================================================
// BEE SWARM INTELLIGENCE — COLLECTIVE DECISION-MAKING MODULE
// Waggle dance encoding, hive mind consensus
// 100,000+ individuals, no central control
// Democratic nest selection, optimal foraging
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com
// ============================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";

module {

  // ── Constants ─────────────────────────────────────────────────
  let S0 : Float = 0.75;
  let SOVEREIGN_CEILING : Float = 9.0;
  let NUM_SCOUTS : Nat = 100;      // Scout bees
  let NUM_FORAGERS : Nat = 1000;   // Forager bees
  let QUORUM_THRESHOLD : Float = 0.8;

  // ── Types ─────────────────────────────────────────────────────
  public type WaggleDance = {
    angle      : Float;   // Direction relative to sun (radians)
    duration   : Float;   // Duration encodes distance
    vigor      : Float;   // Dance intensity (quality signal)
    sourceId   : Nat;     // Which resource/site
    dancerId   : Nat;     // Which bee is dancing
  };

  public type ResourceSite = {
    id           : Nat;
    direction    : Float;   // Radians from hive
    distance     : Float;   // Meters
    quality      : Float;   // Nectar/pollen quality
    quantity     : Float;   // Remaining resource
    lastVisit    : Nat;
    visitorCount : Nat;     // Bees currently there
    danceSupport : Float;   // Cumulative dance endorsement
  };

  public type ScoutBee = {
    id           : Nat;
    state        : BeeState;
    committedTo  : ?Nat;     // Site ID if committed
    energy       : Float;
    exploration  : Float;    // Tendency to explore vs exploit
  };

  public type BeeState = {
    #Searching;
    #Dancing;
    #Following;
    #Recruiting;
    #Foraging;
    #Resting;
  };

  public type ForagerBee = {
    id           : Nat;
    assignedSite : ?Nat;
    nectarLoad   : Float;
    tripCount    : Nat;
  };

  public type HiveState = {
    // Scouts and foragers
    scouts       : [ScoutBee];
    foragers     : [ForagerBee];

    // Known resources
    resources    : [ResourceSite];

    // Dance floor activity
    activeDances : [WaggleDance];
    danceFloorActivity: Float;

    // Collective decision state
    currentConsensus: ?Nat;   // Site with most support
    consensusStrength: Float;
    quorumReached: Bool;

    // Hive conditions
    honeyStores  : Float;
    pollenStores : Float;
    broodNeed    : Float;     // Demand for foraging
    temperature  : Float;     // Hive temp regulation

    // Time tracking
    sunAngle     : Float;     // For dance interpretation
    timeOfDay    : Float;     // 0-1 daily cycle

    beatNum      : Nat;
  };

  // ── Helpers ───────────────────────────────────────────────────
  func _clamp(x: Float, lo: Float, hi: Float) : Float {
    if (x < lo) { lo } else if (x > hi) { hi } else { x }
  };

  // ── Waggle Dance Encoding ─────────────────────────────────────
  // Encode resource location into dance parameters
  public func encodeWaggle(
    direction: Float, distance: Float, quality: Float,
    sourceId: Nat, dancerId: Nat
  ) : WaggleDance {
    // Duration: ~1 second per 1km (75ms per 75m)
    let dur = distance / 1000.0;

    // Vigor proportional to quality
    let vig = _clamp(quality, 0.0, 1.0);

    {
      angle = direction;
      duration = dur;
      vigor = vig;
      sourceId = sourceId;
      dancerId = dancerId;
    }
  };

  // Decode dance back to location estimate
  public func decodeWaggle(dance: WaggleDance, sunAngle: Float) : (Float, Float) {
    // Direction: dance angle + sun compensation
    let absoluteDir = dance.angle + sunAngle;

    // Distance: duration * 1000
    let dist = dance.duration * 1000.0;

    (absoluteDir, dist)
  };

  // ── Dance Evaluation ──────────────────────────────────────────
  // Bees evaluate dances probabilistically based on vigor
  public func evaluateDance(dance: WaggleDance, observerBias: Float) : Bool {
    // Higher vigor = more likely to follow
    let followProb = dance.vigor * 0.8 + observerBias * 0.2;
    followProb > 0.5  // Simplified threshold decision
  };

  // ── Resource Discovery ────────────────────────────────────────
  public func discoverResource(
    resources: [ResourceSite],
    direction: Float, distance: Float, quality: Float, beat: Nat
  ) : [ResourceSite] {
    // Check if this is a known resource
    var found = false;
    let updated = Array.map<ResourceSite, ResourceSite>(resources, func(r) {
      let dirDiff = Float.abs(r.direction - direction);
      let distDiff = Float.abs(r.distance - distance);

      if (dirDiff < 0.1 and distDiff < 50.0) {
        found := true;
        {
          id = r.id;
          direction = r.direction;
          distance = r.distance;
          quality = 0.9 * r.quality + 0.1 * quality;  // Update quality estimate
          quantity = r.quantity;
          lastVisit = beat;
          visitorCount = r.visitorCount + 1;
          danceSupport = r.danceSupport;
        }
      } else { r }
    });

    if (not found) {
      // New resource discovered
      Array.append<ResourceSite>(updated, [{
        id = resources.size();
        direction = direction;
        distance = distance;
        quality = quality;
        quantity = 1.0;  // Unknown, assume full
        lastVisit = beat;
        visitorCount = 1;
        danceSupport = 0.0;
      }])
    } else { updated }
  };

  // ── Dance Support Accumulation ────────────────────────────────
  public func accumulateDanceSupport(
    resources: [ResourceSite], dances: [WaggleDance]
  ) : [ResourceSite] {
    // Count support for each resource from active dances
    var supportMap = Array.init<Float>(resources.size(), 0.0);

    for (dance in dances.vals()) {
      if (dance.sourceId < resources.size()) {
        supportMap[dance.sourceId] := supportMap[dance.sourceId] + dance.vigor;
      };
    };

    Array.tabulate<ResourceSite>(resources.size(), func(i) {
      let r = resources[i];
      {
        id = r.id;
        direction = r.direction;
        distance = r.distance;
        quality = r.quality;
        quantity = r.quantity;
        lastVisit = r.lastVisit;
        visitorCount = r.visitorCount;
        danceSupport = 0.9 * r.danceSupport + 0.1 * supportMap[i];
      }
    })
  };

  // ── Consensus Detection ───────────────────────────────────────
  public func detectConsensus(resources: [ResourceSite]) : (?Nat, Float) {
    if (resources.size() == 0) {
      return (null, 0.0);
    };

    var bestSite : ?Nat = null;
    var bestSupport : Float = 0.0;
    var totalSupport : Float = 0.0;

    var i = 0;
    for (r in resources.vals()) {
      totalSupport += r.danceSupport;
      if (r.danceSupport > bestSupport) {
        bestSupport := r.danceSupport;
        bestSite := ?i;
      };
      i += 1;
    };

    let consensusStrength = if (totalSupport > 0.0) {
      bestSupport / totalSupport
    } else { 0.0 };

    (bestSite, consensusStrength)
  };

  // ── Scout Behavior ────────────────────────────────────────────
  public func updateScout(
    scout: ScoutBee, dances: [WaggleDance], resources: [ResourceSite]
  ) : ScoutBee {
    switch (scout.state) {
      case (#Searching) {
        // Random exploration, may find resource
        if (scout.energy > 0.3) {
          {
            id = scout.id;
            state = #Searching;
            committedTo = scout.committedTo;
            energy = scout.energy - 0.01;
            exploration = scout.exploration;
          }
        } else {
          {
            id = scout.id;
            state = #Resting;
            committedTo = scout.committedTo;
            energy = scout.energy;
            exploration = scout.exploration;
          }
        }
      };
      case (#Dancing) {
        // Continue dancing if committed to good site
        switch (scout.committedTo) {
          case (null) {
            { id = scout.id; state = #Searching; committedTo = null;
              energy = scout.energy; exploration = scout.exploration; }
          };
          case (?siteId) {
            // Dance until tired
            if (scout.energy > 0.2) {
              { id = scout.id; state = #Dancing; committedTo = ?siteId;
                energy = scout.energy - 0.02; exploration = scout.exploration; }
            } else {
              { id = scout.id; state = #Resting; committedTo = ?siteId;
                energy = scout.energy; exploration = scout.exploration; }
            }
          };
        }
      };
      case (#Following) {
        // Watch dances, may commit to advertised site
        var bestDance : ?WaggleDance = null;
        var bestVigor : Float = 0.0;
        for (d in dances.vals()) {
          if (d.vigor > bestVigor) {
            bestVigor := d.vigor;
            bestDance := ?d;
          };
        };

        switch (bestDance) {
          case (null) {
            { id = scout.id; state = #Searching; committedTo = null;
              energy = scout.energy; exploration = scout.exploration; }
          };
          case (?dance) {
            if (evaluateDance(dance, scout.exploration)) {
              { id = scout.id; state = #Foraging; committedTo = ?dance.sourceId;
                energy = scout.energy; exploration = scout.exploration; }
            } else {
              { id = scout.id; state = #Following; committedTo = null;
                energy = scout.energy; exploration = scout.exploration; }
            }
          };
        }
      };
      case (#Recruiting) {
        // Recruiting others to site
        { id = scout.id; state = #Dancing; committedTo = scout.committedTo;
          energy = scout.energy - 0.01; exploration = scout.exploration; }
      };
      case (#Foraging) {
        // At resource site
        { id = scout.id; state = #Dancing; committedTo = scout.committedTo;
          energy = _clamp(scout.energy - 0.005, 0.0, 1.0); exploration = scout.exploration; }
      };
      case (#Resting) {
        // Recovering energy
        let newEnergy = _clamp(scout.energy + 0.05, 0.0, 1.0);
        if (newEnergy > 0.8) {
          { id = scout.id; state = #Following; committedTo = null;
            energy = newEnergy; exploration = scout.exploration; }
        } else {
          { id = scout.id; state = #Resting; committedTo = scout.committedTo;
            energy = newEnergy; exploration = scout.exploration; }
        }
      };
    }
  };

  // ── Forager Assignment ────────────────────────────────────────
  public func assignForagers(
    foragers: [ForagerBee], consensus: ?Nat, consensusStrength: Float
  ) : [ForagerBee] {
    Array.map<ForagerBee, ForagerBee>(foragers, func(f) {
      // If strong consensus, assign unassigned foragers
      switch (consensus) {
        case (null) { f };
        case (?siteId) {
          switch (f.assignedSite) {
            case (null) {
              if (consensusStrength > 0.5) {
                { id = f.id; assignedSite = ?siteId; nectarLoad = 0.0; tripCount = f.tripCount }
              } else { f }
            };
            case (?_) { f };
          }
        };
      }
    })
  };

  // ── Full Beat Update ──────────────────────────────────────────
  public func beatHive(
    state: HiveState,
    newDiscoveries: [(Float, Float, Float)],  // (direction, distance, quality)
    consumptionRate: Float
  ) : HiveState {
    // Process new discoveries
    var newResources = state.resources;
    for ((dir, dist, qual) in newDiscoveries.vals()) {
      newResources := discoverResource(newResources, dir, dist, qual, state.beatNum + 1);
    };

    // Generate dances from committed scouts
    var newDances : [WaggleDance] = [];
    for (scout in state.scouts.vals()) {
      switch (scout.state, scout.committedTo) {
        case (#Dancing, ?siteId) {
          if (siteId < newResources.size()) {
            let r = newResources[siteId];
            let dance = encodeWaggle(r.direction, r.distance, r.quality, siteId, scout.id);
            newDances := Array.append<WaggleDance>(newDances, [dance]);
          };
        };
        case (_, _) {};
      };
    };

    // Update resource dance support
    newResources := accumulateDanceSupport(newResources, newDances);

    // Detect consensus
    let (newConsensus, newStrength) = detectConsensus(newResources);
    let quorumReached = newStrength >= QUORUM_THRESHOLD;

    // Update scouts
    let newScouts = Array.map<ScoutBee, ScoutBee>(state.scouts, func(s) {
      updateScout(s, newDances, newResources)
    });

    // Assign foragers
    let newForagers = assignForagers(state.foragers, newConsensus, newStrength);

    // Update stores
    var foragingReturn : Float = 0.0;
    for (f in newForagers.vals()) {
      if (f.assignedSite != null) {
        foragingReturn += 0.001;  // Each active forager brings back resources
      };
    };
    let newHoney = _clamp(state.honeyStores + foragingReturn - consumptionRate, 0.0, 1.0);
    let newPollen = _clamp(state.pollenStores + foragingReturn * 0.3 - consumptionRate * 0.2, 0.0, 1.0);

    // Update brood need (drives foraging urgency)
    let newBroodNeed = _clamp(
      state.broodNeed + consumptionRate * 0.5 - foragingReturn,
      0.0, 1.0
    );

    // Dance floor activity
    let newActivity = Float.fromInt(newDances.size()) / Float.fromInt(NUM_SCOUTS) * 10.0;

    // Sun angle advances
    let newSunAngle = (state.sunAngle + 0.001) % (2.0 * 3.14159);
    let newTimeOfDay = (state.timeOfDay + 0.001) % 1.0;

    {
      scouts = newScouts;
      foragers = newForagers;
      resources = newResources;
      activeDances = newDances;
      danceFloorActivity = _clamp(newActivity, 0.0, 1.0);
      currentConsensus = newConsensus;
      consensusStrength = newStrength;
      quorumReached = quorumReached;
      honeyStores = newHoney;
      pollenStores = newPollen;
      broodNeed = newBroodNeed;
      temperature = state.temperature;
      sunAngle = newSunAngle;
      timeOfDay = newTimeOfDay;
      beatNum = state.beatNum + 1;
    }
  };

  // ── Init ─────────────────────────────────────────────────────
  public func initHive() : HiveState {
    {
      scouts = Array.tabulate<ScoutBee>(NUM_SCOUTS, func(i) {
        {
          id = i;
          state = #Searching;
          committedTo = null;
          energy = 0.8;
          exploration = 0.3 + Float.fromInt(i % 5) * 0.1;
        }
      });
      foragers = Array.tabulate<ForagerBee>(100, func(i) {  // Start with subset
        {
          id = i;
          assignedSite = null;
          nectarLoad = 0.0;
          tripCount = 0;
        }
      });
      resources = [];
      activeDances = [];
      danceFloorActivity = 0.0;
      currentConsensus = null;
      consensusStrength = 0.0;
      quorumReached = false;
      honeyStores = 0.5;
      pollenStores = 0.5;
      broodNeed = 0.3;
      temperature = 0.95;  // ~35°C normalized
      sunAngle = 0.0;
      timeOfDay = 0.25;
      beatNum = 0;
    }
  };

  // ── Summary ───────────────────────────────────────────────────
  public type HiveSummary = {
    activeScouts      : Nat;
    knownResources    : Nat;
    consensusStrength : Float;
    quorumReached     : Bool;
    honeyStores       : Float;
    danceActivity     : Float;
  };

  public func summary(state: HiveState) : HiveSummary {
    var activeScouts : Nat = 0;
    for (s in state.scouts.vals()) {
      switch (s.state) {
        case (#Resting) {};
        case (_) { activeScouts += 1 };
      };
    };

    {
      activeScouts = activeScouts;
      knownResources = state.resources.size();
      consensusStrength = state.consensusStrength;
      quorumReached = state.quorumReached;
      honeyStores = state.honeyStores;
      danceActivity = state.danceFloorActivity;
    }
  };

}
