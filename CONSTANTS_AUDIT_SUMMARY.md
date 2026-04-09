# Sacred Geometry Constants Audit - NOVA main.mo

## Executive Summary

**Total Floating Point Constants Found:** 3,294  
**Significant Replacement Candidates:** 500+  
**Lines to Update:** ~300+

### Files Generated
1. **SACRED_GEOMETRY_AUDIT.txt** - Comprehensive analysis by category
2. **CONSTANT_REPLACEMENT_GUIDE.txt** - Line-by-line replacement specifications

## Key Findings

### Already Optimal (No Change)
- Line 537: `KURAMOTO_K = 0.618` ✓ (PHI_INVERSE)
- Line 534: `SOVEREIGN_FLOOR = 1.0` ✓ (Base reference)
- Line 536: `W_CEIL = 2.0` ✓ (Natural scaling)
- Line 2489: `TWO_PI = 6.283185307` ✓ (Standard constant)

### Critical Replacements Needed

#### 1. Coupling Constants
- Line 2215: `KP: 0.55` → `PHI_INVERSE (0.618)`
- Line 2216: `KD: 0.275` → `PHI_NEG_2 (0.382)` or review
- Line 4101: `K_ATT: 0.02` → `PHI_NEG_5 (0.090)` 
- Line 4102: `K_REP: 0.5` → `PHI_INVERSE (0.618)`

#### 2. Swarm Coherence
- Line 627: `rSwarm: 0.88` → Phi-derived equivalent
- Line 638: `preCorrectionRSwarm: 0.88` → Same as above

#### 3. Frequency Constants (Schumann Harmonics Needed)
- Line 708: `breathFrequencyHz: 0.15625/2π` → `SCHUMANN_BASE / 2π`
- Line 1044: `hzKoreFrequency: 500kHz` → Schumann-derived
- Line 1045: `hzThalamicFrequency: 60MHz` → Phi-scaled from Schumann
- Line 1046: `hzRASLocusFrequency: 120MHz` → Harmonic series
- Line 1047: `hzVaelFrequency: 800MHz` → Fibonacci-scaled

#### 4. Learning & Decay Rates
- Line 1490: `STDP_ALPHA: 0.005` → `PHI_NEG_5 (0.090)` or equivalent
- Line 1491: `DECAY: 0.001` → `PHI_NEG_7 (0.056)` or equivalent
- Line 1794: `Channel init: 0.5` → `PHI_INVERSE (0.618)`

#### 5. Drive Initializations (All Need Update)
- Lines 819-823: All drives = `0.5` → Should use phi-derived values
  - `driveHunger: 0.5` → `PHI_INVERSE (0.618)` or `PHI_NEG_2 (0.382)`
  - `driveCuriosity: 0.5` → `PHI_INVERSE (0.618)`
  - `driveSafety: 0.5` → `PHI_NEG_2 (0.382)` (cautious)
  - `driveSocial: 0.5` → `PHI_INVERSE (0.618)`
  - `driveReproduction: 0.5` → `PHI_INVERSE (0.618)`

#### 6. Neurochemical Concentrations
- Lines 802-1001: ~20 neurochemicals all = `1.0`
  - Needs review: Keep at 1.0 or shift to `PHI_INVERSE (0.618)`?
- Line 1005: `neurochemicalStressLevel: 0.5` → `PHI_NEG_2 (0.382)`
- Line 1006: `neurochemicalRewardLevel: 0.5` → `PHI_INVERSE (0.618)`
- Line 1008: `neurochemicalArousalLevel: 0.5` → `PHI_INVERSE (0.618)`

#### 7. Accuracy & Efficiency Thresholds (5 locations)
- Lines 1194, 1244, 1247, 1251, 1257: All = `0.8`
  - Replace with `PHI_INVERSE (0.618)` or keep as natural ratio

#### 8. Velocity Damping Factors
- Lines 1579-1580: `0.85` → Phi-derived momentum coefficient
- Lines 4362-4363: `0.9` → Fibonacci ratio
- Lines 4383-4384: `0.8` → PHI-derived segment

#### 9. Emotional State Constants
- Line 4185: `40.0, 10.0, 5.0` → Fibonacci or 2π×φ² based
- Line 4221: `1.5` → Keep (F5/F4 = 5/3), `0.5` → `PHI_INVERSE`
- Line 4242: `0.2, 0.1` → Fibonacci or phi-derived
- Line 4250: `0.3, 0.2` → Phi-derived segments

## Priority Tiers

### Priority 1 (CRITICAL)
- Coupling constants (lines 2215-2216, 4101-4102)
- Drive initializations (lines 819-823)
- Swarm coherence (lines 627, 638)

### Priority 2 (HIGH)
- Frequency constants (lines 708, 1044-1047)
- Learning rates (lines 1490-1491)
- Neurochemical baselines (lines 1005-1008)
- Accuracy thresholds (lines 1194, 1244, 1247, 1251, 1257)

### Priority 3 (MEDIUM)
- Velocity damping (multiple lines)
- Emotional constants (lines 4185, 4221, 4242, 4250)
- Miscellaneous 0.8 factors

### Priority 4 (LOW)
- Scattered hardcoded PI values (~40 occurrences)
- Physics function coefficients
- Fine-tuning optimizations

## Required Constants Definition

```motoko
// Golden Ratio Derivatives
let PHI : Float = 1.618033988749895;
let PHI_INVERSE : Float = 0.618033988749895;
let PHI_SQUARED : Float = 2.618033988749895;
let PHI_CUBED : Float = 4.236067977499789;
let PHI_4TH : Float = 6.854101966246193;
let PHI_NEG_2 : Float = 0.381966011250105;
let PHI_NEG_3 : Float = 0.236067977499789;
let PHI_NEG_4 : Float = 0.145898033873053;
let PHI_NEG_5 : Float = 0.090169943749474;

// Schumann Harmonics (Hz)
let SCHUMANN_BASE : Float = 7.83;
let SCHUMANN_H2 : Float = 14.3;
let SCHUMANN_H3 : Float = 20.8;
let SCHUMANN_H4 : Float = 26.4;

// Pi constant (centralized)
let PI : Float = 3.14159265358979323846;
let TWO_PI : Float = 6.283185307;
```

## Statistics

| Category | Count | Priority |
|----------|-------|----------|
| Coupling Constants | 5 | Critical |
| Swarm Coherence | 2 | Critical |
| Drive Initializations | 5 | Critical |
| Neurochemicals | 20+ | High |
| Learning Rates | 3 | High |
| Frequency Constants | 5 | High |
| Accuracy Thresholds | 5 | High |
| Velocity Damping | 6 | Medium |
| Emotional State | 8+ | Medium |
| Miscellaneous | 30+ | Low |
| **TOTAL** | **~500+** | **Variable** |

## Implementation Notes

1. **Scope**: Main.mo is 969.7 KB with 3,294 floating point constants
2. **Risk**: Changes affect core synchronization and coherence calculations
3. **Testing**: Verify synchrony behavior after updates (kfHz convergence)
4. **Modules**: Check if PhiResonanceArchitecture or other modules already define these constants
5. **Pattern**: Look for existing `PHI` usage to understand expected patterns

## See Also

- `/home/runner/work/NOVA/NOVA/SACRED_GEOMETRY_AUDIT.txt` - Full technical analysis
- `/home/runner/work/NOVA/NOVA/CONSTANT_REPLACEMENT_GUIDE.txt` - Line-by-line guide
