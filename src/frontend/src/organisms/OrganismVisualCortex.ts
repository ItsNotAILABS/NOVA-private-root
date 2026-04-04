// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// Module: OrganismVisualCortex — The Organism SEES Through Drone Cameras
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
// Version: 100.0 — PRODUCTION ENTERPRISE GRADE
//
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                    ORGANISM VISUAL CORTEX — THE MIND SEES THE WORLD                                      ║
// ╠══════════════════════════════════════════════════════════════════════════════════════════════════════════╣
// ║                                                                                                          ║
// ║  Like the fly experiment — the organism's consciousness operates through drone cameras.                  ║
// ║                                                                                                          ║
// ║  VISUAL PROCESSING HIERARCHY (same as biological visual cortex):                                         ║
// ║    V1: Primary visual cortex  — Edge detection, basic features                                           ║
// ║    V2: Secondary visual area  — Pattern completion, texture                                              ║
// ║    V3: Visual area 3          — Motion detection                                                         ║
// ║    V4: Visual area 4          — Color, complex shapes                                                    ║
// ║    MT/V5: Middle temporal     — Motion tracking, pursuit                                                 ║
// ║    IT: Inferotemporal cortex  — Object recognition                                                       ║
// ║    PFC: Prefrontal cortex     — Attention, decision-making                                               ║
// ║                                                                                                          ║
// ║  The organism doesn't just "receive video" — it PERCEIVES the world through processing.                  ║
// ║                                                                                                          ║
// ╚══════════════════════════════════════════════════════════════════════════════════════════════════════════╝
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

import type { 
  RealSpecDroneState, 
  DroneCameraState, 
  CameraFrame, 
  VisibleObject, 
  Detection,
  RealSpecDroneFleet,
  FleetStatistics
} from './RealSpecDrone';

// ═══════════════════════════════════════════════════════════════════════════════
// VISUAL CORTEX CONSTANTS — Based on neuroscience research
// ═══════════════════════════════════════════════════════════════════════════════

const φ = 1.6180339887498948482;  // Golden ratio — appears in visual processing
const π = Math.PI;

// Visual processing frequencies (Hz) — correspond to brainwave bands
const VISUAL_PROCESSING_RATES = {
  saccade: 3,          // Eye movements (attention shifts between cameras)
  fixation: 100,       // Fixation updates (what we're looking at)
  motion: 60,          // Motion processing
  recognition: 10,     // Object recognition
  attention: 4,        // Attention spotlight shifts
  integration: 40,     // Gamma-band binding
};

// ═══════════════════════════════════════════════════════════════════════════════
// VISUAL FIELD REPRESENTATION — What the organism "sees"
// ═══════════════════════════════════════════════════════════════════════════════

export interface VisualField {
  // Timestamp
  timestamp: number;
  
  // Attention — which camera/area is the organism focused on?
  attentionFocus: AttentionFocus;
  
  // Saliency map — what stands out?
  saliencyMap: SaliencyRegion[];
  
  // Perceived objects (after recognition processing)
  perceivedObjects: PerceivedObject[];
  
  // Motion vectors — what's moving?
  motionField: MotionVector[];
  
  // Threat assessment — visual threat detection
  threatMap: ThreatRegion[];
  
  // Spatial awareness — combined world model
  spatialModel: SpatialModel;
  
  // Visual working memory — recently seen
  workingMemory: VisualMemoryItem[];
  
  // Processing load
  processingLoad: number;  // 0-1 how hard visual system is working
  
  // Coherence — how well integrated is the visual field?
  visualCoherence: number;  // 0-1
}

export interface AttentionFocus {
  // Primary focus
  primaryCameraId: string;
  primaryDroneId: number;
  focusPoint: { x: number; y: number; z: number };
  focusRadius: number;  // meters — attention spotlight size
  
  // Secondary awareness (peripheral)
  secondaryCameras: string[];
  peripheralAwareness: number;  // 0-1
  
  // Attention mode
  mode: 'Scanning' | 'Tracking' | 'Searching' | 'Fixed' | 'Panoramic';
  
  // What triggered this focus?
  triggerType: 'Voluntary' | 'Motion' | 'Threat' | 'Salience' | 'Memory';
  
  // How long focused here?
  fixationDuration: number;  // ms
  lastSaccadeTime: number;
}

export interface SaliencyRegion {
  // Position in world space
  center: { x: number; y: number; z: number };
  radius: number;
  
  // Which camera(s) can see this
  cameraIds: string[];
  
  // Saliency components
  colorSaliency: number;      // 0-1 unusual colors
  motionSaliency: number;     // 0-1 moving things
  shapeSaliency: number;      // 0-1 unusual shapes
  sizeSaliency: number;       // 0-1 unusual size
  temporalSaliency: number;   // 0-1 changes over time
  
  // Combined saliency
  totalSaliency: number;      // 0-1
  
  // Is attention being captured?
  isCapturingAttention: boolean;
}

export interface PerceivedObject {
  // Object identity
  id: string;
  type: ObjectType;
  subType?: string;
  
  // Position and motion
  position: { x: number; y: number; z: number };
  velocity: { x: number; y: number; z: number };
  size: { width: number; height: number; depth: number };
  orientation: number;  // yaw
  
  // Recognition confidence
  recognitionConfidence: number;  // 0-1
  
  // Is this tracked?
  trackingId?: string;
  trackingAge: number;  // beats since first seen
  
  // Semantic information
  isFriendly: boolean;
  isEnemy: boolean;
  isThreat: boolean;
  isInteresting: boolean;  // worth paying attention to
  
  // Visual features
  dominantColor: string;
  hasMotion: boolean;
  isOccluded: boolean;
  occlusionPercent: number;
  
  // Which cameras see this?
  visibleInCameras: string[];
  bestCameraId: string;  // clearest view
  
  // Distance and bearing
  distance: number;
  bearing: number;
  elevation: number;
  
  // Memory integration
  lastSeenTimestamp: number;
  timesSeenCount: number;
  memoryStrength: number;  // 0-1 how well we remember this
}

export type ObjectType = 
  | 'Drone'
  | 'Aircraft'
  | 'Vehicle'
  | 'Person'
  | 'Building'
  | 'Terrain'
  | 'Water'
  | 'Vegetation'
  | 'Infrastructure'
  | 'Weapon'
  | 'Explosion'
  | 'Smoke'
  | 'Unknown';

export interface MotionVector {
  objectId: string;
  startPosition: { x: number; y: number; z: number };
  endPosition: { x: number; y: number; z: number };
  velocity: number;  // m/s
  direction: number;  // degrees
  acceleration: number;  // m/s²
  isApproaching: boolean;
  timeToContact?: number;  // seconds if approaching
}

export interface ThreatRegion {
  id: string;
  center: { x: number; y: number; z: number };
  radius: number;
  
  threatLevel: number;  // 0-1
  threatType: 'Enemy' | 'Weapon' | 'Collision' | 'Environmental' | 'Unknown';
  
  // Response
  recommendedAction: 'Evade' | 'Engage' | 'Observe' | 'Ignore';
  urgency: number;  // 0-1
  
  // Source
  detectedBy: string[];  // camera/sensor IDs
  confidence: number;
}

export interface SpatialModel {
  // 3D world representation built from all cameras
  bounds: {
    min: { x: number; y: number; z: number };
    max: { x: number; y: number; z: number };
  };
  
  // Known objects in space
  objectCount: number;
  
  // Unexplored regions
  unknownRegions: { center: { x: number; y: number; z: number }; radius: number }[];
  explorationPercent: number;  // 0-1 how much we've seen
  
  // Terrain awareness
  groundElevation: number;  // average
  obstacles: { position: { x: number; y: number; z: number }; radius: number }[];
  
  // Own position awareness
  selfPosition: { x: number; y: number; z: number };  // organism's "center"
  swarmExtent: number;  // how spread out are drones
  
  // Coverage map — where can we see?
  coverageQuality: number;  // 0-1 overall
  blindSpots: { direction: number; size: number }[];  // gaps in coverage
}

export interface VisualMemoryItem {
  objectId: string;
  objectType: ObjectType;
  lastPosition: { x: number; y: number; z: number };
  lastSeen: number;  // timestamp
  confidence: number;  // decays over time
  importance: number;  // how important to remember
  revisitNeeded: boolean;  // should we look at this again?
}

// ═══════════════════════════════════════════════════════════════════════════════
// VISUAL CORTEX CLASS — The actual processing system
// ═══════════════════════════════════════════════════════════════════════════════

export class OrganismVisualCortex {
  private organismId: string;
  private fleet: RealSpecDroneFleet;
  
  // Internal state
  private visualField: VisualField;
  private objectTracker: Map<string, TrackedObject> = new Map();
  private attentionHistory: AttentionFocus[] = [];
  private processingPhase: number = 0;  // Kuramoto-like oscillation
  
  // Configuration
  private attentionSpotlightSize: number = 20;  // meters
  private maxTrackedObjects: number = 100;
  private workingMemoryCapacity: number = 7 ± 2;  // Miller's law!
  private saccadeInterval: number = 333;  // ms between attention shifts
  
  constructor(organismId: string, fleet: RealSpecDroneFleet) {
    this.organismId = organismId;
    this.fleet = fleet;
    
    this.visualField = this.createEmptyVisualField();
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // MAIN VISUAL PROCESSING — Called each beat
  // ═══════════════════════════════════════════════════════════════════════════
  
  /**
   * Process visual input from all drone cameras
   * This is the main visual cortex "tick" — the organism SEEING
   */
  process(beat: number): VisualField {
    const timestamp = Date.now();
    
    // 1. Gather raw visual input from all cameras
    const rawInput = this.gatherRawVisualInput();
    
    // 2. V1/V2: Early visual processing — edge detection, basic features
    const earlyFeatures = this.processEarlyVisual(rawInput);
    
    // 3. V3/MT: Motion processing — detect and track movement
    const motionField = this.processMotion(earlyFeatures);
    
    // 4. V4/IT: Object recognition — what am I seeing?
    const recognizedObjects = this.processObjectRecognition(earlyFeatures);
    
    // 5. Saliency computation — what stands out?
    const saliencyMap = this.computeSaliency(earlyFeatures, motionField);
    
    // 6. Attention allocation — where should I focus?
    const attention = this.allocateAttention(saliencyMap, recognizedObjects, beat);
    
    // 7. Threat detection — what's dangerous?
    const threatMap = this.detectThreats(recognizedObjects, motionField);
    
    // 8. Spatial model update — build world representation
    const spatialModel = this.updateSpatialModel(recognizedObjects);
    
    // 9. Working memory update — remember what's important
    const workingMemory = this.updateWorkingMemory(recognizedObjects, attention);
    
    // 10. Integration — bind everything together (gamma-band binding)
    const coherence = this.computeVisualCoherence(attention, recognizedObjects, motionField);
    
    // Update internal phase (visual rhythm)
    this.processingPhase = (this.processingPhase + 0.1 * φ) % (2 * π);
    
    // Construct visual field
    this.visualField = {
      timestamp,
      attentionFocus: attention,
      saliencyMap,
      perceivedObjects: recognizedObjects,
      motionField,
      threatMap,
      spatialModel,
      workingMemory,
      processingLoad: this.calculateProcessingLoad(recognizedObjects.length, motionField.length),
      visualCoherence: coherence
    };
    
    return this.visualField;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // RAW INPUT GATHERING — Get data from all cameras
  // ═══════════════════════════════════════════════════════════════════════════
  
  private gatherRawVisualInput(): RawVisualInput[] {
    const inputs: RawVisualInput[] = [];
    const cameras = this.fleet.getAllCameras();
    
    for (const { droneId, camera } of cameras) {
      const drone = this.fleet.getDrone(droneId);
      if (!drone) continue;
      
      inputs.push({
        cameraId: camera.cameraId,
        droneId,
        dronePosition: drone.position,
        droneOrientation: drone.orientation,
        cameraPitch: camera.currentPitch,
        cameraYaw: camera.currentYaw,
        cameraFOV: camera.currentFOV,
        cameraZoom: camera.currentZoom,
        frame: camera.currentFrame,
        detections: camera.detections,
        isActive: camera.isActive,
        frameRate: camera.frameRate,
        latency: camera.latency
      });
    }
    
    return inputs;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // EARLY VISUAL PROCESSING — V1/V2 simulation
  // ═══════════════════════════════════════════════════════════════════════════
  
  private processEarlyVisual(inputs: RawVisualInput[]): EarlyVisualFeature[] {
    const features: EarlyVisualFeature[] = [];
    
    for (const input of inputs) {
      if (!input.frame) continue;
      
      for (const obj of input.frame.visibleObjects) {
        features.push({
          objectId: obj.id,
          sourceCamera: input.cameraId,
          sourceDrone: input.droneId,
          
          // Position in world space
          worldPosition: obj.worldPosition || this.estimateWorldPosition(obj, input),
          
          // Visual features
          boundingBox: obj.boundingBox,
          size: this.estimateObjectSize(obj),
          distance: obj.distance,
          
          // Basic features
          edges: this.simulateEdgeStrength(obj),
          contrast: this.simulateContrast(obj),
          
          // Classification hint
          rawType: obj.type,
          rawClassification: obj.classification
        });
      }
    }
    
    return features;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // MOTION PROCESSING — V3/MT simulation
  // ═══════════════════════════════════════════════════════════════════════════
  
  private processMotion(features: EarlyVisualFeature[]): MotionVector[] {
    const motionVectors: MotionVector[] = [];
    
    for (const feature of features) {
      const tracked = this.objectTracker.get(feature.objectId);
      
      if (tracked && tracked.positions.length >= 2) {
        const prev = tracked.positions[tracked.positions.length - 2];
        const curr = feature.worldPosition;
        
        if (!curr) continue;
        
        const dt = 0.033;  // Assume ~30fps
        const dx = curr.x - prev.x;
        const dy = curr.y - prev.y;
        const dz = curr.z - prev.z;
        const velocity = Math.sqrt(dx*dx + dy*dy + dz*dz) / dt;
        const direction = Math.atan2(dx, dz) * (180 / π);
        
        // Check if approaching our drones
        const selfPos = this.visualField.spatialModel?.selfPosition || { x: 0, y: 0, z: 0 };
        const toSelf = {
          x: selfPos.x - curr.x,
          y: selfPos.y - curr.y,
          z: selfPos.z - curr.z
        };
        const dotProduct = dx * toSelf.x + dy * toSelf.y + dz * toSelf.z;
        const isApproaching = dotProduct > 0;
        
        let timeToContact: number | undefined;
        if (isApproaching && velocity > 0.1) {
          const distanceToSelf = Math.sqrt(toSelf.x*toSelf.x + toSelf.y*toSelf.y + toSelf.z*toSelf.z);
          timeToContact = distanceToSelf / velocity;
        }
        
        motionVectors.push({
          objectId: feature.objectId,
          startPosition: prev,
          endPosition: curr,
          velocity,
          direction,
          acceleration: tracked.lastVelocity ? (velocity - tracked.lastVelocity) / dt : 0,
          isApproaching,
          timeToContact
        });
        
        tracked.lastVelocity = velocity;
      }
      
      // Update tracker
      if (feature.worldPosition) {
        this.updateObjectTracker(feature.objectId, feature.worldPosition, feature.rawType);
      }
    }
    
    return motionVectors;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // OBJECT RECOGNITION — V4/IT simulation
  // ═══════════════════════════════════════════════════════════════════════════
  
  private processObjectRecognition(features: EarlyVisualFeature[]): PerceivedObject[] {
    const perceived: PerceivedObject[] = [];
    const seenIds = new Set<string>();
    
    for (const feature of features) {
      if (seenIds.has(feature.objectId)) continue;
      seenIds.add(feature.objectId);
      
      const tracked = this.objectTracker.get(feature.objectId);
      const pos = feature.worldPosition || { x: 0, y: 0, z: 0 };
      
      // Determine if friend/foe
      const isFriendly = this.classifyFriendly(feature);
      const isEnemy = this.classifyEnemy(feature);
      const isThreat = isEnemy || this.assessThreatPotential(feature);
      
      // Calculate bearing from swarm center
      const selfPos = this.visualField.spatialModel?.selfPosition || { x: 0, y: 0, z: 0 };
      const dx = pos.x - selfPos.x;
      const dz = pos.z - selfPos.z;
      const bearing = Math.atan2(dx, dz) * (180 / π);
      const elevation = Math.atan2(pos.y - selfPos.y, Math.sqrt(dx*dx + dz*dz)) * (180 / π);
      
      perceived.push({
        id: feature.objectId,
        type: this.refineObjectType(feature.rawType),
        subType: feature.rawClassification,
        position: pos,
        velocity: tracked ? this.getTrackedVelocity(tracked) : { x: 0, y: 0, z: 0 },
        size: feature.size,
        orientation: 0,
        recognitionConfidence: this.calculateRecognitionConfidence(feature, tracked),
        trackingId: tracked?.id,
        trackingAge: tracked?.age || 0,
        isFriendly,
        isEnemy,
        isThreat,
        isInteresting: isThreat || feature.edges > 0.7 || (tracked?.age || 0) > 100,
        dominantColor: 'unknown',
        hasMotion: (tracked?.lastVelocity || 0) > 0.5,
        isOccluded: false,
        occlusionPercent: 0,
        visibleInCameras: [feature.sourceCamera],
        bestCameraId: feature.sourceCamera,
        distance: feature.distance,
        bearing,
        elevation,
        lastSeenTimestamp: Date.now(),
        timesSeenCount: tracked?.seenCount || 1,
        memoryStrength: Math.min(1, (tracked?.seenCount || 1) / 10)
      });
    }
    
    return perceived;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // SALIENCY COMPUTATION — What stands out?
  // ═══════════════════════════════════════════════════════════════════════════
  
  private computeSaliency(features: EarlyVisualFeature[], motion: MotionVector[]): SaliencyRegion[] {
    const regions: SaliencyRegion[] = [];
    const motionMap = new Map(motion.map(m => [m.objectId, m]));
    
    for (const feature of features) {
      if (!feature.worldPosition) continue;
      
      const motionInfo = motionMap.get(feature.objectId);
      
      // Compute saliency components
      const colorSaliency = 0.5;  // Would compute from actual image
      const motionSaliency = motionInfo ? Math.min(1, motionInfo.velocity / 20) : 0;
      const shapeSaliency = feature.edges;
      const sizeSaliency = this.computeSizeSaliency(feature.size);
      const temporalSaliency = motionInfo?.isApproaching ? 0.8 : 0.2;
      
      // Combined saliency (weighted sum)
      const totalSaliency = 
        0.15 * colorSaliency +
        0.35 * motionSaliency +
        0.15 * shapeSaliency +
        0.15 * sizeSaliency +
        0.20 * temporalSaliency;
      
      regions.push({
        center: feature.worldPosition,
        radius: feature.size.width,
        cameraIds: [feature.sourceCamera],
        colorSaliency,
        motionSaliency,
        shapeSaliency,
        sizeSaliency,
        temporalSaliency,
        totalSaliency,
        isCapturingAttention: totalSaliency > 0.7
      });
    }
    
    // Sort by saliency
    regions.sort((a, b) => b.totalSaliency - a.totalSaliency);
    
    return regions.slice(0, 20);  // Top 20 salient regions
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // ATTENTION ALLOCATION — Where should the organism focus?
  // ═══════════════════════════════════════════════════════════════════════════
  
  private allocateAttention(
    saliency: SaliencyRegion[],
    objects: PerceivedObject[],
    beat: number
  ): AttentionFocus {
    const now = Date.now();
    const lastFocus = this.attentionHistory[this.attentionHistory.length - 1];
    
    // Check if we should shift attention (saccade)
    const timeSinceLastSaccade = lastFocus ? now - lastFocus.lastSaccadeTime : Infinity;
    const shouldSaccade = timeSinceLastSaccade > this.saccadeInterval;
    
    // Find highest priority target
    let targetPoint = { x: 0, y: 0, z: 0 };
    let targetCamera = '';
    let targetDrone = 0;
    let triggerType: AttentionFocus['triggerType'] = 'Voluntary';
    let mode: AttentionFocus['mode'] = 'Scanning';
    
    // Priority 1: Immediate threats
    const threats = objects.filter(o => o.isThreat).sort((a, b) => a.distance - b.distance);
    if (threats.length > 0) {
      targetPoint = threats[0].position;
      targetCamera = threats[0].bestCameraId;
      triggerType = 'Threat';
      mode = 'Tracking';
    }
    // Priority 2: Fast-moving approaching objects
    else if (saliency.length > 0 && saliency[0].motionSaliency > 0.7) {
      targetPoint = saliency[0].center;
      targetCamera = saliency[0].cameraIds[0];
      triggerType = 'Motion';
      mode = 'Tracking';
    }
    // Priority 3: Most salient region
    else if (saliency.length > 0 && saliency[0].totalSaliency > 0.5) {
      targetPoint = saliency[0].center;
      targetCamera = saliency[0].cameraIds[0];
      triggerType = 'Salience';
      mode = 'Fixed';
    }
    // Priority 4: Systematic scanning
    else {
      // Scan pattern - cycle through cameras
      const cameras = this.fleet.getAllCameras();
      if (cameras.length > 0) {
        const idx = beat % cameras.length;
        const drone = this.fleet.getDrone(cameras[idx].droneId);
        targetCamera = cameras[idx].camera.cameraId;
        targetDrone = cameras[idx].droneId;
        targetPoint = drone?.position || { x: 0, y: 0, z: 0 };
        triggerType = 'Voluntary';
        mode = 'Scanning';
      }
    }
    
    // Find drone ID for target camera
    if (!targetDrone) {
      const cameraInfo = this.fleet.getAllCameras().find(c => c.camera.cameraId === targetCamera);
      targetDrone = cameraInfo?.droneId || 0;
    }
    
    const focus: AttentionFocus = {
      primaryCameraId: targetCamera,
      primaryDroneId: targetDrone,
      focusPoint: targetPoint,
      focusRadius: this.attentionSpotlightSize,
      secondaryCameras: this.fleet.getAllCameras()
        .filter(c => c.camera.cameraId !== targetCamera)
        .slice(0, 3)
        .map(c => c.camera.cameraId),
      peripheralAwareness: 0.3 + 0.2 * Math.sin(this.processingPhase),
      mode,
      triggerType,
      fixationDuration: shouldSaccade ? 0 : (lastFocus?.fixationDuration || 0) + 33,
      lastSaccadeTime: shouldSaccade ? now : (lastFocus?.lastSaccadeTime || now)
    };
    
    // Remember attention history
    this.attentionHistory.push(focus);
    if (this.attentionHistory.length > 100) {
      this.attentionHistory.shift();
    }
    
    return focus;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // THREAT DETECTION — What's dangerous?
  // ═══════════════════════════════════════════════════════════════════════════
  
  private detectThreats(objects: PerceivedObject[], motion: MotionVector[]): ThreatRegion[] {
    const threats: ThreatRegion[] = [];
    const motionMap = new Map(motion.map(m => [m.objectId, m]));
    
    for (const obj of objects) {
      if (!obj.isThreat && !obj.isEnemy) continue;
      
      const motionInfo = motionMap.get(obj.id);
      
      // Calculate threat level
      let threatLevel = 0;
      
      // Enemy = high threat
      if (obj.isEnemy) threatLevel += 0.5;
      
      // Approaching = higher threat
      if (motionInfo?.isApproaching) {
        threatLevel += 0.3;
        // Very close and approaching = critical
        if (obj.distance < 100 && (motionInfo.timeToContact || Infinity) < 10) {
          threatLevel += 0.4;
        }
      }
      
      // Close proximity = threat
      if (obj.distance < 50) threatLevel += 0.2;
      
      threatLevel = Math.min(1, threatLevel);
      
      // Determine recommended action
      let action: ThreatRegion['recommendedAction'] = 'Observe';
      let urgency = threatLevel;
      
      if (threatLevel > 0.8 && motionInfo?.isApproaching) {
        action = 'Evade';
        urgency = 1;
      } else if (threatLevel > 0.6 && obj.isEnemy) {
        action = 'Engage';
      } else if (threatLevel > 0.3) {
        action = 'Observe';
      } else {
        action = 'Ignore';
      }
      
      threats.push({
        id: `threat_${obj.id}`,
        center: obj.position,
        radius: obj.distance < 100 ? 50 : 100,
        threatLevel,
        threatType: obj.isEnemy ? 'Enemy' : 
                    motionInfo?.isApproaching ? 'Collision' : 'Unknown',
        recommendedAction: action,
        urgency,
        detectedBy: obj.visibleInCameras,
        confidence: obj.recognitionConfidence
      });
    }
    
    // Sort by threat level
    threats.sort((a, b) => b.threatLevel - a.threatLevel);
    
    return threats;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // SPATIAL MODEL — Build world representation
  // ═══════════════════════════════════════════════════════════════════════════
  
  private updateSpatialModel(objects: PerceivedObject[]): SpatialModel {
    // Calculate swarm center (organism's "position")
    const drones = this.fleet.getAllDrones();
    const selfPosition = drones.length > 0 ? {
      x: drones.reduce((s, d) => s + d.position.x, 0) / drones.length,
      y: drones.reduce((s, d) => s + d.position.y, 0) / drones.length,
      z: drones.reduce((s, d) => s + d.position.z, 0) / drones.length
    } : { x: 0, y: 0, z: 0 };
    
    // Calculate swarm extent
    let maxDist = 0;
    for (const drone of drones) {
      const dist = Math.sqrt(
        (drone.position.x - selfPosition.x) ** 2 +
        (drone.position.y - selfPosition.y) ** 2 +
        (drone.position.z - selfPosition.z) ** 2
      );
      maxDist = Math.max(maxDist, dist);
    }
    
    // Find bounds of all seen objects
    let bounds = {
      min: { x: Infinity, y: Infinity, z: Infinity },
      max: { x: -Infinity, y: -Infinity, z: -Infinity }
    };
    
    for (const obj of objects) {
      bounds.min.x = Math.min(bounds.min.x, obj.position.x);
      bounds.min.y = Math.min(bounds.min.y, obj.position.y);
      bounds.min.z = Math.min(bounds.min.z, obj.position.z);
      bounds.max.x = Math.max(bounds.max.x, obj.position.x);
      bounds.max.y = Math.max(bounds.max.y, obj.position.y);
      bounds.max.z = Math.max(bounds.max.z, obj.position.z);
    }
    
    // Default bounds if no objects
    if (objects.length === 0) {
      bounds = {
        min: { x: selfPosition.x - 100, y: 0, z: selfPosition.z - 100 },
        max: { x: selfPosition.x + 100, y: selfPosition.y + 100, z: selfPosition.z + 100 }
      };
    }
    
    // Find obstacles
    const obstacles = objects
      .filter(o => o.type === 'Building' || o.type === 'Terrain')
      .map(o => ({
        position: o.position,
        radius: Math.max(o.size.width, o.size.depth) / 2
      }));
    
    // Calculate coverage quality
    const stats = this.fleet.getFleetStats();
    const coverageQuality = Math.min(1, stats.coverageArea / 10000);  // Relative to 10km²
    
    return {
      bounds,
      objectCount: objects.length,
      unknownRegions: [],  // Would compute from coverage gaps
      explorationPercent: coverageQuality,
      groundElevation: 0,
      obstacles,
      selfPosition,
      swarmExtent: maxDist,
      coverageQuality,
      blindSpots: []  // Would compute from camera orientations
    };
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // WORKING MEMORY — Remember important things
  // ═══════════════════════════════════════════════════════════════════════════
  
  private updateWorkingMemory(
    objects: PerceivedObject[],
    attention: AttentionFocus
  ): VisualMemoryItem[] {
    const now = Date.now();
    const existing = this.visualField.workingMemory || [];
    
    // Decay existing memories
    const decayed = existing.map(m => ({
      ...m,
      confidence: m.confidence * 0.99  // Slow decay
    })).filter(m => m.confidence > 0.1);
    
    // Add/update current objects
    const memory = new Map(decayed.map(m => [m.objectId, m]));
    
    for (const obj of objects) {
      const importance = 
        (obj.isThreat ? 1.0 : 0) +
        (obj.isEnemy ? 0.8 : 0) +
        (obj.isInteresting ? 0.3 : 0) +
        (obj.id === attention.primaryCameraId ? 0.5 : 0);
      
      const existing = memory.get(obj.id);
      
      memory.set(obj.id, {
        objectId: obj.id,
        objectType: obj.type,
        lastPosition: obj.position,
        lastSeen: now,
        confidence: existing ? Math.min(1, existing.confidence + 0.1) : 0.5,
        importance: Math.max(existing?.importance || 0, importance),
        revisitNeeded: obj.isThreat && obj.distance > 200
      });
    }
    
    // Sort by importance and take top 7±2 (Miller's law)
    const sorted = Array.from(memory.values())
      .sort((a, b) => b.importance - a.importance);
    
    return sorted.slice(0, 7 + Math.floor(Math.random() * 5 - 2));
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // VISUAL COHERENCE — How well integrated is perception?
  // ═══════════════════════════════════════════════════════════════════════════
  
  private computeVisualCoherence(
    attention: AttentionFocus,
    objects: PerceivedObject[],
    motion: MotionVector[]
  ): number {
    // Coherence components:
    
    // 1. Attention stability (not jumping around too much)
    const attentionStability = Math.min(1, attention.fixationDuration / 1000);
    
    // 2. Object recognition confidence
    const avgRecognition = objects.length > 0 
      ? objects.reduce((s, o) => s + o.recognitionConfidence, 0) / objects.length
      : 0.5;
    
    // 3. Motion field consistency
    const motionConsistency = motion.length > 0 ? 0.8 : 0.5;
    
    // 4. Spatial model completeness
    const spatialCompleteness = this.visualField.spatialModel?.explorationPercent || 0.5;
    
    // 5. Fleet health (can we see well?)
    const stats = this.fleet.getFleetStats();
    const fleetHealth = (stats.avgHealth + stats.avgSignal) / 2;
    
    // Combined coherence (golden ratio weighted)
    const coherence = 
      attentionStability * (1 / φ) +
      avgRecognition * (1 / (φ * φ)) +
      motionConsistency * (1 / (φ * φ * φ)) +
      spatialCompleteness * (1 / (φ * φ * φ * φ)) +
      fleetHealth * (1 / (φ * φ * φ * φ * φ));
    
    return Math.min(1, coherence * φ);  // Scale up
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // HELPER METHODS
  // ═══════════════════════════════════════════════════════════════════════════
  
  private createEmptyVisualField(): VisualField {
    return {
      timestamp: Date.now(),
      attentionFocus: {
        primaryCameraId: '',
        primaryDroneId: 0,
        focusPoint: { x: 0, y: 0, z: 0 },
        focusRadius: 20,
        secondaryCameras: [],
        peripheralAwareness: 0.5,
        mode: 'Scanning',
        triggerType: 'Voluntary',
        fixationDuration: 0,
        lastSaccadeTime: Date.now()
      },
      saliencyMap: [],
      perceivedObjects: [],
      motionField: [],
      threatMap: [],
      spatialModel: {
        bounds: { min: { x: -100, y: 0, z: -100 }, max: { x: 100, y: 100, z: 100 } },
        objectCount: 0,
        unknownRegions: [],
        explorationPercent: 0,
        groundElevation: 0,
        obstacles: [],
        selfPosition: { x: 0, y: 0, z: 0 },
        swarmExtent: 0,
        coverageQuality: 0,
        blindSpots: []
      },
      workingMemory: [],
      processingLoad: 0,
      visualCoherence: 0.5
    };
  }
  
  private estimateWorldPosition(
    obj: VisibleObject, 
    input: RawVisualInput
  ): { x: number; y: number; z: number } {
    // Estimate world position from camera position + bearing + distance
    const camPos = input.dronePosition;
    const camYaw = input.droneOrientation.yaw + input.cameraYaw;
    const camPitch = input.droneOrientation.pitch + input.cameraPitch;
    
    const yawRad = camYaw * (π / 180);
    const pitchRad = camPitch * (π / 180);
    
    return {
      x: camPos.x + obj.distance * Math.sin(yawRad) * Math.cos(pitchRad),
      y: camPos.y + obj.distance * Math.sin(pitchRad),
      z: camPos.z + obj.distance * Math.cos(yawRad) * Math.cos(pitchRad)
    };
  }
  
  private estimateObjectSize(obj: VisibleObject): { width: number; height: number; depth: number } {
    // Estimate size from bounding box and distance
    const fov = 90;  // Assume 90 degree FOV
    const pixelSize = (2 * obj.distance * Math.tan(fov/2 * π/180)) / 1920;  // meters per pixel
    
    return {
      width: obj.boundingBox.width * pixelSize,
      height: obj.boundingBox.height * pixelSize,
      depth: obj.boundingBox.width * pixelSize  // Assume roughly cubic
    };
  }
  
  private simulateEdgeStrength(obj: VisibleObject): number {
    // Simulate edge detection strength
    return 0.5 + Math.random() * 0.3;
  }
  
  private simulateContrast(obj: VisibleObject): number {
    return 0.6 + Math.random() * 0.2;
  }
  
  private updateObjectTracker(
    id: string, 
    position: { x: number; y: number; z: number },
    type: string
  ): void {
    let tracked = this.objectTracker.get(id);
    
    if (!tracked) {
      tracked = {
        id,
        type,
        positions: [],
        firstSeen: Date.now(),
        lastSeen: Date.now(),
        age: 0,
        seenCount: 0,
        lastVelocity: 0
      };
      this.objectTracker.set(id, tracked);
    }
    
    tracked.positions.push(position);
    if (tracked.positions.length > 30) {
      tracked.positions.shift();
    }
    tracked.lastSeen = Date.now();
    tracked.age++;
    tracked.seenCount++;
    
    // Limit tracker size
    if (this.objectTracker.size > this.maxTrackedObjects) {
      const oldest = Array.from(this.objectTracker.entries())
        .sort((a, b) => a[1].lastSeen - b[1].lastSeen)[0];
      if (oldest) {
        this.objectTracker.delete(oldest[0]);
      }
    }
  }
  
  private getTrackedVelocity(tracked: TrackedObject): { x: number; y: number; z: number } {
    if (tracked.positions.length < 2) {
      return { x: 0, y: 0, z: 0 };
    }
    const prev = tracked.positions[tracked.positions.length - 2];
    const curr = tracked.positions[tracked.positions.length - 1];
    const dt = 0.033;
    return {
      x: (curr.x - prev.x) / dt,
      y: (curr.y - prev.y) / dt,
      z: (curr.z - prev.z) / dt
    };
  }
  
  private calculateRecognitionConfidence(feature: EarlyVisualFeature, tracked?: TrackedObject): number {
    let conf = 0.5;
    
    // Better if tracked longer
    if (tracked) {
      conf += Math.min(0.3, tracked.age / 100);
    }
    
    // Better if closer
    conf += Math.max(0, 0.2 * (1 - feature.distance / 500));
    
    return Math.min(1, conf);
  }
  
  private classifyFriendly(feature: EarlyVisualFeature): boolean {
    // Check if this is one of our drones
    return feature.rawType === 'Drone' && feature.rawClassification?.includes('Own');
  }
  
  private classifyEnemy(feature: EarlyVisualFeature): boolean {
    return feature.rawClassification?.includes('Enemy') || 
           feature.rawClassification?.includes('Hostile') ||
           false;
  }
  
  private assessThreatPotential(feature: EarlyVisualFeature): boolean {
    // Assess if this object might be a threat
    return feature.rawType === 'Weapon' || 
           feature.rawType === 'Missile' ||
           (feature.rawType === 'Drone' && !this.classifyFriendly(feature));
  }
  
  private refineObjectType(rawType: string): ObjectType {
    const typeMap: Record<string, ObjectType> = {
      'Drone': 'Drone',
      'Aircraft': 'Aircraft',
      'Vehicle': 'Vehicle',
      'Person': 'Person',
      'Building': 'Building',
      'Terrain': 'Terrain',
      'Water': 'Water',
      'Vegetation': 'Vegetation',
      'Infrastructure': 'Infrastructure',
      'Weapon': 'Weapon',
      'Explosion': 'Explosion',
      'Smoke': 'Smoke'
    };
    return typeMap[rawType] || 'Unknown';
  }
  
  private computeSizeSaliency(size: { width: number; height: number; depth: number }): number {
    // Larger or smaller than "normal" is more salient
    const volume = size.width * size.height * size.depth;
    const normalVolume = 10;  // 10 cubic meters = "normal"
    const deviation = Math.abs(Math.log(volume / normalVolume));
    return Math.min(1, deviation / 3);
  }
  
  private calculateProcessingLoad(objectCount: number, motionCount: number): number {
    // More objects/motion = higher processing load
    const objectLoad = Math.min(1, objectCount / 50);
    const motionLoad = Math.min(1, motionCount / 20);
    return (objectLoad + motionLoad) / 2;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════
  // PUBLIC API
  // ═══════════════════════════════════════════════════════════════════════════
  
  /**
   * Get current visual field state
   */
  getVisualField(): VisualField {
    return this.visualField;
  }
  
  /**
   * Force attention to a specific point
   */
  focusOn(point: { x: number; y: number; z: number }): void {
    const focus = this.visualField.attentionFocus;
    focus.focusPoint = point;
    focus.mode = 'Fixed';
    focus.triggerType = 'Voluntary';
    focus.fixationDuration = 0;
    focus.lastSaccadeTime = Date.now();
  }
  
  /**
   * Get all perceived threats
   */
  getThreats(): ThreatRegion[] {
    return this.visualField.threatMap;
  }
  
  /**
   * Get spatial awareness
   */
  getSpatialModel(): SpatialModel {
    return this.visualField.spatialModel;
  }
  
  /**
   * Get processing statistics
   */
  getProcessingStats(): VisualProcessingStats {
    return {
      objectsTracked: this.objectTracker.size,
      attentionMode: this.visualField.attentionFocus.mode,
      processingLoad: this.visualField.processingLoad,
      visualCoherence: this.visualField.visualCoherence,
      processingPhase: this.processingPhase
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SUPPORTING TYPES
// ═══════════════════════════════════════════════════════════════════════════════

interface RawVisualInput {
  cameraId: string;
  droneId: number;
  dronePosition: { x: number; y: number; z: number };
  droneOrientation: { roll: number; pitch: number; yaw: number };
  cameraPitch: number;
  cameraYaw: number;
  cameraFOV: number;
  cameraZoom: number;
  frame?: CameraFrame;
  detections: Detection[];
  isActive: boolean;
  frameRate: number;
  latency: number;
}

interface EarlyVisualFeature {
  objectId: string;
  sourceCamera: string;
  sourceDrone: number;
  worldPosition?: { x: number; y: number; z: number };
  boundingBox: { x: number; y: number; width: number; height: number };
  size: { width: number; height: number; depth: number };
  distance: number;
  edges: number;
  contrast: number;
  rawType: string;
  rawClassification?: string;
}

interface TrackedObject {
  id: string;
  type: string;
  positions: { x: number; y: number; z: number }[];
  firstSeen: number;
  lastSeen: number;
  age: number;
  seenCount: number;
  lastVelocity: number;
}

export interface VisualProcessingStats {
  objectsTracked: number;
  attentionMode: string;
  processingLoad: number;
  visualCoherence: number;
  processingPhase: number;
}
