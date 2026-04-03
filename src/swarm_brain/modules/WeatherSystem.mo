// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Module: WeatherSystem — Real Atmospheric Physics & Weather Simulation
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
// Version: 100.0 — PRODUCTION ENTERPRISE GRADE
// 
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔══════════════════════════════════════════════════════════════════════════╗
// ║                    WEATHER SYSTEM — REAL ATMOSPHERIC PHYSICS             ║
// ╠══════════════════════════════════════════════════════════════════════════╣
// ║                                                                          ║
// ║  REAL weather simulation. Not random. PHYSICS-BASED.                     ║
// ║                                                                          ║
// ║  ATMOSPHERIC LAYERS:                                                     ║
// ║    Troposphere: 0-12km (where weather happens)                           ║
// ║    Stratosphere: 12-50km                                                 ║
// ║                                                                          ║
// ║  PRESSURE SYSTEMS:                                                       ║
// ║    - High pressure → clear skies, stable                                 ║
// ║    - Low pressure → clouds, precipitation                                ║
// ║    - Fronts: cold, warm, occluded                                        ║
// ║                                                                          ║
// ║  WIND:                                                                   ║
// ║    - Pressure gradient force                                             ║
// ║    - Coriolis effect                                                     ║
// ║    - Terrain effects (channeling, turbulence)                            ║
// ║                                                                          ║
// ║  PRECIPITATION:                                                          ║
// ║    - Rain, snow, hail, sleet                                             ║
// ║    - Based on temperature, humidity, dew point                           ║
// ║                                                                          ║
// ╚══════════════════════════════════════════════════════════════════════════╝
// ============================================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Int   "mo:base/Int";
import Buffer "mo:base/Buffer";

module {

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     CONSTANTS                                          ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  // Temperature conversion
  public let KELVIN_OFFSET : Float = 273.15;
  
  // Standard atmosphere
  public let SEA_LEVEL_PRESSURE : Float = 101325.0;  // Pa
  public let SEA_LEVEL_TEMP : Float = 288.15;        // K (15°C)
  public let LAPSE_RATE : Float = 0.0065;            // K/m
  
  // Gas constants
  public let R_DRY : Float = 287.05;                 // J/(kg·K) dry air
  public let R_VAPOR : Float = 461.5;                // J/(kg·K) water vapor
  
  public let π : Float = 3.1415926535897932385;

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     VECTOR TYPE                                        ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type Vector3 = { x : Float; y : Float; z : Float };
  
  public let ZERO : Vector3 = { x = 0.0; y = 0.0; z = 0.0 };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     WEATHER TYPES                                      ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type WeatherCondition = {
    #Clear;
    #PartlyCloudy;
    #Cloudy;
    #Overcast;
    #Fog;
    #Mist;
    #LightRain;
    #ModerateRain;
    #HeavyRain;
    #Thunderstorm;
    #LightSnow;
    #ModerateSnow;
    #HeavySnow;
    #Blizzard;
    #Hail;
    #Sleet;
    #FreezingRain;
    #Dust;
    #Sandstorm;
  };
  
  public type CloudType = {
    #None;
    #Cirrus;          // High, thin
    #Cirrostratus;    // High, sheet
    #Cirrocumulus;    // High, patchy
    #Altostratus;     // Mid-level, gray
    #Altocumulus;     // Mid-level, puffy
    #Stratus;         // Low, uniform
    #Stratocumulus;   // Low, lumpy
    #Cumulus;         // Fair weather puffy
    #Cumulonimbus;    // Thunderstorm
    #Nimbostratus;    // Rain clouds
  };
  
  public type PrecipitationType = {
    #None;
    #Rain;
    #Snow;
    #Sleet;
    #Hail;
    #FreezingRain;
    #Drizzle;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     ATMOSPHERIC STATE                                  ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type AtmosphericState = {
    // Temperature
    temperature : Float;          // Kelvin
    dewPoint : Float;             // Kelvin
    
    // Pressure
    pressure : Float;             // Pascals
    pressureTendency : Float;     // Pa/hour (+ rising, - falling)
    
    // Humidity
    relativeHumidity : Float;     // [0, 1]
    absoluteHumidity : Float;     // kg/m³
    
    // Wind
    windSpeed : Float;            // m/s
    windDirection : Float;        // degrees (0 = N, 90 = E)
    gustSpeed : Float;            // m/s
    windVector : Vector3;
    
    // Visibility
    visibility : Float;           // meters
    
    // Clouds
    cloudCover : Float;           // [0, 1]
    cloudBase : Float;            // meters AGL
    cloudTop : Float;             // meters AGL
    cloudType : CloudType;
    
    // Precipitation
    precipitation : PrecipitationType;
    precipRate : Float;           // mm/hour
    
    // Overall
    condition : WeatherCondition;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     PRESSURE SYSTEM                                    ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type PressureSystem = {
    id : Nat32;
    center : (Float, Float);      // (x, z) position
    pressure : Float;             // Central pressure (Pa)
    radius : Float;               // meters
    isHigh : Bool;                // true = high, false = low
    movementVector : (Float, Float);  // Movement per hour
    intensity : Float;            // [0, 1]
  };
  
  public type Front = {
    id : Nat32;
    frontType : FrontType;
    startPos : (Float, Float);
    endPos : (Float, Float);
    movementSpeed : Float;        // m/s
    movementDirection : Float;    // degrees
    intensity : Float;
  };
  
  public type FrontType = {
    #Cold;
    #Warm;
    #Stationary;
    #Occluded;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     ATMOSPHERIC CALCULATIONS                           ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// Calculate pressure at altitude (barometric formula)
  public func pressureAtAltitude(seaLevelPressure: Float, altitude: Float) : Float {
    // P = P0 × (1 - L×h/T0)^(g×M/(R×L))
    let g = 9.80665;
    let M = 0.0289644;  // Molar mass of air
    let R = 8.31447;    // Gas constant
    
    let exponent = g * M / (R * LAPSE_RATE);
    seaLevelPressure * Float.pow(1.0 - LAPSE_RATE * altitude / SEA_LEVEL_TEMP, exponent)
  };
  
  /// Calculate temperature at altitude
  public func temperatureAtAltitude(seaLevelTemp: Float, altitude: Float) : Float {
    seaLevelTemp - LAPSE_RATE * altitude
  };
  
  /// Calculate air density
  public func airDensity(pressure: Float, temperature: Float) : Float {
    // ρ = p / (R × T)
    pressure / (R_DRY * temperature)
  };
  
  /// Calculate dew point from temperature and humidity
  public func calculateDewPoint(temperature: Float, relativeHumidity: Float) : Float {
    // Magnus formula (approximation)
    let a = 17.27;
    let b = 237.7;
    let tempC = temperature - KELVIN_OFFSET;
    
    let alpha = a * tempC / (b + tempC) + Float.log(relativeHumidity);
    b * alpha / (a - alpha) + KELVIN_OFFSET
  };
  
  /// Calculate relative humidity from temperature and dew point
  public func calculateRelativeHumidity(temperature: Float, dewPoint: Float) : Float {
    // RH = exp((17.27 × Td)/(237.7 + Td)) / exp((17.27 × T)/(237.7 + T))
    let tempC = temperature - KELVIN_OFFSET;
    let dewC = dewPoint - KELVIN_OFFSET;
    
    Float.exp(17.27 * dewC / (237.7 + dewC)) / Float.exp(17.27 * tempC / (237.7 + tempC))
  };
  
  /// Calculate wind chill (feels-like temperature)
  public func windChill(temperature: Float, windSpeed: Float) : Float {
    let tempC = temperature - KELVIN_OFFSET;
    let windKmh = windSpeed * 3.6;
    
    if (tempC > 10.0 or windKmh < 4.8) {
      return temperature
    };
    
    // Wind chill formula
    let wc = 13.12 + 0.6215 * tempC - 11.37 * Float.pow(windKmh, 0.16) + 
             0.3965 * tempC * Float.pow(windKmh, 0.16);
    wc + KELVIN_OFFSET
  };
  
  /// Calculate heat index
  public func heatIndex(temperature: Float, relativeHumidity: Float) : Float {
    let tempF = (temperature - KELVIN_OFFSET) * 9.0 / 5.0 + 32.0;
    let rh = relativeHumidity * 100.0;
    
    if (tempF < 80.0) { return temperature };
    
    // Rothfusz regression
    var hi = -42.379 + 2.04901523 * tempF + 10.14333127 * rh - 
             0.22475541 * tempF * rh - 0.00683783 * tempF * tempF - 
             0.05481717 * rh * rh + 0.00122874 * tempF * tempF * rh + 
             0.00085282 * tempF * rh * rh - 0.00000199 * tempF * tempF * rh * rh;
    
    (hi - 32.0) * 5.0 / 9.0 + KELVIN_OFFSET
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     WIND CALCULATIONS                                  ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// Calculate wind from pressure gradient
  public func pressureGradientWind(
    pressure1: Float, pressure2: Float,
    distance: Float, latitude: Float
  ) : Float {
    // Wind speed ∝ pressure gradient
    let gradient = Float.abs(pressure1 - pressure2) / distance;
    
    // Coriolis parameter
    let omega = 7.2921e-5;  // Earth's angular velocity
    let f = 2.0 * omega * Float.sin(latitude * π / 180.0);
    
    // Geostrophic wind (simplified)
    if (Float.abs(f) < 0.0001) { return 0.0 };
    gradient / (1.225 * Float.abs(f))
  };
  
  /// Apply terrain effects to wind
  public func terrainWindEffect(
    windSpeed: Float,
    windDirection: Float,
    terrainHeight: Float,
    terrainRoughness: Float
  ) : (Float, Float) {
    // Higher terrain increases wind
    let heightFactor = 1.0 + terrainHeight / 1000.0 * 0.1;
    
    // Roughness reduces wind and adds turbulence
    let roughnessFactor = 1.0 - terrainRoughness * 0.3;
    
    let newSpeed = windSpeed * heightFactor * roughnessFactor;
    
    // Add some directional variation near rough terrain
    let dirVariation = terrainRoughness * 15.0;
    let newDirection = windDirection + dirVariation * Float.sin(windSpeed);
    
    (newSpeed, newDirection)
  };
  
  /// Convert wind direction and speed to vector
  public func windToVector(speed: Float, direction: Float) : Vector3 {
    let rad = direction * π / 180.0;
    {
      x = speed * Float.sin(rad);
      y = 0.0;
      z = speed * Float.cos(rad);
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     PRECIPITATION                                      ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// Determine precipitation type based on temperature profile
  public func determinePrecipType(
    surfaceTemp: Float,
    cloudTemp: Float,
    wetBulbTemp: Float
  ) : PrecipitationType {
    let surfaceC = surfaceTemp - KELVIN_OFFSET;
    let cloudC = cloudTemp - KELVIN_OFFSET;
    let wetBulbC = wetBulbTemp - KELVIN_OFFSET;
    
    // If cloud too warm, no precip (not cold enough for condensation)
    if (cloudC > 0.0) { return #Rain };
    
    // Surface temperature determines type
    if (surfaceC > 5.0) {
      #Rain
    } else if (surfaceC > 2.0) {
      // Marginal zone
      if (wetBulbC > 1.0) { #Rain } else { #Sleet }
    } else if (surfaceC > -2.0) {
      // Potential freezing rain
      if (wetBulbC > 0.0) { #FreezingRain } else { #Sleet }
    } else {
      // Cold enough for snow
      #Snow
    }
  };
  
  /// Calculate precipitation rate from humidity and lift
  public func calculatePrecipRate(
    humidity: Float,
    verticalVelocity: Float,  // Upward motion (m/s)
    temperature: Float
  ) : Float {
    if (humidity < 0.7 or verticalVelocity < 0.0) {
      return 0.0
    };
    
    // Simplified: more lift + more humidity = more precip
    let moistureAvailable = humidity - 0.7;  // Excess above 70%
    let liftFactor = Float.min(5.0, verticalVelocity);
    
    // Temperature affects efficiency
    let tempC = temperature - KELVIN_OFFSET;
    let efficiency = if (tempC < 0.0) { 0.8 } else { 1.0 };
    
    moistureAvailable * liftFactor * 10.0 * efficiency  // mm/hour
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     CLOUD FORMATION                                    ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// Determine cloud type from atmospheric conditions
  public func determineCloudType(
    cloudBase: Float,
    humidity: Float,
    verticalMotion: Float,
    stability: Float
  ) : CloudType {
    if (humidity < 0.5) { return #None };
    
    // Cloud altitude categories
    let isHigh = cloudBase > 6000.0;
    let isMid = cloudBase > 2000.0 and cloudBase <= 6000.0;
    let isLow = cloudBase <= 2000.0;
    
    // Vertical motion categories
    let isConvective = verticalMotion > 2.0;
    let isStable = stability > 0.5;
    
    if (isHigh) {
      if (humidity > 0.8) { #Cirrostratus }
      else if (isConvective) { #Cirrocumulus }
      else { #Cirrus }
    } else if (isMid) {
      if (humidity > 0.9) { #Altostratus }
      else { #Altocumulus }
    } else {
      // Low clouds
      if (isConvective and humidity > 0.9) { #Cumulonimbus }
      else if (isConvective) { #Cumulus }
      else if (humidity > 0.9) { #Nimbostratus }
      else if (isStable) { #Stratus }
      else { #Stratocumulus }
    }
  };
  
  /// Calculate cloud base height (lifting condensation level)
  public func calculateCloudBase(temperature: Float, dewPoint: Float) : Float {
    // LCL ≈ 125 × (T - Td) meters
    let spread = (temperature - dewPoint);
    125.0 * spread
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     WEATHER SYSTEM STATE                               ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type WeatherSystem = {
    // Current conditions at ground level
    atmosphere : AtmosphericState;
    
    // Pressure systems
    pressureSystems : [PressureSystem];
    fronts : [Front];
    
    // Time
    simulationTime : Float;       // seconds
    dayOfYear : Nat;              // 1-365
    hourOfDay : Float;            // 0-24
    
    // Season
    season : Season;
    
    // Global settings
    latitude : Float;             // degrees
    longitude : Float;
  };
  
  public type Season = {
    #Spring;
    #Summer;
    #Autumn;
    #Winter;
  };
  
  /// Get season from day of year (northern hemisphere)
  public func getSeason(dayOfYear: Nat) : Season {
    if (dayOfYear >= 80 and dayOfYear < 172) { #Spring }
    else if (dayOfYear >= 172 and dayOfYear < 266) { #Summer }
    else if (dayOfYear >= 266 and dayOfYear < 355) { #Autumn }
    else { #Winter }
  };
  
  /// Get base temperature for season and latitude
  public func seasonalBaseTemp(season: Season, latitude: Float) : Float {
    let latFactor = (90.0 - Float.abs(latitude)) / 90.0;  // 0 at poles, 1 at equator
    
    let baseC = switch (season) {
      case (#Spring) { 15.0 };
      case (#Summer) { 25.0 };
      case (#Autumn) { 15.0 };
      case (#Winter) { 5.0 };
    };
    
    // Adjust for latitude (colder at higher latitudes)
    let adjustedC = baseC * (0.5 + 0.5 * latFactor);
    adjustedC + KELVIN_OFFSET
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     WEATHER UPDATE                                     ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// Update weather system
  public func updateWeather(weather: WeatherSystem, dt: Float) : WeatherSystem {
    let newTime = weather.simulationTime + dt;
    let newHour = weather.hourOfDay + dt / 3600.0;
    let hourWrapped = if (newHour >= 24.0) { newHour - 24.0 } else { newHour };
    let newDay = if (newHour >= 24.0) { weather.dayOfYear + 1 } else { weather.dayOfYear };
    let dayWrapped = if (newDay > 365) { 1 } else { newDay };
    
    // Diurnal temperature variation
    let hourAngle = (hourWrapped - 14.0) * π / 12.0;  // Peak at 2 PM
    let diurnalVar = Float.cos(hourAngle) * 5.0;  // ±5°C variation
    
    let baseTemp = seasonalBaseTemp(weather.season, weather.latitude);
    let newTemp = baseTemp + diurnalVar;
    
    // Update pressure systems (move them)
    let newPressureSystems = Array.map<PressureSystem, PressureSystem>(
      weather.pressureSystems,
      func(sys) {
        {
          id = sys.id;
          center = (
            sys.center.0 + sys.movementVector.0 * dt / 3600.0,
            sys.center.1 + sys.movementVector.1 * dt / 3600.0
          );
          pressure = sys.pressure;
          radius = sys.radius;
          isHigh = sys.isHigh;
          movementVector = sys.movementVector;
          intensity = sys.intensity * 0.9999;  // Slowly weaken
        }
      }
    );
    
    // Determine overall condition
    let condition = determineWeatherCondition(weather.atmosphere);
    
    {
      atmosphere = {
        weather.atmosphere with
        temperature = newTemp;
        condition = condition;
      };
      pressureSystems = newPressureSystems;
      fronts = weather.fronts;
      simulationTime = newTime;
      dayOfYear = dayWrapped;
      hourOfDay = hourWrapped;
      season = getSeason(dayWrapped);
      latitude = weather.latitude;
      longitude = weather.longitude;
    }
  };
  
  /// Determine weather condition from atmospheric state
  public func determineWeatherCondition(atm: AtmosphericState) : WeatherCondition {
    // Precipitation first
    if (atm.precipRate > 20.0) {
      if (atm.precipitation == #Snow) { return #HeavySnow };
      if (atm.precipitation == #Hail) { return #Hail };
      return #HeavyRain
    };
    if (atm.precipRate > 5.0) {
      if (atm.precipitation == #Snow) { return #ModerateSnow };
      return #ModerateRain
    };
    if (atm.precipRate > 0.5) {
      if (atm.precipitation == #Snow) { return #LightSnow };
      return #LightRain
    };
    
    // Then clouds
    if (atm.visibility < 1000.0) { return #Fog };
    if (atm.visibility < 5000.0) { return #Mist };
    
    if (atm.cloudCover > 0.9) { return #Overcast };
    if (atm.cloudCover > 0.7) { return #Cloudy };
    if (atm.cloudCover > 0.3) { return #PartlyCloudy };
    
    #Clear
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     INITIALIZATION                                     ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public func initWeatherSystem(latitude: Float, longitude: Float) : WeatherSystem {
    let dayOfYear = 180;  // Start in summer
    let season = getSeason(dayOfYear);
    let baseTemp = seasonalBaseTemp(season, latitude);
    
    {
      atmosphere = {
        temperature = baseTemp;
        dewPoint = baseTemp - 5.0;
        pressure = SEA_LEVEL_PRESSURE;
        pressureTendency = 0.0;
        relativeHumidity = 0.5;
        absoluteHumidity = 0.01;
        windSpeed = 5.0;
        windDirection = 270.0;  // West wind
        gustSpeed = 7.0;
        windVector = windToVector(5.0, 270.0);
        visibility = 20000.0;
        cloudCover = 0.3;
        cloudBase = 2000.0;
        cloudTop = 4000.0;
        cloudType = #Cumulus;
        precipitation = #None;
        precipRate = 0.0;
        condition = #PartlyCloudy;
      };
      pressureSystems = [];
      fronts = [];
      simulationTime = 0.0;
      dayOfYear = dayOfYear;
      hourOfDay = 12.0;  // Noon
      season = season;
      latitude = latitude;
      longitude = longitude;
    }
  };

}
