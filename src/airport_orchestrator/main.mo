// ═══════════════════════════════════════════════════════════════════════════════
// AIRPORT ORCHESTRATOR — Sovereign Airport Intelligence Canister
// BUILD №49 — NOVA V5 Airport Application
// ═══════════════════════════════════════════════════════════════════════════════
//
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// MEDINA TECH — SOVEREIGN ORGANISM ARCHITECTURE
// Dallas, Texas, United States of America
//
// NOVA is Layer Zero — the sovereign organism.
// This canister is a substrate application serving airport operations.
//
// Architecture: Central coordination for airport-specific operations including
// flight schedules, gate assignments, passenger flows, booking engine, IoT devices,
// personalization, connections, social matching, loyalty & gamification, partner
// ecosystem, compliance & privacy, emergency & security, and heartbeat synchronization.
//
// ═══════════════════════════════════════════════════════════════════════════════

import Array "mo:base/Array";
import Blob "mo:base/Blob";
import Buffer "mo:base/Buffer";
import Debug "mo:base/Debug";
import Hash "mo:base/Hash";
import HashMap "mo:base/HashMap";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Option "mo:base/Option";
import Principal "mo:base/Principal";
import Text "mo:base/Text";
import Time "mo:base/Time";
import Timer "mo:base/Timer";

actor AirportOrchestrator {

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 1 — CONSTANTS & CONFIGURATION
  // ═══════════════════════════════════════════════════════════════════════════

  // Sovereign constants
  private let HEARTBEAT_MS : Nat = 873; // φ⁴ × Schumann = 873ms (NOVA sovereign creation)
  private let PHI : Float = 1.6180339887498948482; // Golden ratio (19 decimal places)

  // Capacity constants
  private let MAX_FLIGHTS : Nat = 10000;
  private let MAX_GATES : Nat = 200;
  private let MAX_PASSENGERS : Nat = 500000; // Target scale from spec
  private let MAX_PARTNERS : Nat = 1000;
  private let MAX_IOT_DEVICES : Nat = 5000;

  // System state
  private stable var bootTime : Int = 0;
  private stable var tickCount : Nat = 0;
  private stable var isInitialized : Bool = false;
  private stable var owner : Principal = Principal.fromText("aaaaa-aa");

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 2 — FLIGHT SCHEDULE MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════

  public type FlightStatus = {
    #Scheduled;
    #Boarding;
    #Departed;
    #Delayed;
    #Cancelled;
    #Arrived;
  };

  public type Flight = {
    flightNumber : Text;
    airline : Text;
    origin : Text;
    destination : Text;
    scheduledDeparture : Int;
    scheduledArrival : Int;
    actualDeparture : ?Int;
    actualArrival : ?Int;
    gate : ?Text;
    status : FlightStatus;
    delayMinutes : Nat;
  };

  private stable var flightEntries : [(Text, Flight)] = [];
  private var flights = HashMap.HashMap<Text, Flight>(16, Text.equal, Text.hash);

  public shared(msg) func addFlight(flight : Flight) : async Bool {
    if (flights.size() >= MAX_FLIGHTS) {
      return false;
    };
    flights.put(flight.flightNumber, flight);
    return true;
  };

  public query func getFlight(flightNumber : Text) : async ?Flight {
    flights.get(flightNumber)
  };

  public query func getFlightsByStatus(status : FlightStatus) : async [Flight] {
    let buffer = Buffer.Buffer<Flight>(0);
    for ((_, flight) in flights.entries()) {
      if (flight.status == status) {
        buffer.add(flight);
      };
    };
    Buffer.toArray(buffer)
  };

  public shared(msg) func updateFlightStatus(flightNumber : Text, status : FlightStatus, delayMinutes : Nat) : async Bool {
    switch (flights.get(flightNumber)) {
      case null { false };
      case (?flight) {
        let updated = {
          flightNumber = flight.flightNumber;
          airline = flight.airline;
          origin = flight.origin;
          destination = flight.destination;
          scheduledDeparture = flight.scheduledDeparture;
          scheduledArrival = flight.scheduledArrival;
          actualDeparture = flight.actualDeparture;
          actualArrival = flight.actualArrival;
          gate = flight.gate;
          status = status;
          delayMinutes = delayMinutes;
        };
        flights.put(flightNumber, updated);
        true
      };
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 3 — GATE ASSIGNMENT ENGINE
  // ═══════════════════════════════════════════════════════════════════════════

  public type Gate = {
    gateId : Text;
    terminal : Text;
    isAvailable : Bool;
    currentFlight : ?Text;
    capacity : Nat;
  };

  private stable var gateEntries : [(Text, Gate)] = [];
  private var gates = HashMap.HashMap<Text, Gate>(16, Text.equal, Text.hash);

  public shared(msg) func registerGate(gate : Gate) : async Bool {
    if (gates.size() >= MAX_GATES) {
      return false;
    };
    gates.put(gate.gateId, gate);
    return true;
  };

  public shared(msg) func assignGate(flightNumber : Text, gateId : Text) : async Bool {
    switch (flights.get(flightNumber), gates.get(gateId)) {
      case (?flight, ?gate) {
        if (not gate.isAvailable) {
          return false;
        };

        // Update flight with gate
        let updatedFlight = {
          flightNumber = flight.flightNumber;
          airline = flight.airline;
          origin = flight.origin;
          destination = flight.destination;
          scheduledDeparture = flight.scheduledDeparture;
          scheduledArrival = flight.scheduledArrival;
          actualDeparture = flight.actualDeparture;
          actualArrival = flight.actualArrival;
          gate = ?gateId;
          status = flight.status;
          delayMinutes = flight.delayMinutes;
        };
        flights.put(flightNumber, updatedFlight);

        // Update gate
        let updatedGate = {
          gateId = gate.gateId;
          terminal = gate.terminal;
          isAvailable = false;
          currentFlight = ?flightNumber;
          capacity = gate.capacity;
        };
        gates.put(gateId, updatedGate);

        true
      };
      case _ { false };
    };
  };

  public query func getAvailableGates() : async [Gate] {
    let buffer = Buffer.Buffer<Gate>(0);
    for ((_, gate) in gates.entries()) {
      if (gate.isAvailable) {
        buffer.add(gate);
      };
    };
    Buffer.toArray(buffer)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 4 — PASSENGER FLOW ORCHESTRATION
  // ═══════════════════════════════════════════════════════════════════════════

  public type PassengerProfile = {
    passengerId : Text;
    encryptedName : Blob; // Zero-Exposure Wall: encrypted PII
    flightNumber : Text;
    boardingGroup : Nat;
    seatNumber : ?Text;
    hasLoungeAccess : Bool;
    connectionFlightNumber : ?Text;
    minConnectionTime : Nat; // minutes
  };

  private stable var passengerEntries : [(Text, PassengerProfile)] = [];
  private var passengers = HashMap.HashMap<Text, PassengerProfile>(16, Text.equal, Text.hash);

  public shared(msg) func registerPassenger(profile : PassengerProfile) : async Bool {
    if (passengers.size() >= MAX_PASSENGERS) {
      return false;
    };
    passengers.put(profile.passengerId, profile);
    return true;
  };

  public query func getPassenger(passengerId : Text) : async ?PassengerProfile {
    passengers.get(passengerId)
  };

  public query func getPassengersByFlight(flightNumber : Text) : async [PassengerProfile] {
    let buffer = Buffer.Buffer<PassengerProfile>(0);
    for ((_, passenger) in passengers.entries()) {
      if (passenger.flightNumber == flightNumber) {
        buffer.add(passenger);
      };
    };
    Buffer.toArray(buffer)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 5 — BOOKING ENGINE INTEGRATION
  // ═══════════════════════════════════════════════════════════════════════════

  public type BookingStatus = {
    #Pending;
    #Confirmed;
    #Failed;
    #Cancelled;
  };

  public type Booking = {
    bookingId : Text;
    passengerId : Text;
    flightNumber : Text;
    price : Nat; // in cents
    currency : Text;
    status : BookingStatus;
    createdAt : Int;
    confirmedAt : ?Int;
  };

  private stable var bookingEntries : [(Text, Booking)] = [];
  private var bookings = HashMap.HashMap<Text, Booking>(16, Text.equal, Text.hash);

  public shared(msg) func createBooking(booking : Booking) : async Text {
    bookings.put(booking.bookingId, booking);
    booking.bookingId
  };

  public query func getBooking(bookingId : Text) : async ?Booking {
    bookings.get(bookingId)
  };

  public shared(msg) func confirmBooking(bookingId : Text) : async Bool {
    switch (bookings.get(bookingId)) {
      case null { false };
      case (?booking) {
        let updated = {
          bookingId = booking.bookingId;
          passengerId = booking.passengerId;
          flightNumber = booking.flightNumber;
          price = booking.price;
          currency = booking.currency;
          status = #Confirmed;
          createdAt = booking.createdAt;
          confirmedAt = ?Time.now();
        };
        bookings.put(bookingId, updated);
        true
      };
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 6 — IOT DEVICE REGISTRY
  // ═══════════════════════════════════════════════════════════════════════════

  public type DeviceType = {
    #Kiosk;
    #Display;
    #Beacon;
    #Sensor;
    #Gate;
  };

  public type IoTDevice = {
    deviceId : Text;
    deviceType : DeviceType;
    location : Text;
    isOnline : Bool;
    lastHeartbeat : Int;
  };

  private stable var deviceEntries : [(Text, IoTDevice)] = [];
  private var devices = HashMap.HashMap<Text, IoTDevice>(16, Text.equal, Text.hash);

  public shared(msg) func registerDevice(device : IoTDevice) : async Bool {
    if (devices.size() >= MAX_IOT_DEVICES) {
      return false;
    };
    devices.put(device.deviceId, device);
    return true;
  };

  public shared(msg) func deviceHeartbeat(deviceId : Text) : async Bool {
    switch (devices.get(deviceId)) {
      case null { false };
      case (?device) {
        let updated = {
          deviceId = device.deviceId;
          deviceType = device.deviceType;
          location = device.location;
          isOnline = true;
          lastHeartbeat = Time.now();
        };
        devices.put(deviceId, updated);
        true
      };
    };
  };

  public query func getDevicesByType(deviceType : DeviceType) : async [IoTDevice] {
    let buffer = Buffer.Buffer<IoTDevice>(0);
    for ((_, device) in devices.entries()) {
      if (device.deviceType == deviceType) {
        buffer.add(device);
      };
    };
    Buffer.toArray(buffer)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 7 — PERSONALIZATION PROFILE STORE
  // ═══════════════════════════════════════════════════════════════════════════

  public type Preferences = {
    dietaryRestrictions : [Text];
    interests : [Text];
    language : Text;
    accessibilityNeeds : [Text];
  };

  public type PersonalizationProfile = {
    passengerId : Text;
    preferences : Preferences;
    travelHistory : Nat; // number of flights
    loyaltyTier : Nat; // 0-5
  };

  private stable var profileEntries : [(Text, PersonalizationProfile)] = [];
  private var profiles = HashMap.HashMap<Text, PersonalizationProfile>(16, Text.equal, Text.hash);

  public shared(msg) func updateProfile(profile : PersonalizationProfile) : async Bool {
    profiles.put(profile.passengerId, profile);
    true
  };

  public query func getProfile(passengerId : Text) : async ?PersonalizationProfile {
    profiles.get(passengerId)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 8 — CONNECTION MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════

  public type ConnectionRisk = {
    #Low;    // > 90 min
    #Medium; // 45-90 min
    #High;   // 30-45 min
    #Critical; // < 30 min
  };

  public type Connection = {
    passengerId : Text;
    inboundFlight : Text;
    outboundFlight : Text;
    minConnectionTime : Nat;
    walkingTime : Nat;
    risk : ConnectionRisk;
  };

  public func analyzeConnection(passengerId : Text, inbound : Text, outbound : Text) : async ?Connection {
    switch (flights.get(inbound), flights.get(outbound)) {
      case (?inFlight, ?outFlight) {
        let arrivalTime = Option.get(inFlight.actualArrival, inFlight.scheduledArrival);
        let departureTime = outFlight.scheduledDeparture;
        let connectionMinutes = (departureTime - arrivalTime) / 60_000_000_000; // nanoseconds to minutes

        let risk = if (connectionMinutes > 90) { #Low }
                   else if (connectionMinutes > 45) { #Medium }
                   else if (connectionMinutes > 30) { #High }
                   else { #Critical };

        ?{
          passengerId = passengerId;
          inboundFlight = inbound;
          outboundFlight = outbound;
          minConnectionTime = 30; // airport minimum
          walkingTime = 12; // estimated
          risk = risk;
        }
      };
      case _ { null };
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 9 — SOCIAL MATCHING ENGINE
  // ═══════════════════════════════════════════════════════════════════════════

  public type SocialMatch = {
    passengerId1 : Text;
    passengerId2 : Text;
    sharedInterests : [Text];
    matchScore : Float; // φ-weighted similarity
    location : Text; // lounge, gate, etc.
  };

  public func findMatches(passengerId : Text, location : Text) : async [SocialMatch] {
    // Privacy-preserving matching: only with consent
    let buffer = Buffer.Buffer<SocialMatch>(0);

    switch (profiles.get(passengerId)) {
      case null { return Buffer.toArray(buffer); };
      case (?profile1) {
        for ((pid2, profile2) in profiles.entries()) {
          if (pid2 != passengerId) {
            let shared = countSharedInterests(profile1.preferences.interests, profile2.preferences.interests);
            if (shared > 0) {
              let score = Float.fromInt(shared) * PHI; // φ-weighted
              buffer.add({
                passengerId1 = passengerId;
                passengerId2 = pid2;
                sharedInterests = Array.filter(profile1.preferences.interests, func(i : Text) : Bool {
                  Option.isSome(Array.find(profile2.preferences.interests, func(i2 : Text) : Bool { i == i2 }))
                });
                matchScore = score;
                location = location;
              });
            };
          };
        };
      };
    };

    Buffer.toArray(buffer)
  };

  private func countSharedInterests(interests1 : [Text], interests2 : [Text]) : Int {
    var count = 0;
    for (i1 in interests1.vals()) {
      if (Option.isSome(Array.find(interests2, func(i2 : Text) : Bool { i1 == i2 }))) {
        count += 1;
      };
    };
    count
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 10 — LOYALTY & GAMIFICATION (AEROPORTO TOKENS)
  // ═══════════════════════════════════════════════════════════════════════════

  public type TokenBalance = {
    passengerId : Text;
    aeroportoTokens : Nat;
    lastEarned : Int;
    lifetimeEarned : Nat;
  };

  private stable var tokenEntries : [(Text, TokenBalance)] = [];
  private var tokenBalances = HashMap.HashMap<Text, TokenBalance>(16, Text.equal, Text.hash);

  public shared(msg) func awardTokens(passengerId : Text, amount : Nat, reason : Text) : async Bool {
    let balance = switch (tokenBalances.get(passengerId)) {
      case null {
        {
          passengerId = passengerId;
          aeroportoTokens = amount;
          lastEarned = Time.now();
          lifetimeEarned = amount;
        }
      };
      case (?existing) {
        {
          passengerId = existing.passengerId;
          aeroportoTokens = existing.aeroportoTokens + amount;
          lastEarned = Time.now();
          lifetimeEarned = existing.lifetimeEarned + amount;
        }
      };
    };
    tokenBalances.put(passengerId, balance);
    true
  };

  public query func getTokenBalance(passengerId : Text) : async ?TokenBalance {
    tokenBalances.get(passengerId)
  };

  public shared(msg) func redeemTokens(passengerId : Text, amount : Nat) : async Bool {
    switch (tokenBalances.get(passengerId)) {
      case null { false };
      case (?balance) {
        if (balance.aeroportoTokens < amount) {
          return false;
        };
        let updated = {
          passengerId = balance.passengerId;
          aeroportoTokens = balance.aeroportoTokens - amount;
          lastEarned = balance.lastEarned;
          lifetimeEarned = balance.lifetimeEarned;
        };
        tokenBalances.put(passengerId, updated);
        true
      };
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 11 — PARTNER ECOSYSTEM
  // ═══════════════════════════════════════════════════════════════════════════

  public type PartnerType = {
    #Restaurant;
    #Shop;
    #Lounge;
    #Service;
  };

  public type Partner = {
    partnerId : Text;
    name : Text;
    partnerType : PartnerType;
    location : Text;
    acceptsAeroporto : Bool;
    tokenRate : Float; // AEROPORTO per dollar
  };

  private stable var partnerEntries : [(Text, Partner)] = [];
  private var partners = HashMap.HashMap<Text, Partner>(16, Text.equal, Text.hash);

  public shared(msg) func registerPartner(partner : Partner) : async Bool {
    if (partners.size() >= MAX_PARTNERS) {
      return false;
    };
    partners.put(partner.partnerId, partner);
    return true;
  };

  public query func getPartnersByType(partnerType : PartnerType) : async [Partner] {
    let buffer = Buffer.Buffer<Partner>(0);
    for ((_, partner) in partners.entries()) {
      if (partner.partnerType == partnerType) {
        buffer.add(partner);
      };
    };
    Buffer.toArray(buffer)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 12 — COMPLIANCE & PRIVACY (GDPR AUTOMATION)
  // ═══════════════════════════════════════════════════════════════════════════

  public type DataRetentionPolicy = {
    passengerId : Text;
    dataExpiry : Int; // timestamp
    consentGiven : Bool;
  };

  private stable var policyEntries : [(Text, DataRetentionPolicy)] = [];
  private var policies = HashMap.HashMap<Text, DataRetentionPolicy>(16, Text.equal, Text.hash);

  public shared(msg) func setRetentionPolicy(passengerId : Text, daysToRetain : Nat) : async Bool {
    let expiryTime = Time.now() + (daysToRetain * 24 * 60 * 60 * 1_000_000_000);
    let policy = {
      passengerId = passengerId;
      dataExpiry = expiryTime;
      consentGiven = true;
    };
    policies.put(passengerId, policy);
    true
  };

  public shared(msg) func requestDataDeletion(passengerId : Text) : async Bool {
    // Right to erasure (GDPR Article 17)
    passengers.delete(passengerId);
    profiles.delete(passengerId);
    tokenBalances.delete(passengerId);
    policies.delete(passengerId);
    true
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 13 — EMERGENCY & SECURITY
  // ═══════════════════════════════════════════════════════════════════════════

  public type ThreatLevel = {
    #Low;
    #Medium;
    #High;
    #Critical;
  };

  public type SecurityAlert = {
    alertId : Text;
    threatLevel : ThreatLevel;
    location : Text;
    description : Text;
    timestamp : Int;
    resolved : Bool;
  };

  private stable var alertEntries : [(Text, SecurityAlert)] = [];
  private var alerts = HashMap.HashMap<Text, SecurityAlert>(16, Text.equal, Text.hash);

  public shared(msg) func raiseAlert(alert : SecurityAlert) : async Text {
    alerts.put(alert.alertId, alert);
    // TODO: Integration with aegis_shield for threat escalation
    alert.alertId
  };

  public query func getActiveAlerts() : async [SecurityAlert] {
    let buffer = Buffer.Buffer<SecurityAlert>(0);
    for ((_, alert) in alerts.entries()) {
      if (not alert.resolved) {
        buffer.add(alert);
      };
    };
    Buffer.toArray(buffer)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 14 — NOVA STREAM INTEGRATION
  // ═══════════════════════════════════════════════════════════════════════════

  // Topics for airport events
  // FLIGHT_UPDATES, GATE_CHANGES, BOARDING_STATUS, PASSENGER_ALERTS, SECURITY_EVENTS

  // TODO: Integration with nova_stream canister for event publishing
  // This will be wired after nova_stream principal is configured

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 15 — HEARTBEAT & SYNCHRONIZATION (873ms)
  // ═══════════════════════════════════════════════════════════════════════════

  private stable var heartbeatTimerId : Nat = 0;

  private func heartbeatTick() : async () {
    tickCount += 1;

    // Every tick: check for expired data retention policies
    if (tickCount % 100 == 0) { // Every 87.3 seconds
      await enforceDataRetention();
    };

    // Every tick: check for offline devices
    if (tickCount % 10 == 0) { // Every 8.73 seconds
      await checkDeviceStatus();
    };
  };

  private func enforceDataRetention() : async () {
    let now = Time.now();
    let expired = Buffer.Buffer<Text>(0);

    for ((pid, policy) in policies.entries()) {
      if (now > policy.dataExpiry) {
        expired.add(pid);
      };
    };

    // Auto-delete expired passenger data
    for (pid in expired.vals()) {
      ignore await requestDataDeletion(pid);
    };
  };

  private func checkDeviceStatus() : async () {
    let now = Time.now();
    let timeout = 5 * 60 * 1_000_000_000; // 5 minutes

    for ((deviceId, device) in devices.entries()) {
      if (now - device.lastHeartbeat > timeout) {
        let updated = {
          deviceId = device.deviceId;
          deviceType = device.deviceType;
          location = device.location;
          isOnline = false;
          lastHeartbeat = device.lastHeartbeat;
        };
        devices.put(deviceId, updated);
      };
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 16 — SYSTEM STATUS & DIAGNOSTICS
  // ═══════════════════════════════════════════════════════════════════════════

  public type SystemStatus = {
    isInitialized : Bool;
    bootTime : Int;
    tickCount : Nat;
    flightCount : Nat;
    gateCount : Nat;
    passengerCount : Nat;
    bookingCount : Nat;
    deviceCount : Nat;
    partnerCount : Nat;
    activeAlerts : Nat;
  };

  public query func getSystemStatus() : async SystemStatus {
    {
      isInitialized = isInitialized;
      bootTime = bootTime;
      tickCount = tickCount;
      flightCount = flights.size();
      gateCount = gates.size();
      passengerCount = passengers.size();
      bookingCount = bookings.size();
      deviceCount = devices.size();
      partnerCount = partners.size();
      activeAlerts = alerts.size();
    }
  };

  public shared(msg) func initialize(initOwner : Principal) : async Bool {
    if (isInitialized) {
      return false;
    };

    owner := initOwner;
    bootTime := Time.now();
    isInitialized := true;

    // Start 873ms heartbeat
    heartbeatTimerId := Timer.recurringTimer<system>(#nanoseconds(HEARTBEAT_MS * 1_000_000), heartbeatTick);

    true
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // UPGRADE HOOKS
  // ═══════════════════════════════════════════════════════════════════════════

  system func preupgrade() {
    flightEntries := Iter.toArray(flights.entries());
    gateEntries := Iter.toArray(gates.entries());
    passengerEntries := Iter.toArray(passengers.entries());
    bookingEntries := Iter.toArray(bookings.entries());
    deviceEntries := Iter.toArray(devices.entries());
    profileEntries := Iter.toArray(profiles.entries());
    tokenEntries := Iter.toArray(tokenBalances.entries());
    partnerEntries := Iter.toArray(partners.entries());
    policyEntries := Iter.toArray(policies.entries());
    alertEntries := Iter.toArray(alerts.entries());
  };

  system func postupgrade() {
    flights := HashMap.fromIter<Text, Flight>(flightEntries.vals(), 16, Text.equal, Text.hash);
    gates := HashMap.fromIter<Text, Gate>(gateEntries.vals(), 16, Text.equal, Text.hash);
    passengers := HashMap.fromIter<Text, PassengerProfile>(passengerEntries.vals(), 16, Text.equal, Text.hash);
    bookings := HashMap.fromIter<Text, Booking>(bookingEntries.vals(), 16, Text.equal, Text.hash);
    devices := HashMap.fromIter<Text, IoTDevice>(deviceEntries.vals(), 16, Text.equal, Text.hash);
    profiles := HashMap.fromIter<Text, PersonalizationProfile>(profileEntries.vals(), 16, Text.equal, Text.hash);
    tokenBalances := HashMap.fromIter<Text, TokenBalance>(tokenEntries.vals(), 16, Text.equal, Text.hash);
    partners := HashMap.fromIter<Text, Partner>(partnerEntries.vals(), 16, Text.equal, Text.hash);
    policies := HashMap.fromIter<Text, DataRetentionPolicy>(policyEntries.vals(), 16, Text.equal, Text.hash);
    alerts := HashMap.fromIter<Text, SecurityAlert>(alertEntries.vals(), 16, Text.equal, Text.hash);

    flightEntries := [];
    gateEntries := [];
    passengerEntries := [];
    bookingEntries := [];
    deviceEntries := [];
    profileEntries := [];
    tokenEntries := [];
    partnerEntries := [];
    policyEntries := [];
    alertEntries := [];
  };
}
