import React, { useMemo } from 'react';

export interface GRPEState {
  beat: number;
  fieldEnergy: number;
  hotspotScore: number;
  protectionScore: number;
  threatScore: number;
  serviceReadiness: number;
  fieldDirectionX: number;
  fieldDirectionY: number;
  fieldDirectionZ: number;
  sevenHeritageNodes: number[];
  serviceOpportunity: number[];
  defenseServiceOpportunity: number[];
  memoryServiceOpportunity: number[];
  worldServiceOpportunity: number[];
  fieldHistory: number[];
  hotspotHistory: number[];
  protectionHistory: number[];
}

interface Props {
  state: GRPEState | null;
  loading?: boolean;
  source: 'backend' | 'local';
}

const S = {
  root: {
    width: '100%',
    height: '100%',
    overflow: 'auto' as const,
    background: 'linear-gradient(160deg, #050b16 0%, #071529 60%, #081b33 100%)',
    color: '#d6ecff',
    padding: 16,
    boxSizing: 'border-box' as const,
  },
  header: {
    marginBottom: 12,
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'space-between',
    gap: 12,
  },
  title: {
    fontSize: 15,
    letterSpacing: '0.12em',
    textTransform: 'uppercase' as const,
    color: '#00d4ff',
    fontWeight: 700,
  },
  badge: (backend: boolean) => ({
    fontSize: 10,
    padding: '4px 8px',
    borderRadius: 999,
    border: `1px solid ${backend ? '#2ed488' : '#2a6a9a'}`,
    color: backend ? '#91ffd0' : '#91c8ff',
    background: backend ? 'rgba(46,212,136,0.15)' : 'rgba(42,106,154,0.18)',
    letterSpacing: '0.08em',
    textTransform: 'uppercase' as const,
  }),
  grid: {
    display: 'grid',
    gridTemplateColumns: 'repeat(4, minmax(160px, 1fr))',
    gap: 10,
    marginBottom: 12,
  },
  card: {
    background: 'rgba(8, 25, 45, 0.75)',
    border: '1px solid #1f4d77',
    borderRadius: 8,
    padding: 10,
  },
  label: {
    fontSize: 10,
    color: '#79b8e8',
    letterSpacing: '0.08em',
    textTransform: 'uppercase' as const,
  },
  value: {
    fontSize: 20,
    color: '#d8f2ff',
    fontWeight: 700,
    lineHeight: 1.2,
    marginTop: 4,
  },
  panelRow: {
    display: 'grid',
    gridTemplateColumns: '1.4fr 1fr 1fr',
    gap: 10,
    marginBottom: 10,
  },
  panel: {
    background: 'rgba(8, 25, 45, 0.75)',
    border: '1px solid #1f4d77',
    borderRadius: 8,
    padding: 10,
  },
  panelTitle: {
    fontSize: 11,
    color: '#00d4ff',
    letterSpacing: '0.1em',
    textTransform: 'uppercase' as const,
    marginBottom: 8,
  },
  serviceRow: {
    display: 'grid',
    gridTemplateColumns: '1fr auto',
    gap: 8,
    marginBottom: 6,
    fontSize: 12,
  },
  barWrap: {
    width: '100%',
    height: 8,
    borderRadius: 99,
    background: 'rgba(30,70,110,0.6)',
    overflow: 'hidden' as const,
    marginTop: 4,
  },
  bar: (v: number, c: string) => ({
    width: `${Math.max(0, Math.min(100, v * 100))}%`,
    height: '100%',
    background: c,
  }),
  mono: {
    fontFamily: 'ui-monospace, SFMono-Regular, Menlo, monospace',
    fontSize: 11,
    color: '#9ad0ff',
    whiteSpace: 'pre-wrap' as const,
  },
  loading: {
    color: '#7ba6cd',
    fontSize: 12,
    marginTop: 8,
  },
};

const HERITAGE_NAMES = [
  'Zapata',
  'Villa',
  'Independencia',
  'Hidalgo',
  'Adelita',
  'Morelos',
  'Revolucion',
];

const SERVICE_NAMES = [
  'EM Hotspot Mapping',
  'RF Drift Sentinel',
  'Hydrology-Field Correlation',
  'Infrastructure Pulse Risk',
  'Autonomous Watcher Mesh',
  'Grid Anomaly Triangulation',
  'Critical Corridor Scan',
  'Field Integrity Audit',
  'Defense Route Prioritization',
  'Cyber-Physical Signal Hunt',
  'Memory Resonance Cartography',
  'Lineage-Signature Stability',
  'Borderline Event Forecast',
  'Doctrine-to-Field Fit',
  'Geo-Temporal Event Replay',
  'Service Deployment Index',
  'Defense Theater Readiness',
  'Industrial Monitoring Readiness',
  'Eco-Protection Readiness',
  'Cyber Shield Readiness',
];

function fmt(v: number): string {
  return Number.isFinite(v) ? v.toFixed(3) : '0.000';
}

function defaultState(): GRPEState {
  return {
    beat: 0,
    fieldEnergy: 0.66,
    hotspotScore: 0.25,
    protectionScore: 0.74,
    threatScore: 0.28,
    serviceReadiness: 0.7,
    fieldDirectionX: 0.0,
    fieldDirectionY: 0.0,
    fieldDirectionZ: 1.0,
    sevenHeritageNodes: [0.72, 0.7, 0.68, 0.69, 0.74, 0.71, 0.73],
    serviceOpportunity: Array.from({ length: 20 }, (_, i) => 0.65 + Math.sin(i * 0.21) * 0.08),
    defenseServiceOpportunity: [0.78, 0.75, 0.73, 0.77, 0.8],
    memoryServiceOpportunity: [0.72, 0.7, 0.74, 0.71, 0.73],
    worldServiceOpportunity: [0.7, 0.68, 0.72, 0.71, 0.69],
    fieldHistory: [],
    hotspotHistory: [],
    protectionHistory: [],
  };
}

export function GRPELab({ state, loading = false, source }: Props) {
  const s = state ?? defaultState();

  const serviceRows = useMemo(() => {
    const arr = s.serviceOpportunity.length > 0 ? s.serviceOpportunity : defaultState().serviceOpportunity;
    return SERVICE_NAMES.map((name, i) => ({
      name,
      value: arr[i] ?? 0.0,
    }));
  }, [s.serviceOpportunity]);

  return (
    <div style={S.root}>
      <div style={S.header}>
        <div style={S.title}>GRPE · Geo Resonance Protection Engine</div>
        <div style={S.badge(source === 'backend')}>
          {source === 'backend' ? 'Backend Substrate Live' : 'Local Synth Fallback'}
        </div>
      </div>

      <div style={S.grid}>
        <div style={S.card}>
          <div style={S.label}>Beat</div>
          <div style={S.value}>{s.beat}</div>
        </div>
        <div style={S.card}>
          <div style={S.label}>Field Energy</div>
          <div style={S.value}>{fmt(s.fieldEnergy)}</div>
          <div style={S.barWrap}><div style={S.bar(s.fieldEnergy, '#00d4ff')} /></div>
        </div>
        <div style={S.card}>
          <div style={S.label}>Protection Score</div>
          <div style={S.value}>{fmt(s.protectionScore)}</div>
          <div style={S.barWrap}><div style={S.bar(s.protectionScore, '#39e58f')} /></div>
        </div>
        <div style={S.card}>
          <div style={S.label}>Threat Score</div>
          <div style={S.value}>{fmt(s.threatScore)}</div>
          <div style={S.barWrap}><div style={S.bar(s.threatScore * 0.5, '#ff7a7a')} /></div>
        </div>
      </div>

      <div style={S.panelRow}>
        <div style={S.panel}>
          <div style={S.panelTitle}>20 Service Opportunity Surface</div>
          {serviceRows.map((row, i) => (
            <div key={i} style={S.serviceRow}>
              <div>{row.name}</div>
              <div>{fmt(row.value)}</div>
            </div>
          ))}
        </div>

        <div style={S.panel}>
          <div style={S.panelTitle}>Seven Heritage Nodes</div>
          {HERITAGE_NAMES.map((name, i) => {
            const v = s.sevenHeritageNodes[i] ?? 0.0;
            return (
              <div key={name} style={{ marginBottom: 7 }}>
                <div style={{ ...S.serviceRow, marginBottom: 2 }}>
                  <div>{name}</div>
                  <div>{fmt(v)}</div>
                </div>
                <div style={S.barWrap}><div style={S.bar(v, '#d4af37')} /></div>
              </div>
            );
          })}
        </div>

        <div style={S.panel}>
          <div style={S.panelTitle}>Field Geometry</div>
          <div style={S.mono}>
            {`direction: [${fmt(s.fieldDirectionX)}, ${fmt(s.fieldDirectionY)}, ${fmt(s.fieldDirectionZ)}]

hotspot: ${fmt(s.hotspotScore)}
service-readiness: ${fmt(s.serviceReadiness)}

defense-vector:
  [${(s.defenseServiceOpportunity || []).map(fmt).join(', ')}]

memory-vector:
  [${(s.memoryServiceOpportunity || []).map(fmt).join(', ')}]

world-vector:
  [${(s.worldServiceOpportunity || []).map(fmt).join(', ')}]`}
          </div>
          {loading && <div style={S.loading}>syncing backend GRPE state...</div>}
        </div>
      </div>
    </div>
  );
}

export default GRPELab;
