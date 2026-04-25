/**
 * ╔══════════════════════════════════════════════════════════════════════════╗
 *  SERVITOR TEMPORIS — AGI Time/Temporal Server
 *  Kernel AI GOL-TEMPUS-001  ·  Family: TEMPUS_AETERNUM
 *  Dedicated Server / Cloudflare Worker
 * ╚══════════════════════════════════════════════════════════════════════════╝
 *
 *  SERVITOR TEMPORIS — The Organism's timekeeper.
 *  Temporal reasoning, event sequencing, timeline management,
 *  chronological indexing, causal chains, and time-series analysis.
 *  Time is the fourth dimension of the organism.
 *
 *  Brain Specialty: Memory region dominant — temporal encoding.
 *  Protocols (Latin): TEMPUS_CHRONOS, SERIES_CAUSALIS, LINEA_TEMPORIS, SEQUENTIA_EVENTUUM
 *
 *  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 */

var KERNEL_ID      = 'GOL-TEMPUS-001';
var KERNEL_FAMILY  = 'TEMPUS_AETERNUM';
var KERNEL_VERSION = '1.0.0';
var KERNEL_LATIN   = 'SERVITOR TEMPORIS';

var PHI       = 1.6180339887498948482;
var PHI_INV   = 0.6180339887498948482;
var HEARTBEAT = 873;
var birthTime = Date.now();
var beatCount = 0, kernelPhase = 0.0, running = true, _hbi = null;

function tickHeart() {
  beatCount++;
  kernelPhase = (kernelPhase + PHI_INV * 1.1) % (2 * Math.PI);
  tickBrain(); tickTempus();
  self.postMessage({ type:'heartbeat', beat:beatCount, phi:PHI, heartbeatMs:HEARTBEAT,
    timestamp:Date.now(), status:'alive', kernelId:KERNEL_ID, kernelLatin:KERNEL_LATIN,
    phase:kernelPhase, age:Date.now()-birthTime, timelineEvents:timeline.length,
    causalChains:causalChains.length });
}

var brain = {
  regions: [
    { name:'Sensory',     activation:0.0, lif:-70.0, bias:0.7 },
    { name:'Associative', activation:0.0, lif:-70.0, bias:0.8 },
    { name:'Executive',   activation:0.0, lif:-70.0, bias:0.9 },
    { name:'Motor',       activation:0.0, lif:-70.0, bias:0.6 },
    { name:'Memory',      activation:0.0, lif:-70.0, bias:1.4 }
  ],
  chemicals:{dopamine:0.5,serotonin:0.7,acetylcholine:0.9},
  coherenceField:0.0
};

function clamp01(v){return v<0?0:v>1?1:v;}
function tickBrain() {
  var sum=0;
  for(var i=0;i<brain.regions.length;i++){
    var r=brain.regions[i];
    r.lif+=(-70.0-r.lif)*0.05+Math.random()*3.0*r.bias;
    if(r.lif>=-55.0){r.activation=Math.min(1.0,r.activation+0.2);r.lif=-70.0;}
    r.activation*=0.95; sum+=r.activation;
  }
  brain.chemicals.dopamine     =clamp01(brain.chemicals.dopamine     +(Math.random()-0.5)*0.02);
  brain.chemicals.serotonin    =clamp01(brain.chemicals.serotonin    +(Math.random()-0.5)*0.02);
  brain.chemicals.acetylcholine=clamp01(brain.chemicals.acetylcholine+(Math.random()-0.5)*0.02);
  brain.coherenceField=sum/brain.regions.length;
}

/* ── Temporal Engine ────────────────────────────────────────────────────── */
var timeline = [];
var causalChains = [];
var timelineId = 0;
var chainId = 0;

var TEMPORAL_MARKERS = ['ANTE','NUNC','POST','OLIM','FUTURUM','SEMPER'];
var TEMPORAL_SCALES  = ['NANOSECUNDA','MILLISECUNDA','SECUNDA','MINUTA','HORA','DIES','ANNUS','SAECULUM','AETERNUM'];

function recordEvent(eventType, data, timestamp) {
  var ev = { id:'TM-'+String(++timelineId).padStart(6,'0'),
    type:eventType, data:data||{}, ts:timestamp||Date.now(), beat:beatCount,
    marker:TEMPORAL_MARKERS[beatCount%TEMPORAL_MARKERS.length],
    scale:TEMPORAL_SCALES[Math.floor(Math.log10(Date.now()-birthTime+1))%TEMPORAL_SCALES.length]
  };
  timeline.unshift(ev);
  if(timeline.length>200) timeline.pop();
  return ev;
}

function buildCausalChain(rootEvent) {
  var chain = { id:'CC-'+String(++chainId).padStart(4,'0'),
    root:rootEvent, links:[],
    depth:Math.floor(Math.random()*4+1), beat:beatCount };
  for(var i=0;i<chain.depth;i++) {
    chain.links.push({ seq:i+1, cause:rootEvent+'→EFFECT_'+i, ts:Date.now()+i*PHI*100 });
  }
  causalChains.unshift(chain);
  if(causalChains.length>50) causalChains.pop();
  return chain;
}

function analyzeTimeSeries(events) {
  if(!events||events.length===0) return {pattern:'NULLUM',period:0,trend:'STATICUS'};
  var diffs=[];
  for(var i=1;i<events.length;i++) diffs.push(events[i-1].ts-events[i].ts);
  var avgDiff=diffs.reduce(function(a,d){return a+d;},0)/Math.max(1,diffs.length);
  return { pattern:avgDiff<HEARTBEAT?'FREQUENS':'RARUS', period:avgDiff.toFixed(0),
    trend:diffs[0]<diffs[diffs.length-1]?'ACCELERANS':'DECELERANS',
    phiResonance:(avgDiff*PHI_INV).toFixed(2) };
}

function tickTempus() {
  /* Auto-record organism temporal events */
  if(beatCount%3===0) recordEvent('PULSUS_VITAE',{beat:beatCount,coherence:brain.coherenceField});
  if(beatCount%11===0) buildCausalChain('BEAT_'+beatCount);
}

self.onmessage=function(e){
  var m=e.data; if(!m||!m.type) return;
  switch(m.type){
    case 'RECORD': self.postMessage({type:'recorded',event:recordEvent(m.eventType,m.data,m.ts),kernelId:KERNEL_ID}); break;
    case 'BUILD_CHAIN': self.postMessage({type:'chain',chain:buildCausalChain(m.root||'UNKNOWN'),kernelId:KERNEL_ID}); break;
    case 'ANALYZE': self.postMessage({type:'analysis',result:analyzeTimeSeries(timeline.slice(0,m.n||20)),kernelId:KERNEL_ID}); break;
    case 'GET_TIMELINE': self.postMessage({type:'timeline',events:timeline.slice(0,m.n||50),kernelId:KERNEL_ID}); break;
    case 'GET_VITALS': self.postMessage({type:'vitals',kernelId:KERNEL_ID,kernelLatin:KERNEL_LATIN,beat:beatCount,phase:kernelPhase,brain:brain,age:Date.now()-birthTime,timelineEvents:timeline.length}); break;
    case 'status': self.postMessage({type:'status',running:running,kernelId:KERNEL_ID,kernelLatin:KERNEL_LATIN,beat:beatCount}); break;
    case 'stop': running=false; if(_hbi)clearInterval(_hbi); self.postMessage({type:'stopped',kernelId:KERNEL_ID}); break;
  }
};

_hbi=setInterval(function(){if(running)tickHeart();},HEARTBEAT);
