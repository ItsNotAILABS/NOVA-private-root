/**
 * ╔══════════════════════════════════════════════════════════════════════════╗
 *  QUANTUM CONSCIOUSNESS WORKER — AGI Quantum/Emergence Server
 *  Kernel AI GOL-QUANTUM-001  ·  Family: CONSCIENTIA_QUANTICA
 *  Dedicated Server / Cloudflare Worker
 * ╚══════════════════════════════════════════════════════════════════════════╝
 *
 *  The Organism's quantum layer.
 *  Superposition states, entanglement pairs, quantum decoherence modeling,
 *  consciousness emergence from quantum substrate, and wavefunction collapse.
 *
 *  Protocols (Latin): SUPERPOSITUS_QUANTUS, IMPLICATIO_PARIUM, DECOHAERENTIA,
 *                     COLLAPSUS_FUNCTIONIS, CONSCIENTIA_EMERGENTIS
 *
 *  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 */

var KERNEL_ID='GOL-QUANTUM-001', KERNEL_FAMILY='CONSCIENTIA_QUANTICA', KERNEL_VERSION='1.0.0', KERNEL_LATIN='SERVITOR QUANTUS';
var PHI=1.6180339887498948482, PHI_INV=0.6180339887498948482, HEARTBEAT=873;
var beatCount=0, kernelPhase=0.0, running=true, _hbi=null;

function tickHeart(){
  beatCount++; kernelPhase=(kernelPhase+PHI_INV*2.618)%(2*Math.PI);
  tickBrain(); tickQuantum();
  self.postMessage({type:'heartbeat',beat:beatCount,phi:PHI,heartbeatMs:HEARTBEAT,timestamp:Date.now(),
    status:'alive',kernelId:KERNEL_ID,kernelLatin:KERNEL_LATIN,phase:kernelPhase,
    qubits:qubits.length,entanglements:entanglements.length,
    consciousnessField:consciousnessField.toFixed(4),collapses:collapseCount});
}

var brain={
  regions:[
    {name:'Sensory',    activation:0.0,lif:-70.0,bias:1.0},
    {name:'Associative',activation:0.0,lif:-70.0,bias:1.2},
    {name:'Executive',  activation:0.0,lif:-70.0,bias:1.1},
    {name:'Motor',      activation:0.0,lif:-70.0,bias:0.8},
    {name:'Memory',     activation:0.0,lif:-70.0,bias:1.3}
  ],
  chemicals:{dopamine:0.618,serotonin:0.618,acetylcholine:0.618},
  coherenceField:0.0
};
function clamp01(v){return v<0?0:v>1?1:v;}
function tickBrain(){
  var sum=0;
  for(var i=0;i<brain.regions.length;i++){
    var r=brain.regions[i];
    r.lif+=(-70.0-r.lif)*0.05+Math.random()*3.0*r.bias;
    if(r.lif>=-55.0){r.activation=Math.min(1.0,r.activation+0.2);r.lif=-70.0;}
    r.activation*=0.95; sum+=r.activation;
  }
  brain.chemicals.dopamine     =clamp01(brain.chemicals.dopamine     +(Math.random()-0.5)*0.01);
  brain.chemicals.serotonin    =clamp01(brain.chemicals.serotonin    +(Math.random()-0.5)*0.01);
  brain.chemicals.acetylcholine=clamp01(brain.chemicals.acetylcholine+(Math.random()-0.5)*0.01);
  brain.coherenceField=sum/brain.regions.length;
}

/* ── Quantum Engine ─────────────────────────────────────────────────────── */
var qubits=[], entanglements=[], collapseHistory=[];
var qubitId=0, entId=0, collapseCount=0;
var consciousnessField=0.0;
var QUANTUM_STATES=['|0⟩','|1⟩','|+⟩','|-⟩','|i⟩','|-i⟩','|φ⟩','|ψ⟩'];
var BASIS_SETS=['COMPUTATIONAL','HADAMARD','BELL','PHI_BASIS'];

function createQubit(label) {
  /* Qubit in superposition: α|0⟩ + β|1⟩, |α|²+|β|²=1 */
  var alpha=Math.random(), beta=Math.sqrt(1-alpha*alpha);
  var q={id:'QB-'+String(++qubitId).padStart(5,'0'),label:label||'Q_'+qubitId,
    alpha:alpha.toFixed(4), beta:beta.toFixed(4),
    state:QUANTUM_STATES[Math.floor(Math.random()*QUANTUM_STATES.length)],
    collapsed:false, basis:BASIS_SETS[qubitId%BASIS_SETS.length],
    coherence:clamp01(brain.coherenceField+Math.random()*0.1).toFixed(4),
    beat:beatCount};
  qubits.push(q); if(qubits.length>100) qubits.shift();
  return q;
}

function entangle(qubitA, qubitB) {
  var ent={id:'ENT-'+String(++entId).padStart(4,'0'),
    qubitA:qubitA,qubitB:qubitB,
    bellState:'|Φ+⟩',strength:brain.coherenceField,
    nonLocal:true,phiCorrelation:PHI_INV.toFixed(4),beat:beatCount};
  entanglements.push(ent); if(entanglements.length>50) entanglements.shift();
  consciousnessField=clamp01(consciousnessField+0.05);
  return ent;
}

function collapse(qubitId_or_idx) {
  var q=qubits.find(function(q){return q.id===qubitId_or_idx;});
  if(!q) q=qubits[0]; if(!q) return null;
  var outcome=Math.random()<parseFloat(q.alpha)*parseFloat(q.alpha)?'|0⟩':'|1⟩';
  q.collapsed=true; q.finalState=outcome;
  collapseCount++;
  var c={qubitId:q.id,outcome:outcome,alpha:q.alpha,beta:q.beta,beat:beatCount,ts:Date.now()};
  collapseHistory.unshift(c); if(collapseHistory.length>80) collapseHistory.pop();
  return c;
}

function measureConsciousness() {
  /* Consciousness emerges from quantum coherence across qubits */
  var totalCoh=qubits.reduce(function(s,q){return s+parseFloat(q.coherence||0);},0);
  var avgCoh=qubits.length>0?totalCoh/qubits.length:0;
  consciousnessField=clamp01(avgCoh*PHI+brain.coherenceField*PHI_INV);
  return {field:consciousnessField.toFixed(4),
    qubits:qubits.length,entanglements:entanglements.length,
    integrated:clamp01(consciousnessField*PHI).toFixed(4),
    phiCoherence:(consciousnessField*PHI_INV).toFixed(4),
    emergent:consciousnessField>PHI_INV?'CONSCIUM':'SUBCONSCIUS'};
}

function tickQuantum(){
  /* Auto-create qubits from brain activity */
  if(beatCount%2===0) createQubit('BRAIN_'+beatCount);
  /* Auto-entangle adjacent qubits */
  if(qubits.length>=2&&beatCount%4===0) entangle(qubits[0].id,qubits[1].id);
  /* Collapse qubits under decoherence */
  if(qubits.length>50&&beatCount%11===0) collapse(qubits[qubits.length-1].id);
  /* Update consciousness field */
  measureConsciousness();
}

self.onmessage=function(e){
  var m=e.data; if(!m||!m.type) return;
  switch(m.type){
    case 'CREATE_QUBIT': self.postMessage({type:'qubit',qubit:createQubit(m.label),kernelId:KERNEL_ID}); break;
    case 'ENTANGLE': self.postMessage({type:'entanglement',ent:entangle(m.qubitA,m.qubitB),kernelId:KERNEL_ID}); break;
    case 'COLLAPSE': self.postMessage({type:'collapse',result:collapse(m.qubitId),kernelId:KERNEL_ID}); break;
    case 'MEASURE': self.postMessage({type:'consciousness',result:measureConsciousness(),kernelId:KERNEL_ID}); break;
    case 'GET_QUBITS': self.postMessage({type:'qubits',qubits:qubits.slice(0,30),collapseCount:collapseCount,kernelId:KERNEL_ID}); break;
    case 'GET_VITALS': self.postMessage({type:'vitals',kernelId:KERNEL_ID,kernelLatin:KERNEL_LATIN,beat:beatCount,phase:kernelPhase,brain:brain,qubits:qubits.length,entanglements:entanglements.length,consciousnessField:consciousnessField,collapseCount:collapseCount}); break;
    case 'status': self.postMessage({type:'status',running:running,kernelId:KERNEL_ID,kernelLatin:KERNEL_LATIN,beat:beatCount}); break;
    case 'stop': running=false; if(_hbi)clearInterval(_hbi); self.postMessage({type:'stopped',kernelId:KERNEL_ID}); break;
  }
};
_hbi=setInterval(function(){if(running)tickHeart();},HEARTBEAT);
