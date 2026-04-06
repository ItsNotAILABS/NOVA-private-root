// ╔══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                           CHIMERA INTELLIGENCE CORE - DEFENSE GRADE ARCHITECTURE                          ║
// ║                                    Target: 150,000+ Lines Single File                                      ║
// ║                                   $30M Seed Architecture Foundation                                        ║
// ╠══════════════════════════════════════════════════════════════════════════════════════════════════════════╣
// ║  PHASE 1: Multi-Source Intelligence Fusion (8K-12K lines)                                                 ║
// ║  PHASE 2: Virtual World Simulator (15K-20K lines)                                                         ║
// ║  PHASE 3: ICP Control Layer (10K-15K lines)                                                               ║
// ║  PHASE 4: Mission Planning System (12K-18K lines)                                                         ║
// ║  PHASE 5: Swarm Algorithms (15K-20K lines)                                                                ║
// ║  PHASE 6: Learning Systems (10K-15K lines)                                                                ║
// ║  PHASE 7: Sensor Fusion (12K-18K lines)                                                                   ║
// ║  PHASE 8: Azure Integration (5K-8K lines)                                                                 ║
// ║  PHASE 9: Blockchain Integration (8K-12K lines)                                                           ║
// ║  PHASE 10: ICP Innovations (10K+ lines)                                                                   ║
// ╚══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Float "mo:base/Float";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Nat8 "mo:base/Nat8";
import Nat32 "mo:base/Nat32";
import Nat64 "mo:base/Nat64";
import Text "mo:base/Text";
import Time "mo:base/Time";
import Iter "mo:base/Iter";
import Option "mo:base/Option";
import Result "mo:base/Result";
import Hash "mo:base/Hash";
import HashMap "mo:base/HashMap";
import Principal "mo:base/Principal";
import Blob "mo:base/Blob";
import Debug "mo:base/Debug";
import Order "mo:base/Order";
import Char "mo:base/Char";
import Int64 "mo:base/Int64";

module ChimeraIntelligenceCore {

    // ═══════════════════════════════════════════════════════════════════════════════════════════
    // SECTION 1: FUNDAMENTAL CONSTANTS AND CONFIGURATION
    // ═══════════════════════════════════════════════════════════════════════════════════════════
    
    // Mathematical constants for precision calculations
    public let PI : Float = 3.14159265358979323846264338327950288;
    public let TAU : Float = 6.28318530717958647692528676655900577;
    public let E : Float = 2.71828182845904523536028747135266250;
    public let PHI : Float = 1.61803398874989484820458683436563812;  // Golden ratio
    public let SQRT2 : Float = 1.41421356237309504880168872420969808;
    public let SQRT3 : Float = 1.73205080756887729352744634150587237;
    public let LN2 : Float = 0.69314718055994530941723212145817657;
    public let LN10 : Float = 2.30258509299404568401799145468436421;
    
    // Chimera system constants
    public let MAX_DRONES : Nat = 10000;
    public let MAX_SWARM_SIZE : Nat = 1000;
    public let MAX_INTELLIGENCE_SOURCES : Nat = 256;
    public let MAX_SENSOR_CHANNELS : Nat = 512;
    public let MAX_MISSION_OBJECTIVES : Nat = 128;
    public let MAX_WORLD_ENTITIES : Nat = 100000;
    public let MAX_NEURAL_LAYERS : Nat = 64;
    public let MAX_MEMORY_SLOTS : Nat = 1048576;
    public let QUANTUM_COHERENCE_THRESHOLD : Float = 0.85;
    public let SUPERRADIANCE_N_SQUARED_FACTOR : Float = 1.0;
    
    // Timing constants (nanoseconds)
    public let TICK_INTERVAL_NS : Nat64 = 100_000_000; // 100ms
    public let FAST_TICK_NS : Nat64 = 10_000_000; // 10ms
    public let ULTRA_FAST_TICK_NS : Nat64 = 1_000_000; // 1ms
    public let SLOW_TICK_NS : Nat64 = 1_000_000_000; // 1s
    
    // Communication constants
    public let PHEROMONE_CHANNELS : Nat = 16;
    public let COMMAND_CHANNELS : Nat = 32;
    public let TELEMETRY_CHANNELS : Nat = 64;
    public let BROADCAST_RADIUS : Float = 1000.0; // meters
    
    // ═══════════════════════════════════════════════════════════════════════════════════════════
    // SECTION 2: CORE DATA TYPES AND STRUCTURES
    // ═══════════════════════════════════════════════════════════════════════════════════════════
    
    // 3D Vector type for spatial calculations
    public type Vector3 = {
        x : Float;
        y : Float;
        z : Float;
    };
    
    // Quaternion for rotation representation
    public type Quaternion = {
        w : Float;
        x : Float;
        y : Float;
        z : Float;
    };
    
    // 4x4 Transformation matrix
    public type Matrix4x4 = {
        m : [Float]; // 16 elements row-major
    };
    
    // 3x3 Matrix for rotations
    public type Matrix3x3 = {
        m : [Float]; // 9 elements row-major
    };
    
    // Pose (position + orientation)
    public type Pose = {
        position : Vector3;
        orientation : Quaternion;
        timestamp : Nat64;
    };
    
    // Velocity state
    public type Velocity = {
        linear : Vector3;
        angular : Vector3;
    };
    
    // Full kinematic state
    public type KinematicState = {
        pose : Pose;
        velocity : Velocity;
        acceleration : Vector3;
        jerk : Vector3;
    };
    
    // Bounding box for collision detection
    public type BoundingBox = {
        min : Vector3;
        max : Vector3;
    };
    
    // Oriented bounding box
    public type OrientedBoundingBox = {
        center : Vector3;
        halfExtents : Vector3;
        orientation : Quaternion;
    };
    
    // Sphere for simple collision
    public type BoundingSphere = {
        center : Vector3;
        radius : Float;
    };
    
    // Convex hull representation
    public type ConvexHull = {
        vertices : [Vector3];
        faces : [[Nat]];
        normals : [Vector3];
    };
    
    // ═══════════════════════════════════════════════════════════════════════════════════════════
    // SECTION 3: INTELLIGENCE SOURCE TYPES
    // ═══════════════════════════════════════════════════════════════════════════════════════════
    
    // Intelligence classification levels
    public type IntelligenceClassification = {
        #UNCLASSIFIED;
        #CONFIDENTIAL;
        #SECRET;
        #TOP_SECRET;
        #SCI;
        #SAP;
    };
    
    // Intelligence source types
    public type IntelSourceType = {
        #SIGINT;    // Signals Intelligence
        #HUMINT;    // Human Intelligence
        #OSINT;     // Open Source Intelligence
        #GEOINT;    // Geospatial Intelligence
        #MASINT;    // Measurement and Signature Intelligence
        #TECHINT;   // Technical Intelligence
        #FININT;    // Financial Intelligence
        #CYBINT;    // Cyber Intelligence
        #SOCMINT;   // Social Media Intelligence
        #MEDINT;    // Medical Intelligence
        #ACINT;     // Acoustic Intelligence
        #RADINT;    // Radar Intelligence
        #ELINT;     // Electronic Intelligence
        #COMINT;    // Communications Intelligence
        #FISINT;    // Foreign Instrumentation Signals Intelligence
        #IMINT;     // Imagery Intelligence
        #TELINT;    // Telemetry Intelligence
        #NUCINT;    // Nuclear Intelligence
        #BIOINT;    // Biological Intelligence
        #CHEMINT;   // Chemical Intelligence
    };
    
    // Intelligence report structure
    public type IntelligenceReport = {
        id : Nat64;
        sourceType : IntelSourceType;
        classification : IntelligenceClassification;
        timestamp : Nat64;
        expirationTime : Nat64;
        confidence : Float;
        reliability : Float;
        relevance : Float;
        urgency : Float;
        location : ?Vector3;
        subject : Text;
        summary : Text;
        rawData : Blob;
        analysisNotes : [Text];
        corroboratingReports : [Nat64];
        conflictingReports : [Nat64];
        dissemination : [Principal];
        originatorId : Principal;
        handlingInstructions : Text;
        sourceCredibility : Float;
        informationAccuracy : Float;
        timeliness : Float;
    };
    
    // ═══════════════════════════════════════════════════════════════════════════════════════════
    // SECTION 4: SENSOR DATA TYPES
    // ═══════════════════════════════════════════════════════════════════════════════════════════
    
    // Radar detection
    public type RadarDetection = {
        id : Nat64;
        timestamp : Nat64;
        range : Float;
        azimuth : Float;
        elevation : Float;
        rangeRate : Float;
        signalStrength : Float;
        crossSection : Float;
        classification : Text;
        confidence : Float;
        trackId : ?Nat64;
    };
    
    // Lidar point cloud
    public type LidarPoint = {
        x : Float;
        y : Float;
        z : Float;
        intensity : Float;
        returnNumber : Nat8;
        classification : Nat8;
        timestamp : Nat64;
    };
    
    // Lidar scan
    public type LidarScan = {
        id : Nat64;
        timestamp : Nat64;
        points : [LidarPoint];
        sensorPose : Pose;
        scanPattern : Text;
        angularResolution : Float;
        rangeMin : Float;
        rangeMax : Float;
    };
    
    // Camera image metadata
    public type ImageMetadata = {
        id : Nat64;
        timestamp : Nat64;
        width : Nat;
        height : Nat;
        channels : Nat;
        encoding : Text;
        focalLength : Float;
        principalPoint : (Float, Float);
        distortionCoeffs : [Float];
        exposureTime : Float;
        gain : Float;
        cameraPose : Pose;
    };
    
    // Infrared sensor data
    public type IRSensorData = {
        id : Nat64;
        timestamp : Nat64;
        temperature : Float;
        emissivity : Float;
        wavelengthMin : Float;
        wavelengthMax : Float;
        sensorPose : Pose;
        fieldOfView : Float;
        resolution : (Nat, Nat);
        thermalImage : [Float];
    };
    
    // Acoustic sensor data
    public type AcousticData = {
        id : Nat64;
        timestamp : Nat64;
        sampleRate : Nat;
        channels : Nat;
        duration : Float;
        frequencyMin : Float;
        frequencyMax : Float;
        sensorPose : Pose;
        soundPressureLevel : Float;
        spectrum : [Float];
        detectedSources : [AcousticSource];
    };
    
    // Acoustic source detection
    public type AcousticSource = {
        bearing : Float;
        elevation : Float;
        range : ?Float;
        frequency : Float;
        amplitude : Float;
        classification : Text;
        confidence : Float;
    };
    
    // GPS/GNSS data
    public type GNSSData = {
        timestamp : Nat64;
        latitude : Float;
        longitude : Float;
        altitude : Float;
        horizontalAccuracy : Float;
        verticalAccuracy : Float;
        speed : Float;
        heading : Float;
        numSatellites : Nat;
        hdop : Float;
        vdop : Float;
        pdop : Float;
        fixType : Text;
        constellation : Text;
    };
    
    // IMU data
    public type IMUData = {
        timestamp : Nat64;
        linearAcceleration : Vector3;
        angularVelocity : Vector3;
        magneticField : Vector3;
        orientation : Quaternion;
        temperature : Float;
        calibrationStatus : Nat8;
    };
    
    // Barometric altimeter
    public type BarometerData = {
        timestamp : Nat64;
        pressure : Float;
        temperature : Float;
        altitude : Float;
        verticalSpeed : Float;
    };
    
    // Magnetometer
    public type MagnetometerData = {
        timestamp : Nat64;
        fieldStrength : Vector3;
        heading : Float;
        inclination : Float;
        declination : Float;
        calibrationStatus : Nat8;
    };
    
    // ═══════════════════════════════════════════════════════════════════════════════════════════
    // SECTION 5: ENTITY AND OBJECT TYPES
    // ═══════════════════════════════════════════════════════════════════════════════════════════
    
    // Entity classification
    public type EntityType = {
        #FRIENDLY;
        #HOSTILE;
        #NEUTRAL;
        #UNKNOWN;
        #CIVILIAN;
        #INFRASTRUCTURE;
        #TERRAIN;
        #WEATHER;
        #OBSTACLE;
        #WAYPOINT;
        #ZONE;
    };
    
    // Entity threat level
    public type ThreatLevel = {
        #NONE;
        #LOW;
        #MODERATE;
        #HIGH;
        #CRITICAL;
        #IMMINENT;
    };
    
    // Entity mobility type
    public type MobilityType = {
        #STATIC;
        #GROUND;
        #WHEELED;
        #TRACKED;
        #WALKING;
        #SWIMMING;
        #SUBMARINE;
        #AIRBORNE;
        #HOVERING;
        #ORBITAL;
        #BALLISTIC;
    };
    
    // Tracked entity
    public type TrackedEntity = {
        id : Nat64;
        entityType : EntityType;
        threatLevel : ThreatLevel;
        mobilityType : MobilityType;
        kinematics : KinematicState;
        boundingBox : BoundingBox;
        classification : Text;
        confidence : Float;
        firstSeen : Nat64;
        lastSeen : Nat64;
        trackQuality : Float;
        sensorSources : [Nat64];
        attributes : [(Text, Text)];
        behaviorProfile : ?BehaviorProfile;
        predictedPath : [Vector3];
        threatAssessment : ThreatAssessment;
    };
    
    // Behavior profile for entities
    public type BehaviorProfile = {
        aggressiveness : Float;
        predictability : Float;
        competence : Float;
        coordination : Float;
        observedPatterns : [Text];
        lastActions : [EntityAction];
        intentEstimate : Text;
    };
    
    // Entity action record
    public type EntityAction = {
        timestamp : Nat64;
        actionType : Text;
        target : ?Nat64;
        location : Vector3;
        result : Text;
    };
    
    // Threat assessment
    public type ThreatAssessment = {
        threatScore : Float;
        capability : Float;
        intent : Float;
        opportunity : Float;
        vulnerabilityToUs : Float;
        ourVulnerabilityToThem : Float;
        recommendedResponse : Text;
        timeToImpact : ?Float;
        engagementPriority : Nat;
    };
    
    // ═══════════════════════════════════════════════════════════════════════════════════════════
    // SECTION 6: WORLD MODEL TYPES
    // ═══════════════════════════════════════════════════════════════════════════════════════════
    
    // Terrain types
    public type TerrainType = {
        #WATER_DEEP;
        #WATER_SHALLOW;
        #MARSH;
        #SAND;
        #DIRT;
        #GRASS;
        #FOREST;
        #JUNGLE;
        #URBAN;
        #SUBURBAN;
        #INDUSTRIAL;
        #MOUNTAIN;
        #SNOW;
        #ICE;
        #ROCK;
        #ROAD_PAVED;
        #ROAD_UNPAVED;
        #RUNWAY;
        #BRIDGE;
        #BUILDING;
    };
    
    // Terrain cell
    public type TerrainCell = {
        x : Int;
        y : Int;
        terrainType : TerrainType;
        elevation : Float;
        slope : Float;
        aspect : Float;
        roughness : Float;
        traversability : Float;
        cover : Float;
        concealment : Float;
        obstacleHeight : Float;
        vegetationDensity : Float;
        moistureLevel : Float;
        lastUpdated : Nat64;
    };
    
    // Weather conditions
    public type WeatherConditions = {
        timestamp : Nat64;
        location : Vector3;
        temperature : Float;
        humidity : Float;
        pressure : Float;
        windSpeed : Float;
        windDirection : Float;
        visibility : Float;
        cloudCover : Float;
        cloudCeiling : Float;
        precipitation : Float;
        precipitationType : Text;
        lightningRisk : Float;
        turbulence : Float;
        icing : Float;
    };
    
    // Atmospheric layer
    public type AtmosphericLayer = {
        altitudeMin : Float;
        altitudeMax : Float;
        temperature : Float;
        pressure : Float;
        density : Float;
        humidity : Float;
        windSpeed : Float;
        windDirection : Float;
        turbulence : Float;
    };
    
    // Electromagnetic environment
    public type EMEnvironment = {
        timestamp : Nat64;
        location : Vector3;
        radioNoise : Float;
        jamming : Float;
        radarCoverage : Float;
        commsCoverage : Float;
        gpsJamming : Float;
        gpsSpoofing : Float;
        electronicWarfareActivity : Float;
    };
    
    // ═══════════════════════════════════════════════════════════════════════════════════════════
    // SECTION 7: DRONE STATE TYPES
    // ═══════════════════════════════════════════════════════════════════════════════════════════
    
    // Drone type classification
    public type DroneType = {
        #QUADROTOR;
        #HEXAROTOR;
        #OCTOROTOR;
        #FIXED_WING;
        #VTOL;
        #HELICOPTER;
        #GROUND_ROVER;
        #TRACKED_VEHICLE;
        #AQUATIC_SURFACE;
        #AQUATIC_SUBMERSIBLE;
        #HYBRID;
    };
    
    // Drone operational status
    public type DroneStatus = {
        #INITIALIZING;
        #READY;
        #LAUNCHING;
        #IN_FLIGHT;
        #ON_MISSION;
        #RETURNING;
        #LANDING;
        #LANDED;
        #CHARGING;
        #MAINTENANCE;
        #DAMAGED;
        #LOST;
        #DESTROYED;
    };
    
    // Drone health status
    public type DroneHealth = {
        overallHealth : Float;
        batteryLevel : Float;
        batteryHealth : Float;
        motorHealth : [Float];
        sensorHealth : [(Text, Float)];
        commsHealth : Float;
        structuralIntegrity : Float;
        payloadStatus : Text;
        estimatedFlightTime : Float;
        temperatureStatus : Float;
        vibrationLevel : Float;
        errorCodes : [Nat];
    };
    
    // Full drone state
    public type DroneState = {
        id : Nat64;
        droneType : DroneType;
        status : DroneStatus;
        health : DroneHealth;
        kinematics : KinematicState;
        target : ?Vector3;
        waypoints : [Vector3];
        currentWaypointIndex : Nat;
        missionId : ?Nat64;
        assignedObjective : ?Nat64;
        formation : ?FormationAssignment;
        payload : ?PayloadState;
        sensors : [SensorState];
        commsState : CommsState;
        neuralState : DroneNeuralState;
        lastContact : Nat64;
        flightTime : Float;
        distanceTraveled : Float;
        missionProgress : Float;
    };
    
    // Formation assignment
    public type FormationAssignment = {
        formationId : Nat64;
        positionIndex : Nat;
        offsetFromLeader : Vector3;
        role : Text;
    };
    
    // Payload state
    public type PayloadState = {
        payloadType : Text;
        weight : Float;
        status : Text;
        remainingCapacity : Float;
        deployments : Nat;
        lastDeployment : ?Nat64;
    };
    
    // Sensor state
    public type SensorState = {
        sensorId : Nat64;
        sensorType : Text;
        operational : Bool;
        calibrated : Bool;
        lastReading : Nat64;
        accuracy : Float;
        range : Float;
        fieldOfView : Float;
        pointing : Vector3;
    };
    
    // Communications state
    public type CommsState = {
        primaryLinkActive : Bool;
        backupLinkActive : Bool;
        meshConnected : Bool;
        signalStrength : Float;
        dataRate : Float;
        latency : Float;
        packetLoss : Float;
        encryptionActive : Bool;
        lastHeartbeat : Nat64;
        connectedPeers : [Nat64];
    };
    
    // Drone neural state (for swarm intelligence)
    public type DroneNeuralState = {
        activationLevel : Float;
        arousal : Float;
        attention : Float;
        confidence : Float;
        stress : Float;
        fatigue : Float;
        curiosity : Float;
        fearResponse : Float;
        aggression : Float;
        socialBinding : Float;
        hiveMindCoupling : Float;
        localDecisionWeight : Float;
        pheromoneEmission : [Float];
        pheromoneReception : [Float];
        neurotransmitters : [(Text, Float)];
        recentRewards : [Float];
        recentPunishments : [Float];
        learningRate : Float;
        explorationRate : Float;
    };
    
    // ═══════════════════════════════════════════════════════════════════════════════════════════
    // SECTION 8: MISSION PLANNING TYPES
    // ═══════════════════════════════════════════════════════════════════════════════════════════
    
    // Mission type
    public type MissionType = {
        #SURVEILLANCE;
        #RECONNAISSANCE;
        #PATROL;
        #ESCORT;
        #SEARCH_AND_RESCUE;
        #DELIVERY;
        #MAPPING;
        #INSPECTION;
        #COMMUNICATION_RELAY;
        #ELECTRONIC_WARFARE;
        #STRIKE;
        #DEFENSE;
        #INTERCEPT;
        #DECOY;
        #SWARM_ATTACK;
        #AREA_DENIAL;
    };
    
    // Mission priority
    public type MissionPriority = {
        #ROUTINE;
        #PRIORITY;
        #URGENT;
        #FLASH;
        #EMERGENCY;
    };
    
    // Mission status
    public type MissionStatus = {
        #PLANNING;
        #APPROVED;
        #BRIEFING;
        #EXECUTING;
        #PAUSED;
        #ABORTED;
        #COMPLETED;
        #FAILED;
    };
    
    // Mission objective
    public type MissionObjective = {
        id : Nat64;
        objectiveType : Text;
        description : Text;
        location : ?Vector3;
        area : ?[Vector3];
        targetEntity : ?Nat64;
        priority : Nat;
        required : Bool;
        timeConstraint : ?TimeConstraint;
        successCriteria : [SuccessCriterion];
        assignedDrones : [Nat64];
        status : Text;
        progress : Float;
        completedTime : ?Nat64;
    };
    
    // Time constraint
    public type TimeConstraint = {
        earliestStart : Nat64;
        latestStart : Nat64;
        deadline : Nat64;
        maxDuration : Nat64;
    };
    
    // Success criterion
    public type SuccessCriterion = {
        criterionType : Text;
        metric : Text;
        threshold : Float;
        achieved : Bool;
        currentValue : Float;
    };
    
    // Full mission definition
    public type Mission = {
        id : Nat64;
        name : Text;
        missionType : MissionType;
        priority : MissionPriority;
        status : MissionStatus;
        classification : IntelligenceClassification;
        commander : Principal;
        planners : [Principal];
        createdTime : Nat64;
        plannedStartTime : Nat64;
        actualStartTime : ?Nat64;
        plannedEndTime : Nat64;
        actualEndTime : ?Nat64;
        objectives : [MissionObjective];
        constraints : [MissionConstraint];
        rules_of_engagement : RulesOfEngagement;
        assignedAssets : [Nat64];
        operationalArea : OperationalArea;
        phases : [MissionPhase];
        contingencies : [Contingency];
        logistics : LogisticsRequirements;
        communications : CommsPlan;
        intelligence : IntelRequirements;
        riskAssessment : RiskAssessment;
    };
    
    // Mission constraint
    public type MissionConstraint = {
        constraintType : Text;
        description : Text;
        hard : Bool;
        value : Float;
        unit : Text;
    };
    
    // Rules of engagement
    public type RulesOfEngagement = {
        weaponsHold : Bool;
        weaponsFree : Bool;
        selfDefense : Bool;
        positiveIdentificationRequired : Bool;
        minimizeCollateralDamage : Bool;
        restrictedTargets : [Text];
        approvedTargets : [Text];
        escalationProcedure : Text;
        disengagementCriteria : Text;
    };
    
    // Operational area
    public type OperationalArea = {
        center : Vector3;
        radius : Float;
        polygon : ?[Vector3];
        minAltitude : Float;
        maxAltitude : Float;
        restrictedZones : [RestrictedZone];
    };
    
    // Restricted zone
    public type RestrictedZone = {
        id : Nat64;
        name : Text;
        zoneType : Text;
        polygon : [Vector3];
        minAltitude : Float;
        maxAltitude : Float;
        restrictions : [Text];
        activeTime : ?(Nat64, Nat64);
    };
    
    // Mission phase
    public type MissionPhase = {
        phaseNumber : Nat;
        name : Text;
        description : Text;
        plannedStart : Nat64;
        plannedEnd : Nat64;
        actualStart : ?Nat64;
        actualEnd : ?Nat64;
        status : Text;
        objectives : [Nat64];
        transitionCriteria : [Text];
    };
    
    // Contingency plan
    public type Contingency = {
        id : Nat64;
        triggerConditions : [Text];
        actions : [Text];
        priority : Nat;
        automatic : Bool;
    };
    
    // Logistics requirements
    public type LogisticsRequirements = {
        fuelRequired : Float;
        ammoRequired : Float;
        suppliesRequired : Float;
        maintenanceNeeds : [Text];
        resupplyPoints : [Vector3];
        evacuationRoutes : [[Vector3]];
    };
    
    // Communications plan
    public type CommsPlan = {
        primaryFrequency : Float;
        backupFrequency : Float;
        callSigns : [(Nat64, Text)];
        reportingSchedule : [Nat64];
        silenceProtocol : Text;
        emergencyProcedure : Text;
    };
    
    // Intelligence requirements
    public type IntelRequirements = {
        priorityIntelligenceRequirements : [Text];
        essentialElementsOfInformation : [Text];
        namedAreasOfInterest : [Vector3];
        targetedAreasOfInterest : [Vector3];
        collectionAssets : [Nat64];
    };
    
    // Risk assessment
    public type RiskAssessment = {
        overallRisk : Float;
        threatRisk : Float;
        environmentalRisk : Float;
        technicalRisk : Float;
        missionFailureRisk : Float;
        casualtyRisk : Float;
        collateralDamageRisk : Float;
        mitigations : [Text];
    };
    
    // ═══════════════════════════════════════════════════════════════════════════════════════════
    // SECTION 9: SWARM ALGORITHM TYPES
    // ═══════════════════════════════════════════════════════════════════════════════════════════
    
    // Swarm behavior type
    public type SwarmBehavior = {
        #AGGREGATION;
        #DISPERSION;
        #FLOCKING;
        #FORMATION;
        #FORAGING;
        #HUNTING;
        #EVASION;
        #MIGRATION;
        #EXPLORATION;
        #COVERAGE;
        #ENCIRCLEMENT;
        #ATTACK;
        #DEFENSE;
        #ESCORT;
        #RELAY;
    };
    
    // Formation type
    public type FormationType = {
        #LINE;
        #COLUMN;
        #WEDGE;
        #VEE;
        #ECHELON_LEFT;
        #ECHELON_RIGHT;
        #DIAMOND;
        #BOX;
        #CIRCLE;
        #SPHERE;
        #CUSTOM;
    };
    
    // Swarm state
    public type SwarmState = {
        id : Nat64;
        memberDrones : [Nat64];
        behavior : SwarmBehavior;
        formation : ?FormationType;
        leader : ?Nat64;
        centroid : Vector3;
        velocity : Vector3;
        spread : Float;
        coherence : Float;
        alignment : Float;
        separation : Float;
        pheromoneField : PheromoneField;
        consensusState : ConsensusState;
        taskAllocation : TaskAllocation;
    };
    
    // Pheromone field
    public type PheromoneField = {
        channels : [[Float]];
        resolution : Float;
        decay : Float;
        diffusion : Float;
        bounds : BoundingBox;
    };
    
    // Consensus state
    public type ConsensusState = {
        proposedValues : [(Nat64, Float)];
        agreedValue : ?Float;
        convergenceRate : Float;
        iterationsToConsensus : Nat;
        disagreements : Nat;
    };
    
    // Task allocation
    public type TaskAllocation = {
        tasks : [SwarmTask];
        assignments : [(Nat64, Nat64)];
        unassignedTasks : [Nat64];
        unassignedDrones : [Nat64];
        allocationMethod : Text;
        lastReallocation : Nat64;
    };
    
    // Swarm task
    public type SwarmTask = {
        id : Nat64;
        taskType : Text;
        location : ?Vector3;
        priority : Float;
        requiredDrones : Nat;
        assignedDrones : [Nat64];
        deadline : ?Nat64;
        progress : Float;
        status : Text;
    };
    
    // ═══════════════════════════════════════════════════════════════════════════════════════════
    // SECTION 10: NEURAL NETWORK TYPES
    // ═══════════════════════════════════════════════════════════════════════════════════════════
    
    // Activation functions
    public type ActivationFunction = {
        #RELU;
        #LEAKY_RELU;
        #ELU;
        #SELU;
        #SIGMOID;
        #TANH;
        #SOFTMAX;
        #SOFTPLUS;
        #SWISH;
        #GELU;
        #LINEAR;
    };
    
    // Layer type
    public type LayerType = {
        #DENSE;
        #CONVOLUTIONAL;
        #RECURRENT;
        #LSTM;
        #GRU;
        #ATTENTION;
        #TRANSFORMER;
        #DROPOUT;
        #BATCH_NORM;
        #LAYER_NORM;
        #POOLING;
        #FLATTEN;
        #EMBEDDING;
    };
    
    // Neural layer
    public type NeuralLayer = {
        layerType : LayerType;
        inputSize : Nat;
        outputSize : Nat;
        activation : ActivationFunction;
        weights : [Float];
        biases : [Float];
        gradients : [Float];
        momentum : [Float];
        dropoutRate : Float;
    };
    
    // Neural network
    public type NeuralNetwork = {
        id : Nat64;
        name : Text;
        layers : [NeuralLayer];
        learningRate : Float;
        momentum : Float;
        weightDecay : Float;
        batchSize : Nat;
        epochs : Nat;
        trainingLoss : Float;
        validationLoss : Float;
        accuracy : Float;
        lastUpdated : Nat64;
    };
    
    // ═══════════════════════════════════════════════════════════════════════════════════════════
    // SECTION 11: REINFORCEMENT LEARNING TYPES
    // ═══════════════════════════════════════════════════════════════════════════════════════════
    
    // RL action
    public type RLAction = {
        actionId : Nat;
        actionType : Text;
        parameters : [Float];
        probability : Float;
    };
    
    // RL state
    public type RLState = {
        stateId : Nat64;
        features : [Float];
        timestamp : Nat64;
        terminal : Bool;
    };
    
    // RL transition
    public type RLTransition = {
        state : RLState;
        action : RLAction;
        reward : Float;
        nextState : RLState;
        done : Bool;
    };
    
    // Experience replay buffer
    public type ExperienceBuffer = {
        capacity : Nat;
        transitions : [RLTransition];
        priorities : [Float];
        currentSize : Nat;
        totalExperiences : Nat64;
    };
    
    // Q-table entry
    public type QTableEntry = {
        stateHash : Nat64;
        actionValues : [Float];
        visitCounts : [Nat];
        lastUpdate : Nat64;
    };
    
    // Policy gradient state
    public type PolicyGradientState = {
        policyNetwork : NeuralNetwork;
        valueNetwork : NeuralNetwork;
        entropyCoefficient : Float;
        clipRange : Float;
        advantageEstimates : [Float];
        returns : [Float];
    };
    
    // Actor-Critic state
    public type ActorCriticState = {
        actor : NeuralNetwork;
        critic : NeuralNetwork;
        targetActor : NeuralNetwork;
        targetCritic : NeuralNetwork;
        tau : Float;
        gamma : Float;
    };
    
    // Multi-Agent RL state
    public type MARLState = {
        agents : [Nat64];
        jointState : [Float];
        individualStates : [(Nat64, [Float])];
        jointAction : [RLAction];
        rewards : [(Nat64, Float)];
        communicationChannel : [[Float]];
    };
    
    // ═══════════════════════════════════════════════════════════════════════════════════════════
    // SECTION 12: PATH PLANNING TYPES
    // ═══════════════════════════════════════════════════════════════════════════════════════════
    
    // Waypoint
    public type Waypoint = {
        id : Nat64;
        position : Vector3;
        velocity : ?Vector3;
        heading : ?Float;
        altitude : ?Float;
        arrivalTime : ?Nat64;
        holdTime : Float;
        waypointType : Text;
        actions : [Text];
    };
    
    // Path segment
    public type PathSegment = {
        startWaypoint : Nat64;
        endWaypoint : Nat64;
        segmentType : Text;
        length : Float;
        duration : Float;
        cost : Float;
        risk : Float;
        terrainType : TerrainType;
    };
    
    // Complete path
    public type Path = {
        id : Nat64;
        waypoints : [Waypoint];
        segments : [PathSegment];
        totalLength : Float;
        totalDuration : Float;
        totalCost : Float;
        totalRisk : Float;
        feasible : Bool;
        constraints : [Text];
    };
    
    // Navigation graph node
    public type NavGraphNode = {
        id : Nat64;
        position : Vector3;
        neighbors : [(Nat64, Float)];
        nodeType : Text;
        attributes : [(Text, Float)];
    };
    
    // Navigation mesh polygon
    public type NavMeshPolygon = {
        id : Nat64;
        vertices : [Vector3];
        neighbors : [Nat64];
        center : Vector3;
        area : Float;
        normal : Vector3;
        traversable : Bool;
        cost : Float;
    };
    
    // RRT node
    public type RRTNode = {
        id : Nat64;
        position : Vector3;
        parent : ?Nat64;
        cost : Float;
        children : [Nat64];
    };
    
    // ═══════════════════════════════════════════════════════════════════════════════════════════
    // SECTION 13: SENSOR FUSION TYPES
    // ═══════════════════════════════════════════════════════════════════════════════════════════
    
    // Kalman filter state
    public type KalmanState = {
        stateVector : [Float];
        covarianceMatrix : [Float];
        processNoise : [Float];
        measurementNoise : [Float];
        stateTransition : [Float];
        measurementMatrix : [Float];
        controlMatrix : [Float];
    };
    
    // Extended Kalman filter state
    public type EKFState = {
        state : [Float];
        covariance : [Float];
        jacobianF : [Float];
        jacobianH : [Float];
        processNoise : [Float];
        measurementNoise : [Float];
    };
    
    // Unscented Kalman filter state
    public type UKFState = {
        state : [Float];
        covariance : [Float];
        sigmaPoints : [[Float]];
        weights : [Float];
        alpha : Float;
        beta : Float;
        kappa : Float;
    };
    
    // Particle filter state
    public type ParticleFilterState = {
        particles : [[Float]];
        weights : [Float];
        numParticles : Nat;
        effectiveParticles : Float;
        resamplingThreshold : Float;
    };
    
    // Track state
    public type TrackState = {
        trackId : Nat64;
        state : [Float];
        covariance : [Float];
        confidence : Float;
        age : Nat;
        misses : Nat;
        hits : Nat;
        lastUpdate : Nat64;
        sensorSources : [Nat64];
        classification : Text;
        classConfidence : Float;
    };
    
    // Data association
    public type DataAssociation = {
        trackId : Nat64;
        measurementId : Nat64;
        distance : Float;
        probability : Float;
    };
    
    // Sensor model
    public type SensorModel = {
        sensorId : Nat64;
        sensorType : Text;
        measurementDimension : Nat;
        measurementNoise : [Float];
        detectionProbability : Float;
        falseAlarmRate : Float;
        fieldOfView : Float;
        maxRange : Float;
        minRange : Float;
        resolution : Float;
        accuracy : Float;
        latency : Float;
    };
    
    // ═══════════════════════════════════════════════════════════════════════════════════════════
    // SECTION 14: COMMUNICATION TYPES
    // ═══════════════════════════════════════════════════════════════════════════════════════════
    
    // Message type
    public type MessageType = {
        #HEARTBEAT;
        #TELEMETRY;
        #COMMAND;
        #ALERT;
        #INTEL_REPORT;
        #TRACK_UPDATE;
        #MISSION_UPDATE;
        #CONSENSUS_PROPOSAL;
        #CONSENSUS_VOTE;
        #PHEROMONE_BROADCAST;
        #FORMATION_UPDATE;
        #EMERGENCY;
    };
    
    // Swarm message
    public type SwarmMessage = {
        id : Nat64;
        messageType : MessageType;
        senderId : Nat64;
        recipientId : ?Nat64;
        broadcastRadius : Float;
        timestamp : Nat64;
        ttl : Nat;
        priority : Nat;
        encrypted : Bool;
        payload : Blob;
        signature : ?Blob;
    };
    
    // Command message
    public type CommandMessage = {
        commandId : Nat64;
        commandType : Text;
        parameters : [(Text, Text)];
        targetDrones : [Nat64];
        executionTime : ?Nat64;
        timeout : Nat64;
        requiresAck : Bool;
        priority : Nat;
    };
    
    // Telemetry message
    public type TelemetryMessage = {
        droneId : Nat64;
        timestamp : Nat64;
        position : Vector3;
        velocity : Vector3;
        attitude : Quaternion;
        batteryLevel : Float;
        health : Float;
        status : Text;
        sensorData : [(Text, Float)];
    };
    
    // ═══════════════════════════════════════════════════════════════════════════════════════════
    // SECTION 15: AZURE INTEGRATION TYPES
    // ═══════════════════════════════════════════════════════════════════════════════════════════
    
    // Azure IoT device state
    public type AzureDeviceState = {
        deviceId : Text;
        connectionState : Text;
        lastActivityTime : Nat64;
        cloudToDeviceMessageCount : Nat;
        authenticationType : Text;
        capabilities : [Text];
        tags : [(Text, Text)];
        properties : [(Text, Text)];
    };
    
    // Azure IoT message
    public type AzureIoTMessage = {
        messageId : Text;
        correlationId : Text;
        deviceId : Text;
        timestamp : Nat64;
        contentType : Text;
        contentEncoding : Text;
        properties : [(Text, Text)];
        body : Blob;
    };
    
    // Azure Digital Twin
    public type AzureDigitalTwin = {
        twinId : Text;
        modelId : Text;
        etag : Text;
        properties : [(Text, Text)];
        relationships : [TwinRelationship];
        lastUpdated : Nat64;
    };
    
    // Twin relationship
    public type TwinRelationship = {
        relationshipId : Text;
        relationshipName : Text;
        sourceId : Text;
        targetId : Text;
        properties : [(Text, Text)];
    };
    
    // Azure Event
    public type AzureEvent = {
        eventId : Text;
        eventType : Text;
        subject : Text;
        eventTime : Nat64;
        data : Blob;
        dataVersion : Text;
    };
    
    // ═══════════════════════════════════════════════════════════════════════════════════════════
    // SECTION 16: BLOCKCHAIN TYPES
    // ═══════════════════════════════════════════════════════════════════════════════════════════
    
    // Transaction record
    public type BlockchainTransaction = {
        txId : Nat64;
        timestamp : Nat64;
        sender : Principal;
        receiver : Principal;
        amount : Nat64;
        fee : Nat64;
        memo : Blob;
        txType : Text;
        status : Text;
        blockHeight : Nat64;
    };
    
    // Smart contract state
    public type SmartContractState = {
        contractId : Principal;
        version : Nat;
        owner : Principal;
        balance : Nat64;
        storage : [(Text, Blob)];
        lastExecution : Nat64;
        executionCount : Nat64;
    };
    
    // Oracle data
    public type OracleData = {
        oracleId : Principal;
        dataType : Text;
        value : Float;
        timestamp : Nat64;
        confidence : Float;
        sources : [Text];
        signature : Blob;
    };
    
    // Multi-chain state
    public type MultiChainState = {
        chainId : Text;
        chainType : Text;
        blockHeight : Nat64;
        lastSync : Nat64;
        bridgeBalance : Nat64;
        pendingTransactions : [Nat64];
    };
    
    // ═══════════════════════════════════════════════════════════════════════════════════════════
    // SECTION 17: ICP SPECIFIC TYPES
    // ═══════════════════════════════════════════════════════════════════════════════════════════
    
    // Canister state
    public type CanisterState = {
        canisterId : Principal;
        controllers : [Principal];
        moduleHash : Blob;
        memoryUsage : Nat64;
        cycleBalance : Nat;
        status : Text;
        lastUpgrade : Nat64;
    };
    
    // Inter-canister call
    public type InterCanisterCall = {
        callId : Nat64;
        targetCanister : Principal;
        methodName : Text;
        args : Blob;
        cycles : Nat;
        timestamp : Nat64;
        status : Text;
        response : ?Blob;
        error : ?Text;
    };
    
    // HTTP outcall request
    public type HTTPOutcallRequest = {
        url : Text;
        method : Text;
        headers : [(Text, Text)];
        body : ?Blob;
        maxResponseBytes : Nat64;
        transform : ?Text;
    };
    
    // HTTP outcall response
    public type HTTPOutcallResponse = {
        status : Nat;
        headers : [(Text, Text)];
        body : Blob;
    };
    
    // Stable memory region
    public type StableMemoryRegion = {
        regionId : Nat64;
        startAddress : Nat64;
        size : Nat64;
        dataType : Text;
        checksum : Nat32;
        lastModified : Nat64;
    };
    
    // ═══════════════════════════════════════════════════════════════════════════════════════════
    // SECTION 18: COMPLETE CHIMERA STATE
    // ═══════════════════════════════════════════════════════════════════════════════════════════
    
    // Complete Chimera Intelligence Core State
    public type ChimeraState = {
        // Core identification
        systemId : Nat64;
        version : Nat;
        initialized : Bool;
        lastTick : Nat64;
        tickCount : Nat64;
        
        // Drone fleet
        drones : [DroneState];
        activeDrones : Nat;
        totalDrones : Nat;
        
        // Swarm state
        swarms : [SwarmState];
        activeSwarms : Nat;
        
        // World model
        trackedEntities : [TrackedEntity];
        terrainGrid : [TerrainCell];
        weatherConditions : WeatherConditions;
        emEnvironment : EMEnvironment;
        
        // Intelligence
        intelligenceReports : [IntelligenceReport];
        threatAssessment : ThreatAssessment;
        situationalAwareness : Float;
        
        // Missions
        activeMissions : [Mission];
        completedMissions : Nat;
        missionSuccessRate : Float;
        
        // Neural networks
        neuralNetworks : [NeuralNetwork];
        rlStates : [(Text, ActorCriticState)];
        
        // Sensor fusion
        kalmanFilters : [(Nat64, KalmanState)];
        tracks : [TrackState];
        sensorModels : [SensorModel];
        
        // Communications
        messageQueue : [SwarmMessage];
        pendingCommands : [CommandMessage];
        
        // External integrations
        azureDevices : [AzureDeviceState];
        digitalTwins : [AzureDigitalTwin];
        blockchainState : [(Text, MultiChainState)];
        
        // ICP state
        canisters : [CanisterState];
        pendingCalls : [InterCanisterCall];
        stableMemory : [StableMemoryRegion];
        
        // Performance metrics
        cpuUsage : Float;
        memoryUsage : Float;
        cyclesConsumed : Nat;
        latency : Float;
        throughput : Float;
    };

    // ═══════════════════════════════════════════════════════════════════════════════════════════
    // SECTION 19: INITIALIZATION FUNCTIONS
    // ═══════════════════════════════════════════════════════════════════════════════════════════
    
    // Initialize a new Vector3
    public func initVector3(x : Float, y : Float, z : Float) : Vector3 {
        { x = x; y = y; z = z }
    };
    
    // Initialize zero vector
    public func zeroVector3() : Vector3 {
        { x = 0.0; y = 0.0; z = 0.0 }
    };
    
    // Initialize unit vectors
    public func unitX() : Vector3 { { x = 1.0; y = 0.0; z = 0.0 } };
    public func unitY() : Vector3 { { x = 0.0; y = 1.0; z = 0.0 } };
    public func unitZ() : Vector3 { { x = 0.0; y = 0.0; z = 1.0 } };
    
    // Initialize identity quaternion
    public func identityQuaternion() : Quaternion {
        { w = 1.0; x = 0.0; y = 0.0; z = 0.0 }
    };
    
    // Initialize quaternion from axis-angle
    public func quaternionFromAxisAngle(axis : Vector3, angle : Float) : Quaternion {
        let halfAngle = angle / 2.0;
        let s = Float.sin(halfAngle);
        let mag = vectorMagnitude(axis);
        if (mag < 1e-10) {
            return identityQuaternion();
        };
        let nx = axis.x / mag;
        let ny = axis.y / mag;
        let nz = axis.z / mag;
        {
            w = Float.cos(halfAngle);
            x = nx * s;
            y = ny * s;
            z = nz * s;
        }
    };
    
    // Initialize identity matrix 4x4
    public func identityMatrix4x4() : Matrix4x4 {
        {
            m = [
                1.0, 0.0, 0.0, 0.0,
                0.0, 1.0, 0.0, 0.0,
                0.0, 0.0, 1.0, 0.0,
                0.0, 0.0, 0.0, 1.0
            ]
        }
    };
    
    // Initialize identity matrix 3x3
    public func identityMatrix3x3() : Matrix3x3 {
        {
            m = [
                1.0, 0.0, 0.0,
                0.0, 1.0, 0.0,
                0.0, 0.0, 1.0
            ]
        }
    };
    
    // Initialize default pose
    public func initPose(pos : Vector3, orient : Quaternion, ts : Nat64) : Pose {
        {
            position = pos;
            orientation = orient;
            timestamp = ts;
        }
    };
    
    // Initialize default velocity
    public func initVelocity() : Velocity {
        {
            linear = zeroVector3();
            angular = zeroVector3();
        }
    };
    
    // Initialize kinematic state
    public func initKinematicState(pose : Pose) : KinematicState {
        {
            pose = pose;
            velocity = initVelocity();
            acceleration = zeroVector3();
            jerk = zeroVector3();
        }
    };
    
    // Initialize bounding box
    public func initBoundingBox(minV : Vector3, maxV : Vector3) : BoundingBox {
        { min = minV; max = maxV }
    };
    
    // Initialize bounding sphere
    public func initBoundingSphere(center : Vector3, radius : Float) : BoundingSphere {
        { center = center; radius = radius }
    };
    
    // ═══════════════════════════════════════════════════════════════════════════════════════════
    // SECTION 20: VECTOR MATH OPERATIONS
    // ═══════════════════════════════════════════════════════════════════════════════════════════
    
    // Vector addition
    public func vectorAdd(a : Vector3, b : Vector3) : Vector3 {
        { x = a.x + b.x; y = a.y + b.y; z = a.z + b.z }
    };
    
    // Vector subtraction
    public func vectorSub(a : Vector3, b : Vector3) : Vector3 {
        { x = a.x - b.x; y = a.y - b.y; z = a.z - b.z }
    };
    
    // Vector scalar multiplication
    public func vectorScale(v : Vector3, s : Float) : Vector3 {
        { x = v.x * s; y = v.y * s; z = v.z * s }
    };
    
    // Vector dot product
    public func vectorDot(a : Vector3, b : Vector3) : Float {
        a.x * b.x + a.y * b.y + a.z * b.z
    };
    
    // Vector cross product
    public func vectorCross(a : Vector3, b : Vector3) : Vector3 {
        {
            x = a.y * b.z - a.z * b.y;
            y = a.z * b.x - a.x * b.z;
            z = a.x * b.y - a.y * b.x;
        }
    };
    
    // Vector magnitude
    public func vectorMagnitude(v : Vector3) : Float {
        Float.sqrt(v.x * v.x + v.y * v.y + v.z * v.z)
    };
    
    // Vector magnitude squared (faster, no sqrt)
    public func vectorMagnitudeSq(v : Vector3) : Float {
        v.x * v.x + v.y * v.y + v.z * v.z
    };
    
    // Vector normalize
    public func vectorNormalize(v : Vector3) : Vector3 {
        let mag = vectorMagnitude(v);
        if (mag < 1e-10) {
            return zeroVector3();
        };
        vectorScale(v, 1.0 / mag)
    };
    
    // Vector distance
    public func vectorDistance(a : Vector3, b : Vector3) : Float {
        vectorMagnitude(vectorSub(b, a))
    };
    
    // Vector distance squared
    public func vectorDistanceSq(a : Vector3, b : Vector3) : Float {
        vectorMagnitudeSq(vectorSub(b, a))
    };
    
    // Vector lerp (linear interpolation)
    public func vectorLerp(a : Vector3, b : Vector3, t : Float) : Vector3 {
        {
            x = a.x + (b.x - a.x) * t;
            y = a.y + (b.y - a.y) * t;
            z = a.z + (b.z - a.z) * t;
        }
    };
    
    // Vector slerp (spherical linear interpolation)
    public func vectorSlerp(a : Vector3, b : Vector3, t : Float) : Vector3 {
        let dot = vectorDot(vectorNormalize(a), vectorNormalize(b));
        let theta = Float.arccos(Float.min(Float.max(dot, -1.0), 1.0));
        if (Float.abs(theta) < 1e-6) {
            return vectorLerp(a, b, t);
        };
        let sinTheta = Float.sin(theta);
        let wa = Float.sin((1.0 - t) * theta) / sinTheta;
        let wb = Float.sin(t * theta) / sinTheta;
        vectorAdd(vectorScale(a, wa), vectorScale(b, wb))
    };
    
    // Vector reflection
    public func vectorReflect(v : Vector3, normal : Vector3) : Vector3 {
        let n = vectorNormalize(normal);
        let d = 2.0 * vectorDot(v, n);
        vectorSub(v, vectorScale(n, d))
    };
    
    // Vector projection onto another vector
    public func vectorProject(v : Vector3, onto : Vector3) : Vector3 {
        let ontoMagSq = vectorMagnitudeSq(onto);
        if (ontoMagSq < 1e-10) {
            return zeroVector3();
        };
        let scale = vectorDot(v, onto) / ontoMagSq;
        vectorScale(onto, scale)
    };
    
    // Vector rejection (perpendicular component)
    public func vectorReject(v : Vector3, from : Vector3) : Vector3 {
        vectorSub(v, vectorProject(v, from))
    };
    
    // Angle between vectors (radians)
    public func vectorAngle(a : Vector3, b : Vector3) : Float {
        let magA = vectorMagnitude(a);
        let magB = vectorMagnitude(b);
        if (magA < 1e-10 or magB < 1e-10) {
            return 0.0;
        };
        let dot = vectorDot(a, b) / (magA * magB);
        Float.arccos(Float.min(Float.max(dot, -1.0), 1.0))
    };
    
    // Signed angle between vectors around axis
    public func vectorSignedAngle(a : Vector3, b : Vector3, axis : Vector3) : Float {
        let unsignedAngle = vectorAngle(a, b);
        let cross = vectorCross(a, b);
        if (vectorDot(cross, axis) < 0.0) {
            return -unsignedAngle;
        };
        unsignedAngle
    };
    
    // Clamp vector magnitude
    public func vectorClampMagnitude(v : Vector3, maxMag : Float) : Vector3 {
        let mag = vectorMagnitude(v);
        if (mag <= maxMag or mag < 1e-10) {
            return v;
        };
        vectorScale(v, maxMag / mag)
    };
    
    // Component-wise min
    public func vectorMin(a : Vector3, b : Vector3) : Vector3 {
        {
            x = Float.min(a.x, b.x);
            y = Float.min(a.y, b.y);
            z = Float.min(a.z, b.z);
        }
    };
    
    // Component-wise max
    public func vectorMax(a : Vector3, b : Vector3) : Vector3 {
        {
            x = Float.max(a.x, b.x);
            y = Float.max(a.y, b.y);
            z = Float.max(a.z, b.z);
        }
    };
    
    // Component-wise abs
    public func vectorAbs(v : Vector3) : Vector3 {
        {
            x = Float.abs(v.x);
            y = Float.abs(v.y);
            z = Float.abs(v.z);
        }
    };
    
    // Component-wise multiply
    public func vectorMul(a : Vector3, b : Vector3) : Vector3 {
        { x = a.x * b.x; y = a.y * b.y; z = a.z * b.z }
    };
    
    // Component-wise divide
    public func vectorDiv(a : Vector3, b : Vector3) : Vector3 {
        {
            x = if (Float.abs(b.x) < 1e-10) 0.0 else a.x / b.x;
            y = if (Float.abs(b.y) < 1e-10) 0.0 else a.y / b.y;
            z = if (Float.abs(b.z) < 1e-10) 0.0 else a.z / b.z;
        }
    };
    
    // ═══════════════════════════════════════════════════════════════════════════════════════════
    // SECTION 21: QUATERNION OPERATIONS
    // ═══════════════════════════════════════════════════════════════════════════════════════════
    
    // Quaternion multiplication
    public func quaternionMul(a : Quaternion, b : Quaternion) : Quaternion {
        {
            w = a.w * b.w - a.x * b.x - a.y * b.y - a.z * b.z;
            x = a.w * b.x + a.x * b.w + a.y * b.z - a.z * b.y;
            y = a.w * b.y - a.x * b.z + a.y * b.w + a.z * b.x;
            z = a.w * b.z + a.x * b.y - a.y * b.x + a.z * b.w;
        }
    };
    
    // Quaternion conjugate
    public func quaternionConjugate(q : Quaternion) : Quaternion {
        { w = q.w; x = -q.x; y = -q.y; z = -q.z }
    };
    
    // Quaternion magnitude
    public func quaternionMagnitude(q : Quaternion) : Float {
        Float.sqrt(q.w * q.w + q.x * q.x + q.y * q.y + q.z * q.z)
    };
    
    // Quaternion normalize
    public func quaternionNormalize(q : Quaternion) : Quaternion {
        let mag = quaternionMagnitude(q);
        if (mag < 1e-10) {
            return identityQuaternion();
        };
        { w = q.w / mag; x = q.x / mag; y = q.y / mag; z = q.z / mag }
    };
    
    // Quaternion inverse
    public func quaternionInverse(q : Quaternion) : Quaternion {
        let magSq = q.w * q.w + q.x * q.x + q.y * q.y + q.z * q.z;
        if (magSq < 1e-10) {
            return identityQuaternion();
        };
        { w = q.w / magSq; x = -q.x / magSq; y = -q.y / magSq; z = -q.z / magSq }
    };
    
    // Rotate vector by quaternion
    public func quaternionRotateVector(q : Quaternion, v : Vector3) : Vector3 {
        let qv : Quaternion = { w = 0.0; x = v.x; y = v.y; z = v.z };
        let qConj = quaternionConjugate(q);
        let result = quaternionMul(quaternionMul(q, qv), qConj);
        { x = result.x; y = result.y; z = result.z }
    };
    
    // Quaternion slerp
    public func quaternionSlerp(a : Quaternion, b : Quaternion, t : Float) : Quaternion {
        var dot = a.w * b.w + a.x * b.x + a.y * b.y + a.z * b.z;
        var bAdj = b;
        
        // If dot < 0, negate one quaternion to take shorter path
        if (dot < 0.0) {
            bAdj := { w = -b.w; x = -b.x; y = -b.y; z = -b.z };
            dot := -dot;
        };
        
        // If quaternions are very close, use linear interpolation
        if (dot > 0.9995) {
            return quaternionNormalize({
                w = a.w + (bAdj.w - a.w) * t;
                x = a.x + (bAdj.x - a.x) * t;
                y = a.y + (bAdj.y - a.y) * t;
                z = a.z + (bAdj.z - a.z) * t;
            });
        };
        
        let theta = Float.arccos(dot);
        let sinTheta = Float.sin(theta);
        let wa = Float.sin((1.0 - t) * theta) / sinTheta;
        let wb = Float.sin(t * theta) / sinTheta;
        
        {
            w = a.w * wa + bAdj.w * wb;
            x = a.x * wa + bAdj.x * wb;
            y = a.y * wa + bAdj.y * wb;
            z = a.z * wa + bAdj.z * wb;
        }
    };
    
    // Quaternion from Euler angles (ZYX convention)
    public func quaternionFromEuler(roll : Float, pitch : Float, yaw : Float) : Quaternion {
        let cr = Float.cos(roll / 2.0);
        let sr = Float.sin(roll / 2.0);
        let cp = Float.cos(pitch / 2.0);
        let sp = Float.sin(pitch / 2.0);
        let cy = Float.cos(yaw / 2.0);
        let sy = Float.sin(yaw / 2.0);
        
        {
            w = cr * cp * cy + sr * sp * sy;
            x = sr * cp * cy - cr * sp * sy;
            y = cr * sp * cy + sr * cp * sy;
            z = cr * cp * sy - sr * sp * cy;
        }
    };
    
    // Quaternion to Euler angles (returns roll, pitch, yaw)
    public func quaternionToEuler(q : Quaternion) : (Float, Float, Float) {
        // Roll (x-axis rotation)
        let sinrCosp = 2.0 * (q.w * q.x + q.y * q.z);
        let cosrCosp = 1.0 - 2.0 * (q.x * q.x + q.y * q.y);
        let roll = Float.arctan2(sinrCosp, cosrCosp);
        
        // Pitch (y-axis rotation)
        let sinp = 2.0 * (q.w * q.y - q.z * q.x);
        let pitch = if (Float.abs(sinp) >= 1.0) {
            if (sinp > 0.0) PI / 2.0 else -PI / 2.0
        } else {
            Float.arcsin(sinp)
        };
        
        // Yaw (z-axis rotation)
        let sinyCosp = 2.0 * (q.w * q.z + q.x * q.y);
        let cosyCosp = 1.0 - 2.0 * (q.y * q.y + q.z * q.z);
        let yaw = Float.arctan2(sinyCosp, cosyCosp);
        
        (roll, pitch, yaw)
    };
    
    // Quaternion look rotation (creates quaternion looking from origin towards target)
    public func quaternionLookRotation(forward : Vector3, up : Vector3) : Quaternion {
        let f = vectorNormalize(forward);
        let r = vectorNormalize(vectorCross(up, f));
        let u = vectorCross(f, r);
        
        // Build rotation matrix and convert to quaternion
        let m00 = r.x; let m01 = u.x; let m02 = f.x;
        let m10 = r.y; let m11 = u.y; let m12 = f.y;
        let m20 = r.z; let m21 = u.z; let m22 = f.z;
        
        let trace = m00 + m11 + m22;
        
        if (trace > 0.0) {
            let s = 0.5 / Float.sqrt(trace + 1.0);
            return {
                w = 0.25 / s;
                x = (m21 - m12) * s;
                y = (m02 - m20) * s;
                z = (m10 - m01) * s;
            };
        } else if (m00 > m11 and m00 > m22) {
            let s = 2.0 * Float.sqrt(1.0 + m00 - m11 - m22);
            return {
                w = (m21 - m12) / s;
                x = 0.25 * s;
                y = (m01 + m10) / s;
                z = (m02 + m20) / s;
            };
        } else if (m11 > m22) {
            let s = 2.0 * Float.sqrt(1.0 + m11 - m00 - m22);
            return {
                w = (m02 - m20) / s;
                x = (m01 + m10) / s;
                y = 0.25 * s;
                z = (m12 + m21) / s;
            };
        } else {
            let s = 2.0 * Float.sqrt(1.0 + m22 - m00 - m11);
            return {
                w = (m10 - m01) / s;
                x = (m02 + m20) / s;
                y = (m12 + m21) / s;
                z = 0.25 * s;
            };
        };
    };
    
    // Angle between quaternions
    public func quaternionAngle(a : Quaternion, b : Quaternion) : Float {
        let dot = Float.abs(a.w * b.w + a.x * b.x + a.y * b.y + a.z * b.z);
        2.0 * Float.arccos(Float.min(dot, 1.0))
    };
    
    // ═══════════════════════════════════════════════════════════════════════════════════════════
    // SECTION 22: MATRIX OPERATIONS
    // ═══════════════════════════════════════════════════════════════════════════════════════════
    
    // Get matrix element (4x4)
    public func mat4Get(m : Matrix4x4, row : Nat, col : Nat) : Float {
        m.m[row * 4 + col]
    };
    
    // Matrix 4x4 multiplication
    public func mat4Mul(a : Matrix4x4, b : Matrix4x4) : Matrix4x4 {
        let result = Array.tabulate<Float>(16, func(i : Nat) : Float {
            let row = i / 4;
            let col = i % 4;
            var sum : Float = 0.0;
            for (k in Iter.range(0, 3)) {
                sum += mat4Get(a, row, k) * mat4Get(b, k, col);
            };
            sum
        });
        { m = result }
    };
    
    // Transform vector by matrix 4x4 (assumes w=1)
    public func mat4TransformPoint(m : Matrix4x4, v : Vector3) : Vector3 {
        let x = mat4Get(m, 0, 0) * v.x + mat4Get(m, 0, 1) * v.y + mat4Get(m, 0, 2) * v.z + mat4Get(m, 0, 3);
        let y = mat4Get(m, 1, 0) * v.x + mat4Get(m, 1, 1) * v.y + mat4Get(m, 1, 2) * v.z + mat4Get(m, 1, 3);
        let z = mat4Get(m, 2, 0) * v.x + mat4Get(m, 2, 1) * v.y + mat4Get(m, 2, 2) * v.z + mat4Get(m, 2, 3);
        let w = mat4Get(m, 3, 0) * v.x + mat4Get(m, 3, 1) * v.y + mat4Get(m, 3, 2) * v.z + mat4Get(m, 3, 3);
        if (Float.abs(w) < 1e-10) {
            return { x = x; y = y; z = z };
        };
        { x = x / w; y = y / w; z = z / w }
    };
    
    // Transform direction by matrix 4x4 (ignores translation)
    public func mat4TransformDirection(m : Matrix4x4, v : Vector3) : Vector3 {
        {
            x = mat4Get(m, 0, 0) * v.x + mat4Get(m, 0, 1) * v.y + mat4Get(m, 0, 2) * v.z;
            y = mat4Get(m, 1, 0) * v.x + mat4Get(m, 1, 1) * v.y + mat4Get(m, 1, 2) * v.z;
            z = mat4Get(m, 2, 0) * v.x + mat4Get(m, 2, 1) * v.y + mat4Get(m, 2, 2) * v.z;
        }
    };
    
    // Create translation matrix
    public func mat4Translation(t : Vector3) : Matrix4x4 {
        {
            m = [
                1.0, 0.0, 0.0, t.x,
                0.0, 1.0, 0.0, t.y,
                0.0, 0.0, 1.0, t.z,
                0.0, 0.0, 0.0, 1.0
            ]
        }
    };
    
    // Create scale matrix
    public func mat4Scale(s : Vector3) : Matrix4x4 {
        {
            m = [
                s.x, 0.0, 0.0, 0.0,
                0.0, s.y, 0.0, 0.0,
                0.0, 0.0, s.z, 0.0,
                0.0, 0.0, 0.0, 1.0
            ]
        }
    };
    
    // Create rotation matrix from quaternion
    public func mat4FromQuaternion(q : Quaternion) : Matrix4x4 {
        let xx = q.x * q.x;
        let yy = q.y * q.y;
        let zz = q.z * q.z;
        let xy = q.x * q.y;
        let xz = q.x * q.z;
        let yz = q.y * q.z;
        let wx = q.w * q.x;
        let wy = q.w * q.y;
        let wz = q.w * q.z;
        
        {
            m = [
                1.0 - 2.0 * (yy + zz), 2.0 * (xy - wz), 2.0 * (xz + wy), 0.0,
                2.0 * (xy + wz), 1.0 - 2.0 * (xx + zz), 2.0 * (yz - wx), 0.0,
                2.0 * (xz - wy), 2.0 * (yz + wx), 1.0 - 2.0 * (xx + yy), 0.0,
                0.0, 0.0, 0.0, 1.0
            ]
        }
    };
    
    // Create TRS (translation-rotation-scale) matrix
    public func mat4TRS(t : Vector3, r : Quaternion, s : Vector3) : Matrix4x4 {
        let rotMat = mat4FromQuaternion(r);
        {
            m = [
                rotMat.m[0] * s.x, rotMat.m[1] * s.y, rotMat.m[2] * s.z, t.x,
                rotMat.m[4] * s.x, rotMat.m[5] * s.y, rotMat.m[6] * s.z, t.y,
                rotMat.m[8] * s.x, rotMat.m[9] * s.y, rotMat.m[10] * s.z, t.z,
                0.0, 0.0, 0.0, 1.0
            ]
        }
    };
    
    // Matrix transpose 4x4
    public func mat4Transpose(m : Matrix4x4) : Matrix4x4 {
        {
            m = [
                m.m[0], m.m[4], m.m[8], m.m[12],
                m.m[1], m.m[5], m.m[9], m.m[13],
                m.m[2], m.m[6], m.m[10], m.m[14],
                m.m[3], m.m[7], m.m[11], m.m[15]
            ]
        }
    };
    
    // Matrix determinant 4x4
    public func mat4Determinant(m : Matrix4x4) : Float {
        let a = m.m[0]; let b = m.m[1]; let c = m.m[2]; let d = m.m[3];
        let e = m.m[4]; let f = m.m[5]; let g = m.m[6]; let h = m.m[7];
        let i = m.m[8]; let j = m.m[9]; let k = m.m[10]; let l = m.m[11];
        let mm = m.m[12]; let n = m.m[13]; let o = m.m[14]; let p = m.m[15];
        
        a * (f * (k * p - l * o) - g * (j * p - l * n) + h * (j * o - k * n)) -
        b * (e * (k * p - l * o) - g * (i * p - l * mm) + h * (i * o - k * mm)) +
        c * (e * (j * p - l * n) - f * (i * p - l * mm) + h * (i * n - j * mm)) -
        d * (e * (j * o - k * n) - f * (i * o - k * mm) + g * (i * n - j * mm))
    };
    
    // ═══════════════════════════════════════════════════════════════════════════════════════════
    // SECTION 23: GEOMETRIC COLLISION DETECTION
    // ═══════════════════════════════════════════════════════════════════════════════════════════
    
    // Point in AABB
    public func pointInAABB(point : Vector3, box : BoundingBox) : Bool {
        point.x >= box.min.x and point.x <= box.max.x and
        point.y >= box.min.y and point.y <= box.max.y and
        point.z >= box.min.z and point.z <= box.max.z
    };
    
    // Point in sphere
    public func pointInSphere(point : Vector3, sphere : BoundingSphere) : Bool {
        vectorDistanceSq(point, sphere.center) <= sphere.radius * sphere.radius
    };
    
    // AABB vs AABB intersection
    public func aabbIntersectsAABB(a : BoundingBox, b : BoundingBox) : Bool {
        a.min.x <= b.max.x and a.max.x >= b.min.x and
        a.min.y <= b.max.y and a.max.y >= b.min.y and
        a.min.z <= b.max.z and a.max.z >= b.min.z
    };
    
    // Sphere vs sphere intersection
    public func sphereIntersectsSphere(a : BoundingSphere, b : BoundingSphere) : Bool {
        let radSum = a.radius + b.radius;
        vectorDistanceSq(a.center, b.center) <= radSum * radSum
    };
    
    // AABB vs sphere intersection
    public func aabbIntersectsSphere(box : BoundingBox, sphere : BoundingSphere) : Bool {
        // Find closest point on AABB to sphere center
        let closest = {
            x = Float.max(box.min.x, Float.min(sphere.center.x, box.max.x));
            y = Float.max(box.min.y, Float.min(sphere.center.y, box.max.y));
            z = Float.max(box.min.z, Float.min(sphere.center.z, box.max.z));
        };
        vectorDistanceSq(closest, sphere.center) <= sphere.radius * sphere.radius
    };
    
    // Ray vs AABB intersection (returns t parameter or null)
    public func rayIntersectsAABB(rayOrigin : Vector3, rayDir : Vector3, box : BoundingBox) : ?Float {
        let invDir = {
            x = if (Float.abs(rayDir.x) < 1e-10) 1e10 else 1.0 / rayDir.x;
            y = if (Float.abs(rayDir.y) < 1e-10) 1e10 else 1.0 / rayDir.y;
            z = if (Float.abs(rayDir.z) < 1e-10) 1e10 else 1.0 / rayDir.z;
        };
        
        let t1 = (box.min.x - rayOrigin.x) * invDir.x;
        let t2 = (box.max.x - rayOrigin.x) * invDir.x;
        let t3 = (box.min.y - rayOrigin.y) * invDir.y;
        let t4 = (box.max.y - rayOrigin.y) * invDir.y;
        let t5 = (box.min.z - rayOrigin.z) * invDir.z;
        let t6 = (box.max.z - rayOrigin.z) * invDir.z;
        
        let tmin = Float.max(Float.max(Float.min(t1, t2), Float.min(t3, t4)), Float.min(t5, t6));
        let tmax = Float.min(Float.min(Float.max(t1, t2), Float.max(t3, t4)), Float.max(t5, t6));
        
        if (tmax < 0.0 or tmin > tmax) {
            return null;
        };
        
        ?tmin
    };
    
    // Ray vs sphere intersection
    public func rayIntersectsSphere(rayOrigin : Vector3, rayDir : Vector3, sphere : BoundingSphere) : ?Float {
        let oc = vectorSub(rayOrigin, sphere.center);
        let a = vectorDot(rayDir, rayDir);
        let b = 2.0 * vectorDot(oc, rayDir);
        let c = vectorDot(oc, oc) - sphere.radius * sphere.radius;
        let discriminant = b * b - 4.0 * a * c;
        
        if (discriminant < 0.0) {
            return null;
        };
        
        let t = (-b - Float.sqrt(discriminant)) / (2.0 * a);
        if (t < 0.0) {
            return null;
        };
        
        ?t
    };
    
    // Ray vs plane intersection
    public func rayIntersectsPlane(rayOrigin : Vector3, rayDir : Vector3, planeNormal : Vector3, planeD : Float) : ?Float {
        let denom = vectorDot(planeNormal, rayDir);
        if (Float.abs(denom) < 1e-10) {
            return null;
        };
        let t = -(vectorDot(planeNormal, rayOrigin) + planeD) / denom;
        if (t < 0.0) {
            return null;
        };
        ?t
    };
    
    // Closest point on line segment to point
    public func closestPointOnSegment(segStart : Vector3, segEnd : Vector3, point : Vector3) : Vector3 {
        let seg = vectorSub(segEnd, segStart);
        let segLenSq = vectorMagnitudeSq(seg);
        if (segLenSq < 1e-10) {
            return segStart;
        };
        var t = vectorDot(vectorSub(point, segStart), seg) / segLenSq;
        t := Float.max(0.0, Float.min(1.0, t));
        vectorAdd(segStart, vectorScale(seg, t))
    };
    
    // Distance from point to line segment
    public func pointToSegmentDistance(segStart : Vector3, segEnd : Vector3, point : Vector3) : Float {
        vectorDistance(point, closestPointOnSegment(segStart, segEnd, point))
    };
    
    // Closest points between two line segments
    public func closestPointsBetweenSegments(
        a1 : Vector3, a2 : Vector3,
        b1 : Vector3, b2 : Vector3
    ) : (Vector3, Vector3) {
        let d1 = vectorSub(a2, a1);
        let d2 = vectorSub(b2, b1);
        let r = vectorSub(a1, b1);
        
        let a = vectorDot(d1, d1);
        let e = vectorDot(d2, d2);
        let f = vectorDot(d2, r);
        
        var s : Float = 0.0;
        var t : Float = 0.0;
        
        if (a < 1e-10 and e < 1e-10) {
            // Both segments are points
            return (a1, b1);
        };
        
        if (a < 1e-10) {
            // First segment is a point
            t := Float.max(0.0, Float.min(1.0, f / e));
        } else {
            let c = vectorDot(d1, r);
            if (e < 1e-10) {
                // Second segment is a point
                s := Float.max(0.0, Float.min(1.0, -c / a));
            } else {
                let b = vectorDot(d1, d2);
                let denom = a * e - b * b;
                
                if (denom != 0.0) {
                    s := Float.max(0.0, Float.min(1.0, (b * f - c * e) / denom));
                };
                
                t := (b * s + f) / e;
                
                if (t < 0.0) {
                    t := 0.0;
                    s := Float.max(0.0, Float.min(1.0, -c / a));
                } else if (t > 1.0) {
                    t := 1.0;
                    s := Float.max(0.0, Float.min(1.0, (b - c) / a));
                };
            };
        };
        
        let closestA = vectorAdd(a1, vectorScale(d1, s));
        let closestB = vectorAdd(b1, vectorScale(d2, t));
        (closestA, closestB)
    };
    
    // ═══════════════════════════════════════════════════════════════════════════════════════════
    // SECTION 24: SPATIAL HASHING AND ACCELERATION STRUCTURES
    // ═══════════════════════════════════════════════════════════════════════════════════════════
    
    // Spatial hash cell
    public type SpatialHashCell = {
        x : Int;
        y : Int;
        z : Int;
        entityIds : [Nat64];
    };
    
    // Spatial hash grid
    public type SpatialHashGrid = {
        cellSize : Float;
        cells : [(Int, Int, Int, [Nat64])];
        bounds : BoundingBox;
    };
    
    // Compute spatial hash key
    public func computeSpatialHashKey(position : Vector3, cellSize : Float) : (Int, Int, Int) {
        let x = Float.toInt(Float.floor(position.x / cellSize));
        let y = Float.toInt(Float.floor(position.y / cellSize));
        let z = Float.toInt(Float.floor(position.z / cellSize));
        (x, y, z)
    };
    
    // Octree node
    public type OctreeNode = {
        bounds : BoundingBox;
        children : ?[OctreeNode];
        entities : [Nat64];
        depth : Nat;
        isLeaf : Bool;
    };
    
    // BVH node
    public type BVHNode = {
        bounds : BoundingBox;
        leftChild : ?BVHNode;
        rightChild : ?BVHNode;
        entityId : ?Nat64;
        isLeaf : Bool;
    };
    
    // KD-tree node
    public type KDTreeNode = {
        point : Vector3;
        entityId : Nat64;
        splitAxis : Nat;
        leftChild : ?KDTreeNode;
        rightChild : ?KDTreeNode;
    };
    
    // Compute octree child index for point
    public func octreeChildIndex(point : Vector3, center : Vector3) : Nat {
        var index : Nat = 0;
        if (point.x >= center.x) { index += 1; };
        if (point.y >= center.y) { index += 2; };
        if (point.z >= center.z) { index += 4; };
        index
    };
    
    // Compute child bounds for octree
    public func octreeChildBounds(parentBounds : BoundingBox, childIndex : Nat) : BoundingBox {
        let center = {
            x = (parentBounds.min.x + parentBounds.max.x) / 2.0;
            y = (parentBounds.min.y + parentBounds.max.y) / 2.0;
            z = (parentBounds.min.z + parentBounds.max.z) / 2.0;
        };
        
        let minX = if (childIndex % 2 == 0) parentBounds.min.x else center.x;
        let maxX = if (childIndex % 2 == 0) center.x else parentBounds.max.x;
        let minY = if ((childIndex / 2) % 2 == 0) parentBounds.min.y else center.y;
        let maxY = if ((childIndex / 2) % 2 == 0) center.y else parentBounds.max.y;
        let minZ = if (childIndex / 4 == 0) parentBounds.min.z else center.z;
        let maxZ = if (childIndex / 4 == 0) center.z else parentBounds.max.z;
        
        { min = { x = minX; y = minY; z = minZ }; max = { x = maxX; y = maxY; z = maxZ } }
    };

    // ═══════════════════════════════════════════════════════════════════════════════════════════
    // SECTION 25: KALMAN FILTERING AND STATE ESTIMATION
    // ═══════════════════════════════════════════════════════════════════════════════════════════
    
    // Initialize Kalman filter for 6-DOF tracking
    public func initKalman6DOF() : KalmanState {
        // State: [x, y, z, vx, vy, vz, ax, ay, az]
        let stateSize = 9;
        let measurementSize = 3;
        
        {
            stateVector = Array.tabulate<Float>(stateSize, func(_ : Nat) : Float { 0.0 });
            covarianceMatrix = Array.tabulate<Float>(stateSize * stateSize, func(i : Nat) : Float {
                if (i / stateSize == i % stateSize) 1000.0 else 0.0
            });
            processNoise = Array.tabulate<Float>(stateSize * stateSize, func(i : Nat) : Float {
                if (i / stateSize == i % stateSize) 0.01 else 0.0
            });
            measurementNoise = Array.tabulate<Float>(measurementSize * measurementSize, func(i : Nat) : Float {
                if (i / measurementSize == i % measurementSize) 1.0 else 0.0
            });
            stateTransition = Array.tabulate<Float>(stateSize * stateSize, func(i : Nat) : Float {
                let row = i / stateSize;
                let col = i % stateSize;
                if (row == col) 1.0
                else if (col == row + 3 or col == row + 6) 1.0 // dt terms
                else 0.0
            });
            measurementMatrix = Array.tabulate<Float>(measurementSize * stateSize, func(i : Nat) : Float {
                let row = i / stateSize;
                let col = i % stateSize;
                if (row == col) 1.0 else 0.0
            });
            controlMatrix = [];
        }
    };
    
    // Kalman predict step
    public func kalmanPredict(state : KalmanState, dt : Float) : KalmanState {
        let n = 9; // State size
        
        // Update state transition matrix with dt
        let F = Array.tabulate<Float>(n * n, func(i : Nat) : Float {
            let row = i / n;
            let col = i % n;
            if (row == col) { 1.0 }
            else if (row < 3 and col == row + 3) { dt }
            else if (row < 3 and col == row + 6) { 0.5 * dt * dt }
            else if (row >= 3 and row < 6 and col == row + 3) { dt }
            else { 0.0 }
        });
        
        // Predicted state: x = F * x
        let predictedState = Array.tabulate<Float>(n, func(row : Nat) : Float {
            var sum : Float = 0.0;
            for (col in Iter.range(0, n - 1)) {
                sum += F[row * n + col] * state.stateVector[col];
            };
            sum
        });
        
        // Predicted covariance: P = F * P * F' + Q
        let FP = Array.tabulate<Float>(n * n, func(i : Nat) : Float {
            let row = i / n;
            let col = i % n;
            var sum : Float = 0.0;
            for (k in Iter.range(0, n - 1)) {
                sum += F[row * n + k] * state.covarianceMatrix[k * n + col];
            };
            sum
        });
        
        let predictedCov = Array.tabulate<Float>(n * n, func(i : Nat) : Float {
            let row = i / n;
            let col = i % n;
            var sum : Float = 0.0;
            for (k in Iter.range(0, n - 1)) {
                sum += FP[row * n + k] * F[col * n + k]; // F' transpose
            };
            sum + state.processNoise[i]
        });
        
        {
            stateVector = predictedState;
            covarianceMatrix = predictedCov;
            processNoise = state.processNoise;
            measurementNoise = state.measurementNoise;
            stateTransition = F;
            measurementMatrix = state.measurementMatrix;
            controlMatrix = state.controlMatrix;
        }
    };
    
    // Kalman update step
    public func kalmanUpdate(state : KalmanState, measurement : [Float]) : KalmanState {
        let n = 9; // State size
        let m = 3; // Measurement size
        
        let H = state.measurementMatrix;
        let R = state.measurementNoise;
        let P = state.covarianceMatrix;
        let x = state.stateVector;
        
        // Innovation: y = z - H * x
        let innovation = Array.tabulate<Float>(m, func(row : Nat) : Float {
            var sum : Float = 0.0;
            for (col in Iter.range(0, n - 1)) {
                sum += H[row * n + col] * x[col];
            };
            measurement[row] - sum
        });
        
        // Innovation covariance: S = H * P * H' + R
        let HP = Array.tabulate<Float>(m * n, func(i : Nat) : Float {
            let row = i / n;
            let col = i % n;
            var sum : Float = 0.0;
            for (k in Iter.range(0, n - 1)) {
                sum += H[row * n + k] * P[k * n + col];
            };
            sum
        });
        
        let S = Array.tabulate<Float>(m * m, func(i : Nat) : Float {
            let row = i / m;
            let col = i % m;
            var sum : Float = 0.0;
            for (k in Iter.range(0, n - 1)) {
                sum += HP[row * n + k] * H[col * n + k];
            };
            sum + R[i]
        });
        
        // Kalman gain: K = P * H' * S^-1
        let PHt = Array.tabulate<Float>(n * m, func(i : Nat) : Float {
            let row = i / m;
            let col = i % m;
            var sum : Float = 0.0;
            for (k in Iter.range(0, n - 1)) {
                sum += P[row * n + k] * H[col * n + k];
            };
            sum
        });
        
        // Simple 3x3 matrix inverse for S (measurement noise)
        let detS = S[0] * (S[4] * S[8] - S[5] * S[7]) -
                   S[1] * (S[3] * S[8] - S[5] * S[6]) +
                   S[2] * (S[3] * S[7] - S[4] * S[6]);
        
        let invS = if (Float.abs(detS) < 1e-10) {
            Array.tabulate<Float>(m * m, func(i : Nat) : Float {
                if (i / m == i % m) 1.0 else 0.0
            })
        } else {
            let invDet = 1.0 / detS;
            [
                (S[4] * S[8] - S[5] * S[7]) * invDet,
                (S[2] * S[7] - S[1] * S[8]) * invDet,
                (S[1] * S[5] - S[2] * S[4]) * invDet,
                (S[5] * S[6] - S[3] * S[8]) * invDet,
                (S[0] * S[8] - S[2] * S[6]) * invDet,
                (S[2] * S[3] - S[0] * S[5]) * invDet,
                (S[3] * S[7] - S[4] * S[6]) * invDet,
                (S[1] * S[6] - S[0] * S[7]) * invDet,
                (S[0] * S[4] - S[1] * S[3]) * invDet
            ]
        };
        
        let K = Array.tabulate<Float>(n * m, func(i : Nat) : Float {
            let row = i / m;
            let col = i % m;
            var sum : Float = 0.0;
            for (k in Iter.range(0, m - 1)) {
                sum += PHt[row * m + k] * invS[k * m + col];
            };
            sum
        });
        
        // Updated state: x = x + K * y
        let updatedState = Array.tabulate<Float>(n, func(row : Nat) : Float {
            var sum : Float = x[row];
            for (col in Iter.range(0, m - 1)) {
                sum += K[row * m + col] * innovation[col];
            };
            sum
        });
        
        // Updated covariance: P = (I - K * H) * P
        let KH = Array.tabulate<Float>(n * n, func(i : Nat) : Float {
            let row = i / n;
            let col = i % n;
            var sum : Float = 0.0;
            for (k in Iter.range(0, m - 1)) {
                sum += K[row * m + k] * H[k * n + col];
            };
            sum
        });
        
        let ImKH = Array.tabulate<Float>(n * n, func(i : Nat) : Float {
            let row = i / n;
            let col = i % n;
            let identity = if (row == col) 1.0 else 0.0;
            identity - KH[i]
        });
        
        let updatedCov = Array.tabulate<Float>(n * n, func(i : Nat) : Float {
            let row = i / n;
            let col = i % n;
            var sum : Float = 0.0;
            for (k in Iter.range(0, n - 1)) {
                sum += ImKH[row * n + k] * P[k * n + col];
            };
            sum
        });
        
        {
            stateVector = updatedState;
            covarianceMatrix = updatedCov;
            processNoise = state.processNoise;
            measurementNoise = state.measurementNoise;
            stateTransition = state.stateTransition;
            measurementMatrix = state.measurementMatrix;
            controlMatrix = state.controlMatrix;
        }
    };
    
    // ═══════════════════════════════════════════════════════════════════════════════════════════
    // SECTION 26: EXTENDED KALMAN FILTER
    // ═══════════════════════════════════════════════════════════════════════════════════════════
    
    // EKF state initialization
    public func initEKF(stateSize : Nat) : EKFState {
        {
            state = Array.tabulate<Float>(stateSize, func(_ : Nat) : Float { 0.0 });
            covariance = Array.tabulate<Float>(stateSize * stateSize, func(i : Nat) : Float {
                if (i / stateSize == i % stateSize) 100.0 else 0.0
            });
            jacobianF = Array.tabulate<Float>(stateSize * stateSize, func(i : Nat) : Float {
                if (i / stateSize == i % stateSize) 1.0 else 0.0
            });
            jacobianH = Array.tabulate<Float>(stateSize * stateSize, func(i : Nat) : Float {
                if (i / stateSize == i % stateSize) 1.0 else 0.0
            });
            processNoise = Array.tabulate<Float>(stateSize * stateSize, func(i : Nat) : Float {
                if (i / stateSize == i % stateSize) 0.01 else 0.0
            });
            measurementNoise = Array.tabulate<Float>(stateSize * stateSize, func(i : Nat) : Float {
                if (i / stateSize == i % stateSize) 1.0 else 0.0
            });
        }
    };
    
    // Compute numerical Jacobian
    public func computeNumericalJacobian(
        f : [Float] -> [Float],
        x : [Float],
        epsilon : Float
    ) : [Float] {
        let n = x.size();
        let fx = f(x);
        let m = fx.size();
        
        Array.tabulate<Float>(m * n, func(i : Nat) : Float {
            let row = i / n;
            let col = i % n;
            
            let xPlus = Array.tabulate<Float>(n, func(j : Nat) : Float {
                if (j == col) x[j] + epsilon else x[j]
            });
            let xMinus = Array.tabulate<Float>(n, func(j : Nat) : Float {
                if (j == col) x[j] - epsilon else x[j]
            });
            
            let fPlus = f(xPlus);
            let fMinus = f(xMinus);
            
            (fPlus[row] - fMinus[row]) / (2.0 * epsilon)
        })
    };
    
    // ═══════════════════════════════════════════════════════════════════════════════════════════
    // SECTION 27: UNSCENTED KALMAN FILTER
    // ═══════════════════════════════════════════════════════════════════════════════════════════
    
    // UKF parameters
    public func ukfParameters(n : Nat) : (Float, Float, Float) {
        let alpha : Float = 0.001;
        let beta : Float = 2.0;
        let kappa : Float = 0.0;
        (alpha, beta, kappa)
    };
    
    // Generate sigma points
    public func generateSigmaPoints(state : [Float], covariance : [Float], alpha : Float, kappa : Float) : [[Float]] {
        let n = state.size();
        let lambda = alpha * alpha * (Float.fromInt(n) + kappa) - Float.fromInt(n);
        let scaleFactor = Float.sqrt(Float.fromInt(n) + lambda);
        
        // Compute Cholesky decomposition of covariance (simplified)
        let L = Array.tabulate<Float>(n * n, func(i : Nat) : Float {
            let row = i / n;
            let col = i % n;
            if (row == col) {
                Float.sqrt(Float.max(covariance[i], 1e-10))
            } else if (row > col) {
                covariance[i] / Float.sqrt(Float.max(covariance[col * n + col], 1e-10))
            } else {
                0.0
            }
        });
        
        // Generate 2n+1 sigma points
        var sigmaPoints : [[Float]] = [];
        
        // First sigma point is the mean
        sigmaPoints := Array.append(sigmaPoints, [state]);
        
        // Generate positive sigma points
        for (i in Iter.range(0, n - 1)) {
            let point = Array.tabulate<Float>(n, func(j : Nat) : Float {
                state[j] + scaleFactor * L[j * n + i]
            });
            sigmaPoints := Array.append(sigmaPoints, [point]);
        };
        
        // Generate negative sigma points
        for (i in Iter.range(0, n - 1)) {
            let point = Array.tabulate<Float>(n, func(j : Nat) : Float {
                state[j] - scaleFactor * L[j * n + i]
            });
            sigmaPoints := Array.append(sigmaPoints, [point]);
        };
        
        sigmaPoints
    };
    
    // UKF weights
    public func ukfWeights(n : Nat, alpha : Float, beta : Float, kappa : Float) : ([Float], [Float]) {
        let lambda = alpha * alpha * (Float.fromInt(n) + kappa) - Float.fromInt(n);
        let w0m = lambda / (Float.fromInt(n) + lambda);
        let w0c = w0m + (1.0 - alpha * alpha + beta);
        let wi = 1.0 / (2.0 * (Float.fromInt(n) + lambda));
        
        let weightsMean = Array.tabulate<Float>(2 * n + 1, func(i : Nat) : Float {
            if (i == 0) w0m else wi
        });
        
        let weightsCov = Array.tabulate<Float>(2 * n + 1, func(i : Nat) : Float {
            if (i == 0) w0c else wi
        });
        
        (weightsMean, weightsCov)
    };
    
    // ═══════════════════════════════════════════════════════════════════════════════════════════
    // SECTION 28: PARTICLE FILTER
    // ═══════════════════════════════════════════════════════════════════════════════════════════
    
    // Initialize particle filter
    public func initParticleFilter(numParticles : Nat, stateDim : Nat, initialState : [Float], initialVariance : Float) : ParticleFilterState {
        // Create particles around initial state with some variance
        let particles = Array.tabulate<[Float]>(numParticles, func(i : Nat) : [Float] {
            Array.tabulate<Float>(stateDim, func(j : Nat) : Float {
                // Simple pseudo-random offset (would use proper RNG in production)
                let offset = Float.sin(Float.fromInt(i * stateDim + j) * 12.9898) * initialVariance;
                initialState[j] + offset
            })
        });
        
        let uniformWeight = 1.0 / Float.fromInt(numParticles);
        let weights = Array.tabulate<Float>(numParticles, func(_ : Nat) : Float { uniformWeight });
        
        {
            particles = particles;
            weights = weights;
            numParticles = numParticles;
            effectiveParticles = Float.fromInt(numParticles);
            resamplingThreshold = Float.fromInt(numParticles) / 2.0;
        }
    };
    
    // Compute effective sample size
    public func computeEffectiveSampleSize(weights : [Float]) : Float {
        var sumSq : Float = 0.0;
        for (w in weights.vals()) {
            sumSq += w * w;
        };
        if (sumSq < 1e-10) {
            return 0.0;
        };
        1.0 / sumSq
    };
    
    // Systematic resampling
    public func systematicResample(particles : [[Float]], weights : [Float]) : [[Float]] {
        let n = particles.size();
        if (n == 0) return particles;
        
        // Compute cumulative sum of weights
        var cumSum = Array.init<Float>(n, 0.0);
        var sum : Float = 0.0;
        for (i in Iter.range(0, n - 1)) {
            sum += weights[i];
            cumSum[i] := sum;
        };
        
        // Normalize cumulative sum
        for (i in Iter.range(0, n - 1)) {
            cumSum[i] := cumSum[i] / sum;
        };
        
        // Generate starting point
        let u0 = Float.sin(Float.fromInt(n) * 0.123456) * 0.5 + 0.5;
        let step = 1.0 / Float.fromInt(n);
        
        var newParticles : [[Float]] = [];
        var j : Nat = 0;
        
        for (i in Iter.range(0, n - 1)) {
            let u = (Float.fromInt(i) + u0) * step;
            while (j < n - 1 and cumSum[j] < u) {
                j += 1;
            };
            newParticles := Array.append(newParticles, [particles[j]]);
        };
        
        newParticles
    };
    
    // Particle filter predict step
    public func particleFilterPredict(
        state : ParticleFilterState,
        processModel : [Float] -> [Float],
        processNoise : Float
    ) : ParticleFilterState {
        let newParticles = Array.tabulate<[Float]>(state.numParticles, func(i : Nat) : [Float] {
            let predicted = processModel(state.particles[i]);
            Array.tabulate<Float>(predicted.size(), func(j : Nat) : Float {
                // Add process noise (simplified)
                let noise = Float.sin(Float.fromInt(i * predicted.size() + j) * 43758.5453) * processNoise;
                predicted[j] + noise
            })
        });
        
        {
            particles = newParticles;
            weights = state.weights;
            numParticles = state.numParticles;
            effectiveParticles = state.effectiveParticles;
            resamplingThreshold = state.resamplingThreshold;
        }
    };
    
    // Particle filter update step
    public func particleFilterUpdate(
        state : ParticleFilterState,
        measurement : [Float],
        measurementModel : [Float] -> [Float],
        measurementNoise : Float
    ) : ParticleFilterState {
        // Compute likelihood for each particle
        let likelihoods = Array.tabulate<Float>(state.numParticles, func(i : Nat) : Float {
            let predicted = measurementModel(state.particles[i]);
            var sqDist : Float = 0.0;
            for (j in Iter.range(0, measurement.size() - 1)) {
                let diff = measurement[j] - predicted[j];
                sqDist += diff * diff;
            };
            // Gaussian likelihood
            Float.exp(-sqDist / (2.0 * measurementNoise * measurementNoise))
        });
        
        // Compute normalization factor
        var sumLikelihood : Float = 0.0;
        for (l in likelihoods.vals()) {
            sumLikelihood += l;
        };
        
        // Update weights
        let newWeights = if (sumLikelihood < 1e-10) {
            // All weights too small, reinitialize uniformly
            Array.tabulate<Float>(state.numParticles, func(_ : Nat) : Float {
                1.0 / Float.fromInt(state.numParticles)
            })
        } else {
            Array.tabulate<Float>(state.numParticles, func(i : Nat) : Float {
                (state.weights[i] * likelihoods[i]) / sumLikelihood
            })
        };
        
        // Compute effective sample size
        let ess = computeEffectiveSampleSize(newWeights);
        
        // Resample if needed
        let (finalParticles, finalWeights) = if (ess < state.resamplingThreshold) {
            let resampled = systematicResample(state.particles, newWeights);
            let uniform = Array.tabulate<Float>(state.numParticles, func(_ : Nat) : Float {
                1.0 / Float.fromInt(state.numParticles)
            });
            (resampled, uniform)
        } else {
            (state.particles, newWeights)
        };
        
        {
            particles = finalParticles;
            weights = finalWeights;
            numParticles = state.numParticles;
            effectiveParticles = ess;
            resamplingThreshold = state.resamplingThreshold;
        }
    };
    
    // Get particle filter estimate (weighted mean)
    public func particleFilterEstimate(state : ParticleFilterState) : [Float] {
        if (state.numParticles == 0 or state.particles.size() == 0) {
            return [];
        };
        
        let stateDim = state.particles[0].size();
        Array.tabulate<Float>(stateDim, func(j : Nat) : Float {
            var sum : Float = 0.0;
            for (i in Iter.range(0, state.numParticles - 1)) {
                sum += state.weights[i] * state.particles[i][j];
            };
            sum
        })
    };
    
    // ═══════════════════════════════════════════════════════════════════════════════════════════
    // SECTION 29: TRACK MANAGEMENT AND DATA ASSOCIATION
    // ═══════════════════════════════════════════════════════════════════════════════════════════
    
    // Track status
    public type TrackStatus = {
        #TENTATIVE;
        #CONFIRMED;
        #COASTING;
        #DELETED;
    };
    
    // Full track structure
    public type Track = {
        id : Nat64;
        status : TrackStatus;
        state : [Float];
        covariance : [Float];
        kalman : KalmanState;
        classification : Text;
        classConfidence : Float;
        firstDetection : Nat64;
        lastDetection : Nat64;
        hits : Nat;
        misses : Nat;
        consecutiveMisses : Nat;
        sensorSources : [Nat64];
        history : [(Nat64, [Float])];
    };
    
    // Track manager state
    public type TrackManagerState = {
        tracks : [Track];
        nextTrackId : Nat64;
        confirmHits : Nat;
        deleteMisses : Nat;
        gatingThreshold : Float;
        maxTracks : Nat;
    };
    
    // Initialize track manager
    public func initTrackManager(maxTracks : Nat, confirmHits : Nat, deleteMisses : Nat) : TrackManagerState {
        {
            tracks = [];
            nextTrackId = 1;
            confirmHits = confirmHits;
            deleteMisses = deleteMisses;
            gatingThreshold = 9.21; // Chi-squared 99% confidence for 2 DOF
            maxTracks = maxTracks;
        }
    };
    
    // Mahalanobis distance for gating
    public func mahalanobisDistance(
        predicted : [Float],
        measurement : [Float],
        innovationCov : [Float]
    ) : Float {
        let n = predicted.size();
        if (n != measurement.size() or innovationCov.size() != n * n) {
            return Float.fromInt(Int.abs(-1)); // Return large value on error
        };
        
        // Innovation vector
        let innovation = Array.tabulate<Float>(n, func(i : Nat) : Float {
            measurement[i] - predicted[i]
        });
        
        // Simple inverse for 2x2 or 3x3 (for general case, use proper matrix inverse)
        if (n == 2) {
            let det = innovationCov[0] * innovationCov[3] - innovationCov[1] * innovationCov[2];
            if (Float.abs(det) < 1e-10) return 1e10;
            let invDet = 1.0 / det;
            let inv00 = innovationCov[3] * invDet;
            let inv01 = -innovationCov[1] * invDet;
            let inv10 = -innovationCov[2] * invDet;
            let inv11 = innovationCov[0] * invDet;
            
            return innovation[0] * (inv00 * innovation[0] + inv01 * innovation[1]) +
                   innovation[1] * (inv10 * innovation[0] + inv11 * innovation[1]);
        };
        
        // For larger dimensions, use identity approximation
        var sum : Float = 0.0;
        for (i in Iter.range(0, n - 1)) {
            let diagVar = innovationCov[i * n + i];
            if (diagVar > 1e-10) {
                sum += innovation[i] * innovation[i] / diagVar;
            };
        };
        sum
    };
    
    // Global Nearest Neighbor (GNN) data association
    public func gnnAssociation(
        tracks : [Track],
        measurements : [[Float]],
        gatingThreshold : Float
    ) : [(Nat, Nat, Float)] {
        var associations : [(Nat, Nat, Float)] = [];
        var usedMeasurements : [Bool] = Array.tabulate<Bool>(measurements.size(), func(_ : Nat) : Bool { false });
        
        // For each track, find best measurement within gate
        for (ti in Iter.range(0, tracks.size() - 1)) {
            let track = tracks[ti];
            var bestMeasIdx : ?Nat = null;
            var bestDist : Float = gatingThreshold;
            
            for (mi in Iter.range(0, measurements.size() - 1)) {
                if (not usedMeasurements[mi]) {
                    // Compute predicted measurement (first 3 components of state)
                    let predicted = Array.tabulate<Float>(measurements[mi].size(), func(i : Nat) : Float {
                        if (i < track.state.size()) track.state[i] else 0.0
                    });
                    
                    // Use identity covariance for simplicity
                    let identityCov = Array.tabulate<Float>(measurements[mi].size() * measurements[mi].size(), func(i : Nat) : Float {
                        if (i / measurements[mi].size() == i % measurements[mi].size()) 1.0 else 0.0
                    });
                    
                    let dist = mahalanobisDistance(predicted, measurements[mi], identityCov);
                    
                    if (dist < bestDist) {
                        bestDist := dist;
                        bestMeasIdx := ?mi;
                    };
                };
            };
            
            switch (bestMeasIdx) {
                case (?mi) {
                    associations := Array.append(associations, [(ti, mi, bestDist)]);
                    usedMeasurements := Array.tabulate<Bool>(measurements.size(), func(i : Nat) : Bool {
                        if (i == mi) true else usedMeasurements[i]
                    });
                };
                case null {};
            };
        };
        
        associations
    };
    
    // Joint Probabilistic Data Association (JPDA) - simplified
    public func jpdaWeights(
        track : Track,
        measurements : [[Float]],
        gatingThreshold : Float,
        detectionProb : Float,
        clutterDensity : Float
    ) : [Float] {
        let numMeas = measurements.size();
        if (numMeas == 0) return [];
        
        // Compute likelihoods for each measurement
        var likelihoods : [Float] = [];
        
        for (mi in Iter.range(0, numMeas - 1)) {
            let predicted = Array.tabulate<Float>(measurements[mi].size(), func(i : Nat) : Float {
                if (i < track.state.size()) track.state[i] else 0.0
            });
            
            let identityCov = Array.tabulate<Float>(measurements[mi].size() * measurements[mi].size(), func(i : Nat) : Float {
                if (i / measurements[mi].size() == i % measurements[mi].size()) 1.0 else 0.0
            });
            
            let dist = mahalanobisDistance(predicted, measurements[mi], identityCov);
            
            let likelihood = if (dist < gatingThreshold) {
                Float.exp(-0.5 * dist) / Float.sqrt(TAU)
            } else {
                0.0
            };
            
            likelihoods := Array.append(likelihoods, [likelihood]);
        };
        
        // Compute association probabilities
        var sumLikelihood : Float = clutterDensity * (1.0 - detectionProb);
        for (l in likelihoods.vals()) {
            sumLikelihood += detectionProb * l;
        };
        
        // Weight for no association
        let beta0 = clutterDensity * (1.0 - detectionProb) / sumLikelihood;
        
        // Weights for each measurement
        var weights = Array.tabulate<Float>(numMeas + 1, func(i : Nat) : Float {
            if (i == 0) {
                beta0
            } else {
                detectionProb * likelihoods[i - 1] / sumLikelihood
            }
        });
        
        weights
    };
    
    // ═══════════════════════════════════════════════════════════════════════════════════════════
    // SECTION 30: MULTI-HYPOTHESIS TRACKING
    // ═══════════════════════════════════════════════════════════════════════════════════════════
    
    // Hypothesis
    public type Hypothesis = {
        id : Nat64;
        trackAssociations : [(Nat64, Nat)]; // (trackId, measurementIdx)
        probability : Float;
        parent : ?Nat64;
        children : [Nat64];
        depth : Nat;
    };
    
    // MHT state
    public type MHTState = {
        hypotheses : [Hypothesis];
        nextHypothesisId : Nat64;
        maxHypotheses : Nat;
        pruneThreshold : Float;
        mergeThreshold : Float;
        scanDepth : Nat;
    };
    
    // Initialize MHT
    public func initMHT(maxHypotheses : Nat, pruneThreshold : Float, scanDepth : Nat) : MHTState {
        {
            hypotheses = [{
                id = 1;
                trackAssociations = [];
                probability = 1.0;
                parent = null;
                children = [];
                depth = 0;
            }];
            nextHypothesisId = 2;
            maxHypotheses = maxHypotheses;
            pruneThreshold = pruneThreshold;
            mergeThreshold = 0.01;
            scanDepth = scanDepth;
        }
    };
    
    // Generate child hypotheses for a measurement
    public func generateChildHypotheses(
        parent : Hypothesis,
        tracks : [Track],
        measurement : [Float],
        measurementIdx : Nat,
        nextId : Nat64
    ) : ([Hypothesis], Nat64) {
        var children : [Hypothesis] = [];
        var currentId = nextId;
        
        // Hypothesis: measurement is false alarm
        children := Array.append(children, [{
            id = currentId;
            trackAssociations = parent.trackAssociations;
            probability = parent.probability * 0.1; // False alarm probability
            parent = ?parent.id;
            children = [];
            depth = parent.depth + 1;
        }]);
        currentId += 1;
        
        // Hypotheses: measurement associated with each existing track
        for (ti in Iter.range(0, tracks.size() - 1)) {
            let track = tracks[ti];
            
            // Check if track already associated in parent hypothesis
            var alreadyAssociated = false;
            for ((trackId, _) in parent.trackAssociations.vals()) {
                if (trackId == track.id) {
                    alreadyAssociated := true;
                };
            };
            
            if (not alreadyAssociated) {
                // Compute association probability (simplified)
                let predicted = Array.tabulate<Float>(measurement.size(), func(i : Nat) : Float {
                    if (i < track.state.size()) track.state[i] else 0.0
                });
                var dist : Float = 0.0;
                for (i in Iter.range(0, measurement.size() - 1)) {
                    let diff = measurement[i] - predicted[i];
                    dist += diff * diff;
                };
                let likelihood = Float.exp(-dist / 2.0);
                
                children := Array.append(children, [{
                    id = currentId;
                    trackAssociations = Array.append(parent.trackAssociations, [(track.id, measurementIdx)]);
                    probability = parent.probability * likelihood * 0.9; // Detection probability
                    parent = ?parent.id;
                    children = [];
                    depth = parent.depth + 1;
                }]);
                currentId += 1;
            };
        };
        
        // Hypothesis: measurement starts new track
        children := Array.append(children, [{
            id = currentId;
            trackAssociations = Array.append(parent.trackAssociations, [(0, measurementIdx)]); // 0 = new track
            probability = parent.probability * 0.01; // New track probability
            parent = ?parent.id;
            children = [];
            depth = parent.depth + 1;
        }]);
        currentId += 1;
        
        (children, currentId)
    };
    
    // Prune low-probability hypotheses
    public func pruneHypotheses(hypotheses : [Hypothesis], threshold : Float) : [Hypothesis] {
        // Normalize probabilities
        var totalProb : Float = 0.0;
        for (h in hypotheses.vals()) {
            totalProb += h.probability;
        };
        
        let normalized = Array.map<Hypothesis, Hypothesis>(hypotheses, func(h : Hypothesis) : Hypothesis {
            {
                id = h.id;
                trackAssociations = h.trackAssociations;
                probability = if (totalProb > 1e-10) h.probability / totalProb else h.probability;
                parent = h.parent;
                children = h.children;
                depth = h.depth;
            }
        });
        
        // Filter low probability hypotheses
        Array.filter<Hypothesis>(normalized, func(h : Hypothesis) : Bool {
            h.probability >= threshold
        })
    };
    
    // Get best hypothesis
    public func getBestHypothesis(hypotheses : [Hypothesis]) : ?Hypothesis {
        if (hypotheses.size() == 0) return null;
        
        var best = hypotheses[0];
        for (h in hypotheses.vals()) {
            if (h.probability > best.probability) {
                best := h;
            };
        };
        ?best
    };
