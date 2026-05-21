# Debug Type Mapping

You are helping a developer debug type conversion issues between Julia, JavaScript, and Motoko.

## Common Issues

### 1. Matrix Orientation
- Julia uses **column-major** order
- JavaScript uses **row-major** order
- When converting, you may need to transpose

```javascript
// Julia [[1,2],[3,4]] in column-major = [[1,3],[2,4]] in row-major
const transpose = (m) => m[0].map((_, i) => m.map(row => row[i]));
```

### 2. Complex Numbers
- Julia: `Complex{Float64}` or `ComplexF64`
- JavaScript: `{ re: number, im: number }`
- Motoko: `{ re: Float; im: Float }`

```javascript
// Julia 1 + 2im
const complex = { re: 1.0, im: 2.0 };
```

### 3. Integer Precision
- Julia `Int64` → JavaScript `bigint` (not `number`)
- JavaScript `number` can only safely represent integers up to 2^53 - 1

```javascript
// Use BigInt for 64-bit integers
const largeInt = 9007199254740993n; // n suffix for bigint
```

### 4. Optional/Nullable Types
- Julia: `Union{T, Nothing}` or `T | nothing`
- JavaScript: `T | null` or `T | undefined`
- Motoko: `?T`

```javascript
// Julia nothing = JavaScript null
const optionalValue = value ?? null;
```

### 5. Tuples
- Julia: `Tuple{Float64, Float64}` or `(Float64, Float64)`
- JavaScript: `[number, number]` (array)
- Candid: `record { _0: float64; _1: float64 }` (named positional fields)

## Debugging Steps

1. **Check the type map**: `/julia/type-map.json`
2. **Run round-trip test**: `node julia/tests/round-trip.test.js`
3. **Inspect the value at each stage**:
   - Julia value (original)
   - JavaScript value (after bridge)
   - Motoko value (after Candid encoding)
   - JavaScript result (after Candid decoding)
   - Julia-compatible value (final)

## Example Debug Session

**Problem:** Eigenvalues come back in wrong order

**Diagnosis:**
```javascript
// Julia returns eigenvalues sorted by magnitude (descending)
// JavaScript may not preserve order during conversion

// Fix: Sort after conversion
eigenvalues.sort((a, b) => Math.abs(b) - Math.abs(a));
```

**Problem:** Matrix inverse gives wrong result

**Diagnosis:**
```javascript
// Check if matrix is transposed
// Julia: A[row, col] (1-indexed)
// JavaScript: A[row][col] (0-indexed)

// If using column-major Julia data:
const A_js = transpose(A_julia);
```

## Reference

- Type map: `/julia/type-map.json`
- Bridge manifest: `/julia/bridge.manifest.json`
- Round-trip tests: `/julia/tests/round-trip.test.js`
