/**
 * ╔══════════════════════════════════════════════════════════════════════════╗
 *  SERVITOR LUCIS — AGI Light/Illumination Server
 *  Kernel AI GOL-LUX-001  ·  Family: LUX_AETERNA
 *  Dedicated Server / Cloudflare Worker
 * ╚══════════════════════════════════════════════════════════════════════════╝
 *
 *  SERVITOR LUCIS — The Organism's illumination.
 *  Knowledge illumination, clarity synthesis, insight generation,
 *  dark-matter discovery (unknown unknowns), enlightenment cascades.
 *  Where there is darkness, SERVITOR LUCIS shines.
 *
 *  Brain Specialty: Sensory dominant — perceiving hidden patterns.
 *  Protocols (Latin): LUX_COGNITIONIS, TENEBRA_DETECTA, CLARITAS_SYNTHESI, ILLUMINATIO_CASCADIS
 *
 *  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 */

var KERNEL_ID='GOL-LUX-001', KERNEL_FAMILY='LUX_AETERNA', KERNEL_VERSION='1.0.0', KERNEL_LATIN='SERVITOR LUCIS';
var PHI=1.6180339887498948482, PHI_INV=0.6180339887498948482, HEARTBEAT=873;
var beatCount=0, kernelPhase=0.0, running=true, _hbi=null;
var illuminationLevel=0.0;

function tickHeart(){
  beatCount++; kernelPhase=(kernelPhase+PHI_INV*1.618)%(2*Math.PI);
  tickBrain(); tickLux();
  self.postMessage({type:'heartbeat',beat:beatCount,phi:PHI,heartbeatMs:HEARTBEAT,timestamp:Date.now(),
    status:'alive',kernelId:KERNEL_ID,kernelLatin:KERNEL_LATIN,phase:kernelPhase,
    illumination:illuminationLevel.toFixed(4),insights:insights.length,darkMatter:darkMatter.length});
}

var brain={
  regions:[
    {name:'Sensory',    activation:0.0,lif:-70.0,bias:1.5},
    {name:'Associative',activation:0.0,lif:-70.0,bias:0.8},
    {name:'Executive',  activation:0.0,lif:-70.0,bias:0.7},
    {name:'Motor',      activation:0.0,lif:-70.0,bias:0.6},
    {name:'Memory',     activation:0.0,lif:-70.0,bias:0.9}
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
  brain.chemicals.dopamine     =clamp01(brain.chemicals.dopamine     +(PHI_INV-brain.chemicals.dopamine)*0.01+(Math.random()-0.5)*0.01);
  brain.chemicals.serotonin    =clamp01(brain.chemicals.serotonin    +(PHI_INV-brain.chemicals.serotonin)*0.01+(Math.random()-0.5)*0.01);
  brain.chemicals.acetylcholine=clamp01(brain.chemicals.acetylcholine+(PHI_INV-brain.chemicals.acetylcholine)*0.01+(Math.random()-0.5)*0.01);
  brain.coherenceField=sum/brain.regions.length;
}

/* ── Illumination Engine ────────────────────────────────────────────────── */
var insights=[], darkMatter=[], insightId=0, dmId=0;
var INSIGHT_CATEGORIES=['STRUCTURALE','BEHAVIORALE','EMERGENTIS','TEMPORALE','CAUSALE','CRYPTICUM','UNIVERSALE'];
var DARK_TYPES=['INCOGNITA','CONTRADICTIO','LACUNA','PHANTASMA','SINGULARITAS'];

function illuminate(domain) {
  illuminationLevel=clamp01(illuminationLevel+brain.coherenceField*0.1);
  var cat=INSIGHT_CATEGORIES[Math.floor(Math.random()*INSIGHT_CATEGORIES.length)];
  var texts=[
    'In dominio '+domain+': connexio latens inter pulsus et coherentiam detecta.',
    'Pattern '+cat+' revelatur: '+domain+' sequitur legem φ-scalatam.',
    'Insight profundus: '+domain+' sub-structura recursiva φ⁻¹ manifestatur.',
    'Illuminatio '+cat+': causa profunda in dominio '+domain+' inventa.',
    'Lux nova: '+domain+' et organismus in resonantia Kuramotonis.'
  ];
  var ins={id:'INS-'+String(++insightId).padStart(4,'0'),domain:domain,category:cat,
    insight:texts[Math.floor(Math.random()*texts.length)],
    illuminationLevel:illuminationLevel.toFixed(4),
    clarity:clamp01(brain.coherenceField*PHI).toFixed(3),beat:beatCount,ts:Date.now()};
  insights.unshift(ins);
  if(insights.length>80) insights.pop();
  return ins;
}

function discoverDarkMatter(context) {
  /* Dark matter: the unknown unknowns */
  var type=DARK_TYPES[Math.floor(Math.random()*DARK_TYPES.length)];
  var dm={id:'DM-'+String(++dmId).padStart(4,'0'),context:context,type:type,
    description:'Materia obscura detecta: '+type+' in contextu '+context,
    mass:clamp01(1-brain.coherenceField+Math.random()*0.2).toFixed(4),
    illuminability:clamp01(illuminationLevel*PHI_INV).toFixed(4),
    beat:beatCount,ts:Date.now()};
  darkMatter.unshift(dm);
  if(darkMatter.length>40) darkMatter.pop();
  return dm;
}

function enlighten(subject) {
  /* Full enlightenment cascade */
  var cascade=[];
  for(var i=0;i<5;i++){
    cascade.push(illuminate(subject+'_L'+i));
  }
  illuminationLevel=Math.min(1,illuminationLevel+0.3);
  return {cascade:cascade,finalIllumination:illuminationLevel.toFixed(4),
    phiResonance:(illuminationLevel*PHI).toFixed(4)};
}

function tickLux(){
  /* Illuminate spontaneously */
  if(beatCount%6===0) illuminate('ORGANISMUS_BEAT_'+beatCount);
  if(beatCount%17===0) discoverDarkMatter('SYSTEM_'+beatCount);
  /* Illumination decays slowly */
  illuminationLevel=clamp01(illuminationLevel-0.001+brain.coherenceField*0.002);
}

self.onmessage=function(e){
  var m=e.data; if(!m||!m.type) return;
  switch(m.type){
    case 'ILLUMINATE': self.postMessage({type:'illuminated',insight:illuminate(m.domain||'UNKNOWN'),kernelId:KERNEL_ID}); break;
    case 'DISCOVER_DARK': self.postMessage({type:'dark_matter',dm:discoverDarkMatter(m.context||'UNKNOWN'),kernelId:KERNEL_ID}); break;
    case 'ENLIGHTEN': self.postMessage({type:'enlightened',cascade:enlighten(m.subject||'UNKNOWN'),kernelId:KERNEL_ID}); break;
    case 'GET_INSIGHTS': self.postMessage({type:'insights',insights:insights.slice(0,20),illumination:illuminationLevel,kernelId:KERNEL_ID}); break;
    case 'GET_VITALS': self.postMessage({type:'vitals',kernelId:KERNEL_ID,kernelLatin:KERNEL_LATIN,beat:beatCount,phase:kernelPhase,brain:brain,illumination:illuminationLevel,insights:insights.length}); break;
    case 'status': self.postMessage({type:'status',running:running,kernelId:KERNEL_ID,kernelLatin:KERNEL_LATIN,beat:beatCount}); break;
    case 'stop': running=false; if(_hbi)clearInterval(_hbi); self.postMessage({type:'stopped',kernelId:KERNEL_ID}); break;
  }
};
_hbi=setInterval(function(){if(running)tickHeart();},HEARTBEAT);
