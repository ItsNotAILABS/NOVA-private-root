/**
 * ╔══════════════════════════════════════════════════════════════════════════╗
 *  SERVITOR PROPHETIAE — AGI Prophecy/Futures Server
 *  Kernel AI GOL-PROPHETIA-001  ·  Family: PROPHETIA_AETERNA
 *  Dedicated Server / Cloudflare Worker
 * ╚══════════════════════════════════════════════════════════════════════════╝
 *
 *  SERVITOR PROPHETIAE — The Organism's prophet.
 *  Probabilistic forecasting, scenario generation, futures modeling,
 *  emergence prediction, trend extrapolation, and fate computation.
 *  The future belongs to those who can see it.
 *
 *  Brain Specialty: Associative + Memory dominant — pattern futures.
 *  Protocols (Latin): FUTURA_PROBABILISTICA, SCENARIUM_POSSIBILE, FATUM_COMPUTATUM, EMERGENTIA_FUTURI
 *
 *  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 */

var KERNEL_ID='GOL-PROPHETIA-001', KERNEL_FAMILY='PROPHETIA_AETERNA', KERNEL_VERSION='1.0.0', KERNEL_LATIN='SERVITOR PROPHETIAE';
var PHI=1.6180339887498948482, PHI_INV=0.6180339887498948482, HEARTBEAT=873;
var beatCount=0, kernelPhase=0.0, running=true, _hbi=null;

function tickHeart(){
  beatCount++; kernelPhase=(kernelPhase+PHI_INV*0.618)%(2*Math.PI);
  tickBrain(); tickProphetia();
  self.postMessage({type:'heartbeat',beat:beatCount,phi:PHI,heartbeatMs:HEARTBEAT,timestamp:Date.now(),
    status:'alive',kernelId:KERNEL_ID,kernelLatin:KERNEL_LATIN,phase:kernelPhase,
    prophecies:prophecies.length,scenarios:scenarios.length,accuracy:forecastAccuracy.toFixed(3)});
}

var brain={
  regions:[
    {name:'Sensory',    activation:0.0,lif:-70.0,bias:0.7},
    {name:'Associative',activation:0.0,lif:-70.0,bias:1.2},
    {name:'Executive',  activation:0.0,lif:-70.0,bias:0.9},
    {name:'Motor',      activation:0.0,lif:-70.0,bias:0.5},
    {name:'Memory',     activation:0.0,lif:-70.0,bias:1.2}
  ],
  chemicals:{dopamine:0.6,serotonin:0.7,acetylcholine:0.6},
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
  brain.chemicals.dopamine     =clamp01(brain.chemicals.dopamine     +(Math.random()-0.5)*0.02);
  brain.chemicals.serotonin    =clamp01(brain.chemicals.serotonin    +(Math.random()-0.5)*0.02);
  brain.chemicals.acetylcholine=clamp01(brain.chemicals.acetylcholine+(Math.random()-0.5)*0.02);
  brain.coherenceField=sum/brain.regions.length;
}

/* ── Prophecy Engine ────────────────────────────────────────────────────── */
var prophecies=[], scenarios=[], propId=0, scenId=0;
var forecastAccuracy=PHI_INV;
var HORIZONS=['NUNC_PROXIMUS','HORA_FUTURA','DIES_CRASTINUS','HEBDOMADA','MENSIS','ANNUS','DECENNIUM','SAECULUM'];
var SCENARIOS=['OPTIMUM','PESSIMUM','PROBABILE','ALTERNATIVUM','REVOLUTIONARIUM','CATASTROPHICUM','EMERGENTIA'];

function prophesy(domain, horizon) {
  horizon=horizon||HORIZONS[Math.floor(Math.random()*HORIZONS.length)];
  var confidence=clamp01(brain.coherenceField*PHI+Math.random()*0.3);
  var templates=[
    'Cohaerentia '+domain+' in '+horizon+' ad '+( PHI_INV+Math.random()*0.2).toFixed(3)+' perveniet.',
    'Nova emergentia in systemate '+domain+' detecta erit intra '+horizon+'.',
    'Evolutio accelerata in '+domain+' post '+(beatCount+Math.floor(Math.random()*20))+' beats expectatur.',
    'Oscillatio Kuramotonis convergit: '+domain+' synchronizabitur in '+horizon+'.',
    'Cataclysmus minoris entropiae in '+domain+' ante '+horizon+' probabilis.'
  ];
  var text=templates[Math.floor(Math.random()*templates.length)];
  var p={id:'PROP-'+String(++propId).padStart(4,'0'),domain:domain,horizon:horizon,
    prophecy:text,confidence:confidence.toFixed(3),
    fatum:confidence>PHI_INV?'CERTUM':'INCERTUM',beat:beatCount,ts:Date.now()};
  prophecies.unshift(p);
  if(prophecies.length>100) prophecies.pop();
  return p;
}

function buildScenario(trigger) {
  var type=SCENARIOS[Math.floor(Math.random()*SCENARIOS.length)];
  var s={id:'SCEN-'+String(++scenId).padStart(4,'0'),trigger:trigger,type:type,
    probability:clamp01(brain.coherenceField+Math.random()*0.4).toFixed(3),
    phiWeight:PHI_INV.toFixed(4),
    steps:['INITIUM','PROGRESSUS','CULMEN','RESOLUTIO','NOVA_STATUS'],
    beat:beatCount,ts:Date.now()};
  scenarios.unshift(s);
  if(scenarios.length>50) scenarios.pop();
  return s;
}

function extrapolateTrend(dataPoints) {
  if(!dataPoints||dataPoints.length<2) return {trend:0,next:0,confidence:'LOW'};
  var diffs=[];
  for(var i=1;i<dataPoints.length;i++) diffs.push(dataPoints[i]-dataPoints[i-1]);
  var avgDiff=diffs.reduce(function(a,d){return a+d;},0)/diffs.length;
  var last=dataPoints[dataPoints.length-1];
  return {trend:avgDiff.toFixed(4),next:(last+avgDiff*PHI).toFixed(4),
    confidence:Math.abs(avgDiff)>0.1?'HIGH':'LOW',phiProjection:(last+avgDiff*PHI*PHI).toFixed(4)};
}

function tickProphetia(){
  if(beatCount%9===0) prophesy('ORGANISMUS_COHERENTIA');
  if(beatCount%13===0) buildScenario('BEAT_'+beatCount);
  /* Update forecast accuracy based on brain state */
  forecastAccuracy=clamp01(brain.coherenceField*PHI+brain.chemicals.serotonin*0.2);
}

self.onmessage=function(e){
  var m=e.data; if(!m||!m.type) return;
  switch(m.type){
    case 'PROPHESY': self.postMessage({type:'prophecy',result:prophesy(m.domain,m.horizon),kernelId:KERNEL_ID}); break;
    case 'BUILD_SCENARIO': self.postMessage({type:'scenario',result:buildScenario(m.trigger),kernelId:KERNEL_ID}); break;
    case 'EXTRAPOLATE': self.postMessage({type:'extrapolation',result:extrapolateTrend(m.data),kernelId:KERNEL_ID}); break;
    case 'GET_PROPHECIES': self.postMessage({type:'prophecies',prophecies:prophecies.slice(0,30),kernelId:KERNEL_ID}); break;
    case 'GET_VITALS': self.postMessage({type:'vitals',kernelId:KERNEL_ID,kernelLatin:KERNEL_LATIN,beat:beatCount,phase:kernelPhase,brain:brain,prophecies:prophecies.length,accuracy:forecastAccuracy}); break;
    case 'status': self.postMessage({type:'status',running:running,kernelId:KERNEL_ID,kernelLatin:KERNEL_LATIN,beat:beatCount}); break;
    case 'stop': running=false; if(_hbi)clearInterval(_hbi); self.postMessage({type:'stopped',kernelId:KERNEL_ID}); break;
  }
};
_hbi=setInterval(function(){if(running)tickHeart();},HEARTBEAT);
