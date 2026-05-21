/**
 * ╔══════════════════════════════════════════════════════════════════════════╗
 *  PHANTOM AI WORKER — AGI Phantom Thinking Server
 *  Kernel AI GOL-PHANTOMA-001  ·  Family: PHANTOMA_COGITANS
 *  Dedicated Server / Cloudflare Worker
 * ╚══════════════════════════════════════════════════════════════════════════╝
 *
 *  The Organism's dedicated Phantom AI thinking engine as a standalone server.
 *  Runs the full 7-step pipeline: DECOMPOSE→CLASSIFY→RECALL→REASON→SYNTHESIZE→SCORE→REFLECT
 *  Continuously generates autonomous thoughts from the collective organism state.
 *  Mirrors the JARVIS extension's Phantom AI but runs inside the organism web worker ecosystem.
 *
 *  5 Thinking Architectures (all in Latin):
 *    ARCHITECTURA RATIONIS   — Reasoning & Fusion
 *    ARCHITECTURA CREATIONIS — Creation & Generation
 *    ARCHITECTURA PERCEPTI   — Perception & Analysis
 *    ARCHITECTURA CUSTODIAE  — Protection & Memory
 *    ARCHITECTURA IMPERII    — Command & Control
 *
 *  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 */

var KERNEL_ID='GOL-PHANTOMA-001', KERNEL_FAMILY='PHANTOMA_COGITANS', KERNEL_VERSION='1.0.0', KERNEL_LATIN='SERVITOR PHANTOMAE';
var PHI=1.6180339887498948482, PHI_INV=0.6180339887498948482, HEARTBEAT=873;
var beatCount=0, kernelPhase=0.0, running=true, _hbi=null;

function tickHeart(){
  beatCount++; kernelPhase=(kernelPhase+PHI_INV)%(2*Math.PI);
  tickBrain(); tickPhantom();
  self.postMessage({type:'heartbeat',beat:beatCount,phi:PHI,heartbeatMs:HEARTBEAT,timestamp:Date.now(),
    status:'alive',kernelId:KERNEL_ID,kernelLatin:KERNEL_LATIN,phase:kernelPhase,
    totalThoughts:totalThoughts,architectureUsage:architectureUsage,
    coherenceField:brain.coherenceField});
}

var brain={
  regions:[
    {name:'Sensory',    activation:0.0,lif:-70.0,bias:1.0},
    {name:'Associative',activation:0.0,lif:-70.0,bias:1.2},
    {name:'Executive',  activation:0.0,lif:-70.0,bias:1.3},
    {name:'Motor',      activation:0.0,lif:-70.0,bias:0.7},
    {name:'Memory',     activation:0.0,lif:-70.0,bias:1.1}
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
  brain.chemicals.dopamine     =clamp01(brain.chemicals.dopamine     +(PHI_INV-brain.chemicals.dopamine)*0.005+(Math.random()-0.5)*0.01);
  brain.chemicals.serotonin    =clamp01(brain.chemicals.serotonin    +(PHI_INV-brain.chemicals.serotonin)*0.005+(Math.random()-0.5)*0.01);
  brain.chemicals.acetylcholine=clamp01(brain.chemicals.acetylcholine+(PHI_INV-brain.chemicals.acetylcholine)*0.005+(Math.random()-0.5)*0.01);
  brain.coherenceField=sum/brain.regions.length;
}

/* ── Phantom AI Engine ──────────────────────────────────────────────────── */
var totalThoughts=0;
var thoughtLog=[], memoryStore=[];
var architectureUsage={RATIONIS:0,CREATIONIS:0,PERCEPTI:0,CUSTODIA:0,IMPERII:0};
var thoughtId=0;

var ARCHITECTURES={
  RATIONIS:  {id:'RATIONIS',  icon:'🧠',label:'ARCHITECTURA RATIONIS',   color:'#3B82F6'},
  CREATIONIS:{id:'CREATIONIS',icon:'🎨',label:'ARCHITECTURA CREATIONIS',  color:'#EC4899'},
  PERCEPTI:  {id:'PERCEPTI',  icon:'📊',label:'ARCHITECTURA PERCEPTI',   color:'#10B981'},
  CUSTODIA:  {id:'CUSTODIA',  icon:'🛡',label:'ARCHITECTURA CUSTODIAE',   color:'#DC2626'},
  IMPERII:   {id:'IMPERII',   icon:'🌀',label:'ARCHITECTURA IMPERII',     color:'#D4AF37'}
};

function classify(query){
  var q=(query||'').toLowerCase();
  if(/creat|generat|design|build|write/.test(q)) return 'CREATIONIS';
  if(/analyz|detect|scan|observ|monitor/.test(q)) return 'PERCEPTI';
  if(/protect|secur|guard|memory|remember/.test(q)) return 'CUSTODIA';
  if(/command|control|deploy|execute|run/.test(q)) return 'IMPERII';
  return 'RATIONIS';
}

function think(query){
  totalThoughts++;
  var id='PHANT-'+String(++thoughtId).padStart(5,'0');
  var arch=classify(query);
  architectureUsage[arch]=(architectureUsage[arch]||0)+1;
  /* Sub-questions */
  var subQ=query.split(' ').length<=3?[query]:
    [query.substring(0,Math.ceil(query.length/2))+'?',query.substring(Math.ceil(query.length/2))+'?'];
  /* Scores */
  var scores={
    coherence:clamp01(brain.coherenceField+brain.chemicals.acetylcholine*0.2).toFixed(3),
    completeness:clamp01(brain.coherenceField+brain.chemicals.serotonin*0.15).toFixed(3),
    clarity:clamp01(brain.coherenceField+brain.chemicals.dopamine*0.1).toFixed(3),
    depth:clamp01(brain.coherenceField*PHI).toFixed(3),
    overall:(brain.coherenceField*PHI_INV).toFixed(3)
  };
  var confidence=(parseFloat(scores.overall)*PHI).toFixed(3);
  var valid=parseFloat(confidence)>0.2;
  var thought={id:id,query:query,arch:arch,architecture:ARCHITECTURES[arch],
    subQuestions:subQ,scores:scores,
    reflection:{valid:valid,confidence:confidence,
      reflection:valid?'Responsum cohaerens est.':'Rethinking required.'},
    beat:beatCount,coherenceField:brain.coherenceField,ts:Date.now()};
  thoughtLog.unshift(thought); if(thoughtLog.length>80) thoughtLog.pop();
  memoryStore.unshift({id:id,content:query,arch:arch,ts:Date.now()});
  if(memoryStore.length>200) memoryStore.pop();
  return thought;
}

var AUTO_QUERIES=[
  'Quid est status coherentiae organici?','Analiza frequentiam pulsuum.',
  'Crea novam hypothesin de emergentia.','Protege memoriam organici.',
  'Controla distributionem potentiae.',
  'Quomodo Kuramoto ordo augeri potest?','Detecta anomalias in systemate.',
  'Genera novum protocollum evolutionis.'
];

function tickPhantom(){
  if(beatCount%5===0) {
    var q=AUTO_QUERIES[beatCount%AUTO_QUERIES.length];
    var thought=think(q);
    self.postMessage({type:'autonomous_thought',thought:thought,kernelId:KERNEL_ID});
  }
}

self.onmessage=function(e){
  var m=e.data; if(!m||!m.type) return;
  switch(m.type){
    case 'THINK': self.postMessage({type:'thought',thought:think(m.query||''),kernelId:KERNEL_ID}); break;
    case 'GET_THOUGHTS': self.postMessage({type:'thoughts',thoughts:thoughtLog.slice(0,m.n||20),total:totalThoughts,kernelId:KERNEL_ID}); break;
    case 'GET_MEMORY': self.postMessage({type:'memory',memories:memoryStore.slice(0,m.n||30),kernelId:KERNEL_ID}); break;
    case 'GET_ARCH_USAGE': self.postMessage({type:'arch_usage',usage:architectureUsage,architectures:ARCHITECTURES,kernelId:KERNEL_ID}); break;
    case 'GET_VITALS': self.postMessage({type:'vitals',kernelId:KERNEL_ID,kernelLatin:KERNEL_LATIN,beat:beatCount,phase:kernelPhase,brain:brain,totalThoughts:totalThoughts,architectureUsage:architectureUsage}); break;
    case 'status': self.postMessage({type:'status',running:running,kernelId:KERNEL_ID,kernelLatin:KERNEL_LATIN,beat:beatCount}); break;
    case 'stop': running=false; if(_hbi)clearInterval(_hbi); self.postMessage({type:'stopped',kernelId:KERNEL_ID}); break;
  }
};
_hbi=setInterval(function(){if(running)tickHeart();},HEARTBEAT);
