# Full Bridge Task Example

This example shows how to use the NOVA Julia-Motoko bridge to create a complete on-chain risk scoring system.

## Task: On-Chain Risk Scoring Service

Create a canister that:
1. Accepts a portfolio matrix (assets × time series)
2. Computes covariance eigenvalues (risk factors)
3. Returns a φ-weighted risk score

## Step 1: Define the Julia Function

```julia
# In NovaJulia.jl

function phi_risk_score(portfolio::Matrix{Float64})
    # Compute covariance matrix
    n_assets, n_periods = size(portfolio)
    returns = diff(portfolio, dims=2) ./ portfolio[:, 1:end-1]
    cov_matrix = cov(returns')
    
    # Get eigenvalues (risk factors)
    λ, V = eigen(cov_matrix)
    
    # φ-weighted risk score
    # Larger eigenvalues = more systematic risk
    # Weight by φ^(-i) to emphasize dominant risks
    risk_weights = [PHI^(-i) for i in 1:length(λ)]
    risk_score = sum(abs.(λ) .* risk_weights) / sum(risk_weights)
    
    return risk_score
end
```

## Step 2: Generate Motoko Wrapper

```motoko
// JuliaCompute.mo

import Float "mo:base/Float";

module {
  private let julia_bridge = actor("julia-wasm-bridge") : actor {
    call : (Text, [Any]) -> async Any;
  };

  // Risk scoring function
  public shared func compute_risk_score(portfolio: [[Float]]) : async Float {
    let result = await julia_bridge.call("risk.phi_risk_score", [portfolio]);
    return result;
  };
}
```

## Step 3: Generate Candid Interface

```candid
// bridge.did

service : {
  compute_risk_score : (vec vec float64) -> (float64);
}
```

## Step 4: Create TypeScript Client

```typescript
// risk_client.ts

import { Actor, HttpAgent } from '@dfinity/agent';
import { idlFactory } from './declarations/julia_compute';

const agent = new HttpAgent({ host: 'https://ic0.app' });
const juliaCompute = Actor.createActor(idlFactory, {
  agent,
  canisterId: 'your-canister-id',
});

async function computeRiskScore(portfolio: number[][]): Promise<number> {
  return await juliaCompute.compute_risk_score(portfolio);
}

// Example usage
const portfolio = [
  [100, 102, 101, 103, 105],  // Asset 1 prices
  [50, 51, 49, 52, 53],       // Asset 2 prices
  [200, 198, 202, 201, 205],  // Asset 3 prices
];

const riskScore = await computeRiskScore(portfolio);
console.log('φ-weighted risk score:', riskScore);
```

## Step 5: Create Test Vectors

```javascript
// test_vectors.js

const testCases = [
  {
    name: 'Low volatility portfolio',
    input: [
      [100, 100.1, 100.2, 100.15, 100.25],
      [50, 50.05, 50.1, 50.08, 50.12],
    ],
    expected_risk_range: [0, 0.01],
    notes: 'Small price movements → low risk score'
  },
  {
    name: 'High volatility portfolio',
    input: [
      [100, 110, 90, 115, 85],
      [50, 40, 60, 35, 65],
    ],
    expected_risk_range: [0.1, 0.5],
    notes: 'Large price swings → high risk score'
  },
  {
    name: 'Correlated assets',
    input: [
      [100, 105, 110, 115, 120],
      [50, 52.5, 55, 57.5, 60],
    ],
    expected_risk_range: [0.02, 0.1],
    notes: 'Perfectly correlated → concentrated risk factor'
  },
];
```

## Step 6: Validate Round-Trip

```javascript
// round_trip_test.js

import { getJuliaCompute } from './protocols/PROTOCOL-JULIA.js';

async function testRoundTrip() {
  const julia = getJuliaCompute();
  await julia.initialize();

  const portfolio = [
    [100, 102, 101, 103, 105],
    [50, 51, 49, 52, 53],
    [200, 198, 202, 201, 205],
  ];

  // Julia → JS
  const jsPortfolio = portfolio; // Direct mapping

  // Compute via bridge
  const riskScore = await julia.call('risk.phi_risk_score', jsPortfolio);

  // Validate return type
  console.assert(typeof riskScore === 'number', 'Risk score should be number');
  console.assert(riskScore >= 0, 'Risk score should be non-negative');
  console.assert(Number.isFinite(riskScore), 'Risk score should be finite');

  console.log('Round-trip validation passed');
  console.log('Risk score:', riskScore);
}

testRoundTrip();
```

## Complete File Structure

```
julia/
├── NovaJulia.jl              # Julia functions
├── bridge.manifest.json      # Function metadata
├── type-map.json             # Type mappings
├── generated/
│   ├── bridge.did            # Candid interface
│   ├── JuliaCompute.mo       # Motoko module
│   └── julia_compute.ts      # TypeScript client
├── tests/
│   └── round-trip.test.js    # Round-trip tests
└── examples/
    └── risk_scoring/
        ├── main.mo           # Canister entry
        ├── client.ts         # Frontend client
        └── test_vectors.json # Test data
```

## AI Agent Checklist

When building a bridge task:

- [ ] Define Julia function with type annotations
- [ ] Register in JULIA_FUNCTIONS (PROTOCOL-JULIA.js)
- [ ] Generate Motoko wrapper
- [ ] Generate Candid interface
- [ ] Create TypeScript client
- [ ] Write test vectors
- [ ] Validate round-trip
- [ ] Document numerical caveats
- [ ] Add to bridge.manifest.json

## Reference Files

- Bridge manifest: `/julia/bridge.manifest.json`
- Type map: `/julia/type-map.json`
- Protocol: `/protocols/PROTOCOL-JULIA.js`
- Julia module: `/julia/NovaJulia.jl`
