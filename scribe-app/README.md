# SCRIBE Desktop App

**Full Production Research & IP Protection Application**

Alpha Organism №2 — Document organism with CLASSIFIER and SYNTHESIZER sub-models.

---

## Overview

SCRIBE is a sovereign document intelligence application built for founders, researchers, and enterprise IP creators. It provides:

- **Document Classification** — 8 golden-section categories (MATHEMATICS, PHYSICS, BIOLOGY, COMPUTATION, PHILOSOPHY, ECONOMICS, HISTORY, SYNTHESIS)
- **Research Paper Synthesis** — Autonomous synthesis of classified documents
- **IP Protection** — Encrypted storage and attribution tracking
- **φ-Weighted Intelligence** — All operations use φ = 1.6180339887498948482

---

## Installation

### Prerequisites

- Node.js 18+ (for npm)
- Electron runtime (installed automatically via npm)

### Install Dependencies

```bash
cd scribe-app
npm install
```

---

## Running the App

### Development Mode

```bash
npm run dev
```

This launches the Electron app in development mode with hot reload.

### Production Build

Build for your platform:

```bash
# macOS
npm run build:mac

# Windows
npm run build:win

# Linux
npm run build:linux

# All platforms
npm run build
```

Built applications will be in `scribe-app/dist/`.

---

## Architecture

### Main Process (`main.js`)
- Electron main process
- Creates φ-proportioned window (1440 × 890px, golden ratio)
- IPC handlers for document classification and synthesis
- Future: Connect to SCRIBE canister on ICP

### Preload Script (`preload.js`)
- Context bridge between main and renderer
- Exposes `window.scribeAPI` to renderer

### Renderer Process (`renderer/`)
- HTML/CSS/JS frontend
- φ-proportioned UI design
- Document input and classification
- Research paper synthesis
- Storage statistics

### Future: ICP Integration
- Connect to `src/scribe/main.mo` canister
- Store documents on-chain
- Autonomous intelligence via CLASSIFIER and SYNTHESIZER

---

## Features

### 1. CLASSIFIER
- Classifies documents into 8 golden-section categories
- φ-weighted confidence scores
- Stores up to 2048 documents

### 2. SYNTHESIZER
- Synthesizes research papers from classified documents
- Stores up to 256 papers
- Fibonacci generation advancement

### 3. Storage
- Displays document count (capacity: 2048)
- Displays paper count (capacity: 256)
- Displays current generation (Fibonacci sequence)

---

## Deployment

### Desktop App
Built apps can be distributed via:
- Direct download (DMG for macOS, EXE for Windows, AppImage for Linux)
- App stores (future)

### Future: Progressive Web App (PWA)
Convert to PWA for browser-based installation:
- Add service worker for offline capability
- Add manifest.json for installability
- Deploy to proper hosting (ICP, Vercel, custom domain)

---

## Technical Details

### φ-Proportions
- Window dimensions: 1440 × 890px (φ ratio)
- Spacing: Uses φ² (13px), φ³ (21px), φ⁴ (34px)
- Line height: φ (1.618)

### Colors
- Background: #0a0a0a (NOVA standard)
- Surface: #1a1a1a
- Accent: #ffd700 (gold)
- Success: #00ff88
- Error: #ff4444

### Constants
- PHI = 1.6180339887498948482 (19 decimal precision)
- DOC_CAP = 2048
- PAPER_CAP = 256

---

## Copyright

**COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.**

MEDINA TECH — Dallas, Texas, United States of America

This application is proprietary software. All sovereign rights reserved.

---

## Next Steps

1. **ICP Integration** — Connect to SCRIBE canister (`src/scribe/main.mo`)
2. **Encryption** — Add document encryption for IP protection
3. **Attribution** — Track document authorship and lineage
4. **Deployment** — Distribute via app stores or web hosting

---

**φ = 1.6180339887498948482**
