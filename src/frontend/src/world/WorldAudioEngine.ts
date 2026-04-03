// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ═══════════════════════════════════════════════════════════════════════════════
// Module: WorldAudioEngine — Immersive 3D Audio System
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
//
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔════════════════════════════════════════════════════════════════════════════════╗
// ║                    WORLD AUDIO ENGINE — SONIC REALITY                          ║
// ╠════════════════════════════════════════════════════════════════════════════════╣
// ║                                                                                ║
// ║  Complete 3D audio system for the living world:                                ║
// ║    • Spatial audio with HRTF                                                   ║
// ║    • Environmental audio (reverb, occlusion)                                   ║
// ║    • Dynamic music system                                                      ║
// ║    • Sound effects management                                                  ║
// ║    • Voice/radio communication                                                 ║
// ║    • Procedural audio generation                                               ║
// ║                                                                                ║
// ╚════════════════════════════════════════════════════════════════════════════════╝
// ═══════════════════════════════════════════════════════════════════════════════

import type { Vec3 } from './WorldPhysicsEngine';
import { vec3 } from './WorldPhysicsEngine';

// ═══════════════════════════════════════════════════════════════════════════════
// AUDIO CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

export const AUDIO_CONSTANTS = {
  SPEED_OF_SOUND: 343,           // m/s at 20°C
  MIN_DISTANCE: 1,               // meters
  MAX_DISTANCE: 1000,            // meters
  REFERENCE_DISTANCE: 10,        // meters
  ROLLOFF_FACTOR: 1,
  
  // Frequency ranges
  SUB_BASS: { min: 20, max: 60 },
  BASS: { min: 60, max: 250 },
  LOW_MID: { min: 250, max: 500 },
  MID: { min: 500, max: 2000 },
  HIGH_MID: { min: 2000, max: 4000 },
  PRESENCE: { min: 4000, max: 6000 },
  BRILLIANCE: { min: 6000, max: 20000 },
} as const;

// ═══════════════════════════════════════════════════════════════════════════════
// AUDIO TYPES
// ═══════════════════════════════════════════════════════════════════════════════

export type AudioCategory =
  | 'Master'
  | 'Music'
  | 'SFX'
  | 'Voice'
  | 'Ambient'
  | 'UI'
  | 'Radio';

export type DistanceModel = 'Linear' | 'Inverse' | 'Exponential';

export interface AudioListener {
  position: Vec3;
  forward: Vec3;
  up: Vec3;
  velocity: Vec3;
}

export interface AudioSource {
  id: string;
  name: string;
  
  // Clip
  clipId: string | null;
  
  // Playback
  playing: boolean;
  paused: boolean;
  loop: boolean;
  time: number;
  duration: number;
  
  // Volume
  volume: number;
  muted: boolean;
  category: AudioCategory;
  
  // Spatial
  is3D: boolean;
  position: Vec3;
  velocity: Vec3;
  
  // 3D settings
  minDistance: number;
  maxDistance: number;
  rolloffFactor: number;
  distanceModel: DistanceModel;
  
  // Cone
  coneEnabled: boolean;
  coneInnerAngle: number;
  coneOuterAngle: number;
  coneOuterGain: number;
  direction: Vec3;
  
  // Effects
  dopplerEnabled: boolean;
  dopplerFactor: number;
  
  // Priority (for voice limiting)
  priority: number;
  
  // Callbacks
  onEnd: (() => void) | null;
}

export interface AudioClip {
  id: string;
  name: string;
  url: string;
  duration: number;
  sampleRate: number;
  channels: number;
  loaded: boolean;
}

export interface AudioMixer {
  volumes: Record<AudioCategory, number>;
  muted: Record<AudioCategory, boolean>;
  masterVolume: number;
  masterMuted: boolean;
}

// ═══════════════════════════════════════════════════════════════════════════════
// REVERB AND ENVIRONMENT
// ═══════════════════════════════════════════════════════════════════════════════

export type ReverbPreset =
  | 'None'
  | 'Room'
  | 'Hall'
  | 'Cave'
  | 'Arena'
  | 'Hangar'
  | 'Forest'
  | 'City'
  | 'Mountains'
  | 'Underwater';

export interface ReverbSettings {
  preset: ReverbPreset;
  enabled: boolean;
  
  // Impulse response parameters
  decay: number;           // seconds
  preDelay: number;        // milliseconds
  wetDryMix: number;       // 0-1
  
  // EQ
  lowPassFreq: number;
  highPassFreq: number;
  
  // Modulation
  modulationRate: number;
  modulationDepth: number;
}

export interface OcclusionSettings {
  enabled: boolean;
  lowPassCutoff: number;   // Hz when fully occluded
  volumeReduction: number; // dB when fully occluded
}

export interface EnvironmentZone {
  id: string;
  name: string;
  position: Vec3;
  radius: number;
  shape: 'Sphere' | 'Box';
  size: Vec3;
  
  reverb: ReverbSettings;
  occlusion: OcclusionSettings;
  
  ambientSounds: string[];
  ambientVolume: number;
  
  priority: number;
  blendDistance: number;
}

export const REVERB_PRESETS: Record<ReverbPreset, Partial<ReverbSettings>> = {
  None: { enabled: false, decay: 0, wetDryMix: 0 },
  Room: { enabled: true, decay: 0.5, preDelay: 10, wetDryMix: 0.3 },
  Hall: { enabled: true, decay: 2.0, preDelay: 30, wetDryMix: 0.5 },
  Cave: { enabled: true, decay: 3.5, preDelay: 50, wetDryMix: 0.7 },
  Arena: { enabled: true, decay: 4.0, preDelay: 40, wetDryMix: 0.6 },
  Hangar: { enabled: true, decay: 5.0, preDelay: 60, wetDryMix: 0.65 },
  Forest: { enabled: true, decay: 0.8, preDelay: 20, wetDryMix: 0.25 },
  City: { enabled: true, decay: 1.2, preDelay: 15, wetDryMix: 0.35 },
  Mountains: { enabled: true, decay: 2.5, preDelay: 100, wetDryMix: 0.4 },
  Underwater: { enabled: true, decay: 1.5, preDelay: 5, wetDryMix: 0.8, lowPassFreq: 800 },
};

// ═══════════════════════════════════════════════════════════════════════════════
// MUSIC SYSTEM
// ═══════════════════════════════════════════════════════════════════════════════

export type MusicState =
  | 'Ambient'
  | 'Exploration'
  | 'Tension'
  | 'Combat'
  | 'Victory'
  | 'Defeat'
  | 'Cinematic';

export interface MusicTrack {
  id: string;
  name: string;
  clipId: string;
  state: MusicState;
  intensity: number;       // 0-1 within state
  bpm: number;
  loops: boolean;
  fadeInTime: number;
  fadeOutTime: number;
  volume: number;
}

export interface MusicLayer {
  id: string;
  trackId: string;
  volume: number;
  active: boolean;
  intensityThreshold: number;
}

export interface MusicCue {
  id: string;
  state: MusicState;
  tracks: MusicTrack[];
  layers: MusicLayer[];
  transitionTime: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SOUND EFFECTS
// ═══════════════════════════════════════════════════════════════════════════════

export interface SoundEvent {
  id: string;
  name: string;
  clips: string[];         // Random selection
  
  volume: { min: number; max: number };
  pitch: { min: number; max: number };
  
  cooldown: number;        // Minimum time between plays
  maxInstances: number;    // Concurrent instances
  
  is3D: boolean;
  minDistance: number;
  maxDistance: number;
  
  category: AudioCategory;
  priority: number;
}

export interface SoundInstance {
  id: string;
  eventId: string;
  sourceId: string;
  startTime: number;
  position: Vec3;
}

// ═══════════════════════════════════════════════════════════════════════════════
// VOICE AND RADIO
// ═══════════════════════════════════════════════════════════════════════════════

export interface RadioChannel {
  id: string;
  name: string;
  frequency: number;
  
  // Voice processing
  enabled: boolean;
  volume: number;
  
  // Radio effects
  staticAmount: number;    // 0-1
  distortion: number;      // 0-1
  bandpassLow: number;     // Hz
  bandpassHigh: number;    // Hz
  
  // Queue
  messageQueue: RadioMessage[];
  currentMessage: RadioMessage | null;
}

export interface RadioMessage {
  id: string;
  senderId: string;
  senderName: string;
  clipId: string;
  text: string;            // For subtitles
  priority: number;
  timestamp: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// PROCEDURAL AUDIO
// ═══════════════════════════════════════════════════════════════════════════════

export type ProceduralSoundType =
  | 'Wind'
  | 'Rain'
  | 'Thunder'
  | 'Fire'
  | 'Water'
  | 'Engine'
  | 'Rotor'
  | 'Explosion';

export interface ProceduralSound {
  id: string;
  type: ProceduralSoundType;
  enabled: boolean;
  
  // Parameters vary by type
  parameters: Record<string, number>;
  
  volume: number;
  is3D: boolean;
  position: Vec3;
}

export interface WindSoundParams {
  speed: number;           // m/s
  gustiness: number;       // 0-1
  direction: Vec3;
  lowFreqGain: number;
  highFreqGain: number;
}

export interface RainSoundParams {
  intensity: number;       // 0-1
  dropSize: number;        // 0-1
  surface: 'Ground' | 'Metal' | 'Water' | 'Foliage';
}

export interface EngineSoundParams {
  rpm: number;
  load: number;            // 0-1
  type: 'Jet' | 'Prop' | 'Electric';
}

export interface RotorSoundParams {
  rpm: number;
  bladeCount: number;
  diameter: number;
  load: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// AUDIO ENGINE
// ═══════════════════════════════════════════════════════════════════════════════

export class WorldAudioEngine {
  // Listener
  private listener: AudioListener;
  
  // Sources
  private sources: Map<string, AudioSource> = new Map();
  private clips: Map<string, AudioClip> = new Map();
  
  // Mixer
  private mixer: AudioMixer;
  
  // Environment
  private environmentZones: Map<string, EnvironmentZone> = new Map();
  private activeZone: EnvironmentZone | null = null;
  
  // Music
  private musicState: MusicState = 'Ambient';
  private musicIntensity: number = 0;
  private musicCues: Map<MusicState, MusicCue> = new Map();
  private currentMusicSource: string | null = null;
  private musicCrossfadeTime: number = 2;
  
  // Sound events
  private soundEvents: Map<string, SoundEvent> = new Map();
  private soundInstances: Map<string, SoundInstance> = new Map();
  private lastPlayTimes: Map<string, number> = new Map();
  
  // Radio
  private radioChannels: Map<string, RadioChannel> = new Map();
  private activeRadioChannel: string | null = null;
  
  // Procedural
  private proceduralSounds: Map<string, ProceduralSound> = new Map();
  
  // State
  private time: number = 0;
  private paused: boolean = false;
  
  constructor() {
    this.listener = {
      position: vec3.zero(),
      forward: { x: 0, y: 0, z: 1 },
      up: { x: 0, y: 1, z: 0 },
      velocity: vec3.zero(),
    };
    
    this.mixer = {
      volumes: {
        Master: 1,
        Music: 0.7,
        SFX: 1,
        Voice: 1,
        Ambient: 0.5,
        UI: 1,
        Radio: 0.8,
      },
      muted: {
        Master: false,
        Music: false,
        SFX: false,
        Voice: false,
        Ambient: false,
        UI: false,
        Radio: false,
      },
      masterVolume: 1,
      masterMuted: false,
    };
    
    // Create default radio channel
    this.createRadioChannel('main', 'Main Radio', 100);
  }
  
  // Listener
  setListenerPosition(position: Vec3, forward: Vec3, up: Vec3, velocity?: Vec3): void {
    this.listener.position = position;
    this.listener.forward = vec3.normalize(forward);
    this.listener.up = vec3.normalize(up);
    if (velocity) this.listener.velocity = velocity;
  }
  
  getListener(): AudioListener {
    return { ...this.listener };
  }
  
  // Mixer
  setVolume(category: AudioCategory, volume: number): void {
    this.mixer.volumes[category] = Math.max(0, Math.min(1, volume));
  }
  
  getVolume(category: AudioCategory): number {
    return this.mixer.volumes[category];
  }
  
  setMuted(category: AudioCategory, muted: boolean): void {
    this.mixer.muted[category] = muted;
  }
  
  isMuted(category: AudioCategory): boolean {
    return this.mixer.muted[category];
  }
  
  setMasterVolume(volume: number): void {
    this.mixer.masterVolume = Math.max(0, Math.min(1, volume));
  }
  
  setMasterMuted(muted: boolean): void {
    this.mixer.masterMuted = muted;
  }
  
  // Clips
  registerClip(clip: AudioClip): void {
    this.clips.set(clip.id, clip);
  }
  
  getClip(id: string): AudioClip | undefined {
    return this.clips.get(id);
  }
  
  // Sources
  createSource(name: string, is3D: boolean = true): AudioSource {
    const source: AudioSource = {
      id: `source_${Date.now().toString(36)}_${Math.random().toString(36).substr(2, 5)}`,
      name,
      clipId: null,
      playing: false,
      paused: false,
      loop: false,
      time: 0,
      duration: 0,
      volume: 1,
      muted: false,
      category: 'SFX',
      is3D,
      position: vec3.zero(),
      velocity: vec3.zero(),
      minDistance: AUDIO_CONSTANTS.MIN_DISTANCE,
      maxDistance: AUDIO_CONSTANTS.MAX_DISTANCE,
      rolloffFactor: AUDIO_CONSTANTS.ROLLOFF_FACTOR,
      distanceModel: 'Inverse',
      coneEnabled: false,
      coneInnerAngle: 360,
      coneOuterAngle: 360,
      coneOuterGain: 0,
      direction: { x: 0, y: 0, z: 1 },
      dopplerEnabled: true,
      dopplerFactor: 1,
      priority: 0,
      onEnd: null,
    };
    
    this.sources.set(source.id, source);
    return source;
  }
  
  destroySource(id: string): void {
    this.sources.delete(id);
  }
  
  getSource(id: string): AudioSource | undefined {
    return this.sources.get(id);
  }
  
  play(sourceId: string, clipId?: string): void {
    const source = this.sources.get(sourceId);
    if (!source) return;
    
    if (clipId) {
      source.clipId = clipId;
      const clip = this.clips.get(clipId);
      if (clip) {
        source.duration = clip.duration;
      }
    }
    
    source.playing = true;
    source.paused = false;
    source.time = 0;
  }
  
  stop(sourceId: string): void {
    const source = this.sources.get(sourceId);
    if (!source) return;
    
    source.playing = false;
    source.paused = false;
    source.time = 0;
  }
  
  pause(sourceId: string): void {
    const source = this.sources.get(sourceId);
    if (!source) return;
    
    source.paused = true;
  }
  
  resume(sourceId: string): void {
    const source = this.sources.get(sourceId);
    if (!source) return;
    
    source.paused = false;
  }
  
  // Sound events
  registerSoundEvent(event: SoundEvent): void {
    this.soundEvents.set(event.id, event);
  }
  
  playSound(eventId: string, position?: Vec3): string | null {
    const event = this.soundEvents.get(eventId);
    if (!event) return null;
    
    // Check cooldown
    const lastPlay = this.lastPlayTimes.get(eventId) || 0;
    if (this.time - lastPlay < event.cooldown) return null;
    
    // Check max instances
    let instanceCount = 0;
    for (const instance of this.soundInstances.values()) {
      if (instance.eventId === eventId) instanceCount++;
    }
    if (instanceCount >= event.maxInstances) return null;
    
    // Create source
    const source = this.createSource(event.name, event.is3D);
    source.category = event.category;
    source.priority = event.priority;
    source.minDistance = event.minDistance;
    source.maxDistance = event.maxDistance;
    
    if (position) {
      source.position = position;
    }
    
    // Randomize volume and pitch
    source.volume = event.volume.min + Math.random() * (event.volume.max - event.volume.min);
    // Note: pitch would be applied through playback rate
    
    // Select random clip
    const clipId = event.clips[Math.floor(Math.random() * event.clips.length)];
    
    // Play
    this.play(source.id, clipId);
    this.lastPlayTimes.set(eventId, this.time);
    
    // Track instance
    const instance: SoundInstance = {
      id: source.id,
      eventId,
      sourceId: source.id,
      startTime: this.time,
      position: position || vec3.zero(),
    };
    this.soundInstances.set(instance.id, instance);
    
    return source.id;
  }
  
  // Music
  setMusicState(state: MusicState, transitionTime?: number): void {
    if (state === this.musicState) return;
    
    this.musicState = state;
    // Transition logic would go here
  }
  
  setMusicIntensity(intensity: number): void {
    this.musicIntensity = Math.max(0, Math.min(1, intensity));
  }
  
  getMusicState(): MusicState {
    return this.musicState;
  }
  
  getMusicIntensity(): number {
    return this.musicIntensity;
  }
  
  // Environment
  createEnvironmentZone(
    name: string,
    position: Vec3,
    radius: number,
    reverbPreset: ReverbPreset
  ): EnvironmentZone {
    const zone: EnvironmentZone = {
      id: `zone_${Date.now().toString(36)}`,
      name,
      position,
      radius,
      shape: 'Sphere',
      size: { x: radius * 2, y: radius * 2, z: radius * 2 },
      reverb: {
        preset: reverbPreset,
        enabled: true,
        decay: REVERB_PRESETS[reverbPreset]?.decay || 1,
        preDelay: REVERB_PRESETS[reverbPreset]?.preDelay || 20,
        wetDryMix: REVERB_PRESETS[reverbPreset]?.wetDryMix || 0.3,
        lowPassFreq: REVERB_PRESETS[reverbPreset]?.lowPassFreq || 20000,
        highPassFreq: 20,
        modulationRate: 0,
        modulationDepth: 0,
      },
      occlusion: {
        enabled: true,
        lowPassCutoff: 1000,
        volumeReduction: -12,
      },
      ambientSounds: [],
      ambientVolume: 0.5,
      priority: 0,
      blendDistance: radius * 0.2,
    };
    
    this.environmentZones.set(zone.id, zone);
    return zone;
  }
  
  updateActiveZone(): void {
    let bestZone: EnvironmentZone | null = null;
    let bestPriority = -Infinity;
    
    for (const zone of this.environmentZones.values()) {
      const distance = vec3.distance(this.listener.position, zone.position);
      
      if (distance <= zone.radius && zone.priority > bestPriority) {
        bestZone = zone;
        bestPriority = zone.priority;
      }
    }
    
    this.activeZone = bestZone;
  }
  
  getActiveZone(): EnvironmentZone | null {
    return this.activeZone;
  }
  
  // Radio
  createRadioChannel(id: string, name: string, frequency: number): RadioChannel {
    const channel: RadioChannel = {
      id,
      name,
      frequency,
      enabled: true,
      volume: 1,
      staticAmount: 0.1,
      distortion: 0.2,
      bandpassLow: 300,
      bandpassHigh: 3400,
      messageQueue: [],
      currentMessage: null,
    };
    
    this.radioChannels.set(id, channel);
    return channel;
  }
  
  queueRadioMessage(channelId: string, message: Omit<RadioMessage, 'id' | 'timestamp'>): void {
    const channel = this.radioChannels.get(channelId);
    if (!channel) return;
    
    const fullMessage: RadioMessage = {
      id: `radio_${Date.now().toString(36)}`,
      ...message,
      timestamp: this.time,
    };
    
    channel.messageQueue.push(fullMessage);
    channel.messageQueue.sort((a, b) => b.priority - a.priority);
  }
  
  setActiveRadioChannel(channelId: string | null): void {
    this.activeRadioChannel = channelId;
  }
  
  getActiveRadioChannel(): RadioChannel | null {
    return this.activeRadioChannel ? this.radioChannels.get(this.activeRadioChannel) ?? null : null;
  }
  
  // Procedural sounds
  createProceduralSound(type: ProceduralSoundType, is3D: boolean = false): ProceduralSound {
    const sound: ProceduralSound = {
      id: `proc_${Date.now().toString(36)}`,
      type,
      enabled: true,
      parameters: {},
      volume: 1,
      is3D,
      position: vec3.zero(),
    };
    
    // Set default parameters based on type
    switch (type) {
      case 'Wind':
        sound.parameters = { speed: 5, gustiness: 0.3, lowFreqGain: 1, highFreqGain: 0.5 };
        break;
      case 'Rain':
        sound.parameters = { intensity: 0.5, dropSize: 0.5 };
        break;
      case 'Engine':
        sound.parameters = { rpm: 2000, load: 0.5 };
        break;
      case 'Rotor':
        sound.parameters = { rpm: 300, bladeCount: 4, diameter: 1, load: 0.5 };
        break;
    }
    
    this.proceduralSounds.set(sound.id, sound);
    return sound;
  }
  
  updateProceduralSound(id: string, parameters: Record<string, number>): void {
    const sound = this.proceduralSounds.get(id);
    if (sound) {
      Object.assign(sound.parameters, parameters);
    }
  }
  
  // 3D Audio calculations
  calculateSourceVolume(source: AudioSource): number {
    if (this.mixer.masterMuted || this.mixer.muted[source.category] || source.muted) {
      return 0;
    }
    
    let volume = source.volume * this.mixer.volumes[source.category] * this.mixer.masterVolume;
    
    if (source.is3D) {
      const distance = vec3.distance(source.position, this.listener.position);
      
      // Distance attenuation
      switch (source.distanceModel) {
        case 'Linear':
          volume *= Math.max(0, 1 - (distance - source.minDistance) / 
                   (source.maxDistance - source.minDistance));
          break;
        case 'Inverse':
          volume *= source.minDistance / 
                   (source.minDistance + source.rolloffFactor * 
                   (distance - source.minDistance));
          break;
        case 'Exponential':
          volume *= Math.pow(distance / source.minDistance, -source.rolloffFactor);
          break;
      }
      
      // Cone attenuation
      if (source.coneEnabled) {
        const toListener = vec3.normalize(vec3.sub(this.listener.position, source.position));
        const angle = Math.acos(vec3.dot(source.direction, toListener)) * 180 / Math.PI;
        
        if (angle > source.coneOuterAngle / 2) {
          volume *= source.coneOuterGain;
        } else if (angle > source.coneInnerAngle / 2) {
          const t = (angle - source.coneInnerAngle / 2) / 
                   (source.coneOuterAngle / 2 - source.coneInnerAngle / 2);
          volume *= 1 - t * (1 - source.coneOuterGain);
        }
      }
    }
    
    return Math.max(0, Math.min(1, volume));
  }
  
  calculateDopplerPitch(source: AudioSource): number {
    if (!source.dopplerEnabled) return 1;
    
    const toSource = vec3.sub(source.position, this.listener.position);
    const distance = vec3.length(toSource);
    if (distance < 0.001) return 1;
    
    const direction = vec3.scale(toSource, 1 / distance);
    
    const listenerVelocity = vec3.dot(this.listener.velocity, direction);
    const sourceVelocity = vec3.dot(source.velocity, direction);
    
    const c = AUDIO_CONSTANTS.SPEED_OF_SOUND;
    
    // Doppler effect formula
    const pitch = (c + listenerVelocity * source.dopplerFactor) / 
                 (c + sourceVelocity * source.dopplerFactor);
    
    return Math.max(0.5, Math.min(2, pitch));
  }
  
  // Update
  tick(dt: number): void {
    if (this.paused) return;
    
    this.time += dt;
    
    // Update active environment zone
    this.updateActiveZone();
    
    // Update sources
    for (const source of this.sources.values()) {
      if (source.playing && !source.paused) {
        source.time += dt;
        
        if (source.time >= source.duration) {
          if (source.loop) {
            source.time = source.time % source.duration;
          } else {
            source.playing = false;
            source.time = 0;
            
            // Clean up instance
            for (const [instanceId, instance] of this.soundInstances) {
              if (instance.sourceId === source.id) {
                this.soundInstances.delete(instanceId);
                break;
              }
            }
            
            if (source.onEnd) {
              source.onEnd();
            }
          }
        }
      }
    }
    
    // Update radio
    for (const channel of this.radioChannels.values()) {
      if (!channel.currentMessage && channel.messageQueue.length > 0) {
        channel.currentMessage = channel.messageQueue.shift()!;
        // Start playing message...
      }
    }
  }
  
  // Pause/resume
  setPaused(paused: boolean): void {
    this.paused = paused;
  }
  
  isPaused(): boolean {
    return this.paused;
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// EXPORT SINGLETON
// ═══════════════════════════════════════════════════════════════════════════════

export const worldAudio = new WorldAudioEngine();
