// ═══════════════════════════════════════════════════════════════════════════════
// SCRIBE PRELOAD — Bridge between Main and Renderer
// ═══════════════════════════════════════════════════════════════════════════════

const { contextBridge, ipcRenderer } = require('electron');

contextBridge.exposeInMainWorld('scribeAPI', {
  classifyDocument: (document) => ipcRenderer.invoke('classify-document', document),
  synthesizePapers: (papers) => ipcRenderer.invoke('synthesize-papers', papers),
  version: '1.0.0',
  phi: 1.6180339887498948482,
});

console.log('SCRIBE Preload — Context Bridge Established');
