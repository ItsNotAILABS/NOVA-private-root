/**
 * SystemsOverview.tsx — CPL-F Sovereign Systems Overview
 * The "everything connected" view: intelligence, engines, meshes, AI, and build systems.
 */

import React from 'react';
import { FMODEL_REGISTRY, FMODEL_STATS, PHANTOM_REGISTRY, PHANTOM_STATS, PRIMITIVES } from '../intelligence';
import { ChimeraTransformer } from '../engines/ChimeraTransformer';
import { PhoenixEngine } from '../engines/PhoenixEngine';
import { AtlasEngine } from '../engines/AtlasEngine';

const STYLES = {
  page: {
    fontFamily: 'system-ui, -apple-system, sans-serif',
    background: '#06080f',
    color: '#e2e8f0',
    minHeight: '100vh',
    padding: '2rem',
    overflowY: 'auto' as const,
    scrollBehavior: 'smooth' as const,
  },
  header: {
    textAlign: 'center' as const,
    marginBottom: '3rem',
  },
  title: {
    fontSize: '2.5rem',
    fontWeight: 700,
    background: 'linear-gradient(135deg, #4af, #a78bfa)',
    WebkitBackgroundClip: 'text',
    WebkitTextFillColor: 'transparent',
    marginBottom: '0.5rem',
  },
  subtitle: {
    fontSize: '1rem',
    color: '#94a3b8',
  },
  section: {
    marginBottom: '3rem',
  },
  sectionTitle: {
    fontSize: '1.5rem',
    fontWeight: 600,
    marginBottom: '1.25rem',
    paddingBottom: '0.5rem',
    borderBottom: '1px solid rgba(74, 170, 255, 0.2)',
    textShadow: '0 0 12px rgba(74, 170, 255, 0.3)',
  },
  grid: {
    display: 'grid',
    gridTemplateColumns: 'repeat(auto-fill, minmax(300px, 1fr))',
    gap: '1rem',
  },
  card: {
    background: 'rgba(12, 26, 46, 0.5)',
    backdropFilter: 'blur(8px)',
    WebkitBackdropFilter: 'blur(8px)',
    border: '1px solid rgba(74, 170, 255, 0.15)',
    borderRadius: '12px',
    padding: '1.25rem',
    transition: 'border-color 0.2s',
  },
  cardTitle: {
    fontSize: '1.1rem',
    fontWeight: 600,
    color: '#4af',
    marginBottom: '0.5rem',
  },
  cardText: {
    fontSize: '0.875rem',
    color: '#94a3b8',
    lineHeight: 1.6,
  },
  stat: {
    fontSize: '2rem',
    fontWeight: 700,
    background: 'linear-gradient(135deg, #4af, #a78bfa)',
    WebkitBackgroundClip: 'text',
    WebkitTextFillColor: 'transparent',
  },
  tag: {
    display: 'inline-block',
    background: 'rgba(74, 170, 255, 0.1)',
    border: '1px solid rgba(74, 170, 255, 0.2)',
    borderRadius: '6px',
    padding: '0.25rem 0.6rem',
    margin: '0.2rem',
    fontSize: '0.75rem',
    color: '#a78bfa',
  },
  meshContainer: {
    background: 'rgba(12, 26, 46, 0.5)',
    backdropFilter: 'blur(8px)',
    WebkitBackdropFilter: 'blur(8px)',
    border: '1px solid rgba(74, 170, 255, 0.15)',
    borderRadius: '12px',
    padding: '2rem',
    fontFamily: 'monospace',
    fontSize: '0.85rem',
    lineHeight: 2,
    color: '#94a3b8',
  },
  meshArrow: {
    color: '#4af',
  },
  substrateBar: {
    display: 'flex',
    flexWrap: 'wrap' as const,
    gap: '0.75rem',
    justifyContent: 'center',
  },
  substratePill: {
    background: 'rgba(12, 26, 46, 0.7)',
    backdropFilter: 'blur(8px)',
    WebkitBackdropFilter: 'blur(8px)',
    border: '1px solid rgba(167, 139, 250, 0.3)',
    borderRadius: '20px',
    padding: '0.6rem 1.5rem',
    fontSize: '0.9rem',
    fontWeight: 500,
  },
};

const ENGINE_MATRIX = [
  {
    name: 'Chimera Transformer',
    description: 'Hybrid Synthesis — Multi-source trait fusion, genetic algorithm optimization, φ-weighted dominance',
  },
  {
    name: 'Phoenix Engine',
    description: 'Rebirth System — Death detection, ash preservation, φ-enhanced resurrection, immortality cycles',
  },
  {
    name: 'Atlas Engine',
    description: 'Load Bearer — Dynamic scaling, φ-optimal load distribution, failure detection, infinite horizontal scaling',
  },
  {
    name: 'Kronos Transformer',
    description: 'Temporal Engine — Time manipulation, causal ordering, temporal paradox resolution',
  },
  {
    name: 'Metamorphosis Engine',
    description: 'Evolution System — Stage transitions, metamorphic cycles, butterfly emergence patterns',
  },
];

const MESH_ENGINES = [
  { name: 'QuipuEngine', role: 'memory' },
  { name: 'QhapaqNanMesh', role: 'routing' },
  { name: 'TawantinsuyuHub', role: 'topology' },
  { name: 'BehavioralEcon', role: 'economics' },
  { name: 'Antifragility', role: 'resilience' },
  { name: 'FractalSov', role: 'coherence' },
  { name: 'LinguaCompressa', role: 'compression' },
  { name: 'TerraceBench', role: 'testing' },
];

const WORLD_SYSTEMS = [
  'WorldPhysicsEngine', 'WorldWeatherEngine', 'WorldTerrainEngine',
  'WorldRenderingEngine', 'WorldAudioEngine', 'WorldNetworkEngine',
  'WorldEntitySystem', 'DroneFleet500', 'WorldOrchestrator',
];

const SUBSTRATES = [
  { name: 'ICP', role: 'primary on-chain' },
  { name: 'BLOCKCHAIN', role: 'multi-chain' },
  { name: 'EDGE', role: 'low-latency' },
  { name: 'CLOUD', role: 'scalable compute' },
  { name: 'PHANTOM', role: 'stealth/privacy' },
];

const BUILD_STATS = [
  { label: 'Motoko Canisters', value: '40+', detail: 'Compiled by scripts/nova' },
  { label: 'SERVITORES Workers', value: '70', detail: 'Across 7 divisions' },
  { label: 'Sovereign Terminals', value: '19', detail: 'AGI, Quantum, Neural, Defense, etc.' },
  { label: 'arXiv Papers', value: '5', detail: 'Mathematical proofs' },
  { label: 'Math Engines', value: '29', detail: 'CPL-F sovereign math' },
  { label: 'Sovereign Alpha AGIs', value: '10', detail: 'Autonomous intelligences' },
];

export function SystemsOverview() {
  const fmodelCategories = FMODEL_STATS ? Object.keys(FMODEL_REGISTRY || {}) : [];
  const phantomFamilies = PHANTOM_STATS ? Object.keys(PHANTOM_REGISTRY || {}) : [];

  return (
    <div style={STYLES.page}>
      {/* Header */}
      <header style={STYLES.header}>
        <h1 style={STYLES.title}>NOVA — Systems Overview</h1>
        <p style={STYLES.subtitle}>
          Sovereign organism: all intelligence, engines, meshes, AI, and build systems connected
        </p>
      </header>

      {/* Section 1: Intelligence Core */}
      <section style={STYLES.section}>
        <h2 style={STYLES.sectionTitle}>§1 — Intelligence Core</h2>
        <div style={STYLES.grid}>
          <div style={STYLES.card}>
            <div style={STYLES.cardTitle}>F-Model Registry</div>
            <div style={STYLES.stat}>{FMODEL_STATS?.total ?? '—'}</div>
            <p style={STYLES.cardText}>Total F-Models registered</p>
            <div style={{ marginTop: '0.75rem' }}>
              {fmodelCategories.map((cat) => (
                <span key={cat} style={STYLES.tag}>{cat}</span>
              ))}
            </div>
          </div>
          <div style={STYLES.card}>
            <div style={STYLES.cardTitle}>Phantom Registry</div>
            <div style={STYLES.stat}>{PHANTOM_STATS?.total ?? '—'}</div>
            <p style={STYLES.cardText}>Phantom model families</p>
            <div style={{ marginTop: '0.75rem' }}>
              {phantomFamilies.map((fam) => (
                <span key={fam} style={STYLES.tag}>{fam}</span>
              ))}
            </div>
          </div>
          <div style={STYLES.card}>
            <div style={STYLES.cardTitle}>Sovereign Primitives</div>
            <div style={STYLES.stat}>{PRIMITIVES?.length ?? 9}</div>
            <p style={STYLES.cardText}>Core organism primitives</p>
            <div style={{ marginTop: '0.75rem' }}>
              {(PRIMITIVES || []).map((p: { name: string; role: string }, i: number) => (
                <div key={i} style={{ marginBottom: '0.3rem' }}>
                  <span style={{ color: '#4af', fontSize: '0.8rem', fontWeight: 600 }}>{p.name}</span>
                  <span style={{ color: '#64748b', fontSize: '0.75rem', marginLeft: '0.5rem' }}>{p.role}</span>
                </div>
              ))}
            </div>
          </div>
        </div>
      </section>

      {/* Section 2: Engine Matrix */}
      <section style={STYLES.section}>
        <h2 style={STYLES.sectionTitle}>§2 — Engine Matrix</h2>
        <div style={STYLES.grid}>
          {ENGINE_MATRIX.map((engine) => (
            <div key={engine.name} style={STYLES.card}>
              <div style={STYLES.cardTitle}>{engine.name}</div>
              <p style={STYLES.cardText}>{engine.description}</p>
            </div>
          ))}
        </div>
        {/* Instantiation references for imported engines */}
        <div style={{ marginTop: '1rem', fontSize: '0.75rem', color: '#475569' }}>
          Active engines: {ChimeraTransformer?.name || 'ChimeraTransformer'} · {PhoenixEngine?.name || 'PhoenixEngine'} · {AtlasEngine?.name || 'AtlasEngine'}
        </div>
      </section>

      {/* Section 3: Organism Mesh */}
      <section style={STYLES.section}>
        <h2 style={STYLES.sectionTitle}>§3 — Organism Mesh (FusionOrganism)</h2>
        <div style={STYLES.meshContainer}>
          <div>
            <span style={{ color: '#a78bfa' }}>QuipuEngine</span>
            <span style={{ color: '#64748b' }}> (memory)</span>
            <span style={STYLES.meshArrow}> → </span>
            <span style={{ color: '#a78bfa' }}>QhapaqNanMesh</span>
            <span style={{ color: '#64748b' }}> (routing)</span>
            <span style={STYLES.meshArrow}> → </span>
            <span style={{ color: '#a78bfa' }}>TawantinsuyuHub</span>
            <span style={{ color: '#64748b' }}> (topology)</span>
          </div>
          <div>
            <span style={{ color: '#a78bfa' }}>BehavioralEcon</span>
            <span style={{ color: '#64748b' }}> (economics)</span>
            <span style={STYLES.meshArrow}> → </span>
            <span style={{ color: '#a78bfa' }}>Antifragility</span>
            <span style={{ color: '#64748b' }}> (resilience)</span>
            <span style={STYLES.meshArrow}> → </span>
            <span style={{ color: '#a78bfa' }}>FractalSov</span>
            <span style={{ color: '#64748b' }}> (coherence)</span>
          </div>
          <div>
            <span style={{ color: '#a78bfa' }}>LinguaCompressa</span>
            <span style={{ color: '#64748b' }}> (compression)</span>
            <span style={STYLES.meshArrow}> → </span>
            <span style={{ color: '#a78bfa' }}>TerraceBench</span>
            <span style={{ color: '#64748b' }}> (testing)</span>
          </div>
          <div style={{ marginTop: '1.5rem', color: '#4af', fontSize: '0.8rem' }}>
            ╰─── Self-sustaining loop: memory → routing → topology → economics → resilience → coherence → compression → testing → memory ───╯
          </div>
          <div style={{ marginTop: '0.75rem', color: '#64748b', fontSize: '0.8rem' }}>
            All 8 engines form a φ-weighted circular dependency mesh. Each engine feeds its output
            into the next, creating a self-sustaining organism loop that requires no external energy
            once bootstrapped. The mesh auto-heals via Antifragility when any node fails.
          </div>
        </div>
      </section>

      {/* Section 4: World Simulation */}
      <section style={STYLES.section}>
        <h2 style={STYLES.sectionTitle}>§4 — World Simulation</h2>
        <div style={STYLES.grid}>
          {WORLD_SYSTEMS.map((sys) => (
            <div key={sys} style={STYLES.card}>
              <div style={STYLES.cardTitle}>{sys}</div>
              <p style={STYLES.cardText}>
                {sys === 'WorldOrchestrator' && 'Master coordinator — synchronizes all world subsystems'}
                {sys === 'WorldPhysicsEngine' && 'Rigid body dynamics, collision detection, force fields'}
                {sys === 'WorldWeatherEngine' && 'Atmospheric simulation, climate patterns, seasonal cycles'}
                {sys === 'WorldTerrainEngine' && 'Procedural terrain generation, erosion, biome distribution'}
                {sys === 'WorldRenderingEngine' && 'Visual pipeline, LOD management, shader orchestration'}
                {sys === 'WorldAudioEngine' && 'Spatial audio, ambient synthesis, event-driven soundscapes'}
                {sys === 'WorldNetworkEngine' && 'Entity replication, state sync, latency compensation'}
                {sys === 'WorldEntitySystem' && 'ECS architecture, component queries, entity lifecycle'}
                {sys === 'DroneFleet500' && '500-unit autonomous drone swarm with φ-formation patterns'}
              </p>
            </div>
          ))}
        </div>
      </section>

      {/* Section 5: Build Systems */}
      <section style={STYLES.section}>
        <h2 style={STYLES.sectionTitle}>§5 — Build Systems</h2>
        <div style={STYLES.grid}>
          {BUILD_STATS.map((stat) => (
            <div key={stat.label} style={STYLES.card}>
              <div style={STYLES.stat}>{stat.value}</div>
              <div style={STYLES.cardTitle}>{stat.label}</div>
              <p style={STYLES.cardText}>{stat.detail}</p>
            </div>
          ))}
        </div>
      </section>

      {/* Section 6: Substrate Map */}
      <section style={STYLES.section}>
        <h2 style={STYLES.sectionTitle}>§6 — Substrate Map</h2>
        <div style={STYLES.substrateBar}>
          {SUBSTRATES.map((s) => (
            <div key={s.name} style={STYLES.substratePill}>
              <span style={{ color: '#4af', fontWeight: 600 }}>{s.name}</span>
              <span style={{ color: '#64748b', marginLeft: '0.5rem', fontSize: '0.8rem' }}>{s.role}</span>
            </div>
          ))}
        </div>
        <p style={{ textAlign: 'center', marginTop: '1.5rem', color: '#475569', fontSize: '0.85rem' }}>
          NOVA is Layer Zero — sovereign organism. All substrates serve the organism, not the reverse.
        </p>
      </section>
    </div>
  );
}
