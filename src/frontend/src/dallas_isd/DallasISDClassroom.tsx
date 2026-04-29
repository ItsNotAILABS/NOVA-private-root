// ═══════════════════════════════════════════════════════════════════════════════
// NOVA × DALLAS ISD — CLASSROOM VIEW
// ═══════════════════════════════════════════════════════════════════════════════
//
// CPL protocol view for Dallas ISD public school classrooms.
// Renders the three free adapters: Phi Explorer, Kuramoto Lab, TEKS Bridge.
//
// FREE for all Dallas ISD public schools.
// No fees. No data collection. No subscriptions.
// Powered by NOVA — Medina Tech, Dallas TX.
//
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// ═══════════════════════════════════════════════════════════════════════════════

import React, { useState, useEffect, useCallback } from 'react';
import {
  DALLAS_ISD_CONSTANTS,
  createPhiExplorer,
  fibonacciRatio,
  phiPowerTable,
  createKuramotoClassroom,
  kuramotoStep,
  getTEKSMappings,
  explainConcept,
} from './DallasISDAdapters';
import type { KuramotoClassroomState, PhiExplorerState, TEKSMapping } from './DallasISDAdapters';

// ─── §1  PHI EXPLORER PANEL ─────────────────────────────────────────────────────

function PhiExplorerPanel() {
  const [fibIndex, setFibIndex] = useState(6);
  const ratio = fibonacciRatio(fibIndex);
  const table = phiPowerTable();

  return (
    <div style={{ padding: 16, border: '2px solid #c8a84e', borderRadius: 8, marginBottom: 16 }}>
      <h3 style={{ color: '#c8a84e', fontFamily: 'monospace' }}>§ PHI EXPLORER — Golden Ratio</h3>
      <p style={{ fontFamily: 'monospace' }}>
        φ = {DALLAS_ISD_CONSTANTS.PHI}
      </p>

      <div style={{ marginBottom: 12 }}>
        <label style={{ fontFamily: 'monospace' }}>Fibonacci index (n): </label>
        <input
          type="range"
          min={2}
          max={19}
          value={fibIndex}
          onChange={e => setFibIndex(Number(e.target.value))}
          style={{ width: 200 }}
        />
        <span style={{ fontFamily: 'monospace', marginLeft: 8 }}>n = {fibIndex}</span>
      </div>

      <div style={{ fontFamily: 'monospace', background: '#1a1a1a', padding: 12, borderRadius: 4 }}>
        <div>F({fibIndex}) = {ratio.a}</div>
        <div>F({fibIndex - 1}) = {ratio.b}</div>
        <div>F({fibIndex}) / F({fibIndex - 1}) = {ratio.ratio.toFixed(15)}</div>
        <div style={{ color: '#4ecdc4' }}>Error from φ: {ratio.error.toExponential(6)}</div>
        <div style={{ color: '#888', marginTop: 4 }}>
          As n → ∞, the ratio converges to φ = {DALLAS_ISD_CONSTANTS.PHI}
        </div>
      </div>

      <h4 style={{ color: '#c8a84e', fontFamily: 'monospace', marginTop: 16 }}>φ-Power Table</h4>
      <table style={{ fontFamily: 'monospace', fontSize: 12, borderCollapse: 'collapse' }}>
        <thead>
          <tr>
            <th style={{ border: '1px solid #444', padding: 4 }}>Power</th>
            <th style={{ border: '1px solid #444', padding: 4 }}>Value</th>
            <th style={{ border: '1px solid #444', padding: 4 }}>Meaning</th>
          </tr>
        </thead>
        <tbody>
          {table.map(row => (
            <tr key={row.power}>
              <td style={{ border: '1px solid #444', padding: 4 }}>φ^{row.power}</td>
              <td style={{ border: '1px solid #444', padding: 4 }}>{row.value.toFixed(10)}</td>
              <td style={{ border: '1px solid #444', padding: 4 }}>{row.label}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}

// ─── §2  KURAMOTO CLASSROOM PANEL ───────────────────────────────────────────────

function KuramotoPanel() {
  const [state, setState] = useState<KuramotoClassroomState>(() => createKuramotoClassroom(8));
  const [running, setRunning] = useState(false);

  useEffect(() => {
    if (!running) return;
    const interval = setInterval(() => {
      setState(prev => kuramotoStep(prev, 0.05));
    }, 50);
    return () => clearInterval(interval);
  }, [running]);

  const resetSim = useCallback(() => {
    setState(createKuramotoClassroom(8));
    setRunning(false);
  }, []);

  return (
    <div style={{ padding: 16, border: '2px solid #4ecdc4', borderRadius: 8, marginBottom: 16 }}>
      <h3 style={{ color: '#4ecdc4', fontFamily: 'monospace' }}>§ KURAMOTO LAB — Synchronization</h3>

      <div style={{ marginBottom: 8 }}>
        <button onClick={() => setRunning(!running)} style={{ marginRight: 8, padding: '4px 12px' }}>
          {running ? 'PAUSE' : 'START'}
        </button>
        <button onClick={resetSim} style={{ padding: '4px 12px' }}>RESET</button>
        <span style={{ fontFamily: 'monospace', marginLeft: 16 }}>
          K = {state.coupling.toFixed(2)}
        </span>
        <input
          type="range"
          min={0}
          max={3}
          step={0.1}
          value={state.coupling}
          onChange={e => setState(prev => ({ ...prev, coupling: Number(e.target.value) }))}
          style={{ marginLeft: 8, width: 150 }}
        />
      </div>

      <div style={{ fontFamily: 'monospace', background: '#1a1a1a', padding: 12, borderRadius: 4 }}>
        <div style={{ fontSize: 24, color: state.orderParameter > 0.8 ? '#4ecdc4' : '#ff6b6b' }}>
          r = {state.orderParameter.toFixed(4)}
        </div>
        <div style={{ color: '#888' }}>
          Synchronization: {state.orderParameter > 0.8 ? 'LOCKED' : state.orderParameter > 0.4 ? 'PARTIAL' : 'DESYNC'}
        </div>
        <div style={{ color: '#888' }}>t = {state.time.toFixed(2)}s</div>
      </div>

      <div style={{ display: 'flex', flexWrap: 'wrap', gap: 8, marginTop: 12 }}>
        {state.oscillators.map(osc => (
          <div key={osc.id} style={{
            width: 60, height: 60, borderRadius: '50%',
            border: '2px solid #4ecdc4',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            fontFamily: 'monospace', fontSize: 10,
            transform: `rotate(${osc.phase * 180 / Math.PI}deg)`,
          }}>
            <div style={{ transform: `rotate(${-osc.phase * 180 / Math.PI}deg)` }}>
              {osc.id + 1}
            </div>
          </div>
        ))}
      </div>

      <p style={{ fontFamily: 'monospace', fontSize: 12, color: '#888', marginTop: 8 }}>
        Increase coupling K to watch oscillators synchronize — the same math that
        synchronizes NOVA&apos;s 70+ sovereign workers at 873ms.
      </p>
    </div>
  );
}

// ─── §3  TEKS BRIDGE PANEL ──────────────────────────────────────────────────────

function TEKSBridgePanel() {
  const [selectedConcept, setSelectedConcept] = useState('phi');
  const mappings = getTEKSMappings();
  const explanation = explainConcept(selectedConcept);

  return (
    <div style={{ padding: 16, border: '2px solid #ff6b6b', borderRadius: 8, marginBottom: 16 }}>
      <h3 style={{ color: '#ff6b6b', fontFamily: 'monospace' }}>§ TEKS BRIDGE — Curriculum Mapping</h3>

      <div style={{ marginBottom: 12 }}>
        <label style={{ fontFamily: 'monospace' }}>Explore concept: </label>
        <select
          value={selectedConcept}
          onChange={e => setSelectedConcept(e.target.value)}
          style={{ fontFamily: 'monospace', padding: 4 }}
        >
          <option value="phi">Golden Ratio (φ)</option>
          <option value="fibonacci">Fibonacci Sequence</option>
          <option value="kuramoto">Kuramoto Oscillators</option>
          <option value="heartbeat">873ms Heartbeat</option>
          <option value="feigenbaum">Feigenbaum Constant</option>
          <option value="schumann">Schumann Resonance</option>
        </select>
      </div>

      <div style={{ fontFamily: 'monospace', background: '#1a1a1a', padding: 12, borderRadius: 4, marginBottom: 12 }}>
        {explanation}
      </div>

      <h4 style={{ fontFamily: 'monospace', color: '#ff6b6b' }}>NOVA ↔ TEKS Standards</h4>
      <table style={{ fontFamily: 'monospace', fontSize: 11, borderCollapse: 'collapse', width: '100%' }}>
        <thead>
          <tr>
            <th style={{ border: '1px solid #444', padding: 4, textAlign: 'left' }}>NOVA Module</th>
            <th style={{ border: '1px solid #444', padding: 4, textAlign: 'left' }}>Concept</th>
            <th style={{ border: '1px solid #444', padding: 4, textAlign: 'left' }}>Grade</th>
            <th style={{ border: '1px solid #444', padding: 4, textAlign: 'left' }}>TEKS</th>
            <th style={{ border: '1px solid #444', padding: 4, textAlign: 'left' }}>Activity</th>
          </tr>
        </thead>
        <tbody>
          {mappings.map((m, i) => (
            <tr key={i}>
              <td style={{ border: '1px solid #444', padding: 4 }}>{m.novaModule}</td>
              <td style={{ border: '1px solid #444', padding: 4 }}>{m.novaConcept}</td>
              <td style={{ border: '1px solid #444', padding: 4 }}>{m.teksGrade}</td>
              <td style={{ border: '1px solid #444', padding: 4 }}>{m.teksStandard}</td>
              <td style={{ border: '1px solid #444', padding: 4, fontSize: 10 }}>{m.classroomActivity}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}

// ─── §4  MAIN CLASSROOM VIEW ────────────────────────────────────────────────────

type AdapterView = 'PHI' | 'KURAMOTO' | 'TEKS';

export default function DallasISDClassroom() {
  const [view, setView] = useState<AdapterView>('PHI');

  return (
    <div style={{ maxWidth: 900, margin: '0 auto', padding: 24, color: '#e0e0e0', background: '#0a0a0a' }}>
      <div style={{ textAlign: 'center', marginBottom: 24 }}>
        <h1 style={{ fontFamily: 'monospace', color: '#c8a84e', fontSize: 28 }}>
          NOVA × DALLAS ISD
        </h1>
        <p style={{ fontFamily: 'monospace', color: '#888' }}>
          Free Sovereign Mathematics Adapters for Public Schools
        </p>
        <p style={{ fontFamily: 'monospace', fontSize: 11, color: '#555' }}>
          {DALLAS_ISD_CONSTANTS.ATTRIBUTION} | {DALLAS_ISD_CONSTANTS.LICENSE}
        </p>
      </div>

      <div style={{ display: 'flex', gap: 8, marginBottom: 16, justifyContent: 'center' }}>
        {(['PHI', 'KURAMOTO', 'TEKS'] as AdapterView[]).map(v => (
          <button
            key={v}
            onClick={() => setView(v)}
            style={{
              padding: '8px 20px',
              fontFamily: 'monospace',
              background: view === v ? '#c8a84e' : '#1a1a1a',
              color: view === v ? '#000' : '#888',
              border: '1px solid #444',
              borderRadius: 4,
              cursor: 'pointer',
            }}
          >
            {v === 'PHI' ? '§ Phi Explorer' : v === 'KURAMOTO' ? '§ Kuramoto Lab' : '§ TEKS Bridge'}
          </button>
        ))}
      </div>

      {view === 'PHI' && <PhiExplorerPanel />}
      {view === 'KURAMOTO' && <KuramotoPanel />}
      {view === 'TEKS' && <TEKSBridgePanel />}

      <div style={{ textAlign: 'center', marginTop: 24, fontFamily: 'monospace', fontSize: 11, color: '#444' }}>
        <div>873ms = φ⁴ × Schumann — NOVA&apos;s sovereign heartbeat</div>
        <div>COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.</div>
      </div>
    </div>
  );
}
