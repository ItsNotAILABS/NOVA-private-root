// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// COMMUNICATION PROTOCOL MODELS — THE LANGUAGE BETWEEN ORGANISMS
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// Defines the protocol for inter-organism communication.
// Frontend ↔ Backend, Module ↔ Module, Swarm ↔ Brain all speak this protocol.
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Nat "mo:base/Nat";
import Int "mo:base/Int";
import Text "mo:base/Text";
import Bool "mo:base/Bool";
import Array "mo:base/Array";
import Principal "mo:base/Principal";

module CommunicationProtocol {

  // ═══════════════════════════════════════════════════════════════════════════
  // PROTOCOL VERSION & MAGIC NUMBERS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Protocol version - increment on breaking changes
  public let PROTOCOL_VERSION : Nat = 1;
  
  /// Magic number for protocol identification
  public let PROTOCOL_MAGIC : Nat = 0x4E4F5641; // "NOVA" in hex
  
  /// Maximum message size in bytes
  public let MAX_MESSAGE_SIZE : Nat = 65536;
  
  /// Default TTL for messages (in beats)
  public let DEFAULT_TTL : Nat = 100;

  // ═══════════════════════════════════════════════════════════════════════════
  // MESSAGE ENVELOPE — The outer wrapper for all communication
  // ═══════════════════════════════════════════════════════════════════════════

  /// The standard envelope that wraps all inter-organism messages
  public type MessageEnvelope = {
    /// Protocol version for compatibility checking
    version : Nat;
    
    /// Unique message identifier
    messageId : Nat;
    
    /// Correlation ID for request-response matching
    correlationId : ?Nat;
    
    /// Sender's principal
    sender : Principal;
    
    /// Recipient principal(s)
    recipients : [Principal];
    
    /// Message type classification
    messageType : MessageType;
    
    /// The actual payload
    payload : MessagePayload;
    
    /// Timestamp of creation
    timestamp : Int;
    
    /// Beat when created
    beat : Nat;
    
    /// Priority (0.0 - 1.0, higher = more urgent)
    priority : Float;
    
    /// Time to live in beats
    ttl : Nat;
    
    /// Does this require acknowledgment?
    requiresAck : Bool;
    
    /// Is this encrypted?
    encrypted : Bool;
    
    /// Signature for verification (optional)
    signature : ?[Nat8];
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // MESSAGE TYPES — Classification of messages
  // ═══════════════════════════════════════════════════════════════════════════

  /// Primary message type classification
  public type MessageType = {
    /// Heartbeat/pulse broadcast
    #Pulse;
    
    /// Request for information
    #Request;
    
    /// Response to a request
    #Response;
    
    /// Alert/warning notification
    #Alert;
    
    /// Command from higher authority
    #Command;
    
    /// State synchronization
    #Sync;
    
    /// Learning/knowledge transfer
    #Learning;
    
    /// Acknowledgment
    #Ack;
    
    /// Negative acknowledgment
    #Nack;
    
    /// Broadcast to all (gossip)
    #Broadcast;
    
    /// Direct peer-to-peer
    #Direct;
    
    /// Error notification
    #Error;
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // MESSAGE PAYLOADS — The content inside messages
  // ═══════════════════════════════════════════════════════════════════════════

  /// Payload variants - the actual data being transmitted
  public type MessagePayload = {
    /// Heartbeat pulse data
    #PulsePayload : PulseData;
    
    /// Request for data
    #RequestPayload : RequestData;
    
    /// Response with data
    #ResponsePayload : ResponseData;
    
    /// Alert notification
    #AlertPayload : AlertData;
    
    /// Command instruction
    #CommandPayload : CommandData;
    
    /// State sync data
    #SyncPayload : SyncData;
    
    /// Learning transfer
    #LearningPayload : LearningData;
    
    /// Simple acknowledgment
    #AckPayload : AckData;
    
    /// Error details
    #ErrorPayload : ErrorData;
    
    /// Raw binary data
    #RawPayload : [Nat8];
    
    /// Structured JSON-like data
    #StructuredPayload : [(Text, PayloadValue)];
  };

  /// Value types for structured payloads
  public type PayloadValue = {
    #Null;
    #Bool : Bool;
    #Int : Int;
    #Float : Float;
    #Text : Text;
    #Blob : [Nat8];
    #Array : [PayloadValue];
    #Record : [(Text, PayloadValue)];
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // SPECIFIC PAYLOAD TYPES
  // ═══════════════════════════════════════════════════════════════════════════

  /// Pulse (heartbeat) data
  public type PulseData = {
    beat : Nat;
    coherence : Float;
    arousal : Float;
    drift : Float;
    emergence : Float;
    energy : Float;
    phase : Float;
    kuramotoR : Float;
    trustScore : Float;
    anomalyScore : Float;
  };

  /// Request data
  public type RequestData = {
    requestType : RequestType;
    params : [(Text, PayloadValue)];
    maxWait : Nat;           // Max beats to wait for response
    maxResults : ?Nat;       // Max results to return
  };

  /// Request type enumeration
  public type RequestType = {
    #GetState;               // Get current state
    #GetPulse;               // Get pulse only
    #GetNeurochemistry;      // Get neurochemical state
    #GetQuantum;             // Get quantum state
    #GetDrives;              // Get drive state
    #GetMemory;              // Get memory state
    #GetSwarm;               // Get swarm state
    #GetConfig;              // Get configuration
    #Query : Text;           // Custom query by name
  };

  /// Response data
  public type ResponseData = {
    requestId : Nat;
    success : Bool;
    data : PayloadValue;
    executionTime : Int;
  };

  /// Alert data
  public type AlertData = {
    severity : AlertSeverity;
    category : AlertCategory;
    title : Text;
    description : Text;
    source : Text;
    location : ?Position;
    timestamp : Int;
    metadata : [(Text, PayloadValue)];
  };

  /// Alert severity
  public type AlertSeverity = {
    #Debug;
    #Info;
    #Warning;
    #Error;
    #Critical;
    #Emergency;
  };

  /// Alert category
  public type AlertCategory = {
    #Health;
    #Security;
    #Performance;
    #Synchronization;
    #Energy;
    #Communication;
    #External;
    #Internal;
  };

  /// 3D position for location references
  public type Position = {
    x : Float;
    y : Float;
    z : Float;
  };

  /// Command data
  public type CommandData = {
    commandType : CommandType;
    authority : Principal;     // Who issued the command
    authorityLevel : Nat;      // Permission level required
    target : ?Principal;       // Specific target (null = self)
    params : [(Text, PayloadValue)];
    deadline : ?Int;           // Must complete by
    mandatory : Bool;          // Can't be declined
  };

  /// Command types
  public type CommandType = {
    #Start;                    // Start processing
    #Stop;                     // Stop processing
    #Pause;                    // Pause processing
    #Resume;                   // Resume processing
    #Reset;                    // Reset to initial state
    #Sync;                     // Synchronize with target
    #Migrate;                  // Move to different location
    #Configure;                // Change configuration
    #Report;                   // Generate status report
    #Execute : Text;           // Execute named action
    #Emergency;                // Emergency action
  };

  /// State synchronization data
  public type SyncData = {
    syncType : SyncType;
    sourceVersion : Nat;       // Version number of source
    targetVersion : ?Nat;      // Expected target version
    delta : Bool;              // Is this a delta sync?
    stateData : PayloadValue;  // The state to sync
    signature : ?[Nat8];       // For verification
  };

  /// Sync type
  public type SyncType = {
    #Full;                     // Full state replacement
    #Delta;                    // Only changes
    #Checkpoint;               // Checkpoint marker
    #Request;                  // Request for sync
    #Acknowledge;              // Sync acknowledged
  };

  /// Learning transfer data
  public type LearningData = {
    sessionId : Nat;
    learningType : LearningType;
    hebbianDeltas : [Float];   // Weight changes
    patterns : [PatternData];  // Learned patterns
    predictionErrors : Float;
    totalUpdates : Nat;
    confidence : Float;
    sessionDuration : Int;
  };

  /// Learning type
  public type LearningType = {
    #Hebbian;                  // Hebbian weight updates
    #Pattern;                  // Pattern recognition
    #Prediction;               // Predictive model
    #Reward;                   // Reward-based
    #Imitation;                // Learned from observation
  };

  /// Pattern data
  public type PatternData = {
    signature : Nat;
    weights : [Float];
    confidence : Float;
    timestamp : Int;
  };

  /// Acknowledgment data
  public type AckData = {
    messageId : Nat;           // ID of message being acknowledged
    received : Bool;           // Was it received?
    processed : Bool;          // Was it processed?
    status : Text;             // Status message
  };

  /// Error data
  public type ErrorData = {
    code : ErrorCode;
    message : Text;
    source : Text;
    timestamp : Int;
    retryable : Bool;
    details : ?[(Text, PayloadValue)];
  };

  /// Error codes
  public type ErrorCode = {
    #Unknown;
    #NotAuthorized;
    #NotFound;
    #InvalidState;
    #InvalidInput;
    #Timeout;
    #ResourceExhausted;
    #NetworkError;
    #InternalError;
    #ProtocolError;
    #VersionMismatch;
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // CHANNEL DEFINITIONS — Communication pathways
  // ═══════════════════════════════════════════════════════════════════════════

  /// Communication channel definition
  public type Channel = {
    id : Nat;
    name : Text;
    channelType : ChannelType;
    participants : [Principal];
    bandwidth : Nat;           // Messages per beat
    latency : Nat;             // Beats of delay
    encrypted : Bool;
    quality : Float;           // 0.0 - 1.0
  };

  /// Channel types
  public type ChannelType = {
    #Broadcast;                // One-to-many
    #Direct;                   // One-to-one
    #Multicast;                // Many-to-many
    #Priority;                 // High priority
    #Background;               // Low priority
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // ROUTING — How messages find their way
  // ═══════════════════════════════════════════════════════════════════════════

  /// Routing information
  public type RoutingInfo = {
    source : Principal;
    destination : Principal;
    hops : [Principal];        // Intermediate nodes
    maxHops : Nat;
    currentHop : Nat;
    routeQuality : Float;
  };

  /// Route request
  public type RouteRequest = {
    destination : Principal;
    constraints : RouteConstraints;
  };

  /// Routing constraints
  public type RouteConstraints = {
    maxLatency : Nat;
    minQuality : Float;
    encrypted : Bool;
    preferDirect : Bool;
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // PROTOCOL HANDLERS — Processing incoming messages
  // ═══════════════════════════════════════════════════════════════════════════

  /// Handler result type
  public type HandlerResult = {
    #Handled : ?MessageEnvelope;  // Successfully handled, optional response
    #Forward : [Principal];        // Forward to these principals
    #Reject : ErrorData;          // Rejected with error
    #Defer : Nat;                 // Defer for N beats
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // HELPER FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Create a new message envelope
  public func createEnvelope(
    sender : Principal,
    recipients : [Principal],
    messageType : MessageType,
    payload : MessagePayload,
    beat : Nat
  ) : MessageEnvelope {
    {
      version = PROTOCOL_VERSION;
      messageId = 0; // Should be set by caller
      correlationId = null;
      sender = sender;
      recipients = recipients;
      messageType = messageType;
      payload = payload;
      timestamp = 0; // Should be set by caller
      beat = beat;
      priority = 0.5;
      ttl = DEFAULT_TTL;
      requiresAck = false;
      encrypted = false;
      signature = null;
    }
  };

  /// Create a pulse payload
  public func createPulsePayload(
    beat : Nat,
    coherence : Float,
    arousal : Float,
    drift : Float,
    emergence : Float,
    energy : Float,
    phase : Float,
    kuramotoR : Float
  ) : MessagePayload {
    #PulsePayload({
      beat = beat;
      coherence = coherence;
      arousal = arousal;
      drift = drift;
      emergence = emergence;
      energy = energy;
      phase = phase;
      kuramotoR = kuramotoR;
      trustScore = 1.0;
      anomalyScore = 0.0;
    })
  };

  /// Create a request payload
  public func createRequestPayload(
    requestType : RequestType,
    maxWait : Nat
  ) : MessagePayload {
    #RequestPayload({
      requestType = requestType;
      params = [];
      maxWait = maxWait;
      maxResults = null;
    })
  };

  /// Create a response payload
  public func createResponsePayload(
    requestId : Nat,
    success : Bool,
    data : PayloadValue,
    executionTime : Int
  ) : MessagePayload {
    #ResponsePayload({
      requestId = requestId;
      success = success;
      data = data;
      executionTime = executionTime;
    })
  };

  /// Create an alert payload
  public func createAlertPayload(
    severity : AlertSeverity,
    category : AlertCategory,
    title : Text,
    description : Text,
    source : Text
  ) : MessagePayload {
    #AlertPayload({
      severity = severity;
      category = category;
      title = title;
      description = description;
      source = source;
      location = null;
      timestamp = 0;
      metadata = [];
    })
  };

  /// Create an error payload
  public func createErrorPayload(
    code : ErrorCode,
    message : Text,
    source : Text,
    retryable : Bool
  ) : MessagePayload {
    #ErrorPayload({
      code = code;
      message = message;
      source = source;
      timestamp = 0;
      retryable = retryable;
      details = null;
    })
  };

  /// Create an acknowledgment payload
  public func createAckPayload(
    messageId : Nat,
    received : Bool,
    processed : Bool,
    status : Text
  ) : MessagePayload {
    #AckPayload({
      messageId = messageId;
      received = received;
      processed = processed;
      status = status;
    })
  };

  /// Check if message has expired
  public func isExpired(envelope : MessageEnvelope, currentBeat : Nat) : Bool {
    currentBeat > envelope.beat + envelope.ttl
  };

  /// Check protocol version compatibility
  public func isCompatible(version : Nat) : Bool {
    version == PROTOCOL_VERSION
  };

  /// Get priority class from priority value
  public func getPriorityClass(priority : Float) : Text {
    if (priority >= 0.9) { "CRITICAL" }
    else if (priority >= 0.7) { "HIGH" }
    else if (priority >= 0.4) { "NORMAL" }
    else { "LOW" }
  };

}
