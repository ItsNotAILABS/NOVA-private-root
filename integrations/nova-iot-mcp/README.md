# NOVA IoT MCP Bridge

Local-first governed bridge for NOVA Phone, Sovereign Mind agents, lab hardware, and device networks.

## Run

```bash
cd integrations/nova-iot-mcp
python server.py
```

Default address: `http://127.0.0.1:8080`

## Endpoints

- `GET /health`
- `GET /v1/devices`
- `GET /v1/tools`
- `GET /v1/receipts`
- `POST /v1/invoke`

## Example sensor read

```bash
curl -s http://127.0.0.1:8080/v1/invoke \
  -H 'content-type: application/json' \
  -d '{
    "request_id":"read-1",
    "session_id":"nova-local-session",
    "agent_id":"nova-sovereign-mind",
    "capability":"iot.sensor.read",
    "server_id":"nova-local-iot",
    "tool_name":"read_sensor",
    "device_id":"lab-sensor-01",
    "arguments":{"metric":"temperature_c"},
    "risk_tier":"observe",
    "intent_nonce":"intent-read-00000001",
    "deadline":4102444800,
    "approval_id":null,
    "dry_run":false
  }'
```

## Safety boundary

- sessions expire
- capabilities must match the tool and device
- servers/tools/devices are allowlisted
- request nonces are single-use
- deadlines are enforced
- secret-bearing arguments are denied
- execute/critical tools require approval
- every result, denial, and failure emits a hash-chained receipt
- responses include an ICP anchor payload, but this module does not submit it to ICP
- no private key, wallet custody, or financial signing is accepted

## Tests

```bash
python -m unittest -v test_bridge.py
```

The included relay is a local demonstration adapter. Replace it with authenticated protocol-specific adapters such as MQTT, Matter, OPC-UA, Modbus, BLE, or vendor APIs. Keep each adapter behind the same policy and receipt boundary.
