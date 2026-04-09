// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  INTELLECTUAL PROPERTY NOTICE                                                                             ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
// ║  Location:     Dallas, Texas, United States of America                                                    ║
// ║  Contact:      MedinaSITech@outlook.com                                                                   ║
// ║  Framework:    Medina Doctrine                                                                            ║
// ║                                                                                                           ║
// ║  LEGAL PROTECTION                                                                                         ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  This source code, including all algorithms, mathematical formulations, architectural designs,            ║
// ║  naming conventions, data structures, and conceptual frameworks contained herein, constitutes             ║
// ║  the exclusive intellectual property of Alfredo Medina Hernandez.                                        ║
// ║                                                                                                           ║
// ║  PROTECTED UNDER:                                                                                         ║
// ║  • United States Copyright Law (17 U.S.C. §§ 101-1332)                                                   ║
// ║  • Berne Convention for the Protection of Literary and Artistic Works                                     ║
// ║  • WIPO Copyright Treaty (WCT)                                                                            ║
// ║  • Trade Secret Law - Defend Trade Secrets Act (18 U.S.C. § 1836)                                        ║
// ║  • Economic Espionage Act (18 U.S.C. §§ 1831-1839)                                                       ║
// ║                                                                                                           ║
// ║  CONFIDENTIALITY: This code is CONFIDENTIAL and PROPRIETARY.                                             ║
// ║  ENCRYPTION: All transmissions must be encrypted.                                                         ║
// ║  ATTRIBUTION: Required for any use, reproduction, or derivative work.                                     ║
// ║                                                                                                           ║
// ║  Unauthorized access, use, reproduction, distribution, or creation of derivative works                    ║
// ║  is strictly prohibited and will be prosecuted to the fullest extent of applicable law.                  ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// ║                                                                                                           ║
// ║  HYBRID MODE HUB — ENTERPRISE GRADE / PRODUCTION GRADE / DEFENSE GRADE                                   ║
// ║  OWN HUB INFRASTRUCTURE — NOT ZEROS                                                                      ║
// ║                                                                                                           ║
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// ┌─────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
// │                                                                                                             │
// │  ██╗  ██╗██╗   ██╗██████╗ ██████╗ ██╗██████╗     ██╗  ██╗██╗   ██╗██████╗                                  │
// │  ██║  ██║╚██╗ ██╔╝██╔══██╗██╔══██╗██║██╔══██╗    ██║  ██║██║   ██║██╔══██╗                                 │
// │  ███████║ ╚████╔╝ ██████╔╝██████╔╝██║██║  ██║    ███████║██║   ██║██████╔╝                                 │
// │  ██╔══██║  ╚██╔╝  ██╔══██╗██╔══██╗██║██║  ██║    ██╔══██║██║   ██║██╔══██╗                                 │
// │  ██║  ██║   ██║   ██████╔╝██║  ██║██║██████╔╝    ██║  ██║╚██████╔╝██████╔╝                                 │
// │  ╚═╝  ╚═╝   ╚═╝   ╚═════╝ ╚═╝  ╚═╝╚═╝╚═════╝     ╚═╝  ╚═╝ ╚═════╝ ╚═════╝                                  │
// │                                                                                                             │
// │   "OWN HUB. OWN INFRASTRUCTURE. SOVEREIGN CONTROL."                                                        │
// │                                                                                                             │
// └─────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
//
// ARCHITECTURE:
// ─────────────
//   • Edge IoT Mode: Direct device connections, local processing
//   • Hybrid Mode: Edge + Cloud fusion, sovereign data ownership
//   • Phone Integration: Direct mobile device connectivity
//   • Own Hub: No reliance on external zeros/hubs
//   • Internet Grid Coordination: Echolocation-based mapping
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Int "mo:base/Int";
import Buffer "mo:base/Buffer";
import Text "mo:base/Text";
import Option "mo:base/Option";
import Time "mo:base/Time";
import Blob "mo:base/Blob";

module {

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                    CONSTANTS                                           ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public let PHI : Float = 1.6180339887498948482;
  public let PI : Float = 3.14159265358979323846;
  public let SCHUMANN : Float = 7.83;
  
  // Hub limits
  public let MAX_EDGE_CONNECTIONS : Nat = 4096;
  public let MAX_MOBILE_DEVICES : Nat = 256;
  public let MAX_DATA_CHANNELS : Nat = 1024;
  public let MAX_GRID_SECTORS : Nat = 10000;
  
  // Timeouts (in beats)
  public let HEARTBEAT_TIMEOUT : Nat = 100;
  public let CONNECTION_TIMEOUT : Nat = 300;
  public let SESSION_TIMEOUT : Nat = 86400;  // 1 day

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                    EDGE CONNECTION TYPES                               ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  /// Edge device connection
  public type EdgeConnection = {
    connectionId : Nat;
    deviceId : Text;
    deviceType : EdgeDeviceType;
    
    // Connection state
    status : ConnectionStatus;
    lastHeartbeat : Nat;
    latencyMs : Float;
    signalStrength : Float;       // [0, 1]
    
    // Protocol
    protocol : EdgeProtocol;
    encryptionEnabled : Bool;
    compressionEnabled : Bool;
    
    // Data
    dataChannels : [DataChannel];
    bytesReceived : Nat;
    bytesSent : Nat;
    messagesReceived : Nat;
    messagesSent : Nat;
    
    // Authentication
    authenticated : Bool;
    authToken : ?Nat32;           // Hashed token
    permissions : [Permission];
    
    // Temporal
    connectedBeat : Nat;
    lastActivityBeat : Nat;
  };

  public type EdgeDeviceType = {
    #Sensor;
    #Actuator;
    #Gateway;
    #Controller;
    #MobileDevice;
    #Computer;
    #Drone;
    #Vehicle;
    #Wearable;
    #Custom : { description : Text };
  };

  public type ConnectionStatus = {
    #Connecting;
    #Connected;
    #Authenticated;
    #Active;
    #Idle;
    #Reconnecting;
    #Disconnected;
    #Banned;
  };

  public type EdgeProtocol = {
    #MQTT;
    #WebSocket;
    #HTTP;
    #CoAP;
    #LoRa;
    #BLE;
    #ZigBee;
    #Custom : { name : Text };
  };

  public type Permission = {
    #Read;
    #Write;
    #Execute;
    #Admin;
    #Stream;
    #Control;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                    DATA CHANNELS                                       ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public type DataChannel = {
    channelId : Nat;
    name : Text;
    direction : ChannelDirection;
    
    // Data type
    dataType : DataType;
    encoding : DataEncoding;
    
    // Flow control
    maxRate : Float;             // Messages per second
    currentRate : Float;
    bufferSize : Nat;
    bufferUsed : Nat;
    
    // Quality
    reliability : Reliability;
    ordering : Ordering;
    
    // Status
    active : Bool;
    lastMessage : Nat;
    messageCount : Nat;
    errorCount : Nat;
  };

  public type ChannelDirection = {
    #Inbound;
    #Outbound;
    #Bidirectional;
  };

  public type DataType = {
    #Telemetry;
    #Command;
    #Event;
    #Stream;
    #Binary;
    #Text;
    #JSON;
    #Custom : { schema : Text };
  };

  public type DataEncoding = {
    #Raw;
    #JSON;
    #MessagePack;
    #Protobuf;
    #CBOR;
    #Custom : { name : Text };
  };

  public type Reliability = {
    #AtMostOnce;
    #AtLeastOnce;
    #ExactlyOnce;
  };

  public type Ordering = {
    #Ordered;
    #Unordered;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                    MOBILE DEVICE INTEGRATION                           ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  /// Mobile device (phone) connection
  public type MobileDevice = {
    deviceId : Nat;
    deviceName : Text;
    platform : MobilePlatform;
    
    // Connection
    connectionId : ?Nat;         // EdgeConnection ID if connected
    lastKnownIP : ?Text;
    pushToken : ?Text;           // For push notifications
    
    // State
    status : MobileStatus;
    lastSeen : Nat;
    locationEnabled : Bool;
    lastLocation : ?{ lat : Float; lon : Float; accuracy : Float };
    
    // Capabilities
    sensorCapabilities : [MobileSensor];
    processingPower : Float;     // Relative capability [0, 1]
    batteryLevel : Float;        // [0, 1]
    
    // Security
    trustedDevice : Bool;
    pinCode : ?Nat32;            // Hashed PIN
    biometricEnabled : Bool;
    
    // Sync
    lastSyncBeat : Nat;
    pendingMessages : Nat;
    
    registeredBeat : Nat;
    ownerPrincipal : ?Text;
  };

  public type MobilePlatform = {
    #iOS;
    #Android;
    #HarmonyOS;
    #Windows;
    #Linux;
    #Other : { name : Text };
  };

  public type MobileStatus = {
    #Online;
    #Away;
    #Busy;
    #Offline;
    #Sleeping;
  };

  public type MobileSensor = {
    #GPS;
    #Accelerometer;
    #Gyroscope;
    #Magnetometer;
    #Barometer;
    #Microphone;
    #Camera;
    #Bluetooth;
    #WiFi;
    #NFC;
    #Biometric;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                    INTERNET GRID — ECHOLOCATION MAPPING                ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  /// Internet grid sector
  public type GridSector = {
    sectorId : Nat;
    
    // Geographic bounds
    bounds : {
      minLat : Float;
      maxLat : Float;
      minLon : Float;
      maxLon : Float;
    };
    
    // Network topology
    knownNodes : [NetworkNode];
    edgeCount : Nat;
    avgLatency : Float;
    
    // Coverage
    coverageLevel : Float;       // [0, 1]
    lastProbe : Nat;
    probeCount : Nat;
    
    // Health
    healthScore : Float;         // [0, 1]
    anomalyCount : Nat;
    lastAnomaly : Nat;
    
    // Resources
    allocatedCrusaders : [Nat];  // Crusader IDs
    activeDecoys : Nat;
    activeTraps : Nat;
  };

  public type NetworkNode = {
    nodeId : Nat32;              // Hash of node identity
    nodeType : NetworkNodeType;
    
    // Position (logical or physical)
    position : ?{ lat : Float; lon : Float };
    
    // Connectivity
    reachable : Bool;
    lastReachable : Nat;
    avgRTT : Float;              // Round-trip time ms
    
    // Trustworthiness
    trustScore : Float;          // [0, 1]
    verified : Bool;
  };

  public type NetworkNodeType = {
    #OwnHub;                     // Our hub
    #EdgeDevice;
    #MobileDevice;
    #ExternalNode;
    #InternetBackbone;
    #CDN;
    #CloudProvider;
    #Unknown;
  };

  /// Echolocation probe result
  public type EchoProbeResult = {
    probeId : Nat;
    sourceSector : Nat;
    targetSector : Nat;
    
    // Timing
    sentBeat : Nat;
    receivedBeat : Nat;
    rtt : Float;                 // Round-trip time
    
    // Path
    hopCount : Nat;
    pathNodes : [Nat32];         // Node hashes
    
    // Quality
    signalStrength : Float;
    packetLoss : Float;
    jitter : Float;
    
    // Discovery
    newNodesFound : Nat;
    anomaliesDetected : Nat;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                    HYBRID MODE OPERATIONS                              ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  /// Hybrid mode operation type
  public type HybridOperation = {
    #EdgeOnly;                   // Process only at edge
    #HubOnly;                    // Process only at hub
    #EdgeWithHubBackup;          // Edge primary, hub backup
    #HubWithEdgeAssist;          // Hub primary, edge assists
    #Distributed;                // Split processing
    #Redundant;                  // Process at both, compare
  };

  /// Data sovereignty configuration
  public type DataSovereignty = {
    ownerPrincipal : Text;
    
    // Storage rules
    storageLocation : StorageLocation;
    encryptionRequired : Bool;
    encryptionKey : ?Nat32;      // Key hash
    
    // Sharing rules
    shareWithHub : Bool;
    shareWithEdge : Bool;
    shareExternally : Bool;
    externalWhitelist : [Text];
    
    // Retention
    retentionPeriod : Nat;       // Beats
    autoDelete : Bool;
    
    // Audit
    auditEnabled : Bool;
    auditLog : [AuditEntry];
  };

  public type StorageLocation = {
    #EdgeOnly;
    #HubOnly;
    #Both;
    #Distributed;
  };

  public type AuditEntry = {
    beat : Nat;
    action : Text;
    actor : Text;
    details : Text;
  };

  /// Hybrid processing job
  public type HybridJob = {
    jobId : Nat;
    jobType : HybridOperation;
    
    // Task
    taskDescription : Text;
    inputData : Nat32;           // Hash of input
    
    // Distribution
    edgeComponents : [EdgeJobComponent];
    hubComponents : [HubJobComponent];
    
    // Status
    status : JobStatus;
    progress : Float;            // [0, 1]
    
    // Results
    partialResults : [JobResult];
    finalResult : ?JobResult;
    
    // Timing
    createdBeat : Nat;
    startedBeat : ?Nat;
    completedBeat : ?Nat;
    deadline : ?Nat;
  };

  public type EdgeJobComponent = {
    edgeDeviceId : Text;
    componentId : Nat;
    task : Text;
    status : ComponentStatus;
    result : ?JobResult;
  };

  public type HubJobComponent = {
    componentId : Nat;
    task : Text;
    status : ComponentStatus;
    result : ?JobResult;
  };

  public type ComponentStatus = {
    #Pending;
    #Running;
    #Completed;
    #Failed;
    #Cancelled;
  };

  public type JobStatus = {
    #Created;
    #Queued;
    #Running;
    #Aggregating;
    #Completed;
    #Failed;
    #Cancelled;
  };

  public type JobResult = {
    resultId : Nat;
    dataHash : Nat32;
    success : Bool;
    errorMessage : ?Text;
    processingTime : Nat;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                    HUB STATE                                           ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  /// Main state for Hybrid Mode Hub
  public type HybridHubState = {
    // Hub identity
    hubId : Text;
    hubName : Text;
    createdBeat : Nat;
    
    // Operating mode
    currentMode : HubMode;
    edgeModeEnabled : Bool;
    hybridModeEnabled : Bool;
    
    // Edge connections
    edgeConnections : [EdgeConnection];
    activeConnections : Nat;
    totalBytesReceived : Nat;
    totalBytesSent : Nat;
    
    // Mobile devices
    mobileDevices : [MobileDevice];
    onlineMobiles : Nat;
    
    // Data channels
    dataChannels : [DataChannel];
    activeChannels : Nat;
    
    // Internet grid
    gridSectors : [GridSector];
    gridCoverage : Float;        // [0, 1]
    lastGridScan : Nat;
    
    // Echolocation
    echoProbes : [EchoProbeResult];
    probesSent : Nat;
    avgGridLatency : Float;
    
    // Hybrid jobs
    jobs : [HybridJob];
    activeJobs : Nat;
    completedJobs : Nat;
    
    // Data sovereignty
    sovereigntyConfigs : [DataSovereignty];
    
    // Security
    authTokens : [Nat32];        // Valid token hashes
    bannedDevices : [Text];
    securityAlerts : Nat;
    
    // Health
    hubHealth : Float;           // [0, 1]
    uptime : Nat;                // Beats
    lastError : ?{ beat : Nat; message : Text };
    
    // Indices
    nextConnectionId : Nat;
    nextChannelId : Nat;
    nextJobId : Nat;
    nextProbeId : Nat;
    nextMobileId : Nat;
    
    currentBeat : Nat;
  };

  public type HubMode = {
    #Standalone;                 // Operating independently
    #EdgePrimary;                // Edge devices are primary
    #HubPrimary;                 // Hub is primary
    #FullHybrid;                 // Both equal
    #Emergency;                  // Degraded mode
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                    INITIALIZATION                                      ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  /// Initialize Hybrid Hub
  public func initHybridHub(hubId : Text, hubName : Text, currentBeat : Nat) : HybridHubState {
    {
      hubId = hubId;
      hubName = hubName;
      createdBeat = currentBeat;
      
      currentMode = #Standalone;
      edgeModeEnabled = true;
      hybridModeEnabled = true;
      
      edgeConnections = [];
      activeConnections = 0;
      totalBytesReceived = 0;
      totalBytesSent = 0;
      
      mobileDevices = [];
      onlineMobiles = 0;
      
      dataChannels = [];
      activeChannels = 0;
      
      gridSectors = [];
      gridCoverage = 0.0;
      lastGridScan = 0;
      
      echoProbes = [];
      probesSent = 0;
      avgGridLatency = 0.0;
      
      jobs = [];
      activeJobs = 0;
      completedJobs = 0;
      
      sovereigntyConfigs = [];
      
      authTokens = [];
      bannedDevices = [];
      securityAlerts = 0;
      
      hubHealth = 1.0;
      uptime = 0;
      lastError = null;
      
      nextConnectionId = 0;
      nextChannelId = 0;
      nextJobId = 0;
      nextProbeId = 0;
      nextMobileId = 0;
      
      currentBeat = currentBeat;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                    EDGE CONNECTION MANAGEMENT                          ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  /// Accept edge device connection
  public func acceptConnection(
    state : HybridHubState,
    deviceId : Text,
    deviceType : EdgeDeviceType,
    protocol : EdgeProtocol,
    currentBeat : Nat
  ) : (HybridHubState, EdgeConnection) {
    let connection : EdgeConnection = {
      connectionId = state.nextConnectionId;
      deviceId = deviceId;
      deviceType = deviceType;
      status = #Connecting;
      lastHeartbeat = currentBeat;
      latencyMs = 0.0;
      signalStrength = 1.0;
      protocol = protocol;
      encryptionEnabled = true;
      compressionEnabled = false;
      dataChannels = [];
      bytesReceived = 0;
      bytesSent = 0;
      messagesReceived = 0;
      messagesSent = 0;
      authenticated = false;
      authToken = null;
      permissions = [];
      connectedBeat = currentBeat;
      lastActivityBeat = currentBeat;
    };
    
    let newConnections = Array.append(state.edgeConnections, [connection]);
    
    let newState = {
      state with
      edgeConnections = newConnections;
      activeConnections = state.activeConnections + 1;
      nextConnectionId = state.nextConnectionId + 1;
    };
    
    (newState, connection)
  };

  /// Authenticate connection
  public func authenticateConnection(
    state : HybridHubState,
    connectionId : Nat,
    token : Nat32,
    permissions : [Permission]
  ) : HybridHubState {
    let updatedConnections = Array.map<EdgeConnection, EdgeConnection>(state.edgeConnections, func (conn) {
      if (conn.connectionId == connectionId) {
        {
          conn with
          status = #Authenticated;
          authenticated = true;
          authToken = ?token;
          permissions = permissions;
        }
      } else {
        conn
      }
    });
    
    { state with edgeConnections = updatedConnections }
  };

  /// Process heartbeat from edge device
  public func processHeartbeat(
    state : HybridHubState,
    connectionId : Nat,
    latencyMs : Float,
    signalStrength : Float,
    currentBeat : Nat
  ) : HybridHubState {
    let updatedConnections = Array.map<EdgeConnection, EdgeConnection>(state.edgeConnections, func (conn) {
      if (conn.connectionId == connectionId) {
        {
          conn with
          lastHeartbeat = currentBeat;
          latencyMs = latencyMs;
          signalStrength = signalStrength;
          status = if (conn.authenticated) { #Active } else { #Connected };
          lastActivityBeat = currentBeat;
        }
      } else {
        conn
      }
    });
    
    { state with edgeConnections = updatedConnections }
  };

  /// Disconnect edge device
  public func disconnectDevice(
    state : HybridHubState,
    connectionId : Nat
  ) : HybridHubState {
    let updatedConnections = Array.map<EdgeConnection, EdgeConnection>(state.edgeConnections, func (conn) {
      if (conn.connectionId == connectionId) {
        { conn with status = #Disconnected }
      } else {
        conn
      }
    });
    
    let activeCount = Array.foldLeft<EdgeConnection, Nat>(updatedConnections, 0, func (acc, conn) {
      switch (conn.status) {
        case (#Connected or #Authenticated or #Active) { acc + 1 };
        case _ { acc };
      }
    });
    
    {
      state with
      edgeConnections = updatedConnections;
      activeConnections = activeCount;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                    MOBILE DEVICE MANAGEMENT                            ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  /// Register mobile device
  public func registerMobileDevice(
    state : HybridHubState,
    deviceName : Text,
    platform : MobilePlatform,
    capabilities : [MobileSensor],
    currentBeat : Nat
  ) : (HybridHubState, MobileDevice) {
    let device : MobileDevice = {
      deviceId = state.nextMobileId;
      deviceName = deviceName;
      platform = platform;
      connectionId = null;
      lastKnownIP = null;
      pushToken = null;
      status = #Offline;
      lastSeen = currentBeat;
      locationEnabled = false;
      lastLocation = null;
      sensorCapabilities = capabilities;
      processingPower = 0.5;
      batteryLevel = 1.0;
      trustedDevice = false;
      pinCode = null;
      biometricEnabled = false;
      lastSyncBeat = currentBeat;
      pendingMessages = 0;
      registeredBeat = currentBeat;
      ownerPrincipal = null;
    };
    
    let newDevices = Array.append(state.mobileDevices, [device]);
    
    let newState = {
      state with
      mobileDevices = newDevices;
      nextMobileId = state.nextMobileId + 1;
    };
    
    (newState, device)
  };

  /// Connect mobile device to hub
  public func connectMobileDevice(
    state : HybridHubState,
    mobileId : Nat,
    connectionId : Nat,
    currentBeat : Nat
  ) : HybridHubState {
    let updatedDevices = Array.map<MobileDevice, MobileDevice>(state.mobileDevices, func (dev) {
      if (dev.deviceId == mobileId) {
        {
          dev with
          connectionId = ?connectionId;
          status = #Online;
          lastSeen = currentBeat;
        }
      } else {
        dev
      }
    });
    
    let onlineCount = Array.foldLeft<MobileDevice, Nat>(updatedDevices, 0, func (acc, dev) {
      if (dev.status == #Online) { acc + 1 } else { acc }
    });
    
    {
      state with
      mobileDevices = updatedDevices;
      onlineMobiles = onlineCount;
    }
  };

  /// Update mobile device location
  public func updateMobileLocation(
    state : HybridHubState,
    mobileId : Nat,
    lat : Float,
    lon : Float,
    accuracy : Float,
    currentBeat : Nat
  ) : HybridHubState {
    let updatedDevices = Array.map<MobileDevice, MobileDevice>(state.mobileDevices, func (dev) {
      if (dev.deviceId == mobileId) {
        {
          dev with
          locationEnabled = true;
          lastLocation = ?{ lat = lat; lon = lon; accuracy = accuracy };
          lastSeen = currentBeat;
        }
      } else {
        dev
      }
    });
    
    { state with mobileDevices = updatedDevices }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                    DATA CHANNEL MANAGEMENT                             ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  /// Create data channel
  public func createDataChannel(
    state : HybridHubState,
    name : Text,
    direction : ChannelDirection,
    dataType : DataType,
    encoding : DataEncoding,
    reliability : Reliability,
    maxRate : Float
  ) : (HybridHubState, DataChannel) {
    let channel : DataChannel = {
      channelId = state.nextChannelId;
      name = name;
      direction = direction;
      dataType = dataType;
      encoding = encoding;
      maxRate = maxRate;
      currentRate = 0.0;
      bufferSize = 1000;
      bufferUsed = 0;
      reliability = reliability;
      ordering = #Ordered;
      active = true;
      lastMessage = 0;
      messageCount = 0;
      errorCount = 0;
    };
    
    let newChannels = Array.append(state.dataChannels, [channel]);
    
    let newState = {
      state with
      dataChannels = newChannels;
      activeChannels = state.activeChannels + 1;
      nextChannelId = state.nextChannelId + 1;
    };
    
    (newState, channel)
  };

  /// Process message on channel
  public func processChannelMessage(
    state : HybridHubState,
    channelId : Nat,
    messageSize : Nat,
    currentBeat : Nat
  ) : HybridHubState {
    let updatedChannels = Array.map<DataChannel, DataChannel>(state.dataChannels, func (ch) {
      if (ch.channelId == channelId) {
        {
          ch with
          lastMessage = currentBeat;
          messageCount = ch.messageCount + 1;
          currentRate = Float.fromInt(ch.messageCount + 1) / Float.max(1.0, Float.fromInt(currentBeat - 1));
        }
      } else {
        ch
      }
    });
    
    {
      state with
      dataChannels = updatedChannels;
      totalBytesReceived = state.totalBytesReceived + messageSize;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                    INTERNET GRID / ECHOLOCATION                        ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  /// Initialize grid sector
  public func initGridSector(
    state : HybridHubState,
    sectorId : Nat,
    minLat : Float,
    maxLat : Float,
    minLon : Float,
    maxLon : Float
  ) : HybridHubState {
    let sector : GridSector = {
      sectorId = sectorId;
      bounds = { minLat = minLat; maxLat = maxLat; minLon = minLon; maxLon = maxLon };
      knownNodes = [];
      edgeCount = 0;
      avgLatency = 0.0;
      coverageLevel = 0.0;
      lastProbe = 0;
      probeCount = 0;
      healthScore = 1.0;
      anomalyCount = 0;
      lastAnomaly = 0;
      allocatedCrusaders = [];
      activeDecoys = 0;
      activeTraps = 0;
    };
    
    let newSectors = Array.append(state.gridSectors, [sector]);
    
    { state with gridSectors = newSectors }
  };

  /// Execute echolocation probe
  public func executeEchoProbe(
    state : HybridHubState,
    sourceSector : Nat,
    targetSector : Nat,
    currentBeat : Nat
  ) : (HybridHubState, EchoProbeResult) {
    // Simulate probe (in reality this would be actual network probing)
    let result : EchoProbeResult = {
      probeId = state.nextProbeId;
      sourceSector = sourceSector;
      targetSector = targetSector;
      sentBeat = currentBeat;
      receivedBeat = currentBeat + 1;
      rtt = 50.0 + Float.fromInt(targetSector % 100);  // Simulated RTT
      hopCount = 3 + targetSector % 5;
      pathNodes = [];
      signalStrength = 0.9 - Float.fromInt(targetSector % 10) * 0.05;
      packetLoss = 0.01;
      jitter = 5.0;
      newNodesFound = 0;
      anomaliesDetected = 0;
    };
    
    let newProbes = Array.append(state.echoProbes, [result]);
    
    // Update target sector
    let updatedSectors = Array.map<GridSector, GridSector>(state.gridSectors, func (sec) {
      if (sec.sectorId == targetSector) {
        {
          sec with
          lastProbe = currentBeat;
          probeCount = sec.probeCount + 1;
          avgLatency = (sec.avgLatency * Float.fromInt(sec.probeCount) + result.rtt) / Float.fromInt(sec.probeCount + 1);
          coverageLevel = Float.min(1.0, sec.coverageLevel + 0.1);
        }
      } else {
        sec
      }
    });
    
    // Calculate new grid coverage
    var totalCoverage = 0.0;
    for (sec in updatedSectors.vals()) {
      totalCoverage := totalCoverage + sec.coverageLevel;
    };
    let avgCoverage = if (updatedSectors.size() > 0) {
      totalCoverage / Float.fromInt(updatedSectors.size())
    } else {
      0.0
    };
    
    let newState = {
      state with
      echoProbes = newProbes;
      gridSectors = updatedSectors;
      probesSent = state.probesSent + 1;
      gridCoverage = avgCoverage;
      lastGridScan = currentBeat;
      nextProbeId = state.nextProbeId + 1;
    };
    
    (newState, result)
  };

  /// Update grid sector with Crusader assignment
  public func assignCrusaderToSector(
    state : HybridHubState,
    sectorId : Nat,
    crusaderId : Nat
  ) : HybridHubState {
    let updatedSectors = Array.map<GridSector, GridSector>(state.gridSectors, func (sec) {
      if (sec.sectorId == sectorId) {
        {
          sec with
          allocatedCrusaders = Array.append(sec.allocatedCrusaders, [crusaderId])
        }
      } else {
        sec
      }
    });
    
    { state with gridSectors = updatedSectors }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                    HYBRID JOB MANAGEMENT                               ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  /// Create hybrid processing job
  public func createHybridJob(
    state : HybridHubState,
    jobType : HybridOperation,
    taskDescription : Text,
    inputDataHash : Nat32,
    currentBeat : Nat
  ) : (HybridHubState, HybridJob) {
    let job : HybridJob = {
      jobId = state.nextJobId;
      jobType = jobType;
      taskDescription = taskDescription;
      inputData = inputDataHash;
      edgeComponents = [];
      hubComponents = [];
      status = #Created;
      progress = 0.0;
      partialResults = [];
      finalResult = null;
      createdBeat = currentBeat;
      startedBeat = null;
      completedBeat = null;
      deadline = null;
    };
    
    let newJobs = Array.append(state.jobs, [job]);
    
    let newState = {
      state with
      jobs = newJobs;
      activeJobs = state.activeJobs + 1;
      nextJobId = state.nextJobId + 1;
    };
    
    (newState, job)
  };

  /// Update job status
  public func updateJobStatus(
    state : HybridHubState,
    jobId : Nat,
    newStatus : JobStatus,
    progress : Float,
    currentBeat : Nat
  ) : HybridHubState {
    let updatedJobs = Array.map<HybridJob, HybridJob>(state.jobs, func (job) {
      if (job.jobId == jobId) {
        {
          job with
          status = newStatus;
          progress = progress;
          startedBeat = switch (newStatus) {
            case (#Running) { ?currentBeat };
            case _ { job.startedBeat };
          };
          completedBeat = switch (newStatus) {
            case (#Completed or #Failed or #Cancelled) { ?currentBeat };
            case _ { job.completedBeat };
          };
        }
      } else {
        job
      }
    });
    
    // Update active job count
    var activeCount = 0;
    var completedCount = 0;
    for (job in updatedJobs.vals()) {
      switch (job.status) {
        case (#Created or #Queued or #Running or #Aggregating) { activeCount += 1 };
        case (#Completed) { completedCount += 1 };
        case _ { };
      };
    };
    
    {
      state with
      jobs = updatedJobs;
      activeJobs = activeCount;
      completedJobs = completedCount;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                    MAIN TICK FUNCTION                                  ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  /// Main tick for Hybrid Hub
  public func tickHybridHub(
    state : HybridHubState,
    currentBeat : Nat
  ) : HybridHubState {
    var newState = { state with currentBeat = currentBeat; uptime = state.uptime + 1 };
    
    // 1. Check connection timeouts
    let updatedConnections = Array.map<EdgeConnection, EdgeConnection>(newState.edgeConnections, func (conn) {
      if (conn.status != #Disconnected and conn.status != #Banned) {
        if (currentBeat > conn.lastHeartbeat + HEARTBEAT_TIMEOUT) {
          { conn with status = #Idle }
        } else if (currentBeat > conn.lastHeartbeat + CONNECTION_TIMEOUT) {
          { conn with status = #Disconnected }
        } else {
          conn
        }
      } else {
        conn
      }
    });
    
    let activeConnCount = Array.foldLeft<EdgeConnection, Nat>(updatedConnections, 0, func (acc, conn) {
      switch (conn.status) {
        case (#Connected or #Authenticated or #Active) { acc + 1 };
        case _ { acc };
      }
    });
    
    newState := { newState with edgeConnections = updatedConnections; activeConnections = activeConnCount };
    
    // 2. Update mobile device status
    let updatedMobiles = Array.map<MobileDevice, MobileDevice>(newState.mobileDevices, func (dev) {
      if (currentBeat > dev.lastSeen + HEARTBEAT_TIMEOUT * 2) {
        { dev with status = #Offline }
      } else if (currentBeat > dev.lastSeen + HEARTBEAT_TIMEOUT) {
        { dev with status = #Away }
      } else {
        dev
      }
    });
    
    let onlineMobileCount = Array.foldLeft<MobileDevice, Nat>(updatedMobiles, 0, func (acc, dev) {
      if (dev.status == #Online) { acc + 1 } else { acc }
    });
    
    newState := { newState with mobileDevices = updatedMobiles; onlineMobiles = onlineMobileCount };
    
    // 3. Determine operating mode
    let mode : HubMode = if (activeConnCount == 0 and onlineMobileCount == 0) {
      #Standalone
    } else if (activeConnCount > onlineMobileCount * 2) {
      #EdgePrimary
    } else if (onlineMobileCount > activeConnCount * 2) {
      #HubPrimary
    } else {
      #FullHybrid
    };
    
    newState := { newState with currentMode = mode };
    
    // 4. Calculate hub health
    let connectionHealth = if (MAX_EDGE_CONNECTIONS > 0) {
      Float.fromInt(activeConnCount) / Float.fromInt(MAX_EDGE_CONNECTIONS)
    } else { 1.0 };
    let gridHealth = newState.gridCoverage;
    let errorPenalty = if (newState.lastError != null) { 0.1 } else { 0.0 };
    
    let hubHealth = (connectionHealth * 0.3 + gridHealth * 0.3 + 0.4) - errorPenalty;
    
    { newState with hubHealth = Float.max(0.0, Float.min(1.0, hubHealth)) }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                    QUERY FUNCTIONS                                     ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  /// Get Hybrid Hub summary
  public func getHubSummary(state : HybridHubState) : {
    hubId : Text;
    hubName : Text;
    currentMode : HubMode;
    edgeModeEnabled : Bool;
    hybridModeEnabled : Bool;
    activeConnections : Nat;
    onlineMobiles : Nat;
    activeChannels : Nat;
    gridCoverage : Float;
    activeJobs : Nat;
    hubHealth : Float;
    uptime : Nat;
  } {
    {
      hubId = state.hubId;
      hubName = state.hubName;
      currentMode = state.currentMode;
      edgeModeEnabled = state.edgeModeEnabled;
      hybridModeEnabled = state.hybridModeEnabled;
      activeConnections = state.activeConnections;
      onlineMobiles = state.onlineMobiles;
      activeChannels = state.activeChannels;
      gridCoverage = state.gridCoverage;
      activeJobs = state.activeJobs;
      hubHealth = state.hubHealth;
      uptime = state.uptime;
    }
  };

}
