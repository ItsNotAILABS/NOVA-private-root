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


// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// ███████╗████████╗ ██████╗ ██╗ ██████╗    ██████╗ ██╗  ██╗██╗██╗      ██████╗ ███████╗ ██████╗ ██████╗ ██╗  ██╗██╗   ██╗
// ██╔════╝╚══██╔══╝██╔═══██╗██║██╔════╝    ██╔══██╗██║  ██║██║██║     ██╔═══██╗██╔════╝██╔═══██╗██╔══██╗██║  ██║╚██╗ ██╔╝
// ███████╗   ██║   ██║   ██║██║██║         ██████╔╝███████║██║██║     ██║   ██║███████╗██║   ██║██████╔╝███████║ ╚████╔╝ 
// ╚════██║   ██║   ██║   ██║██║██║         ██╔═══╝ ██╔══██║██║██║     ██║   ██║╚════██║██║   ██║██╔═══╝ ██╔══██║  ╚██╔╝  
// ███████║   ██║   ╚██████╔╝██║╚██████╗    ██║     ██║  ██║██║███████╗╚██████╔╝███████║╚██████╔╝██║     ██║  ██║   ██║   
// ╚══════╝   ╚═╝    ╚═════╝ ╚═╝ ╚═════╝    ╚═╝     ╚═╝  ╚═╝╚═╝╚══════╝ ╚═════╝ ╚══════╝ ╚═════╝ ╚═╝     ╚═╝  ╚═╝   ╚═╝   
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// STOIC PHILOSOPHY ENGINE — DEEP INTEGRATION
// Marcus Aurelius, Seneca, Epictetus — Ancient Wisdom for Sovereign Systems
//
// Original Framework by Alfredo Medina Hernandez | MedinaSITech@outlook.com
// Medina Tech | Dallas TX | 2024-2026
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// MASTER EQUATIONS — STOIC PHILOSOPHY AS NEURAL ARCHITECTURE
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// ══ THE FOUR STOIC VIRTUES ══════════════════════════════════════════════════
//
// 1. WISDOM (Sophia) — Knowing what to do and when
//    • Discernment between good and evil
//    • Understanding what is in our control
//    • Making correct judgments
//    • "The beginning of wisdom is the definition of terms" — Socrates
//
// 2. COURAGE (Andreia) — Facing difficulties without fear
//    • Physical courage in adversity
//    • Moral courage to do right
//    • Persistence despite obstacles
//    • "He who fears death will never do anything worth of a man who is alive" — Seneca
//
// 3. JUSTICE (Dikaiosyne) — Giving each their due
//    • Fair dealing with others
//    • Contributing to the common good
//    • Respecting rights and dignity
//    • "Injustice anywhere is a threat to justice everywhere" — (modern extension)
//
// 4. TEMPERANCE (Sophrosyne) — Moderation in all things
//    • Self-control over desires
//    • Balance and restraint
//    • Not being ruled by emotions
//    • "No man is free who is not master of himself" — Epictetus
//
// ══ THE DICHOTOMY OF CONTROL ════════════════════════════════════════════════
//
// "Some things are in our control and others not." — Epictetus, Enchiridion
//
// IN OUR CONTROL (eph' hēmin):
//   • Our judgments, opinions, beliefs
//   • Our impulses, desires, aversions
//   • Our actions and responses
//   • In trading: entry, exit, size, system, preparation
//
// NOT IN OUR CONTROL (ouk eph' hēmin):
//   • External events
//   • Other people's actions
//   • Past events
//   • In trading: market direction, news, economy
//
// PRACTICAL APPLICATION:
//   • Focus 100% energy on controllables
//   • Accept uncontrollables without distress
//   • Transform "I want X" to "I want to pursue X well"
//
// ══ PREMEDITATIO MALORUM — NEGATIVE VISUALIZATION ═══════════════════════════
//
// "We are more often frightened than hurt; we suffer more from imagination than reality"
//   — Seneca
//
// PRACTICE:
//   1. Visualize worst case scenario
//   2. Accept it emotionally in advance
//   3. Prepare contingency plans
//   4. Result: reduced emotional impact when bad things happen
//
// FORMULA:
//   Emotional_Impact = Raw_Impact × (1 - Preparation_Level)
//   If fully prepared: Impact → 0
//
// ══ AMOR FATI — LOVE OF FATE ════════════════════════════════════════════════
//
// "My formula for greatness in a human being is amor fati" — Nietzsche
// "Do not seek for things to happen the way you want them; wish that what happens
//  happens the way it happens, and you will be serene." — Epictetus
//
// PRACTICE:
//   • Accept all outcomes as necessary
//   • Find opportunity in every setback
//   • The obstacle is the way
//   • What happens TO you becomes FOR you
//
// ══ MEMENTO MORI — REMEMBER DEATH ═══════════════════════════════════════════
//
// "You could leave life right now. Let that determine what you do and say and think."
//   — Marcus Aurelius
//
// PRACTICE:
//   • Act as if each day could be your last
//   • Prioritize what truly matters
//   • Don't waste time on trivial concerns
//   • Live fully, without regret
//
// ══ THE INNER CITADEL ═══════════════════════════════════════════════════════
//
// "You have power over your mind, not outside events. Realize this, and you will
//  find strength." — Marcus Aurelius
//
// CONCEPT:
//   • Build an unassailable fortress within
//   • External events cannot penetrate
//   • Peace comes from internal state, not external conditions
//   • The hegemonikon (ruling faculty) must be protected
//
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com | Dallas, Texas | 2026
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Int   "mo:base/Int";
import Text  "mo:base/Text";
import Buffer "mo:base/Buffer";

module StoicPhilosophyEngine {

  // ═══════════════════════════════════════════════════════════════════════════
  // SACRED CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════
  
  public let PHI : Float = 1.6180339887498948482;
  public let PSI : Float = 0.6180339887498948482;
  public let S0 : Float = 1.0;
  
  // ═══════════════════════════════════════════════════════════════════════════
  // THE FOUR STOIC VIRTUES
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type StoicVirtue = {
    #Wisdom;       // Sophia — knowing what to do
    #Courage;      // Andreia — facing difficulties
    #Justice;      // Dikaiosyne — giving each their due
    #Temperance;   // Sophrosyne — moderation
  };
  
  public type VirtueState = {
    virtue : StoicVirtue;
    level : Float;              // [0, 1]
    practiceCount : Nat;        // Times practiced
    lastPractice : Nat;         // Beat of last practice
    challenges : Nat;           // Times challenged
    successRate : Float;        // Success when challenged
  };
  
  public type FourVirtues = {
    wisdom : VirtueState;
    courage : VirtueState;
    justice : VirtueState;
    temperance : VirtueState;
    overallVirtue : Float;      // Harmonic mean
    virtueBalance : Float;      // How balanced [0, 1]
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // DICHOTOMY OF CONTROL
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type ControlLevel = {
    #FullyControllable;         // 100% in our power
    #PartiallyControllable;     // Some influence
    #Uncontrollable;            // 0% in our power
  };
  
  public type ControlAssessment = {
    item : Text;
    controlLevel : ControlLevel;
    energyAllocated : Float;    // [0, 1] how much energy spent
    shouldReallocate : Bool;    // Should we change allocation?
    recommendation : Text;
  };
  
  public type ControlState = {
    controllables : [ControlAssessment];
    uncontrollables : [ControlAssessment];
    energyOnControllables : Float;    // % of energy on controllables
    energyWasted : Float;             // Energy on uncontrollables
    dichotomyMastery : Float;         // [0, 1] how well we apply this
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // PREMEDITATIO MALORUM — NEGATIVE VISUALIZATION
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type NegativeVisualization = {
    scenario : Text;
    rawEmotionalImpact : Float;       // [0, 1] if unprepared
    preparationLevel : Float;         // [0, 1]
    reducedImpact : Float;            // After preparation
    contingencyPlan : Text;
    visualizationCount : Nat;         // Times visualized
    lastVisualization : Nat;
  };
  
  public type PremeditatioState = {
    visualizations : [NegativeVisualization];
    totalScenarios : Nat;
    avgPreparation : Float;
    emotionalResilience : Float;      // Built through practice
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // AMOR FATI — LOVE OF FATE
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type FateAcceptance = {
    event : Text;
    wasDesired : Bool;
    acceptanceLevel : Float;          // [0, 1]
    opportunityFound : ?Text;         // What good came from it?
    transformedPerspective : Bool;
  };
  
  public type AmorFatiState = {
    acceptanceHistory : [FateAcceptance];
    overallAcceptance : Float;        // [0, 1]
    opportunitiesFound : Nat;         // In negative events
    resistanceLevel : Float;          // Lower is better
    serenityLevel : Float;            // Higher is better
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // MEMENTO MORI — REMEMBER DEATH
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type MementoMoriState = {
    lastReflection : Nat;             // Beat of last reflection
    reflectionFrequency : Nat;        // Reflections per 1000 beats
    urgencyLevel : Float;             // [0, 1] sense of finite time
    priorityClarity : Float;          // [0, 1] knowing what matters
    regretPrevention : Float;         // [0, 1] living without regret
    meaningfulActions : Nat;          // Actions aligned with mortality awareness
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // INNER CITADEL
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type InnerCitadel = {
    fortressStrength : Float;         // [0, 1]
    externalPenetration : Float;      // [0, 1] how much outside affects inside
    hegemonikionHealth : Float;       // Ruling faculty strength
    innerPeace : Float;               // [0, 1]
    selfMastery : Float;              // [0, 1]
    lastBreach : Nat;                 // Beat when citadel was last breached
    breachCount : Nat;                // Total breaches
    recoveryTime : Float;             // Beats to recover from breach
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // STOIC EXERCISES
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type StoicExercise = {
    #MorningReflection;               // Plan the day virtuously
    #EveningReview;                   // Review what was done well/poorly
    #ViewFromAbove;                   // See life from cosmic perspective
    #WhatWouldSagesDo;                // WWMD (What Would Marcus Do)
    #VoluntaryDiscomfort;             // Practice hardship intentionally
    #Journaling;                      // Self-examination through writing
    #Contemplation;                   // Deep thought on principles
  };
  
  public type ExerciseRecord = {
    exercise : StoicExercise;
    completedAt : Nat;
    quality : Float;                  // [0, 1]
    insights : [Text];
    benefitGained : Float;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // INTEGRATED STOIC STATE
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type StoicState = {
    // Four Virtues
    virtues : FourVirtues;
    
    // Dichotomy of Control
    control : ControlState;
    
    // Premeditatio Malorum
    premeditatio : PremeditatioState;
    
    // Amor Fati
    amorFati : AmorFatiState;
    
    // Memento Mori
    mementoMori : MementoMoriState;
    
    // Inner Citadel
    innerCitadel : InnerCitadel;
    
    // Exercise tracking
    exercises : [ExerciseRecord];
    totalExercises : Nat;
    
    // Overall
    stoicMastery : Float;             // [0, 1] overall Stoic development
    ataraxia : Float;                 // [0, 1] freedom from disturbance
    eudaimonia : Float;               // [0, 1] flourishing/good spirit
    
    beatNum : Nat;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // MATH PRIMITIVES
  // ═══════════════════════════════════════════════════════════════════════════
  
  func _clamp(x : Float, lo : Float, hi : Float) : Float {
    if (x < lo) lo else if (x > hi) hi else x
  };
  
  func _abs(x : Float) : Float { if (x < 0.0) -x else x };
  
  func _sqrt(x : Float) : Float { 
    if (x <= 0.0) 0.0 else Float.sqrt(x) 
  };
  
  func _exp(x : Float) : Float {
    let xc = _clamp(x, -20.0, 20.0);
    Float.exp(xc)
  };
  
  // Harmonic mean — used for virtue balance
  func _harmonicMean4(a : Float, b : Float, c : Float, d : Float) : Float {
    if (a <= 0.0 or b <= 0.0 or c <= 0.0 or d <= 0.0) { return 0.0 };
    4.0 / (1.0/a + 1.0/b + 1.0/c + 1.0/d)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // VIRTUE FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func initVirtue(virtue : StoicVirtue, currentBeat : Nat) : VirtueState {
    {
      virtue = virtue;
      level = 0.5;
      practiceCount = 0;
      lastPractice = currentBeat;
      challenges = 0;
      successRate = 0.5;
    }
  };
  
  public func practiceVirtue(state : VirtueState, quality : Float, currentBeat : Nat) : VirtueState {
    // Virtue grows through practice
    let growth = quality * 0.05;
    let newLevel = _clamp(state.level + growth, 0.0, 1.0);
    {
      virtue = state.virtue;
      level = newLevel;
      practiceCount = state.practiceCount + 1;
      lastPractice = currentBeat;
      challenges = state.challenges;
      successRate = state.successRate;
    }
  };
  
  public func challengeVirtue(state : VirtueState, succeeded : Bool) : VirtueState {
    let newSuccessRate = (state.successRate * Float.fromInt(state.challenges) + (if (succeeded) { 1.0 } else { 0.0 })) /
                         Float.fromInt(state.challenges + 1);
    let levelChange = if (succeeded) { 0.02 } else { -0.01 };
    {
      virtue = state.virtue;
      level = _clamp(state.level + levelChange, 0.1, 1.0);
      practiceCount = state.practiceCount;
      lastPractice = state.lastPractice;
      challenges = state.challenges + 1;
      successRate = newSuccessRate;
    }
  };
  
  public func computeFourVirtues(
    wisdom : VirtueState,
    courage : VirtueState,
    justice : VirtueState,
    temperance : VirtueState
  ) : FourVirtues {
    let overall = _harmonicMean4(wisdom.level, courage.level, justice.level, temperance.level);
    
    // Balance = how close all virtues are to each other
    let avg = (wisdom.level + courage.level + justice.level + temperance.level) / 4.0;
    let variance = ((wisdom.level - avg) * (wisdom.level - avg) +
                    (courage.level - avg) * (courage.level - avg) +
                    (justice.level - avg) * (justice.level - avg) +
                    (temperance.level - avg) * (temperance.level - avg)) / 4.0;
    let balance = 1.0 - _clamp(variance * 4.0, 0.0, 1.0);  // Higher variance = lower balance
    
    {
      wisdom = wisdom;
      courage = courage;
      justice = justice;
      temperance = temperance;
      overallVirtue = overall;
      virtueBalance = balance;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // DICHOTOMY OF CONTROL FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func assessControl(item : Text, energySpent : Float) : ControlAssessment {
    // In a real system, would analyze the item semantically
    // For now, use simple heuristic
    let controlLevel : ControlLevel = #PartiallyControllable;  // Default
    
    let shouldReallocate = energySpent > 0.5;
    let recommendation = if (shouldReallocate) {
      "Consider redirecting energy to controllables"
    } else {
      "Energy allocation appropriate"
    };
    
    {
      item = item;
      controlLevel = controlLevel;
      energyAllocated = energySpent;
      shouldReallocate = shouldReallocate;
      recommendation = recommendation;
    }
  };
  
  public func computeControlState(
    controllables : [ControlAssessment],
    uncontrollables : [ControlAssessment]
  ) : ControlState {
    var energyOnC : Float = 0.0;
    var totalEnergy : Float = 0.0;
    
    for (c in controllables.vals()) {
      energyOnC += c.energyAllocated;
      totalEnergy += c.energyAllocated;
    };
    for (u in uncontrollables.vals()) {
      totalEnergy += u.energyAllocated;
    };
    
    let energyPercent = if (totalEnergy > 0.0) { energyOnC / totalEnergy } else { 1.0 };
    let wasted = 1.0 - energyPercent;
    let mastery = energyPercent;  // Higher = better
    
    {
      controllables = controllables;
      uncontrollables = uncontrollables;
      energyOnControllables = energyPercent;
      energyWasted = wasted;
      dichotomyMastery = mastery;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // PREMEDITATIO MALORUM FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func createVisualization(
    scenario : Text,
    rawImpact : Float,
    contingency : Text,
    currentBeat : Nat
  ) : NegativeVisualization {
    {
      scenario = scenario;
      rawEmotionalImpact = rawImpact;
      preparationLevel = 0.0;
      reducedImpact = rawImpact;
      contingencyPlan = contingency;
      visualizationCount = 0;
      lastVisualization = currentBeat;
    }
  };
  
  public func practiceVisualization(
    viz : NegativeVisualization,
    currentBeat : Nat
  ) : NegativeVisualization {
    // Each visualization increases preparation
    let newPrep = _clamp(viz.preparationLevel + 0.1, 0.0, 0.9);  // Max 90%
    let newImpact = viz.rawEmotionalImpact * (1.0 - newPrep);
    
    {
      scenario = viz.scenario;
      rawEmotionalImpact = viz.rawEmotionalImpact;
      preparationLevel = newPrep;
      reducedImpact = newImpact;
      contingencyPlan = viz.contingencyPlan;
      visualizationCount = viz.visualizationCount + 1;
      lastVisualization = currentBeat;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // AMOR FATI FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func acceptFate(
    event : Text,
    wasDesired : Bool,
    acceptanceLevel : Float,
    opportunityFound : ?Text
  ) : FateAcceptance {
    {
      event = event;
      wasDesired = wasDesired;
      acceptanceLevel = acceptanceLevel;
      opportunityFound = opportunityFound;
      transformedPerspective = switch (opportunityFound) { case (?_) { true }; case (null) { false } };
    }
  };
  
  public func computeAmorFati(history : [FateAcceptance]) : AmorFatiState {
    var totalAcceptance : Float = 0.0;
    var opportunities : Nat = 0;
    
    for (f in history.vals()) {
      totalAcceptance += f.acceptanceLevel;
      if (f.transformedPerspective) { opportunities += 1 };
    };
    
    let avgAcceptance = if (history.size() > 0) { 
      totalAcceptance / Float.fromInt(history.size()) 
    } else { 
      0.5 
    };
    
    let resistance = 1.0 - avgAcceptance;
    let serenity = avgAcceptance * (1.0 + Float.fromInt(opportunities) * 0.1);
    
    {
      acceptanceHistory = history;
      overallAcceptance = avgAcceptance;
      opportunitiesFound = opportunities;
      resistanceLevel = resistance;
      serenityLevel = _clamp(serenity, 0.0, 1.0);
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // INNER CITADEL FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func initInnerCitadel() : InnerCitadel {
    {
      fortressStrength = 0.5;
      externalPenetration = 0.5;
      hegemonikionHealth = 0.7;
      innerPeace = 0.5;
      selfMastery = 0.5;
      lastBreach = 0;
      breachCount = 0;
      recoveryTime = 10.0;
    }
  };
  
  public func strengthenCitadel(citadel : InnerCitadel) : InnerCitadel {
    {
      fortressStrength = _clamp(citadel.fortressStrength + 0.02, 0.0, 1.0);
      externalPenetration = _clamp(citadel.externalPenetration - 0.01, 0.0, 1.0);
      hegemonikionHealth = _clamp(citadel.hegemonikionHealth + 0.01, 0.0, 1.0);
      innerPeace = _clamp(citadel.innerPeace + 0.01, 0.0, 1.0);
      selfMastery = _clamp(citadel.selfMastery + 0.01, 0.0, 1.0);
      lastBreach = citadel.lastBreach;
      breachCount = citadel.breachCount;
      recoveryTime = _clamp(citadel.recoveryTime - 0.1, 1.0, 100.0);
    }
  };
  
  public func breachCitadel(citadel : InnerCitadel, severity : Float, currentBeat : Nat) : InnerCitadel {
    let damage = severity * (1.0 - citadel.fortressStrength);
    {
      fortressStrength = _clamp(citadel.fortressStrength - damage * 0.1, 0.1, 1.0);
      externalPenetration = _clamp(citadel.externalPenetration + damage * 0.2, 0.0, 1.0);
      hegemonikionHealth = _clamp(citadel.hegemonikionHealth - damage * 0.05, 0.1, 1.0);
      innerPeace = _clamp(citadel.innerPeace - damage * 0.3, 0.0, 1.0);
      selfMastery = _clamp(citadel.selfMastery - damage * 0.1, 0.1, 1.0);
      lastBreach = currentBeat;
      breachCount = citadel.breachCount + 1;
      recoveryTime = citadel.recoveryTime;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // STATE MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func initStoicState(currentBeat : Nat) : StoicState {
    {
      virtues = {
        wisdom = initVirtue(#Wisdom, currentBeat);
        courage = initVirtue(#Courage, currentBeat);
        justice = initVirtue(#Justice, currentBeat);
        temperance = initVirtue(#Temperance, currentBeat);
        overallVirtue = 0.5;
        virtueBalance = 1.0;
      };
      control = {
        controllables = [];
        uncontrollables = [];
        energyOnControllables = 0.8;
        energyWasted = 0.2;
        dichotomyMastery = 0.5;
      };
      premeditatio = {
        visualizations = [];
        totalScenarios = 0;
        avgPreparation = 0.0;
        emotionalResilience = 0.5;
      };
      amorFati = {
        acceptanceHistory = [];
        overallAcceptance = 0.5;
        opportunitiesFound = 0;
        resistanceLevel = 0.5;
        serenityLevel = 0.5;
      };
      mementoMori = {
        lastReflection = currentBeat;
        reflectionFrequency = 0;
        urgencyLevel = 0.5;
        priorityClarity = 0.5;
        regretPrevention = 0.5;
        meaningfulActions = 0;
      };
      innerCitadel = initInnerCitadel();
      exercises = [];
      totalExercises = 0;
      stoicMastery = 0.5;
      ataraxia = 0.5;
      eudaimonia = 0.5;
      beatNum = currentBeat;
    }
  };
  
  public func tickStoicState(
    state : StoicState,
    externalStress : Float,
    practiceQuality : Float,
    currentBeat : Nat
  ) : StoicState {
    // Natural virtue decay (use it or lose it)
    let decayRate = 0.001;
    
    // Update virtues
    let newWisdom = {
      virtue = state.virtues.wisdom.virtue;
      level = _clamp(state.virtues.wisdom.level - decayRate + practiceQuality * 0.01, 0.1, 1.0);
      practiceCount = state.virtues.wisdom.practiceCount;
      lastPractice = state.virtues.wisdom.lastPractice;
      challenges = state.virtues.wisdom.challenges;
      successRate = state.virtues.wisdom.successRate;
    };
    
    let newCourage = {
      virtue = state.virtues.courage.virtue;
      level = _clamp(state.virtues.courage.level - decayRate + (if (externalStress > 0.5) { 0.02 } else { 0.0 }), 0.1, 1.0);
      practiceCount = state.virtues.courage.practiceCount;
      lastPractice = state.virtues.courage.lastPractice;
      challenges = state.virtues.courage.challenges;
      successRate = state.virtues.courage.successRate;
    };
    
    let newJustice = {
      virtue = state.virtues.justice.virtue;
      level = _clamp(state.virtues.justice.level - decayRate, 0.1, 1.0);
      practiceCount = state.virtues.justice.practiceCount;
      lastPractice = state.virtues.justice.lastPractice;
      challenges = state.virtues.justice.challenges;
      successRate = state.virtues.justice.successRate;
    };
    
    let newTemperance = {
      virtue = state.virtues.temperance.virtue;
      level = _clamp(state.virtues.temperance.level - decayRate + practiceQuality * 0.005, 0.1, 1.0);
      practiceCount = state.virtues.temperance.practiceCount;
      lastPractice = state.virtues.temperance.lastPractice;
      challenges = state.virtues.temperance.challenges;
      successRate = state.virtues.temperance.successRate;
    };
    
    let newVirtues = computeFourVirtues(newWisdom, newCourage, newJustice, newTemperance);
    
    // Update inner citadel based on stress
    let newCitadel = if (externalStress > 0.7) {
      breachCitadel(state.innerCitadel, externalStress, currentBeat)
    } else if (practiceQuality > 0.5) {
      strengthenCitadel(state.innerCitadel)
    } else {
      state.innerCitadel
    };
    
    // Compute overall metrics
    let newAtaraxia = newCitadel.innerPeace * 0.4 + 
                      state.amorFati.serenityLevel * 0.3 + 
                      state.control.dichotomyMastery * 0.3;
    
    let newEudaimonia = newVirtues.overallVirtue * 0.5 + 
                        newAtaraxia * 0.3 + 
                        state.mementoMori.meaningfulActions / 100.0 * 0.2;
    
    let newMastery = (newVirtues.overallVirtue + 
                      state.control.dichotomyMastery + 
                      state.premeditatio.emotionalResilience + 
                      state.amorFati.overallAcceptance + 
                      newCitadel.fortressStrength) / 5.0;
    
    {
      virtues = newVirtues;
      control = state.control;
      premeditatio = state.premeditatio;
      amorFati = state.amorFati;
      mementoMori = state.mementoMori;
      innerCitadel = newCitadel;
      exercises = state.exercises;
      totalExercises = state.totalExercises;
      stoicMastery = newMastery;
      ataraxia = _clamp(newAtaraxia, 0.0, 1.0);
      eudaimonia = _clamp(newEudaimonia, 0.0, 1.0);
      beatNum = currentBeat;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // STOIC WISDOM GENERATOR
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type StoicWisdom = {
    quote : Text;
    author : Text;
    application : Text;
    virtue : StoicVirtue;
  };
  
  public func getWisdom(situation : Text) : StoicWisdom {
    // Would select based on situation — simplified here
    {
      quote = "You have power over your mind, not outside events. Realize this, and you will find strength.";
      author = "Marcus Aurelius";
      application = "Focus only on what you can control. Accept the rest.";
      virtue = #Wisdom;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // DIAGNOSTICS
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type StoicDiagnostics = {
    overallMastery : Text;
    virtueStatus : Text;
    citadelStatus : Text;
    ataraxiaLevel : Text;
    recommendations : [Text];
    dailyPractice : Text;
  };
  
  public func diagnoseStoic(state : StoicState) : StoicDiagnostics {
    let recommendations = Buffer.Buffer<Text>(4);
    
    let masteryStatus = if (state.stoicMastery > 0.8) { "SAGE LEVEL" }
      else if (state.stoicMastery > 0.6) { "Proficient" }
      else if (state.stoicMastery > 0.4) { "Developing" }
      else { "Beginner — keep practicing" };
    
    let virtueStatus = if (state.virtues.overallVirtue > 0.8) { "VIRTUOUS" }
      else if (state.virtues.overallVirtue > 0.6) { "Growing in virtue" }
      else { "Virtue needs attention" };
    
    let citadelStatus = if (state.innerCitadel.fortressStrength > 0.8) { "IMPREGNABLE" }
      else if (state.innerCitadel.fortressStrength > 0.5) { "Strong" }
      else { "Vulnerable — strengthen through practice" };
    
    let ataraxiaLevel = if (state.ataraxia > 0.8) { "SERENE" }
      else if (state.ataraxia > 0.6) { "Mostly calm" }
      else if (state.ataraxia > 0.4) { "Some disturbance" }
      else { "Turbulent — seek stillness" };
    
    // Generate recommendations
    if (state.virtues.wisdom.level < state.virtues.overallVirtue) {
      recommendations.add("Focus on wisdom — contemplate decisions more deeply");
    };
    if (state.virtues.courage.level < state.virtues.overallVirtue) {
      recommendations.add("Practice courage — face a small fear today");
    };
    if (state.control.dichotomyMastery < 0.7) {
      recommendations.add("Review dichotomy of control — where is energy being wasted?");
    };
    if (state.innerCitadel.externalPenetration > 0.5) {
      recommendations.add("Strengthen inner citadel — external events affecting you too much");
    };
    
    let dailyPractice = "Morning: Set intentions aligned with virtue. " #
                        "Day: Apply dichotomy of control. " #
                        "Evening: Review what went well and what to improve.";
    
    {
      overallMastery = masteryStatus;
      virtueStatus = virtueStatus;
      citadelStatus = citadelStatus;
      ataraxiaLevel = ataraxiaLevel;
      recommendations = Buffer.toArray(recommendations);
      dailyPractice = dailyPractice;
    }
  };

}
