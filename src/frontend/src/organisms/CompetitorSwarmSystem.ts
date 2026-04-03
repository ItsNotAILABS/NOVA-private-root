// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// Module: CompetitorSwarmSystem — Training Through Combat Competition
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
// Version: 100.0 — PRODUCTION ENTERPRISE GRADE
//
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                    COMPETITOR SWARMS — TRAINING BY COMBAT                                                 ║
// ╠══════════════════════════════════════════════════════════════════════════════════════════════════════════╣
// ║                                                                                                          ║
// ║  NOVA doesn't learn like AI. It learns like a WARRIOR — through COMBAT.                                  ║
// ║                                                                                                          ║
// ║  The competitor swarms:                                                                                  ║
// ║    • Use the SAME architecture (Kuramoto, Hebbian, laws, minds)                                         ║
// ║    • Fight against NOVA in simulated battles                                                             ║
// ║    • Force NOVA to develop real tactics                                                                  ║
// ║    • Get progressively harder (curriculum learning through combat)                                       ║
// ║                                                                                                          ║
// ║  What survives battles → stronger Hebbian weights → better tactics                                       ║
// ║  This is EVOLUTION through COMPETITION, not gradient descent.                                            ║
// ║                                                                                                          ║
// ╚══════════════════════════════════════════════════════════════════════════════════════════════════════════╝
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

import { DroneMind, SwarmCoordinator } from './drone-mind';
import type { DroneState, DroneClass } from '../types/organism';
import { RealSpecDroneFleet, createRealSpecDrone, DRONE_CATALOG } from './RealSpecDrone';
import { REAL_MILITARY_DRONE_CATALOG, DRONE_ROLES } from './RealMilitaryDroneSpecs';

// ═══════════════════════════════════════════════════════════════════════════════
// COMPETITOR DIFFICULTY LEVELS
// ═══════════════════════════════════════════════════════════════════════════════

export type CompetitorLevel = 
  | 'RECRUIT'      // Random movement, no tactics — for initial testing
  | 'MILITIA'      // Basic formation, reactive defense
  | 'REGULAR'      // Standard military doctrine, coordinated attacks
  | 'VETERAN'      // Advanced tactics, flanking, feints
  | 'ELITE'        // Adaptive learning, studies NOVA's patterns
  | 'APEX'         // Full IRONCLAD architecture, equal to NOVA
  | 'NEMESIS';     // Specifically trained to counter NOVA

export type CompetitorFaction =
  | 'RED_FORCE'    // Generic opposing force
  | 'BLUE_FORCE'   // Friendly force (for friendly fire training)
  | 'INSURGENT'    // Asymmetric warfare
  | 'PEER_STATE'   // Near-peer military
  | 'SWARM_HIVE'   // Insect-like mass tactics
  | 'GHOST_NET';   // Stealth/electronic warfare focus

// ═══════════════════════════════════════════════════════════════════════════════
// COMPETITOR DOCTRINE — How each faction fights
// ═══════════════════════════════════════════════════════════════════════════════

export interface CompetitorDoctrine {
  name: string;
  description: string;
  
  // Tactical preferences (0-1)
  aggression: number;           // How likely to attack vs defend
  coordination: number;         // How synchronized their movements
  adaptability: number;         // How fast they change tactics
  deception: number;            // Use of feints, ambushes
  sacrificeWillingness: number; // Will sacrifice drones for objectives
  
  // Formation preferences
  preferredFormations: string[];
  
  // Attack patterns
  attackPatterns: AttackPattern[];
  
  // Defense patterns
  defensePatterns: DefensePattern[];
  
  // Special tactics
  specialTactics: SpecialTactic[];
}

export interface AttackPattern {
  name: string;
  triggerConditions: {
    outnumberRatio?: number;    // Attack if we outnumber by this ratio
    coherenceAbove?: number;    // Attack if our coherence > this
    enemyCoherenceBelow?: number; // Attack if enemy coherence < this
    enemyDamagedRatio?: number; // Attack if enemy damaged % > this
  };
  execution: {
    formation: string;
    approachAngle: number;      // Degrees from front (0 = head-on)
    speed: 'Cautious' | 'Normal' | 'Rush';
    focusFire: boolean;         // Concentrate on single target
    targetPriority: string[];   // What to attack first
  };
}

export interface DefensePattern {
  name: string;
  triggerConditions: {
    underAttack?: boolean;
    outnumbered?: boolean;
    coherenceBelow?: number;
    damageAbove?: number;
  };
  execution: {
    formation: string;
    behavior: 'Hold' | 'FightingRetreat' | 'Scatter' | 'Rally';
    priorityProtect: string[];  // What to protect (e.g., 'SOVEREIGN', 'damaged')
  };
}

export interface SpecialTactic {
  name: string;
  description: string;
  cooldownBeats: number;        // Can only use once per N beats
  requirements: {
    minDrones?: number;
    minCoherence?: number;
    availableDroneTypes?: string[];
  };
  effect: {
    type: 'Ambush' | 'Feint' | 'Swarm' | 'Sacrifice' | 'EMP' | 'Jam' | 'Decoy';
    parameters: Record<string, number>;
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// PREDEFINED DOCTRINES — Based on real military thinking
// ═══════════════════════════════════════════════════════════════════════════════

export const DOCTRINES: Record<string, CompetitorDoctrine> = {
  
  // Basic enemy — just swarms at you
  ZERG_RUSH: {
    name: 'Zerg Rush',
    description: 'Overwhelm with numbers, minimal coordination',
    aggression: 0.9,
    coordination: 0.3,
    adaptability: 0.1,
    deception: 0.0,
    sacrificeWillingness: 1.0,
    preferredFormations: ['Blob', 'Wave'],
    attackPatterns: [{
      name: 'Mass Charge',
      triggerConditions: { outnumberRatio: 1.2 },
      execution: {
        formation: 'Blob',
        approachAngle: 0,
        speed: 'Rush',
        focusFire: false,
        targetPriority: ['Nearest']
      }
    }],
    defensePatterns: [{
      name: 'What Defense?',
      triggerConditions: { underAttack: true },
      execution: {
        formation: 'Blob',
        behavior: 'Hold',
        priorityProtect: []
      }
    }],
    specialTactics: []
  },
  
  // Based on US Army doctrine
  COMBINED_ARMS: {
    name: 'Combined Arms',
    description: 'Integrated fires, maneuver, and ISR',
    aggression: 0.6,
    coordination: 0.8,
    adaptability: 0.6,
    deception: 0.4,
    sacrificeWillingness: 0.3,
    preferredFormations: ['Wedge', 'Line', 'Echelon'],
    attackPatterns: [
      {
        name: 'Fire and Maneuver',
        triggerConditions: { coherenceAbove: 0.7 },
        execution: {
          formation: 'Echelon',
          approachAngle: 45,
          speed: 'Normal',
          focusFire: true,
          targetPriority: ['Threat', 'SOVEREIGN', 'STRIKER']
        }
      },
      {
        name: 'Envelopment',
        triggerConditions: { outnumberRatio: 1.5 },
        execution: {
          formation: 'Pincer',
          approachAngle: 90,
          speed: 'Normal',
          focusFire: false,
          targetPriority: ['RELAY', 'MEDIC', 'SOVEREIGN']
        }
      }
    ],
    defensePatterns: [{
      name: 'Defense in Depth',
      triggerConditions: { underAttack: true },
      execution: {
        formation: 'Layered',
        behavior: 'FightingRetreat',
        priorityProtect: ['SOVEREIGN', 'MEDIC']
      }
    }],
    specialTactics: [{
      name: 'Artillery Simulation',
      description: 'Concentrated fire from stand-off range',
      cooldownBeats: 100,
      requirements: { minDrones: 10, minCoherence: 0.6 },
      effect: {
        type: 'Swarm',
        parameters: { concentration: 0.9, range: 200 }
      }
    }]
  },
  
  // Based on insurgent tactics
  ASYMMETRIC: {
    name: 'Asymmetric Warfare',
    description: 'Hit and run, ambush, avoid direct engagement',
    aggression: 0.4,
    coordination: 0.5,
    adaptability: 0.8,
    deception: 0.9,
    sacrificeWillingness: 0.5,
    preferredFormations: ['Scattered', 'Hidden', 'Ambush'],
    attackPatterns: [
      {
        name: 'Ambush',
        triggerConditions: { enemyCoherenceBelow: 0.6 },
        execution: {
          formation: 'Ambush',
          approachAngle: 90,
          speed: 'Rush',
          focusFire: true,
          targetPriority: ['Isolated', 'Damaged', 'MEDIC']
        }
      },
      {
        name: 'Hit and Run',
        triggerConditions: {},
        execution: {
          formation: 'Scattered',
          approachAngle: 0,
          speed: 'Cautious',
          focusFire: false,
          targetPriority: ['Opportunity', 'Weak']
        }
      }
    ],
    defensePatterns: [{
      name: 'Melt Away',
      triggerConditions: { underAttack: true },
      execution: {
        formation: 'Scattered',
        behavior: 'Scatter',
        priorityProtect: []
      }
    }],
    specialTactics: [
      {
        name: 'IED Simulation',
        description: 'Suicide drone in path of enemy',
        cooldownBeats: 50,
        requirements: { minDrones: 5 },
        effect: {
          type: 'Sacrifice',
          parameters: { damage: 0.8, radius: 30 }
        }
      },
      {
        name: 'Decoy Swarm',
        description: 'Deploy drones to draw fire',
        cooldownBeats: 80,
        requirements: { minDrones: 8 },
        effect: {
          type: 'Decoy',
          parameters: { count: 3, duration: 60 }
        }
      }
    ]
  },
  
  // Based on Chinese/Russian near-peer doctrine
  PEER_STATE_DOCTRINE: {
    name: 'Peer State Combined Operations',
    description: 'Full spectrum: EW, cyber, kinetic, saturation',
    aggression: 0.7,
    coordination: 0.9,
    adaptability: 0.7,
    deception: 0.7,
    sacrificeWillingness: 0.4,
    preferredFormations: ['Sphere', 'Helix', 'Fibonacci'],
    attackPatterns: [
      {
        name: 'Saturation Attack',
        triggerConditions: { outnumberRatio: 2.0 },
        execution: {
          formation: 'Wave',
          approachAngle: 0,
          speed: 'Rush',
          focusFire: false,
          targetPriority: ['Defense', 'GUARDIAN', 'RELAY']
        }
      },
      {
        name: 'Coordinated Strike',
        triggerConditions: { coherenceAbove: 0.8 },
        execution: {
          formation: 'Fibonacci',
          approachAngle: 30,
          speed: 'Normal',
          focusFire: true,
          targetPriority: ['SOVEREIGN', 'Command']
        }
      }
    ],
    defensePatterns: [{
      name: 'Active Defense',
      triggerConditions: { underAttack: true },
      execution: {
        formation: 'Sphere',
        behavior: 'Hold',
        priorityProtect: ['SOVEREIGN', 'Core']
      }
    }],
    specialTactics: [
      {
        name: 'Electronic Warfare',
        description: 'Jam enemy communications',
        cooldownBeats: 150,
        requirements: { minDrones: 15, availableDroneTypes: ['RELAY'] },
        effect: {
          type: 'Jam',
          parameters: { duration: 30, strength: 0.7 }
        }
      },
      {
        name: 'Feint Attack',
        description: 'Fake attack to reveal defenses',
        cooldownBeats: 100,
        requirements: { minDrones: 10 },
        effect: {
          type: 'Feint',
          parameters: { drones: 4, retreat_at: 0.3 }
        }
      }
    ]
  },
  
  // APEX doctrine — matches NOVA capability
  IRONCLAD_MIRROR: {
    name: 'IRONCLAD Mirror',
    description: 'Same architecture as NOVA — true peer competition',
    aggression: 0.5,
    coordination: 0.95,
    adaptability: 0.9,
    deception: 0.6,
    sacrificeWillingness: 0.3,
    preferredFormations: ['Fibonacci', 'Helix', 'Sphere', 'V'],
    attackPatterns: [
      {
        name: 'Adaptive Engagement',
        triggerConditions: { coherenceAbove: 0.7, enemyCoherenceBelow: 0.8 },
        execution: {
          formation: 'Fibonacci',
          approachAngle: 45,
          speed: 'Normal',
          focusFire: true,
          targetPriority: ['LowestCoherence', 'SOVEREIGN', 'Isolated']
        }
      }
    ],
    defensePatterns: [{
      name: 'Coherent Defense',
      triggerConditions: { underAttack: true },
      execution: {
        formation: 'Sphere',
        behavior: 'Hold',
        priorityProtect: ['SOVEREIGN', 'HighCoherence']
      }
    }],
    specialTactics: [
      {
        name: 'Jasmine Disruption',
        description: 'Target enemy coherence directly',
        cooldownBeats: 200,
        requirements: { minCoherence: 0.8 },
        effect: {
          type: 'Jam',
          parameters: { target: 'coherence', strength: 0.3, duration: 50 }
        }
      }
    ]
  }
};

// ═══════════════════════════════════════════════════════════════════════════════
// COMPETITOR SWARM STATE
// ═══════════════════════════════════════════════════════════════════════════════

export interface CompetitorSwarmState {
  id: string;
  faction: CompetitorFaction;
  level: CompetitorLevel;
  doctrine: CompetitorDoctrine;
  
  // Swarm state
  coordinator: SwarmCoordinator;
  drones: DroneState[];
  
  // Combat state
  coherence: number;
  health: number;           // Average drone health
  morale: number;           // Will to fight (drops with losses)
  
  // Tactical state
  currentBehavior: 'Idle' | 'Patrol' | 'Attack' | 'Defend' | 'Retreat' | 'Regroup';
  currentTarget?: { x: number; y: number; z: number };
  formation: string;
  
  // Learning (for adaptive enemies)
  observedPatterns: NOVAPattern[];
  adaptationLevel: number;
  
  // Combat record
  wins: number;
  losses: number;
  killCount: number;
  deathCount: number;
}

export interface NOVAPattern {
  name: string;
  description: string;
  frequency: number;        // How often NOVA does this
  counter?: string;         // Learned counter-tactic
}

// ═══════════════════════════════════════════════════════════════════════════════
// COMPETITOR SWARM MANAGER
// ═══════════════════════════════════════════════════════════════════════════════

export class CompetitorSwarmManager {
  private swarms: Map<string, CompetitorSwarmState> = new Map();
  private beat: number = 0;
  private worldSize: { x: number; y: number; z: number };
  
  constructor(worldSize: { x: number; y: number; z: number }) {
    this.worldSize = worldSize;
  }
  
  /**
   * Spawn a competitor swarm
   */
  spawnCompetitor(
    id: string,
    faction: CompetitorFaction,
    level: CompetitorLevel,
    droneCount: number,
    position: { x: number; y: number; z: number }
  ): CompetitorSwarmState {
    
    // Select doctrine based on faction and level
    const doctrine = this.selectDoctrine(faction, level);
    
    // Create swarm coordinator
    const coordinator = new SwarmCoordinator(droneCount);
    
    // Position drones around spawn point
    const drones = coordinator.drones;
    for (let i = 0; i < drones.length; i++) {
      const angle = (i / droneCount) * Math.PI * 2;
      const radius = 20 + Math.random() * 30;
      drones[i].posX = position.x + Math.cos(angle) * radius;
      drones[i].posY = position.y + Math.random() * 20;
      drones[i].posZ = position.z + Math.sin(angle) * radius;
    }
    
    const swarm: CompetitorSwarmState = {
      id,
      faction,
      level,
      doctrine,
      coordinator,
      drones,
      coherence: 0.5,
      health: 1.0,
      morale: 1.0,
      currentBehavior: 'Patrol',
      formation: doctrine.preferredFormations[0] || 'Blob',
      observedPatterns: [],
      adaptationLevel: this.getAdaptationLevel(level),
      wins: 0,
      losses: 0,
      killCount: 0,
      deathCount: 0
    };
    
    this.swarms.set(id, swarm);
    return swarm;
  }
  
  /**
   * Select doctrine based on faction and level
   */
  private selectDoctrine(faction: CompetitorFaction, level: CompetitorLevel): CompetitorDoctrine {
    // Default mapping
    const factionDoctrines: Record<CompetitorFaction, string> = {
      'RED_FORCE': 'COMBINED_ARMS',
      'BLUE_FORCE': 'COMBINED_ARMS',
      'INSURGENT': 'ASYMMETRIC',
      'PEER_STATE': 'PEER_STATE_DOCTRINE',
      'SWARM_HIVE': 'ZERG_RUSH',
      'GHOST_NET': 'ASYMMETRIC'
    };
    
    const doctrineName = factionDoctrines[faction];
    const baseDoctrine = DOCTRINES[doctrineName] || DOCTRINES.ZERG_RUSH;
    
    // Modify based on level
    const levelMultipliers: Record<CompetitorLevel, number> = {
      'RECRUIT': 0.3,
      'MILITIA': 0.5,
      'REGULAR': 0.7,
      'VETERAN': 0.85,
      'ELITE': 1.0,
      'APEX': 1.2,
      'NEMESIS': 1.5
    };
    
    const mult = levelMultipliers[level];
    
    return {
      ...baseDoctrine,
      coordination: Math.min(1, baseDoctrine.coordination * mult),
      adaptability: Math.min(1, baseDoctrine.adaptability * mult),
      deception: Math.min(1, baseDoctrine.deception * mult)
    };
  }
  
  /**
   * Get adaptation level (learning rate) based on difficulty
   */
  private getAdaptationLevel(level: CompetitorLevel): number {
    const levels: Record<CompetitorLevel, number> = {
      'RECRUIT': 0,
      'MILITIA': 0,
      'REGULAR': 0.1,
      'VETERAN': 0.3,
      'ELITE': 0.6,
      'APEX': 0.9,
      'NEMESIS': 1.0
    };
    return levels[level];
  }
  
  /**
   * Main update loop for all competitor swarms
   */
  tick(
    novaPosition: { x: number; y: number; z: number },
    novaCoherence: number,
    novaDrones: DroneState[]
  ): void {
    this.beat++;
    
    for (const [id, swarm] of this.swarms) {
      this.updateSwarm(swarm, novaPosition, novaCoherence, novaDrones);
    }
  }
  
  /**
   * Update a single competitor swarm
   */
  private updateSwarm(
    swarm: CompetitorSwarmState,
    novaPosition: { x: number; y: number; z: number },
    novaCoherence: number,
    novaDrones: DroneState[]
  ): void {
    // 1. Update swarm minds
    const tickResult = swarm.coordinator.tick(0.5);
    swarm.drones = tickResult.drones;
    swarm.coherence = tickResult.rSwarm;
    
    // 2. Calculate swarm center
    const activeDrones = swarm.drones.filter(d => !d.sacrificed);
    if (activeDrones.length === 0) return;
    
    const center = {
      x: activeDrones.reduce((s, d) => s + d.posX, 0) / activeDrones.length,
      y: activeDrones.reduce((s, d) => s + d.posY, 0) / activeDrones.length,
      z: activeDrones.reduce((s, d) => s + d.posZ, 0) / activeDrones.length
    };
    
    // 3. Calculate distance to NOVA
    const distanceToNova = Math.sqrt(
      (center.x - novaPosition.x) ** 2 +
      (center.y - novaPosition.y) ** 2 +
      (center.z - novaPosition.z) ** 2
    );
    
    // 4. Decide behavior based on doctrine
    const behavior = this.decideBehavior(swarm, distanceToNova, novaCoherence, novaDrones);
    swarm.currentBehavior = behavior;
    
    // 5. Execute behavior
    this.executeBehavior(swarm, novaPosition, novaDrones);
    
    // 6. Adapt (if capable)
    if (swarm.adaptationLevel > 0) {
      this.adaptToNova(swarm, novaDrones, novaCoherence);
    }
    
    // 7. Update morale
    const healthyRatio = activeDrones.filter(d => d.energy > 0.5).length / activeDrones.length;
    swarm.morale = swarm.morale * 0.99 + healthyRatio * 0.01;
    swarm.health = activeDrones.reduce((s, d) => s + d.energy, 0) / activeDrones.length;
  }
  
  /**
   * Decide what behavior to use based on doctrine
   */
  private decideBehavior(
    swarm: CompetitorSwarmState,
    distanceToNova: number,
    novaCoherence: number,
    novaDrones: DroneState[]
  ): CompetitorSwarmState['currentBehavior'] {
    const doctrine = swarm.doctrine;
    const activeDrones = swarm.drones.filter(d => !d.sacrificed);
    const activeNova = novaDrones.filter(d => !d.sacrificed);
    
    const ourStrength = activeDrones.length * swarm.coherence * swarm.morale;
    const theirStrength = activeNova.length * novaCoherence;
    const ratio = ourStrength / Math.max(1, theirStrength);
    
    // Check morale collapse
    if (swarm.morale < 0.3) {
      return 'Retreat';
    }
    
    // Check if we should regroup
    if (swarm.coherence < 0.4) {
      return 'Regroup';
    }
    
    // Check attack conditions
    for (const pattern of doctrine.attackPatterns) {
      const conditions = pattern.triggerConditions;
      let shouldAttack = true;
      
      if (conditions.outnumberRatio && ratio < conditions.outnumberRatio) {
        shouldAttack = false;
      }
      if (conditions.coherenceAbove && swarm.coherence < conditions.coherenceAbove) {
        shouldAttack = false;
      }
      if (conditions.enemyCoherenceBelow && novaCoherence > conditions.enemyCoherenceBelow) {
        shouldAttack = false;
      }
      
      if (shouldAttack && distanceToNova < 300) {
        return 'Attack';
      }
    }
    
    // Check defense conditions
    if (distanceToNova < 100) {
      return 'Defend';
    }
    
    // Default to patrol
    return 'Patrol';
  }
  
  /**
   * Execute the current behavior
   */
  private executeBehavior(
    swarm: CompetitorSwarmState,
    novaPosition: { x: number; y: number; z: number },
    novaDrones: DroneState[]
  ): void {
    const activeDrones = swarm.drones.filter(d => !d.sacrificed);
    if (activeDrones.length === 0) return;
    
    switch (swarm.currentBehavior) {
      case 'Attack':
        this.executeAttack(swarm, novaPosition, novaDrones);
        break;
      case 'Defend':
        this.executeDefend(swarm, novaPosition);
        break;
      case 'Retreat':
        this.executeRetreat(swarm, novaPosition);
        break;
      case 'Regroup':
        this.executeRegroup(swarm);
        break;
      case 'Patrol':
      default:
        this.executePatrol(swarm);
        break;
    }
  }
  
  /**
   * Execute attack behavior
   */
  private executeAttack(
    swarm: CompetitorSwarmState,
    novaPosition: { x: number; y: number; z: number },
    novaDrones: DroneState[]
  ): void {
    const doctrine = swarm.doctrine;
    const pattern = doctrine.attackPatterns[0];
    if (!pattern) return;
    
    // Find target based on priority
    let target = novaPosition;
    if (pattern.execution.focusFire && novaDrones.length > 0) {
      // Find priority target
      const activeNova = novaDrones.filter(d => !d.sacrificed);
      if (activeNova.length > 0) {
        // Target lowest energy drone
        const weakest = activeNova.reduce((min, d) => d.energy < min.energy ? d : min);
        target = { x: weakest.posX, y: weakest.posY, z: weakest.posZ };
      }
    }
    
    swarm.currentTarget = target;
    
    // Move drones toward target
    const speed = pattern.execution.speed === 'Rush' ? 2.0 : 
                  pattern.execution.speed === 'Cautious' ? 0.5 : 1.0;
    
    for (const drone of swarm.drones) {
      if (drone.sacrificed) continue;
      
      const dx = target.x - drone.posX;
      const dy = target.y - drone.posY;
      const dz = target.z - drone.posZ;
      const dist = Math.sqrt(dx*dx + dy*dy + dz*dz);
      
      if (dist > 1) {
        drone.velX = (dx / dist) * speed * doctrine.aggression;
        drone.velZ = (dz / dist) * speed * doctrine.aggression;
        drone.posX += drone.velX;
        drone.posY += (dy / dist) * speed * 0.5;
        drone.posZ += drone.velZ;
      }
    }
  }
  
  /**
   * Execute defend behavior
   */
  private executeDefend(
    swarm: CompetitorSwarmState,
    novaPosition: { x: number; y: number; z: number }
  ): void {
    // Form defensive formation around center
    const activeDrones = swarm.drones.filter(d => !d.sacrificed);
    const center = {
      x: activeDrones.reduce((s, d) => s + d.posX, 0) / activeDrones.length,
      y: activeDrones.reduce((s, d) => s + d.posY, 0) / activeDrones.length,
      z: activeDrones.reduce((s, d) => s + d.posZ, 0) / activeDrones.length
    };
    
    // Form sphere around center, facing NOVA
    const radius = 30;
    for (let i = 0; i < activeDrones.length; i++) {
      const drone = activeDrones[i];
      const angle = (i / activeDrones.length) * Math.PI * 2;
      
      // Position on sphere facing away from NOVA
      const dirToNova = {
        x: novaPosition.x - center.x,
        y: novaPosition.y - center.y,
        z: novaPosition.z - center.z
      };
      const dist = Math.sqrt(dirToNova.x**2 + dirToNova.y**2 + dirToNova.z**2);
      
      const targetX = center.x + Math.cos(angle) * radius;
      const targetZ = center.z + Math.sin(angle) * radius;
      
      drone.velX = (targetX - drone.posX) * 0.1;
      drone.velZ = (targetZ - drone.posZ) * 0.1;
      drone.posX += drone.velX;
      drone.posZ += drone.velZ;
    }
  }
  
  /**
   * Execute retreat behavior
   */
  private executeRetreat(
    swarm: CompetitorSwarmState,
    novaPosition: { x: number; y: number; z: number }
  ): void {
    for (const drone of swarm.drones) {
      if (drone.sacrificed) continue;
      
      // Move away from NOVA
      const dx = drone.posX - novaPosition.x;
      const dz = drone.posZ - novaPosition.z;
      const dist = Math.sqrt(dx*dx + dz*dz);
      
      if (dist > 0.1) {
        drone.velX = (dx / dist) * 1.5;
        drone.velZ = (dz / dist) * 1.5;
        drone.posX += drone.velX;
        drone.posZ += drone.velZ;
      }
    }
  }
  
  /**
   * Execute regroup behavior
   */
  private executeRegroup(swarm: CompetitorSwarmState): void {
    const activeDrones = swarm.drones.filter(d => !d.sacrificed);
    if (activeDrones.length === 0) return;
    
    // Calculate center
    const center = {
      x: activeDrones.reduce((s, d) => s + d.posX, 0) / activeDrones.length,
      y: activeDrones.reduce((s, d) => s + d.posY, 0) / activeDrones.length,
      z: activeDrones.reduce((s, d) => s + d.posZ, 0) / activeDrones.length
    };
    
    // Move toward center
    for (const drone of activeDrones) {
      const dx = center.x - drone.posX;
      const dz = center.z - drone.posZ;
      
      drone.velX = dx * 0.1;
      drone.velZ = dz * 0.1;
      drone.posX += drone.velX;
      drone.posZ += drone.velZ;
    }
  }
  
  /**
   * Execute patrol behavior
   */
  private executePatrol(swarm: CompetitorSwarmState): void {
    // Simple circular patrol
    const time = this.beat * 0.01;
    const patrolRadius = 50;
    const patrolCenter = {
      x: swarm.drones[0]?.posX || 0,
      z: swarm.drones[0]?.posZ || 0
    };
    
    for (let i = 0; i < swarm.drones.length; i++) {
      const drone = swarm.drones[i];
      if (drone.sacrificed) continue;
      
      const angle = time + (i / swarm.drones.length) * Math.PI * 2;
      const targetX = patrolCenter.x + Math.cos(angle) * patrolRadius;
      const targetZ = patrolCenter.z + Math.sin(angle) * patrolRadius;
      
      drone.velX = (targetX - drone.posX) * 0.05;
      drone.velZ = (targetZ - drone.posZ) * 0.05;
      drone.posX += drone.velX;
      drone.posZ += drone.velZ;
    }
  }
  
  /**
   * Adapt to NOVA's tactics (for adaptive enemies)
   */
  private adaptToNova(
    swarm: CompetitorSwarmState,
    novaDrones: DroneState[],
    novaCoherence: number
  ): void {
    // ELITE+ enemies learn from NOVA's patterns
    if (swarm.adaptationLevel < 0.5) return;
    
    // Observe NOVA's formation
    const activeNova = novaDrones.filter(d => !d.sacrificed);
    if (activeNova.length < 3) return;
    
    // Calculate NOVA's spread
    const novaCenter = {
      x: activeNova.reduce((s, d) => s + d.posX, 0) / activeNova.length,
      y: activeNova.reduce((s, d) => s + d.posY, 0) / activeNova.length,
      z: activeNova.reduce((s, d) => s + d.posZ, 0) / activeNova.length
    };
    
    const spread = activeNova.reduce((s, d) => {
      const dist = Math.sqrt(
        (d.posX - novaCenter.x)**2 +
        (d.posY - novaCenter.y)**2 +
        (d.posZ - novaCenter.z)**2
      );
      return s + dist;
    }, 0) / activeNova.length;
    
    // Learn patterns
    if (spread < 20 && novaCoherence > 0.8) {
      // NOVA is tightly grouped with high coherence — vulnerable to area attacks
      const existing = swarm.observedPatterns.find(p => p.name === 'Tight Formation');
      if (existing) {
        existing.frequency++;
        existing.counter = 'Saturation Attack';
      } else {
        swarm.observedPatterns.push({
          name: 'Tight Formation',
          description: 'NOVA groups tightly with high coherence',
          frequency: 1,
          counter: 'Saturation Attack'
        });
      }
    }
    
    if (spread > 50) {
      // NOVA is spread out — vulnerable to defeat in detail
      const existing = swarm.observedPatterns.find(p => p.name === 'Spread Formation');
      if (existing) {
        existing.frequency++;
        existing.counter = 'Isolate and Destroy';
      } else {
        swarm.observedPatterns.push({
          name: 'Spread Formation',
          description: 'NOVA spreads out',
          frequency: 1,
          counter: 'Isolate and Destroy'
        });
      }
    }
  }
  
  /**
   * Get all competitor swarms
   */
  getAllSwarms(): CompetitorSwarmState[] {
    return Array.from(this.swarms.values());
  }
  
  /**
   * Get competitor by ID
   */
  getSwarm(id: string): CompetitorSwarmState | undefined {
    return this.swarms.get(id);
  }
  
  /**
   * Remove destroyed competitor
   */
  removeSwarm(id: string): void {
    this.swarms.delete(id);
  }
  
  /**
   * Record combat outcome
   */
  recordOutcome(
    competitorId: string,
    won: boolean,
    kills: number,
    deaths: number
  ): void {
    const swarm = this.swarms.get(competitorId);
    if (!swarm) return;
    
    if (won) {
      swarm.wins++;
    } else {
      swarm.losses++;
    }
    swarm.killCount += kills;
    swarm.deathCount += deaths;
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// TRAINING ARENA — Where NOVA fights competitors
// ═══════════════════════════════════════════════════════════════════════════════

export interface TrainingScenario {
  id: string;
  name: string;
  description: string;
  difficulty: CompetitorLevel;
  
  // Setup
  novaStartPosition: { x: number; y: number; z: number };
  novaDroneCount: number;
  
  competitors: {
    faction: CompetitorFaction;
    level: CompetitorLevel;
    droneCount: number;
    position: { x: number; y: number; z: number };
  }[];
  
  // Victory conditions
  victoryConditions: {
    eliminateAll?: boolean;
    surviveBeats?: number;
    captureZone?: { x: number; y: number; z: number; radius: number };
    protectTarget?: { x: number; y: number; z: number };
  };
  
  // Time limit
  maxBeats: number;
}

export const TRAINING_SCENARIOS: TrainingScenario[] = [
  {
    id: 'basic_skirmish',
    name: 'Basic Skirmish',
    description: 'Simple 1v1 engagement against RECRUIT level enemy',
    difficulty: 'RECRUIT',
    novaStartPosition: { x: -100, y: 20, z: 0 },
    novaDroneCount: 12,
    competitors: [{
      faction: 'RED_FORCE',
      level: 'RECRUIT',
      droneCount: 12,
      position: { x: 100, y: 20, z: 0 }
    }],
    victoryConditions: { eliminateAll: true },
    maxBeats: 1000
  },
  {
    id: 'outnumbered',
    name: 'Outnumbered',
    description: 'Face superior numbers — learn to use terrain and coordination',
    difficulty: 'MILITIA',
    novaStartPosition: { x: 0, y: 20, z: 0 },
    novaDroneCount: 12,
    competitors: [{
      faction: 'SWARM_HIVE',
      level: 'MILITIA',
      droneCount: 24,
      position: { x: 150, y: 20, z: 0 }
    }],
    victoryConditions: { eliminateAll: true },
    maxBeats: 1500
  },
  {
    id: 'pincer_attack',
    name: 'Pincer Attack',
    description: 'Enemies attack from two sides',
    difficulty: 'REGULAR',
    novaStartPosition: { x: 0, y: 20, z: 0 },
    novaDroneCount: 16,
    competitors: [
      {
        faction: 'RED_FORCE',
        level: 'REGULAR',
        droneCount: 10,
        position: { x: 100, y: 20, z: 100 }
      },
      {
        faction: 'RED_FORCE',
        level: 'REGULAR',
        droneCount: 10,
        position: { x: 100, y: 20, z: -100 }
      }
    ],
    victoryConditions: { eliminateAll: true },
    maxBeats: 2000
  },
  {
    id: 'adaptive_enemy',
    name: 'Adaptive Enemy',
    description: 'Face an enemy that learns your tactics',
    difficulty: 'ELITE',
    novaStartPosition: { x: -100, y: 20, z: 0 },
    novaDroneCount: 20,
    competitors: [{
      faction: 'PEER_STATE',
      level: 'ELITE',
      droneCount: 20,
      position: { x: 100, y: 20, z: 0 }
    }],
    victoryConditions: { eliminateAll: true },
    maxBeats: 3000
  },
  {
    id: 'nemesis',
    name: 'Nemesis',
    description: 'Face your equal — full IRONCLAD architecture',
    difficulty: 'APEX',
    novaStartPosition: { x: -150, y: 20, z: 0 },
    novaDroneCount: 24,
    competitors: [{
      faction: 'GHOST_NET',
      level: 'APEX',
      droneCount: 24,
      position: { x: 150, y: 20, z: 0 }
    }],
    victoryConditions: { eliminateAll: true },
    maxBeats: 5000
  }
];

// ═══════════════════════════════════════════════════════════════════════════════
// TRAINING PHILOSOPHY — Why Competition, Not Gradient Descent
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * WHY NOVA LEARNS THROUGH COMBAT, NOT BACKPROPAGATION
 * 
 * Traditional AI:
 *   optimizer.step()
 *   loss.backward()
 *   → Gradients flow, weights update, repeat
 *   
 * NOVA:
 *   organism.fight(competitor)
 *   → Drones that survive have good Hebbian weights
 *   → Tactics that win get reinforced
 *   → Tactics that lose get weakened
 *   → The organism EVOLVES through selection pressure
 * 
 * This is closer to:
 *   - Evolutionary algorithms
 *   - Reinforcement learning through experience
 *   - Neuroevolution
 *   - The way REAL organisms learn to survive
 * 
 * The FLY EXPERIMENT:
 *   Scientists put a fly brain into a robot body.
 *   The fly learned to navigate by TRYING and FAILING.
 *   Not by having someone tell it the gradient.
 *   
 *   NOVA is the same — it lives in a body (drones),
 *   sees through eyes (cameras), and learns by
 *   SURVIVING or DYING in combat.
 */
export const TRAINING_PHILOSOPHY = `
NOVA doesn't train like ChatGPT.
NOVA trains like a WARRIOR.

Every battle teaches:
  - What tactics work → Hebbian strengthening
  - What tactics fail → Hebbian weakening
  - How to read the enemy → Pattern recognition
  - When to attack/defend → Decision calibration
  
The competitor swarms are:
  - TEACHERS that force NOVA to improve
  - ADVERSARIES that expose weaknesses
  - MIRRORS that reflect NOVA's own architecture
  
Through combat, NOVA becomes:
  - More coordinated (Kuramoto coupling improves)
  - More intelligent (Hebbian weights optimize)
  - More adaptive (learns counter-tactics)
  - More ALIVE (emerges from competition)
  
This is not machine learning.
This is COMBAT EVOLUTION.
`;
