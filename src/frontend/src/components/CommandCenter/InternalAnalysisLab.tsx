import React from 'react';

type CardioNeuralView = {
  beat: number;
  coupling: number;
  oxygenFlow: number;
  perfusionFlow: number;
  conversionGain: number;
  gateOpen: boolean;
  helixBarrier: number;
  shieldIntegrity: number;
  thoughtThroughput: number;
  outputCoherence: number;
  outputDirectionX: number;
  outputDirectionY: number;
  outputDirectionZ: number;
  throughputHistory: number[];
  shieldHistory: number[];
  couplingHistory: number[];
};

type AnalystView = {
  beat: number;
  learningScore: number;
  adaptationScore: number;
  emergencySignal: number;
  recommendationPriority: number;
  narrativeSummary: string;
  heartNarrative: string;
  brainNarrative: string;
  middleOrganNarrative: string;
  defenseNarrative: string;
  growthNarrative: string;
  topRecommendations: string[];
};

type Props = {
  beat: number;
  rSwarm: number;
  jDrift: number;
  cardioNeural: CardioNeuralView;
  analyst: AnalystView;
};

const S = {
  root: {
    width: '100%',
    height: '100%',
    padding: 16,
    background: 'linear-gradient(135deg, #03101b 0%, #071725 45%, #0a1322 100%)',
    color: '#d5ecff',
    overflowY: 'auto' as const,
  },
  h1: {
    margin: 0,
    fontSize: 15,
    letterSpacing: '0.1em',
    textTransform: 'uppercase' as const,
    color: '#52c8ff',
  },
  sub: {
    marginTop: 6,
    color: '#8ab9df',
    fontSize: 12,
    lineHeight: 1.4,
  },
  grid: {
    marginTop: 14,
    display: 'grid',
    gridTemplateColumns: 'repeat(auto-fit, minmax(220px, 1fr))',
    gap: 10,
  },
  card: {
    background: 'rgba(8, 22, 38, 0.82)',
    border: '1px solid #1c4667',
    borderRadius: 8,
    padding: 10,
  },
  label: {
    fontSize: 10,
    letterSpacing: '0.08em',
    textTransform: 'uppercase' as const,
    color: '#6fa9d1',
    marginBottom: 6,
  },
  value: (color: string) => ({
    fontSize: 22,
    fontWeight: 700,
    color,
    lineHeight: 1.1,
  }),
  row: {
    display: 'flex',
    justifyContent: 'space-between',
    gap: 10,
    fontSize: 12,
    color: '#b7dcff',
    marginBottom: 4,
  },
  sectionTitle: {
    marginTop: 16,
    marginBottom: 8,
    color: '#52c8ff',
    fontSize: 12,
    letterSpacing: '0.08em',
    textTransform: 'uppercase' as const,
  },
  narrative: {
    background: 'rgba(9, 24, 40, 0.75)',
    border: '1px solid #1c4667',
    borderRadius: 8,
    padding: 10,
    marginBottom: 8,
    fontSize: 12,
    lineHeight: 1.45,
    color: '#d7ecff',
  },
  recommendation: {
    marginBottom: 6,
    padding: '8px 10px',
    borderRadius: 8,
    border: '1px solid #245779',
    background: 'rgba(12, 30, 48, 0.75)',
    fontSize: 12,
    lineHeight: 1.4,
    color: '#d7ecff',
  },
  sparkRow: {
    marginTop: 8,
    display: 'grid',
    gridTemplateColumns: 'repeat(3, 1fr)',
    gap: 8,
  },
  spark: {
    border: '1px solid #1c4667',
    borderRadius: 8,
    background: 'rgba(8, 22, 38, 0.82)',
    padding: 8,
  },
  sparkLabel: {
    fontSize: 10,
    color: '#79add1',
    marginBottom: 4,
    letterSpacing: '0.08em',
    textTransform: 'uppercase' as const,
  },
  sparkText: {
    fontFamily: 'ui-monospace, SFMono-Regular, Menlo, monospace',
    fontSize: 11,
    color: '#bce0ff',
    whiteSpace: 'pre-wrap' as const,
  },
};

function colorize(value: number, good = 0.7, danger = 0.4) {
  if (value < danger) return '#ff7f7f';
  if (value < good) return '#ffd27a';
  return '#6dffa9';
}

function miniSeries(values: number[], limit = 14): string {
  if (!values.length) return '(no data)';
  const slice = values.slice(Math.max(0, values.length - limit));
  return slice.map(v => v.toFixed(2)).join(' · ');
}

export function InternalAnalysisLab({ beat, rSwarm, jDrift, cardioNeural, analyst }: Props) {
  return (
    <div style={S.root}>
      <h2 style={S.h1}>Internal Analyst Team + Third Regulator Organ</h2>
      <div style={S.sub}>
        Live substrate narration for Heart, Brain, Middle Conversion Organ, Defense membrane, and growth adaptation.
        {' '}Beat {beat} | r={rSwarm.toFixed(3)} | drift={jDrift.toFixed(3)}
      </div>

      <div style={S.grid}>
        <div style={S.card}>
          <div style={S.label}>Coupling</div>
          <div style={S.value(colorize(cardioNeural.coupling))}>{(cardioNeural.coupling * 100).toFixed(0)}%</div>
          <div style={S.row}><span>Gate</span><span>{cardioNeural.gateOpen ? 'OPEN' : 'CLOSED'}</span></div>
          <div style={S.row}><span>Helix barrier</span><span>{cardioNeural.helixBarrier.toFixed(3)}</span></div>
          <div style={S.row}><span>Shield</span><span>{cardioNeural.shieldIntegrity.toFixed(3)}</span></div>
        </div>

        <div style={S.card}>
          <div style={S.label}>Conversion</div>
          <div style={S.value(colorize(cardioNeural.conversionGain))}>{cardioNeural.conversionGain.toFixed(3)}</div>
          <div style={S.row}><span>Thought throughput</span><span>{cardioNeural.thoughtThroughput.toFixed(3)}</span></div>
          <div style={S.row}><span>Output coherence</span><span>{cardioNeural.outputCoherence.toFixed(3)}</span></div>
          <div style={S.row}><span>Direction</span><span>({cardioNeural.outputDirectionX.toFixed(2)}, {cardioNeural.outputDirectionY.toFixed(2)}, {cardioNeural.outputDirectionZ.toFixed(2)})</span></div>
        </div>

        <div style={S.card}>
          <div style={S.label}>Flow</div>
          <div style={S.value(colorize((cardioNeural.oxygenFlow + cardioNeural.perfusionFlow) * 0.5))}>
            {((cardioNeural.oxygenFlow + cardioNeural.perfusionFlow) * 50).toFixed(0)}%
          </div>
          <div style={S.row}><span>Oxygen</span><span>{cardioNeural.oxygenFlow.toFixed(3)}</span></div>
          <div style={S.row}><span>Perfusion</span><span>{cardioNeural.perfusionFlow.toFixed(3)}</span></div>
        </div>

        <div style={S.card}>
          <div style={S.label}>Learning/Adaptation</div>
          <div style={S.value(colorize(analyst.learningScore))}>{analyst.learningScore.toFixed(3)}</div>
          <div style={S.row}><span>Adaptation</span><span>{analyst.adaptationScore.toFixed(3)}</span></div>
          <div style={S.row}><span>Emergency signal</span><span>{analyst.emergencySignal.toFixed(3)}</span></div>
          <div style={S.row}><span>Priority</span><span>{analyst.recommendationPriority.toFixed(3)}</span></div>
        </div>
      </div>

      <div style={S.sectionTitle}>Narrative Diagnostics</div>
      <div style={S.narrative}><strong>Summary:</strong> {analyst.narrativeSummary || '(pending)'}</div>
      <div style={S.narrative}><strong>Heart:</strong> {analyst.heartNarrative || '(pending)'}</div>
      <div style={S.narrative}><strong>Brain:</strong> {analyst.brainNarrative || '(pending)'}</div>
      <div style={S.narrative}><strong>Middle Organ:</strong> {analyst.middleOrganNarrative || '(pending)'}</div>
      <div style={S.narrative}><strong>Defense:</strong> {analyst.defenseNarrative || '(pending)'}</div>
      <div style={S.narrative}><strong>Growth:</strong> {analyst.growthNarrative || '(pending)'}</div>

      <div style={S.sectionTitle}>Top Recommendations (Autonomous Internal Team)</div>
      {(analyst.topRecommendations || []).map((r, i) => (
        <div key={`r-${i}`} style={S.recommendation}>
          <strong>{i + 1}.</strong> {r || '(empty)'}
        </div>
      ))}

      <div style={S.sectionTitle}>Regulation Histories</div>
      <div style={S.sparkRow}>
        <div style={S.spark}>
          <div style={S.sparkLabel}>Throughput</div>
          <div style={S.sparkText}>{miniSeries(cardioNeural.throughputHistory)}</div>
        </div>
        <div style={S.spark}>
          <div style={S.sparkLabel}>Shield</div>
          <div style={S.sparkText}>{miniSeries(cardioNeural.shieldHistory)}</div>
        </div>
        <div style={S.spark}>
          <div style={S.sparkLabel}>Coupling</div>
          <div style={S.sparkText}>{miniSeries(cardioNeural.couplingHistory)}</div>
        </div>
      </div>
    </div>
  );
}

export default InternalAnalysisLab;
