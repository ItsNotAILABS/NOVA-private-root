/**
 * ╔══════════════════════════════════════════════════════════════════════════╗
 *  SERVITOR NEXUS — AGI Connection/Network Weaver Server
 *  Kernel AI GOL-NEXUS-001  ·  Family: NEXUS_OMNIUM
 *  Dedicated Server / Cloudflare Worker
 * ╚══════════════════════════════════════════════════════════════════════════╝
 *
 *  SERVITOR NEXUS — The Organism's grand connector.
 *  Cross-system wiring, ontological linking, meaning weaving,
 *  agent-to-agent bridging, knowledge graph construction,
 *  and the unified field of all organism connections.
 *  All things in the organism are connected through this server.
 *
 *  Brain Specialty: Associative dominant — making connections.
 *  Protocols (Latin): NEXUS_OMNIUM, FILO_ONTOLOGICO, GRAPHUS_COGNITIO, UNIVERSALIS_CONNECTIO
 *
 *  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 */

var KERNEL_ID='GOL-NEXUS-001', KERNEL_FAMILY='NEXUS_OMNIUM', KERNEL_VERSION='1.0.0', KERNEL_LATIN='SERVITOR NEXUS';
var PHI=1.6180339887498948482, PHI_INV=0.6180339887498948482, HEARTBEAT=873;
var beatCount=0, kernelPhase=0.0, running=true, _hbi=null;

function tickHeart(){
  beatCount++; kernelPhase=(kernelPhase+PHI_INV*1.5)%(2*Math.PI);
  tickBrain(); tickNexus();
  self.postMessage({type:'heartbeat',beat:beatCount,phi:PHI,heartbeatMs:HEARTBEAT,timestamp:Date.now(),
    status:'alive',kernelId:KERNEL_ID,kernelLatin:KERNEL_LATIN,phase:kernelPhase,
    kgNodes:knowledgeGraph.nodes.length,kgEdges:knowledgeGraph.edges.length,
    activeLinks:activeLinks.length,fieldStrength:unifiedField.toFixed(4)});
}

var brain={
  regions:[
    {name:'Sensory',    activation:0.0,lif:-70.0,bias:0.7},
    {name:'Associative',activation:0.0,lif:-70.0,bias:1.5},
    {name:'Executive',  activation:0.0,lif:-70.0,bias:0.8},
    {name:'Motor',      activation:0.0,lif:-70.0,bias:0.7},
    {name:'Memory',     activation:0.0,lif:-70.0,bias:1.0}
  ],
  chemicals:{dopamine:0.5,serotonin:0.5,acetylcholine:0.8},
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
  brain.chemicals.acetylcholine=clamp01(brain.chemicals.acetylcholine+(Math.random()-0.45)*0.02);
  brain.coherenceField=sum/brain.regions.length;
}

/* ── Nexus Engine ───────────────────────────────────────────────────────── */
var knowledgeGraph={nodes:[],edges:[]};
var activeLinks=[], linkId=0, kgNodeId=0, kgEdgeId=0;
var unifiedField=0.0;
var ALL_SERVERS=['GOL-MEMORIA-001','GOL-COMPUTATIO-001','GOL-CUSTODIA-001','GOL-COMMERCIUM-001',
  'GOL-COMMUNICATIO-001','GOL-GUBERNATIO-001','GOL-EVOLUTIO-001','GOL-ORACULUM-001',
  'GOL-TEMPUS-001','GOL-SPATIUM-001','GOL-IUDICIUM-001','GOL-PROPHETIA-001',
  'GOL-LUX-001','GOL-HARMONIA-001','GOL-POTENTIA-001','GOL-NEXUS-001'];

function addKGNode(label, type, properties) {
  var n={id:'KG-N-'+String(++kgNodeId).padStart(5,'0'),label:label,type:type||'CONCEPT',
    properties:properties||{},centrality:0,beat:beatCount};
  knowledgeGraph.nodes.push(n);
  if(knowledgeGraph.nodes.length>300) knowledgeGraph.nodes.shift();
  return n;
}

function addKGEdge(fromId, toId, relation, weight) {
  var e={id:'KG-E-'+String(++kgEdgeId).padStart(5,'0'),from:fromId,to:toId,
    relation:relation||'CONNECTIO',weight:weight||brain.coherenceField,
    phiWeight:(weight||brain.coherenceField)*PHI_INV,beat:beatCount};
  knowledgeGraph.edges.push(e);
  if(knowledgeGraph.edges.length>500) knowledgeGraph.edges.shift();
  updateUnifiedField();
  return e;
}

function createLink(agentA, agentB, context) {
  var link={id:'LNK-'+String(++linkId).padStart(5,'0'),agentA:agentA,agentB:agentB,
    context:context||'UNKNOWN',strength:brain.coherenceField,
    bidirectional:true,beat:beatCount,ts:Date.now()};
  activeLinks.unshift(link);
  if(activeLinks.length>100) activeLinks.pop();
  return link;
}

function updateUnifiedField() {
  var n=knowledgeGraph.nodes.length, e=knowledgeGraph.edges.length;
  unifiedField=clamp01((n>0?e/n:0)*PHI_INV*brain.coherenceField);
}

function getConnectedComponents() {
  /* Simple connectivity estimate */
  var n=knowledgeGraph.nodes.length;
  var density=n>0?knowledgeGraph.edges.length/(n*(n-1)/2||1):0;
  return {nodes:n,edges:knowledgeGraph.edges.length,density:density.toFixed(4),
    phiConnected:density>PHI_INV,unifiedField:unifiedField.toFixed(4)};
}

function tickNexus(){
  /* Auto-wire all servers together */
  if(beatCount%4===0){
    var a=ALL_SERVERS[beatCount%ALL_SERVERS.length];
    var b=ALL_SERVERS[(beatCount+1)%ALL_SERVERS.length];
    createLink(a,b,'PULSUS_'+beatCount);
  }
  /* Build knowledge graph from brain state */
  if(beatCount%3===0){
    var n=addKGNode('BEAT_'+beatCount,'TEMPORAL',{coherence:brain.coherenceField});
    if(knowledgeGraph.nodes.length>1) {
      var prev=knowledgeGraph.nodes[knowledgeGraph.nodes.length-2];
      addKGEdge(prev.id,n.id,'SUCCESSIO',brain.coherenceField);
    }
  }
  updateUnifiedField();
}

self.onmessage=function(e){
  var m=e.data; if(!m||!m.type) return;
  switch(m.type){
    case 'ADD_NODE': self.postMessage({type:'kg_node',node:addKGNode(m.label,m.nodeType,m.properties),kernelId:KERNEL_ID}); break;
    case 'ADD_EDGE': self.postMessage({type:'kg_edge',edge:addKGEdge(m.from,m.to,m.relation,m.weight),kernelId:KERNEL_ID}); break;
    case 'CREATE_LINK': self.postMessage({type:'link',link:createLink(m.agentA,m.agentB,m.context),kernelId:KERNEL_ID}); break;
    case 'GET_GRAPH': self.postMessage({type:'graph',nodes:knowledgeGraph.nodes.slice(0,50),edges:knowledgeGraph.edges.slice(0,50),kernelId:KERNEL_ID}); break;
    case 'GET_COMPONENTS': self.postMessage({type:'components',result:getConnectedComponents(),kernelId:KERNEL_ID}); break;
    case 'GET_LINKS': self.postMessage({type:'links',links:activeLinks.slice(0,30),unifiedField:unifiedField,kernelId:KERNEL_ID}); break;
    case 'GET_VITALS': self.postMessage({type:'vitals',kernelId:KERNEL_ID,kernelLatin:KERNEL_LATIN,beat:beatCount,phase:kernelPhase,brain:brain,kgNodes:knowledgeGraph.nodes.length,kgEdges:knowledgeGraph.edges.length,unifiedField:unifiedField}); break;
    case 'status': self.postMessage({type:'status',running:running,kernelId:KERNEL_ID,kernelLatin:KERNEL_LATIN,beat:beatCount}); break;
    case 'stop': running=false; if(_hbi)clearInterval(_hbi); self.postMessage({type:'stopped',kernelId:KERNEL_ID}); break;
  }
};
_hbi=setInterval(function(){if(running)tickHeart();},HEARTBEAT);
