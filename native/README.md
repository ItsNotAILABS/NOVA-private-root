# NOVA Native C/C++ Interface

A polished, dependency-light C/C++ interface for embedding NOVA runtime operations into native applications, command-line tools, local agents, game engines, desktop software, robotics controllers, and high-performance systems.

This interface is intentionally local-first and stable at the ABI boundary:

- **C ABI** for maximum compatibility.
- **C++17 RAII wrapper** for safer modern usage.
- **CMake project** for professional builds.
- **Examples** for C and C++.
- **Tests** for runtime creation, status, packet submission, and receipt flow.

## Layout

```text
native/
  CMakeLists.txt
  include/nova/nova.h       # stable C ABI
  include/nova/nova.hpp     # C++17 wrapper
  src/nova.c                # C ABI implementation
  src/nova_runtime.cpp      # C++ helper implementation
  src/nova_runtime.hpp      # internal runtime helpers
  examples/c_basic.c
  examples/cpp_basic.cpp
  tests/test_nova_native.cpp
```

## Build

```bash
cmake -S native -B native/build -DCMAKE_BUILD_TYPE=Release
cmake --build native/build
ctest --test-dir native/build --output-on-failure
```

## C Example

```c
#include "nova/nova.h"

nova_config_t config;
nova_config_init(&config);
config.instance_name = "native-app";
config.operator_id = "operator";

nova_runtime_t* runtime = NULL;
int rc = nova_runtime_create(&config, &runtime);
```

Submit a packet:

```c
nova_packet_t packet;
packet.intent = "native status packet";
packet.payload_json = "{\"source\":\"c\"}";
packet.route_hint = "native";

nova_receipt_t receipt;
rc = nova_runtime_submit(runtime, &packet, &receipt);
```

## C++ Example

```cpp
#include "nova/nova.hpp"

nova::Config config;
config.instance_name = "native-app";
config.operator_id = "operator";

nova::Runtime runtime(config);
auto receipt = runtime.submit({"status packet", "{\"source\":\"cpp\"}", "native"});
```

## ABI Contract

The C ABI is built around opaque runtime handles and explicit status codes:

- `nova_runtime_t*`
- `nova_config_t`
- `nova_packet_t`
- `nova_receipt_t`
- `NOVA_OK`
- `NOVA_ERR_*`

This keeps the interface safe to call from C, C++, Rust FFI, Python native extensions, Swift wrappers, game engines, and embedded integration layers.

## Current Runtime Boundary

This first native layer is a **local native interface stub**. It does not claim to connect to remote NOVA services, wallets, chain systems, MCP networks, or private production infrastructure yet. It establishes the stable ABI and native packaging surface first.

Future bridge layers can wire `nova_runtime_submit` into deeper NOVA runtime buses, local IPC, MCP bridges, Terminalis, ROOTZIP, or authenticated service endpoints.

## Design Goals

- stable ABI before deep runtime coupling
- zero mandatory third-party dependencies
- predictable memory ownership
- explicit error codes
- C-compatible structs
- modern C++ convenience wrapper
- portable CMake build
- testable examples
