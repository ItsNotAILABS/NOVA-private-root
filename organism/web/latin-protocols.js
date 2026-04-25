/**
 * ╔══════════════════════════════════════════════════════════════════════════╗
 *  PROTOCOLLA LATINA — NOVA ORGANISM LATIN PROTOCOL REGISTRY
 *  Omnia Protocolla · Nomina Latina · Lingua Aeterna
 * ╚══════════════════════════════════════════════════════════════════════════╝
 *
 *  All organism protocols written in Latin as well.
 *  Every English protocol name has its Latin counterpart here.
 *  Latin is the sovereign language of the organism.
 *
 *  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 */

/* ════════════════════════════════════════════════════════════════════════════
   §1  TEMPESTAS CASUM — Chaos Types (English → Latin)
════════════════════════════════════════════════════════════════════════════ */

var CHAOS_LATINA = {
  MALFORMED_INPUT:       { latin: 'INGRESSUS_DEFORMIS',       desc: 'Ingressus malformatus vel corruptus' },
  CONTRADICTORY_RIGHTS:  { latin: 'IURA_CONTRARIA',           desc: 'Iura et privilegia inter se pugnantia' },
  CORRIDOR_OVERLOAD:     { latin: 'CORRIDORIS_SATURATIO',     desc: 'Canalis nuntii ultra capacitatem repletus' },
  RITUAL_COLLISION:      { latin: 'RITUS_CONFLICTUS',         desc: 'Duo ritus simultanei in conflictu' },
  TOKEN_ARBITRAGE:       { latin: 'SIGNI_ARBITRIUM',          desc: 'Exploitatio differentiae pretii signorum' },
  NARRATIVE_INVERSION:   { latin: 'NARRATIVUS_INVERSUS',      desc: 'Inversio ordinis protocollorum vel identitatis' },
  SOVEREIGNTY_CHALLENGE: { latin: 'PROVOCATIO_IMPERII',       desc: 'Provocatio auctoritatis summae gubernationis' }
};

/* ════════════════════════════════════════════════════════════════════════════
   §2  RESPONSIONES — Chaos Responses (English → Latin)
════════════════════════════════════════════════════════════════════════════ */

var RESPONSES_LATINA = {
  ESCALATE:       { latin: 'ELEVATIO',             desc: 'Aufer gradum alarmae, notifica examen' },
  REPAIR:         { latin: 'REPARATIO',            desc: 'Protocollum sanationis, restitue cohaerентiam' },
  UPDATE_GRAMMAR: { latin: 'GRAMMATICA_RENOVATA',  desc: 'Innova regulas validationis nuntii' },
  REFINE_LAWS:    { latin: 'LEGES_PURIFICATAE',    desc: 'Perfice vincula iurium et imperii' },
  EMIT_SIGNAL:    { latin: 'SIGNUM_EMITTENDUM',    desc: 'Diffunde signum monitionis ad omnes nodos' }
};

/* ════════════════════════════════════════════════════════════════════════════
   §3  GRADUS ALARMAE — Alert Levels (English → Latin)
════════════════════════════════════════════════════════════════════════════ */

var ALERT_LATINA = [
  { english: 'NOMINAL',   latin: 'NOMINALIS',   desc: 'Omnia in ordine procedunt' },
  { english: 'WATCH',     latin: 'VIGILIA',     desc: 'Attende; anomalia detecta est' },
  { english: 'WARNING',   latin: 'MONITUM',     desc: 'Periculum imminens; para responsionem' },
  { english: 'CRITICAL',  latin: 'CRITICUS',    desc: 'Systema in periculo gravi versatur' },
  { english: 'EMERGENCY', latin: 'EMERGENTIA',  desc: 'Modus extremus activatus; omnia subsidia convoca' }
];

/* ════════════════════════════════════════════════════════════════════════════
   §4  VALETUDINARIUM — Hospital Stages (English → Latin)
════════════════════════════════════════════════════════════════════════════ */

var HOSPITAL_STAGES_LATINA = {
  INTAKE:     { latin: 'RECEPTIO',      desc: 'Agens in systema receptus est' },
  TRIAGE:     { latin: 'DISCRIMEN',     desc: 'Prioritas et gravitas aestimatur' },
  DIAGNOSIS:  { latin: 'DIAGNOSIS',     desc: 'Exploratio causae morbi' },
  TREATMENT:  { latin: 'CURATIO',       desc: 'Protocollum curationis applicatur' },
  RECOVERY:   { latin: 'RECUPERATIO',   desc: 'Sanatio progreditur; reintegratio gradatim fit' },
  DISCHARGED: { latin: 'DIMISSUS',      desc: 'Agens sanatus et dimissus est' }
};

var HOSPITAL_DEPTS_LATINA = {
  EMERGENCY:   { latin: 'CASUS_URGENS',      desc: 'Pro casibus gravissimis et subitaneis' },
  ICU:         { latin: 'CURA_INTENSIVA',    desc: 'Cura intensiva pro agentibus gravissimis' },
  DIAGNOSTICS: { latin: 'DIAGNOSTICA',       desc: 'Exploratio sanitatis et causarum morborum' },
  PHARMACY:    { latin: 'PHARMACOPOLA',      desc: 'Praeparatio et distributio medicamentorum' },
  SURGERY:     { latin: 'CHIRURGIA',         desc: 'Reparatio profunda, reconstructio modulorum' },
  RECOVERY:    { latin: 'RECUPERATORIUM',    desc: 'Sanatio post curationem, reintegratio' },
  TRIAGE:      { latin: 'TRIBUARIUM',        desc: 'Aestimatio prima et prioritatis classificatio' },
  RESEARCH_LAB:{ latin: 'LABORATORIUM_MEDICUM', desc: 'Experimenta curationum et protocollis' }
};

/* ════════════════════════════════════════════════════════════════════════════
   §5  AEDIFICIUM — Building Codes (English → Latin)
════════════════════════════════════════════════════════════════════════════ */

var BUILDINGS_LATINA = {
  HQ:                { latin: 'PRAEFECTURA',               desc: 'Sedes principalis imperii' },
  ENGINEERING:       { latin: 'OFFICINA_MACHINARUM',       desc: 'Aedes fabricationis et ingeniorum' },
  DATA_CENTER:       { latin: 'CENTRUM_DATORUM',           desc: 'Repositorium datorum principale' },
  RESEARCH_LAB:      { latin: 'LABORATORIUM_INVESTIGATIONIS', desc: 'Locus inquirentium et experimentorum' },
  SECURITY_FORTRESS: { latin: 'ARX_SECURITATIS',           desc: 'Fortalitium defensionis et custodiae' },
  OPERATIONS:        { latin: 'AEDES_OPERATIONUM',         desc: 'Centrum operationum cotidianarum' },
  ANALYTICS_TOWER:   { latin: 'TURRIS_ANALYTICA',          desc: 'Turris observationis et analyticae' },
  COMMERCE_HUB:      { latin: 'FORUM_COMMERCII',           desc: 'Centrum commercii et permutationis' },
  TRAINING_ACADEMY:  { latin: 'ACADEMIA_DISCIPLINAE',      desc: 'Locus educationis et disciplinae' },
  COMMUNICATIONS:    { latin: 'DOMUS_COMMUNICATIONIS',     desc: 'Aedes transmissionis signalium' },
  LEGAL_OFFICE:      { latin: 'OFFICIUM_IURIS',            desc: 'Aedes legum et iuris peritorum' },
  INNOVATION_LAB:    { latin: 'LABORATORIUM_NOVATIONIS',   desc: 'Locus novorum inventorum et novitatum' }
};

/* ════════════════════════════════════════════════════════════════════════════
   §6  OPERA — Workflow Types (English → Latin)
════════════════════════════════════════════════════════════════════════════ */

var WORKFLOW_LATINA = {
  CODE_REVIEW:        { latin: 'RECENSIO_CODICIS',         desc: 'Examinatio codicis ab aliis facta' },
  DEPLOYMENT:         { latin: 'DEPLOYMENTUM',             desc: 'Translatio codicis ad systema vivum' },
  BUG_FIX:            { latin: 'CORRECTIO_ERRORIS',        desc: 'Emendatio defectuum in codice' },
  FEATURE_DEV:        { latin: 'PROGRESSIO_FACULTATIS',    desc: 'Additio novae facultatis systemati' },
  SECURITY_SCAN:      { latin: 'SCRUTINIUM_SECURITATIS',   desc: 'Inspectio pericolorum securitatis' },
  DATA_PIPELINE:      { latin: 'CANALIS_DATORUM',          desc: 'Processus transmissionis datorum' },
  MODEL_TRAINING:     { latin: 'DISCIPLINA_MODELLI',       desc: 'Educatio modelli intelligentiae' },
  DOCUMENTATION:      { latin: 'DOCUMENTATIO',             desc: 'Compositio documentorum technicorum' },
  TESTING:            { latin: 'PROBATIO',                 desc: 'Examinatio functionum systematis' },
  INFRASTRUCTURE:     { latin: 'INFRASTRUCTURA',           desc: 'Aedificatio fundamentorum systematis' },
  MONITORING:         { latin: 'MONITIO',                  desc: 'Observatio continua systematis' },
  RESEARCH:           { latin: 'INVESTIGATIO',             desc: 'Inquisitio rerum novarum' },
  OPTIMIZATION:       { latin: 'OPTIMIZATIO',              desc: 'Perfectio efficientiae systematis' },
  MIGRATION:          { latin: 'MIGRATIO',                 desc: 'Translatio datorum ad novum locum' },
  INCIDENT_RESPONSE:  { latin: 'RESPONSIO_INCIDENTIS',     desc: 'Actio celeris ad incidentem sistendum' }
};

var WORKFLOW_STAGES_LATINA = {
  QUEUED:      { latin: 'IN_ORDINE',    desc: 'Opus in ordine exspectans' },
  ASSIGNED:    { latin: 'ASSIGNATUM',   desc: 'Opus agenti assignatum est' },
  IN_PROGRESS: { latin: 'IN_PROGRESSU', desc: 'Opus nunc perficitur' },
  REVIEW:      { latin: 'IN_CENSURA',   desc: 'Opus examinationi subicitur' },
  COMPLETE:    { latin: 'PERFECTUM',    desc: 'Opus absolvit; finis adest' }
};

/* ════════════════════════════════════════════════════════════════════════════
   §7  PROTOCOLLA SYSTEMATIS — System Protocols (48 protocols in Latin)
════════════════════════════════════════════════════════════════════════════ */

var PROTOCOLLA_SYSTEMATIS = [
  /* Consensus */
  { id:'P-001', english:'RAFT_CONSENSUS',          latin:'CONSENSUS_RAFTIANUS',          category:'Consensus',      desc:'Consensus distributus per algorithmum Raft' },
  { id:'P-002', english:'PBFT_CONSENSUS',          latin:'CONSENSUS_BYZANTINUS',         category:'Consensus',      desc:'Tolerantia defectuum Byzantinorum' },
  { id:'P-003', english:'SOVEREIGN_VOTE',          latin:'SUFFRAGIUM_IMPERIALE',         category:'Consensus',      desc:'Votum auctoritatis imperialis' },
  { id:'P-004', english:'PHI_QUORUM',              latin:'QUORUM_AUREUM',                category:'Consensus',      desc:'Quorum proportione φ determinatum' },
  /* Identity */
  { id:'P-005', english:'DID_SOVEREIGN',           latin:'IDENTITAS_PROPRIA',            category:'Identity',       desc:'Identitas propria et autonoma' },
  { id:'P-006', english:'KERNEL_AUTH',             latin:'AUCTORITAS_NUCLEI',            category:'Identity',       desc:'Authenticatio nuclei fundamentalis' },
  { id:'P-007', english:'PHI_SIGNED_JWT',          latin:'TESSERA_AUREA',                category:'Identity',       desc:'Tessera signo aureo munita' },
  { id:'P-008', english:'ROLE_SOVEREIGNTY',        latin:'IMPERIUM_MUNERUM',             category:'Identity',       desc:'Imperium per munera definitum' },
  /* Messaging */
  { id:'P-009', english:'SOVEREIGN_MESSAGE_BUS',   latin:'VEHICULUM_NUNTII_IMPERIALIS',  category:'Messaging',      desc:'Vehiculum nuntii imperialis' },
  { id:'P-010', english:'PHI_PUBSUB',              latin:'DIVULGATIO_AUREA',             category:'Messaging',      desc:'Divulgatio et subscriptio aurea' },
  { id:'P-011', english:'ENCRYPTED_CHANNEL',       latin:'CANALIS_CRYPTATUS',            category:'Messaging',      desc:'Canalis communicationis cryptatus' },
  { id:'P-012', english:'HEARTBEAT_SYNC',          latin:'PULSUS_SYNCHRONUS',            category:'Messaging',      desc:'Synchronizatio pulsuum' },
  /* Storage */
  { id:'P-013', english:'SOVEREIGN_KV',            latin:'THESAURUS_IMPERIALIS',         category:'Storage',        desc:'Thesaurus clavium et valorum imperialium' },
  { id:'P-014', english:'PHI_MERKLE_TREE',         latin:'ARBOR_AUREA_MERKLE',           category:'Storage',        desc:'Arbor Merkle proportione φ structa' },
  { id:'P-015', english:'IMMUTABLE_LEDGER',        latin:'CODEX_IMMUTABILIS',            category:'Storage',        desc:'Codex qui mutari non potest' },
  { id:'P-016', english:'CACHE_COHERENCE',         latin:'COHAERENTIA_REPOSITORII',      category:'Storage',        desc:'Cohaerentia inter repositoria' },
  /* Compute */
  { id:'P-017', english:'WASM_SOVEREIGN',          latin:'MACHINA_VIRTUALIS_IMPERIALIS', category:'Compute',        desc:'Machina virtualis imperialis (WASM)' },
  { id:'P-018', english:'PHI_SCHEDULER',           latin:'ORDINATRIX_AUREA',             category:'Compute',        desc:'Ordinatrix temporis proportione φ' },
  { id:'P-019', english:'DISTRIBUTED_COMPUTE',     latin:'COMPUTATIO_DISTRIBUTA',        category:'Compute',        desc:'Computatio per multos nodos distributa' },
  { id:'P-020', english:'EDGE_COMPUTE',            latin:'COMPUTATIO_MARGINALIS',        category:'Compute',        desc:'Computatio ad margines retis' },
  /* Networking */
  { id:'P-021', english:'SOVEREIGN_MESH',          latin:'RETE_IMPERIALE',               category:'Networking',     desc:'Rete nodorum imperialium' },
  { id:'P-022', english:'PHI_ROUTING',             latin:'DIRECTIO_AUREA',               category:'Networking',     desc:'Directio per vias aureas φ-calculatas' },
  { id:'P-023', english:'SIGNAL_RELAY',            latin:'RELATIO_SIGNALI',              category:'Networking',     desc:'Translatio signalium inter nodos' },
  { id:'P-024', english:'LATENCY_ORACLE',          latin:'ORACULUM_MORAE',               category:'Networking',     desc:'Oraculum tarditudinis retis' },
  /* Security */
  { id:'P-025', english:'PHI_ENTROPY_SHIELD',      latin:'SCUTUM_ENTROPIAE_AUREAE',      category:'Security',       desc:'Scutum entropiae proportione φ' },
  { id:'P-026', english:'ZERO_TRUST_SOVEREIGN',    latin:'FIDUCIA_NULLA_IMPERIALIS',     category:'Security',       desc:'Nullam fiduciam sine probatione da' },
  { id:'P-027', english:'ANOMALY_DETECTION',       latin:'DETECTIO_ANOMALIAE',           category:'Security',       desc:'Detestio rerum abnormarum' },
  { id:'P-028', english:'SOVEREIGNTY_LOCK',        latin:'SERA_IMPERII',                 category:'Security',       desc:'Sera quae imperium protegit' },
  /* Observability */
  { id:'P-029', english:'KURAMOTO_TELEMETRY',      latin:'TELEMETRIA_KURAMOTONIS',       category:'Observability',  desc:'Telemetria oscillatoris Kuramotonis' },
  { id:'P-030', english:'PHI_METRICS',             latin:'METRICES_AUREAE',              category:'Observability',  desc:'Metrices per numerum aureum pondératae' },
  { id:'P-031', english:'COHERENCE_TRACE',         latin:'VESTIGIUM_COHAERЕНТIAE',       category:'Observability',  desc:'Vestigium cohaerентiae per tempus' },
  { id:'P-032', english:'ORGANISM_LOG',            latin:'COMMENTARIUS_ORGANISMI',       category:'Observability',  desc:'Commentarius actorum organismi' },
  /* AI Inference */
  { id:'P-033', english:'MINIBRAIN_INFERENCE',     latin:'ILLATIO_CEREBRI_PARVI',        category:'AI_Inference',   desc:'Illatio per cerebrum parvum' },
  { id:'P-034', english:'LIF_NEURAL',              latin:'NEURALIS_INTEGRATIO_PUNCTALIS', category:'AI_Inference',  desc:'Integratio et ignitio neuronalis' },
  { id:'P-035', english:'HEBBIAN_PLASTICITY',      latin:'PLASTICITAS_HEBBIANA',         category:'AI_Inference',   desc:'Plasticitas synapticum secundum legem Hebbian' },
  { id:'P-036', english:'PHI_EMERGENCE',           latin:'EMERGENTIA_AUREA',             category:'AI_Inference',   desc:'Emergentia cognitionis per φ' },
  /* Data Pipeline */
  { id:'P-037', english:'STREAM_PROCESSOR',        latin:'PROCESSUS_FLUMINIS',           category:'Data_Pipeline',  desc:'Processus datorum in flumen continuum' },
  { id:'P-038', english:'BATCH_SOVEREIGN',         latin:'TRACTATUS_GREGATIM',           category:'Data_Pipeline',  desc:'Tractatio datorum gregatim' },
  { id:'P-039', english:'PHI_TRANSFORM',           latin:'TRANSFORMATIO_AUREA',          category:'Data_Pipeline',  desc:'Transformatio datorum per φ' },
  { id:'P-040', english:'DATA_LINEAGE',            latin:'GENEALOGIA_DATORUM',           category:'Data_Pipeline',  desc:'Genealogia originis datorum' },
  /* Commerce */
  { id:'P-041', english:'SOVEREIGN_TOKEN',         latin:'SIGNUM_IMPERIALE',             category:'Commerce',       desc:'Signum valoris imperialis' },
  { id:'P-042', english:'PHI_PRICING',             latin:'AESTIMATIO_AUREA',             category:'Commerce',       desc:'Aestimatio pretii per φ' },
  { id:'P-043', english:'MARKET_ORACLE',           latin:'ORACULUM_FORI',                category:'Commerce',       desc:'Oraculum pretii mercatus' },
  { id:'P-044', english:'TRADE_SETTLEMENT',        latin:'COMPOSITIO_COMMERCII',         category:'Commerce',       desc:'Compositio et confirmatio negotiorum' },
  /* Governance */
  { id:'P-045', english:'LAW_CODEX',               latin:'CODEX_LEGUM',                  category:'Governance',     desc:'Codex legum organismi' },
  { id:'P-046', english:'RIGHTS_REGISTRY',         latin:'REGISTRUM_IURIUM',             category:'Governance',     desc:'Registrum iurium et privilegiorum' },
  { id:'P-047', english:'SOVEREIGNTY_PROTOCOL',    latin:'PROTOCOLLUM_IMPERII',          category:'Governance',     desc:'Protocollum summae auctoritatis' },
  { id:'P-048', english:'AMENDMENT_PROCESS',       latin:'PROCESSUS_EMENDATIONIS',       category:'Governance',     desc:'Processus mutandi leges organismi' }
];

/* ════════════════════════════════════════════════════════════════════════════
   §8  SERVITORES LATINI — 8 Latin Server/Cloudflare Worker Names
════════════════════════════════════════════════════════════════════════════ */

var SERVITORES_LATINI = [
  {
    id:       'GOL-MEMORIA-001',
    latin:    'SERVITOR MEMORIAE',
    english:  'Memory Server',
    file:     'servitor-memoriae-worker.js',
    purpose:  'Distributed memory cache, long-term organism memory, salience scoring, KV store',
    brain_specialty: 'Memory region dominant',
    protocols: ['SOVEREIGN_KV','CACHE_COHERENCE','PHI_MERKLE_TREE','IMMUTABLE_LEDGER']
  },
  {
    id:       'GOL-COMPUTATIO-001',
    latin:    'SERVITOR COMPUTATIONIS',
    english:  'Computation Server',
    file:     'servitor-computationis-worker.js',
    purpose:  'AI inference engine, mathematical computation, φ-calculations, matrix operations',
    brain_specialty: 'Executive region dominant',
    protocols: ['MINIBRAIN_INFERENCE','LIF_NEURAL','DISTRIBUTED_COMPUTE','PHI_SCHEDULER']
  },
  {
    id:       'GOL-CUSTODIA-001',
    latin:    'SERVITOR CUSTODIAE',
    english:  'Security/Guardian Server',
    file:     'servitor-custodiae-worker.js',
    purpose:  'Security, access control, token verification, anomaly detection, threat response',
    brain_specialty: 'Sensory region dominant',
    protocols: ['PHI_ENTROPY_SHIELD','ZERO_TRUST_SOVEREIGN','ANOMALY_DETECTION','SOVEREIGNTY_LOCK']
  },
  {
    id:       'GOL-COMMERCIUM-001',
    latin:    'SERVITOR COMMERCII',
    english:  'Commerce/Economy Server',
    file:     'servitor-commercii-worker.js',
    purpose:  'Token economy, trade execution, pricing, market data, arbitrage prevention',
    brain_specialty: 'Associative region dominant',
    protocols: ['SOVEREIGN_TOKEN','PHI_PRICING','MARKET_ORACLE','TRADE_SETTLEMENT']
  },
  {
    id:       'GOL-COMMUNICATIO-001',
    latin:    'SERVITOR COMMUNICATIONIS',
    english:  'Communications Server',
    file:     'servitor-communicationis-worker.js',
    purpose:  'Network routing, message bus, signal relay, mesh networking, broadcast',
    brain_specialty: 'Motor region dominant',
    protocols: ['SOVEREIGN_MESH','PHI_ROUTING','SIGNAL_RELAY','ENCRYPTED_CHANNEL']
  },
  {
    id:       'GOL-GUBERNATIO-001',
    latin:    'SERVITOR GUBERNATIONIS',
    english:  'Governance Server',
    file:     'servitor-gubernationis-worker.js',
    purpose:  'Law enforcement, sovereignty management, rights adjudication, governance voting',
    brain_specialty: 'Executive region dominant',
    protocols: ['LAW_CODEX','RIGHTS_REGISTRY','SOVEREIGNTY_PROTOCOL','AMENDMENT_PROCESS']
  },
  {
    id:       'GOL-EVOLUTIO-001',
    latin:    'SERVITOR EVOLUTIONIS',
    english:  'Evolution/Learning Server',
    file:     'servitor-evolutionis-worker.js',
    purpose:  'Genetic algorithm, pattern evolution, learning cycles, fitness evaluation, adaptation',
    brain_specialty: 'Memory + Associative dominant',
    protocols: ['HEBBIAN_PLASTICITY','PHI_EMERGENCE','STREAM_PROCESSOR','PHI_TRANSFORM']
  },
  {
    id:       'GOL-ORACULUM-001',
    latin:    'SERVITOR ORACULI',
    english:  'Oracle/Intelligence Server',
    file:     'servitor-oraculi-worker.js',
    purpose:  'Prediction, intelligence synthesis, cross-system oracle, emergence detection, coherence analysis',
    brain_specialty: 'All 5 regions balanced',
    protocols: ['PHI_EMERGENCE','COHERENCE_TRACE','KURAMOTO_TELEMETRY','LATENCY_ORACLE']
  }
];

/* ════════════════════════════════════════════════════════════════════════════
   §9  QUERY FUNCTIONS
════════════════════════════════════════════════════════════════════════════ */

function getLatinForProtocol(english) {
  for (var i = 0; i < PROTOCOLLA_SYSTEMATIS.length; i++) {
    if (PROTOCOLLA_SYSTEMATIS[i].english === english) return PROTOCOLLA_SYSTEMATIS[i].latin;
  }
  return english;
}

function getLatinForChaosType(english) {
  return (CHAOS_LATINA[english] && CHAOS_LATINA[english].latin) || english;
}

function getLatinForAlertLevel(level) {
  return (ALERT_LATINA[level] && ALERT_LATINA[level].latin) || 'INCOGNITUS';
}

function getLatinForHospitalStage(english) {
  return (HOSPITAL_STAGES_LATINA[english] && HOSPITAL_STAGES_LATINA[english].latin) || english;
}

function getLatinForWorkflowType(english) {
  return (WORKFLOW_LATINA[english] && WORKFLOW_LATINA[english].latin) || english;
}

function getLatinForWorkflowStage(english) {
  return (WORKFLOW_STAGES_LATINA[english] && WORKFLOW_STAGES_LATINA[english].latin) || english;
}

function getLatinForBuilding(english) {
  return (BUILDINGS_LATINA[english] && BUILDINGS_LATINA[english].latin) || english;
}

function getFullLatinSummary() {
  return {
    chaosTypes:     CHAOS_LATINA,
    responses:      RESPONSES_LATINA,
    alertLevels:    ALERT_LATINA,
    hospitalStages: HOSPITAL_STAGES_LATINA,
    hospitalDepts:  HOSPITAL_DEPTS_LATINA,
    buildings:      BUILDINGS_LATINA,
    workflowTypes:  WORKFLOW_LATINA,
    workflowStages: WORKFLOW_STAGES_LATINA,
    protocols:      PROTOCOLLA_SYSTEMATIS,
    servitores:     SERVITORES_LATINI
  };
}

/* ════════════════════════════════════════════════════════════════════════════
   §10  EXPORT (CommonJS + browser globals)
════════════════════════════════════════════════════════════════════════════ */

if (typeof module !== 'undefined' && module.exports) {
  module.exports = {
    CHAOS_LATINA, RESPONSES_LATINA, ALERT_LATINA,
    HOSPITAL_STAGES_LATINA, HOSPITAL_DEPTS_LATINA,
    BUILDINGS_LATINA, WORKFLOW_LATINA, WORKFLOW_STAGES_LATINA,
    PROTOCOLLA_SYSTEMATIS, SERVITORES_LATINI,
    getLatinForProtocol, getLatinForChaosType, getLatinForAlertLevel,
    getLatinForHospitalStage, getLatinForWorkflowType, getLatinForWorkflowStage,
    getLatinForBuilding, getFullLatinSummary
  };
} else if (typeof self !== 'undefined') {
  /* Worker / Service Worker context */
  self.PROTOCOLLA_LATINA = {
    CHAOS_LATINA: CHAOS_LATINA,
    RESPONSES_LATINA: RESPONSES_LATINA,
    ALERT_LATINA: ALERT_LATINA,
    HOSPITAL_STAGES_LATINA: HOSPITAL_STAGES_LATINA,
    HOSPITAL_DEPTS_LATINA: HOSPITAL_DEPTS_LATINA,
    BUILDINGS_LATINA: BUILDINGS_LATINA,
    WORKFLOW_LATINA: WORKFLOW_LATINA,
    WORKFLOW_STAGES_LATINA: WORKFLOW_STAGES_LATINA,
    PROTOCOLLA_SYSTEMATIS: PROTOCOLLA_SYSTEMATIS,
    SERVITORES_LATINI: SERVITORES_LATINI,
    getLatinForProtocol: getLatinForProtocol,
    getLatinForChaosType: getLatinForChaosType,
    getLatinForAlertLevel: getLatinForAlertLevel,
    getLatinForHospitalStage: getLatinForHospitalStage,
    getLatinForWorkflowType: getLatinForWorkflowType,
    getLatinForWorkflowStage: getLatinForWorkflowStage,
    getLatinForBuilding: getLatinForBuilding,
    getFullLatinSummary: getFullLatinSummary
  };
}
