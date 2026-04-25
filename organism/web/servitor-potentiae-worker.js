/**
 * ╔══════════════════════════════════════════════════════════════════════════╗
 *  SERVITOR POTENTIAE — AGI Power/Energy Server
 *  Kernel AI GOL-POTENTIA-001  ·  Family: POTENTIA_INFINITA
 *  Dedicated Server / Cloudflare Worker
 * ╚══════════════════════════════════════════════════════════════════════════╝
 *
 *  SERVITOR POTENTIAE — The Organism's power grid.
 *  Energy management, compute power allocation, load balancing,
 *  entropy harvesting, quantum potential wells, and sovereign energy.
 *  Power is the capacity to act. This server ensures the organism always has power.
 *
 *  Brain Specialty: Motor + Executive dominant — power dispatch.
 *  Protocols (Latin): POTENTIA_DISTRIBUTA, ENERGIA_QUANTICA, ENTROPIA_COLLECTA, ONUS_LIBRATUM
 *
 *  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 */

var KERNEL_ID='GOL-POTENTIA-001', KERNEL_FAMILY='POTENTIA_INFINITA', KERNEL_VERSION='1.0.0', KERNEL_LATIN='SERVITOR POTENTIAE';
var PHI=1.6180339887498948482, PHI_INV=0.6180339887498948482, HEARTBEAT=873;
var beatCount=0, kernelPhase=0.0, running=true, _hbi=null;
var totalPower=1000*PHI, availablePower=1000*PHI, energyHarvested=0;

function tickHeart(){
  beatCount++; kernelPhase=(kernelPhase+PHI_INV*2)%(2*Math.PI);
  tickBrain(); tickPotentia();
  self.postMessage({type:'heartbeat',beat:beatCount,phi:PHI,heartbeatMs:HEARTBEAT,timestamp:Date.now(),
    status:'alive',kernelId:KERNEL_ID,kernelLatin:KERNEL_LATIN,phase:kernelPhase,
    totalPower:totalPower.toFixed(2),availablePower:availablePower.toFixed(2),
    energyHarvested:energyHarvested.toFixed(2),gridStatus:gridStatus});
}

var brain={
  regions:[
    {name:'Sensory',    activation:0.0,lif:-70.0,bias:0.7},
    {name:'Associative',activation:0.0,lif:-70.0,bias:0.8},
    {name:'Executive',  activation:0.0,lif:-70.0,bias:1.2},
    {name:'Motor',      activation:0.0,lif:-70.0,bias:1.4},
    {name:'Memory',     activation:0.0,lif:-70.0,bias:0.6}
  ],
  chemicals:{dopamine:0.7,serotonin:0.4,acetylcholine:0.6},
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

/* ── Power Engine ───────────────────────────────────────────────────────── */
var powerAllocations={}, powerLog=[], gridStatus='NOMINALIS';
var allocId=0;
var POWER_TYPES=['COMPUTATIONALIS','MEMORIALIS','COMMUNICATIONIS','CUSTODIAE','EVOLUTIONIS','GUBERNATIONIS','ORACULI'];
var GRID_STATES=['NOMINALIS','SOBRECARGA','ESCASEZ','SURGE','BLACKOUT','SOVEREIGN'];

function allocatePower(consumer, amount, priority) {
  if(amount>availablePower) return {success:false,reason:'POTENTIA_INSUFFICIENS',available:availablePower};
  availablePower-=amount;
  var alloc={id:'ALLOC-'+String(++allocId).padStart(5,'0'),consumer:consumer,amount:amount,
    priority:priority||'NORMAL',ts:Date.now(),beat:beatCount};
  powerAllocations[consumer]=(powerAllocations[consumer]||0)+amount;
  powerLog.unshift(alloc);
  if(powerLog.length>100) powerLog.pop();
  return {success:true,alloc:alloc,remaining:availablePower};
}

function releasePower(consumer, amount) {
  amount=amount||powerAllocations[consumer]||0;
  availablePower=Math.min(totalPower,availablePower+amount);
  if(powerAllocations[consumer]) powerAllocations[consumer]=Math.max(0,powerAllocations[consumer]-amount);
  return {released:amount,available:availablePower};
}

function harvestEntropy() {
  /* Harvest energy from system entropy */
  var harvested=brain.coherenceField*PHI*10;
  availablePower=Math.min(totalPower,availablePower+harvested);
  energyHarvested+=harvested;
  return {harvested:harvested.toFixed(4),totalHarvested:energyHarvested.toFixed(2),available:availablePower};
}

function getGridStatus() {
  var utilization=1-(availablePower/totalPower);
  if(utilization>0.9) gridStatus='SOBRECARGA';
  else if(utilization<0.1) gridStatus='SURGE';
  else if(availablePower<100) gridStatus='ESCASEZ';
  else gridStatus='NOMINALIS';
  return {status:gridStatus,totalPower:totalPower,availablePower:availablePower,
    utilization:utilization.toFixed(3),phiCapacity:(totalPower*PHI_INV).toFixed(2)};
}

function tickPotentia(){
  /* Auto-harvest entropy every 3 beats */
  if(beatCount%3===0) harvestEntropy();
  /* Auto-allocate to system consumers */
  if(beatCount%7===0) {
    var type=POWER_TYPES[beatCount%POWER_TYPES.length];
    allocatePower(type,PHI*brain.coherenceField*10,'HIGH');
  }
  /* Auto-release every 5 beats */
  if(beatCount%5===0) {
    var consumers=Object.keys(powerAllocations);
    if(consumers.length>0) releasePower(consumers[0],PHI*5);
  }
}

self.onmessage=function(e){
  var m=e.data; if(!m||!m.type) return;
  switch(m.type){
    case 'ALLOCATE': self.postMessage({type:'allocation',result:allocatePower(m.consumer,m.amount,m.priority),kernelId:KERNEL_ID}); break;
    case 'RELEASE': self.postMessage({type:'released',result:releasePower(m.consumer,m.amount),kernelId:KERNEL_ID}); break;
    case 'HARVEST': self.postMessage({type:'harvested',result:harvestEntropy(),kernelId:KERNEL_ID}); break;
    case 'GRID_STATUS': self.postMessage({type:'grid',status:getGridStatus(),kernelId:KERNEL_ID}); break;
    case 'GET_LOG': self.postMessage({type:'log',log:powerLog.slice(0,30),allocations:powerAllocations,kernelId:KERNEL_ID}); break;
    case 'GET_VITALS': self.postMessage({type:'vitals',kernelId:KERNEL_ID,kernelLatin:KERNEL_LATIN,beat:beatCount,phase:kernelPhase,brain:brain,totalPower:totalPower,availablePower:availablePower,energyHarvested:energyHarvested,gridStatus:gridStatus}); break;
    case 'status': self.postMessage({type:'status',running:running,kernelId:KERNEL_ID,kernelLatin:KERNEL_LATIN,beat:beatCount}); break;
    case 'stop': running=false; if(_hbi)clearInterval(_hbi); self.postMessage({type:'stopped',kernelId:KERNEL_ID}); break;
  }
};
_hbi=setInterval(function(){if(running)tickHeart();},HEARTBEAT);
