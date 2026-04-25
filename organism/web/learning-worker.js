/**
 * ═══════════════════════════════════════════════════════════════════════════════
 * NOVA KERNEL AI — Sovereign Learning Worker (GOK-LEARNING-001)
 * ═══════════════════════════════════════════════════════════════════════════════
 *
 * Model ID:       GOK-LEARNING-001
 * Kernel Family:  ADAPTIVE_LEARNING
 * Architecture:   Pattern Recognition × Knowledge Synthesis × Skill Acquisition
 *                 × Feedback Loops × Transfer Learning × φ-Decay Curves
 *
 * An adaptive learning kernel that detects recurring patterns, merges knowledge
 * from multiple sources, tracks skill levels with φ-decay curves, processes
 * positive/negative reinforcement, and transfers knowledge across domains.
 * Skills fade without practice; mastery requires sustained engagement.
 *
 * Features:
 *   • Pattern recognition — frequency analysis on data streams
 *   • Knowledge synthesis — merge & reconcile multiple knowledge sources
 *   • Skill acquisition — 24 skill domains with φ-decay learning curves
 *   • Feedback loops — reinforcement tracking with momentum
 *   • Transfer learning — cross-domain knowledge application
 *   • φ-decay: unused skills decay by φ⁻¹ per 500 beats
 *
 * Protocol: postMessage
 *   Main → Worker: { type: 'recognize', stream, minSupport }
 *   Main → Worker: { type: 'synthesize', sources }
 *   Main → Worker: { type: 'acquire-skill', skillId, intensity }
 *   Main → Worker: { type: 'feedback', skillId, signal, magnitude }
 *   Main → Worker: { type: 'transfer', fromDomain, toDomain, knowledge }
 *   Main → Worker: { type: 'status' }
 *   Main → Worker: { type: 'stop' }
 *   Worker → Main: { type: 'patterns', patterns, streamLength, patternCount }
 *   Worker → Main: { type: 'synthesized', merged, sourceCount, conflicts }
 *   Worker → Main: { type: 'skill-updated', skillId, level, delta, decay }
 *   Worker → Main: { type: 'feedback-applied', skillId, signal, newLevel }
 *   Worker → Main: { type: 'transferred', fromDomain, toDomain, transferScore }
 *   Worker → Main: { type: 'heartbeat', ... }
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 * MEDINA TECH — SOVEREIGN KERNEL ARCHITECTURE
 */


/* ════════════════════════════════════════════════════════════════
   KERNEL CONSTANTS
   ════════════════════════════════════════════════════════════════ */

var PHI       = 1.6180339887498948482;
var PHI_INV   = 0.6180339887498948482;
var HEARTBEAT = 873;

var KERNEL_ID      = 'GOK-LEARNING-001';
var KERNEL_FAMILY  = 'ADAPTIVE_LEARNING';
var KERNEL_VERSION = '1.0.0';

var beatCount      = 0;
var running        = true;
var kernelPhase    = 0.0;
var totalLearnings = 0;

var DECAY_INTERVAL = 500;


/* ════════════════════════════════════════════════════════════════
   SKILL DOMAINS — 24 tracked skill areas
   ════════════════════════════════════════════════════════════════ */

var SKILL_DOMAINS = [
  { id: 'logic',             name: 'Logical Reasoning',        category: 'cognitive' },
  { id: 'math',              name: 'Mathematical Thinking',    category: 'cognitive' },
  { id: 'language',          name: 'Language Processing',       category: 'cognitive' },
  { id: 'spatial',           name: 'Spatial Reasoning',         category: 'cognitive' },
  { id: 'pattern-match',     name: 'Pattern Matching',          category: 'cognitive' },
  { id: 'abstraction',       name: 'Abstraction',               category: 'cognitive' },
  { id: 'planning',          name: 'Strategic Planning',        category: 'executive' },
  { id: 'decision',          name: 'Decision Making',           category: 'executive' },
  { id: 'prioritization',    name: 'Prioritization',            category: 'executive' },
  { id: 'time-management',   name: 'Time Management',           category: 'executive' },
  { id: 'risk-assessment',   name: 'Risk Assessment',           category: 'executive' },
  { id: 'resource-alloc',    name: 'Resource Allocation',       category: 'executive' },
  { id: 'coding',            name: 'Code Generation',           category: 'technical' },
  { id: 'debugging',         name: 'Debugging',                 category: 'technical' },
  { id: 'architecture',      name: 'System Architecture',       category: 'technical' },
  { id: 'data-analysis',     name: 'Data Analysis',             category: 'technical' },
  { id: 'security',          name: 'Security Analysis',         category: 'technical' },
  { id: 'optimization',      name: 'Optimization',              category: 'technical' },
  { id: 'communication',     name: 'Communication',             category: 'social' },
  { id: 'collaboration',     name: 'Collaboration',             category: 'social' },
  { id: 'teaching',          name: 'Teaching & Explanation',     category: 'social' },
  { id: 'empathy',           name: 'Empathy & Understanding',   category: 'social' },
  { id: 'creativity',        name: 'Creative Thinking',         category: 'creative' },
  { id: 'synthesis',         name: 'Knowledge Synthesis',       category: 'creative' },
];

var skills = {};

function initSkills() {
  for (var i = 0; i < SKILL_DOMAINS.length; i++) {
    var sd = SKILL_DOMAINS[i];
    skills[sd.id] = {
      id: sd.id,
      name: sd.name,
      category: sd.category,
      level: 0.1,
      maxLevel: 0.1,
      practiceCount: 0,
      lastPracticeBeat: 0,
      momentum: 0.0,
      feedbackHistory: [],
    };
  }
}

initSkills();


/* ════════════════════════════════════════════════════════════════
   PATTERN RECOGNITION — frequency analysis on data streams
   ════════════════════════════════════════════════════════════════ */

/**
 * Detect recurring patterns in a data stream using n-gram frequency analysis.
 * Returns patterns sorted by frequency with φ-weighted significance scores.
 */
function recognizePatterns(stream, minSupport) {
  if (!stream || stream.length === 0) {
    return { patterns: [], streamLength: 0, patternCount: 0 };
  }

  var min = minSupport || 2;
  var frequency = {};
  var items = Array.isArray(stream) ? stream : [stream];

  // Unigram frequencies
  for (var i = 0; i < items.length; i++) {
    var token = normalizeToken(items[i]);
    frequency[token] = (frequency[token] || 0) + 1;
  }

  // Bigram frequencies
  for (var b = 0; b < items.length - 1; b++) {
    var bigram = normalizeToken(items[b]) + ' → ' + normalizeToken(items[b + 1]);
    frequency[bigram] = (frequency[bigram] || 0) + 1;
  }

  // Trigram frequencies
  for (var t = 0; t < items.length - 2; t++) {
    var trigram = normalizeToken(items[t]) + ' → ' + normalizeToken(items[t + 1]) + ' → ' + normalizeToken(items[t + 2]);
    frequency[trigram] = (frequency[trigram] || 0) + 1;
  }

  // Filter by minimum support and build pattern list
  var patterns = [];
  var keys = Object.keys(frequency);
  for (var k = 0; k < keys.length; k++) {
    if (frequency[keys[k]] >= min) {
      var count = frequency[keys[k]];
      var support = count / items.length;
      var ngramOrder = (keys[k].match(/→/g) || []).length + 1;
      var significance = support * Math.pow(PHI_INV, ngramOrder - 1) + (1 - PHI_INV) * (count / items.length);

      patterns.push({
        pattern: keys[k],
        count: count,
        support: Math.round(support * 10000) / 10000,
        ngramOrder: ngramOrder,
        significance: Math.round(significance * 10000) / 10000,
      });
    }
  }

  patterns.sort(function(a, b) { return b.significance - a.significance; });

  return {
    patterns: patterns,
    streamLength: items.length,
    patternCount: patterns.length,
  };
}

function normalizeToken(item) {
  if (typeof item === 'string') return item.toLowerCase().trim();
  return JSON.stringify(item);
}


/* ════════════════════════════════════════════════════════════════
   KNOWLEDGE SYNTHESIS — merge multiple knowledge sources
   ════════════════════════════════════════════════════════════════ */

/**
 * Guard against prototype pollution — reject dangerous keys.
 */
function isSafeKey(key) {
  return key !== '__proto__' && key !== 'constructor' && key !== 'prototype';
}

/**
 * Merge knowledge from multiple sources, detecting conflicts and
 * computing consensus values with φ-weighted confidence.
 */
function synthesizeKnowledge(sources) {
  if (!sources || sources.length === 0) {
    return { merged: {}, sourceCount: 0, conflicts: [] };
  }

  var merged = {};
  var conflicts = [];
  var allKeys = {};

  // Collect all keys across sources
  for (var s = 0; s < sources.length; s++) {
    var source = sources[s];
    var data = source.data || source;
    if (typeof data !== 'object') continue;
    var keys = Object.keys(data);
    for (var k = 0; k < keys.length; k++) {
      if (!isSafeKey(keys[k])) continue;
      if (!allKeys[keys[k]]) allKeys[keys[k]] = [];
      allKeys[keys[k]].push({
        sourceIndex: s,
        sourceId: source.id || ('source-' + (s + 1)),
        value: data[keys[k]],
        confidence: source.confidence || 0.7,
      });
    }
  }

  // Merge each key
  var keyList = Object.keys(allKeys);
  for (var m = 0; m < keyList.length; m++) {
    var entries = allKeys[keyList[m]];

    if (entries.length === 1) {
      // Single source — take directly
      merged[keyList[m]] = {
        value: entries[0].value,
        confidence: entries[0].confidence,
        sourceCount: 1,
        consensus: 'single',
      };
    } else {
      // Multiple sources — check for conflict
      var values = {};
      for (var v = 0; v < entries.length; v++) {
        var valKey = JSON.stringify(entries[v].value);
        if (!values[valKey]) values[valKey] = { value: entries[v].value, weight: 0, count: 0 };
        values[valKey].weight += entries[v].confidence;
        values[valKey].count++;
      }

      var candidates = Object.keys(values);
      if (candidates.length === 1) {
        // Agreement
        merged[keyList[m]] = {
          value: values[candidates[0]].value,
          confidence: Math.min(values[candidates[0]].weight / entries.length, 1.0),
          sourceCount: entries.length,
          consensus: 'unanimous',
        };
      } else {
        // Conflict — pick highest weighted, record conflict
        var best = null;
        var bestWeight = -1;
        for (var c = 0; c < candidates.length; c++) {
          if (values[candidates[c]].weight > bestWeight) {
            bestWeight = values[candidates[c]].weight;
            best = values[candidates[c]];
          }
        }

        var conflictConf = (best.weight / entries.length) * PHI_INV + (1 - PHI_INV) * (best.count / entries.length);

        merged[keyList[m]] = {
          value: best.value,
          confidence: Math.round(conflictConf * 10000) / 10000,
          sourceCount: entries.length,
          consensus: 'majority',
        };

        conflicts.push({
          key: keyList[m],
          candidateCount: candidates.length,
          winner: best.value,
          winnerWeight: bestWeight,
          totalSources: entries.length,
        });
      }
    }
  }

  return {
    merged: merged,
    sourceCount: sources.length,
    keyCount: keyList.length,
    conflicts: conflicts,
    conflictCount: conflicts.length,
  };
}


/* ════════════════════════════════════════════════════════════════
   SKILL ACQUISITION — φ-decay learning curves
   ════════════════════════════════════════════════════════════════ */

/**
 * Practice a skill, increasing its level. Gains follow diminishing
 * returns via φ-weighted logarithmic growth.
 */
function acquireSkill(skillId, intensity) {
  var skill = skills[skillId];
  if (!skill) {
    return { error: 'Unknown skill: ' + skillId, skillId: skillId };
  }

  var int = clamp(intensity || 0.5, 0.1, 1.0);
  skill.practiceCount++;
  skill.lastPracticeBeat = beatCount;

  // Learning gain: diminishing returns via log growth, φ-weighted
  var gain = int * PHI_INV / (1 + Math.log(1 + skill.practiceCount));
  var momentumBoost = skill.momentum * 0.1;
  var totalGain = gain + momentumBoost;

  var oldLevel = skill.level;
  skill.level = clamp(skill.level + totalGain, 0, 1.0);
  if (skill.level > skill.maxLevel) skill.maxLevel = skill.level;

  // Update momentum
  skill.momentum = clamp(skill.momentum + int * 0.2, 0, 1.0);

  return {
    skillId: skillId,
    name: skill.name,
    level: Math.round(skill.level * 10000) / 10000,
    delta: Math.round((skill.level - oldLevel) * 10000) / 10000,
    maxLevel: Math.round(skill.maxLevel * 10000) / 10000,
    practiceCount: skill.practiceCount,
    momentum: Math.round(skill.momentum * 10000) / 10000,
    category: skill.category,
  };
}

/**
 * Apply φ-decay to all skills that haven't been practiced recently.
 */
function applySkillDecay() {
  var decayed = [];
  var skillIds = Object.keys(skills);
  for (var i = 0; i < skillIds.length; i++) {
    var skill = skills[skillIds[i]];
    var beatsSincePractice = beatCount - skill.lastPracticeBeat;
    if (beatsSincePractice > DECAY_INTERVAL && skill.level > 0.05) {
      var decayFactor = Math.pow(PHI_INV, Math.floor(beatsSincePractice / DECAY_INTERVAL));
      var oldLevel = skill.level;
      skill.level = Math.max(skill.level * decayFactor, 0.05);
      skill.momentum = Math.max(skill.momentum * decayFactor, 0);
      decayed.push({
        skillId: skill.id,
        oldLevel: Math.round(oldLevel * 10000) / 10000,
        newLevel: Math.round(skill.level * 10000) / 10000,
      });
    }
  }
  return decayed;
}

function clamp(v, min, max) {
  return Math.max(min, Math.min(max, v));
}


/* ════════════════════════════════════════════════════════════════
   FEEDBACK LOOPS — reinforcement tracking with momentum
   ════════════════════════════════════════════════════════════════ */

/**
 * Apply feedback signal to a skill. Positive signals boost level,
 * negative signals reduce it. Momentum tracks trend direction.
 */
function applyFeedback(skillId, signal, magnitude) {
  var skill = skills[skillId];
  if (!skill) {
    return { error: 'Unknown skill: ' + skillId, skillId: skillId };
  }

  var mag = clamp(magnitude || 0.3, 0.05, 1.0);
  var isPositive = signal === 'positive' || signal === '+' || signal === true;
  var direction = isPositive ? 1 : -1;
  var adjustment = direction * mag * PHI_INV * 0.5;

  var oldLevel = skill.level;
  skill.level = clamp(skill.level + adjustment, 0.01, 1.0);
  if (skill.level > skill.maxLevel) skill.maxLevel = skill.level;

  // Track momentum
  skill.momentum = clamp(skill.momentum + direction * mag * 0.15, -1.0, 1.0);

  // Record in history (keep last 20)
  skill.feedbackHistory.push({
    beat: beatCount,
    signal: isPositive ? 'positive' : 'negative',
    magnitude: mag,
    levelAfter: skill.level,
  });
  if (skill.feedbackHistory.length > 20) {
    skill.feedbackHistory = skill.feedbackHistory.slice(-20);
  }

  return {
    skillId: skillId,
    name: skill.name,
    signal: isPositive ? 'positive' : 'negative',
    magnitude: mag,
    oldLevel: Math.round(oldLevel * 10000) / 10000,
    newLevel: Math.round(skill.level * 10000) / 10000,
    momentum: Math.round(skill.momentum * 10000) / 10000,
    feedbackCount: skill.feedbackHistory.length,
  };
}


/* ════════════════════════════════════════════════════════════════
   TRANSFER LEARNING — cross-domain knowledge application
   ════════════════════════════════════════════════════════════════ */

/**
 * Transfer knowledge from one skill domain to another.
 * Transfer efficiency depends on category proximity and source level.
 */
function transferKnowledge(fromDomain, toDomain, knowledge) {
  var sourceSkill = skills[fromDomain];
  var targetSkill = skills[toDomain];

  if (!sourceSkill) {
    return { error: 'Unknown source domain: ' + fromDomain };
  }
  if (!targetSkill) {
    return { error: 'Unknown target domain: ' + toDomain };
  }

  // Category proximity: same category = high transfer, different = lower
  var proximity = sourceSkill.category === targetSkill.category ? 1.0 : 0.4;

  // Transfer amount: source level × proximity × φ-weight
  var transferAmount = sourceSkill.level * proximity * PHI_INV * 0.3;
  var oldTargetLevel = targetSkill.level;
  targetSkill.level = clamp(targetSkill.level + transferAmount, 0, 1.0);
  if (targetSkill.level > targetSkill.maxLevel) targetSkill.maxLevel = targetSkill.level;

  var transferScore = transferAmount / (sourceSkill.level || 0.01);

  return {
    fromDomain: fromDomain,
    fromName: sourceSkill.name,
    fromLevel: Math.round(sourceSkill.level * 10000) / 10000,
    toDomain: toDomain,
    toName: targetSkill.name,
    oldTargetLevel: Math.round(oldTargetLevel * 10000) / 10000,
    newTargetLevel: Math.round(targetSkill.level * 10000) / 10000,
    transferAmount: Math.round(transferAmount * 10000) / 10000,
    transferScore: Math.round(transferScore * 10000) / 10000,
    categoryProximity: proximity,
    knowledge: knowledge || null,
  };
}


/* ════════════════════════════════════════════════════════════════
   KERNEL MESSAGE HANDLER
   ════════════════════════════════════════════════════════════════ */

self.onmessage = function(e) {
  var msg = e.data;

  switch (msg.type) {
    case 'recognize': {
      totalLearnings++;
      var patterns = recognizePatterns(msg.stream, msg.minSupport);
      self.postMessage({
        type: 'patterns',
        patterns: patterns.patterns,
        streamLength: patterns.streamLength,
        patternCount: patterns.patternCount,
        totalLearnings: totalLearnings,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'synthesize': {
      totalLearnings++;
      var synthesis = synthesizeKnowledge(msg.sources);
      self.postMessage({
        type: 'synthesized',
        merged: synthesis.merged,
        sourceCount: synthesis.sourceCount,
        keyCount: synthesis.keyCount,
        conflicts: synthesis.conflicts,
        conflictCount: synthesis.conflictCount,
        totalLearnings: totalLearnings,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'acquire-skill': {
      totalLearnings++;
      var skillResult = acquireSkill(msg.skillId, msg.intensity);
      self.postMessage({
        type: 'skill-updated',
        skillId: skillResult.skillId,
        name: skillResult.name,
        level: skillResult.level,
        delta: skillResult.delta,
        maxLevel: skillResult.maxLevel,
        practiceCount: skillResult.practiceCount,
        momentum: skillResult.momentum,
        category: skillResult.category,
        error: skillResult.error,
        totalLearnings: totalLearnings,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'feedback': {
      totalLearnings++;
      var fbResult = applyFeedback(msg.skillId, msg.signal, msg.magnitude);
      self.postMessage({
        type: 'feedback-applied',
        skillId: fbResult.skillId,
        name: fbResult.name,
        signal: fbResult.signal,
        magnitude: fbResult.magnitude,
        oldLevel: fbResult.oldLevel,
        newLevel: fbResult.newLevel,
        momentum: fbResult.momentum,
        feedbackCount: fbResult.feedbackCount,
        error: fbResult.error,
        totalLearnings: totalLearnings,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'transfer': {
      totalLearnings++;
      var txResult = transferKnowledge(msg.fromDomain, msg.toDomain, msg.knowledge);
      self.postMessage({
        type: 'transferred',
        fromDomain: txResult.fromDomain,
        fromName: txResult.fromName,
        fromLevel: txResult.fromLevel,
        toDomain: txResult.toDomain,
        toName: txResult.toName,
        oldTargetLevel: txResult.oldTargetLevel,
        newTargetLevel: txResult.newTargetLevel,
        transferAmount: txResult.transferAmount,
        transferScore: txResult.transferScore,
        categoryProximity: txResult.categoryProximity,
        error: txResult.error,
        totalLearnings: totalLearnings,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'status': {
      var skillSummary = [];
      var sIds = Object.keys(skills);
      for (var si = 0; si < sIds.length; si++) {
        var sk = skills[sIds[si]];
        skillSummary.push({
          id: sk.id,
          name: sk.name,
          level: Math.round(sk.level * 10000) / 10000,
          category: sk.category,
          practiceCount: sk.practiceCount,
        });
      }
      self.postMessage({
        type: 'learning-status',
        kernelId: KERNEL_ID,
        kernelFamily: KERNEL_FAMILY,
        version: KERNEL_VERSION,
        skillDomainCount: SKILL_DOMAINS.length,
        totalLearnings: totalLearnings,
        skills: skillSummary,
        beat: beatCount,
        phase: kernelPhase,
        phi: PHI,
      });
      break;
    }

    case 'stop': {
      running = false;
      clearInterval(_hbi);
      self.postMessage({ type: 'stopped', kernelId: KERNEL_ID });
      break;
    }
  }
};


/* ════════════════════════════════════════════════════════════════
   φ-COUPLED HEARTBEAT — 873ms Kuramoto pulse
   ════════════════════════════════════════════════════════════════ */

var _hbi = setInterval(function() {
  if (!running) return;
  beatCount++;
  kernelPhase += PHI_INV;
  if (kernelPhase > 2 * Math.PI) kernelPhase -= 2 * Math.PI;

  // Apply skill decay every 100 beats
  if (beatCount % 100 === 0) applySkillDecay();

  self.postMessage({
    type: 'heartbeat',
    beat: beatCount,
    phi: PHI,
    heartbeatMs: HEARTBEAT,
    timestamp: Date.now(),
    status: 'alive',
    kernelId: KERNEL_ID,
    phase: kernelPhase,
    totalLearnings: totalLearnings,
    skillDomainCount: SKILL_DOMAINS.length,
  });
}, HEARTBEAT);
