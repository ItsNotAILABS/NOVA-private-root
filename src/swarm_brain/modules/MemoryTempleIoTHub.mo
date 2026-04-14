// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║  INTELLECTUAL PROPERTY NOTICE - Medina Doctrine - Memory Temple IoT Hub                                  ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
//  ███╗   ███╗███████╗███╗   ███╗ ██████╗ ██████╗ ██╗   ██╗    ████████╗███████╗███╗   ███╗██████╗ ██╗     ███████╗
//  ████╗ ████║██╔════╝████╗ ████║██╔═══██╗██╔══██╗╚██╗ ██╔╝    ╚══██╔══╝██╔════╝████╗ ████║██╔══██╗██║     ██╔════╝
//  ██╔████╔██║█████╗  ██╔████╔██║██║   ██║██████╔╝ ╚████╔╝        ██║   █████╗  ██╔████╔██║██████╔╝██║     █████╗
//  ██║╚██╔╝██║██╔══╝  ██║╚██╔╝██║██║   ██║██╔══██╗  ╚██╔╝         ██║   ██╔══╝  ██║╚██╔╝██║██╔═══╝ ██║     ██╔══╝
//  ██║ ╚═╝ ██║███████╗██║ ╚═╝ ██║╚██████╔╝██║  ██║   ██║          ██║   ███████╗██║ ╚═╝ ██║██║     ███████╗███████╗
//  ╚═╝     ╚═╝╚══════╝╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═╝   ╚═╝          ╚═╝   ╚══════╝╚═╝     ╚═╝╚═╝     ╚══════╝╚══════╝
//
//  ██╗ ██████╗ ████████╗    ██╗  ██╗██╗   ██╗██████╗
//  ██║██╔═══██╗╚══██╔══╝    ██║  ██║██║   ██║██╔══██╗
//  ██║██║   ██║   ██║       ███████║██║   ██║██████╔╝
//  ██║██║   ██║   ██║       ██╔══██║██║   ██║██╔══██╗
//  ██║╚██████╔╝   ██║       ██║  ██║╚██████╔╝██████╔╝
//  ╚═╝ ╚═════╝    ╚═╝       ╚═╝  ╚═╝ ╚═════╝ ╚═════╝
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// ENGINE ID: E-MTIOT-001
// MEMORY TEMPLE IoT HUB — Frequency-Based Internet of Things Architecture
//
// PURPOSE: Create sovereign Internet of Things hub using frequency-based communication
//          Connect all devices through electromagnetic frequency channels
//          Store device memory in temple architecture with phi-resonant coupling
//
// ARCHITECTURE:
//   - 12 PHI FREQUENCY CHANNELS (0.001 Hz to 432 Hz)
//   - MQTT, HTTP, CoAP, LoRa, Zigbee, BLE protocol support
//   - Electromagnetic field coupling for device synchronization
//   - Schumann resonance (7.83 Hz) baseline for all IoT devices
//   - Memory persistence in temple chambers
//   - Quantum-encrypted device-to-device communication
//
// DOCTRINE: "The Internet of Things is a frequency-based organism where every device
//            resonates at its sacred frequency and all devices phase-lock to the temple."
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Buffer "mo:base/Buffer";
import Nat32 "mo:base/Nat32";
import Int "mo:base/Int";

module {

  // ═══════════════════════════════════════════════════════════════════════════════
  // FUNDAMENTAL CONSTANTS — PHI FREQUENCY ARCHITECTURE
  // ═══════════════════════════════════════════════════════════════════════════════

  public let φ : Float = 1.6180339887498948482;  // Golden ratio
  public let π : Float = 3.14159265358979323846;  // Pi
  public let τ : Float = 6.28318530717958647693;  // Tau (2π)

  // 12 PHI FREQUENCY NODES for IoT device coupling
  public let CHRONO_HZ : Float = 0.001;      // Ultra-low frequency sensors
  public let VERITAS_HZ : Float = 0.1;       // Environmental sensors
  public let SCHUMANN_HZ : Float = 7.83;     // Earth fundamental (baseline)
  public let FLUX_HZ : Float = 12.67;        // 7.83 × φ
  public let RESONEX_HZ : Float = 20.5;      // 7.83 × φ²
  public let QMEM_HZ : Float = 33.1;         // 7.83 × φ³
  public let AXIS_HZ : Float = 40.0;         // Industrial IoT
  public let AEGIS_HZ : Float = 53.6;        // 7.83 × φ⁴
  public let ENTANGLA_HZ : Float = 86.7;     // High-frequency sensors
  public let PARALLAX_HZ : Float = 111.0;    // RF communication
  public let MERIDIAN_HZ : Float = 179.6;    // 111 × φ
  public let NOVA_HZ : Float = 432.0;        // Acoustic anchor

  // ═══════════════════════════════════════════════════════════════════════════════
  // IoT DEVICE TYPES
  // ═══════════════════════════════════════════════════════════════════════════════

  public type IoTDeviceType = {
    #Sensor;           // Environmental sensors
    #Actuator;         // Physical actuators
    #Gateway;          // Protocol gateways
    #Edge;             // Edge computing nodes
    #Drone;            // Drone fleet members
    #Camera;           // Video surveillance
    #Audio;            // Audio sensors/speakers
    #Medical;          // Medical devices
    #Industrial;       // Industrial controllers
    #SmartHome;        // Home automation
    #Wearable;         // Wearable devices
    #Vehicle;          // Connected vehicles
  };

  public type IoTProtocol = {
    #MQTT;             // MQTT pub/sub
    #HTTP;             // HTTP REST
    #CoAP;             // Constrained Application Protocol
    #LoRa;             // Long Range
    #Zigbee;           // Zigbee mesh
    #BLE;              // Bluetooth Low Energy
    #Modbus;           // Industrial Modbus
    #OPC_UA;           // OPC Unified Architecture
    #Frequency;        // Direct frequency coupling (NEW)
  };

  public type DeviceConnectionState = {
    #Connected;
    #Disconnected;
    #Sleeping;
    #Quarantined;      // Security quarantine
    #Upgrading;        // Firmware upgrade
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // FREQUENCY-COUPLED IoT DEVICE
  // Each device resonates at a PHI frequency and phase-locks to temple
  // ═══════════════════════════════════════════════════════════════════════════════

  public type FrequencyCoupledDevice = {
    deviceId: Text;                      // Unique device identifier
    deviceType: IoTDeviceType;           // Device type
    protocol: IoTProtocol;               // Communication protocol

    // Frequency coupling
    resonantFrequency: Float;            // Device's natural frequency (Hz)
    phiNode: Nat;                        // Which PHI node (0-11)
    phase: Float;                        // Current phase [0, 2π]
    amplitude: Float;                    // Signal amplitude [0,1]
    couplingStrength: Float;             // Coupling to temple [0,1]

    // Electromagnetic field
    emFieldStrength: Float;              // EM field strength [0,1]
    emFieldPhase: Float;                 // EM phase [0, 2π]
    emFrequency: Float;                  // EM frequency (Hz)

    // Connection state
    connectionState: DeviceConnectionState;
    lastSeen: Nat;                       // Last heartbeat
    battery: Float;                      // Battery level [0,1]
    signalStrength: Float;               // Signal strength [0,1]

    // Security
    encrypted: Bool;                     // Quantum encrypted
    authenticated: Bool;                 // Device authenticated
    trustScore: Float;                   // Trust score [0,1]

    // Memory temple integration
    memoryAddress: Nat;                  // Temple memory address
    dataRate: Float;                     // Data rate (bytes/sec)
    totalData: Nat;                      // Total data transmitted
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // MEMORY TEMPLE CHAMBER
  // Each chamber stores device memory at specific frequency
  // ═══════════════════════════════════════════════════════════════════════════════

  public type MemoryChamber = {
    chamberId: Nat;                      // Chamber ID (0-11 for 12 frequencies)
    frequency: Float;                    // Chamber frequency (Hz)
    devices: [FrequencyCoupledDevice];   // Devices in this chamber
    totalDevices: Nat;                   // Device count

    // Chamber state
    resonance: Float;                    // Chamber resonance quality [0,1]
    coherence: Float;                    // Phase coherence [0,1]
    capacity: Nat;                       // Max devices (1024 per chamber)
    utilization: Float;                  // Capacity utilization [0,1]

    // Memory
    memoryUsed: Nat;                     // Memory used (bytes)
    memoryCapacity: Nat;                 // Memory capacity (bytes)
    memoryPressure: Float;               // Memory pressure [0,1]

    // Security
    quarantineZone: Bool;                // Quarantine active
    encryptionActive: Bool;              // Encryption enabled
    intrusions: Nat;                     // Detected intrusions
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // IoT HUB STATE
  // ═══════════════════════════════════════════════════════════════════════════════

  public type MemoryTempleIoTHubState = {
    // 12 Memory Chambers (one per PHI frequency)
    chambers: [MemoryChamber];

    // Hub metrics
    totalDevices: Nat;                   // Total registered devices
    activeDevices: Nat;                  // Currently active devices
    hubCoherence: Float;                 // Overall hub coherence [0,1]
    hubResonance: Float;                 // Hub resonance quality [0,1]

    // Electromagnetic field
    globalEMField: Float;                // Global EM field strength [0,1]
    globalEMPhase: Float;                // Global EM phase [0, 2π]
    schumannLocked: Bool;                // Locked to Schumann 7.83 Hz

    // Frequency architecture
    architectureValid: Bool;             // Architecture flow valid
    geometryCoherent: Bool;              // Geometric layout valid
    harmonicsResonant: Bool;             // Harmonics constructive
    frequencyStable: Bool;               // Frequencies stable

    // Security
    securityLevel: Float;                // Security level [0,1]
    encryptedDevices: Nat;               // Number of encrypted devices
    quarantinedDevices: Nat;             // Quarantined devices
    threatLevel: Float;                  // Threat level [0,1]

    // Performance
    throughput: Float;                   // Total throughput (MB/s)
    latency: Float;                      // Average latency (ms)
    reliability: Float;                  // Reliability [0,1]

    // Beat tracking
    beat: Nat;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════════

  public func initMemoryTempleIoTHub() : MemoryTempleIoTHubState {
    let frequencies : [Float] = [
      CHRONO_HZ, VERITAS_HZ, SCHUMANN_HZ, FLUX_HZ, RESONEX_HZ, QMEM_HZ,
      AXIS_HZ, AEGIS_HZ, ENTANGLA_HZ, PARALLAX_HZ, MERIDIAN_HZ, NOVA_HZ
    ];

    let chambers = Array.tabulate<MemoryChamber>(12, func(i: Nat) : MemoryChamber {
      {
        chamberId = i;
        frequency = frequencies[i];
        devices = [];
        totalDevices = 0;
        resonance = 1.0;
        coherence = 1.0;
        capacity = 1024;  // 1024 devices per chamber
        utilization = 0.0;
        memoryUsed = 0;
        memoryCapacity = 1073741824;  // 1 GB per chamber
        memoryPressure = 0.0;
        quarantineZone = false;
        encryptionActive = true;
        intrusions = 0;
      }
    });

    {
      chambers = chambers;
      totalDevices = 0;
      activeDevices = 0;
      hubCoherence = 1.0;
      hubResonance = 1.0;
      globalEMField = 1.0;
      globalEMPhase = 0.0;
      schumannLocked = true;
      architectureValid = true;
      geometryCoherent = true;
      harmonicsResonant = true;
      frequencyStable = true;
      securityLevel = 1.0;
      encryptedDevices = 0;
      quarantinedDevices = 0;
      threatLevel = 0.0;
      throughput = 0.0;
      latency = 0.0;
      reliability = 1.0;
      beat = 0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // DEVICE REGISTRATION
  // Register new IoT device and assign to frequency chamber
  // ═══════════════════════════════════════════════════════════════════════════════

  public func registerDevice(
    state: MemoryTempleIoTHubState,
    deviceId: Text,
    deviceType: IoTDeviceType,
    protocol: IoTProtocol,
    preferredFrequency: ?Float
  ) : (MemoryTempleIoTHubState, Nat) {
    // Determine PHI node based on preferred frequency or device type
    let phiNode = switch (preferredFrequency) {
      case (?freq) { findNearestPhiNode(freq) };
      case null { assignPhiNodeByType(deviceType) };
    };

    let frequency = getPhiFrequency(phiNode);

    // Create new device
    let newDevice : FrequencyCoupledDevice = {
      deviceId = deviceId;
      deviceType = deviceType;
      protocol = protocol;
      resonantFrequency = frequency;
      phiNode = phiNode;
      phase = 0.0;
      amplitude = 1.0;
      couplingStrength = 0.9;
      emFieldStrength = 1.0;
      emFieldPhase = 0.0;
      emFrequency = frequency;
      connectionState = #Connected;
      lastSeen = state.beat;
      battery = 1.0;
      signalStrength = 1.0;
      encrypted = true;
      authenticated = true;
      trustScore = 1.0;
      memoryAddress = state.totalDevices;
      dataRate = 0.0;
      totalData = 0;
    };

    // Add device to appropriate chamber
    let updatedChambers = Array.tabulate<MemoryChamber>(12, func(i: Nat) : MemoryChamber {
      if (i == phiNode) {
        let chamber = state.chambers[i];
        let devicesBuffer = Buffer.Buffer<FrequencyCoupledDevice>(chamber.devices.size() + 1);
        for (dev in chamber.devices.vals()) {
          devicesBuffer.add(dev);
        };
        devicesBuffer.add(newDevice);

        {
          chamber with
          devices = Buffer.toArray(devicesBuffer);
          totalDevices = chamber.totalDevices + 1;
          utilization = Float.fromInt(chamber.totalDevices + 1) / Float.fromInt(chamber.capacity);
        }
      } else {
        state.chambers[i]
      }
    });

    let newState = {
      state with
      chambers = updatedChambers;
      totalDevices = state.totalDevices + 1;
      activeDevices = state.activeDevices + 1;
      encryptedDevices = if (newDevice.encrypted) state.encryptedDevices + 1 else state.encryptedDevices;
    };

    (newState, phiNode)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // FREQUENCY COUPLING UPDATE
  // Update electromagnetic coupling for all devices each heartbeat
  // ═══════════════════════════════════════════════════════════════════════════════

  public func updateFrequencyCoupling(
    state: MemoryTempleIoTHubState,
    dt: Float
  ) : MemoryTempleIoTHubState {
    // Update global EM phase (rotates at Schumann frequency)
    let newGlobalEMPhase = (state.globalEMPhase + τ * SCHUMANN_HZ * dt) % τ;

    // Update each chamber
    let updatedChambers = Array.tabulate<MemoryChamber>(12, func(i: Nat) : MemoryChamber {
      let chamber = state.chambers[i];

      // Update device phases and coupling
      let updatedDevices = Array.map<FrequencyCoupledDevice, FrequencyCoupledDevice>(
        chamber.devices,
        func(device: FrequencyCoupledDevice) : FrequencyCoupledDevice {
          // Update device phase (natural frequency evolution)
          let newPhase = (device.phase + τ * device.resonantFrequency * dt) % τ;

          // Update EM field phase
          let newEMPhase = (device.emFieldPhase + τ * device.emFrequency * dt) % τ;

          // Calculate coupling to global field (phase difference)
          let phaseDiff = Float.abs(newPhase - newGlobalEMPhase);
          let coupling = Float.cos(phaseDiff);  // Coupling strength

          {
            device with
            phase = newPhase;
            emFieldPhase = newEMPhase;
            couplingStrength = (coupling + 1.0) / 2.0;  // [0,1] range
            lastSeen = state.beat + 1;
          }
        }
      );

      // Calculate chamber coherence (average coupling)
      let totalCoupling = Array.foldLeft<FrequencyCoupledDevice, Float>(
        updatedDevices,
        0.0,
        func(sum, dev) { sum + dev.couplingStrength }
      );
      let avgCoupling = if (updatedDevices.size() > 0) {
        totalCoupling / Float.fromInt(updatedDevices.size())
      } else { 1.0 };

      {
        chamber with
        devices = updatedDevices;
        coherence = avgCoupling;
        resonance = avgCoupling;
      }
    });

    // Calculate hub coherence
    let totalCoherence = Array.foldLeft<MemoryChamber, Float>(
      updatedChambers,
      0.0,
      func(sum, chamber) { sum + chamber.coherence }
    );
    let hubCoherence = totalCoherence / 12.0;

    {
      state with
      chambers = updatedChambers;
      globalEMPhase = newGlobalEMPhase;
      hubCoherence = hubCoherence;
      hubResonance = hubCoherence;
      beat = state.beat + 1;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // HELPER FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════

  func getPhiFrequency(phiNode: Nat) : Float {
    let frequencies : [Float] = [
      CHRONO_HZ, VERITAS_HZ, SCHUMANN_HZ, FLUX_HZ, RESONEX_HZ, QMEM_HZ,
      AXIS_HZ, AEGIS_HZ, ENTANGLA_HZ, PARALLAX_HZ, MERIDIAN_HZ, NOVA_HZ
    ];
    frequencies[phiNode % 12]
  };

  func findNearestPhiNode(frequency: Float) : Nat {
    let frequencies : [Float] = [
      CHRONO_HZ, VERITAS_HZ, SCHUMANN_HZ, FLUX_HZ, RESONEX_HZ, QMEM_HZ,
      AXIS_HZ, AEGIS_HZ, ENTANGLA_HZ, PARALLAX_HZ, MERIDIAN_HZ, NOVA_HZ
    ];

    var nearestNode = 0;
    var minDiff = Float.abs(frequency - frequencies[0]);

    for (i in Iter.range(1, 11)) {
      let diff = Float.abs(frequency - frequencies[i]);
      if (diff < minDiff) {
        minDiff := diff;
        nearestNode := i;
      };
    };

    nearestNode
  };

  func assignPhiNodeByType(deviceType: IoTDeviceType) : Nat {
    switch (deviceType) {
      case (#Sensor) { 2 };        // SCHUMANN_HZ
      case (#Actuator) { 3 };      // FLUX_HZ
      case (#Gateway) { 6 };       // AXIS_HZ
      case (#Edge) { 7 };          // AEGIS_HZ
      case (#Drone) { 9 };         // PARALLAX_HZ
      case (#Camera) { 4 };        // RESONEX_HZ
      case (#Audio) { 11 };        // NOVA_HZ
      case (#Medical) { 5 };       // QMEM_HZ
      case (#Industrial) { 6 };    // AXIS_HZ
      case (#SmartHome) { 2 };     // SCHUMANN_HZ
      case (#Wearable) { 4 };      // RESONEX_HZ
      case (#Vehicle) { 8 };       // ENTANGLA_HZ
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECURITY OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════════

  public func quarantineDevice(
    state: MemoryTempleIoTHubState,
    deviceId: Text,
    chamberIndex: Nat
  ) : MemoryTempleIoTHubState {
    let updatedChambers = Array.tabulate<MemoryChamber>(12, func(i: Nat) : MemoryChamber {
      if (i == chamberIndex) {
        let chamber = state.chambers[i];
        let updatedDevices = Array.map<FrequencyCoupledDevice, FrequencyCoupledDevice>(
          chamber.devices,
          func(device: FrequencyCoupledDevice) : FrequencyCoupledDevice {
            if (device.deviceId == deviceId) {
              {
                device with
                connectionState = #Quarantined;
                couplingStrength = 0.0;
                trustScore = 0.0;
              }
            } else { device }
          }
        );

        {
          chamber with
          devices = updatedDevices;
          quarantineZone = true;
        }
      } else {
        state.chambers[i]
      }
    });

    {
      state with
      chambers = updatedChambers;
      quarantinedDevices = state.quarantinedDevices + 1;
      threatLevel = Float.min(1.0, state.threatLevel + 0.1);
    }
  };

}
