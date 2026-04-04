// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ═══════════════════════════════════════════════════════════════════════════════
// Module: VirtualAirstrip — Geometry, Parking Grid & Ground Operations
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
//
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔════════════════════════════════════════════════════════════════════════════════╗
// ║           NOVA VIRTUAL AIRSTRIP — 500-DRONE HOLDING FACILITY                  ║
// ╠════════════════════════════════════════════════════════════════════════════════╣
// ║                                                                                ║
// ║  Layout (world units = meters):                                                ║
// ║                                                                                ║
// ║    ┌──────────────── 800m ─────────────────────────────────────────────┐       ║
// ║    │                                                                   │       ║
// ║    │  ╔═════ CONTROL TOWER ═════╗                                      │       ║
// ║    │  ║  x=-350, z=160          ║    ← 30m × 30m tower block           │       ║
// ║    │  ╚═════════════════════════╝                                      │       ║
// ║    │                                                                   │       ║
// ║    │  RUNWAY 09/27  (500m × 30m, center z=0)                          │       ║
// ║    │  ██████████████████████████████████████████████████████          │       ║
// ║    │                                                                   │       ║
// ║    │  TAXIWAY ALPHA  (500m × 15m, z=-30)                              │       ║
// ║    │  ─────────────────────────────────────────────────────            │       ║
// ║    │                                                                   │       ║
// ║    │  APRON (500m × 200m, z=-50 to z=-250)                            │       ║
// ║    │                                                                   │       ║
// ║    │  PARKING GRID (25 cols × 20 rows = 500 spots)                    │       ║
// ║    │  Each spot: 5m × 5m, spacing 10m (CMD) / 5m (Scout/Support/Hvy) │       ║
// ║    │                                                                   │       ║
// ║    └───────────────────────────────────────────────────────────────────┘       ║
// ║                                                                                ║
// ║  All dimensions in meters, X east, Y up, Z south convention.                  ║
// ║                                                                                ║
// ╚════════════════════════════════════════════════════════════════════════════════╝
// ═══════════════════════════════════════════════════════════════════════════════

// ═══════════════════════════════════════════════════════════════════════════════
// COORDINATE TYPES
// ═══════════════════════════════════════════════════════════════════════════════

export interface Vec3 {
  x: number;
  y: number;
  z: number;
}

export interface Vec2 {
  x: number;
  z: number;
}

export interface BoundingBox {
  minX: number;
  maxX: number;
  minZ: number;
  maxZ: number;
  minY: number;
  maxY: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// AIRSTRIP LAYOUT CONSTANTS — All in meters
// ═══════════════════════════════════════════════════════════════════════════════

export const AIRSTRIP = {
  /** Runway centre X origin (world origin) */
  RUNWAY_CENTER_X: 0,
  /** Runway centre Z = world Z=0 */
  RUNWAY_CENTER_Z: 0,
  /** Runway length [m] */
  RUNWAY_LENGTH: 500,
  /** Runway width [m] */
  RUNWAY_WIDTH: 30,
  /** Runway surface elevation [m] */
  RUNWAY_ELEVATION: 0.05,
  /** Runway magnetic heading 09 (090°) = east */
  RUNWAY_HEADING_DEG: 90,
  /** Threshold markings width [m] */
  THRESHOLD_WIDTH: 1.5,

  /** Taxiway A: parallel to runway, south side */
  TAXIWAY_A_Z: -52,
  TAXIWAY_A_LENGTH: 520,
  TAXIWAY_A_WIDTH: 15,
  TAXIWAY_ELEVATION: 0.03,

  /** Cross-taxiway (connects runway ends to taxiway) */
  CROSS_TAXI_WIDTH: 12,

  /** Apron area */
  APRON_Z_NORTH: -70,
  APRON_Z_SOUTH: -280,
  APRON_X_WEST: -260,
  APRON_X_EAST: 260,
  APRON_ELEVATION: 0.02,

  /** Control tower */
  TOWER_X: -320,
  TOWER_Z: 100,
  TOWER_WIDTH: 18,
  TOWER_DEPTH: 18,
  TOWER_HEIGHT: 45,
  TOWER_CAB_HEIGHT: 8,
  TOWER_CAB_WIDTH: 14,

  /** Parking grid origin (top-left corner, NW corner of apron) */
  PARKING_ORIGIN_X: -250,
  PARKING_ORIGIN_Z: -80,

  /** Parking spot spacing [m] (edge-to-edge + clearance) */
  PARKING_SPACING_X: 18,
  PARKING_SPACING_Z: 16,

  /** Parking grid: 25 columns × 20 rows = 500 spots */
  PARKING_COLS: 25,
  PARKING_ROWS: 20,

  /** Spot pad size [m] */
  SPOT_PAD_SIZE: 5,

  /** Ground service road width [m] */
  SERVICE_ROAD_WIDTH: 6,

  /** Perimeter fence offset from boundary [m] */
  FENCE_OFFSET: 20,

  /** PAPI lights position (X from threshold, Z = runway edge) */
  PAPI_OFFSET_X: 300,
  PAPI_OFFSET_Z: 22,

  /** Wind sock position */
  WINDSOCK_X: 200,
  WINDSOCK_Z: 80,
  WINDSOCK_POLE_HEIGHT: 8,

  /** Lighting poles spacing along runway [m] */
  RUNWAY_LIGHT_SPACING: 60,

  /** Touchdown zone marking length [m] */
  TOUCHDOWN_ZONE_LENGTH: 150,

  /** Displaced threshold [m] from runway start */
  DISPLACED_THRESHOLD: 30,
} as const;

// ═══════════════════════════════════════════════════════════════════════════════
// PARKING SPOT — One of 500 individual positions
// ═══════════════════════════════════════════════════════════════════════════════

export interface ParkingSpot {
  /** Unique spot ID, e.g. "P00-07" */
  id: string;
  /** Row index (0–19) */
  row: number;
  /** Column index (0–24) */
  col: number;
  /** Fleet index (0–499) that maps here */
  fleetIndex: number;
  /** World position of spot centre */
  position: Vec3;
  /** Heading the parked drone faces [degrees, 0=North, 90=East] */
  headingDeg: number;
  /** Spot occupied by actual drone? */
  occupied: boolean;
  /** Spot type based on row (different row groups = different classes) */
  spotClass: 'Commander' | 'Scout' | 'Support' | 'Heavy';
  /** Charging pad present */
  hasChargingPad: boolean;
  /** Pad dimensions [m] */
  padWidth: number;
  padDepth: number;
}

/**
 * Generate the full 500-spot parking grid.
 * Rows 0–1   → Commander (50 units in 2 rows × 25)
 * Rows 2–4   → Scout A   (75 units in 3 rows × 25)
 * Rows 5–7   → Scout B   (75 units in 3 rows × 25)
 * Rows 8–10  → Support A (75 units in 3 rows × 25)
 * Rows 11–15 → Support B (125 units in 5 rows × 25)
 * Rows 16–19 → Heavy     (100 units in 4 rows × 25)
 */
export function generateParkingGrid(): ParkingSpot[] {
  const spots: ParkingSpot[] = [];

  for (let row = 0; row < AIRSTRIP.PARKING_ROWS; row++) {
    for (let col = 0; col < AIRSTRIP.PARKING_COLS; col++) {
      const fleetIndex = row * AIRSTRIP.PARKING_COLS + col;

      const x = AIRSTRIP.PARKING_ORIGIN_X + col * AIRSTRIP.PARKING_SPACING_X;
      const z = AIRSTRIP.PARKING_ORIGIN_Z - row * AIRSTRIP.PARKING_SPACING_Z;
      const y = AIRSTRIP.APRON_ELEVATION;

      let spotClass: ParkingSpot['spotClass'];
      if (row < 2)        spotClass = 'Commander';
      else if (row < 5)   spotClass = 'Scout';
      else if (row < 8)   spotClass = 'Scout';
      else if (row < 11)  spotClass = 'Support';
      else if (row < 16)  spotClass = 'Support';
      else                spotClass = 'Heavy';

      // Pad size depends on class
      const padWidth = spotClass === 'Heavy' ? 8 : spotClass === 'Commander' ? 6 : 4;
      const padDepth = padWidth;

      spots.push({
        id: `P${String(row).padStart(2, '0')}-${String(col).padStart(2, '0')}`,
        row,
        col,
        fleetIndex,
        position: { x, y, z },
        headingDeg: 0, // All drones face North (towards runway) when parked
        occupied: true,
        spotClass,
        hasChargingPad: true,
        padWidth,
        padDepth,
      });
    }
  }

  return spots;
}

// ═══════════════════════════════════════════════════════════════════════════════
// RUNWAY SEGMENT — For rendering and navigation
// ═══════════════════════════════════════════════════════════════════════════════

export interface RunwaySegment {
  /** Segment type */
  type:
    | 'Pavement'
    | 'Centerline'
    | 'ThresholdMarking'
    | 'AimingPoint'
    | 'TouchdownZone'
    | 'DisplacedThreshold'
    | 'Edge'
    | 'PAPI'
    | 'RunwayLight'
    | 'EndLight';
  /** World position */
  position: Vec3;
  /** Dimensions [m] */
  width: number;
  length: number;
  /** Orientation [degrees] */
  headingDeg: number;
  /** Color (hex) */
  color: string;
  /** Light intensity (0 = not a light) */
  lightIntensity: number;
  /** Light color */
  lightColor: string;
}

export function generateRunwaySegments(): RunwaySegment[] {
  const segments: RunwaySegment[] = [];
  const cx = AIRSTRIP.RUNWAY_CENTER_X;
  const cz = AIRSTRIP.RUNWAY_CENTER_Z;
  const halfLen = AIRSTRIP.RUNWAY_LENGTH / 2;
  const halfWidth = AIRSTRIP.RUNWAY_WIDTH / 2;

  // ─── Runway pavement ───────────────────────────────────────────────────────
  segments.push({
    type: 'Pavement',
    position: { x: cx, y: AIRSTRIP.RUNWAY_ELEVATION, z: cz },
    width: AIRSTRIP.RUNWAY_WIDTH,
    length: AIRSTRIP.RUNWAY_LENGTH,
    headingDeg: 90,
    color: '#1a1a1a',
    lightIntensity: 0,
    lightColor: '#000000',
  });

  // ─── Centerline markings ──────────────────────────────────────────────────
  const centerlineCount = 20;
  for (let i = 0; i < centerlineCount; i++) {
    const xOffset = -halfLen + 15 + i * (AIRSTRIP.RUNWAY_LENGTH - 30) / centerlineCount;
    segments.push({
      type: 'Centerline',
      position: { x: cx + xOffset, y: AIRSTRIP.RUNWAY_ELEVATION + 0.01, z: cz },
      width: 0.9,
      length: 15,
      headingDeg: 90,
      color: '#ffffff',
      lightIntensity: 0,
      lightColor: '#000000',
    });
  }

  // ─── Threshold markings (09 and 27) ──────────────────────────────────────
  const thresholdStripes = 8;
  for (let s = 0; s < thresholdStripes; s++) {
    const zOff = (-thresholdStripes / 2 + s + 0.5) * (AIRSTRIP.RUNWAY_WIDTH / thresholdStripes);

    // Threshold 09 (west end)
    segments.push({
      type: 'ThresholdMarking',
      position: { x: cx - halfLen + 20, y: AIRSTRIP.RUNWAY_ELEVATION + 0.01, z: cz + zOff },
      width: 1.8,
      length: 30,
      headingDeg: 90,
      color: '#ffffff',
      lightIntensity: 0,
      lightColor: '#000000',
    });

    // Threshold 27 (east end)
    segments.push({
      type: 'ThresholdMarking',
      position: { x: cx + halfLen - 20, y: AIRSTRIP.RUNWAY_ELEVATION + 0.01, z: cz + zOff },
      width: 1.8,
      length: 30,
      headingDeg: 90,
      color: '#ffffff',
      lightIntensity: 0,
      lightColor: '#000000',
    });
  }

  // ─── Aiming point markings ────────────────────────────────────────────────
  const aimOffset = 300;
  [-halfWidth * 0.6, halfWidth * 0.6].forEach(zOff => {
    // 09 aiming point
    segments.push({
      type: 'AimingPoint',
      position: { x: cx - halfLen + aimOffset, y: AIRSTRIP.RUNWAY_ELEVATION + 0.01, z: cz + zOff },
      width: 3,
      length: 45,
      headingDeg: 90,
      color: '#ffffff',
      lightIntensity: 0,
      lightColor: '#000000',
    });
    // 27 aiming point
    segments.push({
      type: 'AimingPoint',
      position: { x: cx + halfLen - aimOffset, y: AIRSTRIP.RUNWAY_ELEVATION + 0.01, z: cz + zOff },
      width: 3,
      length: 45,
      headingDeg: 90,
      color: '#ffffff',
      lightIntensity: 0,
      lightColor: '#000000',
    });
  });

  // ─── Edge lights ──────────────────────────────────────────────────────────
  const lightSpacing = AIRSTRIP.RUNWAY_LIGHT_SPACING;
  const lightCount = Math.floor(AIRSTRIP.RUNWAY_LENGTH / lightSpacing) + 1;
  for (let i = 0; i < lightCount; i++) {
    const xPos = cx - halfLen + i * lightSpacing;
    [-halfWidth - 1.5, halfWidth + 1.5].forEach(zOff => {
      segments.push({
        type: 'RunwayLight',
        position: { x: xPos, y: AIRSTRIP.RUNWAY_ELEVATION + 0.3, z: cz + zOff },
        width: 0.3,
        length: 0.3,
        headingDeg: 0,
        color: '#ffffff',
        lightIntensity: 1.5,
        lightColor: '#ffffff',
      });
    });
  }

  // ─── End lights (red on approach end) ─────────────────────────────────────
  for (let z = -halfWidth; z <= halfWidth; z += 2) {
    // 09 approach end
    segments.push({
      type: 'EndLight',
      position: { x: cx - halfLen - 2, y: AIRSTRIP.RUNWAY_ELEVATION + 0.3, z: cz + z },
      width: 0.3,
      length: 0.3,
      headingDeg: 0,
      color: '#ff2200',
      lightIntensity: 2,
      lightColor: '#ff2200',
    });
    // 27 approach end
    segments.push({
      type: 'EndLight',
      position: { x: cx + halfLen + 2, y: AIRSTRIP.RUNWAY_ELEVATION + 0.3, z: cz + z },
      width: 0.3,
      length: 0.3,
      headingDeg: 0,
      color: '#ff2200',
      lightIntensity: 2,
      lightColor: '#ff2200',
    });
  }

  // ─── PAPI lights (Precision Approach Path Indicator) ─────────────────────
  const papiBoxCount = 4;
  for (let p = 0; p < papiBoxCount; p++) {
    segments.push({
      type: 'PAPI',
      position: {
        x: cx - halfLen + AIRSTRIP.PAPI_OFFSET_X + p * 2,
        y: AIRSTRIP.RUNWAY_ELEVATION + 0.5,
        z: cz - AIRSTRIP.PAPI_OFFSET_Z,
      },
      width: 0.6,
      length: 0.6,
      headingDeg: 0,
      color: p < 2 ? '#ff4400' : '#ffffff',
      lightIntensity: 3,
      lightColor: p < 2 ? '#ff4400' : '#ffffff',
    });
  }

  return segments;
}

// ═══════════════════════════════════════════════════════════════════════════════
// TAXIWAY NETWORK — Nodes and edges for routing
// ═══════════════════════════════════════════════════════════════════════════════

export interface TaxiwayNode {
  id: string;
  position: Vec3;
  type: 'Intersection' | 'HoldShort' | 'Runway' | 'Apron' | 'Spot';
  connectedTo: string[];
}

export interface TaxiwayEdge {
  id: string;
  fromNodeId: string;
  toNodeId: string;
  width: number;
  maxSpeedMs: number;
  surface: 'Asphalt' | 'Concrete';
  lightingColor: string;
  centerlineColor: string;
}

export function generateTaxiwayNetwork(): { nodes: TaxiwayNode[]; edges: TaxiwayEdge[] } {
  const nodes: TaxiwayNode[] = [];
  const edges: TaxiwayEdge[] = [];

  const halfLen = AIRSTRIP.RUNWAY_LENGTH / 2;
  const taxiZ = AIRSTRIP.TAXIWAY_A_Z;

  // ─── Taxiway A main corridor ───────────────────────────────────────────────
  // West end of taxiway A
  const nodeA_W: TaxiwayNode = {
    id: 'TWY-A-WEST',
    position: { x: -halfLen, y: AIRSTRIP.TAXIWAY_ELEVATION, z: taxiZ },
    type: 'Intersection',
    connectedTo: ['TWY-A-MID1', 'CROSS-TAXI-WEST'],
  };
  // Mid-1
  const nodeA_M1: TaxiwayNode = {
    id: 'TWY-A-MID1',
    position: { x: -halfLen / 2, y: AIRSTRIP.TAXIWAY_ELEVATION, z: taxiZ },
    type: 'Intersection',
    connectedTo: ['TWY-A-WEST', 'TWY-A-MID2', 'APRON-ENTRY-W'],
  };
  // Mid-2 (centre)
  const nodeA_M2: TaxiwayNode = {
    id: 'TWY-A-MID2',
    position: { x: 0, y: AIRSTRIP.TAXIWAY_ELEVATION, z: taxiZ },
    type: 'Intersection',
    connectedTo: ['TWY-A-MID1', 'TWY-A-MID3', 'APRON-ENTRY-C'],
  };
  // Mid-3
  const nodeA_M3: TaxiwayNode = {
    id: 'TWY-A-MID3',
    position: { x: halfLen / 2, y: AIRSTRIP.TAXIWAY_ELEVATION, z: taxiZ },
    type: 'Intersection',
    connectedTo: ['TWY-A-MID2', 'TWY-A-EAST', 'APRON-ENTRY-E'],
  };
  // East end
  const nodeA_E: TaxiwayNode = {
    id: 'TWY-A-EAST',
    position: { x: halfLen, y: AIRSTRIP.TAXIWAY_ELEVATION, z: taxiZ },
    type: 'Intersection',
    connectedTo: ['TWY-A-MID3', 'CROSS-TAXI-EAST'],
  };

  // Cross-taxiways connecting runway ends to taxiway A
  const crossWest: TaxiwayNode = {
    id: 'CROSS-TAXI-WEST',
    position: { x: -halfLen, y: AIRSTRIP.TAXIWAY_ELEVATION, z: -AIRSTRIP.RUNWAY_WIDTH / 2 },
    type: 'HoldShort',
    connectedTo: ['TWY-A-WEST'],
  };
  const crossEast: TaxiwayNode = {
    id: 'CROSS-TAXI-EAST',
    position: { x: halfLen, y: AIRSTRIP.TAXIWAY_ELEVATION, z: -AIRSTRIP.RUNWAY_WIDTH / 2 },
    type: 'HoldShort',
    connectedTo: ['TWY-A-EAST'],
  };

  // Apron entry nodes
  const apronEntryW: TaxiwayNode = {
    id: 'APRON-ENTRY-W',
    position: { x: -100, y: AIRSTRIP.APRON_ELEVATION, z: AIRSTRIP.APRON_Z_NORTH },
    type: 'Apron',
    connectedTo: ['TWY-A-MID1'],
  };
  const apronEntryC: TaxiwayNode = {
    id: 'APRON-ENTRY-C',
    position: { x: 0, y: AIRSTRIP.APRON_ELEVATION, z: AIRSTRIP.APRON_Z_NORTH },
    type: 'Apron',
    connectedTo: ['TWY-A-MID2'],
  };
  const apronEntryE: TaxiwayNode = {
    id: 'APRON-ENTRY-E',
    position: { x: 100, y: AIRSTRIP.APRON_ELEVATION, z: AIRSTRIP.APRON_Z_NORTH },
    type: 'Apron',
    connectedTo: ['TWY-A-MID3'],
  };

  nodes.push(
    nodeA_W, nodeA_M1, nodeA_M2, nodeA_M3, nodeA_E,
    crossWest, crossEast,
    apronEntryW, apronEntryC, apronEntryE
  );

  // ─── Taxiway edges ─────────────────────────────────────────────────────────
  const taxiwayEdgeProps = {
    width: AIRSTRIP.TAXIWAY_A_WIDTH,
    maxSpeedMs: 5,
    surface: 'Asphalt' as const,
    lightingColor: '#00aaff',
    centerlineColor: '#ffcc00',
  };

  const edgePairs: Array<[string, string]> = [
    ['TWY-A-WEST', 'TWY-A-MID1'],
    ['TWY-A-MID1', 'TWY-A-MID2'],
    ['TWY-A-MID2', 'TWY-A-MID3'],
    ['TWY-A-MID3', 'TWY-A-EAST'],
    ['TWY-A-WEST', 'CROSS-TAXI-WEST'],
    ['TWY-A-EAST', 'CROSS-TAXI-EAST'],
    ['TWY-A-MID1', 'APRON-ENTRY-W'],
    ['TWY-A-MID2', 'APRON-ENTRY-C'],
    ['TWY-A-MID3', 'APRON-ENTRY-E'],
  ];

  edgePairs.forEach(([from, to], i) => {
    edges.push({
      id: `EDGE-${i}`,
      fromNodeId: from,
      toNodeId: to,
      ...taxiwayEdgeProps,
    });
  });

  return { nodes, edges };
}

// ═══════════════════════════════════════════════════════════════════════════════
// AIRSTRIP SURFACE MARKINGS — Complete set for rendering
// ═══════════════════════════════════════════════════════════════════════════════

export interface SurfaceMarking {
  id: string;
  type: 'RunwayNumber' | 'HoldShortLine' | 'TaxiwayEdge' | 'TaxiwayCenterline' | 'NoEntry' | 'ParkingSpotOutline' | 'RowLabel';
  position: Vec3;
  headingDeg: number;
  width: number;
  length: number;
  color: string;
  text?: string;
  fontSize?: number;
}

export function generateSurfaceMarkings(): SurfaceMarking[] {
  const markings: SurfaceMarking[] = [];
  const halfLen = AIRSTRIP.RUNWAY_LENGTH / 2;
  const cz = AIRSTRIP.RUNWAY_CENTER_Z;

  // Runway designators
  markings.push(
    {
      id: 'RWY-09',
      type: 'RunwayNumber',
      position: { x: -halfLen + 15, y: AIRSTRIP.RUNWAY_ELEVATION + 0.02, z: cz },
      headingDeg: 90,
      width: 8,
      length: 12,
      color: '#ffffff',
      text: '09',
      fontSize: 6,
    },
    {
      id: 'RWY-27',
      type: 'RunwayNumber',
      position: { x: halfLen - 15, y: AIRSTRIP.RUNWAY_ELEVATION + 0.02, z: cz },
      headingDeg: 270,
      width: 8,
      length: 12,
      color: '#ffffff',
      text: '27',
      fontSize: 6,
    }
  );

  // Hold-short lines at each runway intersection with taxiway
  const holdShortXPositions = [-halfLen, halfLen];
  holdShortXPositions.forEach((xPos, i) => {
    markings.push({
      id: `HOLD-SHORT-${i}`,
      type: 'HoldShortLine',
      position: { x: xPos, y: AIRSTRIP.TAXIWAY_ELEVATION + 0.01, z: AIRSTRIP.TAXIWAY_A_Z },
      headingDeg: 0,
      width: AIRSTRIP.TAXIWAY_A_WIDTH,
      length: 0.6,
      color: '#ffcc00',
    });
  });

  // Taxiway centerline markings
  const centerlineSpacing = 10;
  const taxiMarkCount = Math.floor(AIRSTRIP.TAXIWAY_A_LENGTH / centerlineSpacing);
  for (let i = 0; i < taxiMarkCount; i++) {
    const xPos = AIRSTRIP.RUNWAY_CENTER_X - AIRSTRIP.TAXIWAY_A_LENGTH / 2 + i * centerlineSpacing;
    markings.push({
      id: `TAXI-CL-${i}`,
      type: 'TaxiwayCenterline',
      position: { x: xPos, y: AIRSTRIP.TAXIWAY_ELEVATION + 0.01, z: AIRSTRIP.TAXIWAY_A_Z },
      headingDeg: 90,
      width: 0.15,
      length: 7,
      color: '#ffcc00',
    });
  }

  // Parking spot outlines
  for (let row = 0; row < AIRSTRIP.PARKING_ROWS; row++) {
    for (let col = 0; col < AIRSTRIP.PARKING_COLS; col++) {
      const x = AIRSTRIP.PARKING_ORIGIN_X + col * AIRSTRIP.PARKING_SPACING_X;
      const z = AIRSTRIP.PARKING_ORIGIN_Z - row * AIRSTRIP.PARKING_SPACING_Z;
      markings.push({
        id: `SPOT-${row}-${col}`,
        type: 'ParkingSpotOutline',
        position: { x, y: AIRSTRIP.APRON_ELEVATION + 0.01, z },
        headingDeg: 0,
        width: AIRSTRIP.SPOT_PAD_SIZE,
        length: AIRSTRIP.SPOT_PAD_SIZE,
        color: '#44aaff',
      });
    }
  }

  // Row labels (every 5 rows)
  for (let row = 0; row < AIRSTRIP.PARKING_ROWS; row += 5) {
    const z = AIRSTRIP.PARKING_ORIGIN_Z - row * AIRSTRIP.PARKING_SPACING_Z;
    markings.push({
      id: `ROW-LABEL-${row}`,
      type: 'RowLabel',
      position: { x: AIRSTRIP.PARKING_ORIGIN_X - 10, y: AIRSTRIP.APRON_ELEVATION + 0.02, z },
      headingDeg: 0,
      width: 3,
      length: 6,
      color: '#ffffff',
      text: `R${row}`,
      fontSize: 2,
    });
  }

  return markings;
}

// ═══════════════════════════════════════════════════════════════════════════════
// AIRSTRIP STRUCTURES — Buildings and fixed objects
// ═══════════════════════════════════════════════════════════════════════════════

export interface AirstripStructure {
  id: string;
  type:
    | 'ControlTower'
    | 'Hangar'
    | 'MaintenanceBuilding'
    | 'FuelDepot'
    | 'ChargingStation'
    | 'SecurityHut'
    | 'WindSock'
    | 'PerimeterFence'
    | 'AccessGate'
    | 'ServiceRoad'
    | 'WeatherStation';
  position: Vec3;
  dimensions: Vec3; // width (X), height (Y), depth (Z)
  headingDeg: number;
  color: string;
  emissive?: string;
  label?: string;
}

export function generateAirstripStructures(): AirstripStructure[] {
  const structures: AirstripStructure[] = [];

  // Control tower base
  structures.push({
    id: 'TOWER-BASE',
    type: 'ControlTower',
    position: {
      x: AIRSTRIP.TOWER_X,
      y: AIRSTRIP.TOWER_HEIGHT / 2,
      z: AIRSTRIP.TOWER_Z,
    },
    dimensions: { x: AIRSTRIP.TOWER_WIDTH, y: AIRSTRIP.TOWER_HEIGHT, z: AIRSTRIP.TOWER_DEPTH },
    headingDeg: 0,
    color: '#c0c4cc',
    label: 'NOVA ATC',
  });

  // Control tower cab (glass top)
  structures.push({
    id: 'TOWER-CAB',
    type: 'ControlTower',
    position: {
      x: AIRSTRIP.TOWER_X,
      y: AIRSTRIP.TOWER_HEIGHT + AIRSTRIP.TOWER_CAB_HEIGHT / 2,
      z: AIRSTRIP.TOWER_Z,
    },
    dimensions: {
      x: AIRSTRIP.TOWER_CAB_WIDTH,
      y: AIRSTRIP.TOWER_CAB_HEIGHT,
      z: AIRSTRIP.TOWER_CAB_WIDTH,
    },
    headingDeg: 0,
    color: '#88bbdd',
    emissive: '#224466',
    label: 'ATC CAB',
  });

  // Main hangar complex (3 hangars)
  const hangarPositions = [-150, 0, 150];
  hangarPositions.forEach((xOff, i) => {
    structures.push({
      id: `HANGAR-${i + 1}`,
      type: 'Hangar',
      position: {
        x: AIRSTRIP.PARKING_ORIGIN_X + xOff + 100,
        y: 12,
        z: AIRSTRIP.APRON_Z_SOUTH + 40,
      },
      dimensions: { x: 80, y: 24, z: 60 },
      headingDeg: 0,
      color: '#6688aa',
      label: `NOVA HANGAR ${i + 1}`,
    });
  });

  // Maintenance building
  structures.push({
    id: 'MAINTENANCE',
    type: 'MaintenanceBuilding',
    position: {
      x: 180,
      y: 8,
      z: AIRSTRIP.APRON_Z_SOUTH + 60,
    },
    dimensions: { x: 60, y: 16, z: 40 },
    headingDeg: 0,
    color: '#778899',
    label: 'MAINTENANCE OPS',
  });

  // Fuel / charging depot
  structures.push({
    id: 'FUEL-DEPOT',
    type: 'FuelDepot',
    position: {
      x: 240,
      y: 6,
      z: AIRSTRIP.APRON_Z_SOUTH + 30,
    },
    dimensions: { x: 30, y: 12, z: 20 },
    headingDeg: 0,
    color: '#aa4422',
    emissive: '#331100',
    label: 'FUEL / POWER',
  });

  // Charging stations (distributed across apron)
  const chargingStationCount = 10;
  for (let c = 0; c < chargingStationCount; c++) {
    structures.push({
      id: `CHARGING-${c}`,
      type: 'ChargingStation',
      position: {
        x: AIRSTRIP.PARKING_ORIGIN_X + c * 48,
        y: 1.5,
        z: AIRSTRIP.APRON_Z_NORTH - 10,
      },
      dimensions: { x: 4, y: 3, z: 2 },
      headingDeg: 0,
      color: '#2266aa',
      emissive: '#001133',
      label: `CHG-${c}`,
    });
  }

  // Security huts at access gates
  [-260, 260].forEach((x, i) => {
    structures.push({
      id: `SECURITY-HUT-${i}`,
      type: 'SecurityHut',
      position: {
        x,
        y: 2.5,
        z: AIRSTRIP.APRON_Z_NORTH + 15,
      },
      dimensions: { x: 5, y: 5, z: 5 },
      headingDeg: 0,
      color: '#445544',
      label: `GATE ${i === 0 ? 'ALPHA' : 'BRAVO'}`,
    });
  });

  // Wind sock
  structures.push({
    id: 'WINDSOCK',
    type: 'WindSock',
    position: {
      x: AIRSTRIP.WINDSOCK_X,
      y: AIRSTRIP.WINDSOCK_POLE_HEIGHT,
      z: AIRSTRIP.WINDSOCK_Z,
    },
    dimensions: { x: 0.3, y: AIRSTRIP.WINDSOCK_POLE_HEIGHT, z: 0.3 },
    headingDeg: 0,
    color: '#ff6600',
    label: 'WINDSOCK',
  });

  // Weather station
  structures.push({
    id: 'WEATHER-STATION',
    type: 'WeatherStation',
    position: {
      x: 280,
      y: 4,
      z: 80,
    },
    dimensions: { x: 2, y: 8, z: 2 },
    headingDeg: 0,
    color: '#aaaaaa',
    emissive: '#222222',
    label: 'METEO',
  });

  return structures;
}

// ═══════════════════════════════════════════════════════════════════════════════
// AIRSTRIP LIGHTING — Full night operations light set
// ═══════════════════════════════════════════════════════════════════════════════

export interface AirstripLight {
  id: string;
  type:
    | 'RunwayEdge'
    | 'RunwayEnd'
    | 'RunwayCenterline'
    | 'PAPI'
    | 'TaxiwayEdge'
    | 'TaxiwayCenterline'
    | 'ApronFlood'
    | 'PerimeterMarker'
    | 'ObstructionBeacon'
    | 'Beacon';
  position: Vec3;
  color: string;
  intensity: number;
  distanceM: number;
  isOn: boolean;
}

export function generateAirstripLights(): AirstripLight[] {
  const lights: AirstripLight[] = [];
  const halfLen = AIRSTRIP.RUNWAY_LENGTH / 2;
  const halfWidth = AIRSTRIP.RUNWAY_WIDTH / 2;

  // ─── Runway edge lights (white) ────────────────────────────────────────────
  const lightSpacing = AIRSTRIP.RUNWAY_LIGHT_SPACING;
  const lightCount = Math.ceil(AIRSTRIP.RUNWAY_LENGTH / lightSpacing) + 1;
  for (let i = 0; i < lightCount; i++) {
    const x = -halfLen + i * lightSpacing;
    [-halfWidth - 1.5, halfWidth + 1.5].forEach((zOff, side) => {
      lights.push({
        id: `RWY-EDGE-${i}-${side}`,
        type: 'RunwayEdge',
        position: { x, y: AIRSTRIP.RUNWAY_ELEVATION + 0.15, z: zOff },
        color: '#ffffff',
        intensity: 2,
        distanceM: 120,
        isOn: true,
      });
    });
  }

  // ─── Runway end lights (red / green) ─────────────────────────────────────
  const endLightCount = 8;
  for (let i = 0; i < endLightCount; i++) {
    const z = -halfWidth + i * (AIRSTRIP.RUNWAY_WIDTH / (endLightCount - 1));
    // West end — green (threshold 09)
    lights.push({
      id: `RWY-END-09-${i}`,
      type: 'RunwayEnd',
      position: { x: -halfLen - 2, y: AIRSTRIP.RUNWAY_ELEVATION + 0.2, z },
      color: '#00ff44',
      intensity: 3,
      distanceM: 200,
      isOn: true,
    });
    // East end — red (threshold 27)
    lights.push({
      id: `RWY-END-27-${i}`,
      type: 'RunwayEnd',
      position: { x: halfLen + 2, y: AIRSTRIP.RUNWAY_ELEVATION + 0.2, z },
      color: '#ff2200',
      intensity: 3,
      distanceM: 200,
      isOn: true,
    });
  }

  // ─── Runway centerline lights ──────────────────────────────────────────────
  const clLightSpacing = 30;
  const clLightCount = Math.floor(AIRSTRIP.RUNWAY_LENGTH / clLightSpacing);
  for (let i = 0; i < clLightCount; i++) {
    const x = -halfLen + 15 + i * clLightSpacing;
    const isLastThird = x > halfLen / 3;
    lights.push({
      id: `RWY-CL-${i}`,
      type: 'RunwayCenterline',
      position: { x, y: AIRSTRIP.RUNWAY_ELEVATION + 0.02, z: 0 },
      color: isLastThird ? '#ff6600' : '#ffffff',
      intensity: 1.5,
      distanceM: 80,
      isOn: true,
    });
  }

  // ─── PAPI lights ──────────────────────────────────────────────────────────
  for (let p = 0; p < 4; p++) {
    // 3° glidepath: bottom 2 white, top 2 red = on glideslope
    // Below glidepath: more red; above: more white
    lights.push({
      id: `PAPI-09-${p}`,
      type: 'PAPI',
      position: {
        x: -halfLen + AIRSTRIP.PAPI_OFFSET_X + p * 2.5,
        y: AIRSTRIP.RUNWAY_ELEVATION + 0.8,
        z: -AIRSTRIP.PAPI_OFFSET_Z,
      },
      color: p < 2 ? '#ff2200' : '#ffffff',
      intensity: 8,
      distanceM: 5000,
      isOn: true,
    });
  }

  // ─── Taxiway edge lights (blue) ───────────────────────────────────────────
  const taxiLightSpacing = 30;
  const taxiLightCount = Math.ceil(AIRSTRIP.TAXIWAY_A_LENGTH / taxiLightSpacing);
  for (let i = 0; i < taxiLightCount; i++) {
    const x = AIRSTRIP.RUNWAY_CENTER_X - AIRSTRIP.TAXIWAY_A_LENGTH / 2 + i * taxiLightSpacing;
    [-AIRSTRIP.TAXIWAY_A_WIDTH / 2 - 1, AIRSTRIP.TAXIWAY_A_WIDTH / 2 + 1].forEach((zOff, side) => {
      lights.push({
        id: `TWY-EDGE-${i}-${side}`,
        type: 'TaxiwayEdge',
        position: { x, y: AIRSTRIP.TAXIWAY_ELEVATION + 0.1, z: AIRSTRIP.TAXIWAY_A_Z + zOff },
        color: '#0066ff',
        intensity: 1.2,
        distanceM: 60,
        isOn: true,
      });
    });
  }

  // ─── Taxiway centerline lights (green) ────────────────────────────────────
  const taxiCLSpacing = 15;
  const taxiCLCount = Math.floor(AIRSTRIP.TAXIWAY_A_LENGTH / taxiCLSpacing);
  for (let i = 0; i < taxiCLCount; i++) {
    const x = AIRSTRIP.RUNWAY_CENTER_X - AIRSTRIP.TAXIWAY_A_LENGTH / 2 + i * taxiCLSpacing;
    lights.push({
      id: `TWY-CL-${i}`,
      type: 'TaxiwayCenterline',
      position: { x, y: AIRSTRIP.TAXIWAY_ELEVATION + 0.02, z: AIRSTRIP.TAXIWAY_A_Z },
      color: '#00ff44',
      intensity: 0.8,
      distanceM: 30,
      isOn: true,
    });
  }

  // ─── Apron flood lights ───────────────────────────────────────────────────
  const floodLightCols = 6;
  const floodLightRows = 4;
  for (let fr = 0; fr < floodLightRows; fr++) {
    for (let fc = 0; fc < floodLightCols; fc++) {
      const x = AIRSTRIP.APRON_X_WEST + (fc + 0.5) * (AIRSTRIP.APRON_X_EAST - AIRSTRIP.APRON_X_WEST) / floodLightCols;
      const z = AIRSTRIP.APRON_Z_NORTH - (fr + 0.5) * Math.abs(AIRSTRIP.APRON_Z_SOUTH - AIRSTRIP.APRON_Z_NORTH) / floodLightRows;
      lights.push({
        id: `APRON-FLOOD-${fr}-${fc}`,
        type: 'ApronFlood',
        position: { x, y: 20, z },
        color: '#ffffcc',
        intensity: 8,
        distanceM: 150,
        isOn: true,
      });
    }
  }

  // ─── Aerodrome beacon (rotating green/white at control tower) ─────────────
  lights.push({
    id: 'AERO-BEACON',
    type: 'Beacon',
    position: {
      x: AIRSTRIP.TOWER_X,
      y: AIRSTRIP.TOWER_HEIGHT + AIRSTRIP.TOWER_CAB_HEIGHT + 2,
      z: AIRSTRIP.TOWER_Z,
    },
    color: '#00ff44',
    intensity: 20,
    distanceM: 10000,
    isOn: true,
  });

  // ─── Obstruction lights (red, on tall structures) ─────────────────────────
  lights.push({
    id: 'TOWER-OBSTRUCTION',
    type: 'ObstructionBeacon',
    position: {
      x: AIRSTRIP.TOWER_X,
      y: AIRSTRIP.TOWER_HEIGHT + AIRSTRIP.TOWER_CAB_HEIGHT + 1,
      z: AIRSTRIP.TOWER_Z,
    },
    color: '#ff2200',
    intensity: 5,
    distanceM: 5000,
    isOn: true,
  });

  return lights;
}

// ═══════════════════════════════════════════════════════════════════════════════
// COMPLETE AIRSTRIP WORLD — Assembled scene data
// ═══════════════════════════════════════════════════════════════════════════════

export interface AirstripWorld {
  parkingGrid: ParkingSpot[];
  runwaySegments: RunwaySegment[];
  taxiway: { nodes: TaxiwayNode[]; edges: TaxiwayEdge[] };
  surfaceMarkings: SurfaceMarking[];
  structures: AirstripStructure[];
  lights: AirstripLight[];
  worldBounds: BoundingBox;
}

let _cachedAirstripWorld: AirstripWorld | null = null;

/** Build and cache the complete airstrip world. */
export function buildAirstripWorld(): AirstripWorld {
  if (_cachedAirstripWorld) return _cachedAirstripWorld;

  _cachedAirstripWorld = {
    parkingGrid: generateParkingGrid(),
    runwaySegments: generateRunwaySegments(),
    taxiway: generateTaxiwayNetwork(),
    surfaceMarkings: generateSurfaceMarkings(),
    structures: generateAirstripStructures(),
    lights: generateAirstripLights(),
    worldBounds: {
      minX: -400,
      maxX: 400,
      minZ: -350,
      maxZ: 200,
      minY: 0,
      maxY: 100,
    },
  };

  return _cachedAirstripWorld;
}

// ═══════════════════════════════════════════════════════════════════════════════
// GROUND OPERATIONS MANAGER — Route drones through taxiway network
// ═══════════════════════════════════════════════════════════════════════════════

export interface GroundRoute {
  droneId: number;
  from: string; // node ID
  to: string;   // node ID
  waypoints: Vec3[];
  estimatedTimeS: number;
  currentWaypointIndex: number;
}

/**
 * Compute a simple ground route from parking spot to runway hold-short.
 * Uses the taxiway network A (west or east ramp based on parking column).
 */
export function computeTakeoffRoute(
  parkingSpot: ParkingSpot,
  targetRunwayEnd: 'East' | 'West'
): GroundRoute {
  const waypoints: Vec3[] = [];

  // Start at parking spot
  waypoints.push({ ...parkingSpot.position });

  // Exit parking row (move north to taxiway row)
  waypoints.push({
    x: parkingSpot.position.x,
    y: AIRSTRIP.TAXIWAY_ELEVATION,
    z: AIRSTRIP.TAXIWAY_A_Z,
  });

  // Taxi east or west to runway
  const targetX = targetRunwayEnd === 'West'
    ? -AIRSTRIP.RUNWAY_LENGTH / 2
    : AIRSTRIP.RUNWAY_LENGTH / 2;

  waypoints.push({
    x: targetX,
    y: AIRSTRIP.TAXIWAY_ELEVATION,
    z: AIRSTRIP.TAXIWAY_A_Z,
  });

  // Cross to runway hold-short
  waypoints.push({
    x: targetX,
    y: AIRSTRIP.TAXIWAY_ELEVATION,
    z: -AIRSTRIP.RUNWAY_WIDTH / 2 - 3,
  });

  // Line up on runway
  waypoints.push({
    x: targetX + (targetRunwayEnd === 'West' ? 10 : -10),
    y: AIRSTRIP.RUNWAY_ELEVATION,
    z: 0,
  });

  // Total distance
  let totalDist = 0;
  for (let i = 1; i < waypoints.length; i++) {
    const dx = waypoints[i].x - waypoints[i - 1].x;
    const dz = waypoints[i].z - waypoints[i - 1].z;
    totalDist += Math.sqrt(dx * dx + dz * dz);
  }
  const groundSpeedMs = 4; // 4 m/s taxi speed
  const estimatedTimeS = totalDist / groundSpeedMs;

  return {
    droneId: parkingSpot.fleetIndex,
    from: parkingSpot.id,
    to: targetRunwayEnd === 'West' ? 'CROSS-TAXI-WEST' : 'CROSS-TAXI-EAST',
    waypoints,
    estimatedTimeS,
    currentWaypointIndex: 0,
  };
}

/**
 * Compute landing route from final approach to parking spot.
 */
export function computeLandingRoute(
  parkingSpot: ParkingSpot,
  landedRunwayEnd: 'East' | 'West'
): GroundRoute {
  const waypoints: Vec3[] = [];

  // Start on runway after landing
  const startX = landedRunwayEnd === 'East'
    ? AIRSTRIP.RUNWAY_LENGTH / 2 - 50
    : -AIRSTRIP.RUNWAY_LENGTH / 2 + 50;

  waypoints.push({ x: startX, y: AIRSTRIP.RUNWAY_ELEVATION, z: 0 });

  // Vacate runway at nearest cross-taxi
  const crossX = parkingSpot.position.x > 0
    ? AIRSTRIP.RUNWAY_LENGTH / 2
    : -AIRSTRIP.RUNWAY_LENGTH / 2;

  waypoints.push({ x: crossX, y: AIRSTRIP.RUNWAY_ELEVATION, z: -AIRSTRIP.RUNWAY_WIDTH / 2 - 3 });

  // Taxi on taxiway A to align with parking column
  waypoints.push({
    x: parkingSpot.position.x,
    y: AIRSTRIP.TAXIWAY_ELEVATION,
    z: AIRSTRIP.TAXIWAY_A_Z,
  });

  // Turn into parking row
  waypoints.push({
    x: parkingSpot.position.x,
    y: AIRSTRIP.APRON_ELEVATION,
    z: parkingSpot.position.z,
  });

  let totalDist = 0;
  for (let i = 1; i < waypoints.length; i++) {
    const dx = waypoints[i].x - waypoints[i - 1].x;
    const dz = waypoints[i].z - waypoints[i - 1].z;
    totalDist += Math.sqrt(dx * dx + dz * dz);
  }

  return {
    droneId: parkingSpot.fleetIndex,
    from: landedRunwayEnd === 'East' ? 'CROSS-TAXI-EAST' : 'CROSS-TAXI-WEST',
    to: parkingSpot.id,
    waypoints,
    estimatedTimeS: totalDist / 4,
    currentWaypointIndex: 0,
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// AIRSTRIP STATS — Summary for display panels
// ═══════════════════════════════════════════════════════════════════════════════

export interface AirstripStats {
  totalParkingSpots: number;
  occupiedSpots: number;
  vacantSpots: number;
  chargingSpots: number;
  taxiwaySections: number;
  runwayLengthM: number;
  runwayWidthM: number;
  structureCount: number;
  lightCount: number;
  surfaceMarkingCount: number;
  totalApronAreaM2: number;
}

export function getAirstripStats(world: AirstripWorld): AirstripStats {
  return {
    totalParkingSpots: world.parkingGrid.length,
    occupiedSpots: world.parkingGrid.filter(s => s.occupied).length,
    vacantSpots: world.parkingGrid.filter(s => !s.occupied).length,
    chargingSpots: world.parkingGrid.filter(s => s.hasChargingPad).length,
    taxiwaySections: world.taxiway.edges.length,
    runwayLengthM: AIRSTRIP.RUNWAY_LENGTH,
    runwayWidthM: AIRSTRIP.RUNWAY_WIDTH,
    structureCount: world.structures.length,
    lightCount: world.lights.length,
    surfaceMarkingCount: world.surfaceMarkings.length,
    totalApronAreaM2:
      (AIRSTRIP.APRON_X_EAST - AIRSTRIP.APRON_X_WEST) *
      Math.abs(AIRSTRIP.APRON_Z_SOUTH - AIRSTRIP.APRON_Z_NORTH),
  };
}
