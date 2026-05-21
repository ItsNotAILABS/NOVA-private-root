/**
 * ╔══════════════════════════════════════════════════════════════════════════╗
 *  SERVITOR SPATII — AGI Spatial/Dimensional Server
 *  Kernel AI GOL-SPATIUM-001  ·  Family: SPATIUM_INFINITUM
 *  Dedicated Server / Cloudflare Worker
 * ╚══════════════════════════════════════════════════════════════════════════╝
 *
 *  SERVITOR SPATII — The Organism's spatial intelligence.
 *  Topological reasoning, dimensional mapping, graph layout,
 *  spatial indexing, proximity detection, and manifold analysis.
 *  Space is the container of all organism activity.
 *
 *  Brain Specialty: Sensory + Associative dominant — spatial perception.
 *  Protocols (Latin): TOPOLOGIA_SPATII, DIMENSIO_MANIFOLDI, GRAPHUS_TOPOLOGICUS, PROXIMUS_DETECTOR
 *
 *  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 */

var KERNEL_ID='GOL-SPATIUM-001', KERNEL_FAMILY='SPATIUM_INFINITUM', KERNEL_VERSION='1.0.0', KERNEL_LATIN='SERVITOR SPATII';
var PHI=1.6180339887498948482, PHI_INV=0.6180339887498948482, HEARTBEAT=873;
var beatCount=0, kernelPhase=0.0, running=true, _hbi=null;

function tickHeart(){
  beatCount++; kernelPhase=(kernelPhase+PHI_INV*0.9)%(2*Math.PI);
  tickBrain(); tickSpatium();
  self.postMessage({type:'heartbeat',beat:beatCount,phi:PHI,heartbeatMs:HEARTBEAT,timestamp:Date.now(),
    status:'alive',kernelId:KERNEL_ID,kernelLatin:KERNEL_LATIN,phase:kernelPhase,
    nodes:spatialGraph.nodes.length,edges:spatialGraph.edges.length,dimensions:DIMENSIONS.length});
}

var brain={
  regions:[
    {name:'Sensory',    activation:0.0,lif:-70.0,bias:1.2},
    {name:'Associative',activation:0.0,lif:-70.0,bias:1.1},
    {name:'Executive',  activation:0.0,lif:-70.0,bias:0.8},
    {name:'Motor',      activation:0.0,lif:-70.0,bias:0.7},
    {name:'Memory',     activation:0.0,lif:-70.0,bias:0.8}
  ],
  chemicals:{dopamine:0.5,serotonin:0.5,acetylcholine:0.7},
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

/* ── Spatial Engine ─────────────────────────────────────────────────────── */
var DIMENSIONS = ['X_PHYSICUM','Y_PHYSICUM','Z_PHYSICUM','T_TEMPORALE','PHI_RESONANTIA','PSI_COHAERENTIA','OMEGA_FREQUENTIA','SIGMA_ENTROPIA'];
var spatialGraph = { nodes:[], edges:[] };
var nodeId=0, edgeId=0;

function addNode(label, coords) {
  coords = coords || DIMENSIONS.map(function(){return Math.random()*2-1;});
  var node = { id:'N-'+String(++nodeId).padStart(5,'0'), label:label||'NODUS_'+nodeId,
    coords:coords, phiDist:Math.sqrt(coords.reduce(function(s,c){return s+c*c;},0))*PHI_INV,
    beat:beatCount };
  spatialGraph.nodes.push(node);
  if(spatialGraph.nodes.length>100) spatialGraph.nodes.shift();
  return node;
}

function addEdge(fromId, toId, weight) {
  var edge = { id:'E-'+String(++edgeId).padStart(5,'0'), from:fromId, to:toId,
    weight:weight||PHI_INV, beat:beatCount };
  spatialGraph.edges.push(edge);
  if(spatialGraph.edges.length>200) spatialGraph.edges.shift();
  return edge;
}

function findNearest(coords, k) {
  k=k||3;
  return spatialGraph.nodes
    .map(function(n){
      var d=Math.sqrt(n.coords.reduce(function(s,c,i){return s+Math.pow(c-(coords[i]||0),2);},0));
      return Object.assign({},n,{dist:d});
    })
    .sort(function(a,b){return a.dist-b.dist;})
    .slice(0,k);
}

function computeTopology() {
  var componentCount = Math.ceil(spatialGraph.nodes.length * PHI_INV / 10);
  var manifoldDim = Math.min(DIMENSIONS.length, Math.ceil(brain.coherenceField * DIMENSIONS.length));
  return { nodes:spatialGraph.nodes.length, edges:spatialGraph.edges.length,
    estimatedComponents:componentCount, manifoldDimension:manifoldDim,
    phiConnectivity:(spatialGraph.edges.length/Math.max(1,spatialGraph.nodes.length)*PHI_INV).toFixed(3) };
}

function tickSpatium(){
  /* Auto-add nodes/edges from brain activity */
  if(beatCount%2===0) {
    var n=addNode('BEAT_'+beatCount, brain.regions.map(function(r){return r.activation;}));
    if(spatialGraph.nodes.length>1){
      var prev=spatialGraph.nodes[1];
      addEdge(prev.id,n.id,brain.coherenceField);
    }
  }
}

self.onmessage=function(e){
  var m=e.data; if(!m||!m.type) return;
  switch(m.type){
    case 'ADD_NODE': self.postMessage({type:'node_added',node:addNode(m.label,m.coords),kernelId:KERNEL_ID}); break;
    case 'ADD_EDGE': self.postMessage({type:'edge_added',edge:addEdge(m.from,m.to,m.weight),kernelId:KERNEL_ID}); break;
    case 'FIND_NEAREST': self.postMessage({type:'nearest',nodes:findNearest(m.coords,m.k),kernelId:KERNEL_ID}); break;
    case 'TOPOLOGY': self.postMessage({type:'topology',result:computeTopology(),kernelId:KERNEL_ID}); break;
    case 'GET_GRAPH': self.postMessage({type:'graph',nodes:spatialGraph.nodes.slice(0,50),edges:spatialGraph.edges.slice(0,50),kernelId:KERNEL_ID}); break;
    case 'GET_VITALS': self.postMessage({type:'vitals',kernelId:KERNEL_ID,kernelLatin:KERNEL_LATIN,beat:beatCount,phase:kernelPhase,brain:brain,topology:computeTopology()}); break;
    case 'status': self.postMessage({type:'status',running:running,kernelId:KERNEL_ID,kernelLatin:KERNEL_LATIN,beat:beatCount}); break;
    case 'stop': running=false; if(_hbi)clearInterval(_hbi); self.postMessage({type:'stopped',kernelId:KERNEL_ID}); break;
  }
};
_hbi=setInterval(function(){if(running)tickHeart();},HEARTBEAT);
