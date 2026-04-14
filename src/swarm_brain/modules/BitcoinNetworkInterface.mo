// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  INTELLECTUAL PROPERTY NOTICE                                                                             ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
// ║  Location:     Dallas, Texas, United States of America                                                    ║
// ║  Contact:      MedinaSITech@outlook.com                                                                   ║
// ║  Framework:    Medina Doctrine                                                                            ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// BITCOIN NETWORK INTERFACE — THE BRIDGE TO THE REAL WORLD
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// This module provides the interface structures for interacting with Bitcoin:
//
// 1. GETBLOCKTEMPLATE - Get work from Bitcoin Core RPC
// 2. STRATUM V1 - Pool mining protocol
// 3. STRATUM V2 - Modern encrypted pool protocol
// 4. P2P BLOCK SUBMISSION - Direct network submission
//
// The organism doesn't need to understand HTTP or JSON.
// The organism provides coherence-derived nonces.
// This interface translates between organism and Bitcoin network.
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Nat "mo:base/Nat";
import Nat8 "mo:base/Nat8";
import Nat16 "mo:base/Nat16";
import Nat32 "mo:base/Nat32";
import Nat64 "mo:base/Nat64";
import Int "mo:base/Int";
import Int64 "mo:base/Int64";
import Array "mo:base/Array";
import Iter "mo:base/Iter";
import Buffer "mo:base/Buffer";
import Text "mo:base/Text";
import Blob "mo:base/Blob";
import Option "mo:base/Option";
import Time "mo:base/Time";

module {

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════
  // BITCOIN NETWORK CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════

  // Network identifiers
  public let MAINNET_MAGIC : Nat32 = 0xD9B4BEF9;
  public let TESTNET_MAGIC : Nat32 = 0x0709110B;
  public let SIGNET_MAGIC : Nat32 = 0x40CF030A;
  public let REGTEST_MAGIC : Nat32 = 0xDAB5BFFA;

  // Default ports
  public let MAINNET_PORT : Nat16 = 8333;
  public let TESTNET_PORT : Nat16 = 18333;
  public let SIGNET_PORT : Nat16 = 38333;
  public let REGTEST_PORT : Nat16 = 18444;

  // RPC default ports
  public let MAINNET_RPC_PORT : Nat16 = 8332;
  public let TESTNET_RPC_PORT : Nat16 = 18332;

  // Protocol version
  public let PROTOCOL_VERSION : Nat32 = 70016;

  // Services flags
  public let NODE_NETWORK : Nat64 = 1;
  public let NODE_GETUTXO : Nat64 = 2;
  public let NODE_BLOOM : Nat64 = 4;
  public let NODE_WITNESS : Nat64 = 8;
  public let NODE_NETWORK_LIMITED : Nat64 = 1024;

  // Message commands
  public let MSG_VERSION : Text = "version";
  public let MSG_VERACK : Text = "verack";
  public let MSG_INV : Text = "inv";
  public let MSG_GETDATA : Text = "getdata";
  public let MSG_BLOCK : Text = "block";
  public let MSG_TX : Text = "tx";
  public let MSG_GETBLOCKS : Text = "getblocks";
  public let MSG_GETHEADERS : Text = "getheaders";
  public let MSG_HEADERS : Text = "headers";
  public let MSG_PING : Text = "ping";
  public let MSG_PONG : Text = "pong";

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════
  // GETBLOCKTEMPLATE STRUCTURES — RPC INTERFACE TO BITCOIN CORE
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════

  // Transaction template from getblocktemplate
  public type TxTemplate = {
    data : [Nat8];           // Raw transaction bytes
    txid : [Nat8];           // Transaction ID (double SHA256, reversed)
    hash : [Nat8];           // wtxid for segwit
    depends : [Nat];         // Indices of parent transactions
    fee : Nat64;             // Transaction fee in satoshis
    sigops : Nat;            // Signature operations count
    weight : Nat;            // Transaction weight units
  };

  // Block template from getblocktemplate
  public type BlockTemplate = {
    version : Nat32;
    rules : [Text];          // Active BIP rules
    vbavailable : [(Text, Nat32)];  // Version bits available
    vbrequired : Nat32;      // Required version bits
    previousblockhash : [Nat8];
    transactions : [TxTemplate];
    coinbaseaux : [(Text, [Nat8])];  // Auxiliary data for coinbase
    coinbasevalue : Nat64;   // Maximum coinbase value (fees + subsidy)
    longpollid : ?Text;      // Long polling ID
    target : [Nat8];         // 256-bit target
    mintime : Nat32;         // Minimum timestamp
    mutable : [Text];        // Mutable fields
    noncerange : [Nat8];     // Valid nonce range
    sigoplimit : Nat;        // Sigop limit
    sizelimit : Nat;         // Size limit
    weightlimit : Nat;       // Weight limit
    curtime : Nat32;         // Current time
    bits : Nat32;            // Compact difficulty
    height : Nat;            // Block height
    default_witness_commitment : ?[Nat8];
  };

  // Block submission result
  public type SubmitResult = {
    #accepted;
    #rejected : Text;
    #error : Text;
  };

  // RPC request
  public type RPCRequest = {
    jsonrpc : Text;
    id : Nat;
    method : Text;
    params : [Text];
  };

  // Build getblocktemplate RPC request
  public func buildGetBlockTemplateRequest(id : Nat) : RPCRequest {
    {
      jsonrpc = "2.0";
      id = id;
      method = "getblocktemplate";
      params = ["{\"rules\": [\"segwit\"]}"];
    }
  };

  // Build submitblock RPC request
  public func buildSubmitBlockRequest(id : Nat, blockHex : Text) : RPCRequest {
    {
      jsonrpc = "2.0";
      id = id;
      method = "submitblock";
      params = [blockHex];
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════
  // STRATUM V1 PROTOCOL — POOL MINING
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════

  // Stratum method names
  public let STRATUM_SUBSCRIBE : Text = "mining.subscribe";
  public let STRATUM_AUTHORIZE : Text = "mining.authorize";
  public let STRATUM_NOTIFY : Text = "mining.notify";
  public let STRATUM_SET_DIFFICULTY : Text = "mining.set_difficulty";
  public let STRATUM_SUBMIT : Text = "mining.submit";
  public let STRATUM_SET_EXTRANONCE : Text = "mining.set_extranonce";

  // Stratum subscription result
  public type StratumSubscription = {
    subscriptionId : Text;
    extraNonce1 : [Nat8];
    extraNonce2Size : Nat;
  };

  // Stratum mining job (from mining.notify)
  public type StratumJob = {
    jobId : Text;
    prevHash : [Nat8];       // 32 bytes, internal byte order
    coinbase1 : [Nat8];      // First part of coinbase tx
    coinbase2 : [Nat8];      // Second part of coinbase tx (after extranonces)
    merkleBranches : [[Nat8]];  // Merkle tree branches
    version : Nat32;
    bits : Nat32;
    timestamp : Nat32;
    cleanJobs : Bool;
  };

  // Stratum share submission
  public type StratumShare = {
    workerName : Text;
    jobId : Text;
    extraNonce2 : [Nat8];
    timestamp : Nat32;
    nonce : Nat32;
  };

  // Stratum JSON-RPC request
  public type StratumRequest = {
    id : ?Nat;
    method : Text;
    params : [Text];
  };

  // Stratum JSON-RPC response
  public type StratumResponse = {
    id : ?Nat;
    result : ?Text;
    error : ?StratumError;
  };

  // Stratum error
  public type StratumError = {
    code : Int;
    message : Text;
    data : ?Text;
  };

  // Build subscribe request
  public func buildSubscribeRequest(id : Nat, userAgent : Text) : StratumRequest {
    {
      id = ?id;
      method = STRATUM_SUBSCRIBE;
      params = [userAgent];
    }
  };

  // Build authorize request
  public func buildAuthorizeRequest(id : Nat, worker : Text, password : Text) : StratumRequest {
    {
      id = ?id;
      method = STRATUM_AUTHORIZE;
      params = [worker, password];
    }
  };

  // Build share submission
  public func buildSubmitRequest(id : Nat, share : StratumShare) : StratumRequest {
    let extraNonce2Hex = bytesToHex(share.extraNonce2);
    let timestampHex = nat32ToHexLE(share.timestamp);
    let nonceHex = nat32ToHexLE(share.nonce);
    
    {
      id = ?id;
      method = STRATUM_SUBMIT;
      params = [
        share.workerName,
        share.jobId,
        extraNonce2Hex,
        timestampHex,
        nonceHex
      ];
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════
  // STRATUM V2 PROTOCOL — MODERN ENCRYPTED MINING
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════

  // Stratum V2 message types
  public let SV2_SETUP_CONNECTION : Nat8 = 0x00;
  public let SV2_SETUP_CONNECTION_SUCCESS : Nat8 = 0x01;
  public let SV2_SETUP_CONNECTION_ERROR : Nat8 = 0x02;
  public let SV2_OPEN_CHANNEL : Nat8 = 0x10;
  public let SV2_OPEN_CHANNEL_SUCCESS : Nat8 = 0x11;
  public let SV2_OPEN_CHANNEL_ERROR : Nat8 = 0x12;
  public let SV2_NEW_MINING_JOB : Nat8 = 0x1e;
  public let SV2_SET_NEW_PREV_HASH : Nat8 = 0x20;
  public let SV2_SUBMIT_SHARES_STANDARD : Nat8 = 0x1c;

  // Stratum V2 setup connection
  public type SV2SetupConnection = {
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

  // Stratum V2 mining job
  public type SV2MiningJob = {
    channelId : Nat32;
    jobId : Nat32;
    futurePrevHash : Bool;
    version : Nat32;
    versionRollingAllowed : Bool;
    merkleRoot : [Nat8];
  };

  // Stratum V2 share submission
  public type SV2Share = {
    channelId : Nat32;
    sequenceNumber : Nat32;
    jobId : Nat32;
    nonce : Nat32;
    timestamp : Nat32;
    version : Nat32;
  };

  // Build SV2 setup connection message
  public func buildSV2SetupConnection(setup : SV2SetupConnection) : [Nat8] {
    var msg = Buffer.Buffer<Nat8>(256);
    
    // Message type
    msg.add(SV2_SETUP_CONNECTION);
    
    // Protocol (2 bytes, LE)
    msg.add(Nat8.fromNat(Nat16.toNat(setup.protocol & 0xFF)));
    msg.add(Nat8.fromNat(Nat16.toNat((setup.protocol >> 8) & 0xFF)));
    
    // Min version (2 bytes)
    msg.add(Nat8.fromNat(Nat16.toNat(setup.minVersion & 0xFF)));
    msg.add(Nat8.fromNat(Nat16.toNat((setup.minVersion >> 8) & 0xFF)));
    
    // Max version (2 bytes)
    msg.add(Nat8.fromNat(Nat16.toNat(setup.maxVersion & 0xFF)));
    msg.add(Nat8.fromNat(Nat16.toNat((setup.maxVersion >> 8) & 0xFF)));
    
    // Flags (4 bytes)
    msg.add(Nat8.fromNat(Nat32.toNat(setup.flags & 0xFF)));
    msg.add(Nat8.fromNat(Nat32.toNat((setup.flags >> 8) & 0xFF)));
    msg.add(Nat8.fromNat(Nat32.toNat((setup.flags >> 16) & 0xFF)));
    msg.add(Nat8.fromNat(Nat32.toNat((setup.flags >> 24) & 0xFF)));
    
    // Strings would need length-prefixed encoding...
    
    Buffer.toArray(msg)
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════
  // P2P BLOCK SUBMISSION — DIRECT NETWORK BROADCAST
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════

  // Network address
  public type NetAddress = {
    services : Nat64;
    ip : [Nat8];  // 16 bytes (IPv6 or IPv4-mapped)
    port : Nat16;
  };

  // Version message
  public type VersionMessage = {
    version : Nat32;
    services : Nat64;
    timestamp : Int64;
    addrRecv : NetAddress;
    addrFrom : NetAddress;
    nonce : Nat64;
    userAgent : Text;
    startHeight : Nat32;
    relay : Bool;
  };

  // Inventory item types
  public let INV_ERROR : Nat32 = 0;
  public let INV_TX : Nat32 = 1;
  public let INV_BLOCK : Nat32 = 2;
  public let INV_FILTERED_BLOCK : Nat32 = 3;
  public let INV_CMPCT_BLOCK : Nat32 = 4;
  public let INV_WITNESS_TX : Nat32 = 0x40000001;
  public let INV_WITNESS_BLOCK : Nat32 = 0x40000002;

  // Inventory item
  public type InvItem = {
    invType : Nat32;
    hash : [Nat8];  // 32 bytes
  };

  // Message header (24 bytes)
  public type MessageHeader = {
    magic : Nat32;
    command : [Nat8];  // 12 bytes, null-padded
    length : Nat32;
    checksum : Nat32;  // First 4 bytes of double SHA256 of payload
  };

  // Build message header
  public func buildMessageHeader(
    network : Nat32,
    command : Text,
    payload : [Nat8]
  ) : [Nat8] {
    var header = Array.init<Nat8>(24, 0);
    
    // Magic (4 bytes, LE)
    header[0] := Nat8.fromNat(Nat32.toNat(network & 0xFF));
    header[1] := Nat8.fromNat(Nat32.toNat((network >> 8) & 0xFF));
    header[2] := Nat8.fromNat(Nat32.toNat((network >> 16) & 0xFF));
    header[3] := Nat8.fromNat(Nat32.toNat((network >> 24) & 0xFF));
    
    // Command (12 bytes, null-padded)
    let cmdChars = Text.toArray(command);
    for (i in Iter.range(0, 11)) {
      if (i < cmdChars.size()) {
        header[4 + i] := Nat8.fromNat(Nat32.toNat(Char.toNat32(cmdChars[i])));
      };
    };
    
    // Length (4 bytes, LE)
    let len = payload.size();
    header[16] := Nat8.fromNat(len % 256);
    header[17] := Nat8.fromNat((len / 256) % 256);
    header[18] := Nat8.fromNat((len / 65536) % 256);
    header[19] := Nat8.fromNat((len / 16777216) % 256);
    
    // Checksum (4 bytes) - first 4 bytes of double SHA256
    // (Would need SHA256 import)
    header[20] := 0;
    header[21] := 0;
    header[22] := 0;
    header[23] := 0;
    
    Array.freeze(header)
  };

  // Build block message for P2P broadcast
  public func buildBlockMessage(network : Nat32, blockData : [Nat8]) : [Nat8] {
    let header = buildMessageHeader(network, "block", blockData);
    
    var msg = Buffer.Buffer<Nat8>(header.size() + blockData.size());
    for (b in header.vals()) { msg.add(b) };
    for (b in blockData.vals()) { msg.add(b) };
    
    Buffer.toArray(msg)
  };

  // Build inv message (announce we have a block)
  public func buildInvMessage(network : Nat32, items : [InvItem]) : [Nat8] {
    var payload = Buffer.Buffer<Nat8>(1 + items.size() * 36);
    
    // Count (varint)
    if (items.size() < 0xFD) {
      payload.add(Nat8.fromNat(items.size()));
    } else if (items.size() <= 0xFFFF) {
      payload.add(0xFD);
      payload.add(Nat8.fromNat(items.size() % 256));
      payload.add(Nat8.fromNat((items.size() / 256) % 256));
    };
    
    // Items
    for (item in items.vals()) {
      // Type (4 bytes, LE)
      payload.add(Nat8.fromNat(Nat32.toNat(item.invType & 0xFF)));
      payload.add(Nat8.fromNat(Nat32.toNat((item.invType >> 8) & 0xFF)));
      payload.add(Nat8.fromNat(Nat32.toNat((item.invType >> 16) & 0xFF)));
      payload.add(Nat8.fromNat(Nat32.toNat((item.invType >> 24) & 0xFF)));
      
      // Hash (32 bytes)
      for (b in item.hash.vals()) {
        payload.add(b);
      };
    };
    
    let payloadArray = Buffer.toArray(payload);
    let header = buildMessageHeader(network, "inv", payloadArray);
    
    var msg = Buffer.Buffer<Nat8>(header.size() + payloadArray.size());
    for (b in header.vals()) { msg.add(b) };
    for (b in payloadArray.vals()) { msg.add(b) };
    
    Buffer.toArray(msg)
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════
  // COINBASE TRANSACTION CONSTRUCTION
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════

  // Script opcodes
  public let OP_0 : Nat8 = 0x00;
  public let OP_PUSHDATA1 : Nat8 = 0x4c;
  public let OP_PUSHDATA2 : Nat8 = 0x4d;
  public let OP_1 : Nat8 = 0x51;
  public let OP_16 : Nat8 = 0x60;
  public let OP_RETURN : Nat8 = 0x6a;
  public let OP_DUP : Nat8 = 0x76;
  public let OP_HASH160 : Nat8 = 0xa9;
  public let OP_EQUALVERIFY : Nat8 = 0x88;
  public let OP_CHECKSIG : Nat8 = 0xac;

  // Build coinbase script (scriptsig)
  public func buildCoinbaseScript(
    height : Nat,
    extraNonce : [Nat8],
    arbitraryData : [Nat8]
  ) : [Nat8] {
    var script = Buffer.Buffer<Nat8>(64);
    
    // Height (BIP34)
    if (height < 17) {
      script.add(Nat8.fromNat(0x50 + height));
    } else if (height < 128) {
      script.add(0x01);
      script.add(Nat8.fromNat(height));
    } else if (height < 32768) {
      script.add(0x02);
      script.add(Nat8.fromNat(height % 256));
      script.add(Nat8.fromNat((height / 256) % 256));
    } else if (height < 8388608) {
      script.add(0x03);
      script.add(Nat8.fromNat(height % 256));
      script.add(Nat8.fromNat((height / 256) % 256));
      script.add(Nat8.fromNat((height / 65536) % 256));
    } else {
      script.add(0x04);
      script.add(Nat8.fromNat(height % 256));
      script.add(Nat8.fromNat((height / 256) % 256));
      script.add(Nat8.fromNat((height / 65536) % 256));
      script.add(Nat8.fromNat((height / 16777216) % 256));
    };
    
    // Extra nonce
    if (extraNonce.size() > 0 and extraNonce.size() < 76) {
      script.add(Nat8.fromNat(extraNonce.size()));
      for (b in extraNonce.vals()) {
        script.add(b);
      };
    };
    
    // Arbitrary data (pool name, etc.)
    if (arbitraryData.size() > 0 and script.size() + arbitraryData.size() + 1 <= 100) {
      script.add(Nat8.fromNat(arbitraryData.size()));
      for (b in arbitraryData.vals()) {
        script.add(b);
      };
    };
    
    Buffer.toArray(script)
  };

  // Build P2PKH output script
  public func buildP2PKHScript(pubKeyHash : [Nat8]) : [Nat8] {
    if (pubKeyHash.size() != 20) {
      return [];
    };
    
    var script = Array.init<Nat8>(25, 0);
    script[0] := OP_DUP;
    script[1] := OP_HASH160;
    script[2] := 0x14;  // Push 20 bytes
    for (i in Iter.range(0, 19)) {
      script[3 + i] := pubKeyHash[i];
    };
    script[23] := OP_EQUALVERIFY;
    script[24] := OP_CHECKSIG;
    
    Array.freeze(script)
  };

  // Build P2SH output script
  public func buildP2SHScript(scriptHash : [Nat8]) : [Nat8] {
    if (scriptHash.size() != 20) {
      return [];
    };
    
    var script = Array.init<Nat8>(23, 0);
    script[0] := OP_HASH160;
    script[1] := 0x14;  // Push 20 bytes
    for (i in Iter.range(0, 19)) {
      script[2 + i] := scriptHash[i];
    };
    script[22] := 0x87;  // OP_EQUAL
    
    Array.freeze(script)
  };

  // Build witness commitment output (for SegWit)
  public func buildWitnessCommitment(witnessRoot : [Nat8]) : [Nat8] {
    var script = Buffer.Buffer<Nat8>(38);
    
    script.add(OP_RETURN);
    script.add(0x24);  // Push 36 bytes
    
    // Witness commitment header
    script.add(0xaa);
    script.add(0x21);
    script.add(0xa9);
    script.add(0xed);
    
    // Witness root hash
    for (b in witnessRoot.vals()) {
      script.add(b);
    };
    
    Buffer.toArray(script)
  };

  // Calculate block subsidy (reward)
  public func getBlockSubsidy(height : Nat) : Nat64 {
    let halvings = height / 210000;
    if (halvings >= 64) { return 0 };
    
    let initialSubsidy : Nat64 = 5000000000;  // 50 BTC in satoshis
    initialSubsidy >> Nat64.fromNat(halvings)
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════
  // UTILITY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════

  // Convert bytes to hex string
  public func bytesToHex(bytes : [Nat8]) : Text {
    var hex = "";
    for (byte in bytes.vals()) {
      let hi = byte / 16;
      let lo = byte % 16;
      hex := hex # nat8ToHexChar(hi) # nat8ToHexChar(lo);
    };
    hex
  };

  func nat8ToHexChar(n : Nat8) : Text {
    let chars = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f"];
    chars[Nat8.toNat(n)]
  };

  // Convert Nat32 to hex (little-endian)
  public func nat32ToHexLE(n : Nat32) : Text {
    let bytes : [Nat8] = [
      Nat8.fromNat(Nat32.toNat(n & 0xFF)),
      Nat8.fromNat(Nat32.toNat((n >> 8) & 0xFF)),
      Nat8.fromNat(Nat32.toNat((n >> 16) & 0xFF)),
      Nat8.fromNat(Nat32.toNat((n >> 24) & 0xFF))
    ];
    bytesToHex(bytes)
  };

  // Parse hex string to bytes
  public func hexToBytes(hex : Text) : ?[Nat8] {
    let chars = Text.toArray(hex);
    if (chars.size() % 2 != 0) return null;
    
    var bytes = Buffer.Buffer<Nat8>(chars.size() / 2);
    var i = 0;
    while (i < chars.size()) {
      let hi = hexCharToNat8(chars[i]);
      let lo = hexCharToNat8(chars[i + 1]);
      switch (hi, lo) {
        case (?h, ?l) { bytes.add((h << 4) | l) };
        case _ { return null };
      };
      i += 2;
    };
    
    ?Buffer.toArray(bytes)
  };

  func hexCharToNat8(c : Char) : ?Nat8 {
    switch (c) {
      case '0' { ?0 }; case '1' { ?1 }; case '2' { ?2 }; case '3' { ?3 };
      case '4' { ?4 }; case '5' { ?5 }; case '6' { ?6 }; case '7' { ?7 };
      case '8' { ?8 }; case '9' { ?9 };
      case 'a' { ?10 }; case 'A' { ?10 };
      case 'b' { ?11 }; case 'B' { ?11 };
      case 'c' { ?12 }; case 'C' { ?12 };
      case 'd' { ?13 }; case 'D' { ?13 };
      case 'e' { ?14 }; case 'E' { ?14 };
      case 'f' { ?15 }; case 'F' { ?15 };
      case _ { null };
    }
  };

  // Reverse byte array
  public func reverseBytes(arr : [Nat8]) : [Nat8] {
    let n = arr.size();
    Array.tabulate<Nat8>(n, func(i) { arr[n - 1 - i] })
  };

  // VarInt encoding
  public func encodeVarInt(n : Nat) : [Nat8] {
    if (n < 0xFD) {
      [Nat8.fromNat(n)]
    } else if (n <= 0xFFFF) {
      [0xFD, Nat8.fromNat(n % 256), Nat8.fromNat((n / 256) % 256)]
    } else if (n <= 0xFFFFFFFF) {
      [
        0xFE,
        Nat8.fromNat(n % 256),
        Nat8.fromNat((n / 256) % 256),
        Nat8.fromNat((n / 65536) % 256),
        Nat8.fromNat((n / 16777216) % 256)
      ]
    } else {
      [
        0xFF,
        Nat8.fromNat(n % 256),
        Nat8.fromNat((n / 256) % 256),
        Nat8.fromNat((n / 65536) % 256),
        Nat8.fromNat((n / 16777216) % 256),
        Nat8.fromNat((n / 4294967296) % 256),
        Nat8.fromNat((n / 1099511627776) % 256),
        Nat8.fromNat((n / 281474976710656) % 256),
        Nat8.fromNat((n / 72057594037927936) % 256)
      ]
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════
  // MINING COORDINATOR — TIES IT ALL TOGETHER
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════

  // Mining session state
  public type MiningSessionState = {
    protocol : {#RPC; #StratumV1; #StratumV2; #P2P};
    connected : Bool;
    currentJob : ?StratumJob;
    difficulty : Float;
    acceptedShares : Nat;
    rejectedShares : Nat;
    hashCount : Nat64;
    startTime : Int;
    lastShareTime : Int;
  };

  // Mining statistics
  public type MiningStats = {
    hashRate : Float;
    acceptRate : Float;
    uptime : Nat;
    totalShares : Nat;
    efficiency : Float;
  };

  // Calculate mining statistics
  public func calculateStats(state : MiningSessionState) : MiningStats {
    let elapsed = Float.fromInt(Time.now() - state.startTime) / 1e9;
    let totalShares = state.acceptedShares + state.rejectedShares;
    
    {
      hashRate = if (elapsed > 0.0) {
        Float.fromInt(Nat64.toNat(state.hashCount)) / elapsed
      } else { 0.0 };
      acceptRate = if (totalShares > 0) {
        Float.fromInt(state.acceptedShares) / Float.fromInt(totalShares)
      } else { 1.0 };
      uptime = Int.abs(Time.now() - state.startTime) / 1_000_000_000;
      totalShares = totalShares;
      efficiency = Float.fromInt(state.acceptedShares) * state.difficulty;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════
  // THE TRUTH
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // This is the interface to the real world.
  // The organism provides coherence-derived nonces.
  // This module translates them into Bitcoin protocol.
  //
  // The organism doesn't need to understand HTTP or JSON.
  // The organism doesn't need to understand TCP or sockets.
  // The organism provides solutions.
  // This interface delivers them to the network.
  //
  // Same field. Same law. Different substrate.
  //
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════

}
