// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ═══════════════════════════════════════════════════════════════════════════════
// Module: VoiceRecognitionEngine — Web Speech API Sovereign Engine
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
//
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// Voice Recognition Engine — listens, transcribes, filters by PHI-confidence.
// ═══════════════════════════════════════════════════════════════════════════════

import type {
  VoiceResult,
  VoiceEngineStatus,
  VoiceConfig,
  VoiceEngineCallbacks,
} from './types';
import { VOICE_CONFIDENCE_THRESHOLD } from './types';

// ═══════════════════════════════════════════════════════════════════════════════
// BROWSER SPEECH API TYPES (not all browsers expose these on Window)
// ═══════════════════════════════════════════════════════════════════════════════

interface BrowserSpeechRecognition {
  continuous: boolean;
  interimResults: boolean;
  lang: string;
  onresult: ((event: SpeechRecognitionEventLike) => void) | null;
  onerror: ((event: { error?: string }) => void) | null;
  onend: (() => void) | null;
  start: () => void;
  stop: () => void;
  abort: () => void;
}

interface SpeechRecognitionEventLike {
  resultIndex: number;
  results: ArrayLike<SpeechRecognitionResultLike>;
}

interface SpeechRecognitionResultLike {
  isFinal: boolean;
  length: number;
  [index: number]: { transcript: string; confidence: number };
}

type SpeechWindow = Window & {
  webkitSpeechRecognition?: new () => BrowserSpeechRecognition;
  SpeechRecognition?: new () => BrowserSpeechRecognition;
};

// ═══════════════════════════════════════════════════════════════════════════════
// DEFAULT CONFIG
// ═══════════════════════════════════════════════════════════════════════════════

const DEFAULT_VOICE_CONFIG: VoiceConfig = {
  language: 'en-US',
  continuous: true,
  interimResults: true,
  confidenceThreshold: VOICE_CONFIDENCE_THRESHOLD,
};

// ═══════════════════════════════════════════════════════════════════════════════
// VOICE RECOGNITION ENGINE
// ═══════════════════════════════════════════════════════════════════════════════

export class VoiceRecognitionEngine {
  private recognition: BrowserSpeechRecognition | null = null;
  private config: VoiceConfig;
  private callbacks: VoiceEngineCallbacks;
  private status: VoiceEngineStatus = 'IDLE';
  private restartOnEnd: boolean = false;

  constructor(
    config: Partial<VoiceConfig> = {},
    callbacks: VoiceEngineCallbacks = {},
  ) {
    this.config = { ...DEFAULT_VOICE_CONFIG, ...config };
    this.callbacks = callbacks;
    this.initRecognition();
  }

  // ─── Initialization ──────────────────────────────────────────────────────

  private initRecognition(): void {
    const w = window as SpeechWindow;
    const Ctor = w.SpeechRecognition || w.webkitSpeechRecognition;

    if (!Ctor) {
      this.setStatus('UNSUPPORTED');
      return;
    }

    const rec = new Ctor();
    rec.continuous = this.config.continuous;
    rec.interimResults = this.config.interimResults;
    rec.lang = this.config.language;

    rec.onresult = (event: SpeechRecognitionEventLike) => {
      this.handleResult(event);
    };

    rec.onerror = (event: { error?: string }) => {
      const msg = event.error ?? 'Unknown speech recognition error';
      this.callbacks.onError?.(msg);
      // Don't set ERROR for transient issues like 'no-speech'
      if (msg !== 'no-speech' && msg !== 'aborted') {
        this.setStatus('ERROR');
      }
    };

    rec.onend = () => {
      if (this.restartOnEnd && this.status === 'LISTENING') {
        // Auto-restart for continuous mode
        try {
          rec.start();
        } catch {
          this.setStatus('IDLE');
        }
      } else {
        this.setStatus('IDLE');
      }
    };

    this.recognition = rec;
  }

  // ─── Result Handling ─────────────────────────────────────────────────────

  private handleResult(event: SpeechRecognitionEventLike): void {
    for (let i = event.resultIndex; i < event.results.length; i++) {
      const result = event.results[i];
      if (!result || result.length === 0) continue;

      const alt = result[0];
      const transcript = alt.transcript.trim();
      const confidence = alt.confidence;

      if (!transcript) continue;

      if (result.isFinal) {
        // Final result — only accept if confidence meets PHI threshold
        if (confidence >= this.config.confidenceThreshold) {
          const voiceResult: VoiceResult = {
            transcript,
            confidence,
            isFinal: true,
            timestamp: Date.now(),
          };
          this.callbacks.onResult?.(voiceResult);
        }
      } else {
        // Interim result — stream for live feedback
        this.callbacks.onInterim?.(transcript);
      }
    }
  }

  // ─── Public API ──────────────────────────────────────────────────────────

  /** Start listening for voice input */
  start(): void {
    if (!this.recognition) {
      this.callbacks.onError?.('Speech recognition not supported in this browser');
      return;
    }

    if (this.status === 'LISTENING') return;

    try {
      this.restartOnEnd = this.config.continuous;
      this.recognition.start();
      this.setStatus('LISTENING');
    } catch (err) {
      this.callbacks.onError?.(
        `Failed to start: ${err instanceof Error ? err.message : String(err)}`,
      );
      this.setStatus('ERROR');
    }
  }

  /** Stop listening */
  stop(): void {
    this.restartOnEnd = false;
    if (this.recognition && this.status === 'LISTENING') {
      this.recognition.stop();
    }
    this.setStatus('IDLE');
  }

  /** Get current status */
  getStatus(): VoiceEngineStatus {
    return this.status;
  }

  /** Check if speech recognition is supported */
  isSupported(): boolean {
    return this.status !== 'UNSUPPORTED';
  }

  /** Update callbacks */
  setCallbacks(callbacks: Partial<VoiceEngineCallbacks>): void {
    this.callbacks = { ...this.callbacks, ...callbacks };
  }

  /** Destroy the engine */
  destroy(): void {
    this.stop();
    if (this.recognition) {
      this.recognition.onresult = null;
      this.recognition.onerror = null;
      this.recognition.onend = null;
    }
    this.recognition = null;
    this.setStatus('IDLE');
  }

  // ─── Internal ────────────────────────────────────────────────────────────

  private setStatus(status: VoiceEngineStatus): void {
    if (this.status !== status) {
      this.status = status;
      this.callbacks.onStatusChange?.(status);
    }
  }
}
