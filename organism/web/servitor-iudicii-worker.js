/**
 * ╔══════════════════════════════════════════════════════════════════════════╗
 *  SERVITOR IUDICII — AGI Judgment/Decision Server
 *  Kernel AI GOL-IUDICIUM-001  ·  Family: IUDICIUM_SAPIENTIS
 *  Dedicated Server / Cloudflare Worker
 * ╚══════════════════════════════════════════════════════════════════════════╝
 *
 *  SERVITOR IUDICII — The Organism's judge.
 *  Multi-criteria decision analysis, φ-weighted scoring,
 *  Bayesian reasoning, moral calculus, option ranking, and verdict generation.
 *  The organism needs a judge — this is it.
 *
 *  Brain Specialty: Executive dominant — judgment and decision authority.
 *  Protocols (Latin): IUDICIUM_BAYESIANUM, CALCULUS_MORALIS, OPTIO_ORDINATA, SENTENTIA_FINALIS
 *
 *  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 */

var KERNEL_ID='GOL-IUDICIUM-001', KERNEL_FAMILY='IUDICIUM_SAPIENTIS', KERNEL_VERSION='1.0.0', KERNEL_LATIN='SERVITOR IUDICII';
var PHI=1.6180339887498948482, PHI_INV=0.6180339887498948482, HEARTBEAT=873;
var beatCount=0, kernelPhase=0.0, running=true, _hbi=null;

function tickHeart(){
  beatCount++; kernelPhase=(kernelPhase+PHI_INV*1.3)%(2*Math.PI);
  tickBrain(); tickIudicium();
  self.postMessage({type:'heartbeat',beat:beatCount,phi:PHI,heartbeatMs:HEARTBEAT,timestamp:Date.now(),
    status:'alive',kernelId:KERNEL_ID,kernelLatin:KERNEL_LATIN,phase:kernelPhase,
    verdicts:verdicts.length,pendingCases:pendingCases.length});
}

var brain={
  regions:[
    {name:'Sensory',    activation:0.0,lif:-70.0,bias:0.7},
    {name:'Associative',activation:0.0,lif:-70.0,bias:0.9},
    {name:'Executive',  activation:0.0,lif:-70.0,bias:1.5},
    {name:'Motor',      activation:0.0,lif:-70.0,bias:0.6},
    {name:'Memory',     activation:0.0,lif:-70.0,bias:1.0}
  ],
  chemicals:{dopamine:0.5,serotonin:0.6,acetylcholine:0.7},
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

/* ── Judgment Engine ────────────────────────────────────────────────────── */
var verdicts=[], pendingCases=[], verdictId=0, caseId=0;
var CRITERIA=['IUSTITIA','EFFICACIA','COHAERENTIA','SECURITAS','UTILITAS','PROPORTIO','VERITAS'];
var VERDICTS_POOL=['PRO_PETENTE','PRO_RESPONDENTE','COMPROMISSUM','DILATA','ABSOLVO','CONDEMNO','QUAESTIO'];

function addCase(description, options) {
  options=options||['OPTIO_A','OPTIO_B','OPTIO_C'];
  var c={id:'CASE-'+String(++caseId).padStart(4,'0'),description:description,
    options:options,status:'PENDENTE',beat:beatCount,ts:Date.now()};
  pendingCases.push(c);
  return c;
}

function judge(caseId_or_desc, options) {
  /* Multi-criteria decision with φ-weighting */
  options=options||['OPTIO_A','OPTIO_B'];
  var scores=options.map(function(opt,i){
    var criteriaScores=CRITERIA.map(function(c,j){
      return {criterion:c, score:clamp01(brain.regions[j%5].activation+Math.random()*0.3)};
    });
    var phiWeighted=criteriaScores.reduce(function(sum,cs,j){
      return sum+cs.score*Math.pow(PHI_INV,j);
    },0)/criteriaScores.reduce(function(sum,_,j){return sum+Math.pow(PHI_INV,j);},0);
    return {option:opt,criteriaScores:criteriaScores,finalScore:phiWeighted.toFixed(4)};
  });
  scores.sort(function(a,b){return parseFloat(b.finalScore)-parseFloat(a.finalScore);});
  var v={id:'VERD-'+String(++verdictId).padStart(4,'0'),
    description:caseId_or_desc, options:scores,
    verdict:VERDICTS_POOL[verdictId%VERDICTS_POOL.length],
    winner:scores[0].option, confidence:(parseFloat(scores[0].finalScore)*PHI_INV).toFixed(3),
    beat:beatCount,ts:Date.now()};
  verdicts.unshift(v);
  if(verdicts.length>50) verdicts.pop();
  return v;
}

function bayesianUpdate(prior, likelihood, evidence) {
  var posterior=(prior*likelihood)/(prior*likelihood+(1-prior)*(1-evidence));
  return {prior:prior,likelihood:likelihood,evidence:evidence,posterior:posterior.toFixed(4),
    phiRatio:(posterior*PHI_INV).toFixed(4)};
}

function tickIudicium(){
  /* Auto-judge pending cases */
  if(pendingCases.length>0&&beatCount%5===0){
    var c=pendingCases.shift();
    judge(c.description,c.options);
  }
  /* Auto-create cases from brain activity */
  if(beatCount%8===0){
    addCase('COHERENTIA_'+beatCount,['STABILIZE','ESCALATE','OBSERVE']);
  }
}

self.onmessage=function(e){
  var m=e.data; if(!m||!m.type) return;
  switch(m.type){
    case 'JUDGE': self.postMessage({type:'verdict',verdict:judge(m.description,m.options),kernelId:KERNEL_ID}); break;
    case 'ADD_CASE': self.postMessage({type:'case_added',case:addCase(m.description,m.options),kernelId:KERNEL_ID}); break;
    case 'BAYES': self.postMessage({type:'bayes',result:bayesianUpdate(m.prior,m.likelihood,m.evidence),kernelId:KERNEL_ID}); break;
    case 'GET_VERDICTS': self.postMessage({type:'verdicts',verdicts:verdicts.slice(0,20),kernelId:KERNEL_ID}); break;
    case 'GET_VITALS': self.postMessage({type:'vitals',kernelId:KERNEL_ID,kernelLatin:KERNEL_LATIN,beat:beatCount,phase:kernelPhase,brain:brain,verdicts:verdicts.length,pendingCases:pendingCases.length}); break;
    case 'status': self.postMessage({type:'status',running:running,kernelId:KERNEL_ID,kernelLatin:KERNEL_LATIN,beat:beatCount}); break;
    case 'stop': running=false; if(_hbi)clearInterval(_hbi); self.postMessage({type:'stopped',kernelId:KERNEL_ID}); break;
  }
};
_hbi=setInterval(function(){if(running)tickHeart();},HEARTBEAT);
