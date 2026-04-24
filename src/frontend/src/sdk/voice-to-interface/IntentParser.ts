// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ═══════════════════════════════════════════════════════════════════════════════
// Module: IntentParser — Voice Transcript → Structured UI Intent
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
//
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// Natural language → structured intent. No external NLP dependencies.
// Pattern matching with PHI-weighted confidence scoring.
// ═══════════════════════════════════════════════════════════════════════════════

import type {
  VoiceIntent,
  IntentAction,
  UIComponentKind,
  ChartKind,
  LayoutStrategy,
  DataDomain,
  ColorTheme,
} from './types';
import { PHI_INV } from './types';

// ═══════════════════════════════════════════════════════════════════════════════
// PATTERN DICTIONARIES — Keyword → Intent mappings
// ═══════════════════════════════════════════════════════════════════════════════

const ACTION_PATTERNS: Array<{ pattern: RegExp; action: IntentAction }> = [
  { pattern: /^(show|display|give|open|pull up|bring up|present|view)/i,   action: 'SHOW' },
  { pattern: /^(create|build|make|generate|construct|spawn)/i,             action: 'CREATE' },
  { pattern: /^(add|insert|append|include|attach)/i,                       action: 'ADD' },
  { pattern: /^(remove|delete|destroy|hide|close|dismiss|clear)/i,         action: 'REMOVE' },
  { pattern: /^(update|refresh|reload|sync|renew)/i,                       action: 'UPDATE' },
  { pattern: /^(clear|reset|wipe|clean)/i,                                 action: 'CLEAR' },
  { pattern: /^(resize|scale|expand|shrink|enlarge)/i,                     action: 'RESIZE' },
  { pattern: /^(rearrange|reorganize|reorder|shuffle|move)/i,              action: 'REARRANGE' },
];

const COMPONENT_PATTERNS: Array<{ pattern: RegExp; kind: UIComponentKind; chartKind?: ChartKind }> = [
  // Dashboard must come before 'board'
  { pattern: /dashboard/i,                    kind: 'DASHBOARD' },
  // Charts — specific types first
  { pattern: /bar\s*chart/i,                  kind: 'CHART', chartKind: 'BAR' },
  { pattern: /line\s*(chart|graph)/i,         kind: 'CHART', chartKind: 'LINE' },
  { pattern: /pie\s*(chart|graph)/i,          kind: 'CHART', chartKind: 'PIE' },
  { pattern: /area\s*(chart|graph)/i,         kind: 'CHART', chartKind: 'AREA' },
  { pattern: /scatter\s*(plot|chart)/i,       kind: 'CHART', chartKind: 'SCATTER' },
  { pattern: /gauge/i,                        kind: 'CHART', chartKind: 'GAUGE' },
  { pattern: /heat\s*map/i,                   kind: 'CHART', chartKind: 'HEATMAP' },
  { pattern: /radar\s*(chart|graph)/i,        kind: 'CHART', chartKind: 'RADAR' },
  { pattern: /chart|graph|plot|visual/i,      kind: 'CHART', chartKind: 'BAR' },
  // Table
  { pattern: /table|spreadsheet|grid\s*view/i, kind: 'TABLE' },
  // Form
  { pattern: /form|input|editor/i,            kind: 'FORM' },
  // Card
  { pattern: /card|tile|widget/i,             kind: 'CARD' },
  // List
  { pattern: /list|feed|stream/i,             kind: 'LIST' },
  // Metric
  { pattern: /metric|kpi|number|counter|stat/i, kind: 'METRIC' },
  // Timeline
  { pattern: /timeline|history|log/i,         kind: 'TIMELINE' },
  // Terminal
  { pattern: /terminal|console|shell/i,       kind: 'TERMINAL' },
  // Map
  { pattern: /map|territory|atlas/i,          kind: 'MAP' },
  // Panel
  { pattern: /panel|pane|section/i,           kind: 'PANEL' },
  // Alert
  { pattern: /alert|warning|notification/i,   kind: 'ALERT' },
  // Status
  { pattern: /status|health|monitor/i,        kind: 'STATUS' },
  // Grid
  { pattern: /grid|layout/i,                  kind: 'GRID' },
];

const DATA_DOMAIN_PATTERNS: Array<{ pattern: RegExp; domain: DataDomain }> = [
  { pattern: /sales|revenue|profit|customer|conversion|pipeline|deal/i,     domain: 'SALES' },
  { pattern: /defense|threat|security|attack|shield|vael|aegis/i,          domain: 'DEFENSE' },
  { pattern: /neural|brain|neuron|synapse|cortex|cognitive/i,               domain: 'NEURAL' },
  { pattern: /quantum|qubit|entangle|coherence|fidelity/i,                  domain: 'QUANTUM' },
  { pattern: /economic|forma|token|treasury|reserve|yield/i,                domain: 'ECONOMIC' },
  { pattern: /swarm|drone|squadron|fleet|kuramoto/i,                        domain: 'SWARM' },
  { pattern: /governance|law|doctrine|compliance|sovereignty/i,             domain: 'GOVERNANCE' },
  { pattern: /memory|temple|hippocampal|replay|recall/i,                    domain: 'MEMORY' },
  { pattern: /frequency|hz|oscillat|schumann|band/i,                        domain: 'FREQUENCY' },
  { pattern: /organism|heartbeat|pulse|arousal|emergence/i,                 domain: 'ORGANISM' },
  { pattern: /coherence|sync|phase|order\s*parameter/i,                     domain: 'COHERENCE' },
];

const THEME_PATTERNS: Array<{ pattern: RegExp; theme: ColorTheme }> = [
  { pattern: /sovereign|royal|gold/i,                                       theme: 'SOVEREIGN' },
  { pattern: /defense|military|red|war/i,                                   theme: 'DEFENSE' },
  { pattern: /neural|brain|purple/i,                                        theme: 'NEURAL' },
  { pattern: /economic|money|green|financial/i,                             theme: 'ECONOMIC' },
  { pattern: /quantum|deep\s*purple/i,                                      theme: 'QUANTUM' },
  { pattern: /organic|natural|earth/i,                                      theme: 'ORGANIC' },
  { pattern: /alert|warning|danger/i,                                       theme: 'ALERT' },
];

const LAYOUT_PATTERNS: Array<{ pattern: RegExp; layout: LayoutStrategy }> = [
  { pattern: /side\s*by\s*side|horizontal|left.*right/i,                    layout: 'SPLIT_HORIZONTAL' },
  { pattern: /top.*bottom|vertical|stack/i,                                 layout: 'SPLIT_VERTICAL' },
  { pattern: /masonry|pinterest/i,                                          layout: 'GRID_MASONRY' },
  { pattern: /row|horizontal\s*list/i,                                      layout: 'FLEX_ROW' },
  { pattern: /column|vertical\s*list/i,                                     layout: 'FLEX_COLUMN' },
  { pattern: /single|full\s*screen|one/i,                                   layout: 'SINGLE' },
];

// ═══════════════════════════════════════════════════════════════════════════════
// INTENT PARSER CLASS
// ═══════════════════════════════════════════════════════════════════════════════

export class IntentParser {

  /** Parse a voice transcript into a structured intent */
  parse(transcript: string): VoiceIntent {
    const lower = transcript.toLowerCase().trim();
    let matchCount = 0;

    // 1. Extract action
    const action = this.extractAction(lower);
    if (action !== 'SHOW') matchCount++; // non-default = matched

    // 2. Extract component kind
    const { kind: componentKind, chartKind } = this.extractComponent(lower);
    if (componentKind !== 'PANEL') matchCount++;

    // 3. Extract data domain
    const dataDomain = this.extractDomain(lower);
    if (dataDomain !== 'CUSTOM') matchCount++;

    // 4. Extract layout
    const layout = this.extractLayout(lower, componentKind);
    if (layout !== 'GRID_AUTO') matchCount++;

    // 5. Extract theme
    const theme = this.extractTheme(lower, dataDomain);

    // 6. Extract data fields
    const dataFields = this.extractDataFields(lower, dataDomain);

    // 7. Extract count
    const count = this.extractCount(lower);

    // 8. Generate title
    const title = this.generateTitle(componentKind, dataDomain, chartKind);

    // Confidence: PHI_INV base + bonus per match, capped at 1.0
    const parseConfidence = Math.min(1.0, PHI_INV + matchCount * 0.1);

    return {
      rawTranscript: transcript,
      action,
      componentKind,
      chartKind,
      layout,
      dataDomain,
      dataFields,
      title,
      theme,
      count,
      parseConfidence,
      timestamp: Date.now(),
    };
  }

  // ─── Extraction methods ──────────────────────────────────────────────────

  private extractAction(text: string): IntentAction {
    for (const { pattern, action } of ACTION_PATTERNS) {
      if (pattern.test(text)) return action;
    }
    return 'SHOW'; // Default: show
  }

  private extractComponent(text: string): { kind: UIComponentKind; chartKind?: ChartKind } {
    for (const { pattern, kind, chartKind } of COMPONENT_PATTERNS) {
      if (pattern.test(text)) return { kind, chartKind };
    }
    // If no specific component mentioned but has data domain → default to PANEL
    return { kind: 'PANEL' };
  }

  private extractDomain(text: string): DataDomain {
    for (const { pattern, domain } of DATA_DOMAIN_PATTERNS) {
      if (pattern.test(text)) return domain;
    }
    return 'CUSTOM';
  }

  private extractLayout(text: string, componentKind: UIComponentKind): LayoutStrategy {
    for (const { pattern, layout } of LAYOUT_PATTERNS) {
      if (pattern.test(text)) return layout;
    }
    // Intelligent defaults based on component kind
    switch (componentKind) {
      case 'DASHBOARD': return 'DASHBOARD_GRID';
      case 'TABLE':     return 'SINGLE';
      case 'FORM':      return 'SINGLE';
      case 'TERMINAL':  return 'SINGLE';
      case 'METRIC':    return 'FLEX_ROW';
      case 'CARD':      return 'GRID_AUTO';
      default:          return 'GRID_AUTO';
    }
  }

  private extractTheme(text: string, domain: DataDomain): ColorTheme {
    for (const { pattern, theme } of THEME_PATTERNS) {
      if (pattern.test(text)) return theme;
    }
    // Domain-based default themes
    const domainThemes: Partial<Record<DataDomain, ColorTheme>> = {
      DEFENSE: 'DEFENSE',
      NEURAL: 'NEURAL',
      ECONOMIC: 'ECONOMIC',
      QUANTUM: 'QUANTUM',
    };
    return domainThemes[domain] ?? 'DEFAULT';
  }

  private extractDataFields(text: string, domain: DataDomain): string[] {
    const fields: string[] = [];
    // Domain-specific field extraction
    const fieldPatterns: Partial<Record<DataDomain, Array<{ pattern: RegExp; field: string }>>> = {
      SALES: [
        { pattern: /revenue/i, field: 'revenue' },
        { pattern: /profit/i, field: 'profit' },
        { pattern: /customer/i, field: 'customers' },
        { pattern: /conversion/i, field: 'conversionRate' },
        { pattern: /pipeline/i, field: 'pipeline' },
        { pattern: /deal/i, field: 'deals' },
      ],
      ORGANISM: [
        { pattern: /coherence/i, field: 'coherence' },
        { pattern: /heartbeat|beat/i, field: 'beat' },
        { pattern: /arousal/i, field: 'arousal' },
        { pattern: /drift/i, field: 'drift' },
        { pattern: /emergence/i, field: 'emergence' },
        { pattern: /energy/i, field: 'energy' },
      ],
      DEFENSE: [
        { pattern: /threat/i, field: 'threatLevel' },
        { pattern: /shield/i, field: 'shieldStrength' },
        { pattern: /anomal/i, field: 'anomalyScore' },
        { pattern: /trust/i, field: 'trustScore' },
      ],
      SWARM: [
        { pattern: /drone/i, field: 'droneCount' },
        { pattern: /coherence/i, field: 'swarmCoherence' },
        { pattern: /phase/i, field: 'meanPhase' },
        { pattern: /squadron/i, field: 'squadronCount' },
      ],
      NEURAL: [
        { pattern: /dopamine/i, field: 'dopamine' },
        { pattern: /cortisol/i, field: 'cortisol' },
        { pattern: /norepinephrine/i, field: 'norepinephrine' },
        { pattern: /oxytocin/i, field: 'oxytocin' },
        { pattern: /serotonin/i, field: 'serotonin' },
      ],
      ECONOMIC: [
        { pattern: /forma/i, field: 'formaBalance' },
        { pattern: /treasury/i, field: 'treasury' },
        { pattern: /reserve/i, field: 'reserve' },
        { pattern: /yield/i, field: 'yieldRate' },
      ],
    };

    const domainFields = fieldPatterns[domain];
    if (domainFields) {
      for (const { pattern, field } of domainFields) {
        if (pattern.test(text)) {
          fields.push(field);
        }
      }
    }

    // If no specific fields matched, provide domain defaults
    if (fields.length === 0) {
      const defaults: Partial<Record<DataDomain, string[]>> = {
        SALES: ['revenue', 'profit', 'customers', 'conversionRate'],
        ORGANISM: ['coherence', 'beat', 'arousal', 'emergence'],
        DEFENSE: ['threatLevel', 'shieldStrength', 'anomalyScore'],
        SWARM: ['droneCount', 'swarmCoherence', 'meanPhase'],
        NEURAL: ['dopamine', 'cortisol', 'norepinephrine', 'oxytocin'],
        ECONOMIC: ['formaBalance', 'treasury', 'reserve'],
        QUANTUM: ['fidelity', 'entanglement', 'coherence'],
        GOVERNANCE: ['complianceScore', 'lawsDriftCount', 'sovereigntyIndex'],
        MEMORY: ['totalMemories', 'compressionRatio', 'hebbianStrength'],
        FREQUENCY: ['orderParameter', 'meanFrequency', 'bandCoherence'],
        COHERENCE: ['kuramotoR', 'meanPhase', 'drift'],
        CUSTOM: ['value1', 'value2', 'value3'],
      };
      fields.push(...(defaults[domain] ?? ['value']));
    }

    return fields;
  }

  private extractCount(text: string): number | undefined {
    // Look for numbers in the text
    const numMatch = text.match(/\b(\d+)\b/);
    if (numMatch) return parseInt(numMatch[1], 10);
    // Word numbers
    const wordNums: Record<string, number> = {
      one: 1, two: 2, three: 3, four: 4, five: 5,
      six: 6, seven: 7, eight: 8, nine: 9, ten: 10,
      twelve: 12, twenty: 20, fifty: 50,
    };
    for (const [word, num] of Object.entries(wordNums)) {
      if (text.includes(word)) return num;
    }
    return undefined;
  }

  private toTitleCase(text: string): string {
    return text.charAt(0).toUpperCase() + text.slice(1).toLowerCase();
  }

  private generateTitle(
    kind: UIComponentKind,
    domain: DataDomain,
    chartKind?: ChartKind,
  ): string {
    const domainLabel = domain === 'CUSTOM' ? 'Data' : this.toTitleCase(domain);
    const kindLabel = this.toTitleCase(kind).replace('_', ' ');
    if (chartKind) {
      const chartLabel = this.toTitleCase(chartKind);
      return `${domainLabel} ${chartLabel} Chart`;
    }
    return `${domainLabel} ${kindLabel}`;
  }
}
