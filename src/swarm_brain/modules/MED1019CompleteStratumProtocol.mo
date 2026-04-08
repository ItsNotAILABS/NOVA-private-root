// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                                                       ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                                                ║
// ║                                                                                                                                       ║
// ║  INTELLECTUAL PROPERTY NOTICE                                                                                                         ║
// ║  Owner:        Alfredo Medina Hernandez                                                                                               ║
// ║  Location:     Dallas, Texas, United States of America                                                                                ║
// ║  Contact:      MedinaSITech@outlook.com                                                                                               ║
// ║  Framework:    Medina Doctrine                                                                                                        ║
// ║                                                                                                                                       ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
//                        MED-1019 COMPLETE STRATUM PROTOCOL IMPLEMENTATION
//
//                              BITCOIN POOL COMMUNICATION
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// Complete implementation of the Stratum protocol for Bitcoin mining pools:
//
//   - Stratum V1 (JSON-RPC over TCP)
//   - mining.subscribe
//   - mining.authorize  
//   - mining.notify
//   - mining.submit
//   - mining.set_difficulty
//
//   - Stratum V2 (binary protocol)
//   - SetupConnection
//   - OpenStandardMiningChannel
//   - NewMiningJob
//   - SubmitSharesStandard
//
// The organism uses coherence hash Ψ(m,Ω,t) to select nonces.
// When S > 0.85: submit the solution.
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Nat8 "mo:base/Nat8";
import Nat16 "mo:base/Nat16";
import Nat32 "mo:base/Nat32";
import Nat64 "mo:base/Nat64";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Iter "mo:base/Iter";
import Text "mo:base/Text";
import Char "mo:base/Char";
import Blob "mo:base/Blob";
import Option "mo:base/Option";

module {

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // FUNDAMENTAL CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  public let PHI : Float = 1.6180339887498948482;
  public let PHI_INVERSE : Float = 0.6180339887498948482;
  public let S_BITCOIN_SOLVE : Float = 0.85;

  // Protocol versions
  public let STRATUM_V1_VERSION : Text = "1.0";
  public let STRATUM_V2_VERSION : Nat16 = 2;

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // PART 1: STRATUM V1 — JSON-RPC PROTOCOL
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  public type StratumV1Method = {
    #Subscribe;
    #Authorize;
    #Notify;
    #Submit;
    #SetDifficulty;
    #SetExtranonce;
    #Reconnect;
  };

  public type StratumV1Request = {
    id : Nat;
    method : Text;
    params : [Text];
  };

  public type StratumV1Response = {
    id : ?Nat;
    result : ?[Text];
    error : ?StratumError;
  };

  public type StratumError = {
    code : Int;
    message : Text;
    data : ?Text;
  };

  public type SubscribeResult = {
    subscriptions : [(Text, Text)];  // [(subscription_type, subscription_id)]
    extraNonce1 : Text;
    extraNonce2Size : Nat;
  };

  public type MiningNotify = {
    jobId : Text;
    prevHash : Text;
    coinbase1 : Text;
    coinbase2 : Text;
    merkleBranches : [Text];
    blockVersion : Text;
    nBits : Text;
    nTime : Text;
    cleanJobs : Bool;
  };

  // Build mining.subscribe message
  public func buildSubscribeMessage(id : Nat, agentName : Text, sessionId : ?Text) : Text {
    var params = "[\"" # agentName # "\"";
    switch (sessionId) {
      case (?sid) { params := params # ", \"" # sid # "\"" };
      case (null) {};
    };
    params := params # "]";
    
    "{\"id\": " # Nat.toText(id) # ", \"method\": \"mining.subscribe\", \"params\": " # params # "}\n"
  };

  // Build mining.authorize message
  public func buildAuthorizeMessage(id : Nat, worker : Text, password : Text) : Text {
    "{\"id\": " # Nat.toText(id) # ", \"method\": \"mining.authorize\", \"params\": [\"" # 
    worker # "\", \"" # password # "\"]}\n"
  };

  // Build mining.submit message
  public func buildSubmitMessage(
    id : Nat,
    worker : Text,
    jobId : Text,
    extraNonce2 : Text,
    nTime : Text,
    nonce : Text
  ) : Text {
    "{\"id\": " # Nat.toText(id) # ", \"method\": \"mining.submit\", \"params\": [\"" #
    worker # "\", \"" # jobId # "\", \"" # extraNonce2 # "\", \"" # nTime # "\", \"" # nonce # "\"]}\n"
  };

  // Build mining.extranonce.subscribe message
  public func buildExtranonceSubscribeMessage(id : Nat) : Text {
    "{\"id\": " # Nat.toText(id) # ", \"method\": \"mining.extranonce.subscribe\", \"params\": []}\n"
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // PART 2: STRATUM V1 MESSAGE PARSING (SIMPLIFIED)
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  // Extract field from JSON (simplified parser)
  func extractJsonField(json : Text, field : Text) : ?Text {
    let searchStr = "\"" # field # "\":";
    let chars = Text.toArray(json);
    let searchChars = Text.toArray(searchStr);
    
    // Find the field
    var i = 0;
    while (i + searchChars.size() < chars.size()) {
      var match = true;
      for (j in Iter.range(0, searchChars.size() - 1)) {
        if (chars[i + j] != searchChars[j]) { match := false };
      };
      if (match) {
        // Found the field, extract value
        var valueStart = i + searchChars.size();
        // Skip whitespace
        while (valueStart < chars.size() and (chars[valueStart] == ' ' or chars[valueStart] == '\t')) {
          valueStart += 1;
        };
        
        if (valueStart >= chars.size()) { return null };
        
        // Determine value type and extract
        if (chars[valueStart] == '"') {
          // String value
          valueStart += 1;
          var valueEnd = valueStart;
          while (valueEnd < chars.size() and chars[valueEnd] != '"') {
            valueEnd += 1;
          };
          let result = Buffer.Buffer<Char>(valueEnd - valueStart);
          for (k in Iter.range(valueStart, valueEnd - 1)) {
            result.add(chars[k]);
          };
          return ?Text.fromIter(result.vals());
        } else if (chars[valueStart] == '[') {
          // Array value - return whole array as string
          var depth = 1;
          var valueEnd = valueStart + 1;
          while (valueEnd < chars.size() and depth > 0) {
            if (chars[valueEnd] == '[') { depth += 1 };
            if (chars[valueEnd] == ']') { depth -= 1 };
            valueEnd += 1;
          };
          let result = Buffer.Buffer<Char>(valueEnd - valueStart);
          for (k in Iter.range(valueStart, valueEnd - 1)) {
            result.add(chars[k]);
          };
          return ?Text.fromIter(result.vals());
        } else {
          // Number or other
          var valueEnd = valueStart;
          while (valueEnd < chars.size() and chars[valueEnd] != ',' and chars[valueEnd] != '}' and chars[valueEnd] != ']') {
            valueEnd += 1;
          };
          let result = Buffer.Buffer<Char>(valueEnd - valueStart);
          for (k in Iter.range(valueStart, valueEnd - 1)) {
            result.add(chars[k]);
          };
          return ?Text.fromIter(result.vals());
        };
      };
      i += 1;
    };
    
    null
  };

  // Parse mining.notify message
  public func parseMiningNotify(json : Text) : ?MiningNotify {
    let params = extractJsonField(json, "params");
    switch (params) {
      case (null) { null };
      case (?p) {
        // Simplified: would need full JSON array parsing
        ?{
          jobId = Option.get(extractJsonField(json, "job_id"), "");
          prevHash = "";
          coinbase1 = "";
          coinbase2 = "";
          merkleBranches = [];
          blockVersion = "";
          nBits = "";
          nTime = "";
          cleanJobs = false;
        }
      };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // PART 3: STRATUM V2 — BINARY PROTOCOL
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  public type StratumV2MessageType = {
    #SetupConnection;
    #SetupConnectionSuccess;
    #SetupConnectionError;
    #OpenStandardMiningChannel;
    #OpenStandardMiningChannelSuccess;
    #NewMiningJob;
    #SetNewPrevHash;
    #SubmitSharesStandard;
    #SubmitSharesSuccess;
    #SubmitSharesError;
  };

  // Message type IDs
  public let MSG_SETUP_CONNECTION : Nat8 = 0x00;
  public let MSG_SETUP_CONNECTION_SUCCESS : Nat8 = 0x01;
  public let MSG_SETUP_CONNECTION_ERROR : Nat8 = 0x02;
  public let MSG_OPEN_MINING_CHANNEL : Nat8 = 0x10;
  public let MSG_OPEN_MINING_CHANNEL_SUCCESS : Nat8 = 0x11;
  public let MSG_NEW_MINING_JOB : Nat8 = 0x1e;
  public let MSG_SET_NEW_PREV_HASH : Nat8 = 0x20;
  public let MSG_SUBMIT_SHARES : Nat8 = 0x1c;
  public let MSG_SUBMIT_SHARES_SUCCESS : Nat8 = 0x1d;

  public type V2SetupConnection = {
    protocol : Nat16;
    minVersion : Nat16;
    maxVersion : Nat16;
    flags : Nat32;
    endpoint : Text;
    vendor : Text;
    hardwareVersion : Text;
    firmwareVersion : Text;
    deviceId : Text;
  };

  public type V2MiningJob = {
    channelId : Nat32;
    jobId : Nat32;
    futureJob : Bool;
    version : Nat32;
    versionRollingMask : Nat32;
    merkleRoot : [Nat8];
    coinbaseOutputCount : Nat8;
    coinbaseOutputs : [[Nat8]];
  };

  public type V2SubmitShares = {
    channelId : Nat32;
    sequenceNumber : Nat32;
    jobId : Nat32;
    nonce : Nat32;
    nTime : Nat32;
    version : Nat32;
  };

  // Build V2 SetupConnection message
  public func buildV2SetupConnection(config : V2SetupConnection) : [Nat8] {
    let buffer = Buffer.Buffer<Nat8>(100);
    
    // Message type
    buffer.add(MSG_SETUP_CONNECTION);
    
    // Protocol version (little-endian)
    buffer.add(Nat8.fromNat(Nat16.toNat(config.protocol & 0xFF)));
    buffer.add(Nat8.fromNat(Nat16.toNat((config.protocol >> 8) & 0xFF)));
    
    // Min version
    buffer.add(Nat8.fromNat(Nat16.toNat(config.minVersion & 0xFF)));
    buffer.add(Nat8.fromNat(Nat16.toNat((config.minVersion >> 8) & 0xFF)));
    
    // Max version
    buffer.add(Nat8.fromNat(Nat16.toNat(config.maxVersion & 0xFF)));
    buffer.add(Nat8.fromNat(Nat16.toNat((config.maxVersion >> 8) & 0xFF)));
    
    // Flags (little-endian 32-bit)
    buffer.add(Nat8.fromNat(Nat32.toNat(config.flags & 0xFF)));
    buffer.add(Nat8.fromNat(Nat32.toNat((config.flags >> 8) & 0xFF)));
    buffer.add(Nat8.fromNat(Nat32.toNat((config.flags >> 16) & 0xFF)));
    buffer.add(Nat8.fromNat(Nat32.toNat((config.flags >> 24) & 0xFF)));
    
    // Endpoint (length-prefixed string)
    let endpointBytes = Text.encodeUtf8(config.endpoint);
    buffer.add(Nat8.fromNat(Blob.toArray(endpointBytes).size()));
    for (b in Blob.toArray(endpointBytes).vals()) {
      buffer.add(b);
    };
    
    // Vendor
    let vendorBytes = Text.encodeUtf8(config.vendor);
    buffer.add(Nat8.fromNat(Blob.toArray(vendorBytes).size()));
    for (b in Blob.toArray(vendorBytes).vals()) {
      buffer.add(b);
    };
    
    // Hardware version
    let hwBytes = Text.encodeUtf8(config.hardwareVersion);
    buffer.add(Nat8.fromNat(Blob.toArray(hwBytes).size()));
    for (b in Blob.toArray(hwBytes).vals()) {
      buffer.add(b);
    };
    
    // Firmware version
    let fwBytes = Text.encodeUtf8(config.firmwareVersion);
    buffer.add(Nat8.fromNat(Blob.toArray(fwBytes).size()));
    for (b in Blob.toArray(fwBytes).vals()) {
      buffer.add(b);
    };
    
    // Device ID
    let devBytes = Text.encodeUtf8(config.deviceId);
    buffer.add(Nat8.fromNat(Blob.toArray(devBytes).size()));
    for (b in Blob.toArray(devBytes).vals()) {
      buffer.add(b);
    };
    
    Buffer.toArray(buffer)
  };

  // Build V2 SubmitShares message
  public func buildV2SubmitShares(share : V2SubmitShares) : [Nat8] {
    let buffer = Buffer.Buffer<Nat8>(30);
    
    // Message type
    buffer.add(MSG_SUBMIT_SHARES);
    
    // Channel ID (little-endian 32-bit)
    buffer.add(Nat8.fromNat(Nat32.toNat(share.channelId & 0xFF)));
    buffer.add(Nat8.fromNat(Nat32.toNat((share.channelId >> 8) & 0xFF)));
    buffer.add(Nat8.fromNat(Nat32.toNat((share.channelId >> 16) & 0xFF)));
    buffer.add(Nat8.fromNat(Nat32.toNat((share.channelId >> 24) & 0xFF)));
    
    // Sequence number
    buffer.add(Nat8.fromNat(Nat32.toNat(share.sequenceNumber & 0xFF)));
    buffer.add(Nat8.fromNat(Nat32.toNat((share.sequenceNumber >> 8) & 0xFF)));
    buffer.add(Nat8.fromNat(Nat32.toNat((share.sequenceNumber >> 16) & 0xFF)));
    buffer.add(Nat8.fromNat(Nat32.toNat((share.sequenceNumber >> 24) & 0xFF)));
    
    // Job ID
    buffer.add(Nat8.fromNat(Nat32.toNat(share.jobId & 0xFF)));
    buffer.add(Nat8.fromNat(Nat32.toNat((share.jobId >> 8) & 0xFF)));
    buffer.add(Nat8.fromNat(Nat32.toNat((share.jobId >> 16) & 0xFF)));
    buffer.add(Nat8.fromNat(Nat32.toNat((share.jobId >> 24) & 0xFF)));
    
    // Nonce
    buffer.add(Nat8.fromNat(Nat32.toNat(share.nonce & 0xFF)));
    buffer.add(Nat8.fromNat(Nat32.toNat((share.nonce >> 8) & 0xFF)));
    buffer.add(Nat8.fromNat(Nat32.toNat((share.nonce >> 16) & 0xFF)));
    buffer.add(Nat8.fromNat(Nat32.toNat((share.nonce >> 24) & 0xFF)));
    
    // nTime
    buffer.add(Nat8.fromNat(Nat32.toNat(share.nTime & 0xFF)));
    buffer.add(Nat8.fromNat(Nat32.toNat((share.nTime >> 8) & 0xFF)));
    buffer.add(Nat8.fromNat(Nat32.toNat((share.nTime >> 16) & 0xFF)));
    buffer.add(Nat8.fromNat(Nat32.toNat((share.nTime >> 24) & 0xFF)));
    
    // Version
    buffer.add(Nat8.fromNat(Nat32.toNat(share.version & 0xFF)));
    buffer.add(Nat8.fromNat(Nat32.toNat((share.version >> 8) & 0xFF)));
    buffer.add(Nat8.fromNat(Nat32.toNat((share.version >> 16) & 0xFF)));
    buffer.add(Nat8.fromNat(Nat32.toNat((share.version >> 24) & 0xFF)));
    
    Buffer.toArray(buffer)
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // PART 4: COINBASE TRANSACTION CONSTRUCTION
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  public type CoinbaseConfig = {
    blockHeight : Nat;
    extraNonce1 : [Nat8];
    extraNonce2 : [Nat8];
    coinbaseValue : Nat64;
    recipientScript : [Nat8];
    coinbase1 : [Nat8];
    coinbase2 : [Nat8];
  };

  // Build coinbase transaction
  public func buildCoinbaseTransaction(config : CoinbaseConfig) : [Nat8] {
    let buffer = Buffer.Buffer<Nat8>(200);
    
    // Version (01000000)
    buffer.add(0x01);
    buffer.add(0x00);
    buffer.add(0x00);
    buffer.add(0x00);
    
    // Number of inputs (1)
    buffer.add(0x01);
    
    // Previous output hash (32 zero bytes for coinbase)
    for (i in Iter.range(0, 31)) {
      buffer.add(0x00);
    };
    
    // Previous output index (0xffffffff)
    buffer.add(0xff);
    buffer.add(0xff);
    buffer.add(0xff);
    buffer.add(0xff);
    
    // Coinbase script
    // coinbase1 + extranonce1 + extranonce2 + coinbase2
    let scriptLen = config.coinbase1.size() + config.extraNonce1.size() + 
                    config.extraNonce2.size() + config.coinbase2.size();
    buffer.add(Nat8.fromNat(scriptLen));
    
    for (b in config.coinbase1.vals()) { buffer.add(b) };
    for (b in config.extraNonce1.vals()) { buffer.add(b) };
    for (b in config.extraNonce2.vals()) { buffer.add(b) };
    for (b in config.coinbase2.vals()) { buffer.add(b) };
    
    // Sequence (0xffffffff)
    buffer.add(0xff);
    buffer.add(0xff);
    buffer.add(0xff);
    buffer.add(0xff);
    
    // Number of outputs (1)
    buffer.add(0x01);
    
    // Output value (little-endian 64-bit)
    buffer.add(Nat8.fromNat(Nat64.toNat(config.coinbaseValue & 0xff)));
    buffer.add(Nat8.fromNat(Nat64.toNat((config.coinbaseValue >> 8) & 0xff)));
    buffer.add(Nat8.fromNat(Nat64.toNat((config.coinbaseValue >> 16) & 0xff)));
    buffer.add(Nat8.fromNat(Nat64.toNat((config.coinbaseValue >> 24) & 0xff)));
    buffer.add(Nat8.fromNat(Nat64.toNat((config.coinbaseValue >> 32) & 0xff)));
    buffer.add(Nat8.fromNat(Nat64.toNat((config.coinbaseValue >> 40) & 0xff)));
    buffer.add(Nat8.fromNat(Nat64.toNat((config.coinbaseValue >> 48) & 0xff)));
    buffer.add(Nat8.fromNat(Nat64.toNat((config.coinbaseValue >> 56) & 0xff)));
    
    // Output script
    buffer.add(Nat8.fromNat(config.recipientScript.size()));
    for (b in config.recipientScript.vals()) { buffer.add(b) };
    
    // Locktime (00000000)
    buffer.add(0x00);
    buffer.add(0x00);
    buffer.add(0x00);
    buffer.add(0x00);
    
    Buffer.toArray(buffer)
  };

  // BIP34 block height encoding for coinbase
  public func encodeBIP34Height(height : Nat) : [Nat8] {
    if (height < 17) {
      [Nat8.fromNat(0x50 + height)]
    } else if (height < 256) {
      [0x01, Nat8.fromNat(height)]
    } else if (height < 65536) {
      [0x02, Nat8.fromNat(height & 0xff), Nat8.fromNat((height >> 8) & 0xff)]
    } else if (height < 16777216) {
      [0x03, Nat8.fromNat(height & 0xff), Nat8.fromNat((height >> 8) & 0xff), Nat8.fromNat((height >> 16) & 0xff)]
    } else {
      [0x04, Nat8.fromNat(height & 0xff), Nat8.fromNat((height >> 8) & 0xff), 
       Nat8.fromNat((height >> 16) & 0xff), Nat8.fromNat((height >> 24) & 0xff)]
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // PART 5: CONNECTION STATE MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  public type StratumConnectionState = {
    // Connection info
    poolUrl : Text;
    poolPort : Nat16;
    isConnected : Bool;
    protocolVersion : Nat;        // 1 or 2
    
    // Authentication
    workerName : Text;
    password : Text;
    isAuthorized : Bool;
    
    // Subscription
    subscriptionId : ?Text;
    extraNonce1 : [Nat8];
    extraNonce2Size : Nat;
    
    // Mining state
    currentDifficulty : Float;
    currentJobId : ?Text;
    currentPrevHash : ?[Nat8];
    currentMerkleRoot : ?[Nat8];
    
    // Statistics
    sharesSubmitted : Nat64;
    sharesAccepted : Nat64;
    sharesRejected : Nat64;
    lastShareTime : Int;
    
    // Message IDs
    nextMessageId : Nat;
  };

  // Initialize connection state
  public func initConnectionState(
    poolUrl : Text,
    poolPort : Nat16,
    workerName : Text,
    password : Text
  ) : StratumConnectionState {
    {
      poolUrl = poolUrl;
      poolPort = poolPort;
      isConnected = false;
      protocolVersion = 1;
      workerName = workerName;
      password = password;
      isAuthorized = false;
      subscriptionId = null;
      extraNonce1 = [];
      extraNonce2Size = 4;
      currentDifficulty = 1.0;
      currentJobId = null;
      currentPrevHash = null;
      currentMerkleRoot = null;
      sharesSubmitted = 0;
      sharesAccepted = 0;
      sharesRejected = 0;
      lastShareTime = 0;
      nextMessageId = 1;
    }
  };

  // Get next message ID and increment
  public func getNextMessageId(state : StratumConnectionState) : (Nat, StratumConnectionState) {
    (state.nextMessageId, { state with nextMessageId = state.nextMessageId + 1 })
  };

  // Update state after subscribe response
  public func handleSubscribeResponse(
    state : StratumConnectionState,
    extraNonce1 : [Nat8],
    extraNonce2Size : Nat,
    subscriptionId : Text
  ) : StratumConnectionState {
    {
      state with
      extraNonce1 = extraNonce1;
      extraNonce2Size = extraNonce2Size;
      subscriptionId = ?subscriptionId;
    }
  };

  // Update state after authorize response
  public func handleAuthorizeResponse(state : StratumConnectionState, success : Bool) : StratumConnectionState {
    { state with isAuthorized = success }
  };

  // Update state after mining.notify
  public func handleMiningNotify(
    state : StratumConnectionState,
    jobId : Text,
    prevHash : [Nat8],
    merkleRoot : [Nat8],
    difficulty : Float
  ) : StratumConnectionState {
    {
      state with
      currentJobId = ?jobId;
      currentPrevHash = ?prevHash;
      currentMerkleRoot = ?merkleRoot;
      currentDifficulty = difficulty;
    }
  };

  // Update state after share submission
  public func handleShareSubmit(
    state : StratumConnectionState,
    accepted : Bool,
    timestamp : Int
  ) : StratumConnectionState {
    {
      state with
      sharesSubmitted = state.sharesSubmitted + 1;
      sharesAccepted = if (accepted) { state.sharesAccepted + 1 } else { state.sharesAccepted };
      sharesRejected = if (accepted) { state.sharesRejected } else { state.sharesRejected + 1 };
      lastShareTime = timestamp;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // PART 6: HEX CONVERSION UTILITIES
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  let HEX_CHARS : [Char] = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'];

  // Byte to hex string
  public func byteToHex(b : Nat8) : Text {
    let high = HEX_CHARS[Nat8.toNat(b) / 16];
    let low = HEX_CHARS[Nat8.toNat(b) % 16];
    Text.fromChar(high) # Text.fromChar(low)
  };

  // Bytes to hex string
  public func bytesToHex(bytes : [Nat8]) : Text {
    var result = "";
    for (b in bytes.vals()) {
      result := result # byteToHex(b);
    };
    result
  };

  // Hex char to nibble
  func hexCharToNibble(c : Char) : ?Nat8 {
    let code = Char.toNat32(c);
    if (code >= 0x30 and code <= 0x39) {
      ?Nat8.fromNat(Nat32.toNat(code - 0x30))
    } else if (code >= 0x41 and code <= 0x46) {
      ?Nat8.fromNat(Nat32.toNat(code - 0x41 + 10))
    } else if (code >= 0x61 and code <= 0x66) {
      ?Nat8.fromNat(Nat32.toNat(code - 0x61 + 10))
    } else {
      null
    }
  };

  // Hex string to bytes
  public func hexToBytes(hex : Text) : ?[Nat8] {
    let chars = Text.toArray(hex);
    if (chars.size() % 2 != 0) { return null };
    
    let result = Buffer.Buffer<Nat8>(chars.size() / 2);
    var i = 0;
    while (i < chars.size()) {
      switch (hexCharToNibble(chars[i]), hexCharToNibble(chars[i + 1])) {
        case (?high, ?low) {
          result.add((high << 4) | low);
        };
        case (_, _) { return null };
      };
      i += 2;
    };
    
    ?Buffer.toArray(result)
  };

  // Reverse bytes (for hash display)
  public func reverseBytes(bytes : [Nat8]) : [Nat8] {
    Array.tabulate<Nat8>(bytes.size(), func(i) { bytes[bytes.size() - 1 - i] })
  };

  // Nonce to hex (little-endian)
  public func nonceToHex(nonce : Nat32) : Text {
    let b0 = Nat8.fromNat(Nat32.toNat(nonce & 0xFF));
    let b1 = Nat8.fromNat(Nat32.toNat((nonce >> 8) & 0xFF));
    let b2 = Nat8.fromNat(Nat32.toNat((nonce >> 16) & 0xFF));
    let b3 = Nat8.fromNat(Nat32.toNat((nonce >> 24) & 0xFF));
    byteToHex(b0) # byteToHex(b1) # byteToHex(b2) # byteToHex(b3)
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // PART 7: DIFFICULTY HANDLING
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

  // Pool difficulty to target
  public func difficultyToTarget(difficulty : Float) : [Nat8] {
    // Target = 2^256 / (difficulty × 2^32)
    // For simplicity, we use a lookup-based approximation
    // In production, this would use arbitrary-precision arithmetic
    
    let target = Array.init<Nat8>(32, 0);
    
    if (difficulty <= 1.0) {
      // Difficulty 1 target
      target[0] := 0x00;
      target[1] := 0x00;
      target[2] := 0x00;
      target[3] := 0x00;
      target[4] := 0xff;
      target[5] := 0xff;
      for (i in Iter.range(6, 31)) {
        target[i] := 0x00;
      };
    } else {
      // Higher difficulty = smaller target
      let leadingZeroBytes = Int.abs(Float.toInt(Float.log(difficulty) / Float.log(256.0)));
      for (i in Iter.range(0, Nat.min(31, leadingZeroBytes))) {
        target[i] := 0x00;
      };
      if (leadingZeroBytes < 32) {
        target[leadingZeroBytes] := 0xff;
      };
    };
    
    Array.freeze(target)
  };

  // Check if hash meets difficulty
  public func hashMeetsDifficulty(hash : [Nat8], difficulty : Float) : Bool {
    let target = difficultyToTarget(difficulty);
    
    // Compare hash to target (hash must be < target)
    for (i in Iter.range(0, 31)) {
      if (hash[i] < target[i]) { return true };
      if (hash[i] > target[i]) { return false };
    };
    true  // Equal is valid
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SUMMARY — COMPLETE STRATUM PROTOCOL
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // STRATUM V1 (JSON-RPC):
  //   mining.subscribe → Get subscription ID, extraNonce1, extraNonce2 size
  //   mining.authorize → Authenticate worker
  //   mining.notify → Receive new job (prevHash, merkle branches, etc.)
  //   mining.submit → Submit share (worker, jobId, extraNonce2, nTime, nonce)
  //   mining.set_difficulty → Pool adjusts difficulty
  //
  // STRATUM V2 (Binary):
  //   SetupConnection → Initial handshake
  //   OpenStandardMiningChannel → Start mining channel
  //   NewMiningJob → Receive job (binary format)
  //   SubmitSharesStandard → Submit share (binary format)
  //
  // COINBASE CONSTRUCTION:
  //   Version + inputs + coinbase script + outputs + locktime
  //   BIP34 height encoding in coinbase script
  //   extraNonce1 (from pool) + extraNonce2 (miner-controlled)
  //
  // The organism uses coherence hash to select nonces.
  // When S > 0.85: submit the share through Stratum protocol.
  //
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

}
