import React from 'react';

type ConstantFeedbackView = {
  backendConnected: boolean;
  beat: number;
  cognitivePressure: number;
  loopClosureScore: number;
  reinjectionIntegrity: number;
  multiGroupCoherence: number;
  multiOrganismCoherence: number;
  cognitionReadiness: number;
  arbitrationReadiness: number;
  governanceStability: number;
  recommendationPriority: number;
  narrativeSummary: string;
  topActions: string[];
  pressureHistory: number[];
  closureHistory: number[];
  reinjectionHistory: number[];
  multiGroupHistory: number[];
  multiOrganismHistory: number[];
};

type Props = {
  beat: number;
  rSwarm: number;
  jDrift: number;
  feedback: ConstantFeedbackView;
};

const S = {
  root: {
    width: '100%',
    height: '100%',
    padding: 16,
    background: 'linear-gradient(140deg, #031120 0%, #07192c 45%, #0a1c2d 100%)',
    color: '#d5edff',
    overflowY: 'auto' as const,
  },
  h1: {
    margin: 0,
    fontSize: 15,
    letterSpacing: '0.1em',
    textTransform: 'uppercase' as const,
    color: '#54cbff',
  },
  sub: {
    marginTop: 6,
    color: '#8ebfe4',
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
    background: 'rgba(9, 24, 40, 0.82)',
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

export function ConstantFeedbackLab({ beat, rSwarm, jDrift, feedback }: Props) {
  return (
    <div style={S.root}>
      <h2 style={S.h1}>Constant Feedback Cognition</h2>
      <div style={S.sub}>
        Continuous feedback closure across multi-groups and multi-organisms.
        {' '}Beat {beat} | r={rSwarm.toFixed(3)} | drift={jDrift.toFixed(3)}
      </div>
      <div style={S.badge(feedback.backendConnected)}>
        {feedback.backendConnected ? 'Backend Substrate Live' : 'Local Fallback'}
      </div>

      <div style={S.grid}>
        <div style={S.card}>
          <div style={S.label}>Cognitive Pressure</div>
          <div style={S.value}>{fmt(feedback.cognitivePressure)}</div>
          <div style={S.barWrap}><div style={S.bar(feedback.cognitivePressure, '#ff9b6a')} /></div>
        </div>
        <div style={S.card}>
          <div style={S.label}>Loop Closure</div>
          <div style={S.value}>{fmt(feedback.loopClosureScore)}</div>
          <div style={S.barWrap}><div style={S.bar(feedback.loopClosureScore, '#4dd9ff')} /></div>
        </div>
        <div style={S.card}>
          <div style={S.label}>Reinjection Integrity</div>
          <div style={S.value}>{fmt(feedback.reinjectionIntegrity)}</div>
          <div style={S.barWrap}><div style={S.bar(feedback.reinjectionIntegrity, '#63ffaa')} /></div>
        </div>
        <div style={S.card}>
          <div style={S.label}>Recommendation Priority</div>
          <div style={S.value}>{fmt(feedback.recommendationPriority)}</div>
          <div style={S.mini}>governance: {fmt(feedback.governanceStability)}</div>
          <div style={S.barWrap}><div style={S.bar(feedback.recommendationPriority, '#ffd27a')} /></div>
        </div>
      </div>

      <div style={S.grid}>
        <div style={S.card}>
          <div style={S.label}>Multi-Group Coherence</div>
          <div style={S.value}>{fmt(feedback.multiGroupCoherence)}</div>
          <div style={S.barWrap}><div style={S.bar(feedback.multiGroupCoherence, '#62c8ff')} /></div>
        </div>
        <div style={S.card}>
          <div style={S.label}>Multi-Organism Coherence</div>
          <div style={S.value}>{fmt(feedback.multiOrganismCoherence)}</div>
          <div style={S.barWrap}><div style={S.bar(feedback.multiOrganismCoherence, '#9bffdd')} /></div>
        </div>
        <div style={S.card}>
          <div style={S.label}>Cognition Readiness</div>
          <div style={S.value}>{fmt(feedback.cognitionReadiness)}</div>
          <div style={S.barWrap}><div style={S.bar(feedback.cognitionReadiness, '#b3b8ff')} /></div>
        </div>
        <div style={S.card}>
          <div style={S.label}>Arbitration Readiness</div>
          <div style={S.value}>{fmt(feedback.arbitrationReadiness)}</div>
          <div style={S.barWrap}><div style={S.bar(feedback.arbitrationReadiness, '#d4af37')} /></div>
        </div>
      </div>

      <div style={S.sectionTitle}>Narrative</div>
      <div style={S.narrative}>{feedback.narrativeSummary || '(pending)'}</div>

      <div style={S.sectionTitle}>Top Actions</div>
      {(feedback.topActions || []).map((r, i) => (
        <div key={`rec-${i}`} style={S.rec}>
          <strong>{i + 1}.</strong> {r || '(empty)'}
        </div>
      ))}

      <div style={S.sectionTitle}>Feedback Histories</div>
      <div style={S.card}>
        <div style={S.spark}>
          pressure: {miniSeries(feedback.pressureHistory)}
          {'\n'}closure: {miniSeries(feedback.closureHistory)}
          {'\n'}reinjection: {miniSeries(feedback.reinjectionHistory)}
          {'\n'}groups: {miniSeries(feedback.multiGroupHistory)}
          {'\n'}organisms: {miniSeries(feedback.multiOrganismHistory)}
        </div>
      </div>
    </div>
  );
}

export default ConstantFeedbackLab;
