// ═══════════════════════════════════════════════════════════════════════════════
// SCRIBE DESKTOP APP — Main Process (Electron)
// ═══════════════════════════════════════════════════════════════════════════════
//
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// MEDINA TECH — Dallas, Texas, United States of America
//
// Full production research and IP protection application.
// Alpha Organism №2 — Document organism with CLASSIFIER and SYNTHESIZER.
//
// ═══════════════════════════════════════════════════════════════════════════════

const { app, BrowserWindow, ipcMain } = require('electron');
const path = require('path');

const PHI = 1.6180339887498948482;

let mainWindow;

// ═══════════════════════════════════════════════════════════════════════════════
// Section 1 — Window Creation
// ═══════════════════════════════════════════════════════════════════════════════

function createWindow() {
  // φ-proportioned window dimensions (golden ratio)
  const width = 1440;
  const height = Math.floor(width / PHI); // ≈890px

  mainWindow = new BrowserWindow({
    width,
    height,
    title: 'SCRIBE — Document Intelligence',
    webPreferences: {
      preload: path.join(__dirname, 'preload.js'),
      nodeIntegration: false,
      contextIsolation: true,
    },
    backgroundColor: '#0a0a0a',
    icon: path.join(__dirname, 'assets', 'icon.png'),
  });

  mainWindow.loadFile(path.join(__dirname, 'renderer', 'index.html'));

  mainWindow.on('closed', () => {
    mainWindow = null;
  });
}

// ═══════════════════════════════════════════════════════════════════════════════
// Section 2 — App Lifecycle
// ═══════════════════════════════════════════════════════════════════════════════

app.whenReady().then(() => {
  createWindow();

  app.on('activate', () => {
    if (BrowserWindow.getAllWindows().length === 0) {
      createWindow();
    }
  });
});

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});

// ═══════════════════════════════════════════════════════════════════════════════
// Section 3 — IPC Communication (Main ↔ Renderer)
// ═══════════════════════════════════════════════════════════════════════════════

ipcMain.handle('classify-document', async (event, document) => {
  // Document classification will connect to SCRIBE canister on ICP
  // For now, return φ-weighted category
  const categories = [
    'MATHEMATICS',
    'PHYSICS',
    'BIOLOGY',
    'COMPUTATION',
    'PHILOSOPHY',
    'ECONOMICS',
    'HISTORY',
    'SYNTHESIS',
  ];

  // φ-weighted random selection (temporary until ICP connection)
  const index = Math.floor(Math.random() * categories.length);
  return {
    category: categories[index],
    confidence: 1 / Math.pow(PHI, index),
    timestamp: Date.now(),
  };
});

ipcMain.handle('synthesize-papers', async (event, papers) => {
  // Paper synthesis will connect to SCRIBE canister on ICP
  return {
    synthesis: 'Paper synthesis placeholder — will connect to SCRIBE canister',
    paperCount: papers.length,
    timestamp: Date.now(),
  };
});

console.log('SCRIBE Desktop App — Main Process Started');
console.log(`φ = ${PHI} (19 decimal precision)`);
