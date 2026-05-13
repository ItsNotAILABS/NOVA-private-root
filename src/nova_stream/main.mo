// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
// ║  Location:     Dallas, Texas, United States of America                                                    ║
// ║  Contact:      MedinaSITech@outlook.com                                                                   ║
// ║  Framework:    Medina Doctrine — Native Nova Protocol                                                     ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// NATIVE NOVA PROTOCOL — BUILD №41
// NOVA STREAM — Sovereign On-Chain Streaming Bus
// Medina Tech | Alfredo Medina Hernandez | Dallas, TX | 2026
//
// NOVA STREAM IS THE SOVEREIGN INFORMATION SPINE.
// Every canister in the NOVA organism publishes events here.
// Every subscriber reads from here. Nothing is lost.
// Nothing is off-chain.
//
// Architecture:
//   Ring buffer    — STREAM_CAP (512) event slots, monotonic global IDs
//   Topics         — named channels (any Text); dynamic, no pre-registration needed
//   Publisher ACL  — only registered canisters may publish; open by default until locked
//   Cursor polling — getStreamSince(topic, cursor) returns events since ID (the streaming primitive)
//   No-drop law    — events overflow oldest slot (ring), cursor consumers never lose future events
//
// PUBLIC API:
//   publish(topic, payload, origin)   — push event (authorized publishers or pre-lock open)
//   getStream(topic)                  — all events in topic (up to STREAM_CAP most recent)
//   getStreamSince(topic, cursor)     — poll events with id >= cursor in topic (streaming primitive)
//   getStreamHead(topic)              — latest event global ID in topic (?Nat, null if empty)
//   getTopics()                       — list of all distinct topics published so far
//   getEventCount()                   — total events published (monotonic, never resets)
//   getStreamStatus()                 — health / diagnostics snapshot
//
// ADMIN API (architect only):
//   claimStream()
//   addPublisher(principal)
//   removePublisher(principal)
//   lockPublishers()                  — freeze ACL (no new additions)
//   setOpenPublishing(bool)           — allow/deny anonymous publishing

import Array     "mo:base/Array";
import Bool      "mo:base/Bool";
import Float     "mo:base/Float";
import Int       "mo:base/Int";
import Nat       "mo:base/Nat";
import Principal "mo:base/Principal";
import Text      "mo:base/Text";
import Time      "mo:base/Time";

actor NovaStream {

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 1 — SOVEREIGN IDENTITY
  // ═══════════════════════════════════════════════════════════════════════════

  stable var architectPrincipal : Principal = Principal.fromText("aaaaa-aa");
  stable var genesisLocked      : Bool      = false;
  stable var sovereignSeal      : Text      = "";
  stable var genesisTimestamp   : Int       = 0;

  func _isArchitect(caller : Principal) : Bool {
    caller == architectPrincipal
  };

  public shared(msg) func claimStream() : async Text {
    if (genesisLocked) return "STREAM_ALREADY_CLAIMED";
    architectPrincipal := msg.caller;
    genesisLocked      := true;
    sovereignSeal      := "NOVA-STREAM-BUILD41-" # Principal.toText(msg.caller);
    genesisTimestamp   := Time.now();
    "GENESIS_CLAIMED: " # sovereignSeal
  };

  public query func getSeal()            : async Text      { sovereignSeal };
  public query func isLocked()           : async Bool      { genesisLocked };
  public query func getGenesisTimestamp(): async Int       { genesisTimestamp };
  public query func getArchitect()       : async Principal { architectPrincipal };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 2 — GOLDEN MATH CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════

  let PHI     : Float = 1.6180339887498948482;
  let PHI_INV : Float = 0.6180339887498948482;

  // φ-weighted event priority: older events decay, recent events are sovereign
  func _phiWeight(age : Nat, total : Nat) : Float {
    if (total == 0) return 1.0;
    let frac = Float.fromInt(age) / Float.fromInt(total);
    Float.exp((-1.0) * frac * Float.log(PHI))
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 3 — STREAM TYPES
  // ═══════════════════════════════════════════════════════════════════════════

  // StreamEvent — the sovereign unit of information
  public type StreamEvent = {
    id        : Nat;    // monotonic global sequence — never reused
    topic     : Text;   // named channel
    payload   : Text;   // JSON or any sovereign encoding
    origin    : Text;   // publisher canister label or Principal.toText
    timestamp : Int;    // Time.now() nanoseconds
    weight    : Float;  // φ-weight at publish time (recency indicator)
  };

  // StreamStatus — diagnostics snapshot
  public type StreamStatus = {
    seal           : Text;
    totalPublished : Nat;
    slotsUsed      : Nat;
    slotCapacity   : Nat;
    topicCount     : Nat;
    publisherCount : Nat;
    openPublishing : Bool;
    publishersLocked : Bool;
    uptimeNs       : Int;
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 4 — RING BUFFER STATE (stable)
  // ═══════════════════════════════════════════════════════════════════════════

  // Ring buffer capacity — 512 events (sovereign constant)
  let STREAM_CAP : Nat = 512;

  // Flat parallel arrays — one slot per ring position
  stable var evId        : [var Nat]  = Array.init<Nat> (STREAM_CAP, 0);
  stable var evTopic     : [var Text] = Array.init<Text>(STREAM_CAP, "");
  stable var evPayload   : [var Text] = Array.init<Text>(STREAM_CAP, "");
  stable var evOrigin    : [var Text] = Array.init<Text>(STREAM_CAP, "");
  stable var evTimestamp : [var Int]  = Array.init<Int> (STREAM_CAP, 0);
  stable var evWeight    : [var Float]= Array.init<Float>(STREAM_CAP, 0.0);
  stable var evValid     : [var Bool] = Array.init<Bool>(STREAM_CAP, false);

  // Ring write head (next slot to write)
  stable var ringHead    : Nat = 0;

  // Monotonic global event counter (never resets — this is the cursor ID source)
  stable var eventSeq    : Nat = 0;

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 5 — PUBLISHER ACCESS CONTROL
  // ═══════════════════════════════════════════════════════════════════════════

  let MAX_PUBLISHERS : Nat = 64;

  stable var publishers       : [var Principal] = Array.init<Principal>(MAX_PUBLISHERS, Principal.fromText("aaaaa-aa"));
  stable var publisherCount   : Nat             = 0;
  stable var publishersLocked : Bool            = false;
  stable var openPublishing   : Bool            = true; // open until first lock

  func _isPublisher(caller : Principal) : Bool {
    if (openPublishing) return true;
    if (_isArchitect(caller)) return true;
    var i = 0;
    while (i < publisherCount) {
      if (publishers[i] == caller) return true;
      i += 1;
    };
    false
  };

  public shared(msg) func addPublisher(p : Principal) : async Text {
    assert(_isArchitect(msg.caller));
    assert(not publishersLocked);
    assert(publisherCount < MAX_PUBLISHERS);
    // idempotent
    var i = 0;
    while (i < publisherCount) {
      if (publishers[i] == p) return "PUBLISHER_ALREADY_REGISTERED";
      i += 1;
    };
    publishers[publisherCount] := p;
    publisherCount += 1;
    "PUBLISHER_ADDED: " # Principal.toText(p)
  };

  public shared(msg) func removePublisher(p : Principal) : async Text {
    assert(_isArchitect(msg.caller));
    var found = false;
    var i = 0;
    while (i < publisherCount) {
      if (publishers[i] == p) { found := true };
      if (found and i + 1 < publisherCount) {
        publishers[i] := publishers[i + 1];
      };
      i += 1;
    };
    if (found) {
      publisherCount -= 1;
      "PUBLISHER_REMOVED: " # Principal.toText(p)
    } else {
      "PUBLISHER_NOT_FOUND"
    }
  };

  public shared(msg) func lockPublishers() : async Text {
    assert(_isArchitect(msg.caller));
    publishersLocked := true;
    openPublishing   := false;
    "PUBLISHERS_LOCKED"
  };

  public shared(msg) func setOpenPublishing(open : Bool) : async Text {
    assert(_isArchitect(msg.caller));
    openPublishing := open;
    if (open) "OPEN_PUBLISHING_ENABLED" else "OPEN_PUBLISHING_DISABLED"
  };

  public query func getPublishers() : async [Text] {
    let buf = Array.init<Text>(publisherCount, "");
    var i = 0;
    while (i < publisherCount) {
      buf[i] := Principal.toText(publishers[i]);
      i += 1;
    };
    Array.freeze(buf)
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 6 — CORE PUBLISH
  // ═══════════════════════════════════════════════════════════════════════════

  // publish — the sovereign write. Any authorized canister calls this.
  // Returns the global event ID assigned to this event.
  public shared(msg) func publish(topic : Text, payload : Text, origin : Text) : async Nat {
    assert(_isPublisher(msg.caller));
    assert(Text.size(topic)   > 0);
    assert(Text.size(payload) > 0);

    let id     = eventSeq;
    let ts     = Time.now();
    let slot   = ringHead;
    let w      = _phiWeight(id % STREAM_CAP, STREAM_CAP);

    evId[slot]        := id;
    evTopic[slot]     := topic;
    evPayload[slot]   := payload;
    evOrigin[slot]    := origin;
    evTimestamp[slot] := ts;
    evWeight[slot]    := w;
    evValid[slot]     := true;

    eventSeq  += 1;
    ringHead   := (ringHead + 1) % STREAM_CAP;

    id
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 7 — QUERY API (zero side-effects)
  // ═══════════════════════════════════════════════════════════════════════════

  // _collectTopic — internal helper: scan ring and return all valid events for topic
  func _collectTopic(topic : Text) : [StreamEvent] {
    let buf = Array.init<StreamEvent>(STREAM_CAP, {
      id = 0; topic = ""; payload = ""; origin = ""; timestamp = 0; weight = 0.0
    });
    var count = 0;
    var i = 0;
    while (i < STREAM_CAP) {
      if (evValid[i] and evTopic[i] == topic) {
        buf[count] := {
          id        = evId[i];
          topic     = evTopic[i];
          payload   = evPayload[i];
          origin    = evOrigin[i];
          timestamp = evTimestamp[i];
          weight    = evWeight[i];
        };
        count += 1;
      };
      i += 1;
    };
    // Return only filled portion, sorted ascending by id
    let raw = Array.tabulate<StreamEvent>(count, func(j) { buf[j] });
    Array.sort<StreamEvent>(raw, func(a, b) {
      if (a.id < b.id) #less
      else if (a.id > b.id) #greater
      else #equal
    })
  };

  // getStream — all events in a topic (most recent STREAM_CAP)
  public query func getStream(topic : Text) : async [StreamEvent] {
    _collectTopic(topic)
  };

  // getStreamSince — THE STREAMING PRIMITIVE.
  // Returns all events in topic with id >= cursor, sorted ascending.
  // Caller sets cursor = 0 to get all; cursor = head+1 to get only future events.
  public query func getStreamSince(topic : Text, cursor : Nat) : async [StreamEvent] {
    let all = _collectTopic(topic);
    Array.filter<StreamEvent>(all, func(ev) { ev.id >= cursor })
  };

  // getStreamHead — returns the highest event id published in topic (null if no events yet)
  // Use this to initialize your cursor before polling with getStreamSince.
  public query func getStreamHead(topic : Text) : async ?Nat {
    var found  : Bool = false;
    var maxId  : Nat  = 0;
    var i = 0;
    while (i < STREAM_CAP) {
      if (evValid[i] and evTopic[i] == topic) {
        if (not found or evId[i] > maxId) {
          maxId := evId[i];
          found := true;
        };
      };
      i += 1;
    };
    if (found) { ?maxId } else { null }
  };

  // getTopics — list all distinct topics currently in the ring
  public query func getTopics() : async [Text] {
    // collect unique topics
    let seen  = Array.init<Text>(STREAM_CAP, "");
    var seenN : Nat = 0;
    var i = 0;
    while (i < STREAM_CAP) {
      if (evValid[i]) {
        let t  = evTopic[i];
        var dup = false;
        var j   = 0;
        while (j < seenN) {
          if (seen[j] == t) { dup := true };
          j += 1;
        };
        if (not dup) {
          seen[seenN] := t;
          seenN += 1;
        };
      };
      i += 1;
    };
    Array.tabulate<Text>(seenN, func(k) { seen[k] })
  };

  // getEventCount — total events published (monotonic; never resets)
  public query func getEventCount() : async Nat { eventSeq };

  // getLatestEvent — latest event in the ring regardless of topic
  public query func getLatestEvent() : async ?StreamEvent {
    if (eventSeq == 0) return null;
    // Most recent write was at (ringHead - 1 + STREAM_CAP) % STREAM_CAP
    let slot = (ringHead + STREAM_CAP - 1) % STREAM_CAP;
    if (not evValid[slot]) return null;
    ?{
      id        = evId[slot];
      topic     = evTopic[slot];
      payload   = evPayload[slot];
      origin    = evOrigin[slot];
      timestamp = evTimestamp[slot];
      weight    = evWeight[slot];
    }
  };

  // getRingSnapshot — full raw ring for diagnostics (architect use)
  public query func getRingSnapshot() : async [StreamEvent] {
    let buf = Array.init<StreamEvent>(STREAM_CAP, {
      id = 0; topic = ""; payload = ""; origin = ""; timestamp = 0; weight = 0.0
    });
    var count = 0;
    var i = 0;
    while (i < STREAM_CAP) {
      if (evValid[i]) {
        buf[count] := {
          id        = evId[i];
          topic     = evTopic[i];
          payload   = evPayload[i];
          origin    = evOrigin[i];
          timestamp = evTimestamp[i];
          weight    = evWeight[i];
        };
        count += 1;
      };
      i += 1;
    };
    let raw = Array.tabulate<StreamEvent>(count, func(j) { buf[j] });
    Array.sort<StreamEvent>(raw, func(a, b) {
      if (a.id < b.id) #less
      else if (a.id > b.id) #greater
      else #equal
    })
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 8 — STATUS & DIAGNOSTICS
  // ═══════════════════════════════════════════════════════════════════════════

  func _countValidSlots() : Nat {
    var n = 0;
    var i = 0;
    while (i < STREAM_CAP) {
      if (evValid[i]) { n += 1 };
      i += 1;
    };
    n
  };

  func _countTopics() : Nat {
    let seen  = Array.init<Text>(STREAM_CAP, "");
    var seenN : Nat = 0;
    var i = 0;
    while (i < STREAM_CAP) {
      if (evValid[i]) {
        let t  = evTopic[i];
        var dup = false;
        var j   = 0;
        while (j < seenN) {
          if (seen[j] == t) { dup := true };
          j += 1;
        };
        if (not dup) {
          seen[seenN] := t;
          seenN += 1;
        };
      };
      i += 1;
    };
    seenN
  };

  public query func getStreamStatus() : async StreamStatus {
    {
      seal             = sovereignSeal;
      totalPublished   = eventSeq;
      slotsUsed        = _countValidSlots();
      slotCapacity     = STREAM_CAP;
      topicCount       = _countTopics();
      publisherCount   = publisherCount;
      openPublishing   = openPublishing;
      publishersLocked = publishersLocked;
      uptimeNs         = Time.now() - genesisTimestamp;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // Section 9 — SOVEREIGN DIAGNOSTICS STRING
  // ═══════════════════════════════════════════════════════════════════════════

  public query func diagnostics() : async Text {
    let slots = _countValidSlots();
    let topics = _countTopics();
    "NOVA_STREAM | BUILD_41 | "
      # "events=" # Nat.toText(eventSeq) # " | "
      # "slots_used=" # Nat.toText(slots) # "/" # Nat.toText(STREAM_CAP) # " | "
      # "topics=" # Nat.toText(topics) # " | "
      # "publishers=" # Nat.toText(publisherCount) # " | "
      # "open=" # Bool.toText(openPublishing) # " | "
      # "PHI=" # Float.toText(PHI)
  };

};
