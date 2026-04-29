// ═══════════════════════════════════════════════════════════════════════════════
// NOVA × DALLAS ISD — DIGITAL CLASSROOM ADAPTERS — INDEX
// ═══════════════════════════════════════════════════════════════════════════════
//
// Free Digital Classroom Adapters for Dallas ISD & Dallas County public schools.
// Covers ALL curriculum areas: Math, Science, Social Studies, ELA, CS.
//
// ⚠ TRADE SECRET NOTICE: PhiExplorer and KuramotoClassroom are TRADE SECRETS
// of NOVA / Medina Tech. They are NOT exported from this module. The φ-formula
// engine and Kuramoto synchronization engine are proprietary IP.
// See: docs/charters/NOVA_MASTER_CHARTER.md §4
//
// Powered by NOVA — Medina Tech, Dallas TX.
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// ═══════════════════════════════════════════════════════════════════════════════

// ─── Digital Classroom Adapters (FREE — all subjects) ───────────────────────
export {
  DigitalClassroomAdapters,
  DIGITAL_CLASSROOM_CONSTANTS,
  // TEKS Curriculum (all subjects)
  getAllTEKSMappings,
  getTEKSBySubject,
  getTEKSByGrade,
  explainConcept,
  // Subject areas
  getSubjectAreas,
  getLessonCounts,
  // PWA SDK
  getDigitalClassroomPWAConfig,
  getServiceWorkerTemplate,
  // Grant funding
  getGrantFundingInfo,
} from './DigitalClassroomAdapters';

export type {
  SubjectArea,
  TEKSMapping,
  PWAConfig,
  GrantInfo,
} from './DigitalClassroomAdapters';

// ─── Legacy backward compatibility (DEPRECATED — use DigitalClassroomAdapters) ─
// NOTE: DallasISDAdapters.ts is retained for backward compatibility but
// PhiExplorer and KuramotoClassroom within it are TRADE SECRETS.
// New code should import from DigitalClassroomAdapters instead.
export {
  DallasISDAdapters,
  DALLAS_ISD_CONSTANTS,
} from './DallasISDAdapters';
