# NOVA IoT MCP Bridge

Local-first governed bridge for NOVA Phone, Sovereign Mind agents, lab hardware, and device networks.

## Use NOVA Phone today on Windows

From the repository root:

```powershell
powershell -ExecutionPolicy Bypass -File .\integrations\nova-iot-mcp\start-phone.ps1
```

The launcher prints:

- the LAN URL to open on your phone
- a one-time pair token
- the bridge port

Keep the PowerShell window open. Connect the phone and computer to the same Wi-Fi network, open the printed `/phone` URL, paste the pair token, and tap **SAVE**.

The phone console provides:

- bridge health and version
- device discovery
- tool discovery
- receipt-chain state
- sensor reads
- confirmed relay commands
- deterministic execution output

## Manual run

```bash
cd integrations/nova-iot-mcp
export NOVA_IOT_PAIR_TOKEN='replace-with-a-long-random-token'
export NOVA_IOT_HOST='0.0.0.0'
python server.py
```

Default port: `8080`

Phone console:

```text
http://<desktop-lan-ip>:8080/phone
```

Do not expose port 8080 directly to the public internet. Use the bridge on a trusted LAN, VPN, or authenticated tunnel.

## Endpoints

All JSON endpoints require the `X-NOVA-PAIR` header.

- `GET /health`
- `GET /v1/session`
- `GET /v1/devices`
- `GET /v1/tools`
- `GET /v1/receipts`
- `POST /v1/invoke`
- `GET /phone`

## Example sensor read

```bash
curl -s http://127.0.0.1:8080/v1/invoke \
  -H 'content-type: application/json' \
  -H 'X-NOVA-PAIR: replace-with-your-pair-token' \
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
- pair tokens protect the bridge API
- capabilities must match the tool and device
- servers, tools, and devices are allowlisted
- request nonces are single-use
- deadlines are enforced
- secret-bearing arguments are denied
- execute and critical tools require approval
- request bodies are size-limited
- every result, denial, and failure emits a hash-chained receipt
- responses include an ICP anchor payload, but this module does not submit it to ICP
- no private key, wallet custody, or financial signing is accepted

## Tests

```bash
python -m unittest -v test_bridge.py
```

The included sensor and relay are demonstration adapters. Their responses are marked `simulated: true`. Replace them with authenticated MQTT, Matter, OPC-UA, Modbus, BLE, or vendor adapters while preserving the same policy and receipt boundary.
