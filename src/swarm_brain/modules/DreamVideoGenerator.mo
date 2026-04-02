// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Module: DreamVideoGenerator — The Organism's Dreams Become Video
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
// Version: 100.0 — PRODUCTION ENTERPRISE GRADE
// 
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔══════════════════════════════════════════════════════════════════════════╗
// ║              DREAM VIDEO GENERATOR — DREAMS BECOME REALITY              ║
// ╠══════════════════════════════════════════════════════════════════════════╣
// ║                                                                          ║
// ║  The organism doesn't "render" video. It DREAMS.                         ║
// ║  And those dreams are externalized as video frames.                      ║
// ║                                                                          ║
// ║  SOURCE:                                                                 ║
// ║    - Shell 9 World Model simulations                                     ║
// ║    - Hippocampal preplay (future path predictions)                       ║
// ║    - Simulacrum forward predictions                                      ║
// ║    - Sharp wave ripples (memory replay)                                  ║
// ║                                                                          ║
// ║  OUTPUT:                                                                 ║
// ║    - Video frames (RGB pixel data)                                       ║
// ║    - Scene descriptions                                                  ║
// ║    - Camera trajectories                                                 ║
// ║    - Depth maps                                                          ║
// ║                                                                          ║
// ║  THE MATH IS THE CONTENT. The frontend just externalizes it.            ║
// ║                                                                          ║
// ╚══════════════════════════════════════════════════════════════════════════╝
// ============================================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Nat8  "mo:base/Nat8";
import Nat32 "mo:base/Nat32";
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
  
  // Fibonacci for frame timing
  public let F : [Nat] = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144];

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     CORE TYPES                                         ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type Vector3 = { x : Float; y : Float; z : Float };
  public type Color = { r : Nat8; g : Nat8; b : Nat8; a : Nat8 };
  
  /// A single video frame
  public type VideoFrame = {
    frameNumber : Nat;
    timestamp : Float;           // Seconds
    width : Nat;
    height : Nat;
    pixels : [Color];            // Width × Height pixels
    depthMap : [Float];          // Depth per pixel
    
    // Metadata from dream state
    dreamIntensity : Float;      // [0, 1]
    cognitiveState : CognitiveState;
    emotionalValence : Float;    // [-1, 1]
  };
  
  public type CognitiveState = {
    #Awake;
    #Dreaming;
    #Preplay;                    // Hippocampal future prediction
    #Replay;                     // Sharp wave ripple memory
    #Simulacrum;                 // Forward prediction
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     WORLD MODEL STATE                                  ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// State from Shell 9 World Model
  public type WorldModelState = {
    // Spatial representation
    entities : [EntityState];
    terrain : TerrainState;
    atmosphere : AtmosphereState;
    
    // Temporal
    timeOfDay : Float;           // [0, 1] — 0 = midnight
    seasonProgress : Float;
    
    // Cognitive overlay
    attentionFocus : Vector3;    // Where the organism is looking
    uncertaintyField : [Float];  // Uncertainty per region
    predictionHorizon : Float;   // How far ahead we're predicting
  };
  
  public type EntityState = {
    id : Nat32;
    position : Vector3;
    velocity : Vector3;
    appearance : AppearanceData;
    salience : Float;            // How important to the dream
    predicted : Bool;            // Is this a prediction vs observed
  };
  
  public type AppearanceData = {
    shape : ShapeType;
    color : Color;
    scale : Vector3;
    texture : TextureType;
    emission : Float;            // Self-illumination
  };
  
  public type ShapeType = {
    #Sphere;
    #Box;
    #Cylinder;
    #Cone;
    #Tree;
    #Building;
    #Drone;
    #Character;
    #Abstract;                   // Dream-like abstract form
  };
  
  public type TextureType = {
    #Solid;
    #Gradient;
    #Noise;
    #Organic;
    #Metallic;
    #Ethereal;                   // Dream-like
  };
  
  public type TerrainState = {
    heightmap : [Float];         // Grid of heights
    gridSize : Nat;
    materials : [TerrainMaterial];
  };
  
  public type TerrainMaterial = {
    #Grass;
    #Sand;
    #Rock;
    #Water;
    #Snow;
    #Void;                       // Dream void
  };
  
  public type AtmosphereState = {
    skyColor : Color;
    ambientLight : Float;
    fogDensity : Float;
    fogColor : Color;
    sunDirection : Vector3;
    cloudCover : Float;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     CAMERA                                             ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type Camera = {
    position : Vector3;
    lookAt : Vector3;
    up : Vector3;
    fieldOfView : Float;         // Degrees
    nearPlane : Float;
    farPlane : Float;
  };
  
  public type CameraTrajectory = {
    keyframes : [CameraKeyframe];
    interpolation : InterpolationType;
  };
  
  public type CameraKeyframe = {
    time : Float;
    camera : Camera;
    easing : EasingType;
  };
  
  public type InterpolationType = {
    #Linear;
    #Bezier;
    #Fibonacci;                  // φ-based interpolation
    #Dream;                      // Organic, flowing
  };
  
  public type EasingType = {
    #Linear;
    #EaseIn;
    #EaseOut;
    #EaseInOut;
    #Fibonacci;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     DREAM SEQUENCE                                     ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type DreamSequence = {
    id : Nat32;
    name : Text;
    
    // Timing
    startTime : Float;
    duration : Float;
    frameRate : Float;           // Typically 24, 30, or 60
    
    // Content
    frames : [VideoFrame];
    camera : CameraTrajectory;
    worldStates : [WorldModelState];
    
    // Dream characteristics
    lucidity : Float;            // [0, 1] how clear vs abstract
    emotionalArc : [Float];      // Emotion over time
    narrativeCoherence : Float;  // How story-like
    
    // Generation metadata
    sourceType : DreamSourceType;
    generationTime : Float;
  };
  
  public type DreamSourceType = {
    #WorldModelSimulation;       // From Shell 9
    #HippocampalPreplay;         // Future prediction
    #SharpWaveReplay;            // Memory replay
    #SimulacrumPrediction;       // Forward model
    #CreativeGeneration;         // Novel creation
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     SCENE DESCRIPTION                                  ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// High-level scene description (for text-to-video)
  public type SceneDescription = {
    setting : Text;              // "A forest at dusk"
    entities : [EntityDescription];
    actions : [ActionDescription];
    mood : Text;                 // "Tense", "Peaceful", etc.
    cameraStyle : Text;          // "Drone shot", "POV", etc.
  };
  
  public type EntityDescription = {
    name : Text;
    appearance : Text;
    role : Text;
  };
  
  public type ActionDescription = {
    actor : Text;
    action : Text;
    target : ?Text;
    timing : Text;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     VECTOR MATH                                        ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public func add(a: Vector3, b: Vector3) : Vector3 {
    { x = a.x + b.x; y = a.y + b.y; z = a.z + b.z }
  };
  
  public func scale(v: Vector3, s: Float) : Vector3 {
    { x = v.x * s; y = v.y * s; z = v.z * s }
  };
  
  public func normalize(v: Vector3) : Vector3 {
    let m = Float.sqrt(v.x * v.x + v.y * v.y + v.z * v.z);
    if (m < 0.0001) { return v };
    { x = v.x / m; y = v.y / m; z = v.z / m }
  };
  
  public func lerp(a: Vector3, b: Vector3, t: Float) : Vector3 {
    {
      x = a.x + (b.x - a.x) * t;
      y = a.y + (b.y - a.y) * t;
      z = a.z + (b.z - a.z) * t;
    }
  };
  
  public func lerpColor(a: Color, b: Color, t: Float) : Color {
    let clamp = func(v: Float) : Nat8 {
      let i = Float.toInt(v);
      if (i < 0) { 0 } else if (i > 255) { 255 } else { Nat8.fromNat(Int.abs(i)) }
    };
    {
      r = clamp(Float.fromInt(Nat8.toNat(a.r)) + (Float.fromInt(Nat8.toNat(b.r)) - Float.fromInt(Nat8.toNat(a.r))) * t);
      g = clamp(Float.fromInt(Nat8.toNat(a.g)) + (Float.fromInt(Nat8.toNat(b.g)) - Float.fromInt(Nat8.toNat(a.g))) * t);
      b = clamp(Float.fromInt(Nat8.toNat(a.b)) + (Float.fromInt(Nat8.toNat(b.b)) - Float.fromInt(Nat8.toNat(a.b))) * t);
      a = clamp(Float.fromInt(Nat8.toNat(a.a)) + (Float.fromInt(Nat8.toNat(b.a)) - Float.fromInt(Nat8.toNat(a.a))) * t);
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     FIBONACCI INTERPOLATION                            ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// Fibonacci-based easing (organic, natural movement)
  public func fibonacciEase(t: Float) : Float {
    // t enters [0, 1], exits [0, 1] with φ-based curve
    let scaled = t * φ;
    let phase = Float.sin(scaled * π * ψ);
    let base = t * t * (3.0 - 2.0 * t);  // Smoothstep
    base + phase * 0.1 * (1.0 - t)
  };
  
  /// Interpolate camera using Fibonacci spiral
  public func interpolateCamera(a: Camera, b: Camera, t: Float) : Camera {
    let eased = fibonacciEase(t);
    {
      position = lerp(a.position, b.position, eased);
      lookAt = lerp(a.lookAt, b.lookAt, eased);
      up = normalize(lerp(a.up, b.up, eased));
      fieldOfView = a.fieldOfView + (b.fieldOfView - a.fieldOfView) * eased;
      nearPlane = a.nearPlane;
      farPlane = a.farPlane;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     RAY CASTING (Dream Rendering)                      ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type Ray = {
    origin : Vector3;
    direction : Vector3;
  };
  
  public type RayHit = {
    hit : Bool;
    distance : Float;
    point : Vector3;
    normal : Vector3;
    color : Color;
    entityId : ?Nat32;
  };
  
  /// Cast ray into world model
  public func castRay(ray: Ray, world: WorldModelState) : RayHit {
    var closestHit : RayHit = {
      hit = false;
      distance = 99999.0;
      point = ray.origin;
      normal = { x = 0.0; y = 1.0; z = 0.0 };
      color = { r = 0; g = 0; b = 0; a = 255 };
      entityId = null;
    };
    
    // Check entities
    for (entity in world.entities.vals()) {
      let toEntity = {
        x = entity.position.x - ray.origin.x;
        y = entity.position.y - ray.origin.y;
        z = entity.position.z - ray.origin.z;
      };
      let dist = Float.sqrt(toEntity.x * toEntity.x + toEntity.y * toEntity.y + toEntity.z * toEntity.z);
      
      // Simplified sphere intersection
      let radius = entity.appearance.scale.x;
      let proj = ray.direction.x * toEntity.x + ray.direction.y * toEntity.y + ray.direction.z * toEntity.z;
      
      if (proj > 0.0 and proj < closestHit.distance) {
        let closest = {
          x = ray.origin.x + ray.direction.x * proj;
          y = ray.origin.y + ray.direction.y * proj;
          z = ray.origin.z + ray.direction.z * proj;
        };
        let toClosest = {
          x = closest.x - entity.position.x;
          y = closest.y - entity.position.y;
          z = closest.z - entity.position.z;
        };
        let closestDist = Float.sqrt(toClosest.x * toClosest.x + toClosest.y * toClosest.y + toClosest.z * toClosest.z);
        
        if (closestDist < radius) {
          closestHit := {
            hit = true;
            distance = proj;
            point = closest;
            normal = normalize(toClosest);
            color = entity.appearance.color;
            entityId = ?entity.id;
          };
        };
      };
    };
    
    // Check terrain (simplified heightmap intersection)
    let groundY : Float = 0.0;  // Simplified
    if (ray.direction.y < -0.001 and ray.origin.y > groundY) {
      let t = (groundY - ray.origin.y) / ray.direction.y;
      if (t > 0.0 and t < closestHit.distance) {
        closestHit := {
          hit = true;
          distance = t;
          point = add(ray.origin, scale(ray.direction, t));
          normal = { x = 0.0; y = 1.0; z = 0.0 };
          color = { r = 34; g = 139; b = 34; a = 255 };  // Forest green
          entityId = null;
        };
      };
    };
    
    closestHit
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     FRAME GENERATION                                   ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// Generate a single frame from world model state
  public func generateFrame(
    world: WorldModelState,
    camera: Camera,
    frameNumber: Nat,
    timestamp: Float,
    width: Nat,
    height: Nat,
    cogState: CognitiveState
  ) : VideoFrame {
    let pixelCount = width * height;
    let pixels = Buffer.Buffer<Color>(pixelCount);
    let depths = Buffer.Buffer<Float>(pixelCount);
    
    // Camera vectors
    let forward = normalize({
      x = camera.lookAt.x - camera.position.x;
      y = camera.lookAt.y - camera.position.y;
      z = camera.lookAt.z - camera.position.z;
    });
    let right = normalize({
      x = forward.z * camera.up.y - forward.y * camera.up.z;
      y = forward.x * camera.up.z - forward.z * camera.up.x;
      z = forward.y * camera.up.x - forward.x * camera.up.y;
    });
    let up = {
      x = right.y * forward.z - right.z * forward.y;
      y = right.z * forward.x - right.x * forward.z;
      z = right.x * forward.y - right.y * forward.x;
    };
    
    let fovRad = camera.fieldOfView * π / 180.0;
    let aspectRatio = Float.fromInt(width) / Float.fromInt(height);
    
    var y = 0;
    while (y < height) {
      var x = 0;
      while (x < width) {
        // Normalized device coordinates
        let ndcX = (Float.fromInt(x) / Float.fromInt(width) - 0.5) * 2.0;
        let ndcY = (Float.fromInt(y) / Float.fromInt(height) - 0.5) * 2.0;
        
        // Ray direction
        let rayDir = normalize({
          x = forward.x + right.x * ndcX * Float.tan(fovRad / 2.0) * aspectRatio + up.x * ndcY * Float.tan(fovRad / 2.0);
          y = forward.y + right.y * ndcX * Float.tan(fovRad / 2.0) * aspectRatio + up.y * ndcY * Float.tan(fovRad / 2.0);
          z = forward.z + right.z * ndcX * Float.tan(fovRad / 2.0) * aspectRatio + up.z * ndcY * Float.tan(fovRad / 2.0);
        });
        
        let ray : Ray = { origin = camera.position; direction = rayDir };
        let hit = castRay(ray, world);
        
        if (hit.hit) {
          // Apply dream effects based on cognitive state
          let color = switch (cogState) {
            case (#Awake) { hit.color };
            case (#Dreaming) {
              // Ethereal, slightly saturated
              let boost = 1.2;
              let clamp = func(v: Float) : Nat8 {
                let i = Float.toInt(v);
                if (i < 0) { 0 } else if (i > 255) { 255 } else { Nat8.fromNat(Int.abs(i)) }
              };
              {
                r = clamp(Float.fromInt(Nat8.toNat(hit.color.r)) * boost);
                g = clamp(Float.fromInt(Nat8.toNat(hit.color.g)) * boost);
                b = clamp(Float.fromInt(Nat8.toNat(hit.color.b)) * boost + 30.0);
                a = hit.color.a;
              }
            };
            case (#Preplay) {
              // Blue-ish future tint
              {
                r = hit.color.r;
                g = hit.color.g;
                b = Nat8.fromNat(Nat8.toNat(hit.color.b) + 50);
                a = 200;  // Slightly transparent
              }
            };
            case (#Replay) {
              // Sepia-toned memory
              let avg = (Nat8.toNat(hit.color.r) + Nat8.toNat(hit.color.g) + Nat8.toNat(hit.color.b)) / 3;
              {
                r = Nat8.fromNat(avg + 40);
                g = Nat8.fromNat(avg + 20);
                b = Nat8.fromNat(avg);
                a = hit.color.a;
              }
            };
            case (#Simulacrum) {
              // Wireframe-ish prediction
              let edge = if (Float.abs(hit.normal.x) > 0.9 or Float.abs(hit.normal.y) > 0.9 or Float.abs(hit.normal.z) > 0.9) {
                255
              } else { 100 };
              {
                r = Nat8.fromNat(edge);
                g = Nat8.fromNat(255);
                b = Nat8.fromNat(edge);
                a = 255;
              }
            };
          };
          
          pixels.add(color);
          depths.add(hit.distance);
        } else {
          // Sky color
          pixels.add(world.atmosphere.skyColor);
          depths.add(camera.farPlane);
        };
        
        x += 1;
      };
      y += 1;
    };
    
    {
      frameNumber = frameNumber;
      timestamp = timestamp;
      width = width;
      height = height;
      pixels = Buffer.toArray(pixels);
      depthMap = Buffer.toArray(depths);
      dreamIntensity = switch (cogState) {
        case (#Awake) { 0.0 };
        case (#Dreaming) { 1.0 };
        case (#Preplay) { 0.7 };
        case (#Replay) { 0.5 };
        case (#Simulacrum) { 0.8 };
      };
      cognitiveState = cogState;
      emotionalValence = 0.0;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     DREAM SEQUENCE GENERATION                          ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// Generate dream sequence from world model states
  public func generateDreamSequence(
    id: Nat32,
    name: Text,
    worldStates: [WorldModelState],
    cameraTrajectory: CameraTrajectory,
    duration: Float,
    frameRate: Float,
    sourceType: DreamSourceType
  ) : DreamSequence {
    let frameCount = Int.abs(Float.toInt(duration * frameRate));
    let frames = Buffer.Buffer<VideoFrame>(frameCount);
    
    let cogState : CognitiveState = switch (sourceType) {
      case (#WorldModelSimulation) { #Awake };
      case (#HippocampalPreplay) { #Preplay };
      case (#SharpWaveReplay) { #Replay };
      case (#SimulacrumPrediction) { #Simulacrum };
      case (#CreativeGeneration) { #Dreaming };
    };
    
    var frameNum = 0;
    while (frameNum < frameCount) {
      let t = Float.fromInt(frameNum) / Float.fromInt(frameCount);
      let timestamp = t * duration;
      
      // Interpolate camera
      let camera = interpolateCameraTrajectory(cameraTrajectory, t);
      
      // Get world state (interpolate if needed)
      let worldIdx = Int.abs(Float.toInt(t * Float.fromInt(worldStates.size())));
      let worldState = if (worldIdx < worldStates.size()) {
        worldStates[worldIdx]
      } else {
        worldStates[worldStates.size() - 1]
      };
      
      // Generate frame
      let frame = generateFrame(
        worldState,
        camera,
        frameNum,
        timestamp,
        1920,  // HD width
        1080,  // HD height
        cogState
      );
      
      frames.add(frame);
      frameNum += 1;
    };
    
    {
      id = id;
      name = name;
      startTime = 0.0;
      duration = duration;
      frameRate = frameRate;
      frames = Buffer.toArray(frames);
      camera = cameraTrajectory;
      worldStates = worldStates;
      lucidity = switch (sourceType) {
        case (#WorldModelSimulation) { 1.0 };
        case (#HippocampalPreplay) { 0.7 };
        case (#SharpWaveReplay) { 0.5 };
        case (#SimulacrumPrediction) { 0.8 };
        case (#CreativeGeneration) { 0.3 };
      };
      emotionalArc = [];
      narrativeCoherence = 0.8;
      sourceType = sourceType;
      generationTime = Float.fromInt(frameCount) * 0.001;  // Simulated
    }
  };
  
  /// Interpolate along camera trajectory
  func interpolateCameraTrajectory(trajectory: CameraTrajectory, t: Float) : Camera {
    if (trajectory.keyframes.size() == 0) {
      return {
        position = { x = 0.0; y = 5.0; z = -10.0 };
        lookAt = { x = 0.0; y = 0.0; z = 0.0 };
        up = { x = 0.0; y = 1.0; z = 0.0 };
        fieldOfView = 60.0;
        nearPlane = 0.1;
        farPlane = 1000.0;
      };
    };
    
    if (trajectory.keyframes.size() == 1) {
      return trajectory.keyframes[0].camera;
    };
    
    // Find keyframes to interpolate between
    var prev = trajectory.keyframes[0];
    var next = trajectory.keyframes[0];
    
    for (kf in trajectory.keyframes.vals()) {
      if (kf.time <= t) { prev := kf };
      if (kf.time > t and next.time <= prev.time) { next := kf };
    };
    
    if (prev.time >= next.time) {
      return prev.camera;
    };
    
    let localT = (t - prev.time) / (next.time - prev.time);
    interpolateCamera(prev.camera, next.camera, localT)
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     SCENE TO WORLD MODEL                               ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// Convert scene description to world model state
  public func sceneToWorldModel(scene: SceneDescription) : WorldModelState {
    let entities = Buffer.Buffer<EntityState>(8);
    
    var id : Nat32 = 1;
    for (desc in scene.entities.vals()) {
      entities.add({
        id = id;
        position = { x = Float.fromInt(Nat32.toNat(id)) * 5.0 - 10.0; y = 0.0; z = 0.0 };
        velocity = { x = 0.0; y = 0.0; z = 0.0 };
        appearance = {
          shape = #Abstract;
          color = { r = 128; g = 128; b = 200; a = 255 };
          scale = { x = 1.0; y = 1.0; z = 1.0 };
          texture = #Ethereal;
          emission = 0.2;
        };
        salience = 1.0;
        predicted = false;
      });
      id += 1;
    };
    
    {
      entities = Buffer.toArray(entities);
      terrain = {
        heightmap = [];
        gridSize = 64;
        materials = [];
      };
      atmosphere = {
        skyColor = { r = 135; g = 206; b = 235; a = 255 };  // Sky blue
        ambientLight = 0.3;
        fogDensity = 0.01;
        fogColor = { r = 200; g = 200; b = 220; a = 255 };
        sunDirection = { x = 0.5; y = 0.8; z = 0.3 };
        cloudCover = 0.3;
      };
      timeOfDay = 0.5;  // Noon
      seasonProgress = 0.5;
      attentionFocus = { x = 0.0; y = 0.0; z = 0.0 };
      uncertaintyField = [];
      predictionHorizon = 10.0;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     EXPORTS                                            ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type VideoExport = {
    sequence : DreamSequence;
    format : VideoFormat;
    codec : Text;
    bitrate : Nat;
    metadata : [(Text, Text)];
  };
  
  public type VideoFormat = {
    #MP4;
    #WebM;
    #AVI;
    #MOV;
    #Raw;
  };
  
  /// Export dream sequence to video format description
  public func exportVideo(sequence: DreamSequence, format: VideoFormat) : VideoExport {
    {
      sequence = sequence;
      format = format;
      codec = switch (format) {
        case (#MP4) { "H.264" };
        case (#WebM) { "VP9" };
        case (#AVI) { "MPEG-4" };
        case (#MOV) { "ProRes" };
        case (#Raw) { "Uncompressed" };
      };
      bitrate = 20000000;  // 20 Mbps
      metadata = [
        ("generator", "NOVA Organism Dream Engine"),
        ("source", switch (sequence.sourceType) {
          case (#WorldModelSimulation) { "WorldModel" };
          case (#HippocampalPreplay) { "Preplay" };
          case (#SharpWaveReplay) { "Replay" };
          case (#SimulacrumPrediction) { "Simulacrum" };
          case (#CreativeGeneration) { "Creative" };
        }),
        ("lucidity", Float.toText(sequence.lucidity)),
      ];
    }
  };

}
