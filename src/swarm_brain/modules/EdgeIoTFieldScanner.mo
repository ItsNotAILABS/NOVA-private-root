// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  INTELLECTUAL PROPERTY NOTICE                                                                             ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
// ║  Location:     Dallas, Texas, United States of America                                                    ║
// ║  Contact:      MedinaSITech@outlook.com                                                                   ║
// ║  Framework:    Medina Doctrine                                                                            ║
// ║                                                                                                           ║
// ║  LEGAL PROTECTION                                                                                         ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  This source code, including all algorithms, mathematical formulations, architectural designs,            ║
// ║  naming conventions, data structures, and conceptual frameworks contained herein, constitutes             ║
// ║  the exclusive intellectual property of Alfredo Medina Hernandez.                                        ║
// ║                                                                                                           ║
// ║  PROTECTED UNDER:                                                                                         ║
// ║  • United States Copyright Law (17 U.S.C. §§ 101-1332)                                                   ║
// ║  • Berne Convention for the Protection of Literary and Artistic Works                                     ║
// ║  • WIPO Copyright Treaty (WCT)                                                                            ║
// ║  • Trade Secret Law - Defend Trade Secrets Act (18 U.S.C. § 1836)                                        ║
// ║  • Economic Espionage Act (18 U.S.C. §§ 1831-1839)                                                       ║
// ║                                                                                                           ║
// ║  CONFIDENTIALITY: This code is CONFIDENTIAL and PROPRIETARY.                                             ║
// ║  ENCRYPTION: All transmissions must be encrypted.                                                         ║
// ║  ATTRIBUTION: Required for any use, reproduction, or derivative work.                                     ║
// ║                                                                                                           ║
// ║  Unauthorized access, use, reproduction, distribution, or creation of derivative works                    ║
// ║  is strictly prohibited and will be prosecuted to the fullest extent of applicable law.                  ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// ║                                                                                                           ║
// ║  EDGE IoT FIELD SCANNER — ENTERPRISE GRADE / PRODUCTION GRADE / DEFENSE GRADE                            ║
// ║  ALPHA CRITICAL MODE — OWN HUB INFRASTRUCTURE                                                            ║
// ║                                                                                                           ║
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// ┌─────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
// │                                                                                                             │
// │  ███████╗██████╗  ██████╗ ███████╗    ██╗ ██████╗ ████████╗                                                │
// │  ██╔════╝██╔══██╗██╔════╝ ██╔════╝    ██║██╔═══██╗╚══██╔══╝                                                │
// │  █████╗  ██║  ██║██║  ███╗█████╗      ██║██║   ██║   ██║                                                   │
// │  ██╔══╝  ██║  ██║██║   ██║██╔══╝      ██║██║   ██║   ██║                                                   │
// │  ███████╗██████╔╝╚██████╔╝███████╗    ██║╚██████╔╝   ██║                                                   │
// │  ╚══════╝╚═════╝  ╚═════╝ ╚══════╝    ╚═╝ ╚═════╝    ╚═╝                                                   │
// │                                                                                                             │
// │   FIELD SCANNER CORE — WITH AND WITHOUT IoT                                                                │
// │   "OWN HUB. OWN INFRASTRUCTURE. NOT ZEROS."                                                                │
// │                                                                                                             │
// └─────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// ║  PASSIVE MODE (NO IoT REQUIRED)                                                                           ║
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//   • Satellite geomagnetic data
//   • Ionosphere state monitoring
//   • Weather pattern analysis
//   • Terrain mapping
//   • Hydrology datasets
//   • OUTPUTS: Hotspot maps, drift maps, signal-risk maps
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// ║  ACTIVE MODE (IoT + EDGE)                                                                                 ║
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//   • Local magnetic field sensors
//   • RF spectrum analysis
//   • Conductivity probes
//   • Vibration sensors
//   • Thermal imaging
//   • Water quality probes
//   • OUTPUTS: Real-time anomaly detection, resilience scoring
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// ║  FUSION OUTPUTS                                                                                           ║
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//   • Coherence heatmap
//   • Interference likelihood
//   • Infrastructure stress forecast
//   • Route/zone trust index
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Int "mo:base/Int";
import Buffer "mo:base/Buffer";
import Text "mo:base/Text";
import Option "mo:base/Option";
import Time "mo:base/Time";

module {

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                    PHYSICAL CONSTANTS                                  ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public let PHI : Float = 1.6180339887498948482;
  public let PHI_SQUARED : Float = 2.6180339887498948482;
  public let PI : Float = 3.14159265358979323846;
  public let E : Float = 2.71828182845904523536;
  public let SCHUMANN : Float = 7.83;                    // Hz
  public let EARTH_MAGNETIC_FIELD : Float = 50000.0;     // nT average
  public let IONOSPHERE_BASE_HEIGHT : Float = 60000.0;   // meters
  
  // Sensor constants
  public let MAX_EDGE_DEVICES : Nat = 1024;
  public let MAX_PASSIVE_SOURCES : Nat = 64;
  public let SCAN_GRID_SIZE : Nat = 100;
  public let FUSION_UPDATE_INTERVAL : Nat = 10;          // Beats between fusion updates

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                    PASSIVE MODE — DATA SOURCES                         ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  /// Geomagnetic field data (satellite/ground station derived)
  public type GeomagneticData = {
    timestamp : Nat;
    location : { lat : Float; lon : Float };
    
    // Field components
    bx : Float;                    // X component (nT)
    by : Float;                    // Y component (nT)
    bz : Float;                    // Z component (nT)
    totalField : Float;            // Total field strength (nT)
    declination : Float;           // Declination angle (degrees)
    inclination : Float;           // Inclination angle (degrees)
    
    // Derived metrics
    horizontalIntensity : Float;   // Horizontal component
    verticalIntensity : Float;     // Vertical component
    
    // Anomaly detection
    anomalyScore : Float;          // [0, 1] deviation from expected
    driftRate : Float;             // nT/day
    
    // Quality
    dataQuality : Float;           // [0, 1]
    source : GeomagSource;
  };

  public type GeomagSource = {
    #Satellite;        // SWARM, GOES, etc.
    #GroundStation;    // Observatory data
    #Model;            // WMM, IGRF
    #Interpolated;     // Derived from multiple sources
  };

  /// Ionosphere state data
  public type IonosphereData = {
    timestamp : Nat;
    location : { lat : Float; lon : Float };
    
    // Layer states
    dLayerHeight : Float;          // km
    eLayerHeight : Float;          // km
    fLayerHeight : Float;          // km
    f2LayerHeight : Float;         // km
    
    // Electron density
    electronDensity : Float;       // electrons/m³
    totalElectronContent : Float;  // TEC units
    
    // Propagation effects
    foF2 : Float;                  // Critical frequency F2 layer
    hmF2 : Float;                  // Height of max density
    
    // Storm indicators
    stormLevel : StormLevel;
    scintillationIndex : Float;    // S4 index [0, 1]
    
    // Quality
    dataQuality : Float;
    source : IonosphereSource;
  };

  public type StormLevel = {
    #Quiet;
    #Unsettled;
    #MinorStorm;
    #MajorStorm;
    #Severe;
  };

  public type IonosphereSource = {
    #Ionosonde;
    #GPS;
    #Satellite;
    #Model;
  };

  /// Weather data
  public type WeatherData = {
    timestamp : Nat;
    location : { lat : Float; lon : Float };
    
    // Basic weather
    temperature : Float;           // Celsius
    humidity : Float;              // Percent
    pressure : Float;              // hPa
    windSpeed : Float;             // m/s
    windDirection : Float;         // degrees
    
    // Electromagnetic effects
    lightningActivity : Float;     // Strikes/hour in region
    cloudCover : Float;            // [0, 1]
    precipitation : Float;         // mm/hour
    
    // Derived
    conductivityIndex : Float;     // Atmospheric conductivity indicator
    staticChargeRisk : Float;      // [0, 1]
    
    dataQuality : Float;
    source : WeatherSource;
  };

  public type WeatherSource = {
    #Station;
    #Satellite;
    #Radar;
    #Model;
  };

  /// Terrain data
  public type TerrainData = {
    location : { lat : Float; lon : Float };
    
    // Elevation
    elevation : Float;             // meters
    slope : Float;                 // degrees
    aspect : Float;                // degrees (direction of slope)
    
    // Geology
    soilType : SoilType;
    rockType : RockType;
    conductivity : Float;          // Siemens/m (ground conductivity)
    permeability : Float;          // Magnetic permeability
    
    // Features
    vegetationDensity : Float;     // [0, 1]
    urbanDensity : Float;          // [0, 1]
    waterPresence : Float;         // [0, 1] nearby water bodies
    
    // Underground
    depthToWaterTable : Float;     // meters
    cavernPresence : Float;        // [0, 1] likelihood of caves/voids
    mineralContent : Float;        // Magnetic mineral indicator
    
    lastUpdate : Nat;
  };

  public type SoilType = {
    #Sand;
    #Clay;
    #Loam;
    #Peat;
    #Rock;
    #Mixed;
  };

  public type RockType = {
    #Igneous;
    #Sedimentary;
    #Metamorphic;
    #Basalt;
    #Granite;
    #Limestone;
    #Unknown;
  };

  /// Hydrology data
  public type HydrologyData = {
    timestamp : Nat;
    location : { lat : Float; lon : Float };
    
    // Surface water
    nearestRiver : ?{
      name : Text;
      distance : Float;            // km
      flowRate : Float;            // m³/s
      depth : Float;               // m
    };
    nearestLake : ?{
      name : Text;
      distance : Float;            // km
      surfaceArea : Float;         // km²
      maxDepth : Float;            // m
    };
    coastalDistance : Float;       // km to ocean (if applicable)
    
    // Groundwater
    aquiferDepth : Float;          // m
    aquiferType : AquiferType;
    groundwaterFlow : Float;       // m/day
    
    // Water quality
    salinity : Float;              // ppt
    mineralContent : Float;        // general mineral load indicator
    conductivity : Float;          // µS/cm
    
    // Karst/cenote features
    karstFeatures : Bool;
    cenotePresence : Bool;
    cenoteDistance : ?Float;       // km to nearest cenote
    
    dataQuality : Float;
  };

  public type AquiferType = {
    #Unconfined;
    #Confined;
    #SemiConfined;
    #Perched;
    #None;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                    ACTIVE MODE — IoT SENSORS                           ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  /// Edge device types
  public type EdgeDeviceType = {
    #MagneticSensor;      // Local magnetic field
    #RFScanner;           // RF spectrum analyzer
    #ConductivityProbe;   // Ground/water conductivity
    #VibrationSensor;     // Seismic/vibration
    #ThermalImager;       // Infrared thermal
    #WaterProbe;          // Water quality
    #AirQuality;          // Atmospheric
    #Acoustic;            // Sound/ultrasound
    #Electromagnetic;     // General EM field
    #HybridMulti;         // Multi-sensor device
  };

  /// Edge device registration
  public type EdgeDevice = {
    deviceId : Nat;
    deviceType : EdgeDeviceType;
    location : { lat : Float; lon : Float; alt : Float };
    
    // Status
    online : Bool;
    lastSeen : Nat;
    batteryLevel : Float;          // [0, 1]
    signalStrength : Float;        // [0, 1]
    
    // Capabilities
    sensorRange : Float;           // meters
    samplingRate : Float;          // Hz
    accuracy : Float;              // [0, 1]
    
    // Connection
    protocol : IoTProtocol;
    firmwareVersion : Text;
    
    // Data
    lastReading : ?SensorReading;
    readingCount : Nat;
    anomalyCount : Nat;
    
    // Registration
    registeredBeat : Nat;
    owner : Text;
  };

  public type IoTProtocol = {
    #MQTT;
    #HTTP;
    #CoAP;
    #LoRa;
    #ZigBee;
    #BLE;
    #Custom;
  };

  /// Sensor reading
  public type SensorReading = {
    timestamp : Nat;
    deviceId : Nat;
    deviceType : EdgeDeviceType;
    
    // Generic value fields
    primaryValue : Float;
    secondaryValue : ?Float;
    tertiaryValue : ?Float;
    
    // Contextual
    unit : Text;
    quality : Float;               // [0, 1]
    
    // Anomaly
    isAnomaly : Bool;
    anomalyScore : Float;          // [0, 1]
    expectedValue : ?Float;
    deviation : ?Float;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                    MAGNETIC FIELD SENSOR                               ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public type MagneticReading = {
    timestamp : Nat;
    deviceId : Nat;
    
    // Field components (local)
    bx : Float;                    // nT
    by : Float;
    bz : Float;
    totalField : Float;
    
    // Derived
    declination : Float;
    inclination : Float;
    
    // Comparison to expected
    expectedField : Float;
    deviation : Float;
    deviationPercent : Float;
    
    // Anomaly analysis
    anomalyScore : Float;          // [0, 1]
    anomalyType : ?MagneticAnomalyType;
    
    quality : Float;
  };

  public type MagneticAnomalyType = {
    #LocalInterference;    // Nearby electronics/metal
    #Underground;          // Underground structure
    #Geologic;             // Natural geological
    #Storm;                // Geomagnetic storm
    #Unknown;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                    RF SPECTRUM SENSOR                                  ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public type RFReading = {
    timestamp : Nat;
    deviceId : Nat;
    
    // Spectrum bands
    vlfPower : Float;              // Very Low Frequency (3-30 kHz)
    lfPower : Float;               // Low Frequency (30-300 kHz)
    mfPower : Float;               // Medium Frequency (300 kHz - 3 MHz)
    hfPower : Float;               // High Frequency (3-30 MHz)
    vhfPower : Float;              // VHF (30-300 MHz)
    uhfPower : Float;              // UHF (300 MHz - 3 GHz)
    
    // Detected signals
    detectedSignals : [RFSignal];
    
    // Noise floor
    noiseFloor : Float;            // dBm
    
    // Anomalies
    anomalyScore : Float;
    unexplainedSignals : Nat;
    
    quality : Float;
  };

  public type RFSignal = {
    frequency : Float;             // Hz
    power : Float;                 // dBm
    bandwidth : Float;             // Hz
    modulation : ?ModulationType;
    identified : Bool;
    source : ?Text;
  };

  public type ModulationType = {
    #AM;
    #FM;
    #PM;
    #FSK;
    #PSK;
    #QAM;
    #OFDM;
    #Spread;
    #Unknown;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                    CONDUCTIVITY PROBE                                  ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public type ConductivityReading = {
    timestamp : Nat;
    deviceId : Nat;
    
    // Measurements
    conductivity : Float;          // Siemens/m or µS/cm
    resistivity : Float;           // Ohm-m
    temperature : Float;           // Celsius (affects conductivity)
    
    // Corrected values
    temperatureCorrected : Float;  // Conductivity at 25°C
    
    // Type
    medium : ConductivityMedium;
    
    // Anomaly
    anomalyScore : Float;
    expectedConductivity : Float;
    
    quality : Float;
  };

  public type ConductivityMedium = {
    #Soil;
    #FreshWater;
    #SaltWater;
    #Rock;
    #Air;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                    VIBRATION SENSOR                                    ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public type VibrationReading = {
    timestamp : Nat;
    deviceId : Nat;
    
    // Accelerometer data
    ax : Float;                    // m/s²
    ay : Float;
    az : Float;
    
    // Derived
    peakAcceleration : Float;
    rmsVibration : Float;
    dominantFrequency : Float;     // Hz
    
    // Spectrum
    frequencyBands : [Float];      // Power in frequency bands
    
    // Classification
    vibrationType : VibrationType;
    
    // Anomaly
    anomalyScore : Float;
    
    quality : Float;
  };

  public type VibrationType = {
    #Ambient;              // Normal background
    #Seismic;              // Earthquake/geological
    #Traffic;              // Vehicle traffic
    #Industrial;           // Machinery
    #Construction;         // Building work
    #Unknown;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                    THERMAL SENSOR                                      ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public type ThermalReading = {
    timestamp : Nat;
    deviceId : Nat;
    
    // Temperature
    ambientTemp : Float;           // Celsius
    surfaceTemp : Float;           // Celsius (if measuring surface)
    
    // Thermal image (if available)
    hasImage : Bool;
    minTemp : Float;
    maxTemp : Float;
    avgTemp : Float;
    
    // Hotspot detection
    hotspotDetected : Bool;
    hotspotLocation : ?{ x : Float; y : Float };
    hotspotTemp : ?Float;
    
    // Cold spot detection
    coldspotDetected : Bool;
    coldspotTemp : ?Float;
    
    // Anomaly
    anomalyScore : Float;
    
    quality : Float;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                    WATER PROBE                                         ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  public type WaterProbeReading = {
    timestamp : Nat;
    deviceId : Nat;
    
    // Basic parameters
    temperature : Float;           // Celsius
    pH : Float;                    // pH units
    conductivity : Float;          // µS/cm
    turbidity : Float;             // NTU
    dissolvedOxygen : Float;       // mg/L
    
    // Salinity
    salinity : Float;              // ppt
    tds : Float;                   // Total dissolved solids mg/L
    
    // Additional (if sensor supports)
    orp : ?Float;                  // Oxidation-reduction potential mV
    ammonia : ?Float;              // mg/L
    nitrate : ?Float;              // mg/L
    
    // Anomaly
    anomalyScore : Float;
    
    quality : Float;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                    FUSION OUTPUTS — COHERENCE HEATMAP                  ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  /// Coherence heatmap cell
  public type CoherenceCell = {
    gridX : Nat;
    gridY : Nat;
    centerLat : Float;
    centerLon : Float;
    
    // Coherence score
    coherenceScore : Float;        // [0, 1] — 1 = high coherence
    
    // Components
    geomagCoherence : Float;       // From geomagnetic data
    ionosphereCoherence : Float;   // From ionosphere data
    environmentalCoherence : Float; // From weather/terrain
    sensorCoherence : Float;       // From IoT sensors (if available)
    
    // Confidence
    dataConfidence : Float;        // [0, 1]
    lastUpdate : Nat;
    
    // Sources used
    passiveSourceCount : Nat;
    activeSourceCount : Nat;
  };

  /// Full coherence heatmap
  public type CoherenceHeatmap = {
    gridSizeX : Nat;
    gridSizeY : Nat;
    bounds : {
      minLat : Float;
      maxLat : Float;
      minLon : Float;
      maxLon : Float;
    };
    
    cells : [[CoherenceCell]];     // 2D grid
    
    globalCoherence : Float;       // Average across all cells
    minCoherence : Float;
    maxCoherence : Float;
    
    lastUpdate : Nat;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                    FUSION OUTPUTS — INTERFERENCE MAP                   ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  /// Interference likelihood cell
  public type InterferenceCell = {
    gridX : Nat;
    gridY : Nat;
    centerLat : Float;
    centerLon : Float;
    
    // Interference probability
    interferenceLikelihood : Float; // [0, 1]
    
    // Types of interference
    electromagneticRisk : Float;
    geomagneticRisk : Float;
    ionosphericRisk : Float;
    atmosphericRisk : Float;
    humanMadeRisk : Float;
    
    // Peak risk times
    peakRiskHour : ?Nat;           // Hour of day with highest risk
    peakRiskSeason : ?Season;      // Season with highest risk
    
    dataConfidence : Float;
    lastUpdate : Nat;
  };

  public type Season = {
    #Spring;
    #Summer;
    #Fall;
    #Winter;
  };

  /// Interference likelihood map
  public type InterferenceMap = {
    gridSizeX : Nat;
    gridSizeY : Nat;
    bounds : {
      minLat : Float;
      maxLat : Float;
      minLon : Float;
      maxLon : Float;
    };
    
    cells : [[InterferenceCell]];
    
    globalInterferenceRisk : Float;
    
    lastUpdate : Nat;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                    FUSION OUTPUTS — INFRASTRUCTURE STRESS              ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  /// Infrastructure stress cell
  public type InfrastructureStressCell = {
    gridX : Nat;
    gridY : Nat;
    centerLat : Float;
    centerLon : Float;
    
    // Stress forecast
    currentStress : Float;         // [0, 1]
    forecastStress1h : Float;      // 1 hour forecast
    forecastStress6h : Float;      // 6 hour forecast
    forecastStress24h : Float;     // 24 hour forecast
    
    // Contributing factors
    geomagStress : Float;
    ionosphereStress : Float;
    weatherStress : Float;
    solarStress : Float;
    localStress : Float;           // From IoT sensors
    
    // Risk level
    riskLevel : StressRiskLevel;
    
    dataConfidence : Float;
    lastUpdate : Nat;
  };

  public type StressRiskLevel = {
    #Low;
    #Moderate;
    #Elevated;
    #High;
    #Critical;
  };

  /// Infrastructure stress forecast map
  public type InfrastructureStressMap = {
    gridSizeX : Nat;
    gridSizeY : Nat;
    bounds : {
      minLat : Float;
      maxLat : Float;
      minLon : Float;
      maxLon : Float;
    };
    
    cells : [[InfrastructureStressCell]];
    
    globalStressLevel : Float;
    criticalCells : Nat;           // Number of cells at Critical
    highCells : Nat;               // Number of cells at High
    
    lastUpdate : Nat;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                    FUSION OUTPUTS — ROUTE/ZONE TRUST                   ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  /// Zone trust assessment
  public type ZoneTrust = {
    zoneId : Nat;
    name : Text;
    bounds : {
      minLat : Float;
      maxLat : Float;
      minLon : Float;
      maxLon : Float;
    };
    
    // Trust index
    trustIndex : Float;            // [0, 1] — 1 = fully trusted
    
    // Components
    coherenceTrust : Float;        // From coherence analysis
    stabilityTrust : Float;        // Historical stability
    interferenceTrust : Float;     // Inverse of interference risk
    infrastructureTrust : Float;   // Infrastructure health
    sensorTrust : Float;           // IoT sensor coverage and quality
    
    // History
    trustHistory : [Float];        // Recent trust values
    trendDirection : TrustTrend;
    
    // Recommendation
    operationalStatus : ZoneOperationalStatus;
    
    lastUpdate : Nat;
  };

  public type TrustTrend = {
    #Improving;
    #Stable;
    #Degrading;
    #Volatile;
  };

  public type ZoneOperationalStatus = {
    #FullyOperational;
    #ReducedOperations;
    #CautionAdvised;
    #MinimalOperations;
    #AvoidIfPossible;
    #Prohibited;
  };

  /// Route trust assessment
  public type RouteTrust = {
    routeId : Nat;
    name : Text;
    waypoints : [{ lat : Float; lon : Float }];
    
    // Overall trust
    overallTrust : Float;          // [0, 1]
    
    // Segment trusts
    segmentTrusts : [Float];       // Trust for each segment
    
    // Weak points
    lowestTrustSegment : Nat;
    lowestTrustValue : Float;
    
    // Recommendation
    recommended : Bool;
    alternativeRoutes : [Nat];     // IDs of alternative routes
    
    lastUpdate : Nat;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                    FIELD SCANNER STATE                                 ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  /// Main state for Edge IoT Field Scanner
  public type FieldScannerState = {
    // Mode
    passiveModeActive : Bool;
    activeModeActive : Bool;
    hybridModeActive : Bool;
    
    // Passive data sources
    geomagData : [GeomagneticData];
    ionosphereData : [IonosphereData];
    weatherData : [WeatherData];
    terrainData : [TerrainData];
    hydrologyData : [HydrologyData];
    
    // Active IoT devices
    edgeDevices : [EdgeDevice];
    activeDeviceCount : Nat;
    totalReadings : Nat;
    
    // Fusion outputs
    coherenceHeatmap : ?CoherenceHeatmap;
    interferenceMap : ?InterferenceMap;
    stressMap : ?InfrastructureStressMap;
    zoneTrusts : [ZoneTrust];
    routeTrusts : [RouteTrust];
    
    // Metrics
    lastPassiveUpdate : Nat;
    lastActiveUpdate : Nat;
    lastFusionUpdate : Nat;
    
    // Anomalies detected
    passiveAnomalies : Nat;
    activeAnomalies : Nat;
    
    // Global scores
    globalCoherence : Float;
    globalInterferenceRisk : Float;
    globalInfrastructureStress : Float;
    globalTrust : Float;
    
    // Beat tracking
    currentBeat : Nat;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                    INITIALIZATION                                      ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  /// Initialize field scanner state
  public func initFieldScannerState() : FieldScannerState {
    {
      passiveModeActive = true;    // Passive always available
      activeModeActive = false;    // Active requires devices
      hybridModeActive = false;    // Hybrid requires both
      
      geomagData = [];
      ionosphereData = [];
      weatherData = [];
      terrainData = [];
      hydrologyData = [];
      
      edgeDevices = [];
      activeDeviceCount = 0;
      totalReadings = 0;
      
      coherenceHeatmap = null;
      interferenceMap = null;
      stressMap = null;
      zoneTrusts = [];
      routeTrusts = [];
      
      lastPassiveUpdate = 0;
      lastActiveUpdate = 0;
      lastFusionUpdate = 0;
      
      passiveAnomalies = 0;
      activeAnomalies = 0;
      
      globalCoherence = 1.0;
      globalInterferenceRisk = 0.0;
      globalInfrastructureStress = 0.0;
      globalTrust = 1.0;
      
      currentBeat = 0;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                    PASSIVE MODE OPERATIONS                             ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  /// Ingest geomagnetic data
  public func ingestGeomagData(
    state : FieldScannerState,
    data : GeomagneticData
  ) : FieldScannerState {
    let newData = Array.append(state.geomagData, [data]);
    let anomalyCount = if (data.anomalyScore > 0.5) {
      state.passiveAnomalies + 1
    } else {
      state.passiveAnomalies
    };
    
    {
      state with
      geomagData = newData;
      passiveAnomalies = anomalyCount;
    }
  };

  /// Ingest ionosphere data
  public func ingestIonosphereData(
    state : FieldScannerState,
    data : IonosphereData
  ) : FieldScannerState {
    let newData = Array.append(state.ionosphereData, [data]);
    {
      state with
      ionosphereData = newData;
    }
  };

  /// Ingest weather data
  public func ingestWeatherData(
    state : FieldScannerState,
    data : WeatherData
  ) : FieldScannerState {
    let newData = Array.append(state.weatherData, [data]);
    {
      state with
      weatherData = newData;
    }
  };

  /// Ingest terrain data
  public func ingestTerrainData(
    state : FieldScannerState,
    data : TerrainData
  ) : FieldScannerState {
    let newData = Array.append(state.terrainData, [data]);
    {
      state with
      terrainData = newData;
    }
  };

  /// Ingest hydrology data
  public func ingestHydrologyData(
    state : FieldScannerState,
    data : HydrologyData
  ) : FieldScannerState {
    let newData = Array.append(state.hydrologyData, [data]);
    {
      state with
      hydrologyData = newData;
    }
  };

  /// Generate hotspot map from passive data
  public func generateHotspotMap(
    state : FieldScannerState,
    gridSize : Nat,
    bounds : { minLat : Float; maxLat : Float; minLon : Float; maxLon : Float }
  ) : [[Float]] {
    // Create grid
    let grid = Array.tabulate<[Float]>(gridSize, func (i) {
      Array.tabulate<Float>(gridSize, func (j) {
        // Calculate center of this cell
        let latStep = (bounds.maxLat - bounds.minLat) / Float.fromInt(gridSize);
        let lonStep = (bounds.maxLon - bounds.minLon) / Float.fromInt(gridSize);
        let cellLat = bounds.minLat + latStep * Float.fromInt(i) + latStep / 2.0;
        let cellLon = bounds.minLon + lonStep * Float.fromInt(j) + lonStep / 2.0;
        
        // Find nearest geomag data and calculate hotspot score
        var hotspotScore = 0.0;
        for (data in state.geomagData.vals()) {
          let dist = Float.sqrt(
            (data.location.lat - cellLat) ** 2.0 + 
            (data.location.lon - cellLon) ** 2.0
          );
          if (dist < 1.0) {  // Within 1 degree
            hotspotScore := Float.max(hotspotScore, data.anomalyScore);
          };
        };
        
        hotspotScore
      })
    });
    
    grid
  };

  /// Generate drift map from passive data
  public func generateDriftMap(
    state : FieldScannerState,
    gridSize : Nat,
    bounds : { minLat : Float; maxLat : Float; minLon : Float; maxLon : Float }
  ) : [[Float]] {
    // Create grid
    let grid = Array.tabulate<[Float]>(gridSize, func (i) {
      Array.tabulate<Float>(gridSize, func (j) {
        let latStep = (bounds.maxLat - bounds.minLat) / Float.fromInt(gridSize);
        let lonStep = (bounds.maxLon - bounds.minLon) / Float.fromInt(gridSize);
        let cellLat = bounds.minLat + latStep * Float.fromInt(i) + latStep / 2.0;
        let cellLon = bounds.minLon + lonStep * Float.fromInt(j) + lonStep / 2.0;
        
        // Calculate drift from geomag data
        var driftRate = 0.0;
        for (data in state.geomagData.vals()) {
          let dist = Float.sqrt(
            (data.location.lat - cellLat) ** 2.0 + 
            (data.location.lon - cellLon) ** 2.0
          );
          if (dist < 1.0) {
            driftRate := driftRate + data.driftRate / (1.0 + dist);
          };
        };
        
        driftRate
      })
    });
    
    grid
  };

  /// Generate signal risk map
  public func generateSignalRiskMap(
    state : FieldScannerState,
    gridSize : Nat,
    bounds : { minLat : Float; maxLat : Float; minLon : Float; maxLon : Float }
  ) : [[Float]] {
    let grid = Array.tabulate<[Float]>(gridSize, func (i) {
      Array.tabulate<Float>(gridSize, func (j) {
        let latStep = (bounds.maxLat - bounds.minLat) / Float.fromInt(gridSize);
        let lonStep = (bounds.maxLon - bounds.minLon) / Float.fromInt(gridSize);
        let cellLat = bounds.minLat + latStep * Float.fromInt(i) + latStep / 2.0;
        let cellLon = bounds.minLon + lonStep * Float.fromInt(j) + lonStep / 2.0;
        
        // Calculate risk from ionosphere and weather data
        var riskScore = 0.0;
        
        // Ionosphere contribution
        for (data in state.ionosphereData.vals()) {
          let dist = Float.sqrt(
            (data.location.lat - cellLat) ** 2.0 + 
            (data.location.lon - cellLon) ** 2.0
          );
          if (dist < 2.0) {
            let stormRisk = switch (data.stormLevel) {
              case (#Quiet) { 0.1 };
              case (#Unsettled) { 0.3 };
              case (#MinorStorm) { 0.5 };
              case (#MajorStorm) { 0.7 };
              case (#Severe) { 0.95 };
            };
            riskScore := Float.max(riskScore, stormRisk * data.scintillationIndex);
          };
        };
        
        // Weather contribution
        for (data in state.weatherData.vals()) {
          let dist = Float.sqrt(
            (data.location.lat - cellLat) ** 2.0 + 
            (data.location.lon - cellLon) ** 2.0
          );
          if (dist < 1.0) {
            riskScore := riskScore + data.staticChargeRisk * 0.3;
          };
        };
        
        Float.min(1.0, riskScore)
      })
    });
    
    grid
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                    ACTIVE MODE OPERATIONS                              ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  /// Register edge device
  public func registerEdgeDevice(
    state : FieldScannerState,
    device : EdgeDevice
  ) : FieldScannerState {
    let newDevices = Array.append(state.edgeDevices, [device]);
    let activeCount = state.activeDeviceCount + (if (device.online) { 1 } else { 0 });
    
    {
      state with
      edgeDevices = newDevices;
      activeDeviceCount = activeCount;
      activeModeActive = activeCount > 0;
      hybridModeActive = state.passiveModeActive and activeCount > 0;
    }
  };

  /// Process sensor reading
  public func processSensorReading(
    state : FieldScannerState,
    reading : SensorReading
  ) : FieldScannerState {
    let anomalyCount = if (reading.isAnomaly) {
      state.activeAnomalies + 1
    } else {
      state.activeAnomalies
    };
    
    // Update the device's last reading
    let updatedDevices = Array.map<EdgeDevice, EdgeDevice>(state.edgeDevices, func (d) {
      if (d.deviceId == reading.deviceId) {
        {
          d with
          lastReading = ?reading;
          readingCount = d.readingCount + 1;
          anomalyCount = if (reading.isAnomaly) { d.anomalyCount + 1 } else { d.anomalyCount };
        }
      } else {
        d
      }
    });
    
    {
      state with
      edgeDevices = updatedDevices;
      totalReadings = state.totalReadings + 1;
      activeAnomalies = anomalyCount;
    }
  };

  /// Calculate real-time anomaly score
  public func calculateRealTimeAnomalyScore(readings : [SensorReading]) : Float {
    if (readings.size() == 0) { return 0.0 };
    
    var totalAnomaly = 0.0;
    for (reading in readings.vals()) {
      totalAnomaly := totalAnomaly + reading.anomalyScore;
    };
    
    totalAnomaly / Float.fromInt(readings.size())
  };

  /// Calculate resilience score
  public func calculateResilienceScore(
    state : FieldScannerState,
    zoneId : Nat
  ) : Float {
    // Resilience based on:
    // - Number of active sensors
    // - Data quality
    // - Coverage
    // - Historical stability
    
    let sensorCoverage = Float.fromInt(state.activeDeviceCount) / Float.fromInt(MAX_EDGE_DEVICES);
    let dataFreshness = if (state.currentBeat > state.lastActiveUpdate) {
      Float.max(0.0, 1.0 - Float.fromInt(state.currentBeat - state.lastActiveUpdate) / 100.0)
    } else {
      1.0
    };
    
    let anomalyPenalty = Float.fromInt(state.activeAnomalies) / Float.fromInt(Float.toInt(Float.max(1.0, Float.fromInt(state.totalReadings))));
    
    let resilience = (sensorCoverage * 0.3 + dataFreshness * 0.4 + (1.0 - anomalyPenalty) * 0.3);
    Float.max(0.0, Float.min(1.0, resilience))
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                    FUSION OPERATIONS                                   ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  /// Generate coherence heatmap (fusion of passive + active)
  public func generateCoherenceHeatmap(
    state : FieldScannerState,
    gridSize : Nat,
    bounds : { minLat : Float; maxLat : Float; minLon : Float; maxLon : Float },
    currentBeat : Nat
  ) : CoherenceHeatmap {
    let latStep = (bounds.maxLat - bounds.minLat) / Float.fromInt(gridSize);
    let lonStep = (bounds.maxLon - bounds.minLon) / Float.fromInt(gridSize);
    
    var minCoherence = 1.0;
    var maxCoherence = 0.0;
    var totalCoherence = 0.0;
    var cellCount = 0;
    
    let cells = Array.tabulate<[CoherenceCell]>(gridSize, func (i) {
      Array.tabulate<CoherenceCell>(gridSize, func (j) {
        let cellLat = bounds.minLat + latStep * Float.fromInt(i) + latStep / 2.0;
        let cellLon = bounds.minLon + lonStep * Float.fromInt(j) + lonStep / 2.0;
        
        // Calculate coherence components
        var geomagCoherence = 1.0;
        var passiveCount = 0;
        
        for (data in state.geomagData.vals()) {
          let dist = Float.sqrt(
            (data.location.lat - cellLat) ** 2.0 + 
            (data.location.lon - cellLon) ** 2.0
          );
          if (dist < 1.0) {
            geomagCoherence := geomagCoherence * (1.0 - data.anomalyScore * 0.5);
            passiveCount += 1;
          };
        };
        
        var ionosphereCoherence = 1.0;
        for (data in state.ionosphereData.vals()) {
          let dist = Float.sqrt(
            (data.location.lat - cellLat) ** 2.0 + 
            (data.location.lon - cellLon) ** 2.0
          );
          if (dist < 2.0) {
            let stormPenalty = switch (data.stormLevel) {
              case (#Quiet) { 0.0 };
              case (#Unsettled) { 0.1 };
              case (#MinorStorm) { 0.2 };
              case (#MajorStorm) { 0.4 };
              case (#Severe) { 0.6 };
            };
            ionosphereCoherence := ionosphereCoherence * (1.0 - stormPenalty);
            passiveCount += 1;
          };
        };
        
        var environmentalCoherence = 1.0;
        for (data in state.weatherData.vals()) {
          let dist = Float.sqrt(
            (data.location.lat - cellLat) ** 2.0 + 
            (data.location.lon - cellLon) ** 2.0
          );
          if (dist < 1.0) {
            environmentalCoherence := environmentalCoherence * (1.0 - data.staticChargeRisk * 0.3);
            passiveCount += 1;
          };
        };
        
        // Sensor coherence from IoT
        var sensorCoherence = 1.0;
        var activeCount = 0;
        for (device in state.edgeDevices.vals()) {
          let dist = Float.sqrt(
            (device.location.lat - cellLat) ** 2.0 + 
            (device.location.lon - cellLon) ** 2.0
          );
          if (dist < 0.5 and device.online) {
            switch (device.lastReading) {
              case (?reading) {
                sensorCoherence := sensorCoherence * (1.0 - reading.anomalyScore * 0.4);
              };
              case null { };
            };
            activeCount += 1;
          };
        };
        
        // Overall coherence
        let coherenceScore = (geomagCoherence * 0.3 + 
                             ionosphereCoherence * 0.25 + 
                             environmentalCoherence * 0.2 + 
                             sensorCoherence * 0.25);
        
        // Track min/max
        if (coherenceScore < minCoherence) { minCoherence := coherenceScore };
        if (coherenceScore > maxCoherence) { maxCoherence := coherenceScore };
        totalCoherence := totalCoherence + coherenceScore;
        cellCount += 1;
        
        // Data confidence
        let confidence = Float.min(1.0, Float.fromInt(passiveCount + activeCount) / 5.0);
        
        {
          gridX = i;
          gridY = j;
          centerLat = cellLat;
          centerLon = cellLon;
          coherenceScore = coherenceScore;
          geomagCoherence = geomagCoherence;
          ionosphereCoherence = ionosphereCoherence;
          environmentalCoherence = environmentalCoherence;
          sensorCoherence = sensorCoherence;
          dataConfidence = confidence;
          lastUpdate = currentBeat;
          passiveSourceCount = passiveCount;
          activeSourceCount = activeCount;
        }
      })
    });
    
    {
      gridSizeX = gridSize;
      gridSizeY = gridSize;
      bounds = bounds;
      cells = cells;
      globalCoherence = if (cellCount > 0) { totalCoherence / Float.fromInt(cellCount) } else { 1.0 };
      minCoherence = minCoherence;
      maxCoherence = maxCoherence;
      lastUpdate = currentBeat;
    }
  };

  /// Generate interference likelihood map
  public func generateInterferenceMap(
    state : FieldScannerState,
    gridSize : Nat,
    bounds : { minLat : Float; maxLat : Float; minLon : Float; maxLon : Float },
    currentBeat : Nat
  ) : InterferenceMap {
    let latStep = (bounds.maxLat - bounds.minLat) / Float.fromInt(gridSize);
    let lonStep = (bounds.maxLon - bounds.minLon) / Float.fromInt(gridSize);
    
    var totalRisk = 0.0;
    var cellCount = 0;
    
    let cells = Array.tabulate<[InterferenceCell]>(gridSize, func (i) {
      Array.tabulate<InterferenceCell>(gridSize, func (j) {
        let cellLat = bounds.minLat + latStep * Float.fromInt(i) + latStep / 2.0;
        let cellLon = bounds.minLon + lonStep * Float.fromInt(j) + lonStep / 2.0;
        
        // Calculate interference risks
        var emRisk = 0.1;  // Base EM risk
        var geomagRisk = 0.1;
        var ionoRisk = 0.1;
        var atmosRisk = 0.1;
        var humanRisk = 0.1;
        
        // From geomag data
        for (data in state.geomagData.vals()) {
          let dist = Float.sqrt(
            (data.location.lat - cellLat) ** 2.0 + 
            (data.location.lon - cellLon) ** 2.0
          );
          if (dist < 1.0) {
            geomagRisk := Float.max(geomagRisk, data.anomalyScore * 0.8);
            emRisk := Float.max(emRisk, data.anomalyScore * 0.5);
          };
        };
        
        // From ionosphere data
        for (data in state.ionosphereData.vals()) {
          let dist = Float.sqrt(
            (data.location.lat - cellLat) ** 2.0 + 
            (data.location.lon - cellLon) ** 2.0
          );
          if (dist < 2.0) {
            ionoRisk := Float.max(ionoRisk, data.scintillationIndex);
            let stormRisk = switch (data.stormLevel) {
              case (#Quiet) { 0.05 };
              case (#Unsettled) { 0.2 };
              case (#MinorStorm) { 0.4 };
              case (#MajorStorm) { 0.7 };
              case (#Severe) { 0.95 };
            };
            ionoRisk := Float.max(ionoRisk, stormRisk);
          };
        };
        
        // From weather data
        for (data in state.weatherData.vals()) {
          let dist = Float.sqrt(
            (data.location.lat - cellLat) ** 2.0 + 
            (data.location.lon - cellLon) ** 2.0
          );
          if (dist < 1.0) {
            atmosRisk := Float.max(atmosRisk, data.staticChargeRisk);
            atmosRisk := Float.max(atmosRisk, data.lightningActivity / 100.0);
          };
        };
        
        // From terrain data
        for (data in state.terrainData.vals()) {
          let dist = Float.sqrt(
            (data.location.lat - cellLat) ** 2.0 + 
            (data.location.lon - cellLon) ** 2.0
          );
          if (dist < 0.5) {
            humanRisk := Float.max(humanRisk, data.urbanDensity * 0.5);
          };
        };
        
        // Overall interference likelihood
        let interferenceLikelihood = (emRisk * 0.25 + geomagRisk * 0.2 + 
                                      ionoRisk * 0.25 + atmosRisk * 0.15 + 
                                      humanRisk * 0.15);
        
        totalRisk := totalRisk + interferenceLikelihood;
        cellCount += 1;
        
        {
          gridX = i;
          gridY = j;
          centerLat = cellLat;
          centerLon = cellLon;
          interferenceLikelihood = interferenceLikelihood;
          electromagneticRisk = emRisk;
          geomagneticRisk = geomagRisk;
          ionosphericRisk = ionoRisk;
          atmosphericRisk = atmosRisk;
          humanMadeRisk = humanRisk;
          peakRiskHour = null;
          peakRiskSeason = null;
          dataConfidence = 0.8;
          lastUpdate = currentBeat;
        }
      })
    });
    
    {
      gridSizeX = gridSize;
      gridSizeY = gridSize;
      bounds = bounds;
      cells = cells;
      globalInterferenceRisk = if (cellCount > 0) { totalRisk / Float.fromInt(cellCount) } else { 0.0 };
      lastUpdate = currentBeat;
    }
  };

  /// Generate infrastructure stress forecast
  public func generateStressMap(
    state : FieldScannerState,
    gridSize : Nat,
    bounds : { minLat : Float; maxLat : Float; minLon : Float; maxLon : Float },
    currentBeat : Nat
  ) : InfrastructureStressMap {
    let latStep = (bounds.maxLat - bounds.minLat) / Float.fromInt(gridSize);
    let lonStep = (bounds.maxLon - bounds.minLon) / Float.fromInt(gridSize);
    
    var totalStress = 0.0;
    var criticalCount = 0;
    var highCount = 0;
    var cellCount = 0;
    
    let cells = Array.tabulate<[InfrastructureStressCell]>(gridSize, func (i) {
      Array.tabulate<InfrastructureStressCell>(gridSize, func (j) {
        let cellLat = bounds.minLat + latStep * Float.fromInt(i) + latStep / 2.0;
        let cellLon = bounds.minLon + lonStep * Float.fromInt(j) + lonStep / 2.0;
        
        // Calculate stress components
        var geomagStress = 0.0;
        var ionoStress = 0.0;
        var weatherStress = 0.0;
        var solarStress = 0.2;  // Base solar stress
        var localStress = 0.0;
        
        for (data in state.geomagData.vals()) {
          let dist = Float.sqrt(
            (data.location.lat - cellLat) ** 2.0 + 
            (data.location.lon - cellLon) ** 2.0
          );
          if (dist < 1.0) {
            geomagStress := Float.max(geomagStress, 
              data.anomalyScore * 0.5 + Float.abs(data.driftRate) / 100.0);
          };
        };
        
        for (data in state.ionosphereData.vals()) {
          let dist = Float.sqrt(
            (data.location.lat - cellLat) ** 2.0 + 
            (data.location.lon - cellLon) ** 2.0
          );
          if (dist < 2.0) {
            let stormStress = switch (data.stormLevel) {
              case (#Quiet) { 0.0 };
              case (#Unsettled) { 0.15 };
              case (#MinorStorm) { 0.35 };
              case (#MajorStorm) { 0.6 };
              case (#Severe) { 0.9 };
            };
            ionoStress := Float.max(ionoStress, stormStress);
          };
        };
        
        for (data in state.weatherData.vals()) {
          let dist = Float.sqrt(
            (data.location.lat - cellLat) ** 2.0 + 
            (data.location.lon - cellLon) ** 2.0
          );
          if (dist < 1.0) {
            weatherStress := Float.max(weatherStress, 
              data.staticChargeRisk * 0.3 + data.lightningActivity / 200.0);
          };
        };
        
        // Local stress from IoT
        for (device in state.edgeDevices.vals()) {
          let dist = Float.sqrt(
            (device.location.lat - cellLat) ** 2.0 + 
            (device.location.lon - cellLon) ** 2.0
          );
          if (dist < 0.5 and device.online) {
            switch (device.lastReading) {
              case (?reading) {
                localStress := Float.max(localStress, reading.anomalyScore * 0.8);
              };
              case null { };
            };
          };
        };
        
        // Current stress
        let currentStress = (geomagStress * 0.25 + ionoStress * 0.25 + 
                            weatherStress * 0.2 + solarStress * 0.15 + 
                            localStress * 0.15);
        
        // Forecasts (simple linear projection)
        let forecast1h = Float.min(1.0, currentStress * 1.05);
        let forecast6h = Float.min(1.0, currentStress * 1.1);
        let forecast24h = Float.min(1.0, currentStress * 1.15);
        
        // Risk level
        let riskLevel : StressRiskLevel = if (currentStress > 0.8) {
          criticalCount += 1;
          #Critical
        } else if (currentStress > 0.6) {
          highCount += 1;
          #High
        } else if (currentStress > 0.4) {
          #Elevated
        } else if (currentStress > 0.2) {
          #Moderate
        } else {
          #Low
        };
        
        totalStress := totalStress + currentStress;
        cellCount += 1;
        
        {
          gridX = i;
          gridY = j;
          centerLat = cellLat;
          centerLon = cellLon;
          currentStress = currentStress;
          forecastStress1h = forecast1h;
          forecastStress6h = forecast6h;
          forecastStress24h = forecast24h;
          geomagStress = geomagStress;
          ionosphereStress = ionoStress;
          weatherStress = weatherStress;
          solarStress = solarStress;
          localStress = localStress;
          riskLevel = riskLevel;
          dataConfidence = 0.75;
          lastUpdate = currentBeat;
        }
      })
    });
    
    {
      gridSizeX = gridSize;
      gridSizeY = gridSize;
      bounds = bounds;
      cells = cells;
      globalStressLevel = if (cellCount > 0) { totalStress / Float.fromInt(cellCount) } else { 0.0 };
      criticalCells = criticalCount;
      highCells = highCount;
      lastUpdate = currentBeat;
    }
  };

  /// Calculate zone trust
  public func calculateZoneTrust(
    state : FieldScannerState,
    zone : { zoneId : Nat; name : Text; minLat : Float; maxLat : Float; minLon : Float; maxLon : Float },
    currentBeat : Nat
  ) : ZoneTrust {
    // Get data from coherence heatmap if available
    var coherenceTrust = 1.0;
    switch (state.coherenceHeatmap) {
      case (?heatmap) {
        var sum = 0.0;
        var count = 0;
        for (row in heatmap.cells.vals()) {
          for (cell in row.vals()) {
            if (cell.centerLat >= zone.minLat and cell.centerLat <= zone.maxLat and
                cell.centerLon >= zone.minLon and cell.centerLon <= zone.maxLon) {
              sum := sum + cell.coherenceScore;
              count += 1;
            };
          };
        };
        if (count > 0) {
          coherenceTrust := sum / Float.fromInt(count);
        };
      };
      case null { };
    };
    
    // Get interference trust
    var interferenceTrust = 1.0;
    switch (state.interferenceMap) {
      case (?imap) {
        var sum = 0.0;
        var count = 0;
        for (row in imap.cells.vals()) {
          for (cell in row.vals()) {
            if (cell.centerLat >= zone.minLat and cell.centerLat <= zone.maxLat and
                cell.centerLon >= zone.minLon and cell.centerLon <= zone.maxLon) {
              sum := sum + (1.0 - cell.interferenceLikelihood);
              count += 1;
            };
          };
        };
        if (count > 0) {
          interferenceTrust := sum / Float.fromInt(count);
        };
      };
      case null { };
    };
    
    // Get infrastructure trust
    var infrastructureTrust = 1.0;
    switch (state.stressMap) {
      case (?smap) {
        var sum = 0.0;
        var count = 0;
        for (row in smap.cells.vals()) {
          for (cell in row.vals()) {
            if (cell.centerLat >= zone.minLat and cell.centerLat <= zone.maxLat and
                cell.centerLon >= zone.minLon and cell.centerLon <= zone.maxLon) {
              sum := sum + (1.0 - cell.currentStress);
              count += 1;
            };
          };
        };
        if (count > 0) {
          infrastructureTrust := sum / Float.fromInt(count);
        };
      };
      case null { };
    };
    
    // Sensor trust from IoT coverage
    var sensorCount = 0;
    for (device in state.edgeDevices.vals()) {
      if (device.location.lat >= zone.minLat and device.location.lat <= zone.maxLat and
          device.location.lon >= zone.minLon and device.location.lon <= zone.maxLon and
          device.online) {
        sensorCount += 1;
      };
    };
    let sensorTrust = Float.min(1.0, Float.fromInt(sensorCount) / 10.0);
    
    // Stability trust (placeholder - would use historical data)
    let stabilityTrust = 0.8;
    
    // Overall trust
    let trustIndex = coherenceTrust * 0.25 + stabilityTrust * 0.2 + 
                     interferenceTrust * 0.2 + infrastructureTrust * 0.2 + 
                     sensorTrust * 0.15;
    
    // Operational status
    let status : ZoneOperationalStatus = if (trustIndex > 0.9) {
      #FullyOperational
    } else if (trustIndex > 0.75) {
      #ReducedOperations
    } else if (trustIndex > 0.6) {
      #CautionAdvised
    } else if (trustIndex > 0.4) {
      #MinimalOperations
    } else if (trustIndex > 0.2) {
      #AvoidIfPossible
    } else {
      #Prohibited
    };
    
    {
      zoneId = zone.zoneId;
      name = zone.name;
      bounds = {
        minLat = zone.minLat;
        maxLat = zone.maxLat;
        minLon = zone.minLon;
        maxLon = zone.maxLon;
      };
      trustIndex = trustIndex;
      coherenceTrust = coherenceTrust;
      stabilityTrust = stabilityTrust;
      interferenceTrust = interferenceTrust;
      infrastructureTrust = infrastructureTrust;
      sensorTrust = sensorTrust;
      trustHistory = [];
      trendDirection = #Stable;
      operationalStatus = status;
      lastUpdate = currentBeat;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                    MAIN TICK FUNCTION                                  ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  /// Main tick for field scanner
  public func tickFieldScanner(
    state : FieldScannerState,
    currentBeat : Nat
  ) : FieldScannerState {
    // Update device online status (devices not seen for 100 beats go offline)
    let updatedDevices = Array.map<EdgeDevice, EdgeDevice>(state.edgeDevices, func (d) {
      if (currentBeat > d.lastSeen + 100) {
        { d with online = false }
      } else {
        d
      }
    });
    
    let activeCount = Array.foldLeft<EdgeDevice, Nat>(updatedDevices, 0, func (acc, d) {
      if (d.online) { acc + 1 } else { acc }
    });
    
    // Update mode flags
    let passiveActive = state.geomagData.size() > 0 or state.ionosphereData.size() > 0;
    let activeActive = activeCount > 0;
    let hybridActive = passiveActive and activeActive;
    
    // Update global scores
    let globalCoherence = switch (state.coherenceHeatmap) {
      case (?h) { h.globalCoherence };
      case null { state.globalCoherence };
    };
    
    let globalInterference = switch (state.interferenceMap) {
      case (?m) { m.globalInterferenceRisk };
      case null { state.globalInterferenceRisk };
    };
    
    let globalStress = switch (state.stressMap) {
      case (?m) { m.globalStressLevel };
      case null { state.globalInfrastructureStress };
    };
    
    let globalTrust = (globalCoherence * 0.4 + (1.0 - globalInterference) * 0.3 + (1.0 - globalStress) * 0.3);
    
    {
      state with
      edgeDevices = updatedDevices;
      activeDeviceCount = activeCount;
      passiveModeActive = passiveActive;
      activeModeActive = activeActive;
      hybridModeActive = hybridActive;
      globalCoherence = globalCoherence;
      globalInterferenceRisk = globalInterference;
      globalInfrastructureStress = globalStress;
      globalTrust = globalTrust;
      currentBeat = currentBeat;
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                    QUERY FUNCTIONS                                     ║
  // ╚════════════════════════════════════════════════════════════════════════╝

  /// Get field scanner summary
  public func getFieldScannerSummary(state : FieldScannerState) : {
    passiveMode : Bool;
    activeMode : Bool;
    hybridMode : Bool;
    activeDevices : Nat;
    totalReadings : Nat;
    passiveAnomalies : Nat;
    activeAnomalies : Nat;
    globalCoherence : Float;
    globalInterferenceRisk : Float;
    globalInfrastructureStress : Float;
    globalTrust : Float;
  } {
    {
      passiveMode = state.passiveModeActive;
      activeMode = state.activeModeActive;
      hybridMode = state.hybridModeActive;
      activeDevices = state.activeDeviceCount;
      totalReadings = state.totalReadings;
      passiveAnomalies = state.passiveAnomalies;
      activeAnomalies = state.activeAnomalies;
      globalCoherence = state.globalCoherence;
      globalInterferenceRisk = state.globalInterferenceRisk;
      globalInfrastructureStress = state.globalInfrastructureStress;
      globalTrust = state.globalTrust;
    }
  };

}
