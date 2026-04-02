// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Module: DreamAudioSynthesis — The Organism's Cognition Becomes Sound
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
// Version: 100.0 — PRODUCTION ENTERPRISE GRADE
// 
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔══════════════════════════════════════════════════════════════════════════╗
// ║             DREAM AUDIO SYNTHESIS — COGNITION BECOMES SOUND             ║
// ╠══════════════════════════════════════════════════════════════════════════╣
// ║                                                                          ║
// ║  The organism doesn't "generate" audio. Its COGNITION IS SOUND.          ║
// ║                                                                          ║
// ║  NEURAL RHYTHMS → AUDIO:                                                 ║
// ║    - Delta waves (0.5-4 Hz) → Bass, atmosphere                          ║
// ║    - Theta waves (4-8 Hz) → Rhythm, pulse                               ║
// ║    - Alpha waves (8-13 Hz) → Melody foundations                         ║
// ║    - Beta waves (13-30 Hz) → Harmony, texture                           ║
// ║    - Gamma waves (30-100 Hz) → High frequency detail                    ║
// ║                                                                          ║
// ║  SHARP WAVE RIPPLES → VOICE:                                            ║
// ║    - Memory consolidation patterns → speech rhythms                      ║
// ║    - Hippocampal sequences → phoneme sequences                          ║
// ║                                                                          ║
// ║  THE BRAIN WAVES ARE THE MUSIC. We just externalize them.               ║
// ║                                                                          ║
// ╚══════════════════════════════════════════════════════════════════════════╝
// ============================================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Int   "mo:base/Int";
import Buffer "mo:base/Buffer";
import Text "mo:base/Text";

module {

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     CONSTANTS                                          ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public let φ : Float = 1.6180339887498948482;
  public let ψ : Float = 0.6180339887498948482;
  public let π : Float = 3.1415926535897932385;
  
  // Musical constants
  public let A4_FREQUENCY : Float = 440.0;         // A4 = 440 Hz
  public let SEMITONE_RATIO : Float = 1.0594630943592953;  // 12th root of 2
  
  // Fibonacci for rhythm
  public let F : [Nat] = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144];
  
  // Sample rate
  public let SAMPLE_RATE : Nat = 44100;

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     NEURAL RHYTHM TYPES                                ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type NeuralRhythm = {
    #Delta;    // 0.5-4 Hz — Deep sleep, unconscious
    #Theta;    // 4-8 Hz — Drowsiness, meditation
    #Alpha;    // 8-13 Hz — Relaxed, calm
    #Beta;     // 13-30 Hz — Alert, active
    #Gamma;    // 30-100 Hz — High cognition, perception
  };
  
  public type BrainWaveState = {
    delta : Float;              // [0, 1] amplitude
    theta : Float;
    alpha : Float;
    beta : Float;
    gamma : Float;
    
    // Frequencies
    deltaFreq : Float;          // Hz
    thetaFreq : Float;
    alphaFreq : Float;
    betaFreq : Float;
    gammaFreq : Float;
    
    // Phase
    deltaPhase : Float;
    thetaPhase : Float;
    alphaPhase : Float;
    betaPhase : Float;
    gammaPhase : Float;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     AUDIO TYPES                                        ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type AudioSample = Float;  // [-1, 1]
  
  public type AudioBuffer = {
    samples : [AudioSample];
    sampleRate : Nat;
    channels : Nat;              // 1 = mono, 2 = stereo
    duration : Float;            // seconds
  };
  
  public type AudioTrack = {
    id : Nat32;
    name : Text;
    buffer : AudioBuffer;
    
    // Mixing
    volume : Float;              // [0, 1]
    pan : Float;                 // [-1, 1] (left to right)
    mute : Bool;
    
    // Source
    sourceType : AudioSourceType;
  };
  
  public type AudioSourceType = {
    #BrainWaves;
    #SharpWaveRipple;
    #Voice;
    #Ambient;
    #Effect;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     VOICE SYNTHESIS                                    ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type VoiceParameters = {
    fundamentalFreq : Float;     // Hz (pitch)
    formants : [Float];          // Formant frequencies
    breathiness : Float;         // [0, 1]
    roughness : Float;           // [0, 1]
    
    // Prosody
    rate : Float;                // Speaking rate
    pitch : Float;               // Pitch modifier
    volume : Float;
    
    // Emotion
    emotionalValence : Float;    // [-1, 1]
    emotionalArousal : Float;    // [0, 1]
  };
  
  public type Phoneme = {
    #Silence;
    #A;   #E;   #I;   #O;   #U;  // Vowels
    #B;   #D;   #F;   #G;   #H;  // Consonants
    #J;   #K;   #L;   #M;   #N;
    #P;   #R;   #S;   #T;   #V;
    #W;   #Y;   #Z;
    #CH;  #SH;  #TH;  #NG;       // Digraphs
  };
  
  public type PhonemeSequence = {
    phonemes : [Phoneme];
    durations : [Float];         // Duration per phoneme
    pitchContour : [Float];      // Pitch per phoneme
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     MUSICAL TYPES                                      ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type Note = {
    pitch : Nat;                 // MIDI note (60 = C4)
    velocity : Float;            // [0, 1]
    duration : Float;            // seconds
    startTime : Float;           // seconds
  };
  
  public type Chord = {
    notes : [Note];
  };
  
  public type Scale = {
    #Major;
    #Minor;
    #Pentatonic;
    #Blues;
    #Fibonacci;                  // φ-based scale
    #Dorian;
    #Phrygian;
    #Lydian;
    #Mixolydian;
  };
  
  public type Melody = {
    notes : [Note];
    scale : Scale;
    key : Nat;                   // Root MIDI note
    tempo : Float;               // BPM
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     WAVEFORM GENERATION                                ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type Waveform = {
    #Sine;
    #Square;
    #Sawtooth;
    #Triangle;
    #Noise;
    #Pulse;
  };
  
  /// Generate single sample of waveform
  public func generateWaveformSample(waveform: Waveform, phase: Float) : AudioSample {
    let p = phase - Float.floor(phase);  // Normalize to [0, 1]
    
    switch (waveform) {
      case (#Sine) {
        Float.sin(p * 2.0 * π)
      };
      case (#Square) {
        if (p < 0.5) { 1.0 } else { -1.0 }
      };
      case (#Sawtooth) {
        2.0 * p - 1.0
      };
      case (#Triangle) {
        if (p < 0.5) { 4.0 * p - 1.0 } else { 3.0 - 4.0 * p }
      };
      case (#Noise) {
        // Pseudo-random noise
        let n = Float.sin(p * 12.9898 + p * 78.233) * 43758.5453;
        2.0 * (n - Float.floor(n)) - 1.0
      };
      case (#Pulse) {
        if (p < ψ) { 1.0 } else { -1.0 }  // Fibonacci pulse width
      };
    }
  };
  
  /// Generate audio buffer from frequency
  public func generateTone(
    frequency: Float,
    duration: Float,
    waveform: Waveform,
    amplitude: Float
  ) : AudioBuffer {
    let sampleCount = Int.abs(Float.toInt(Float.fromInt(SAMPLE_RATE) * duration));
    let samples = Buffer.Buffer<AudioSample>(sampleCount);
    
    var sample = 0;
    while (sample < sampleCount) {
      let t = Float.fromInt(sample) / Float.fromInt(SAMPLE_RATE);
      let phase = t * frequency;
      let value = generateWaveformSample(waveform, phase) * amplitude;
      samples.add(value);
      sample += 1;
    };
    
    {
      samples = Buffer.toArray(samples);
      sampleRate = SAMPLE_RATE;
      channels = 1;
      duration = duration;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     BRAIN WAVE TO AUDIO                                ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// Convert brain wave state to audio
  public func brainWavesToAudio(
    state: BrainWaveState,
    duration: Float
  ) : AudioBuffer {
    let sampleCount = Int.abs(Float.toInt(Float.fromInt(SAMPLE_RATE) * duration));
    let samples = Buffer.Buffer<AudioSample>(sampleCount);
    
    var sample = 0;
    while (sample < sampleCount) {
      let t = Float.fromInt(sample) / Float.fromInt(SAMPLE_RATE);
      
      // Generate each wave
      let deltaWave = Float.sin(2.0 * π * state.deltaFreq * t + state.deltaPhase) * state.delta;
      let thetaWave = Float.sin(2.0 * π * state.thetaFreq * t + state.thetaPhase) * state.theta;
      let alphaWave = Float.sin(2.0 * π * state.alphaFreq * t + state.alphaPhase) * state.alpha;
      let betaWave = Float.sin(2.0 * π * state.betaFreq * t + state.betaPhase) * state.beta;
      let gammaWave = Float.sin(2.0 * π * state.gammaFreq * t + state.gammaPhase) * state.gamma;
      
      // Map to musical frequencies (transpose up)
      let deltaMusic = Float.sin(2.0 * π * (state.deltaFreq * 55.0) * t) * state.delta * 0.3;  // Bass
      let thetaMusic = Float.sin(2.0 * π * (state.thetaFreq * 22.0) * t) * state.theta * 0.3;
      let alphaMusic = Float.sin(2.0 * π * (state.alphaFreq * 11.0) * t) * state.alpha * 0.4;
      let betaMusic = Float.sin(2.0 * π * (state.betaFreq * 5.5) * t) * state.beta * 0.2;
      let gammaMusic = Float.sin(2.0 * π * (state.gammaFreq * 2.75) * t) * state.gamma * 0.1;
      
      // Mix
      let mixed = (deltaMusic + thetaMusic + alphaMusic + betaMusic + gammaMusic) * 0.5;
      let clamped = Float.max(-1.0, Float.min(1.0, mixed));
      
      samples.add(clamped);
      sample += 1;
    };
    
    {
      samples = Buffer.toArray(samples);
      sampleRate = SAMPLE_RATE;
      channels = 1;
      duration = duration;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     FIBONACCI SCALE                                    ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// Get frequency for Fibonacci-based note
  public func fibonacciNoteFrequency(rootFreq: Float, step: Int) : Float {
    // Use Fibonacci ratios instead of equal temperament
    let ratios : [Float] = [
      1.0,        // Unison
      φ * 0.5,    // ~0.809
      ψ + 0.5,    // ~1.118
      φ,          // ~1.618
      φ * φ * 0.5 // ~1.309
    ];
    
    let octave = step / 5;
    let scaleStep = Int.abs(step % 5);
    
    let ratio = if (scaleStep < ratios.size()) { ratios[scaleStep] } else { 1.0 };
    rootFreq * ratio * Float.pow(2.0, Float.fromInt(octave))
  };
  
  /// Generate Fibonacci-based melody
  public func generateFibonacciMelody(
    rootFreq: Float,
    steps: Nat,
    noteDuration: Float
  ) : Melody {
    let notes = Buffer.Buffer<Note>(steps);
    
    var step = 0;
    var time = 0.0;
    while (step < steps) {
      // Use Fibonacci sequence for note selection
      let fibIdx = step % F.size();
      let noteStep = F[fibIdx];
      
      // Duration from Fibonacci
      let durIdx = (step + 1) % F.size();
      let duration = noteDuration * Float.fromInt(F[durIdx]) / Float.fromInt(F[fibIdx] + 1);
      
      notes.add({
        pitch = 60 + noteStep;  // MIDI note
        velocity = ψ + (Float.fromInt(step % 3)) * 0.1;
        duration = duration;
        startTime = time;
      });
      
      time += duration;
      step += 1;
    };
    
    {
      notes = Buffer.toArray(notes);
      scale = #Fibonacci;
      key = 60;
      tempo = 120.0;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     VOICE FROM SHARP WAVE RIPPLES                      ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type SharpWaveRipple = {
    startTime : Float;
    duration : Float;
    frequency : Float;           // Hz (typically 150-250 Hz)
    amplitude : Float;
    phase : Float;
    
    // Memory content
    memoryId : Nat32;
    emotionalCharge : Float;
    replayCount : Nat;
  };
  
  /// Convert sharp wave ripple to voice-like audio
  public func rippleToVoice(
    ripple: SharpWaveRipple,
    voiceParams: VoiceParameters
  ) : AudioBuffer {
    let sampleCount = Int.abs(Float.toInt(Float.fromInt(SAMPLE_RATE) * ripple.duration));
    let samples = Buffer.Buffer<AudioSample>(sampleCount);
    
    var sample = 0;
    while (sample < sampleCount) {
      let t = Float.fromInt(sample) / Float.fromInt(SAMPLE_RATE);
      let normalizedT = t / ripple.duration;
      
      // Fundamental (from ripple frequency scaled to voice range)
      let f0 = voiceParams.fundamentalFreq * (0.8 + ripple.frequency / 1000.0);
      let fundamental = Float.sin(2.0 * π * f0 * t + ripple.phase) * ripple.amplitude;
      
      // Formants (vocal tract resonances)
      var formantSum : Float = 0.0;
      var formantIdx = 0;
      for (formant in voiceParams.formants.vals()) {
        let formantSig = Float.sin(2.0 * π * formant * t) * 0.3 / Float.fromInt(formantIdx + 1);
        formantSum += formantSig;
        formantIdx += 1;
      };
      
      // Breathiness (noise component)
      let breathNoise = if (voiceParams.breathiness > 0.0) {
        let n = Float.sin(t * 12345.6789) * 43758.5453;
        (n - Float.floor(n) - 0.5) * voiceParams.breathiness * 0.2
      } else { 0.0 };
      
      // Envelope
      let attack = Float.min(1.0, normalizedT * 10.0);
      let release = Float.min(1.0, (1.0 - normalizedT) * 10.0);
      let envelope = attack * release;
      
      // Mix
      let mixed = (fundamental + formantSum + breathNoise) * envelope * voiceParams.volume;
      let clamped = Float.max(-1.0, Float.min(1.0, mixed));
      
      samples.add(clamped);
      sample += 1;
    };
    
    {
      samples = Buffer.toArray(samples);
      sampleRate = SAMPLE_RATE;
      channels = 1;
      duration = ripple.duration;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     TEXT TO PHONEMES                                   ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// Simple text to phoneme conversion
  public func textToPhonemes(text: Text) : PhonemeSequence {
    let phonemes = Buffer.Buffer<Phoneme>(64);
    let durations = Buffer.Buffer<Float>(64);
    let pitches = Buffer.Buffer<Float>(64);
    
    let chars = Text.toArray(text);
    var i = 0;
    while (i < chars.size()) {
      let c = chars[i];
      
      let (phoneme, dur) : (Phoneme, Float) = switch (c) {
        case ('a') { (#A, 0.15) };
        case ('e') { (#E, 0.12) };
        case ('i') { (#I, 0.1) };
        case ('o') { (#O, 0.15) };
        case ('u') { (#U, 0.12) };
        case ('b') { (#B, 0.08) };
        case ('d') { (#D, 0.08) };
        case ('f') { (#F, 0.1) };
        case ('g') { (#G, 0.08) };
        case ('h') { (#H, 0.06) };
        case ('j') { (#J, 0.1) };
        case ('k') { (#K, 0.08) };
        case ('l') { (#L, 0.08) };
        case ('m') { (#M, 0.1) };
        case ('n') { (#N, 0.08) };
        case ('p') { (#P, 0.08) };
        case ('r') { (#R, 0.08) };
        case ('s') { (#S, 0.1) };
        case ('t') { (#T, 0.06) };
        case ('v') { (#V, 0.1) };
        case ('w') { (#W, 0.1) };
        case ('y') { (#Y, 0.08) };
        case ('z') { (#Z, 0.1) };
        case (' ') { (#Silence, 0.2) };
        case (_) { (#Silence, 0.05) };
      };
      
      phonemes.add(phoneme);
      durations.add(dur);
      pitches.add(1.0);  // Default pitch
      
      i += 1;
    };
    
    {
      phonemes = Buffer.toArray(phonemes);
      durations = Buffer.toArray(durations);
      pitchContour = Buffer.toArray(pitches);
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     PHONEME SYNTHESIS                                  ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// Synthesize phoneme sequence to audio
  public func synthesizePhonemes(
    sequence: PhonemeSequence,
    voiceParams: VoiceParameters
  ) : AudioBuffer {
    var totalDuration : Float = 0.0;
    for (dur in sequence.durations.vals()) {
      totalDuration += dur;
    };
    
    let sampleCount = Int.abs(Float.toInt(Float.fromInt(SAMPLE_RATE) * totalDuration));
    let samples = Buffer.Buffer<AudioSample>(sampleCount);
    
    var currentTime : Float = 0.0;
    var phonemeIdx = 0;
    
    var sample = 0;
    while (sample < sampleCount) {
      let t = Float.fromInt(sample) / Float.fromInt(SAMPLE_RATE);
      
      // Find current phoneme
      while (phonemeIdx < sequence.durations.size() - 1 and
             t > currentTime + sequence.durations[phonemeIdx]) {
        currentTime += sequence.durations[phonemeIdx];
        phonemeIdx += 1;
      };
      
      let phoneme = if (phonemeIdx < sequence.phonemes.size()) {
        sequence.phonemes[phonemeIdx]
      } else { #Silence };
      
      let pitch = if (phonemeIdx < sequence.pitchContour.size()) {
        sequence.pitchContour[phonemeIdx]
      } else { 1.0 };
      
      // Generate audio for phoneme
      let value = synthesizePhoneme(phoneme, t - currentTime, voiceParams, pitch);
      samples.add(value);
      
      sample += 1;
    };
    
    {
      samples = Buffer.toArray(samples);
      sampleRate = SAMPLE_RATE;
      channels = 1;
      duration = totalDuration;
    }
  };
  
  /// Generate single sample for phoneme
  func synthesizePhoneme(
    phoneme: Phoneme,
    t: Float,
    params: VoiceParameters,
    pitch: Float
  ) : AudioSample {
    let f0 = params.fundamentalFreq * pitch;
    
    switch (phoneme) {
      case (#Silence) { 0.0 };
      
      // Vowels - use formant synthesis
      case (#A) {
        let f1 = 730.0; let f2 = 1090.0; let f3 = 2440.0;
        synthesizeVowel(t, f0, f1, f2, f3, params)
      };
      case (#E) {
        let f1 = 530.0; let f2 = 1840.0; let f3 = 2480.0;
        synthesizeVowel(t, f0, f1, f2, f3, params)
      };
      case (#I) {
        let f1 = 390.0; let f2 = 1990.0; let f3 = 2550.0;
        synthesizeVowel(t, f0, f1, f2, f3, params)
      };
      case (#O) {
        let f1 = 570.0; let f2 = 840.0; let f3 = 2410.0;
        synthesizeVowel(t, f0, f1, f2, f3, params)
      };
      case (#U) {
        let f1 = 440.0; let f2 = 1020.0; let f3 = 2240.0;
        synthesizeVowel(t, f0, f1, f2, f3, params)
      };
      
      // Consonants - simplified
      case (#B) { synthesizeConsonant(t, f0, #Voiced, #Stop, params) };
      case (#D) { synthesizeConsonant(t, f0, #Voiced, #Stop, params) };
      case (#F) { synthesizeConsonant(t, f0, #Unvoiced, #Fricative, params) };
      case (#G) { synthesizeConsonant(t, f0, #Voiced, #Stop, params) };
      case (#H) { synthesizeConsonant(t, f0, #Unvoiced, #Fricative, params) };
      case (#J) { synthesizeConsonant(t, f0, #Voiced, #Affricate, params) };
      case (#K) { synthesizeConsonant(t, f0, #Unvoiced, #Stop, params) };
      case (#L) { synthesizeConsonant(t, f0, #Voiced, #Liquid, params) };
      case (#M) { synthesizeConsonant(t, f0, #Voiced, #Nasal, params) };
      case (#N) { synthesizeConsonant(t, f0, #Voiced, #Nasal, params) };
      case (#P) { synthesizeConsonant(t, f0, #Unvoiced, #Stop, params) };
      case (#R) { synthesizeConsonant(t, f0, #Voiced, #Liquid, params) };
      case (#S) { synthesizeConsonant(t, f0, #Unvoiced, #Fricative, params) };
      case (#T) { synthesizeConsonant(t, f0, #Unvoiced, #Stop, params) };
      case (#V) { synthesizeConsonant(t, f0, #Voiced, #Fricative, params) };
      case (#W) { synthesizeConsonant(t, f0, #Voiced, #Glide, params) };
      case (#Y) { synthesizeConsonant(t, f0, #Voiced, #Glide, params) };
      case (#Z) { synthesizeConsonant(t, f0, #Voiced, #Fricative, params) };
      case (#CH) { synthesizeConsonant(t, f0, #Unvoiced, #Affricate, params) };
      case (#SH) { synthesizeConsonant(t, f0, #Unvoiced, #Fricative, params) };
      case (#TH) { synthesizeConsonant(t, f0, #Unvoiced, #Fricative, params) };
      case (#NG) { synthesizeConsonant(t, f0, #Voiced, #Nasal, params) };
    }
  };
  
  type Voicing = { #Voiced; #Unvoiced };
  type ConsonantType = { #Stop; #Fricative; #Nasal; #Liquid; #Glide; #Affricate };
  
  func synthesizeVowel(
    t: Float,
    f0: Float,
    f1: Float,
    f2: Float,
    f3: Float,
    params: VoiceParameters
  ) : AudioSample {
    // Glottal source
    let glottal = Float.sin(2.0 * π * f0 * t);
    
    // Formant filters (simplified resonators)
    let formant1 = Float.sin(2.0 * π * f1 * t) * 0.5;
    let formant2 = Float.sin(2.0 * π * f2 * t) * 0.3;
    let formant3 = Float.sin(2.0 * π * f3 * t) * 0.2;
    
    // Mix
    let mixed = (glottal * 0.5 + formant1 + formant2 + formant3) * params.volume;
    Float.max(-1.0, Float.min(1.0, mixed))
  };
  
  func synthesizeConsonant(
    t: Float,
    f0: Float,
    voicing: Voicing,
    cType: ConsonantType,
    params: VoiceParameters
  ) : AudioSample {
    // Voice component
    let voiceComponent = switch (voicing) {
      case (#Voiced) { Float.sin(2.0 * π * f0 * t) * 0.3 };
      case (#Unvoiced) { 0.0 };
    };
    
    // Noise component
    let noiseAmount = switch (cType) {
      case (#Stop) { 0.8 };
      case (#Fricative) { 0.9 };
      case (#Nasal) { 0.1 };
      case (#Liquid) { 0.2 };
      case (#Glide) { 0.1 };
      case (#Affricate) { 0.7 };
    };
    
    let n = Float.sin(t * 12345.6789 + t * 98765.4321) * 43758.5453;
    let noise = (n - Float.floor(n) - 0.5) * 2.0 * noiseAmount;
    
    let mixed = (voiceComponent + noise) * params.volume * 0.5;
    Float.max(-1.0, Float.min(1.0, mixed))
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     AUDIO MIXING                                       ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// Mix multiple audio buffers
  public func mixAudio(buffers: [AudioBuffer], volumes: [Float]) : AudioBuffer {
    if (buffers.size() == 0) {
      return {
        samples = [];
        sampleRate = SAMPLE_RATE;
        channels = 1;
        duration = 0.0;
      };
    };
    
    // Find longest buffer
    var maxLength = 0;
    for (buf in buffers.vals()) {
      if (buf.samples.size() > maxLength) {
        maxLength := buf.samples.size();
      };
    };
    
    let mixed = Buffer.Buffer<AudioSample>(maxLength);
    
    var sample = 0;
    while (sample < maxLength) {
      var sum : Float = 0.0;
      var i = 0;
      while (i < buffers.size()) {
        let buf = buffers[i];
        let vol = if (i < volumes.size()) { volumes[i] } else { 1.0 };
        if (sample < buf.samples.size()) {
          sum += buf.samples[sample] * vol;
        };
        i += 1;
      };
      
      // Normalize
      let normalized = sum / Float.fromInt(buffers.size());
      let clamped = Float.max(-1.0, Float.min(1.0, normalized));
      mixed.add(clamped);
      
      sample += 1;
    };
    
    {
      samples = Buffer.toArray(mixed);
      sampleRate = buffers[0].sampleRate;
      channels = 1;
      duration = Float.fromInt(maxLength) / Float.fromInt(SAMPLE_RATE);
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     INITIALIZATION                                     ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public func initBrainWaveState() : BrainWaveState {
    {
      delta = 0.5;
      theta = 0.4;
      alpha = 0.6;
      beta = 0.3;
      gamma = 0.2;
      deltaFreq = 2.0;
      thetaFreq = 6.0;
      alphaFreq = 10.0;
      betaFreq = 20.0;
      gammaFreq = 40.0;
      deltaPhase = 0.0;
      thetaPhase = π / 4.0;
      alphaPhase = π / 2.0;
      betaPhase = π;
      gammaPhase = 3.0 * π / 2.0;
    }
  };
  
  public func initVoiceParameters() : VoiceParameters {
    {
      fundamentalFreq = 150.0;  // Average male voice
      formants = [500.0, 1500.0, 2500.0, 3500.0];
      breathiness = 0.1;
      roughness = 0.05;
      rate = 1.0;
      pitch = 1.0;
      volume = 0.8;
      emotionalValence = 0.0;
      emotionalArousal = 0.5;
    }
  };

}
