# Generate Motoko Wrapper

You are helping a developer generate Motoko wrapper code for a Julia function.

## Context

The NOVA Julia-Motoko bridge allows Julia numerical functions to be called from Motoko smart contracts on the Internet Computer. The bridge works through a JavaScript/WASM layer.

## Type Mappings

Use these type mappings:

| Julia | Motoko |
|-------|--------|
| Float64 | Float |
| Int64 | Int |
| Bool | Bool |
| String | Text |
| Vector{Float64} | [Float] |
| Matrix{Float64} | [[Float]] |
| Complex{Float64} | { re: Float; im: Float } |
| Tuple{A, B} | (A, B) |
| Union{T, Nothing} | ?T |

## Instructions

1. Parse the Julia function signature
2. Map input types to Motoko types
3. Map return type to Motoko type
4. Generate async shared function that calls the Julia bridge

## Template

```motoko
// Auto-generated Motoko wrapper for: {FUNCTION_NAME}
// Description: {DESCRIPTION}

public shared func {motoko_function_name}({args}) : async {return_type} {
  let result = await julia_bridge_call("{julia_function_name}", [{arg_names}]);
  return result;
};
```

## Example

**Input:** Julia function `phi_eigen(A::Matrix{Float64}) -> (Vector{Float64}, Matrix{Float64})`

**Output:**
```motoko
// Auto-generated Motoko wrapper for: phi_eigen
// Description: Eigenvalue decomposition with φ-weighting

public shared func linalg_eigen(A: [[Float]]) : async ([Float], [[Float]]) {
  let result = await julia_bridge_call("linalg.eigen", [A]);
  return result;
};
```

## Your Task

When given a Julia function signature, generate:
1. The Motoko wrapper code
2. Brief usage example
3. Any type conversion notes

Reference the bridge manifest at `/julia/bridge.manifest.json` for function metadata.
