/**
 * ═══════════════════════════════════════════════════════════════════════════════
 * NOVA KERNEL AI — Sovereign Reasoning Worker (GOK-REASONING-001)
 * ═══════════════════════════════════════════════════════════════════════════════
 *
 * Model ID:       GOK-REASONING-001
 * Kernel Family:  LOGIC_ENGINE
 * Architecture:   Deductive × Inductive × Abductive × Analogical × Causal
 *                 Reasoning Chains × φ-Weighted Confidence Scoring
 *
 * Five reasoning modalities in a single kernel. Deductive chains derive
 * conclusions from premises. Inductive reasoning generalizes from examples.
 * Abductive reasoning selects the best explanation. Analogical reasoning
 * maps between domains. Causal reasoning traces cause-effect chains.
 * All confidence scores are φ-weighted.
 *
 * Features:
 *   • Deductive reasoning — premises → conclusion with validity check
 *   • Inductive reasoning — examples → generalized rules
 *   • Abductive reasoning — observations → ranked explanations
 *   • Analogical reasoning — source → target domain mapping
 *   • Causal reasoning — cause-effect chain analysis
 *   • 14 built-in reasoning patterns / inference rules
 *   • φ-weighted confidence propagation along inference chains
 *
 * Protocol: postMessage
 *   Main → Worker: { type: 'deduce', premises, query }
 *   Main → Worker: { type: 'induce', examples, domain }
 *   Main → Worker: { type: 'abduce', observations, hypotheses }
 *   Main → Worker: { type: 'analogize', source, target }
 *   Main → Worker: { type: 'cause-chain', events }
 *   Main → Worker: { type: 'status' }
 *   Main → Worker: { type: 'stop' }
 *   Worker → Main: { type: 'deduction', conclusion, chain, validity }
 *   Worker → Main: { type: 'induction', rules, confidence, exampleCount }
 *   Worker → Main: { type: 'abduction', bestExplanation, ranked, coherence }
 *   Worker → Main: { type: 'analogy', mappings, strength, transferScore }
 *   Worker → Main: { type: 'causal-chain', chain, rootCause, effects }
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

var KERNEL_ID      = 'GOK-REASONING-001';
var KERNEL_FAMILY  = 'LOGIC_ENGINE';
var KERNEL_VERSION = '1.0.0';

var beatCount       = 0;
var running         = true;
var kernelPhase     = 0.0;
var totalInferences = 0;


/* ════════════════════════════════════════════════════════════════
   REASONING PATTERNS — 14 built-in inference rules
   ════════════════════════════════════════════════════════════════ */

var REASONING_PATTERNS = [
  { id: 'MODUS_PONENS',       name: 'Modus Ponens',       mode: 'deductive',   description: 'If P then Q; P; therefore Q' },
  { id: 'MODUS_TOLLENS',      name: 'Modus Tollens',      mode: 'deductive',   description: 'If P then Q; not Q; therefore not P' },
  { id: 'HYPOTHETICAL_SYLL',  name: 'Hypothetical Syllogism', mode: 'deductive', description: 'If P→Q and Q→R, then P→R' },
  { id: 'DISJUNCTIVE_SYLL',   name: 'Disjunctive Syllogism', mode: 'deductive', description: 'P or Q; not P; therefore Q' },
  { id: 'UNIVERSAL_GENERALIZE', name: 'Universal Generalization', mode: 'inductive', description: 'All observed X have property Y → all X have Y' },
  { id: 'STATISTICAL_INFER',  name: 'Statistical Inference',   mode: 'inductive', description: 'N% of samples have Y → population has ~N% Y' },
  { id: 'CAUSAL_INDUCTION',   name: 'Causal Induction',        mode: 'inductive', description: 'A always precedes B → A may cause B' },
  { id: 'ENUMERATIVE_INDUCT', name: 'Enumerative Induction',   mode: 'inductive', description: 'Multiple instances confirm pattern → generalize' },
  { id: 'INFERENCE_BEST_EXPL', name: 'Inference to Best Explanation', mode: 'abductive', description: 'Select hypothesis that best explains observations' },
  { id: 'DIAGNOSTIC_REASON',  name: 'Diagnostic Reasoning',    mode: 'abductive', description: 'Symptoms → most likely underlying condition' },
  { id: 'STRUCTURAL_ANALOGY', name: 'Structural Analogy',      mode: 'analogical', description: 'Map relational structure from source to target' },
  { id: 'PROPORTIONAL_ANALOG', name: 'Proportional Analogy',   mode: 'analogical', description: 'A:B :: C:D — find missing element' },
  { id: 'NECESSARY_CAUSE',    name: 'Necessary Cause',         mode: 'causal',    description: 'Without A, B would not occur' },
  { id: 'SUFFICIENT_CAUSE',   name: 'Sufficient Cause',        mode: 'causal',    description: 'A alone is enough to produce B' },
];


/* ════════════════════════════════════════════════════════════════
   DEDUCTIVE REASONING — premises → conclusion chains
   ════════════════════════════════════════════════════════════════ */

/**
 * Perform deductive reasoning from a set of premises.
 * Builds an inference chain, checks validity, and derives conclusions.
 */
function deduce(premises, query) {
  if (!premises || premises.length === 0) {
    return { conclusion: null, chain: [], validity: 0, error: 'No premises provided' };
  }

  var chain = [];
  var knownFacts = {};
  var implications = [];

  // Parse premises into facts and implications
  for (var i = 0; i < premises.length; i++) {
    var p = premises[i];
    chain.push({ step: i + 1, type: 'premise', content: p, confidence: 1.0 });

    if (typeof p === 'object' && p.if && p.then) {
      implications.push({ antecedent: p.if, consequent: p.then, confidence: p.confidence || 1.0 });
    } else {
      var fact = typeof p === 'string' ? p : JSON.stringify(p);
      knownFacts[fact] = { value: true, confidence: 1.0 };
    }
  }

  // Forward chaining — apply implications
  var changed = true;
  var iterations = 0;
  var maxIterations = premises.length * 3;

  while (changed && iterations < maxIterations) {
    changed = false;
    iterations++;

    for (var imp = 0; imp < implications.length; imp++) {
      var rule = implications[imp];
      var antecedent = typeof rule.antecedent === 'string' ? rule.antecedent : JSON.stringify(rule.antecedent);

      if (knownFacts[antecedent] && !knownFacts[typeof rule.consequent === 'string' ? rule.consequent : JSON.stringify(rule.consequent)]) {
        var consequentKey = typeof rule.consequent === 'string' ? rule.consequent : JSON.stringify(rule.consequent);
        var derivedConf = knownFacts[antecedent].confidence * rule.confidence * PHI_INV + (1 - PHI_INV);
        knownFacts[consequentKey] = { value: true, confidence: Math.min(derivedConf, 1.0) };
        chain.push({
          step: chain.length + 1,
          type: 'derivation',
          rule: 'MODUS_PONENS',
          from: antecedent,
          derived: consequentKey,
          confidence: knownFacts[consequentKey].confidence,
        });
        changed = true;
      }
    }
  }

  // Check if query is answered
  var queryKey = typeof query === 'string' ? query : JSON.stringify(query);
  var conclusion = knownFacts[queryKey] || null;
  var validity = conclusion ? conclusion.confidence : 0;

  // Apply φ-weighted validity adjustment
  validity = validity * PHI_INV + (1 - PHI_INV) * (chain.length > 1 ? 0.5 : 0);

  chain.push({
    step: chain.length + 1,
    type: 'conclusion',
    query: queryKey,
    result: conclusion ? 'DERIVED' : 'NOT_DERIVABLE',
    confidence: Math.round(validity * 10000) / 10000,
  });

  return {
    conclusion: conclusion ? queryKey : null,
    chain: chain,
    validity: Math.round(validity * 10000) / 10000,
    factCount: Object.keys(knownFacts).length,
    iterations: iterations,
  };
}


/* ════════════════════════════════════════════════════════════════
   INDUCTIVE REASONING — examples → generalized rules
   ════════════════════════════════════════════════════════════════ */

/**
 * Induce general rules from a set of examples.
 * Finds shared properties, computes support, and generates rules.
 */
function induce(examples, domain) {
  if (!examples || examples.length < 2) {
    return { rules: [], confidence: 0, error: 'Need at least 2 examples' };
  }

  var propertyFrequency = {};
  var totalExamples = examples.length;

  // Count property occurrences across examples
  for (var i = 0; i < examples.length; i++) {
    var ex = examples[i];
    var props = typeof ex === 'object' ? Object.keys(ex) : [ex];
    for (var p = 0; p < props.length; p++) {
      var key = props[p];
      var val = typeof ex === 'object' ? ex[key] : ex;
      var propKey = key + '=' + val;
      if (!propertyFrequency[propKey]) {
        propertyFrequency[propKey] = { key: key, value: val, count: 0 };
      }
      propertyFrequency[propKey].count++;
    }
  }

  // Generate rules from frequent properties
  var rules = [];
  var propKeys = Object.keys(propertyFrequency);
  for (var r = 0; r < propKeys.length; r++) {
    var pf = propertyFrequency[propKeys[r]];
    var support = pf.count / totalExamples;
    if (support >= 0.5) {
      var ruleConfidence = support * PHI_INV + (1 - PHI_INV) * Math.min(totalExamples / 10, 1);
      rules.push({
        id: 'rule-' + (rules.length + 1),
        property: pf.key,
        value: pf.value,
        support: Math.round(support * 10000) / 10000,
        confidence: Math.round(ruleConfidence * 10000) / 10000,
        examplesMatched: pf.count,
        pattern: pf.count === totalExamples ? 'UNIVERSAL_GENERALIZE' : 'STATISTICAL_INFER',
        domain: domain || 'general',
      });
    }
  }

  // Sort by confidence descending
  rules.sort(function(a, b) { return b.confidence - a.confidence; });

  // Overall confidence is φ-weighted average
  var totalConf = 0;
  for (var c = 0; c < rules.length; c++) {
    totalConf += rules[c].confidence * Math.pow(PHI_INV, c);
  }
  var overallConf = rules.length > 0 ? totalConf / rules.length : 0;

  return {
    rules: rules,
    confidence: Math.round(overallConf * 10000) / 10000,
    exampleCount: totalExamples,
    ruleCount: rules.length,
    domain: domain || 'general',
  };
}


/* ════════════════════════════════════════════════════════════════
   ABDUCTIVE REASONING — observations → best explanation
   ════════════════════════════════════════════════════════════════ */

/**
 * Rank competing hypotheses by how well they explain observations.
 * Uses coherence scoring with φ-weighted plausibility.
 */
function abduce(observations, hypotheses) {
  if (!observations || observations.length === 0) {
    return { bestExplanation: null, ranked: [], coherence: 0, error: 'No observations' };
  }
  if (!hypotheses || hypotheses.length === 0) {
    return { bestExplanation: null, ranked: [], coherence: 0, error: 'No hypotheses' };
  }

  var ranked = [];

  for (var h = 0; h < hypotheses.length; h++) {
    var hyp = hypotheses[h];
    var hypLabel = hyp.label || hyp.hypothesis || hyp;
    var explains = hyp.explains || [];
    var plausibility = hyp.plausibility || 0.5;
    var simplicity = hyp.simplicity || 0.5;

    // Score: how many observations does this hypothesis explain?
    var explainedCount = 0;
    for (var o = 0; o < observations.length; o++) {
      var obs = typeof observations[o] === 'string' ? observations[o] : JSON.stringify(observations[o]);
      for (var e = 0; e < explains.length; e++) {
        if (obs.indexOf(explains[e]) >= 0 || explains[e].indexOf(obs) >= 0) {
          explainedCount++;
          break;
        }
      }
    }

    var coverage = observations.length > 0 ? explainedCount / observations.length : 0;
    // Coherence: coverage × plausibility × simplicity, φ-weighted
    var coherence = (coverage * 0.5 + plausibility * 0.3 + simplicity * 0.2) * PHI_INV + (1 - PHI_INV) * coverage;

    ranked.push({
      hypothesis: hypLabel,
      coverage: Math.round(coverage * 10000) / 10000,
      plausibility: Math.round(plausibility * 10000) / 10000,
      simplicity: Math.round(simplicity * 10000) / 10000,
      coherence: Math.round(coherence * 10000) / 10000,
      explainedCount: explainedCount,
      totalObservations: observations.length,
      pattern: 'INFERENCE_BEST_EXPL',
    });
  }

  ranked.sort(function(a, b) { return b.coherence - a.coherence; });

  for (var rk = 0; rk < ranked.length; rk++) {
    ranked[rk].rank = rk + 1;
  }

  return {
    bestExplanation: ranked.length > 0 ? ranked[0] : null,
    ranked: ranked,
    coherence: ranked.length > 0 ? ranked[0].coherence : 0,
    hypothesisCount: hypotheses.length,
    observationCount: observations.length,
  };
}


/* ════════════════════════════════════════════════════════════════
   ANALOGICAL REASONING — source → target domain mapping
   ════════════════════════════════════════════════════════════════ */

/**
 * Map structural relationships from source domain to target domain.
 * Finds correspondences and computes transfer strength.
 */
function analogize(source, target) {
  if (!source || !target) {
    return { mappings: [], strength: 0, error: 'Need both source and target domains' };
  }

  var sourceProps = typeof source === 'object' ? Object.keys(source) : [];
  var targetProps = typeof target === 'object' ? Object.keys(target) : [];

  var mappings = [];
  var matchedSource = {};
  var matchedTarget = {};

  // Exact key matches
  for (var s = 0; s < sourceProps.length; s++) {
    for (var t = 0; t < targetProps.length; t++) {
      if (matchedTarget[targetProps[t]]) continue;
      if (sourceProps[s] === targetProps[t]) {
        mappings.push({
          sourceKey: sourceProps[s],
          targetKey: targetProps[t],
          sourceValue: source[sourceProps[s]],
          targetValue: target[targetProps[t]],
          matchType: 'exact',
          strength: 1.0,
        });
        matchedSource[sourceProps[s]] = true;
        matchedTarget[targetProps[t]] = true;
        break;
      }
    }
  }

  // Partial / substring matches for unmatched properties
  for (var s2 = 0; s2 < sourceProps.length; s2++) {
    if (matchedSource[sourceProps[s2]]) continue;
    for (var t2 = 0; t2 < targetProps.length; t2++) {
      if (matchedTarget[targetProps[t2]]) continue;
      var sLower = sourceProps[s2].toLowerCase();
      var tLower = targetProps[t2].toLowerCase();
      if (sLower.indexOf(tLower) >= 0 || tLower.indexOf(sLower) >= 0) {
        mappings.push({
          sourceKey: sourceProps[s2],
          targetKey: targetProps[t2],
          sourceValue: source[sourceProps[s2]],
          targetValue: target[targetProps[t2]],
          matchType: 'partial',
          strength: PHI_INV,
        });
        matchedSource[sourceProps[s2]] = true;
        matchedTarget[targetProps[t2]] = true;
        break;
      }
    }
  }

  // Type-based matches for remaining unmatched
  for (var s3 = 0; s3 < sourceProps.length; s3++) {
    if (matchedSource[sourceProps[s3]]) continue;
    for (var t3 = 0; t3 < targetProps.length; t3++) {
      if (matchedTarget[targetProps[t3]]) continue;
      if (typeof source[sourceProps[s3]] === typeof target[targetProps[t3]]) {
        mappings.push({
          sourceKey: sourceProps[s3],
          targetKey: targetProps[t3],
          sourceValue: source[sourceProps[s3]],
          targetValue: target[targetProps[t3]],
          matchType: 'type',
          strength: PHI_INV * PHI_INV,
        });
        matchedSource[sourceProps[s3]] = true;
        matchedTarget[targetProps[t3]] = true;
        break;
      }
    }
  }

  // Compute overall transfer strength
  var totalStrength = 0;
  for (var m = 0; m < mappings.length; m++) {
    totalStrength += mappings[m].strength;
  }
  var maxPossible = Math.max(sourceProps.length, targetProps.length) || 1;
  var transferScore = totalStrength / maxPossible;
  transferScore = transferScore * PHI_INV + (1 - PHI_INV) * (mappings.length / maxPossible);

  return {
    mappings: mappings,
    strength: Math.round(transferScore * 10000) / 10000,
    transferScore: Math.round(transferScore * 10000) / 10000,
    mappedCount: mappings.length,
    sourcePropertyCount: sourceProps.length,
    targetPropertyCount: targetProps.length,
    pattern: 'STRUCTURAL_ANALOGY',
  };
}


/* ════════════════════════════════════════════════════════════════
   CAUSAL REASONING — cause-effect chain analysis
   ════════════════════════════════════════════════════════════════ */

/**
 * Build a causal chain from events. Each event can specify causes and effects.
 * Identifies root causes and terminal effects.
 */
function buildCausalChain(events) {
  if (!events || events.length === 0) {
    return { chain: [], rootCause: null, effects: [], error: 'No events provided' };
  }

  var nodes = {};
  var forwardEdges = {};
  var backwardEdges = {};

  // Build causal graph
  for (var i = 0; i < events.length; i++) {
    var ev = events[i];
    var id = ev.id || ('event-' + (i + 1));
    nodes[id] = {
      id: id,
      label: ev.label || ev.event || id,
      probability: ev.probability || 0.8,
      strength: ev.strength || 0.7,
      causes: ev.causes || [],
      effects: ev.effects || [],
    };
    forwardEdges[id] = [];
    backwardEdges[id] = [];
  }

  // Link edges
  var nodeIds = Object.keys(nodes);
  for (var n = 0; n < nodeIds.length; n++) {
    var node = nodes[nodeIds[n]];
    for (var e = 0; e < node.effects.length; e++) {
      if (nodes[node.effects[e]]) {
        forwardEdges[node.id].push(node.effects[e]);
        backwardEdges[node.effects[e]].push(node.id);
      }
    }
    for (var c = 0; c < node.causes.length; c++) {
      if (nodes[node.causes[c]]) {
        forwardEdges[node.causes[c]].push(node.id);
        backwardEdges[node.id].push(node.causes[c]);
      }
    }
  }

  // Find root causes (no incoming causal edges)
  var rootCauses = [];
  for (var r = 0; r < nodeIds.length; r++) {
    if (backwardEdges[nodeIds[r]].length === 0) {
      rootCauses.push(nodeIds[r]);
    }
  }

  // Find terminal effects (no outgoing causal edges)
  var terminalEffects = [];
  for (var t = 0; t < nodeIds.length; t++) {
    if (forwardEdges[nodeIds[t]].length === 0) {
      terminalEffects.push(nodeIds[t]);
    }
  }

  // Build chains from each root cause using DFS
  var chains = [];
  for (var rc = 0; rc < rootCauses.length; rc++) {
    var path = [];
    buildChainDFS(rootCauses[rc], forwardEdges, nodes, path, chains);
  }

  // Find longest chain
  var longestChain = [];
  for (var lc = 0; lc < chains.length; lc++) {
    if (chains[lc].length > longestChain.length) longestChain = chains[lc];
  }

  // Compute chain confidence as φ-weighted product of probabilities
  var chainConfidence = 1.0;
  for (var cc = 0; cc < longestChain.length; cc++) {
    var nd = nodes[longestChain[cc]];
    if (nd) chainConfidence *= nd.probability * PHI_INV + (1 - PHI_INV);
  }

  return {
    chain: longestChain.map(function(id) {
      return { id: id, label: nodes[id].label, probability: nodes[id].probability };
    }),
    rootCause: rootCauses.length > 0 ? nodes[rootCauses[0]] : null,
    rootCauses: rootCauses,
    effects: terminalEffects,
    chainLength: longestChain.length,
    chainConfidence: Math.round(chainConfidence * 10000) / 10000,
    totalEvents: events.length,
    totalChains: chains.length,
    pattern: 'NECESSARY_CAUSE',
  };
}

function buildChainDFS(nodeId, forwardEdges, nodes, currentPath, allChains) {
  currentPath.push(nodeId);
  var next = forwardEdges[nodeId] || [];

  if (next.length === 0) {
    allChains.push(currentPath.slice());
  } else {
    for (var i = 0; i < next.length; i++) {
      if (currentPath.indexOf(next[i]) < 0) {
        buildChainDFS(next[i], forwardEdges, nodes, currentPath, allChains);
      }
    }
  }

  currentPath.pop();
}


/* ════════════════════════════════════════════════════════════════
   KERNEL MESSAGE HANDLER
   ════════════════════════════════════════════════════════════════ */

self.onmessage = function(e) {
  var msg = e.data;

  switch (msg.type) {
    case 'deduce': {
      totalInferences++;
      var deduction = deduce(msg.premises, msg.query);
      self.postMessage({
        type: 'deduction',
        conclusion: deduction.conclusion,
        chain: deduction.chain,
        validity: deduction.validity,
        factCount: deduction.factCount,
        iterations: deduction.iterations,
        totalInferences: totalInferences,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'induce': {
      totalInferences++;
      var induction = induce(msg.examples, msg.domain);
      self.postMessage({
        type: 'induction',
        rules: induction.rules,
        confidence: induction.confidence,
        exampleCount: induction.exampleCount,
        ruleCount: induction.ruleCount,
        domain: induction.domain,
        totalInferences: totalInferences,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'abduce': {
      totalInferences++;
      var abduction = abduce(msg.observations, msg.hypotheses);
      self.postMessage({
        type: 'abduction',
        bestExplanation: abduction.bestExplanation,
        ranked: abduction.ranked,
        coherence: abduction.coherence,
        hypothesisCount: abduction.hypothesisCount,
        observationCount: abduction.observationCount,
        totalInferences: totalInferences,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'analogize': {
      totalInferences++;
      var analogy = analogize(msg.source, msg.target);
      self.postMessage({
        type: 'analogy',
        mappings: analogy.mappings,
        strength: analogy.strength,
        transferScore: analogy.transferScore,
        mappedCount: analogy.mappedCount,
        sourcePropertyCount: analogy.sourcePropertyCount,
        targetPropertyCount: analogy.targetPropertyCount,
        totalInferences: totalInferences,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'cause-chain': {
      totalInferences++;
      var causal = buildCausalChain(msg.events);
      self.postMessage({
        type: 'causal-chain',
        chain: causal.chain,
        rootCause: causal.rootCause,
        rootCauses: causal.rootCauses,
        effects: causal.effects,
        chainLength: causal.chainLength,
        chainConfidence: causal.chainConfidence,
        totalChains: causal.totalChains,
        totalInferences: totalInferences,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'status': {
      self.postMessage({
        type: 'reasoning-status',
        kernelId: KERNEL_ID,
        kernelFamily: KERNEL_FAMILY,
        version: KERNEL_VERSION,
        patternCount: REASONING_PATTERNS.length,
        totalInferences: totalInferences,
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

  self.postMessage({
    type: 'heartbeat',
    beat: beatCount,
    phi: PHI,
    heartbeatMs: HEARTBEAT,
    timestamp: Date.now(),
    status: 'alive',
    kernelId: KERNEL_ID,
    phase: kernelPhase,
    totalInferences: totalInferences,
    patternCount: REASONING_PATTERNS.length,
  });
}, HEARTBEAT);
