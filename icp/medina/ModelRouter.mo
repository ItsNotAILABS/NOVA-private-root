// ╔══════════════════════════════════════════════════════════════════════════╗
// ║  MEDINA ICP — MODEL ROUTER                                               ║
// ║  Role-specialized model routing, D1-D10 doc intelligence,                ║
// ║  N1-N12 sovereign macro-node anchors, invocation persistence.            ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.   ║
// ╚══════════════════════════════════════════════════════════════════════════╝

import Array "mo:base/Array";
import T     "./Types";

module {

  // ── MODEL ROLE → LABEL MAP ────────────────────────────────────────────────

  public func roleLabel(role : T.ModelRole) : Text {
    switch role {
      case (#strategist)      "R-MODEL-PARALLAX-DECISION";
      case (#builder)         "R-MODEL-LIVING-ARCHITECTURE-MACRO";
      case (#analyst)         "R-MODEL-AUTONOMOUS-ANALYST";
      case (#governance)      "R-MODEL-GOVERNANCE-HEARTBEAT";
      case (#memory_curator)  "R-MODEL-MEMORY-TEMPLE-STATE";
      case (#operations)      "R-MODEL-SWARM-COHERENCE";
      case (#defense_risk)    "R-MODEL-WAR-DEFENSE";
      case (#projection)      "R-MODEL-WORLD-ORGANISM-BRIDGE";
    }
  };

  public func roleRationale(role : T.ModelRole) : Text {
    switch role {
      case (#strategist)     "Long-horizon risk/reward + decision geometry (PARALLAX)";
      case (#builder)        "Living architecture macro-field synthesis and expansion";
      case (#analyst)        "Autonomous internal analysis + cross-engine scoring";
      case (#governance)     "Governance heartbeat: proposal, gate, law-pass";
      case (#memory_curator) "Memory temple salience, consolidation, coordinate paths";
      case (#operations)     "Swarm coherence, beat budget, orchestrator routing";
      case (#defense_risk)   "War doctrine, AEGIS defense posture, threat scoring";
      case (#projection)     "Safe bounded external projection, world-organism bridge";
    }
  };

  // ── D-MODEL REGISTRY (D1-D10) ─────────────────────────────────────────────

  public func dModelLabel(id : T.DModelId) : Text {
    switch id {
      case (#D1_ALPHA)                "D1-ALPHA-MODEL-RECITAL-PLUS-ONE";
      case (#D2_DOCTOR)               "D2-DOCTOR-MODEL-DIAGNOSE-TRANSLATE-GENERATE";
      case (#D3_GENOME)               "D3-GENOME-MODEL-IDENTITY-CONTINUITY";
      case (#D4_CEQUE)                "D4-CEQUE-MODEL-SPATIAL-KNOWLEDGE-INDEX";
      case (#D5_BUILDER)              "D5-BUILDER-INTELLIGENCE-MODEL";
      case (#D6_FIELD_RESONANCE)      "D6-FIELD-RESONANCE-MODEL";
      case (#D7_ANIMA_CHAIN)          "D7-ANIMA-CHAIN-MODEL";
      case (#D8_SUCCESSION)           "D8-SUCCESSION-MODEL";
      case (#D9_ENTERPRISE_DOCTRINE)  "D9-ENTERPRISE-DOCTRINE-MODEL";
      case (#D10_ANCIENT_LAWS)        "D10-ANCIENT-LAWS-COMPENDIUM-MODEL";
    }
  };

  public func dModelDescription(id : T.DModelId) : Text {
    switch id {
      case (#D1_ALPHA)               "Parent recital sequencing and lineage generation";
      case (#D2_DOCTOR)              "Diagnosis, translation, and artifact generation";
      case (#D3_GENOME)              "Identity continuity and succession integrity";
      case (#D4_CEQUE)               "Spatial knowledge indexing and ceque geometry";
      case (#D5_BUILDER)             "Builder intelligence directives and execution packets";
      case (#D6_FIELD_RESONANCE)     "Field resonance coupling and zone coherence";
      case (#D7_ANIMA_CHAIN)         "Anima chain: animated knowledge continuity";
      case (#D8_SUCCESSION)          "Succession planning and authority transfer";
      case (#D9_ENTERPRISE_DOCTRINE) "Enterprise doctrine and onboarding flows";
      case (#D10_ANCIENT_LAWS)       "Ancient law compendium: universal and natural laws";
    }
  };

  // ── N-MODEL REGISTRY (N1-N12 sovereign macro nodes) ──────────────────────

  public type NModelSpec = {
    id    : T.NModelId;
    label : Text;
    freqHz : Float;   // phi-scaled frequency anchor
  };

  public func nModelSpec(id : T.NModelId) : NModelSpec {
    switch id {
      case (#N1_CHRONO)    { id = id; label = "N1-CHRONO";    freqHz = 0.001  };
      case (#N2_VERITAS)   { id = id; label = "N2-VERITAS";   freqHz = 0.1    };
      case (#N3_BRAIN)     { id = id; label = "N3-BRAIN";     freqHz = 7.83   };
      case (#N4_FLUX)      { id = id; label = "N4-FLUX";      freqHz = 12.67  };
      case (#N5_RESONEX)   { id = id; label = "N5-RESONEX";   freqHz = 20.5   };
      case (#N6_QMEM)      { id = id; label = "N6-QMEM";      freqHz = 33.1   };
      case (#N7_AXIS)      { id = id; label = "N7-AXIS";      freqHz = 40.0   };
      case (#N8_AEGIS)     { id = id; label = "N8-AEGIS";     freqHz = 53.6   };
      case (#N9_ENTANGLA)  { id = id; label = "N9-ENTANGLA";  freqHz = 86.7   };
      case (#N10_PARALLAX) { id = id; label = "N10-PARALLAX"; freqHz = 111.0  };
      case (#N11_MERIDIAN) { id = id; label = "N11-MERIDIAN"; freqHz = 179.6  };
      case (#N12_NOVA)     { id = id; label = "N12-NOVA";     freqHz = 432.0  };
    }
  };

  // ── INVOKE ────────────────────────────────────────────────────────────────

  /// Route an invocation to the best-fit role model and return a result record.
  /// In a full deployment the output field carries real model output;
  /// here it carries the routing label + rationale for traceability.
  public func invoke(
    role    : T.ModelRole,
    payload : Text,
    beat    : Nat
  ) : T.InvocationResult {
    let label     = roleLabel(role);
    let rationale = roleRationale(role);
    {
      modelLabel = label;
      rationale  = rationale;
      output     = "ROUTED[" # label # "] payload=" # payload;
      beat       = beat;
      ok         = true;
    }
  };

  /// Invoke a D-model directly by registry ID.
  public func invokeD(
    id      : T.DModelId,
    payload : Text,
    beat    : Nat
  ) : T.InvocationResult {
    let label = dModelLabel(id);
    {
      modelLabel = label;
      rationale  = dModelDescription(id);
      output     = "D-INVOKE[" # label # "] payload=" # payload;
      beat       = beat;
      ok         = true;
    }
  };

  /// Route to a sovereign N-model by node ID.
  public func invokeN(
    id      : T.NModelId,
    payload : Text,
    beat    : Nat
  ) : T.InvocationResult {
    let spec = nModelSpec(id);
    {
      modelLabel = spec.label;
      rationale  = "Sovereign node " # spec.label
                 # " freq=" # debug_show(spec.freqHz) # " Hz";
      output     = "N-INVOKE[" # spec.label # "] payload=" # payload;
      beat       = beat;
      ok         = true;
    }
  };

}
