# Create Candid Interface

You are helping a developer generate Candid interface definitions for the Julia-Motoko bridge.

## What is Candid?

Candid is the Interface Description Language (IDL) for the Internet Computer. It:
- Describes the types and methods of a canister's public interface
- Enables type-safe communication between canisters
- Allows frontend (JavaScript/TypeScript) code to call canister methods

## Type Mappings

| Julia | Candid |
|-------|--------|
| Float64 | float64 |
| Float32 | float32 |
| Int64 | int64 |
| Int32 | int32 |
| UInt64 | nat64 |
| Bool | bool |
| String | text |
| Vector{Float64} | vec float64 |
| Matrix{Float64} | vec vec float64 |
| Complex{Float64} | record { re: float64; im: float64 } |
| Tuple{A, B} | record { _0: A; _1: B } |
| Union{T, Nothing} | opt T |
| Dict{String, Float64} | vec record { key: text; value: float64 } |

## Candid Syntax

```candid
// Service definition
service : {
  // Method with single argument returning single value
  method_name : (arg_type) -> (return_type);
  
  // Method with multiple arguments
  method_name : (arg1: type1, arg2: type2) -> (return_type);
  
  // Method with named return fields
  method_name : (arg_type) -> (record { field1: type1; field2: type2 });
  
  // Query method (read-only, faster)
  query_method : (arg_type) -> (return_type) query;
}
```

## Template

```candid
// Auto-generated Candid interface for NOVA Julia-Motoko Bridge
// Generated: {DATE}

type EigenResult = record {
  eigenvalues: vec float64;
  eigenvectors: vec vec float64;
};

type SvdResult = record {
  U: vec vec float64;
  S: vec float64;
  V: vec vec float64;
};

type OptimResult = record {
  optimum: vec float64;
  iterations: nat64;
};

type Complex = record {
  re: float64;
  im: float64;
};

type Oscillator = record {
  phase: float64;
  frequency: float64;
};

service : {
  // Linear Algebra
  linalg_eigen : (vec vec float64) -> (EigenResult);
  linalg_svd : (vec vec float64) -> (SvdResult);
  linalg_inv : (vec vec float64) -> (vec vec float64);
  linalg_det : (vec vec float64) -> (float64);
  linalg_norm : (vec float64) -> (float64);
  
  // Statistics
  stats_mean : (vec float64) -> (float64);
  stats_std : (vec float64) -> (float64);
  stats_cor : (vec float64, vec float64) -> (float64);
  
  // FFT
  fft_fft : (vec Complex) -> (vec Complex);
  fft_ifft : (vec Complex) -> (vec Complex);
  
  // Optimization (query not safe - heavy compute)
  optim_gradient_descent : (vec float64) -> (OptimResult);
  
  // Kuramoto
  kuramoto_step : (vec Oscillator, float64, float64) -> (vec Oscillator);
  order_parameter : (vec Oscillator) -> (float64) query;
}
```

## Instructions

When given a Julia function:

1. Map input types to Candid types
2. Map return type to Candid type
3. Create record types for complex returns
4. Generate the Candid method signature

## Example

**Julia:** `phi_svd(A::Matrix{Float64}) -> (Matrix{Float64}, Vector{Float64}, Matrix{Float64})`

**Candid:**
```candid
type SvdResult = record {
  U: vec vec float64;
  S: vec float64;
  V: vec vec float64;
};

linalg_svd : (vec vec float64) -> (SvdResult);
```

## Reference

- Type map: `/julia/type-map.json`
- Generated Candid: `/julia/generated/bridge.did`
