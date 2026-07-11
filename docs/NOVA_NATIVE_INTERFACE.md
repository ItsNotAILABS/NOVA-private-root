# NOVA Native Interface

The NOVA native interface adds a professional C/C++ integration surface under `native/`.

## Why this exists

NOVA needs a clean native boundary for systems that do not want to speak Python, JavaScript, Motoko, or browser-first APIs directly. A C ABI gives the stack a low-level foundation that can be wrapped by other languages and embedded into native environments.

## Current capabilities

- Creates a native NOVA runtime handle.
- Returns a JSON status packet.
- Accepts intent packets with JSON payloads.
- Emits deterministic receipt structs.
- Provides status/error codes.
- Includes a C++17 RAII wrapper.
- Builds through CMake.
- Runs cross-platform CI.

## Commands

```bash
cmake -S native -B native/build -DCMAKE_BUILD_TYPE=Release
cmake --build native/build
ctest --test-dir native/build --output-on-failure
```

## Native bridge roadmap

1. Local ABI and examples. Done in this interface package.
2. IPC bridge to local NOVA services.
3. Terminalis bridge.
4. MCP bridge adapter.
5. Authenticated runtime endpoint.
6. Receipt signing and hash manifest.
7. Language wrappers for Rust, Python, Swift, C#, and Node native addons.

## Boundary

This interface is currently a native local runtime boundary and testable scaffold. It does not claim remote deployment, wallet execution, chain notarization, or external NOVA service connectivity until those bridges are explicitly implemented and tested.
