// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ═══════════════════════════════════════════════════════════════════════════════
// Module: VoiceToInterfaceSDK — THE SOVEREIGN ORCHESTRATOR
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
//
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔══════════════════════════════════════════════════════════════════════════════╗
// ║    @medina/voice-to-interface-sdk — SPEAK AND THE INTERFACE BUILDS ITSELF    ║
// ╠══════════════════════════════════════════════════════════════════════════════╣
// ║                                                                              ║
// ║  THE SOVEREIGN MODEL — Does this for ALL of them.                           ║
// ║                                                                              ║
// ║  Pipeline: Voice → Intent → DOM → Runtime                                  ║
// ║                                                                              ║
// ║  1. VoiceRecognitionEngine: Web Speech API, PHI-confidence filtering        ║
// ║  2. IntentParser: NLP intent extraction, pattern matching                   ║
// ║  3. DOMConstructor: CSS Grid/Flexbox auto-layout, Web Animations API        ║
// ║  4. RuntimeWire: All 96 AI models wired, all autonomous, all 24h running   ║
// ║                                                                              ║
// ║  "Show me a dashboard with sales data" → dashboard appears.                 ║
// ║  No code, no drag-and-drop — just talk.                                     ║
// ║                                                                              ║
// ╚══════════════════════════════════════════════════════════════════════════════╝
// ═══════════════════════════════════════════════════════════════════════════════

import type {
  VoiceToInterfaceConfig,
  VoiceToInterfaceState,
  VoiceResult,
  VoiceIntent,
  UIComponentDescriptor,
  RuntimeWireState,
  VoiceEngineStatus,
  ColorTheme,
} from './types';
import { VoiceRecognitionEngine } from './VoiceRecognitionEngine';
import { IntentParser } from './IntentParser';
import { DOMConstructor } from './DOMConstructor';
import { RuntimeWire } from './RuntimeWire';

// ═══════════════════════════════════════════════════════════════════════════════
// DEFAULT CONFIGURATION
// ═══════════════════════════════════════════════════════════════════════════════

const DEFAULT_CONFIG: VoiceToInterfaceConfig = {
  mountTarget: '#vtui-mount',
  voice: {
    language: 'en-US',
    continuous: true,
    interimResults: true,
    confidenceThreshold: 0.618,
  },
  defaultTheme: 'DEFAULT' as ColorTheme,
  enableRuntime: true,
  enableAnimations: true,
  maxComponents: 20,
};

// ═══════════════════════════════════════════════════════════════════════════════
// VOICE-TO-INTERFACE SDK — THE SOVEREIGN MODEL
// ═══════════════════════════════════════════════════════════════════════════════

export class VoiceToInterfaceSDK {
  private config: VoiceToInterfaceConfig;
  private voiceEngine: VoiceRecognitionEngine;
  private intentParser: IntentParser;
  private domConstructor: DOMConstructor;
  private runtimeWire: RuntimeWire;
  private mountElement: HTMLElement | null = null;

  // State
  private activeComponents: UIComponentDescriptor[] = [];
  private intentHistory: VoiceIntent[] = [];
  private commandCount: number = 0;
  private initialized: boolean = false;

  constructor(config: Partial<VoiceToInterfaceConfig> = {}) {
    this.config = { ...DEFAULT_CONFIG, ...config };

    // Initialize Intent Parser (no dependencies)
    this.intentParser = new IntentParser();

    // Initialize Voice Engine with callbacks
    this.voiceEngine = new VoiceRecognitionEngine(this.config.voice, {
      onResult: (result) => this.handleVoiceResult(result),
      onInterim: (transcript) => this.handleInterim(transcript),
      onStatusChange: (status) => this.handleStatusChange(status),
      onError: (error) => this.config.callbacks?.onError?.(error),
    });

    // Initialize Runtime Wire
    this.runtimeWire = new RuntimeWire((state) => {
      this.config.callbacks?.onRuntimeUpdate?.(state);
    });

    // Initialize DOM Constructor with a temporary element (will be replaced on init)
    this.domConstructor = new DOMConstructor(document.createElement('div'));
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PUBLIC API — The interface for the world
  // ═══════════════════════════════════════════════════════════════════════════

  /**
   * Initialize the SDK — wire everything, prepare the mount target.
   * Call this after the DOM is ready.
   */
  init(): boolean {
    // Resolve mount target
    const target = this.resolveMountTarget();
    if (!target) {
      this.config.callbacks?.onError?.('Mount target not found');
      return false;
    }
    this.mountElement = target;
    this.domConstructor.setMountTarget(target);

    // Style the mount target
    this.styleMountTarget(target);

    // Start the runtime wire — all AI models come alive
    if (this.config.enableRuntime) {
      this.runtimeWire.start();
    }

    this.initialized = true;
    return true;
  }

  /**
   * Start listening for voice commands.
   * Call after init().
   */
  startListening(): void {
    if (!this.initialized) {
      this.config.callbacks?.onError?.('SDK not initialized. Call init() first.');
      return;
    }
    this.voiceEngine.start();
  }

  /**
   * Stop listening for voice commands.
   */
  stopListening(): void {
    this.voiceEngine.stop();
  }

  /**
   * Process a text command directly (bypass voice).
   * Useful for typed input, testing, or API integration.
   */
  processCommand(text: string): UIComponentDescriptor | null {
    if (!this.initialized) return null;

    const fakeVoiceResult: VoiceResult = {
      transcript: text,
      confidence: 1.0,
      isFinal: true,
      timestamp: Date.now(),
    };
    return this.handleVoiceResult(fakeVoiceResult);
  }

  /**
   * Remove a component by ID.
   */
  removeComponent(id: string): boolean {
    const result = this.domConstructor.remove(id);
    if (result) {
      this.activeComponents = this.activeComponents.filter(c => c.id !== id);
      this.config.callbacks?.onComponentRemoved?.(id);
    }
    return result;
  }

  /**
   * Clear all generated components.
   */
  clearAll(): void {
    this.domConstructor.clear();
    this.activeComponents = [];
  }

  /**
   * Get the full SDK state.
   */
  getState(): VoiceToInterfaceState {
    return {
      voiceStatus: this.voiceEngine.getStatus(),
      activeComponents: [...this.activeComponents],
      intentHistory: [...this.intentHistory],
      runtime: this.runtimeWire.getState(),
      initialized: this.initialized,
      commandCount: this.commandCount,
    };
  }

  /**
   * Check if voice is supported in this browser.
   */
  isVoiceSupported(): boolean {
    return this.voiceEngine.isSupported();
  }

  /**
   * Destroy the SDK — clean up everything.
   */
  destroy(): void {
    this.voiceEngine.destroy();
    this.runtimeWire.destroy();
    this.clearAll();
    this.initialized = false;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // INTERNAL — The sovereign pipeline
  // ═══════════════════════════════════════════════════════════════════════════

  /**
   * The sovereign pipeline: Voice → Intent → DOM → Runtime
   */
  private handleVoiceResult(result: VoiceResult): UIComponentDescriptor | null {
    this.commandCount++;
    this.config.callbacks?.onVoiceResult?.(result);

    // Step 1: Parse intent from transcript
    const intent = this.intentParser.parse(result.transcript);
    this.intentHistory.push(intent);
    this.config.callbacks?.onIntentParsed?.(intent);

    // Step 2: Handle the action
    switch (intent.action) {
      case 'SHOW':
      case 'CREATE':
      case 'ADD':
        return this.createComponent(intent);
      case 'REMOVE':
        this.handleRemove(intent);
        return null;
      case 'CLEAR':
        this.clearAll();
        return null;
      case 'UPDATE':
        // Force refresh data
        this.runtimeWire.getState();
        return null;
      default:
        return this.createComponent(intent);
    }
  }

  private createComponent(intent: VoiceIntent): UIComponentDescriptor | null {
    // Enforce max components
    if (this.activeComponents.length >= this.config.maxComponents) {
      // Remove the oldest component
      const oldest = this.activeComponents.shift();
      if (oldest) {
        this.domConstructor.remove(oldest.id);
      }
    }

    // Build the component
    const descriptor = this.domConstructor.build(intent);
    this.activeComponents.push(descriptor);
    this.config.callbacks?.onComponentCreated?.(descriptor);

    // Speak confirmation
    this.speak(`Created ${intent.title}`);

    return descriptor;
  }

  private handleRemove(intent: VoiceIntent): void {
    // Try to find a matching component by domain or kind
    const match = this.activeComponents.find(
      c => c.dataBinding.domain === intent.dataDomain || c.kind === intent.componentKind,
    );
    if (match) {
      this.removeComponent(match.id);
      this.speak(`Removed ${match.title}`);
    }
  }

  private handleInterim(transcript: string): void {
    // Could be used for live preview — show what's being recognized
    // For now, just pass through
    void transcript;
  }

  private handleStatusChange(status: VoiceEngineStatus): void {
    if (status === 'LISTENING') {
      this.speak('Listening');
    }
  }

  // ─── Speech Output ───────────────────────────────────────────────────────

  private speak(text: string): void {
    if (typeof window === 'undefined') return;
    if (!('speechSynthesis' in window)) return;
    const utterance = new SpeechSynthesisUtterance(text);
    utterance.rate = 1.1;
    utterance.pitch = 0.9;
    utterance.volume = 0.7;
    window.speechSynthesis.speak(utterance);
  }

  // ─── Mount Target ────────────────────────────────────────────────────────

  private resolveMountTarget(): HTMLElement | null {
    const target = this.config.mountTarget;
    if (typeof target === 'string') {
      return document.querySelector<HTMLElement>(target);
    }
    return target;
  }

  private styleMountTarget(el: HTMLElement): void {
    Object.assign(el.style, {
      width: '100%',
      minHeight: '200px',
      display: 'flex',
      flexDirection: 'column',
      gap: '13px',
      fontFamily: "'SF Mono', 'Fira Code', 'Cascadia Code', monospace",
    });
  }
}
