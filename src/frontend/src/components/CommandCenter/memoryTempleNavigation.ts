export type MemoryTempleNavigationInput = {
  beat: number;
  continuityWeave: number;
  resonanceField: number;
  memoryRetention: number;
  recallReadiness: number;
  memoryCognitionCoupling: number;
  directionX: number;
  directionY: number;
  directionZ: number;
  continuityHistory: number[];
  resonanceHistory: number[];
  couplingHistory: number[];
};

export type MemoryTempleNavigationNode = {
  id: string;
  beat: number;
  ring: number;
  theta: number;
  phi: number;
  depth: number;
  salience: number;
  doctrineAlignment: number;
  genesisDistance: number;
  rippleReady: boolean;
};

export type MemoryTempleNavigationState = {
  nodes: MemoryTempleNavigationNode[];
  activeNodeIndex: number;
  activeNodeId: string;
  helixNodeCount: number;
  ringPulse: number;
  sharpWaveActive: boolean;
  summary: string;
  oroRetrieval: string;
};

const TAU = 6.283185307179586;
const MAX_NODES = 72;

function clamp(x: number, lo: number, hi: number): number {
  if (x < lo) return lo;
  if (x > hi) return hi;
  return x;
}

function wrap01(x: number): number {
  let y = x;
  while (y >= 1) y -= 1;
  while (y < 0) y += 1;
  return y;
}

function buildNode(input: MemoryTempleNavigationInput, absoluteBeat: number): MemoryTempleNavigationNode {
  const ring = absoluteBeat % 34;
  const depth = clamp(ring / 34, 0, 1);
  const salience = clamp(
    0.34 * input.continuityWeave +
      0.3 * input.resonanceField +
      0.18 * input.recallReadiness +
      0.18 * input.memoryCognitionCoupling,
    0,
    1.5,
  );
  const doctrineAlignment = clamp(
    0.55 * input.continuityWeave + 0.45 * input.memoryRetention,
    0,
    1.5,
  );
  const genesisDistance = clamp(1 - doctrineAlignment, 0, 1.5);
  const theta = wrap01(absoluteBeat * 0.017 + input.continuityWeave * 0.13) * TAU;
  const phi = wrap01(absoluteBeat * 0.011 + input.resonanceField * 0.21) * TAU;
  const rippleReady = salience > 0.9 && doctrineAlignment > 0.75 && input.memoryRetention > 0.7;

  return {
    id: `HTX-${absoluteBeat}-${ring}`,
    beat: absoluteBeat,
    ring,
    theta,
    phi,
    depth,
    salience,
    doctrineAlignment,
    genesisDistance,
    rippleReady,
  };
}

function buildMemoryTempleNavigationState(
  input: MemoryTempleNavigationInput,
  activeNodeIndex: number,
): MemoryTempleNavigationState {
  const continuity = input.continuityHistory ?? [];
  const resonance = input.resonanceHistory ?? [];
  const coupling = input.couplingHistory ?? [];
  const historySize = Math.max(continuity.length, resonance.length, coupling.length);
  const nodeCount = Math.max(1, Math.min(MAX_NODES, historySize || 1));
  const nodes: MemoryTempleNavigationNode[] = [];

  if (historySize === 0) {
    nodes.push(buildNode(input, input.beat));
  } else {
    for (let i = 0; i < nodeCount; i += 1) {
      const offset = nodeCount - 1 - i;
      const absoluteBeat = Math.max(0, input.beat - offset);
      const c = continuity[Math.max(0, continuity.length - nodeCount + i)] ?? input.continuityWeave;
      const r = resonance[Math.max(0, resonance.length - nodeCount + i)] ?? input.resonanceField;
      const k = coupling[Math.max(0, coupling.length - nodeCount + i)] ?? input.memoryCognitionCoupling;
      nodes.push(
        buildNode(
          {
            ...input,
            continuityWeave: c,
            resonanceField: r,
            memoryCognitionCoupling: k,
          },
          absoluteBeat,
        ),
      );
    }
  }

  const idx = clamp(activeNodeIndex, 0, Math.max(0, nodes.length - 1));
  const activeNode = nodes[idx];
  const ringPulse = clamp(
    0.45 * activeNode.salience +
      0.35 * activeNode.doctrineAlignment +
      0.2 * input.memoryCognitionCoupling,
    0,
    1.5,
  );
  const sharpWaveActive = Boolean(activeNode.rippleReady && input.beat % 52 === 0);
  const summary =
    `Navigation beat ${input.beat}: nodes=${nodes.length}, active=${activeNode.id}, pulse=${ringPulse.toFixed(3)}` +
    (sharpWaveActive ? ', sharp-wave ripple active.' : ', ripple pending.');
  const oroRetrieval =
    `ORO focus ${activeNode.id} @ beat ${activeNode.beat} | ` +
    `salience=${activeNode.salience.toFixed(3)} | doctrine=${activeNode.doctrineAlignment.toFixed(3)} | ` +
    `genesisDistance=${activeNode.genesisDistance.toFixed(3)} | vector=(${input.directionX.toFixed(2)}, ${input.directionY.toFixed(2)}, ${input.directionZ.toFixed(2)})`;

  return {
    nodes,
    activeNodeIndex: idx,
    activeNodeId: activeNode.id,
    helixNodeCount: nodes.length,
    ringPulse,
    sharpWaveActive,
    summary,
    oroRetrieval,
  };
}

export type MemoryTempleNavigationSnapshot = MemoryTempleNavigationState;

export function initMemoryTempleNavigation(): MemoryTempleNavigationState {
  const seedInput: MemoryTempleNavigationInput = {
    beat: 0,
    continuityWeave: 0.74,
    resonanceField: 0.72,
    memoryRetention: 0.73,
    recallReadiness: 0.7,
    memoryCognitionCoupling: 0.72,
    directionX: 0,
    directionY: 0,
    directionZ: 1,
    continuityHistory: [],
    resonanceHistory: [],
    couplingHistory: [],
  };
  return buildMemoryTempleNavigationState(seedInput, 0);
}

export function tickMemoryTempleNavigation(
  state: MemoryTempleNavigationState,
  input: MemoryTempleNavigationInput,
): MemoryTempleNavigationState {
  return buildMemoryTempleNavigationState(input, state.activeNodeIndex);
}

export function navigateMemoryTempleToIndex(
  state: MemoryTempleNavigationState,
  targetIndex: number,
): MemoryTempleNavigationState {
  if (!state.nodes.length) return state;
  const idx = clamp(targetIndex, 0, state.nodes.length - 1);
  const activeNode = state.nodes[idx];
  return {
    ...state,
    activeNodeIndex: idx,
    activeNodeId: activeNode.id,
    ringPulse: clamp(0.82 * state.ringPulse + 0.18 * activeNode.salience, 0, 1.5),
    sharpWaveActive: Boolean(activeNode.rippleReady),
    summary: `Navigation focus moved to ${activeNode.id} (beat ${activeNode.beat}).`,
    oroRetrieval:
      `ORO focus ${activeNode.id} @ beat ${activeNode.beat} | ` +
      `salience=${activeNode.salience.toFixed(3)} | doctrine=${activeNode.doctrineAlignment.toFixed(3)} | ` +
      `genesisDistance=${activeNode.genesisDistance.toFixed(3)}`,
  };
}
