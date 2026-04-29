// ═══════════════════════════════════════════════════════════════════════════════
// NOVA × DALLAS ISD — DIGITAL CLASSROOM VIEW
// ═══════════════════════════════════════════════════════════════════════════════
//
// CPL protocol view for Dallas ISD Digital Classrooms.
// Covers ALL curriculum areas: Math, Science, Social Studies, ELA, CS.
//
// NO TRADE SECRETS EXPOSED. No φ-formula engines. No Kuramoto code.
// This view provides TEKS-aligned lesson plans, activities, concept
// explanations, PWA SDK info, and grant-funding documentation.
//
// FREE for all Dallas ISD & Dallas County public schools.
// No fees. No data collection. No subscriptions.
// Powered by NOVA — Medina Tech, Dallas TX.
//
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// ═══════════════════════════════════════════════════════════════════════════════

import React, { useState } from 'react';
import {
  DIGITAL_CLASSROOM_CONSTANTS,
  getAllTEKSMappings,
  getTEKSBySubject,
  explainConcept,
  getSubjectAreas,
  getLessonCounts,
  getDigitalClassroomPWAConfig,
  getGrantFundingInfo,
} from './DigitalClassroomAdapters';
import type { SubjectArea, TEKSMapping } from './DigitalClassroomAdapters';

// ─── §1  LESSON PANEL ──────────────────────────────────────────────────────────

function LessonPanel({ mapping }: { mapping: TEKSMapping }) {
  const [expanded, setExpanded] = useState(false);
  const subjectColors: Record<SubjectArea, string> = {
    MATH: '#c8a84e',
    SCIENCE: '#4ecdc4',
    SOCIAL_STUDIES: '#ff6b6b',
    ELA: '#a78bfa',
    COMPUTER_SCIENCE: '#34d399',
  };
  const color = subjectColors[mapping.subject];

  return (
    <div style={{
      border: `1px solid ${color}`,
      borderRadius: 8,
      padding: 12,
      marginBottom: 8,
      background: '#111',
      cursor: 'pointer',
    }} onClick={() => setExpanded(!expanded)}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <div>
          <span style={{ color, fontFamily: 'monospace', fontWeight: 'bold' }}>
            {mapping.concept}
          </span>
          <span style={{ color: '#888', fontFamily: 'monospace', fontSize: 11, marginLeft: 8 }}>
            {mapping.teksGrade}
          </span>
        </div>
        <span style={{ color: '#888', fontFamily: 'monospace' }}>{expanded ? '▼' : '▶'}</span>
      </div>

      {expanded && (
        <div style={{ marginTop: 12, fontFamily: 'monospace', fontSize: 12 }}>
          <div style={{ marginBottom: 8 }}>
            <span style={{ color: '#888' }}>TEKS: </span>
            <span style={{ color: '#e0e0e0' }}>{mapping.teksStandard} — {mapping.teksDescription}</span>
          </div>
          <div style={{ marginBottom: 8, background: '#0a0a0a', padding: 8, borderRadius: 4 }}>
            <div style={{ color }}>ACTIVITY:</div>
            <div style={{ color: '#e0e0e0', marginTop: 4 }}>{mapping.classroomActivity}</div>
          </div>
          <div style={{ display: 'flex', gap: 16 }}>
            <div>
              <span style={{ color: '#888' }}>Materials: </span>
              <span style={{ color: '#e0e0e0' }}>{mapping.materialsNeeded}</span>
            </div>
            <div>
              <span style={{ color: '#888' }}>Duration: </span>
              <span style={{ color: '#e0e0e0' }}>{mapping.duration}</span>
            </div>
          </div>
          <div style={{ marginTop: 8 }}>
            <span style={{ color: '#888' }}>Grant Alignment: </span>
            {mapping.grantAlignment.map((g, i) => (
              <span key={i} style={{
                background: '#1a1a1a',
                color: '#34d399',
                padding: '2px 6px',
                borderRadius: 3,
                fontSize: 10,
                marginRight: 4,
              }}>
                {g}
              </span>
            ))}
          </div>
        </div>
      )}
    </div>
  );
}

// ─── §2  SUBJECT BROWSER ────────────────────────────────────────────────────────

function SubjectBrowser() {
  const subjects = getSubjectAreas();
  const counts = getLessonCounts();
  const [selected, setSelected] = useState<SubjectArea>('MATH');
  const lessons = getTEKSBySubject(selected);

  return (
    <div style={{ marginBottom: 24 }}>
      <h2 style={{ fontFamily: 'monospace', color: '#c8a84e', marginBottom: 12 }}>
        § DIGITAL CLASSROOM — TEKS Curriculum
      </h2>

      <div style={{ display: 'flex', gap: 8, marginBottom: 16, flexWrap: 'wrap' }}>
        {subjects.map(s => (
          <button
            key={s.id}
            onClick={() => setSelected(s.id)}
            style={{
              padding: '8px 16px',
              fontFamily: 'monospace',
              fontSize: 12,
              background: selected === s.id ? s.color : '#1a1a1a',
              color: selected === s.id ? '#000' : '#888',
              border: `1px solid ${s.color}`,
              borderRadius: 4,
              cursor: 'pointer',
            }}
          >
            {s.icon} {s.label} ({counts[s.id]})
          </button>
        ))}
      </div>

      {lessons.map((m, i) => (
        <LessonPanel key={i} mapping={m} />
      ))}
    </div>
  );
}

// ─── §3  CONCEPT EXPLORER ───────────────────────────────────────────────────────

function ConceptExplorer() {
  const [concept, setConcept] = useState('fibonacci');
  const explanation = explainConcept(concept);
  const concepts = [
    { value: 'fibonacci', label: 'Fibonacci Sequence' },
    { value: 'golden', label: 'Golden Ratio' },
    { value: 'heartbeat', label: '873ms Heartbeat' },
    { value: 'schumann', label: 'Schumann Resonance' },
    { value: 'platonic', label: 'Platonic Solids' },
    { value: 'emergence', label: 'Emergence' },
    { value: 'quipu', label: 'Quipu (Inca IT)' },
    { value: 'network', label: 'Network Effects' },
    { value: 'recursion', label: 'Recursion' },
    { value: 'pwa', label: 'Progressive Web Apps' },
    { value: 'sovereignty', label: 'Digital Sovereignty' },
  ];

  return (
    <div style={{ marginBottom: 24 }}>
      <h2 style={{ fontFamily: 'monospace', color: '#4ecdc4', marginBottom: 12 }}>
        § CONCEPT EXPLORER — Student Reference
      </h2>

      <div style={{ display: 'flex', flexWrap: 'wrap', gap: 6, marginBottom: 12 }}>
        {concepts.map(c => (
          <button
            key={c.value}
            onClick={() => setConcept(c.value)}
            style={{
              padding: '4px 10px',
              fontFamily: 'monospace',
              fontSize: 11,
              background: concept === c.value ? '#4ecdc4' : '#1a1a1a',
              color: concept === c.value ? '#000' : '#888',
              border: '1px solid #333',
              borderRadius: 3,
              cursor: 'pointer',
            }}
          >
            {c.label}
          </button>
        ))}
      </div>

      <div style={{
        fontFamily: 'monospace',
        fontSize: 13,
        background: '#111',
        padding: 16,
        borderRadius: 8,
        border: '1px solid #4ecdc4',
        color: '#e0e0e0',
        lineHeight: 1.6,
      }}>
        {explanation}
      </div>
    </div>
  );
}

// ─── §4  PWA SDK PANEL ──────────────────────────────────────────────────────────

function PWASDKPanel() {
  const config = getDigitalClassroomPWAConfig();

  return (
    <div style={{ marginBottom: 24 }}>
      <h2 style={{ fontFamily: 'monospace', color: '#34d399', marginBottom: 12 }}>
        § PWA SDK — Download &amp; Deploy
      </h2>

      <div style={{
        fontFamily: 'monospace',
        fontSize: 12,
        background: '#111',
        padding: 16,
        borderRadius: 8,
        border: '1px solid #34d399',
      }}>
        <div style={{ marginBottom: 12, color: '#34d399', fontSize: 14 }}>
          Progressive Web App — Offline-Capable Classroom Deployment
        </div>

        <div style={{ color: '#e0e0e0', marginBottom: 12 }}>
          Deploy NOVA Digital Classroom as a Progressive Web App on school
          devices. Works offline. No internet required after initial install.
          No student data collected. No app store required.
        </div>

        <table style={{ borderCollapse: 'collapse', width: '100%', marginBottom: 12 }}>
          <tbody>
            {Object.entries({
              'App Name': config.name,
              'Display': config.display,
              'Offline': config.offlineCapable ? 'YES — full offline support' : 'No',
              'Data Collection': config.dataCollection,
              'Orientation': config.orientation,
              'Cost': 'FREE — no fees, no subscriptions',
            }).map(([k, v]) => (
              <tr key={k}>
                <td style={{ border: '1px solid #333', padding: 6, color: '#888' }}>{k}</td>
                <td style={{ border: '1px solid #333', padding: 6, color: '#e0e0e0' }}>{String(v)}</td>
              </tr>
            ))}
          </tbody>
        </table>

        <div style={{ color: '#888', fontSize: 11 }}>
          To deploy: Contact Medina Tech (MedinaSITech@outlook.com) for the
          PWA package. Include your school name, district, and number of devices.
          Installation takes 5 minutes per device.
        </div>
      </div>
    </div>
  );
}

// ─── §5  GRANT FUNDING PANEL ────────────────────────────────────────────────────

function GrantFundingPanel() {
  const grants = getGrantFundingInfo();

  return (
    <div style={{ marginBottom: 24 }}>
      <h2 style={{ fontFamily: 'monospace', color: '#ff6b6b', marginBottom: 12 }}>
        § GRANT FUNDING — Eligibility &amp; Guidance
      </h2>

      <div style={{ fontFamily: 'monospace', fontSize: 12, color: '#888', marginBottom: 12 }}>
        The NOVA Digital Classroom Adapters are designed to qualify for multiple
        federal and state education technology grants. Use the information below
        in your grant applications.
      </div>

      {grants.map((g, i) => (
        <div key={i} style={{
          background: '#111',
          border: '1px solid #333',
          borderRadius: 8,
          padding: 12,
          marginBottom: 8,
          fontFamily: 'monospace',
          fontSize: 12,
        }}>
          <div style={{ color: '#ff6b6b', fontSize: 13, marginBottom: 6 }}>
            {g.grantName}
            <span style={{
              background: '#1a1a1a',
              color: '#888',
              padding: '2px 6px',
              borderRadius: 3,
              fontSize: 10,
              marginLeft: 8,
            }}>
              {g.federalOrState}
            </span>
          </div>
          <div style={{ color: '#888', marginBottom: 4 }}>
            <strong>Eligibility:</strong> {g.eligibility}
          </div>
          <div style={{ color: '#888', marginBottom: 4 }}>
            <strong>How to Apply:</strong> {g.howToApply}
          </div>
          <div style={{ color: '#34d399' }}>
            <strong>NOVA Alignment:</strong> {g.novaAlignment}
          </div>
        </div>
      ))}
    </div>
  );
}

// ─── §6  MAIN DIGITAL CLASSROOM VIEW ────────────────────────────────────────────

type ClassroomView = 'CURRICULUM' | 'CONCEPTS' | 'PWA_SDK' | 'GRANTS';

export default function DigitalClassroom() {
  const [view, setView] = useState<ClassroomView>('CURRICULUM');

  const tabs: Array<{ id: ClassroomView; label: string; color: string }> = [
    { id: 'CURRICULUM', label: '§ Curriculum',       color: '#c8a84e' },
    { id: 'CONCEPTS',   label: '§ Concepts',         color: '#4ecdc4' },
    { id: 'PWA_SDK',    label: '§ PWA SDK',           color: '#34d399' },
    { id: 'GRANTS',     label: '§ Grant Funding',     color: '#ff6b6b' },
  ];

  return (
    <div style={{ maxWidth: 960, margin: '0 auto', padding: 24, color: '#e0e0e0', background: '#0a0a0a' }}>
      <div style={{ textAlign: 'center', marginBottom: 24 }}>
        <h1 style={{ fontFamily: 'monospace', color: '#c8a84e', fontSize: 28 }}>
          NOVA × DALLAS ISD
        </h1>
        <p style={{ fontFamily: 'monospace', color: '#888', fontSize: 14 }}>
          Free Digital Classroom Adapters for Public Schools
        </p>
        <p style={{ fontFamily: 'monospace', fontSize: 12, color: '#555' }}>
          Math · Science · Social Studies · ELA · Computer Science
        </p>
        <p style={{ fontFamily: 'monospace', fontSize: 11, color: '#444' }}>
          {DIGITAL_CLASSROOM_CONSTANTS.ATTRIBUTION} | {DIGITAL_CLASSROOM_CONSTANTS.LICENSE}
        </p>
      </div>

      <div style={{ display: 'flex', gap: 8, marginBottom: 20, justifyContent: 'center', flexWrap: 'wrap' }}>
        {tabs.map(t => (
          <button
            key={t.id}
            onClick={() => setView(t.id)}
            style={{
              padding: '8px 20px',
              fontFamily: 'monospace',
              background: view === t.id ? t.color : '#1a1a1a',
              color: view === t.id ? '#000' : '#888',
              border: `1px solid ${t.color}`,
              borderRadius: 4,
              cursor: 'pointer',
            }}
          >
            {t.label}
          </button>
        ))}
      </div>

      {view === 'CURRICULUM' && <SubjectBrowser />}
      {view === 'CONCEPTS' && <ConceptExplorer />}
      {view === 'PWA_SDK' && <PWASDKPanel />}
      {view === 'GRANTS' && <GrantFundingPanel />}

      <div style={{ textAlign: 'center', marginTop: 32, fontFamily: 'monospace', fontSize: 11, color: '#444' }}>
        <div>NOVA Digital Classroom v{DIGITAL_CLASSROOM_CONSTANTS.VERSION} — All Subjects, All Grades</div>
        <div>No data collection · No fees · No subscriptions</div>
        <div>COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.</div>
      </div>
    </div>
  );
}
