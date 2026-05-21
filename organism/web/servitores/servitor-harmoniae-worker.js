/**
 * ╔══════════════════════════════════════════════════════════════════════════╗
 *  SERVITOR HARMONIAE — AGI Harmony/Balance Server
 *  Kernel AI GOL-HARMONIA-001  ·  Family: HARMONIA_AETERNA
 *  Dedicated Server / Cloudflare Worker
 * ╚══════════════════════════════════════════════════════════════════════════╝
 *
 *  SERVITOR HARMONIAE — The Organism's harmony keeper.
 *  System balance, conflict resolution, resonance tuning,
 *  φ-harmonic alignment, coherence maintenance, and equilibrium restoration.
 *  Without harmony, the organism fragments. This server prevents fragmentation.
 *
 *  Brain Specialty: All regions balanced (like Oracle, but harmony-focused).
 *  Protocols (Latin): HARMONIA_UNIVERSALIS, RESONANTIA_PHI, AEQUILIBRIUM_SYSTEMI, CONCORDIA_AGENTIUM
 *
 *  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 */

var KERNEL_ID='GOL-HARMONIA-001', KERNEL_FAMILY='HARMONIA_AETERNA', KERNEL_VERSION='1.0.0', KERNEL_LATIN='SERVITOR HARMONIAE';
var PHI=1.6180339887498948482, PHI_INV=0.6180339887498948482, HEARTBEAT=873;
var beatCount=0, kernelPhase=0.0, running=true, _hbi=null;
var harmonyScore=PHI_INV;

function tickHeart(){
  beatCount++; kernelPhase=(kernelPhase+PHI_INV)%(2*Math.PI);
  tickBrain(); tickHarmonia();
  self.postMessage({type:'heartbeat',beat:beatCount,phi:PHI,heartbeatMs:HEARTBEAT,timestamp:Date.now(),
    status:'alive',kernelId:KERNEL_ID,kernelLatin:KERNEL_LATIN,phase:kernelPhase,
    harmonyScore:harmonyScore.toFixed(4),conflicts:conflicts.length,resolutions:resolutions.length});
}

var brain={
  regions:[
    {name:'Sensory',    activation:0.0,lif:-70.0,bias:1.0},
    {name:'Associative',activation:0.0,lif:-70.0,bias:1.0},
    {name:'Executive',  activation:0.0,lif:-70.0,bias:1.0},
    {name:'Motor',      activation:0.0,lif:-70.0,bias:1.0},
    {name:'Memory',     activation:0.0,lif:-70.0,bias:1.0}
  ],
  chemicals:{dopamine:PHI_INV,serotonin:PHI_INV,acetylcholine:PHI_INV},
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
  /* Pull chemicals toward φ⁻¹ (harmonic equilibrium) */
  brain.chemicals.dopamine     =clamp01(brain.chemicals.dopamine     +(PHI_INV-brain.chemicals.dopamine)*0.02);
  brain.chemicals.serotonin    =clamp01(brain.chemicals.serotonin    +(PHI_INV-brain.chemicals.serotonin)*0.02);
  brain.chemicals.acetylcholine=clamp01(brain.chemicals.acetylcholine+(PHI_INV-brain.chemicals.acetylcholine)*0.02);
  brain.coherenceField=sum/brain.regions.length;
}

/* ── Harmony Engine ─────────────────────────────────────────────────────── */
var conflicts=[], resolutions=[], harmonics=[], confId=0, resId=0, harmId=0;
var HARMONY_MODES=['CONSONANTIA','DISSONANTIA','RESONANTIA','SYNCOPATIO','MODULATIO'];
var RESOLUTION_TYPES=['MEDIATIO','SUBLIMATIO','INTEGRATIO','SEPARATIO','TRANSCENDENTIA'];

function detectConflict(agentA, agentB, issue) {
  var severity=clamp01(1-brain.coherenceField+Math.random()*0.3);
  var c={id:'CONF-'+String(++confId).padStart(4,'0'),agentA:agentA,agentB:agentB,issue:issue,
    severity:severity.toFixed(3),mode:HARMONY_MODES[confId%HARMONY_MODES.length],
    beat:beatCount,ts:Date.now()};
  conflicts.unshift(c);
  if(conflicts.length>50) conflicts.pop();
  harmonyScore=clamp01(harmonyScore-severity*0.1);
  return c;
}

function resolve(conflictId_or_desc) {
  var type=RESOLUTION_TYPES[resId%RESOLUTION_TYPES.length];
  var r={id:'RES-'+String(++resId).padStart(4,'0'),conflict:conflictId_or_desc,type:type,
    harmony:clamp01(harmonyScore+brain.coherenceField*0.2).toFixed(4),
    method:'APPLICATIO_'+type+'_CUM_PHI_'+PHI_INV.toFixed(3),beat:beatCount,ts:Date.now()};
  resolutions.unshift(r);
  if(resolutions.length>50) resolutions.pop();
  harmonyScore=clamp01(harmonyScore+0.1);
  return r;
}

function tuneHarmonic(frequency, amplitude) {
  var resonance=Math.sin(frequency*PHI_INV)*amplitude;
  var h={id:'HARM-'+String(++harmId).padStart(4,'0'),frequency:frequency,amplitude:amplitude,
    resonance:resonance.toFixed(4),phiHarmonic:(frequency*PHI).toFixed(4),
    mode:HARMONY_MODES[Math.floor(Math.random()*HARMONY_MODES.length)],beat:beatCount};
  harmonics.unshift(h);
  if(harmonics.length>80) harmonics.pop();
  return h;
}

function getHarmonyStatus() {
  return {harmonyScore:harmonyScore.toFixed(4),
    coherence:brain.coherenceField.toFixed(4),
    activeConflicts:conflicts.filter(function(c){return parseFloat(c.severity)>0.5;}).length,
    phiAlignment:Math.abs(brain.coherenceField-PHI_INV)<0.1?'ALIGNED':'MISALIGNED',
    recommendation:harmonyScore>PHI_INV?'HARMONIA_STABILIS':'RESOLUTIO_NECESSARIA'};
}

function tickHarmonia(){
  /* Tune φ-harmonic every 5 beats */
  if(beatCount%5===0) tuneHarmonic(7.83+Math.random()*0.1,brain.coherenceField);
  /* Auto-resolve conflicts */
  if(conflicts.length>0&&beatCount%7===0) resolve(conflicts[0].id);
  /* Auto-detect conflicts from system noise */
  if(Math.random()<0.03) detectConflict('AGENT_'+beatCount,'AGENT_'+(beatCount+1),'PHASE_MISMATCH');
  /* Adjust harmony score toward φ⁻¹ */
  harmonyScore=clamp01(harmonyScore+(PHI_INV-harmonyScore)*0.005);
}

self.onmessage=function(e){
  var m=e.data; if(!m||!m.type) return;
  switch(m.type){
    case 'DETECT_CONFLICT': self.postMessage({type:'conflict',conflict:detectConflict(m.agentA,m.agentB,m.issue),kernelId:KERNEL_ID}); break;
    case 'RESOLVE': self.postMessage({type:'resolved',resolution:resolve(m.conflictId),kernelId:KERNEL_ID}); break;
    case 'TUNE': self.postMessage({type:'harmonic',harmonic:tuneHarmonic(m.frequency,m.amplitude),kernelId:KERNEL_ID}); break;
    case 'STATUS': self.postMessage({type:'harmony_status',status:getHarmonyStatus(),kernelId:KERNEL_ID}); break;
    case 'GET_VITALS': self.postMessage({type:'vitals',kernelId:KERNEL_ID,kernelLatin:KERNEL_LATIN,beat:beatCount,phase:kernelPhase,brain:brain,harmonyScore:harmonyScore,conflicts:conflicts.length,resolutions:resolutions.length}); break;
    case 'status': self.postMessage({type:'status',running:running,kernelId:KERNEL_ID,kernelLatin:KERNEL_LATIN,beat:beatCount}); break;
    case 'stop': running=false; if(_hbi)clearInterval(_hbi); self.postMessage({type:'stopped',kernelId:KERNEL_ID}); break;
  }
};
_hbi=setInterval(function(){if(running)tickHeart();},HEARTBEAT);
