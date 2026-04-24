// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ═══════════════════════════════════════════════════════════════════════════════
// Module: DOMConstructor — Intent → Live DOM (CSS Grid/Flexbox + Web Animations)
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
//
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// Dynamic DOM construction: takes a parsed intent, builds live UI elements
// using CSS Grid/Flexbox auto-layout and Web Animations API.
// No external UI library — pure sovereign DOM construction.
// ═══════════════════════════════════════════════════════════════════════════════

import type {
  VoiceIntent,
  UIComponentDescriptor,
  LayoutConfig,
  DataBinding,
  AnimationConfig,
  UIComponentKind,
  ChartKind,
  ColorTheme,
  EntranceAnimation,
  LayoutStrategy,
  DataDomain,
} from './types';
import { ANIMATION_DURATION_MS, GRID_GAP_PX, PHI_INV } from './types';

// ═══════════════════════════════════════════════════════════════════════════════
// COLOR THEME PALETTES
// ═══════════════════════════════════════════════════════════════════════════════

interface ThemePalette {
  bg: string;
  bgCard: string;
  border: string;
  text: string;
  textSecondary: string;
  accent: string;
  accentDim: string;
  barColor: string;
  gradientStart: string;
  gradientEnd: string;
}

const THEME_PALETTES: Record<ColorTheme, ThemePalette> = {
  DEFAULT:    { bg: '#040b18', bgCard: '#0a1628', border: '#1b3857', text: '#cfe8ff', textSecondary: '#6a9cc7', accent: '#3b82f6', accentDim: '#1e3a5f', barColor: '#3b82f6', gradientStart: '#1e3a5f', gradientEnd: '#3b82f6' },
  SOVEREIGN:  { bg: '#0a0a14', bgCard: '#12122a', border: '#2d2d5e', text: '#e8d5aa', textSecondary: '#a89060', accent: '#d4a843', accentDim: '#4a3c1a', barColor: '#d4a843', gradientStart: '#4a3c1a', gradientEnd: '#d4a843' },
  DEFENSE:    { bg: '#140808', bgCard: '#1e0f0f', border: '#5c2020', text: '#ffcccc', textSecondary: '#cc8888', accent: '#ef4444', accentDim: '#4a1616', barColor: '#ef4444', gradientStart: '#4a1616', gradientEnd: '#ef4444' },
  NEURAL:     { bg: '#0a0814', bgCard: '#150f28', border: '#3d2d6e', text: '#d5ccff', textSecondary: '#9080bb', accent: '#a855f7', accentDim: '#3b1f5e', barColor: '#a855f7', gradientStart: '#3b1f5e', gradientEnd: '#a855f7' },
  ECONOMIC:   { bg: '#081408', bgCard: '#0f1e0f', border: '#205c20', text: '#ccffcc', textSecondary: '#88cc88', accent: '#22c55e', accentDim: '#164a16', barColor: '#22c55e', gradientStart: '#164a16', gradientEnd: '#22c55e' },
  QUANTUM:    { bg: '#0e0614', bgCard: '#1a0e28', border: '#4e2d7e', text: '#e0ccff', textSecondary: '#a080cc', accent: '#c084fc', accentDim: '#4e1f7e', barColor: '#c084fc', gradientStart: '#4e1f7e', gradientEnd: '#c084fc' },
  ORGANIC:    { bg: '#141008', bgCard: '#1e1a0f', border: '#5c4c20', text: '#ffe8cc', textSecondary: '#ccb088', accent: '#d97706', accentDim: '#4a3810', barColor: '#d97706', gradientStart: '#4a3810', gradientEnd: '#d97706' },
  ALERT:      { bg: '#141008', bgCard: '#1e160a', border: '#7e5c10', text: '#ffeecc', textSecondary: '#ccaa66', accent: '#f59e0b', accentDim: '#5c4010', barColor: '#f59e0b', gradientStart: '#5c4010', gradientEnd: '#f59e0b' },
};

// ═══════════════════════════════════════════════════════════════════════════════
// DOM CONSTRUCTOR CLASS
// ═══════════════════════════════════════════════════════════════════════════════

let componentIdCounter = 0;

export class DOMConstructor {
  private mountTarget: HTMLElement;

  constructor(mountTarget: HTMLElement) {
    this.mountTarget = mountTarget;
  }

  // ─── Public API ──────────────────────────────────────────────────────────

  /** Build a UI component from a parsed intent and mount it */
  build(intent: VoiceIntent): UIComponentDescriptor {
    const descriptor = this.createDescriptor(intent);
    const element = this.renderDescriptor(descriptor);
    descriptor.element = element;

    // Mount into the target
    this.mountTarget.appendChild(element);

    // Animate entrance
    this.animateEntrance(element, descriptor.animation);

    return descriptor;
  }

  /** Remove a component by ID */
  remove(id: string): boolean {
    const el = this.mountTarget.querySelector(`[data-vtui-id="${id}"]`);
    if (!el) return false;

    // Exit animation
    el.animate(
      [
        { opacity: 1, transform: 'scale(1)' },
        { opacity: 0, transform: 'scale(0.95)' },
      ],
      { duration: 300, easing: 'ease-in', fill: 'forwards' },
    ).onfinish = () => el.remove();

    return true;
  }

  /** Clear all components */
  clear(): void {
    const children = Array.from(this.mountTarget.querySelectorAll('[data-vtui-id]'));
    for (const child of children) {
      child.remove();
    }
  }

  /** Update mount target */
  setMountTarget(target: HTMLElement): void {
    this.mountTarget = target;
  }

  // ─── Descriptor Creation ─────────────────────────────────────────────────

  private createDescriptor(intent: VoiceIntent): UIComponentDescriptor {
    const id = `vtui-${++componentIdCounter}-${Date.now().toString(36)}`;
    const palette = THEME_PALETTES[intent.theme];
    const layout = this.createLayout(intent);
    const dataBinding = this.createDataBinding(intent);
    const animation = this.createAnimation(intent.componentKind);
    const styles = this.createStyles(intent, palette);
    const children = this.createChildren(intent, palette);

    return {
      id,
      kind: intent.componentKind,
      chartKind: intent.chartKind,
      title: intent.title,
      styles,
      layout,
      dataBinding,
      animation,
      children,
    };
  }

  private createLayout(intent: VoiceIntent): LayoutConfig {
    const columns = intent.count ?? this.defaultColumns(intent.componentKind);
    return {
      strategy: intent.layout,
      columns,
      rows: undefined,
      gap: GRID_GAP_PX,
      padding: GRID_GAP_PX,
      minWidth: '280px',
      minHeight: '200px',
    };
  }

  private defaultColumns(kind: UIComponentKind): number {
    switch (kind) {
      case 'DASHBOARD': return 3;
      case 'METRIC':    return 4;
      case 'CARD':      return 3;
      case 'GRID':      return 3;
      default:          return 1;
    }
  }

  private createDataBinding(intent: VoiceIntent): DataBinding {
    return {
      domain: intent.dataDomain,
      fields: intent.dataFields,
      refreshIntervalMs: 3000,
      transform: 'RAW',
    };
  }

  private createAnimation(kind: UIComponentKind): AnimationConfig {
    const entranceMap: Partial<Record<UIComponentKind, EntranceAnimation>> = {
      DASHBOARD: 'FADE_IN',
      CHART: 'SCALE_UP',
      TABLE: 'SLIDE_UP',
      METRIC: 'SLIDE_LEFT',
      CARD: 'SCALE_UP',
      ALERT: 'SLIDE_UP',
      TERMINAL: 'FADE_IN',
    };
    return {
      entrance: entranceMap[kind] ?? 'FADE_IN',
      durationMs: ANIMATION_DURATION_MS,
      easing: 'cubic-bezier(0.16, 1, 0.3, 1)', // Ease-out expo
      delay: 0,
    };
  }

  private createStyles(intent: VoiceIntent, p: ThemePalette): Record<string, string> {
    const base: Record<string, string> = {
      background: p.bgCard,
      border: `1px solid ${p.border}`,
      borderRadius: '8px',
      color: p.text,
      fontFamily: "'SF Mono', 'Fira Code', 'Cascadia Code', monospace",
      fontSize: '13px',
      overflow: 'hidden',
    };

    // Layout-specific styles
    switch (intent.layout) {
      case 'GRID_AUTO':
      case 'DASHBOARD_GRID':
        base.display = 'grid';
        base.gridTemplateColumns = `repeat(auto-fit, minmax(280px, 1fr))`;
        base.gap = `${GRID_GAP_PX}px`;
        base.padding = `${GRID_GAP_PX}px`;
        break;
      case 'FLEX_ROW':
        base.display = 'flex';
        base.flexDirection = 'row';
        base.flexWrap = 'wrap';
        base.gap = `${GRID_GAP_PX}px`;
        base.padding = `${GRID_GAP_PX}px`;
        break;
      case 'FLEX_COLUMN':
        base.display = 'flex';
        base.flexDirection = 'column';
        base.gap = `${GRID_GAP_PX}px`;
        base.padding = `${GRID_GAP_PX}px`;
        break;
      case 'SPLIT_HORIZONTAL':
        base.display = 'grid';
        base.gridTemplateColumns = '1fr 1fr';
        base.gap = `${GRID_GAP_PX}px`;
        base.padding = `${GRID_GAP_PX}px`;
        break;
      case 'SPLIT_VERTICAL':
        base.display = 'grid';
        base.gridTemplateRows = '1fr 1fr';
        base.gap = `${GRID_GAP_PX}px`;
        base.padding = `${GRID_GAP_PX}px`;
        break;
      case 'SINGLE':
        base.padding = `${GRID_GAP_PX}px`;
        break;
    }

    return base;
  }

  private createChildren(
    intent: VoiceIntent,
    palette: ThemePalette,
  ): UIComponentDescriptor[] {
    // For dashboards, create child cards for each data field
    if (intent.componentKind === 'DASHBOARD') {
      return intent.dataFields.map((field, i) => {
        const childId = `vtui-child-${++componentIdCounter}-${Date.now().toString(36)}`;
        return {
          id: childId,
          kind: 'METRIC' as UIComponentKind,
          title: this.formatFieldLabel(field),
          styles: {
            background: palette.bgCard,
            border: `1px solid ${palette.border}`,
            borderRadius: '6px',
            padding: '16px',
            display: 'flex',
            flexDirection: 'column',
            gap: '8px',
          },
          layout: { strategy: 'SINGLE' as LayoutStrategy, gap: 8, padding: 12 },
          dataBinding: {
            domain: intent.dataDomain,
            fields: [field],
            refreshIntervalMs: 3000,
          },
          animation: {
            entrance: 'SCALE_UP' as EntranceAnimation,
            durationMs: ANIMATION_DURATION_MS,
            easing: 'cubic-bezier(0.16, 1, 0.3, 1)',
            delay: i * 100,
          },
          children: [],
        };
      });
    }

    return [];
  }

  // ─── DOM Rendering ───────────────────────────────────────────────────────

  private renderDescriptor(descriptor: UIComponentDescriptor): HTMLElement {
    const wrapper = document.createElement('div');
    wrapper.setAttribute('data-vtui-id', descriptor.id);
    wrapper.style.marginBottom = `${GRID_GAP_PX}px`;

    // Header bar
    const header = document.createElement('div');
    Object.assign(header.style, {
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'space-between',
      padding: '10px 14px',
      borderBottom: `1px solid ${descriptor.styles.border?.replace('1px solid ', '') ?? '#1b3857'}`,
      fontSize: '12px',
      letterSpacing: '0.08em',
      textTransform: 'uppercase',
      color: descriptor.styles.color ?? '#cfe8ff',
    });

    const titleSpan = document.createElement('span');
    titleSpan.textContent = descriptor.title;
    header.appendChild(titleSpan);

    const kindBadge = document.createElement('span');
    kindBadge.textContent = descriptor.kind;
    Object.assign(kindBadge.style, {
      fontSize: '9px',
      padding: '2px 6px',
      borderRadius: '3px',
      background: 'rgba(59, 130, 246, 0.2)',
      color: 'rgba(147, 197, 253, 0.8)',
    });
    header.appendChild(kindBadge);

    wrapper.appendChild(header);

    // Body container
    const body = document.createElement('div');
    for (const [key, value] of Object.entries(descriptor.styles)) {
      (body.style as Record<string, string>)[key] = value;
    }
    wrapper.appendChild(body);

    // Render based on component kind
    switch (descriptor.kind) {
      case 'DASHBOARD':
        this.renderDashboard(body, descriptor);
        break;
      case 'CHART':
        this.renderChart(body, descriptor);
        break;
      case 'TABLE':
        this.renderTable(body, descriptor);
        break;
      case 'METRIC':
        this.renderMetric(body, descriptor);
        break;
      case 'LIST':
        this.renderList(body, descriptor);
        break;
      case 'STATUS':
        this.renderStatus(body, descriptor);
        break;
      case 'TERMINAL':
        this.renderTerminal(body, descriptor);
        break;
      case 'ALERT':
        this.renderAlert(body, descriptor);
        break;
      case 'TIMELINE':
        this.renderTimeline(body, descriptor);
        break;
      case 'CARD':
        this.renderCard(body, descriptor);
        break;
      default:
        this.renderPanel(body, descriptor);
        break;
    }

    // Apply wrapper styles
    Object.assign(wrapper.style, {
      background: descriptor.styles.background,
      border: descriptor.styles.border,
      borderRadius: descriptor.styles.borderRadius ?? '8px',
      color: descriptor.styles.color,
      fontFamily: descriptor.styles.fontFamily,
      overflow: 'hidden',
    });

    return wrapper;
  }

  // ─── Component Renderers ─────────────────────────────────────────────────

  private renderDashboard(container: HTMLElement, desc: UIComponentDescriptor): void {
    for (const child of desc.children) {
      const childEl = this.renderMetricCard(child);
      container.appendChild(childEl);
    }
  }

  private renderMetricCard(desc: UIComponentDescriptor): HTMLElement {
    const card = document.createElement('div');
    for (const [key, value] of Object.entries(desc.styles)) {
      (card.style as Record<string, string>)[key] = value;
    }

    const label = document.createElement('div');
    Object.assign(label.style, {
      fontSize: '10px',
      textTransform: 'uppercase',
      letterSpacing: '0.1em',
      opacity: '0.7',
    });
    label.textContent = desc.title;
    card.appendChild(label);

    const value = document.createElement('div');
    Object.assign(value.style, {
      fontSize: '28px',
      fontWeight: '700',
      letterSpacing: '-0.02em',
    });
    // Placeholder value — will be filled by runtime wire
    value.textContent = '—';
    value.setAttribute('data-vtui-field', desc.dataBinding.fields[0] ?? '');
    card.appendChild(value);

    const bar = document.createElement('div');
    Object.assign(bar.style, {
      height: '3px',
      borderRadius: '2px',
      background: 'rgba(59, 130, 246, 0.3)',
      marginTop: '8px',
      overflow: 'hidden',
    });
    const fill = document.createElement('div');
    Object.assign(fill.style, {
      width: `${(PHI_INV * 100).toFixed(0)}%`,
      height: '100%',
      borderRadius: '2px',
      background: 'rgba(59, 130, 246, 0.8)',
      transition: 'width 0.6s ease',
    });
    bar.appendChild(fill);
    card.appendChild(bar);

    return card;
  }

  private renderChart(container: HTMLElement, desc: UIComponentDescriptor): void {
    // CSS-only chart rendering (no external chart libs)
    const chartArea = document.createElement('div');
    Object.assign(chartArea.style, {
      display: 'flex',
      alignItems: 'flex-end',
      gap: '4px',
      padding: '16px',
      height: '200px',
    });

    const barCount = desc.dataBinding.fields.length || 5;
    const BAR_BASE_HEIGHT = 30;
    const BAR_OSCILLATION = 40;
    const BAR_OFFSET = 40;
    for (let i = 0; i < barCount; i++) {
      const bar = document.createElement('div');
      const height = BAR_BASE_HEIGHT + Math.floor(Math.sin(i * PHI_INV) * BAR_OSCILLATION + BAR_OFFSET);
      Object.assign(bar.style, {
        flex: '1',
        height: `${height}%`,
        background: `linear-gradient(to top, rgba(59, 130, 246, 0.3), rgba(59, 130, 246, 0.8))`,
        borderRadius: '4px 4px 0 0',
        transition: 'height 0.6s ease',
        minWidth: '20px',
      });
      bar.setAttribute('data-vtui-field', desc.dataBinding.fields[i] ?? `field${i}`);
      chartArea.appendChild(bar);
    }

    container.appendChild(chartArea);

    // Labels
    const labels = document.createElement('div');
    Object.assign(labels.style, {
      display: 'flex',
      gap: '4px',
      padding: '0 16px 12px',
      fontSize: '9px',
      opacity: '0.6',
      textTransform: 'uppercase',
    });
    for (let i = 0; i < barCount; i++) {
      const lbl = document.createElement('div');
      lbl.style.flex = '1';
      lbl.style.textAlign = 'center';
      lbl.textContent = this.formatFieldLabel(desc.dataBinding.fields[i] ?? `F${i + 1}`);
      labels.appendChild(lbl);
    }
    container.appendChild(labels);
  }

  private renderTable(container: HTMLElement, desc: UIComponentDescriptor): void {
    const table = document.createElement('table');
    Object.assign(table.style, {
      width: '100%',
      borderCollapse: 'collapse',
      fontSize: '12px',
    });

    // Header
    const thead = document.createElement('thead');
    const headerRow = document.createElement('tr');
    for (const field of desc.dataBinding.fields) {
      const th = document.createElement('th');
      Object.assign(th.style, {
        textAlign: 'left',
        padding: '8px 12px',
        borderBottom: '1px solid rgba(59, 130, 246, 0.2)',
        fontSize: '10px',
        textTransform: 'uppercase',
        letterSpacing: '0.08em',
        opacity: '0.7',
      });
      th.textContent = this.formatFieldLabel(field);
      headerRow.appendChild(th);
    }
    thead.appendChild(headerRow);
    table.appendChild(thead);

    // Body — placeholder rows
    const tbody = document.createElement('tbody');
    tbody.setAttribute('data-vtui-table-body', 'true');
    for (let r = 0; r < 5; r++) {
      const row = document.createElement('tr');
      for (const _field of desc.dataBinding.fields) {
        const td = document.createElement('td');
        Object.assign(td.style, {
          padding: '6px 12px',
          borderBottom: '1px solid rgba(27, 56, 87, 0.3)',
        });
        td.textContent = '—';
        row.appendChild(td);
      }
      tbody.appendChild(row);
    }
    table.appendChild(tbody);
    container.appendChild(table);
  }

  private renderMetric(container: HTMLElement, desc: UIComponentDescriptor): void {
    Object.assign(container.style, {
      display: 'flex',
      flexDirection: 'column',
      alignItems: 'center',
      justifyContent: 'center',
      padding: '24px',
      gap: '8px',
    });

    const value = document.createElement('div');
    Object.assign(value.style, { fontSize: '36px', fontWeight: '700' });
    value.textContent = '—';
    value.setAttribute('data-vtui-field', desc.dataBinding.fields[0] ?? '');
    container.appendChild(value);

    const label = document.createElement('div');
    Object.assign(label.style, {
      fontSize: '10px',
      textTransform: 'uppercase',
      letterSpacing: '0.1em',
      opacity: '0.6',
    });
    label.textContent = this.formatFieldLabel(desc.dataBinding.fields[0] ?? 'value');
    container.appendChild(label);
  }

  private renderList(container: HTMLElement, desc: UIComponentDescriptor): void {
    Object.assign(container.style, { padding: '12px' });
    const ul = document.createElement('ul');
    Object.assign(ul.style, {
      listStyle: 'none',
      margin: '0',
      padding: '0',
      display: 'flex',
      flexDirection: 'column',
      gap: '6px',
    });

    for (const field of desc.dataBinding.fields) {
      const li = document.createElement('li');
      Object.assign(li.style, {
        display: 'flex',
        justifyContent: 'space-between',
        padding: '8px 12px',
        borderRadius: '4px',
        background: 'rgba(59, 130, 246, 0.05)',
        border: '1px solid rgba(27, 56, 87, 0.3)',
      });
      const nameSpan = document.createElement('span');
      nameSpan.textContent = this.formatFieldLabel(field);
      nameSpan.style.opacity = '0.7';
      li.appendChild(nameSpan);

      const valSpan = document.createElement('span');
      valSpan.textContent = '—';
      valSpan.setAttribute('data-vtui-field', field);
      li.appendChild(valSpan);

      ul.appendChild(li);
    }
    container.appendChild(ul);
  }

  private renderStatus(container: HTMLElement, desc: UIComponentDescriptor): void {
    Object.assign(container.style, {
      display: 'flex',
      flexWrap: 'wrap',
      gap: '12px',
      padding: '16px',
    });

    for (const field of desc.dataBinding.fields) {
      const indicator = document.createElement('div');
      Object.assign(indicator.style, {
        display: 'flex',
        alignItems: 'center',
        gap: '8px',
        padding: '8px 14px',
        borderRadius: '20px',
        background: 'rgba(34, 197, 94, 0.1)',
        border: '1px solid rgba(34, 197, 94, 0.3)',
        fontSize: '11px',
      });
      const dot = document.createElement('span');
      Object.assign(dot.style, {
        width: '8px',
        height: '8px',
        borderRadius: '50%',
        background: '#22c55e',
      });
      indicator.appendChild(dot);
      const label = document.createElement('span');
      label.textContent = this.formatFieldLabel(field);
      indicator.appendChild(label);
      container.appendChild(indicator);
    }
  }

  private renderTerminal(container: HTMLElement, desc: UIComponentDescriptor): void {
    Object.assign(container.style, {
      padding: '12px',
      fontFamily: "'SF Mono', 'Fira Code', monospace",
      fontSize: '12px',
      lineHeight: '1.6',
      maxHeight: '300px',
      overflowY: 'auto',
    });

    const lines = [
      `> VOICE-TO-INTERFACE SDK v1.0`,
      `> Domain: ${desc.dataBinding.domain}`,
      `> Fields: ${desc.dataBinding.fields.join(', ')}`,
      `> Status: ACTIVE`,
      `> Runtime: WIRED`,
      `> ─────────────────────`,
    ];

    for (const line of lines) {
      const div = document.createElement('div');
      div.textContent = line;
      div.style.opacity = line.startsWith('>') ? '0.7' : '1';
      container.appendChild(div);
    }
  }

  private renderAlert(container: HTMLElement, desc: UIComponentDescriptor): void {
    Object.assign(container.style, {
      display: 'flex',
      alignItems: 'center',
      gap: '12px',
      padding: '16px',
    });

    const icon = document.createElement('span');
    icon.textContent = '⚠';
    icon.style.fontSize = '24px';
    container.appendChild(icon);

    const text = document.createElement('div');
    text.textContent = `${desc.title} — Monitoring ${desc.dataBinding.fields.length} field(s)`;
    container.appendChild(text);
  }

  private renderTimeline(container: HTMLElement, desc: UIComponentDescriptor): void {
    Object.assign(container.style, {
      padding: '16px',
      display: 'flex',
      flexDirection: 'column',
      gap: '12px',
    });

    for (let i = 0; i < Math.min(desc.dataBinding.fields.length, 5); i++) {
      const entry = document.createElement('div');
      Object.assign(entry.style, {
        display: 'flex',
        gap: '12px',
        alignItems: 'flex-start',
      });

      const dot = document.createElement('div');
      Object.assign(dot.style, {
        width: '10px',
        height: '10px',
        borderRadius: '50%',
        background: 'rgba(59, 130, 246, 0.6)',
        marginTop: '4px',
        flexShrink: '0',
      });
      entry.appendChild(dot);

      const content = document.createElement('div');
      const label = document.createElement('div');
      label.style.fontSize = '10px';
      label.style.opacity = '0.5';
      label.textContent = `T-${i}`;
      content.appendChild(label);

      const val = document.createElement('div');
      val.textContent = this.formatFieldLabel(desc.dataBinding.fields[i] ?? `event${i}`);
      val.setAttribute('data-vtui-field', desc.dataBinding.fields[i] ?? '');
      content.appendChild(val);

      entry.appendChild(content);
      container.appendChild(entry);
    }
  }

  private renderCard(container: HTMLElement, desc: UIComponentDescriptor): void {
    Object.assign(container.style, {
      padding: '20px',
      display: 'flex',
      flexDirection: 'column',
      gap: '12px',
    });

    for (const field of desc.dataBinding.fields) {
      const row = document.createElement('div');
      Object.assign(row.style, {
        display: 'flex',
        justifyContent: 'space-between',
        padding: '4px 0',
        borderBottom: '1px solid rgba(27, 56, 87, 0.2)',
      });

      const lbl = document.createElement('span');
      lbl.style.opacity = '0.6';
      lbl.textContent = this.formatFieldLabel(field);
      row.appendChild(lbl);

      const val = document.createElement('span');
      val.textContent = '—';
      val.setAttribute('data-vtui-field', field);
      row.appendChild(val);

      container.appendChild(row);
    }
  }

  private renderPanel(container: HTMLElement, desc: UIComponentDescriptor): void {
    Object.assign(container.style, { padding: '16px' });
    const info = document.createElement('div');
    info.style.opacity = '0.6';
    info.style.fontSize = '11px';
    info.textContent = `${desc.kind} — ${desc.dataBinding.domain} — ${desc.dataBinding.fields.join(', ')}`;
    container.appendChild(info);
  }

  // ─── Animation ───────────────────────────────────────────────────────────

  private animateEntrance(el: HTMLElement, config: AnimationConfig): void {
    const keyframes = this.getEntranceKeyframes(config.entrance);
    if (keyframes.length === 0) return;

    el.animate(keyframes, {
      duration: config.durationMs,
      easing: config.easing,
      delay: config.delay,
      fill: 'backwards',
    });
  }

  private getEntranceKeyframes(entrance: EntranceAnimation): Keyframe[] {
    switch (entrance) {
      case 'FADE_IN':
        return [{ opacity: 0 }, { opacity: 1 }];
      case 'SLIDE_UP':
        return [
          { opacity: 0, transform: 'translateY(20px)' },
          { opacity: 1, transform: 'translateY(0)' },
        ];
      case 'SLIDE_LEFT':
        return [
          { opacity: 0, transform: 'translateX(-20px)' },
          { opacity: 1, transform: 'translateX(0)' },
        ];
      case 'SCALE_UP':
        return [
          { opacity: 0, transform: 'scale(0.95)' },
          { opacity: 1, transform: 'scale(1)' },
        ];
      case 'FLIP':
        return [
          { opacity: 0, transform: 'rotateY(90deg)' },
          { opacity: 1, transform: 'rotateY(0deg)' },
        ];
      case 'NONE':
        return [];
    }
  }

  // ─── Utilities ───────────────────────────────────────────────────────────

  private formatFieldLabel(field: string): string {
    return field
      .replace(/([A-Z])/g, ' $1')
      .replace(/[_-]/g, ' ')
      .replace(/^\s+/, '')
      .split(' ')
      .map(w => w.charAt(0).toUpperCase() + w.slice(1))
      .join(' ');
  }
}
