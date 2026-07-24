from __future__ import annotations

from dataclasses import asdict, dataclass, field
from hashlib import sha256
import json
import os
import time
from typing import Any, Callable
from urllib import request as urlrequest


STATUS_LEVELS = ("DISCOVERED", "OBSERVE", "SIMULATE", "SUPERVISED", "CERTIFIED")
RISK_LEVELS = ("observe", "simulate", "prepare", "execute", "critical")


def canonical_json(value: Any) -> str:
    return json.dumps(value, sort_keys=True, separators=(",", ":"), ensure_ascii=True)


def digest(value: Any) -> str:
    return "0x" + sha256(canonical_json(value).encode("utf-8")).hexdigest()


@dataclass(frozen=True)
class AccessPoint:
    access_id: str
    family: str
    protocol: str
    transport: str
    device_classes: tuple[str, ...]
    capabilities: tuple[str, ...]
    maturity: str
    execution_default: str
    requires_gateway: bool
    configuration_env: tuple[str, ...] = ()
    notes: str = ""


@dataclass(frozen=True)
class RobotCommand:
    access_id: str
    device_id: str
    capability: str
    arguments: dict[str, Any]
    risk_tier: str
    dry_run: bool = True
    approval_id: str | None = None
    deadline: int = 0
    nonce: str = ""

    def hash(self) -> str:
        return digest(asdict(self))


@dataclass(frozen=True)
class AdapterResult:
    ok: bool
    access_id: str
    device_id: str
    capability: str
    mode: str
    payload: dict[str, Any]
    command_hash: str
    completed_at: int


@dataclass
class Adapter:
    descriptor: AccessPoint
    handler: Callable[[RobotCommand], AdapterResult]


class RobotAccessRegistry:
    """Canonical protocol and vendor access-point registry.

    The registry separates protocol support from execution promotion. An access point may
    be implemented while individual devices remain OBSERVE or SIMULATE only.
    """

    def __init__(self) -> None:
        self._adapters: dict[str, Adapter] = {}
        self._device_status: dict[str, str] = {}

    def register(self, descriptor: AccessPoint, handler: Callable[[RobotCommand], AdapterResult]) -> None:
        if descriptor.access_id in self._adapters:
            raise ValueError(f"duplicate access point: {descriptor.access_id}")
        if descriptor.maturity not in STATUS_LEVELS:
            raise ValueError(f"invalid maturity: {descriptor.maturity}")
        self._adapters[descriptor.access_id] = Adapter(descriptor, handler)

    def set_device_status(self, device_id: str, status: str) -> None:
        if status not in STATUS_LEVELS:
            raise ValueError(f"invalid device status: {status}")
        self._device_status[device_id] = status

    def list_access_points(self) -> list[dict[str, Any]]:
        return [asdict(adapter.descriptor) for adapter in self._adapters.values()]

    def device_status(self, device_id: str) -> str:
        return self._device_status.get(device_id, "DISCOVERED")

    def invoke(self, command: RobotCommand) -> AdapterResult:
        adapter = self._adapters.get(command.access_id)
        if adapter is None:
            raise KeyError(f"unknown access point: {command.access_id}")
        if command.risk_tier not in RISK_LEVELS:
            raise ValueError("invalid risk tier")
        now = int(time.time())
        if command.deadline and now > command.deadline:
            raise PermissionError("command deadline expired")
        if command.capability not in adapter.descriptor.capabilities:
            raise PermissionError("capability not supported by access point")

        status = self.device_status(command.device_id)
        if status in {"DISCOVERED", "OBSERVE"} and command.risk_tier not in {"observe", "simulate"}:
            raise PermissionError(f"device status {status} does not permit execution")
        if status == "SIMULATE" and not command.dry_run:
            raise PermissionError("SIMULATE device requires dry_run")
        if command.risk_tier in {"execute", "critical"} and not command.approval_id:
            raise PermissionError("execute-tier command requires approval_id")
        return adapter.handler(command)


def _simulated_handler(command: RobotCommand) -> AdapterResult:
    return AdapterResult(
        ok=True,
        access_id=command.access_id,
        device_id=command.device_id,
        capability=command.capability,
        mode="simulated" if command.dry_run else "supervised",
        payload={
            "accepted": True,
            "arguments": command.arguments,
            "transported": False,
            "simulation": True,
        },
        command_hash=command.hash(),
        completed_at=int(time.time()),
    )


def _http_gateway_handler(env_name: str) -> Callable[[RobotCommand], AdapterResult]:
    def handler(command: RobotCommand) -> AdapterResult:
        base_url = os.getenv(env_name, "").rstrip("/")
        if command.dry_run or not base_url:
            result = _simulated_handler(command)
            return AdapterResult(
                **{**asdict(result), "payload": {**result.payload, "gateway_configured": bool(base_url)}}
            )
        token = os.getenv(f"{env_name}_TOKEN", "")
        body = canonical_json({
            "device_id": command.device_id,
            "capability": command.capability,
            "arguments": command.arguments,
            "command_hash": command.hash(),
            "approval_id": command.approval_id,
            "nonce": command.nonce,
            "deadline": command.deadline,
        }).encode("utf-8")
        req = urlrequest.Request(
            f"{base_url}/v1/commands",
            data=body,
            method="POST",
            headers={
                "Content-Type": "application/json",
                "Authorization": f"Bearer {token}" if token else "",
                "X-NOVA-Command-Hash": command.hash(),
            },
        )
        with urlrequest.urlopen(req, timeout=8) as response:
            payload = json.loads(response.read().decode("utf-8"))
        return AdapterResult(
            ok=True,
            access_id=command.access_id,
            device_id=command.device_id,
            capability=command.capability,
            mode="supervised",
            payload=payload,
            command_hash=command.hash(),
            completed_at=int(time.time()),
        )
    return handler


def build_default_registry() -> RobotAccessRegistry:
    registry = RobotAccessRegistry()

    access_points = [
        AccessPoint("ros2", "robotics", "ROS 2", "DDS via signed gateway", ("mobile-robot", "manipulator", "humanoid", "quadruped", "drone"), ("robot.state.read", "robot.nav.goal", "robot.velocity.set", "robot.arm.trajectory", "robot.stop"), "ALPHA", "simulate", True, ("NOVA_ROS2_GATEWAY_URL",), "TurtleBot, Create 3 and custom ROS 2 systems first."),
        AccessPoint("mqtt", "iot", "MQTT 5/TLS", "broker", ("esp32", "raspberry-pi", "sensor", "relay", "custom-robot"), ("iot.telemetry.read", "iot.command.publish", "robot.stop"), "ALPHA", "simulate", True, ("NOVA_MQTT_GATEWAY_URL",), "Topic allowlists and broker identity required."),
        AccessPoint("unitree", "robotics", "Unitree SDK", "Ethernet/Wi-Fi gateway", ("quadruped", "humanoid"), ("robot.state.read", "robot.motion.mode", "robot.velocity.set", "robot.pose.set", "robot.stop"), "PROTOTYPE", "simulate", True, ("NOVA_UNITREE_GATEWAY_URL",), "Targets Go2, B2, G1 and H1 through a vendor gateway."),
        AccessPoint("spot", "robotics", "Boston Dynamics SDK", "HTTPS/gRPC gateway", ("quadruped",), ("robot.state.read", "robot.lease.acquire", "robot.nav.goal", "robot.mission.run", "robot.stop"), "PLANNED", "simulate", True, ("NOVA_SPOT_GATEWAY_URL",), "Lease and estop ownership must remain vendor-native."),
        AccessPoint("universal-robots", "robotics", "RTDE/Dashboard", "TCP gateway", ("cobot", "manipulator"), ("robot.state.read", "robot.program.load", "robot.program.run", "robot.arm.trajectory", "robot.stop"), "PLANNED", "simulate", True, ("NOVA_UR_GATEWAY_URL",), "Protective-stop and safety-controller state cannot be bypassed."),
        AccessPoint("franka", "robotics", "libfranka/ROS 2", "real-time gateway", ("research-arm",), ("robot.state.read", "robot.arm.trajectory", "robot.gripper.set", "robot.stop"), "PLANNED", "simulate", True, ("NOVA_FRANKA_GATEWAY_URL",), "Research-arm lane; hard real-time remains local."),
        AccessPoint("px4", "aerial", "MAVLink/PX4", "UDP/serial gateway", ("drone", "rover"), ("vehicle.state.read", "vehicle.mission.upload", "vehicle.arm", "vehicle.takeoff", "vehicle.land", "robot.stop"), "PROTOTYPE", "simulate", True, ("NOVA_PX4_GATEWAY_URL",), "SITL before any supervised hardware promotion."),
        AccessPoint("ardupilot", "aerial", "MAVLink/ArduPilot", "UDP/serial gateway", ("drone", "rover", "boat"), ("vehicle.state.read", "vehicle.mission.upload", "vehicle.arm", "vehicle.takeoff", "vehicle.land", "robot.stop"), "PROTOTYPE", "simulate", True, ("NOVA_ARDUPILOT_GATEWAY_URL",), "SITL before any supervised hardware promotion."),
        AccessPoint("matter", "building", "Matter", "Thread/Wi-Fi controller", ("light", "lock", "thermostat", "sensor", "outlet"), ("device.state.read", "device.state.set", "device.lock.set"), "PLANNED", "simulate", True, ("NOVA_MATTER_GATEWAY_URL",), "Fabric credentials remain in the local controller."),
        AccessPoint("home-assistant", "building", "Home Assistant", "REST/WebSocket", ("building-device", "camera", "sensor", "relay"), ("device.state.read", "device.service.call", "camera.snapshot"), "ALPHA", "simulate", True, ("NOVA_HOME_ASSISTANT_GATEWAY_URL",), "Preferred broad smart-building integration surface."),
        AccessPoint("opcua", "industrial", "OPC UA", "TLS gateway", ("plc", "industrial-robot", "machine", "lab-instrument"), ("industrial.node.read", "industrial.node.write", "industrial.method.call"), "PLANNED", "simulate", True, ("NOVA_OPCUA_GATEWAY_URL",), "Certificate trust list and namespace allowlist required."),
        AccessPoint("modbus", "industrial", "Modbus TCP/RTU", "TCP/serial gateway", ("plc", "drive", "sensor", "meter"), ("industrial.register.read", "industrial.register.write"), "PLANNED", "simulate", True, ("NOVA_MODBUS_GATEWAY_URL",), "Write ranges must be explicit and device-specific."),
        AccessPoint("bacnet", "building", "BACnet/IP", "UDP gateway", ("hvac", "building-controller", "meter"), ("building.object.read", "building.object.write"), "PLANNED", "simulate", True, ("NOVA_BACNET_GATEWAY_URL",), "Building automation network segmentation required."),
        AccessPoint("scpi", "laboratory", "SCPI", "VISA/TCP/serial gateway", ("oscilloscope", "power-supply", "spectrum-analyzer", "signal-generator"), ("lab.measure.read", "lab.instrument.configure", "lab.output.set"), "PROTOTYPE", "simulate", True, ("NOVA_SCPI_GATEWAY_URL",), "Instrument command allowlists required."),
        AccessPoint("edge-gateway", "compute", "NOVA Gateway API", "HTTPS", ("laptop", "raspberry-pi", "jetson", "workstation"), ("host.state.read", "host.file.read", "host.screenshot.capture", "host.command.run", "camera.snapshot", "serial.exchange"), "ALPHA", "simulate", True, ("NOVA_EDGE_GATEWAY_URL",), "Canonical host for vendor SDKs, cameras, serial and USB."),
        AccessPoint("onvif", "vision", "ONVIF", "SOAP/HTTPS gateway", ("ip-camera", "ptz-camera"), ("camera.state.read", "camera.snapshot", "camera.ptz.set"), "PLANNED", "simulate", True, ("NOVA_ONVIF_GATEWAY_URL",), "Camera credentials remain in the gateway."),
        AccessPoint("rtsp", "vision", "RTSP", "media gateway", ("ip-camera", "robot-camera"), ("camera.stream.inspect", "camera.frame.capture"), "PLANNED", "observe", True, ("NOVA_RTSP_GATEWAY_URL",), "Read-only media ingestion by default."),
        AccessPoint("ble", "iot", "Bluetooth LE", "local gateway", ("sensor", "wearable", "beacon", "robot-controller"), ("ble.device.discover", "ble.characteristic.read", "ble.characteristic.write"), "PLANNED", "observe", True, ("NOVA_BLE_GATEWAY_URL",), "BLE is for discovery, presence and low-bandwidth control; not bulk data."),
    ]

    env_by_access = {
        "ros2": "NOVA_ROS2_GATEWAY_URL",
        "mqtt": "NOVA_MQTT_GATEWAY_URL",
        "unitree": "NOVA_UNITREE_GATEWAY_URL",
        "spot": "NOVA_SPOT_GATEWAY_URL",
        "universal-robots": "NOVA_UR_GATEWAY_URL",
        "franka": "NOVA_FRANKA_GATEWAY_URL",
        "px4": "NOVA_PX4_GATEWAY_URL",
        "ardupilot": "NOVA_ARDUPILOT_GATEWAY_URL",
        "matter": "NOVA_MATTER_GATEWAY_URL",
        "home-assistant": "NOVA_HOME_ASSISTANT_GATEWAY_URL",
        "opcua": "NOVA_OPCUA_GATEWAY_URL",
        "modbus": "NOVA_MODBUS_GATEWAY_URL",
        "bacnet": "NOVA_BACNET_GATEWAY_URL",
        "scpi": "NOVA_SCPI_GATEWAY_URL",
        "edge-gateway": "NOVA_EDGE_GATEWAY_URL",
        "onvif": "NOVA_ONVIF_GATEWAY_URL",
        "rtsp": "NOVA_RTSP_GATEWAY_URL",
        "ble": "NOVA_BLE_GATEWAY_URL",
    }
    for descriptor in access_points:
        registry.register(descriptor, _http_gateway_handler(env_by_access[descriptor.access_id]))
    return registry


class RobotTaskPlanner:
    """Deterministic AI-facing planner that emits proposals, never direct execution."""

    KEYWORDS: tuple[tuple[tuple[str, ...], str], ...] = (
        (("stop", "halt", "freeze", "emergency"), "robot.stop"),
        (("navigate", "go to", "drive", "move to"), "robot.nav.goal"),
        (("velocity", "speed"), "robot.velocity.set"),
        (("arm", "trajectory", "joint"), "robot.arm.trajectory"),
        (("takeoff", "launch"), "vehicle.takeoff"),
        (("land",), "vehicle.land"),
        (("mission", "waypoint"), "vehicle.mission.upload"),
        (("camera", "snapshot", "photo"), "camera.snapshot"),
        (("sensor", "telemetry", "temperature"), "iot.telemetry.read"),
        (("relay", "switch", "turn on", "turn off"), "iot.command.publish"),
        (("status", "state", "health"), "robot.state.read"),
    )

    def __init__(self, registry: RobotAccessRegistry) -> None:
        self.registry = registry

    def plan(self, instruction: str, device_id: str, preferred_access: str | None = None) -> dict[str, Any]:
        normalized = instruction.lower().strip()
        capability = "robot.state.read"
        for words, candidate in self.KEYWORDS:
            if any(word in normalized for word in words):
                capability = candidate
                break

        candidates = []
        for access in self.registry.list_access_points():
            if capability in access["capabilities"]:
                candidates.append(access)
        if preferred_access:
            candidates.sort(key=lambda item: item["access_id"] != preferred_access)

        risk = "observe" if capability.endswith("read") or capability in {"camera.snapshot", "camera.frame.capture"} else "execute"
        selected = candidates[0]["access_id"] if candidates else None
        proposal = {
            "instruction": instruction,
            "device_id": device_id,
            "selected_access_id": selected,
            "capability": capability,
            "risk_tier": risk,
            "dry_run": True,
            "requires_approval": risk in {"execute", "critical"},
            "candidate_access_points": [item["access_id"] for item in candidates],
            "arguments": {"instruction": instruction},
            "planner": "nova.robot.task-planner.v1",
            "created_at": int(time.time()),
        }
        proposal["proposal_hash"] = digest(proposal)
        return proposal
