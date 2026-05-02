// ═══════════════════════════════════════════════════════════════════════════════
// FLIGHT INTELLIGENCE — Predictive Flight Operations Canister
// BUILD №49 — NOVA V5 Airport Application
// ═══════════════════════════════════════════════════════════════════════════════
//
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// MEDINA TECH — SOVEREIGN ORGANISM ARCHITECTURE
// Dallas, Texas, United States of America
//
// Purpose: Predictive flight operations and passenger impact analysis
// - Delay cascade prediction
// - Connection risk scoring
// - Rebooking recommendations
// - Baggage tracking integration
// - Weather correlation
//
// ═══════════════════════════════════════════════════════════════════════════════

import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Debug "mo:base/Debug";
import Float "mo:base/Float";
import HashMap "mo:base/HashMap";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Option "mo:base/Option";
import Principal "mo:base/Principal";
import Text "mo:base/Text";
import Time "mo:base/Time";

actor FlightIntelligence {

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 1 — CONSTANTS & TYPES
  // ═══════════════════════════════════════════════════════════════════════════

  private let PHI : Float = 1.6180339887498948482;
  private let HEARTBEAT_MS : Nat = 873;

  public type FlightStatus = {
    #Scheduled;
    #Boarding;
    #Departed;
    #Delayed;
    #Cancelled;
    #Arrived;
  };

  public type DelayPrediction = {
    flightNumber : Text;
    predictedDelayMinutes : Nat;
    confidence : Float; // 0.0 to 1.0
    cascadeRisk : Float; // φ-weighted impact score
    affectedConnections : Nat;
  };

  public type ConnectionRisk = {
    passengerId : Text;
    inboundFlight : Text;
    outboundFlight : Text;
    riskScore : Float; // φ-weighted: 0=safe, 1=at-risk, >1=miss probable
    recommendedAction : Text;
  };

  public type RebookingOption = {
    originalFlight : Text;
    alternativeFlight : Text;
    costDelta : Int; // cents (negative = cheaper, positive = more expensive)
    timeAdjustment : Int; // minutes (negative = earlier, positive = later)
    availability : Nat; // seats available
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 2 — DELAY CASCADE PREDICTION
  // ═══════════════════════════════════════════════════════════════════════════

  private stable var delayPredictionEntries : [(Text, DelayPrediction)] = [];
  private var delayPredictions = HashMap.HashMap<Text, DelayPrediction>(16, Text.equal, Text.hash);

  public func predictDelayCascade(flightNumber : Text, initialDelayMinutes : Nat) : async DelayPrediction {
    // Simplified cascade model: each delayed flight affects downstream flights
    // with exponential decay based on φ

    let baseImpact = Float.fromInt(initialDelayMinutes);
    let cascadeFactor = baseImpact * PHI; // φ-weighted
    let confidence = 0.75; // Base confidence
    let affectedCount = Nat.min(initialDelayMinutes / 15, 10); // Estimate affected connections

    let prediction = {
      flightNumber = flightNumber;
      predictedDelayMinutes = initialDelayMinutes;
      confidence = confidence;
      cascadeRisk = cascadeFactor;
      affectedConnections = affectedCount;
    };

    delayPredictions.put(flightNumber, prediction);
    prediction
  };

  public query func getDelayPrediction(flightNumber : Text) : async ?DelayPrediction {
    delayPredictions.get(flightNumber)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 3 — CONNECTION RISK SCORING
  // ═══════════════════════════════════════════════════════════════════════════

  private stable var connectionRiskEntries : [(Text, ConnectionRisk)] = [];
  private var connectionRisks = HashMap.HashMap<Text, ConnectionRisk>(16, Text.equal, Text.hash);

  public func scoreConnectionRisk(
    passengerId : Text,
    inbound : Text,
    outbound : Text,
    connectionMinutes : Nat,
    walkingMinutes : Nat
  ) : async ConnectionRisk {
    // φ-weighted risk scoring
    // Risk = 0 when time > 90min
    // Risk = 1 when time = minimum (30min)
    // Risk > 1 when time < minimum

    let availableTime = Float.fromInt(connectionMinutes);
    let minimumTime = Float.fromInt(30 + walkingMinutes);

    let riskScore = if (availableTime >= 90.0) {
      0.0
    } else if (availableTime >= minimumTime) {
      (90.0 - availableTime) / 60.0 * PHI // φ-weighted growth
    } else {
      PHI + (minimumTime - availableTime) / 10.0 // Exponential risk
    };

    let action = if (riskScore < 0.3) {
      "Connection safe - proceed normally"
    } else if (riskScore < 0.7) {
      "Monitor connection - be ready at gate"
    } else if (riskScore < 1.0) {
      "High risk - contact airline for rebooking options"
    } else {
      "Connection will be missed - rebook immediately"
    };

    let risk = {
      passengerId = passengerId;
      inboundFlight = inbound;
      outboundFlight = outbound;
      riskScore = riskScore;
      recommendedAction = action;
    };

    let key = passengerId # "-" # outbound;
    connectionRisks.put(key, risk);
    risk
  };

  public query func getConnectionRisk(passengerId : Text, outboundFlight : Text) : async ?ConnectionRisk {
    let key = passengerId # "-" # outboundFlight;
    connectionRisks.get(key)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 4 — REBOOKING RECOMMENDATIONS
  // ═══════════════════════════════════════════════════════════════════════════

  public func findRebookingOptions(
    originalFlight : Text,
    destination : Text,
    departureWindow : Nat // hours around original departure
  ) : async [RebookingOption] {
    // Simplified: return mock rebooking options
    // In production, this would query real flight inventory

    let buffer = Buffer.Buffer<RebookingOption>(0);

    // Option 1: Earlier flight
    buffer.add({
      originalFlight = originalFlight;
      alternativeFlight = originalFlight # "-EARLY";
      costDelta = 5000; // $50 more
      timeAdjustment = -120; // 2 hours earlier
      availability = 5;
    });

    // Option 2: Later flight
    buffer.add({
      originalFlight = originalFlight;
      alternativeFlight = originalFlight # "-LATE";
      costDelta = 0; // Same price
      timeAdjustment = 180; // 3 hours later
      availability = 12;
    });

    // Option 3: Connecting flight via hub
    buffer.add({
      originalFlight = originalFlight;
      alternativeFlight = originalFlight # "-CONNECT";
      costDelta = -2000; // $20 cheaper
      timeAdjustment = 240; // 4 hours later (includes connection)
      availability = 8;
    });

    Buffer.toArray(buffer)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 5 — BAGGAGE TRACKING INTEGRATION
  // ═══════════════════════════════════════════════════════════════════════════

  public type BaggageStatus = {
    #CheckedIn;
    #Loaded;
    #InTransit;
    #Arrived;
    #Delayed;
    #Lost;
  };

  public type Baggage = {
    tagNumber : Text;
    passengerId : Text;
    flightNumber : Text;
    status : BaggageStatus;
    lastLocation : Text;
    lastUpdate : Int;
  };

  private stable var baggageEntries : [(Text, Baggage)] = [];
  private var baggageTracking = HashMap.HashMap<Text, Baggage>(16, Text.equal, Text.hash);

  public shared(msg) func updateBaggageStatus(tagNumber : Text, status : BaggageStatus, location : Text) : async Bool {
    switch (baggageTracking.get(tagNumber)) {
      case null { false };
      case (?bag) {
        let updated = {
          tagNumber = bag.tagNumber;
          passengerId = bag.passengerId;
          flightNumber = bag.flightNumber;
          status = status;
          lastLocation = location;
          lastUpdate = Time.now();
        };
        baggageTracking.put(tagNumber, updated);
        true
      };
    };
  };

  public query func getBaggageStatus(tagNumber : Text) : async ?Baggage {
    baggageTracking.get(tagNumber)
  };

  public query func getPassengerBaggage(passengerId : Text) : async [Baggage] {
    let buffer = Buffer.Buffer<Baggage>(0);
    for ((_, bag) in baggageTracking.entries()) {
      if (bag.passengerId == passengerId) {
        buffer.add(bag);
      };
    };
    Buffer.toArray(buffer)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 6 — WEATHER CORRELATION
  // ═══════════════════════════════════════════════════════════════════════════

  public type WeatherCondition = {
    #Clear;
    #Cloudy;
    #Rain;
    #Snow;
    #Thunderstorm;
    #Fog;
  };

  public type WeatherImpact = {
    airport : Text;
    condition : WeatherCondition;
    visibility : Nat; // meters
    windSpeed : Nat; // knots
    delayProbability : Float; // 0.0 to 1.0
  };

  public func assessWeatherImpact(airport : Text, condition : WeatherCondition, visibility : Nat, windSpeed : Nat) : async WeatherImpact {
    // Simplified weather impact model
    let baseProbability = switch (condition) {
      case (#Clear) { 0.05 };
      case (#Cloudy) { 0.10 };
      case (#Rain) { 0.25 };
      case (#Snow) { 0.60 };
      case (#Thunderstorm) { 0.85 };
      case (#Fog) { 0.70 };
    };

    // Adjust for visibility and wind
    let visibilityFactor = if (visibility < 1000) { 0.3 } else if (visibility < 3000) { 0.15 } else { 0.0 };
    let windFactor = if (windSpeed > 40) { 0.25 } else if (windSpeed > 25) { 0.10 } else { 0.0 };

    let totalProbability = Float.min(1.0, baseProbability + visibilityFactor + windFactor);

    {
      airport = airport;
      condition = condition;
      visibility = visibility;
      windSpeed = windSpeed;
      delayProbability = totalProbability;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 7 — SYSTEM STATUS
  // ═══════════════════════════════════════════════════════════════════════════

  public type SystemStatus = {
    delayPredictionCount : Nat;
    connectionRiskCount : Nat;
    baggageCount : Nat;
  };

  public query func getSystemStatus() : async SystemStatus {
    {
      delayPredictionCount = delayPredictions.size();
      connectionRiskCount = connectionRisks.size();
      baggageCount = baggageTracking.size();
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // UPGRADE HOOKS
  // ═══════════════════════════════════════════════════════════════════════════

  system func preupgrade() {
    delayPredictionEntries := Iter.toArray(delayPredictions.entries());
    connectionRiskEntries := Iter.toArray(connectionRisks.entries());
    baggageEntries := Iter.toArray(baggageTracking.entries());
  };

  system func postupgrade() {
    delayPredictions := HashMap.fromIter<Text, DelayPrediction>(delayPredictionEntries.vals(), 16, Text.equal, Text.hash);
    connectionRisks := HashMap.fromIter<Text, ConnectionRisk>(connectionRiskEntries.vals(), 16, Text.equal, Text.hash);
    baggageTracking := HashMap.fromIter<Text, Baggage>(baggageEntries.vals(), 16, Text.equal, Text.hash);

    delayPredictionEntries := [];
    connectionRiskEntries := [];
    baggageEntries := [];
  };
}
