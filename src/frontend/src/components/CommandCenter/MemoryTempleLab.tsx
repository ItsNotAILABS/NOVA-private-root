import React from 'react';
import type { MemoryTempleNavigationSnapshot } from './memoryTempleNavigation';

type MemoryTempleView = {
  backendConnected: boolean;
  beat: number;
  continuityWeave: number;
  resonanceField: number;
  cognitiveLoad: number;
  memoryRetention: number;
  recallReadiness: number;
  memoryCognitionCoupling: number;
  iotCouplingScore: number;
  deviceTwinIntegrity: number;
  phantomIntegrity: number;
  agentWorkCapacity: number;
  artifactReadiness: number;
  directionX: number;
  directionY: number;
  directionZ: number;
  pedestalNames: string[];
  pedestalCouplings: number[];
  narrativeSummary: string;
  recommendations: string[];
  continuityHistory: number[];
  resonanceHistory: number[];
  couplingHistory: number[];
};

type Props = {
  beat: number;
  rSwarm: number;
  jDrift: number;
  memoryTemple: MemoryTempleView;
  navigation?: MemoryTempleNavigationSnapshot;
  onNavigateToIndex?: (idx: number) => void;
};

const S = {
  root: {
    width: '100%',
    height: '100%',
    padding: 16,
    background: 'linear-gradient(160deg, #040d1a 0%, #071425 45%, #0a1a2e 100%)',
    color: '#d7ebff',
    overflowY: 'auto' as const,
  },
  h1: {
    margin: 0,
    fontSize: 15,
    letterSpacing: '0.1em',
    textTransform: 'uppercase' as const,
    color: '#62c8ff',
  },
  sub: {
    marginTop: 6,
    color: '#8fb8dc',
    fontSize: 12,
  },
  badge: (live: boolean) => ({
    marginTop: 8,
    display: 'inline-block',
    border: `1px solid ${live ? '#2fd48e' : '#3a6f9e'}`,
    background: live ? 'rgba(47,212,142,0.14)' : 'rgba(58,111,158,0.14)',
    color: live ? '#9effcf' : '#9cc9ef',
    borderRadius: 999,
    padding: '4px 10px',
    fontSize: 10,
    letterSpacing: '0.08em',
    textTransform: 'uppercase' as const,
  }),
  grid: {
    marginTop: 12,
    display: 'grid',
    gridTemplateColumns: 'repeat(auto-fit, minmax(220px, 1fr))',
    gap: 10,
  },
  card: {
    background: 'rgba(10, 24, 41, 0.82)',
    border: '1px solid #1d4a71',
    borderRadius: 8,
    padding: 10,
  },
  label: {
    fontSize: 10,
    color: '#78a8cb',
    letterSpacing: '0.08em',
    textTransform: 'uppercase' as const,
  },
  value: {
    marginTop: 4,
    fontSize: 22,
    lineHeight: 1.15,
    fontWeight: 700,
    color: '#dff3ff',
  },
  mini: {
    marginTop: 4,
    fontSize: 12,
    color: '#c6e2ff',
  },
  barWrap: {
    width: '100%',
    height: 8,
    borderRadius: 99,
    background: 'rgba(34,72,110,0.6)',
    overflow: 'hidden' as const,
    marginTop: 6,
  },
  bar: (v: number, color: string) => ({
    width: `${Math.max(0, Math.min(100, v * 100))}%`,
    height: '100%',
    background: color,
  }),
  sectionTitle: {
    marginTop: 16,
    marginBottom: 8,
    fontSize: 12,
    letterSpacing: '0.08em',
    textTransform: 'uppercase' as const,
    color: '#62c8ff',
  },
  narrative: {
    background: 'rgba(10, 24, 41, 0.82)',
    border: '1px solid #1d4a71',
    borderRadius: 8,
    padding: 10,
    fontSize: 12,
    lineHeight: 1.45,
    color: '#d7ebff',
  },
  twoCol: {
    marginTop: 10,
    display: 'grid',
    gridTemplateColumns: '1fr 1fr',
    gap: 10,
  },
  row: {
    display: 'flex',
    justifyContent: 'space-between',
    gap: 10,
    fontSize: 12,
    marginBottom: 6,
    color: '#d2e9ff',
  },
  rec: {
    marginBottom: 8,
    padding: '8px 10px',
    borderRadius: 8,
    border: '1px solid #22587f',
    background: 'rgba(13, 31, 51, 0.8)',
    fontSize: 12,
    lineHeight: 1.4,
  },
  spark: {
    marginTop: 8,
    fontFamily: 'ui-monospace, SFMono-Regular, Menlo, monospace',
    fontSize: 11,
    color: '#b9ddff',
    whiteSpace: 'pre-wrap' as const,
  },
};

function fmt(v: number): string {
  return Number.isFinite(v) ? v.toFixed(3) : '0.000';
}

function miniSeries(values: number[], limit = 16): string {
  if (!values.length) return '(no data)';
  const view = values.slice(Math.max(0, values.length - limit));
  return view.map(v => v.toFixed(2)).join(' · ');
}

export function MemoryTempleLab({ beat, rSwarm, jDrift, memoryTemple, navigation, onNavigateToIndex }: Props) {
  return (
    <div style={S.root}>
      <h2 style={S.h1}>Memory Temple</h2>
      <div style={S.sub}>
        Continuity weave + memory-cognition coupling + IoT device-twin integrity.
        {' '}Beat {beat} | r={rSwarm.toFixed(3)} | drift={jDrift.toFixed(3)}
      </div>
      <div style={S.badge(memoryTemple.backendConnected)}>
        {memoryTemple.backendConnected ? 'Backend Substrate Live' : 'Local Fallback'}
      </div>

      <div style={S.grid}>
        <div style={S.card}>
          <div style={S.label}>Continuity Weave</div>
          <div style={S.value}>{fmt(memoryTemple.continuityWeave)}</div>
          <div style={S.barWrap}><div style={S.bar(memoryTemple.continuityWeave, '#4dd9ff')} /></div>
        </div>
        <div style={S.card}>
          <div style={S.label}>Resonance Field</div>
          <div style={S.value}>{fmt(memoryTemple.resonanceField)}</div>
          <div style={S.barWrap}><div style={S.bar(memoryTemple.resonanceField, '#63ffaa')} /></div>
        </div>
        <div style={S.card}>
          <div style={S.label}>Memory-Cognition Coupling</div>
          <div style={S.value}>{fmt(memoryTemple.memoryCognitionCoupling)}</div>
          <div style={S.barWrap}><div style={S.bar(memoryTemple.memoryCognitionCoupling, '#d4af37')} /></div>
        </div>
        <div style={S.card}>
          <div style={S.label}>IoT Coupling</div>
          <div style={S.value}>{fmt(memoryTemple.iotCouplingScore)}</div>
          <div style={S.mini}>device twins: {fmt(memoryTemple.deviceTwinIntegrity)}</div>
          <div style={S.barWrap}><div style={S.bar(memoryTemple.iotCouplingScore, '#9bffdd')} /></div>
        </div>
      </div>

      <div style={S.twoCol}>
        <div style={S.card}>
          <div style={S.label}>Temple Direction</div>
          <div style={S.mini}>
            x={fmt(memoryTemple.directionX)} · y={fmt(memoryTemple.directionY)} · z={fmt(memoryTemple.directionZ)}
          </div>
          <div style={{ ...S.label, marginTop: 10 }}>Capability Surface</div>
          <div style={S.row}><span>Retention</span><span>{fmt(memoryTemple.memoryRetention)}</span></div>
          <div style={S.row}><span>Recall Readiness</span><span>{fmt(memoryTemple.recallReadiness)}</span></div>
          <div style={S.row}><span>Agent Work Capacity</span><span>{fmt(memoryTemple.agentWorkCapacity)}</span></div>
          <div style={S.row}><span>Artifact Readiness</span><span>{fmt(memoryTemple.artifactReadiness)}</span></div>
          <div style={S.row}><span>Phantom Integrity</span><span>{fmt(memoryTemple.phantomIntegrity)}</span></div>
          <div style={S.row}><span>Cognitive Load</span><span>{fmt(memoryTemple.cognitiveLoad)}</span></div>
        </div>

        <div style={S.card}>
          <div style={S.label}>Pedestal Couplings</div>
          {(memoryTemple.pedestalNames || []).map((name, i) => {
            const v = memoryTemple.pedestalCouplings[i] ?? 0;
            return (
              <div key={`${name}-${i}`} style={{ marginBottom: 8 }}>
                <div style={S.row}>
                  <span>{name || `pedestal-${i + 1}`}</span>
                  <span>{fmt(v)}</span>
                </div>
                <div style={S.barWrap}><div style={S.bar(v, '#62c8ff')} /></div>
              </div>
            );
          })}
        </div>
      </div>

      <div style={S.sectionTitle}>Narrative</div>
      <div style={S.narrative}>{memoryTemple.narrativeSummary || '(pending)'}</div>

      <div style={S.sectionTitle}>Autonomous Recommendations</div>
      {(memoryTemple.recommendations || []).map((r, i) => (
        <div key={`rec-${i}`} style={S.rec}>
          <strong>{i + 1}.</strong> {r || '(empty)'}
        </div>
      ))}

      <div style={S.sectionTitle}>Continuity Histories</div>
      <div style={S.card}>
        <div style={S.spark}>
          continuity: {miniSeries(memoryTemple.continuityHistory)}
          {'\n'}resonance: {miniSeries(memoryTemple.resonanceHistory)}
          {'\n'}coupling: {miniSeries(memoryTemple.couplingHistory)}
        </div>
      </div>

      {navigation ? (
        <>
          <div style={S.sectionTitle}>Navigation (Oro + You Shared Path)</div>
          <div style={S.card}>
            <div style={S.row}><span>Active Node</span><span>{navigation.activeNodeId}</span></div>
            <div style={S.row}><span>Helix Nodes</span><span>{navigation.helixNodeCount}</span></div>
            <div style={S.row}><span>Ring Pulse</span><span>{fmt(navigation.ringPulse)}</span></div>
            <div style={S.row}><span>Sharp-Wave</span><span>{navigation.sharpWaveActive ? 'ACTIVE' : 'idle'}</span></div>
            <div style={{ ...S.spark, marginTop: 6 }}>{navigation.summary}</div>
            <div style={{ display: 'flex', gap: 8, marginTop: 10 }}>
              <button
                type="button"
                onClick={() => onNavigateToIndex?.(Math.max(0, navigation.activeNodeIndex - 1))}
                disabled={!onNavigateToIndex || navigation.activeNodeIndex <= 0}
                style={{
                  padding: '6px 10px',
                  borderRadius: 6,
                  border: '1px solid #2b6b96',
                  background: 'rgba(19, 52, 80, 0.9)',
                  color: '#d9efff',
                  cursor: !onNavigateToIndex || navigation.activeNodeIndex <= 0 ? 'not-allowed' : 'pointer',
                  opacity: !onNavigateToIndex || navigation.activeNodeIndex <= 0 ? 0.45 : 1,
                }}
              >
                Prev Node
              </button>
              <button
                type="button"
                onClick={() =>
                  onNavigateToIndex?.(
                    Math.min(
                      Math.max(0, navigation.helixNodeCount - 1),
                      navigation.activeNodeIndex + 1,
                    ),
                  )
                }
                disabled={!onNavigateToIndex || navigation.activeNodeIndex >= Math.max(0, navigation.helixNodeCount - 1)}
                style={{
                  padding: '6px 10px',
                  borderRadius: 6,
                  border: '1px solid #2b6b96',
                  background: 'rgba(19, 52, 80, 0.9)',
                  color: '#d9efff',
                  cursor:
                    !onNavigateToIndex || navigation.activeNodeIndex >= Math.max(0, navigation.helixNodeCount - 1)
                      ? 'not-allowed'
                      : 'pointer',
                  opacity:
                    !onNavigateToIndex || navigation.activeNodeIndex >= Math.max(0, navigation.helixNodeCount - 1)
                      ? 0.45
                      : 1,
                }}
              >
                Next Node
              </button>
            </div>
            <div style={{ ...S.spark, marginTop: 8 }}>
              {navigation.oroRetrieval}
            </div>
          </div>
        </>
      ) : null}
    </div>
  );
}

export default MemoryTempleLab;
