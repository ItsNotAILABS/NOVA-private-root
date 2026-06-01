"""NOVA Safety — Constants & Types"""

from enum import Enum

PHI = 1.6180339887498948482
PHI_INV = 0.6180339887498948482
AMOR = 0.3819660112501051518

TOTAL_CONTROLS = 481  # Total compliance controls

class SafetyLevel(str, Enum):
    SAFE = "SAFE"
    CAUTION = "CAUTION"
    WARNING = "WARNING"
    CRITICAL = "CRITICAL"
    EMERGENCY = "EMERGENCY"

class ComplianceState(str, Enum):
    COMPLIANT = "COMPLIANT"
    PARTIAL = "PARTIAL"
    NON_COMPLIANT = "NON_COMPLIANT"
    EXEMPT = "EXEMPT"

class ThreatClass(str, Enum):
    NONE = "NONE"
    LOW = "LOW"
    MEDIUM = "MEDIUM"
    HIGH = "HIGH"
    CRITICAL = "CRITICAL"
    EXISTENTIAL = "EXISTENTIAL"

class ControlCategory(str, Enum):
    ACCESS = "ACCESS"
    DATA = "DATA"
    NETWORK = "NETWORK"
    IDENTITY = "IDENTITY"
    CRYPTO = "CRYPTO"
    AUDIT = "AUDIT"
    GOVERNANCE = "GOVERNANCE"
    PHYSICAL = "PHYSICAL"
    COMPLIANCE = "COMPLIANCE"
    SOVEREIGN = "SOVEREIGN"

CONTROL_CATEGORIES = {
    ControlCategory.ACCESS: 52,
    ControlCategory.DATA: 58,
    ControlCategory.NETWORK: 48,
    ControlCategory.IDENTITY: 45,
    ControlCategory.CRYPTO: 51,
    ControlCategory.AUDIT: 47,
    ControlCategory.GOVERNANCE: 50,
    ControlCategory.PHYSICAL: 38,
    ControlCategory.COMPLIANCE: 46,
    ControlCategory.SOVEREIGN: 46,
}
