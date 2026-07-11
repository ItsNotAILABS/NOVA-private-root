# NOVA Native C/C++ Interface

Production-oriented native interface for local NOVA / NOVA Agent Council runtimes.

This interface gives C and C++ applications a clean way to talk to the local NOVA MCP Spine over HTTP JSON-RPC without pulling a large dependency tree into native projects.

## Surfaces

- C ABI: `include/nova/nova_client.h`
- C++17 RAII wrapper: `include/nova/nova_client.hpp`
- Socket transport: `src/nova_client.cpp`
- Demo app: `examples/nova_tools_demo.cpp`
- Offline compile test: `tests/test_nova_client_offline.cpp`

## Build

```bash
cmake -S interfaces/cpp -B build/nova-cpp
cmake --build build/nova-cpp --config Release
ctest --test-dir build/nova-cpp --output-on-failure
```

## Usage

Start the NOVA MCP Spine first:

```bat
Start-NOVAAgentCouncil-MCP.bat
```

Then run the native demo:

```bash
./nova_tools_demo 127.0.0.1 8787
```

## Boundary

This client is transport and invocation only. It does not silently deploy, delete, or write to external systems. Tool calls still go through NOVA server-side permission and receipt rules.
