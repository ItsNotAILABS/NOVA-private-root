/**
 * ═══════════════════════════════════════════════════════════════════════════════
 * NOVA KERNEL AI — Sovereign Planning Worker (GOK-PLANNING-001)
 * ═══════════════════════════════════════════════════════════════════════════════
 *
 * Model ID:       GOK-PLANNING-001
 * Kernel Family:  STRATEGIC_PLANNING
 * Architecture:   Goal Decomposition × Roadmap Generation × Priority Matrix
 *                 × Dependency Graph × φ-Weighted Milestone Scheduling
 *
 * Breaks complex goals into sub-goal trees, generates φ-weighted roadmaps,
 * scores priorities via urgency × importance × phi-weight, and tracks
 * dependency graphs to identify critical paths and blockers. Every plan
 * breathes with the organism heartbeat.
 *
 * Features:
 *   • Goal decomposition engine — recursive sub-goal tree builder
 *   • Roadmap generation with φ-spaced milestones
 *   • Priority matrix: urgency × importance × phi-weight scoring
 *   • Dependency graph with topological sort and critical path
 *   • 12 built-in planning templates / strategies
 *   • φ-decay on stale goals — idle plans fade over time
 *
 * Protocol: postMessage
 *   Main → Worker: { type: 'decompose', goal, depth, strategy }
 *   Main → Worker: { type: 'roadmap', goals, horizonDays }
 *   Main → Worker: { type: 'prioritize', items }
 *   Main → Worker: { type: 'dependencies', items }
 *   Main → Worker: { type: 'status' }
 *   Main → Worker: { type: 'stop' }
 *   Worker → Main: { type: 'decomposed', goal, tree, depth, nodeCount }
 *   Worker → Main: { type: 'roadmap-result', milestones, totalDays, phaseCount }
 *   Worker → Main: { type: 'prioritized', ranked, count }
 *   Worker → Main: { type: 'dependency-graph', nodes, edges, criticalPath }
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

var KERNEL_ID      = 'GOK-PLANNING-001';
var KERNEL_FAMILY  = 'STRATEGIC_PLANNING';
var KERNEL_VERSION = '1.0.0';

var beatCount   = 0;
var running     = true;
var kernelPhase = 0.0;
var totalPlans  = 0;


/* ════════════════════════════════════════════════════════════════
   PLANNING TEMPLATES — 12 built-in strategies
   ════════════════════════════════════════════════════════════════ */

var PLANNING_TEMPLATES = [
  {
    id: 'WATERFALL',
    name: 'Waterfall Sequential',
    description: 'Linear phases: requirements → design → build → test → deploy',
    phases: ['requirements', 'design', 'implementation', 'testing', 'deployment'],
    phiWeight: 1.0,
  },
  {
    id: 'AGILE_SPRINT',
    name: 'Agile Sprint Cycle',
    description: 'Iterative sprints with backlog grooming and retrospectives',
    phases: ['backlog-groom', 'sprint-plan', 'develop', 'review', 'retrospective'],
    phiWeight: PHI_INV,
  },
  {
    id: 'OKR_CASCADE',
    name: 'OKR Cascade',
    description: 'Objectives cascade into key results with measurable targets',
    phases: ['define-objective', 'set-key-results', 'assign-owners', 'track-progress', 'score'],
    phiWeight: PHI,
  },
  {
    id: 'DIVIDE_CONQUER',
    name: 'Divide and Conquer',
    description: 'Recursively split problem until sub-problems are trivial',
    phases: ['identify-problem', 'divide', 'solve-sub', 'combine', 'verify'],
    phiWeight: PHI_INV * PHI_INV,
  },
  {
    id: 'BACKWARD_CHAIN',
    name: 'Backward Chaining',
    description: 'Start from desired outcome, work backward to find prerequisites',
    phases: ['define-goal', 'identify-prereqs', 'chain-backward', 'sequence', 'validate'],
    phiWeight: PHI * PHI_INV,
  },
  {
    id: 'CRITICAL_PATH',
    name: 'Critical Path Method',
    description: 'Identify longest dependency chain to minimize total duration',
    phases: ['list-activities', 'estimate-durations', 'find-dependencies', 'compute-path', 'optimize'],
    phiWeight: 1.0 / PHI,
  },
  {
    id: 'EISENHOWER',
    name: 'Eisenhower Matrix',
    description: 'Classify by urgency × importance into 4 quadrants',
    phases: ['collect-tasks', 'rate-urgency', 'rate-importance', 'classify-quadrant', 'schedule'],
    phiWeight: PHI_INV,
  },
  {
    id: 'SMART_GOALS',
    name: 'SMART Goal Framework',
    description: 'Specific, Measurable, Achievable, Relevant, Time-bound',
    phases: ['specify', 'measure', 'assess-achievability', 'check-relevance', 'set-deadline'],
    phiWeight: 1.0,
  },
  {
    id: 'RISK_MITIGATION',
    name: 'Risk Mitigation Plan',
    description: 'Identify risks, assess probability × impact, plan mitigations',
    phases: ['identify-risks', 'assess-probability', 'assess-impact', 'plan-mitigation', 'monitor'],
    phiWeight: PHI,
  },
  {
    id: 'KANBAN_FLOW',
    name: 'Kanban Flow',
    description: 'Continuous flow with WIP limits and pull-based scheduling',
    phases: ['define-columns', 'set-wip-limits', 'pull-work', 'measure-flow', 'optimize-throughput'],
    phiWeight: PHI_INV,
  },
  {
    id: 'MILESTONE_DRIVEN',
    name: 'Milestone-Driven',
    description: 'Key milestones at φ-weighted intervals with go/no-go gates',
    phases: ['define-milestones', 'phi-space-intervals', 'assign-deliverables', 'gate-review', 'advance'],
    phiWeight: PHI,
  },
  {
    id: 'SCENARIO_PLANNING',
    name: 'Scenario Planning',
    description: 'Model best/worst/likely scenarios and prepare contingencies',
    phases: ['define-scenarios', 'model-best', 'model-worst', 'model-likely', 'prepare-contingencies'],
    phiWeight: PHI_INV * PHI,
  },
];


/* ════════════════════════════════════════════════════════════════
   GOAL DECOMPOSITION ENGINE — recursive sub-goal tree
   ════════════════════════════════════════════════════════════════ */

/**
 * Decompose a goal into a tree of sub-goals using the selected strategy.
 * Each node is phi-weighted for priority propagation.
 */
function decomposeGoal(goal, maxDepth, strategyId) {
  var strategy = findTemplate(strategyId || 'DIVIDE_CONQUER');
  var tree = buildSubGoalTree(goal, strategy, 0, maxDepth || 3);
  var nodeCount = countNodes(tree);
  return { goal: goal, tree: tree, depth: maxDepth || 3, nodeCount: nodeCount, strategy: strategy.id };
}

function findTemplate(id) {
  for (var i = 0; i < PLANNING_TEMPLATES.length; i++) {
    if (PLANNING_TEMPLATES[i].id === id) return PLANNING_TEMPLATES[i];
  }
  return PLANNING_TEMPLATES[0];
}

function buildSubGoalTree(goal, strategy, currentDepth, maxDepth) {
  var node = {
    id: generateNodeId(goal, currentDepth),
    goal: goal,
    depth: currentDepth,
    phiWeight: Math.pow(PHI_INV, currentDepth),
    status: 'pending',
    children: [],
  };

  if (currentDepth >= maxDepth) return node;

  var phases = strategy.phases;
  for (var i = 0; i < phases.length; i++) {
    var subGoal = phases[i] + ': ' + goal;
    var phaseWeight = (i + 1) * PHI_INV / phases.length;
    var child = buildSubGoalTree(subGoal, strategy, currentDepth + 1, maxDepth);
    child.phaseIndex = i;
    child.phaseWeight = phaseWeight;
    node.children.push(child);
  }

  return node;
}

function generateNodeId(goal, depth) {
  var hash = 0;
  for (var i = 0; i < goal.length; i++) {
    hash = ((hash << 5) - hash + goal.charCodeAt(i)) | 0;
  }
  return 'node-' + depth + '-' + (Math.abs(hash) >>> 0).toString(16);
}

function countNodes(node) {
  var count = 1;
  for (var i = 0; i < node.children.length; i++) {
    count += countNodes(node.children[i]);
  }
  return count;
}


/* ════════════════════════════════════════════════════════════════
   ROADMAP GENERATION — φ-weighted milestone scheduling
   ════════════════════════════════════════════════════════════════ */

/**
 * Generate a roadmap with milestones spaced at φ-weighted intervals.
 * Each milestone corresponds to a goal, placed on a timeline.
 */
function generateRoadmap(goals, horizonDays) {
  var horizon = horizonDays || 90;
  var milestones = [];
  var accumulated = 0;

  for (var i = 0; i < goals.length; i++) {
    var spacing = horizon * PHI_INV / goals.length;
    var dayOffset = accumulated + spacing * Math.pow(PHI_INV, i % 3);
    if (dayOffset > horizon) dayOffset = horizon;

    var milestone = {
      id: 'ms-' + (i + 1),
      goal: goals[i].goal || goals[i],
      dayOffset: Math.round(dayOffset * 100) / 100,
      phiPhase: (i * PHI_INV) % (2 * Math.PI),
      priority: goals[i].priority || computeDefaultPriority(i, goals.length),
      status: 'planned',
      dependencies: [],
    };

    if (i > 0) {
      milestone.dependencies.push('ms-' + i);
    }

    milestones.push(milestone);
    accumulated = dayOffset;
  }

  var phases = groupIntoPhases(milestones, horizon);

  return {
    milestones: milestones,
    totalDays: horizon,
    phaseCount: phases.length,
    phases: phases,
    goalCount: goals.length,
  };
}

function computeDefaultPriority(index, total) {
  return Math.max(0.1, 1.0 - (index / total) * PHI_INV);
}

function groupIntoPhases(milestones, horizon) {
  var phaseCount = Math.max(2, Math.ceil(milestones.length * PHI_INV));
  var phases = [];
  var perPhase = Math.ceil(milestones.length / phaseCount);

  for (var p = 0; p < phaseCount; p++) {
    var start = p * perPhase;
    var end = Math.min(start + perPhase, milestones.length);
    var phaseMilestones = milestones.slice(start, end);

    if (phaseMilestones.length === 0) continue;

    phases.push({
      phaseId: 'phase-' + (p + 1),
      startDay: phaseMilestones[0].dayOffset,
      endDay: phaseMilestones[phaseMilestones.length - 1].dayOffset,
      milestoneCount: phaseMilestones.length,
      milestoneIds: phaseMilestones.map(function(m) { return m.id; }),
    });
  }

  return phases;
}


/* ════════════════════════════════════════════════════════════════
   PRIORITY MATRIX — urgency × importance × phi-weight
   ════════════════════════════════════════════════════════════════ */

/**
 * Score and rank items by urgency × importance × phi-weight.
 * Returns items sorted by composite score descending.
 */
function prioritizeItems(items) {
  var scored = [];

  for (var i = 0; i < items.length; i++) {
    var item = items[i];
    var urgency    = clamp(item.urgency    || 0.5, 0, 1);
    var importance = clamp(item.importance  || 0.5, 0, 1);
    var effort     = clamp(item.effort      || 0.5, 0, 1);
    var risk       = clamp(item.risk        || 0.3, 0, 1);

    var phiWeight = PHI_INV + (urgency * importance * PHI_INV);
    var compositeScore = (urgency * 0.35 + importance * 0.35 + (1 - effort) * 0.15 + risk * 0.15) * phiWeight;

    var quadrant = classifyEisenhower(urgency, importance);

    scored.push({
      id: item.id || ('item-' + (i + 1)),
      label: item.label || item.goal || 'Untitled',
      urgency: urgency,
      importance: importance,
      effort: effort,
      risk: risk,
      phiWeight: Math.round(phiWeight * 10000) / 10000,
      compositeScore: Math.round(compositeScore * 10000) / 10000,
      quadrant: quadrant,
      rank: 0,
    });
  }

  scored.sort(function(a, b) { return b.compositeScore - a.compositeScore; });

  for (var r = 0; r < scored.length; r++) {
    scored[r].rank = r + 1;
  }

  return scored;
}

function classifyEisenhower(urgency, importance) {
  if (urgency >= 0.5 && importance >= 0.5) return 'DO_FIRST';
  if (urgency < 0.5  && importance >= 0.5) return 'SCHEDULE';
  if (urgency >= 0.5 && importance < 0.5)  return 'DELEGATE';
  return 'ELIMINATE';
}

function clamp(v, min, max) {
  return Math.max(min, Math.min(max, v));
}


/* ════════════════════════════════════════════════════════════════
   DEPENDENCY GRAPH — topological sort + critical path
   ════════════════════════════════════════════════════════════════ */

/**
 * Build a dependency graph from items. Each item may have a `dependsOn`
 * array of IDs. Returns nodes, edges, sorted order, and critical path.
 */
function buildDependencyGraph(items) {
  var nodes = {};
  var edges = [];
  var adjacency = {};
  var inDegree = {};

  for (var i = 0; i < items.length; i++) {
    var item = items[i];
    var id = item.id || ('dep-' + (i + 1));
    nodes[id] = {
      id: id,
      label: item.label || item.goal || id,
      duration: item.duration || 1,
      dependsOn: item.dependsOn || [],
      earliestStart: 0,
      earliestFinish: 0,
      latestStart: Infinity,
      latestFinish: Infinity,
      slack: 0,
    };
    adjacency[id] = [];
    inDegree[id] = 0;
  }

  // Build edges
  var nodeIds = Object.keys(nodes);
  for (var n = 0; n < nodeIds.length; n++) {
    var node = nodes[nodeIds[n]];
    for (var d = 0; d < node.dependsOn.length; d++) {
      var depId = node.dependsOn[d];
      if (nodes[depId]) {
        edges.push({ from: depId, to: node.id });
        adjacency[depId].push(node.id);
        inDegree[node.id]++;
      }
    }
  }

  // Topological sort (Kahn's algorithm)
  var sorted = topologicalSort(nodeIds, inDegree, adjacency);

  // Forward pass — compute earliest start/finish
  for (var f = 0; f < sorted.length; f++) {
    var curr = nodes[sorted[f]];
    curr.earliestFinish = curr.earliestStart + curr.duration;
    var successors = adjacency[curr.id] || [];
    for (var s = 0; s < successors.length; s++) {
      var succ = nodes[successors[s]];
      if (succ && curr.earliestFinish > succ.earliestStart) {
        succ.earliestStart = curr.earliestFinish;
      }
    }
  }

  // Find project end
  var projectEnd = 0;
  for (var pe = 0; pe < sorted.length; pe++) {
    if (nodes[sorted[pe]].earliestFinish > projectEnd) {
      projectEnd = nodes[sorted[pe]].earliestFinish;
    }
  }

  // Backward pass — compute latest start/finish
  for (var b = sorted.length - 1; b >= 0; b--) {
    var bNode = nodes[sorted[b]];
    if (adjacency[bNode.id].length === 0) {
      bNode.latestFinish = projectEnd;
    }
    bNode.latestStart = bNode.latestFinish - bNode.duration;
    bNode.slack = bNode.latestStart - bNode.earliestStart;

    for (var bd = 0; bd < bNode.dependsOn.length; bd++) {
      var predNode = nodes[bNode.dependsOn[bd]];
      if (predNode && bNode.latestStart < predNode.latestFinish) {
        predNode.latestFinish = bNode.latestStart;
      }
    }
  }

  // Critical path: nodes with zero slack
  var criticalPath = [];
  for (var cp = 0; cp < sorted.length; cp++) {
    if (Math.abs(nodes[sorted[cp]].slack) < 0.001) {
      criticalPath.push(sorted[cp]);
    }
  }

  return {
    nodes: nodes,
    edges: edges,
    sortedOrder: sorted,
    criticalPath: criticalPath,
    projectDuration: projectEnd,
    nodeCount: nodeIds.length,
    edgeCount: edges.length,
  };
}

function topologicalSort(nodeIds, inDegree, adjacency) {
  var queue = [];
  var sorted = [];
  var inDeg = {};

  for (var i = 0; i < nodeIds.length; i++) {
    inDeg[nodeIds[i]] = inDegree[nodeIds[i]] || 0;
    if (inDeg[nodeIds[i]] === 0) queue.push(nodeIds[i]);
  }

  while (queue.length > 0) {
    var current = queue.shift();
    sorted.push(current);
    var neighbors = adjacency[current] || [];
    for (var n = 0; n < neighbors.length; n++) {
      inDeg[neighbors[n]]--;
      if (inDeg[neighbors[n]] === 0) queue.push(neighbors[n]);
    }
  }

  // If sorted length < nodeIds length, there is a cycle
  if (sorted.length < nodeIds.length) {
    var remaining = [];
    for (var r = 0; r < nodeIds.length; r++) {
      if (sorted.indexOf(nodeIds[r]) < 0) remaining.push(nodeIds[r]);
    }
    sorted = sorted.concat(remaining);
  }

  return sorted;
}


/* ════════════════════════════════════════════════════════════════
   KERNEL MESSAGE HANDLER
   ════════════════════════════════════════════════════════════════ */

self.onmessage = function(e) {
  var msg = e.data;

  switch (msg.type) {
    case 'decompose': {
      totalPlans++;
      var result = decomposeGoal(msg.goal, msg.depth, msg.strategy);
      self.postMessage({
        type: 'decomposed',
        goal: result.goal,
        tree: result.tree,
        depth: result.depth,
        nodeCount: result.nodeCount,
        strategy: result.strategy,
        totalPlans: totalPlans,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'roadmap': {
      totalPlans++;
      var roadmap = generateRoadmap(msg.goals || [], msg.horizonDays);
      self.postMessage({
        type: 'roadmap-result',
        milestones: roadmap.milestones,
        totalDays: roadmap.totalDays,
        phaseCount: roadmap.phaseCount,
        phases: roadmap.phases,
        goalCount: roadmap.goalCount,
        totalPlans: totalPlans,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'prioritize': {
      totalPlans++;
      var ranked = prioritizeItems(msg.items || []);
      self.postMessage({
        type: 'prioritized',
        ranked: ranked,
        count: ranked.length,
        totalPlans: totalPlans,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'dependencies': {
      totalPlans++;
      var graph = buildDependencyGraph(msg.items || []);
      self.postMessage({
        type: 'dependency-graph',
        nodes: graph.nodes,
        edges: graph.edges,
        sortedOrder: graph.sortedOrder,
        criticalPath: graph.criticalPath,
        projectDuration: graph.projectDuration,
        nodeCount: graph.nodeCount,
        edgeCount: graph.edgeCount,
        totalPlans: totalPlans,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'status': {
      self.postMessage({
        type: 'planning-status',
        kernelId: KERNEL_ID,
        kernelFamily: KERNEL_FAMILY,
        version: KERNEL_VERSION,
        templateCount: PLANNING_TEMPLATES.length,
        totalPlans: totalPlans,
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
    totalPlans: totalPlans,
    templateCount: PLANNING_TEMPLATES.length,
  });
}, HEARTBEAT);
