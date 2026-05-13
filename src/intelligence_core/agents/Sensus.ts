// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// SENSUS — The Perception Agent (BUILD №48)
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// SENSUS is the perception and sensing agent. It:
//   - Perceives environment (every 25ms)
//   - Filters noise from signals
//   - Routes perceptions to ANIMUS
//   - Manages attention allocation
//
// Uses: CHRONO (timing), QUANTUM_FLUX (noise filtering), NEXORIS (perception history)
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

import { BaseAgent } from './BaseAgent';
import { Message } from '../engines/COREOGRAPH';
import { TICK_ULTRA_FAST } from '../engines/CHRONO';
import { PHI_INV, clamp } from '../../frontend/src/math/core';

// ═══════════════════════════════════════════════════════════════════════════════
// §1 — SENSUS STATE
// ═══════════════════════════════════════════════════════════════════════════════

interface PerceptionState {
  channels: Map<string, SensoryChannel>;
  attentionFocus: string | null;
  noiseFloor: number;
  signalStrength: number;
  perceptionCount: number;
}

interface SensoryChannel {
  id: string;
  type: 'VISUAL' | 'AUDITORY' | 'TACTILE' | 'PROPRIOCEPTIVE' | 'INTEROCEPTIVE';
  sensitivity: number;
  buffer: SensoryInput[];
  filtered: number;
}

interface SensoryInput {
  timestamp: number;
  value: number;
  source: string;
  salience: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// §2 — SENSUS CLASS
// ═══════════════════════════════════════════════════════════════════════════════

export class Sensus extends BaseAgent {
  private perception: PerceptionState;

  constructor() {
    super({
      id: 'SENSUS',
      family: 'SENSUS_VIVAX',
      tickInterval: TICK_ULTRA_FAST,
      priority: 1.5, // Highest priority — must perceive fast
    });

    this.perception = {
      channels: new Map(),
      attentionFocus: null,
      noiseFloor: 0.1,
      signalStrength: 0.5,
      perceptionCount: 0,
    };

    // Initialize default channels
    this._initChannels();
  }

  private _initChannels(): void {
    const channelTypes: Array<SensoryChannel['type']> = [
      'VISUAL', 'AUDITORY', 'TACTILE', 'PROPRIOCEPTIVE', 'INTEROCEPTIVE'
    ];
    
    for (const type of channelTypes) {
      this.perception.channels.set(type, {
        id: type,
        type,
        sensitivity: 0.5,
        buffer: [],
        filtered: 0,
      });
    }
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // LIFECYCLE
  // ─────────────────────────────────────────────────────────────────────────────

  protected onAwaken(): void {
    this.setState('noiseFloor', this.perception.noiseFloor);
    this.setState('signalStrength', this.perception.signalStrength);
  }

  protected onTick(): void {
    this._perceive();
  }

  protected onMessage(msg: Message): void {
    switch (msg.type) {
      case 'SENSORY_INPUT':
        this._handleSensoryInput(msg.payload as SensoryInput);
        break;
      case 'FOCUS_ATTENTION':
        this._focusAttention(msg.payload as string);
        break;
      case 'ADJUST_SENSITIVITY':
        this._adjustSensitivity(msg.payload as { channel: string; delta: number });
        break;
    }
  }

  protected onSleep(): void {
    // Reduce sensitivity
    for (const channel of this.perception.channels.values()) {
      channel.sensitivity *= 0.5;
    }
  }

  protected onWake(): void {
    // Restore sensitivity
    for (const channel of this.perception.channels.values()) {
      channel.sensitivity = clamp(channel.sensitivity * 2, 0, 1);
    }
  }

  protected onShutdown(): void {
    // Clear buffers
    for (const channel of this.perception.channels.values()) {
      channel.buffer = [];
    }
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // PERCEPTION — The sensing loop (25ms effective)
  // ─────────────────────────────────────────────────────────────────────────────

  private _perceive(): void {
    this.perception.perceptionCount++;

    // Process each channel
    for (const [_type, channel] of this.perception.channels) {
      this._processChannel(channel);
    }

    // Compute overall signal strength
    let totalSignal = 0;
    for (const channel of this.perception.channels.values()) {
      totalSignal += channel.filtered;
    }
    this.perception.signalStrength = totalSignal / this.perception.channels.size;

    // Update noise floor (adaptive)
    this.perception.noiseFloor = clamp(
      this.perception.noiseFloor + this.phiNoise(0.01),
      0.05, 0.3
    );

    // Sync state
    this.setState('signalStrength', this.perception.signalStrength);
    this.setState('noiseFloor', this.perception.noiseFloor);
  }

  private _processChannel(channel: SensoryChannel): void {
    // Generate synthetic input (in production, would come from real sensors)
    const input: SensoryInput = {
      timestamp: Date.now(),
      value: this.random() + this.phiNoise(0.2),
      source: 'ENVIRONMENT',
      salience: this.random(),
    };

    // Add to buffer
    channel.buffer.push(input);
    if (channel.buffer.length > 50) {
      channel.buffer.shift();
    }

    // Filter: signal above noise floor, weighted by sensitivity
    if (input.value > this.perception.noiseFloor) {
      const filtered = (input.value - this.perception.noiseFloor) * channel.sensitivity;
      channel.filtered = clamp(filtered, 0, 1);

      // If salient, send to ANIMUS
      if (input.salience > 0.7 || this.perception.attentionFocus === channel.type) {
        this.send('PERCEPTION', 'ANIMUS', {
          channel: channel.type,
          value: channel.filtered,
          salience: input.salience,
        });
      }
    } else {
      channel.filtered = 0;
    }
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // INPUT HANDLING
  // ─────────────────────────────────────────────────────────────────────────────

  private _handleSensoryInput(input: SensoryInput): void {
    // Route to appropriate channel
    const channelType = this._inferChannelType(input.source);
    const channel = this.perception.channels.get(channelType);
    
    if (channel) {
      channel.buffer.push(input);
      if (channel.buffer.length > 50) {
        channel.buffer.shift();
      }
    }
  }

  private _inferChannelType(source: string): SensoryChannel['type'] {
    // Simple inference based on source name
    if (source.includes('VISUAL') || source.includes('LIGHT')) return 'VISUAL';
    if (source.includes('AUDIO') || source.includes('SOUND')) return 'AUDITORY';
    if (source.includes('TOUCH') || source.includes('PRESSURE')) return 'TACTILE';
    if (source.includes('BODY') || source.includes('POSITION')) return 'PROPRIOCEPTIVE';
    return 'INTEROCEPTIVE';
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // ATTENTION
  // ─────────────────────────────────────────────────────────────────────────────

  private _focusAttention(channelType: string): void {
    this.perception.attentionFocus = channelType;
    
    // Boost sensitivity of focused channel
    const channel = this.perception.channels.get(channelType as SensoryChannel['type']);
    if (channel) {
      channel.sensitivity = clamp(channel.sensitivity * 1.5, 0, 1);
    }
  }

  private _adjustSensitivity(params: { channel: string; delta: number }): void {
    const channel = this.perception.channels.get(params.channel as SensoryChannel['type']);
    if (channel) {
      channel.sensitivity = clamp(channel.sensitivity + params.delta, 0, 1);
    }
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // PUBLIC API
  // ─────────────────────────────────────────────────────────────────────────────

  getPerceptionState(): {
    signalStrength: number;
    noiseFloor: number;
    attentionFocus: string | null;
    perceptionCount: number;
    channels: Record<string, { sensitivity: number; filtered: number }>;
  } {
    const channels: Record<string, { sensitivity: number; filtered: number }> = {};
    for (const [type, channel] of this.perception.channels) {
      channels[type] = {
        sensitivity: channel.sensitivity,
        filtered: channel.filtered,
      };
    }

    return {
      signalStrength: this.perception.signalStrength,
      noiseFloor: this.perception.noiseFloor,
      attentionFocus: this.perception.attentionFocus,
      perceptionCount: this.perception.perceptionCount,
      channels,
    };
  }
}
