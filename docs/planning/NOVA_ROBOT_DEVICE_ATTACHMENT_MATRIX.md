# NOVA Robot and Device Attachment Matrix

Status: planning baseline

This document defines which robots and devices NOVA should attach to first, how they should connect, and what evidence is required before any physical execution claim is made.

## Core attachment rule

Every physical device is represented through a signed device identity, a capability manifest, an adapter boundary, an execution policy, and durable receipts. No vendor SDK is allowed to bypass the canonical MCP tool surface or the execution trust substrate.

## Priority tiers

### Tier 1 — Build first

| Device class | Initial targets | Primary transport | Why first | Initial NOVA capabilities |
|---|---|---|---|---|
| ROS 2 mobile robots | TurtleBot 4, Create 3-class bases, custom ROS 2 differential-drive robots | ROS 2 DDS over LAN | Accessible, simulation-friendly, broad robotics ecosystem | discover, telemetry, pose, map, navigate, stop, dock |
| MQTT robots and IoT devices | ESP32 robots, Raspberry Pi robots, custom lab devices, relays, sensors | MQTT over TLS | Fastest path to real hardware with explicit topic controls | read telemetry, publish command, wait for acknowledgement |
| Local computer | Windows/Linux workstation, Raspberry Pi gateway | authenticated local agent over LAN | Immediately useful from PhoneAI and already central to the ecosystem | status, services, approved commands, files, screenshots |
| Cameras | RTSP/ONVIF cameras, USB cameras through gateway | RTSP/ONVIF or local gateway | Adds perception without immediate actuation risk | snapshot, stream metadata, object-event handoff |
| Smart-home devices | Matter bridges, Home Assistant exposed devices | Matter or authenticated Home Assistant API | Large device coverage through one governed adapter | read state, switch, scene, climate setpoint |

### Tier 2 — Strategic robotics adapters

| Robot/device | Adapter path | Initial authority | Notes |
|---|---|---|---|
| Unitree Go2/B2/G1/H1 class | Vendor SDK gateway plus ROS 2 normalization | telemetry, posture state, safe stop; motion only after certification | Strong showcase value; vendor-specific safety envelope required |
| Boston Dynamics Spot | Spot SDK gateway | telemetry, image capture, lease state, estop state; navigation after supervised testing | Lease and estop semantics must remain vendor authoritative |
| Universal Robots cobots | RTDE and Dashboard Server gateway, optionally ROS 2 driver | state and program inspection first; controlled program execution later | Industrial safety system remains independent of NOVA |
| Franka research arms | ROS 2 / libfranka gateway | joint state and simulation first | Good research manipulator target |
| NVIDIA Jetson edge robots | NOVA gateway runtime on Jetson | perception, model execution, ROS/MQTT bridging | Natural AURO edge-compute target |
| Drones using MAVLink | PX4 or ArduPilot through MAVSDK/MAVLink gateway | telemetry and mission validation first; launch disabled by default | Requires geofence, arming, operator and regulatory gates |

### Tier 3 — Industrial and building systems

| System | Protocol | Initial capability |
|---|---|---|
| PLCs and industrial controllers | OPC UA | browse nodes, read values, subscriptions; writes gated |
| Legacy PLCs, meters and drives | Modbus TCP/RTU through isolated gateway | read registers first; write registers separately certified |
| Building automation | BACnet/IP through gateway | occupancy, temperature, alarms, approved setpoints |
| CNC and fabrication equipment | vendor API, MTConnect, OPC UA | machine state and job evidence first |
| Lab instruments | SCPI over TCP/serial, vendor APIs | identify, read measurement, configure bounded experiments |
| Networked power systems | SNMP, Redfish, vendor APIs | health, power telemetry, controlled restart |

## Canonical adapter architecture

```text
PhoneAI / Claude / Codex / NOVA agents
                 |
          canonical MCP
                 |
       capability and policy gate
                 |
 identity -> approval -> nonce -> receipt
                 |
       protocol adapter gateway
                 |
 ROS 2 | MQTT | Matter | OPC UA | Modbus | vendor SDK
                 |
              device
```

## Canonical MCP tool families

- `devices.discover`
- `devices.describe`
- `devices.telemetry.read`
- `devices.telemetry.subscribe`
- `robot.state.read`
- `robot.navigate.plan`
- `robot.navigate.execute`
- `robot.motion.stop`
- `robot.dock`
- `camera.snapshot`
- `camera.stream.describe`
- `actuator.proposal.create`
- `actuator.execute`
- `execution.receipt.read`
- `execution.receipt.verify`

Device-specific tools should map into these families instead of creating unrelated vendor-shaped interfaces.

## Required device manifest

Each attached device must declare:

- device ID and identity fingerprint
- vendor, model and firmware
- transport and endpoint
- supported capabilities
- read-only versus physical-execution capabilities
- input and output schema hashes
- unit conventions and coordinate frames
- required approval class
- timeout and retry policy
- value, speed, force, area, geofence or workspace limits
- emergency-stop mechanism
- health and heartbeat policy
- adapter version
- simulator availability

## Promotion stages

1. `DISCOVERED` — detected but no authority.
2. `OBSERVE` — authenticated telemetry only.
3. `SIMULATE` — commands execute against simulator or digital twin.
4. `SUPERVISED` — bounded physical execution with operator present.
5. `CERTIFIED` — repeatable tests, durable receipts and explicit device profile.

No device begins above `OBSERVE`.

## First three concrete builds

### Build A — ROS 2 gateway

Deliver a gateway that discovers topics, services and actions but exposes only an allowlisted normalized surface. First target is TurtleBot-class navigation in simulation, then a physical differential-drive base.

### Build B — MQTT device gateway

Deliver mutual-TLS broker support, topic allowlists, retained-state handling, command acknowledgement, idempotency keys and receipt linkage. First physical target should be an ESP32 or Raspberry Pi sensor/relay/robot kit.

### Build C — local computer and Jetson gateway

Turn the laptop or Jetson into a signed NOVA device. This becomes the bridge for cameras, USB, serial, BLE presence, ROS 2 and vendor SDKs. Arbitrary shell access remains prohibited; only registered capabilities are exposed.

## Testing invariant

Every adapter must pass:

- identity rejection tests
- replay and concurrent nonce tests
- schema validation
- timeout and cancellation
- disconnect and reconnect behavior
- emergency-stop behavior where applicable
- simulator parity tests
- approval binding tests
- durable receipt verification
- restart persistence

## Initial recommendation

Start with ROS 2, MQTT and the local computer/Jetson gateway in parallel. They provide the widest coverage while preserving a single canonical MCP and trust boundary. Unitree and Spot should be showcase targets after the generic gateways are stable; Matter, OPC UA and Modbus follow as device-fleet expansion lanes.
