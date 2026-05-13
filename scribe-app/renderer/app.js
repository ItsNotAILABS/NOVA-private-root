// ═══════════════════════════════════════════════════════════════════════════════
// SCRIBE RENDERER — Frontend Application Logic
// ═══════════════════════════════════════════════════════════════════════════════

const PHI = 1.6180339887498948482;

// ═══════════════════════════════════════════════════════════════════════════════
// Section 1 — State Management
// ═══════════════════════════════════════════════════════════════════════════════

const state = {
  documents: [],
  papers: [],
  generation: 0,
};

// ═══════════════════════════════════════════════════════════════════════════════
// Section 2 — UI Elements
// ═══════════════════════════════════════════════════════════════════════════════

const elements = {
  documentInput: document.getElementById('documentInput'),
  classifyBtn: document.getElementById('classifyBtn'),
  classificationResult: document.getElementById('classificationResult'),
  papersList: document.getElementById('papersList'),
  synthesizeBtn: document.getElementById('synthesizeBtn'),
  synthesisResult: document.getElementById('synthesisResult'),
  docCount: document.getElementById('docCount'),
  paperCount: document.getElementById('paperCount'),
  generation: document.getElementById('generation'),
};

// ═══════════════════════════════════════════════════════════════════════════════
// Section 3 — Document Classification
// ═══════════════════════════════════════════════════════════════════════════════

elements.classifyBtn.addEventListener('click', async () => {
  const text = elements.documentInput.value.trim();

  if (!text) {
    alert('Please enter a document to classify');
    return;
  }

  elements.classifyBtn.disabled = true;
  elements.classifyBtn.textContent = 'Classifying...';

  try {
    const result = await window.scribeAPI.classifyDocument({
      text,
      timestamp: Date.now(),
    });

    // Add to documents
    state.documents.push({
      id: state.documents.length + 1,
      text,
      category: result.category,
      confidence: result.confidence,
      timestamp: result.timestamp,
    });

    // Add to papers list
    state.papers.push(result);

    // Update UI
    displayClassificationResult(result);
    updatePapersList();
    updateStats();

    // Enable synthesis button
    elements.synthesizeBtn.disabled = false;

    // Clear input
    elements.documentInput.value = '';

  } catch (error) {
    console.error('Classification error:', error);
    alert('Classification failed. See console for details.');
  } finally {
    elements.classifyBtn.disabled = false;
    elements.classifyBtn.textContent = 'Classify Document';
  }
});

function displayClassificationResult(result) {
  elements.classificationResult.classList.remove('hidden');
  elements.classificationResult.innerHTML = `
    <div><strong>Category:</strong> ${result.category}</div>
    <div><strong>Confidence:</strong> ${result.confidence.toFixed(4)}</div>
    <div><strong>Timestamp:</strong> ${new Date(result.timestamp).toLocaleString()}</div>
  `;

  // Highlight active category
  document.querySelectorAll('.category').forEach(cat => {
    cat.classList.remove('active');
    if (cat.dataset.category === result.category) {
      cat.classList.add('active');
    }
  });
}

// ═══════════════════════════════════════════════════════════════════════════════
// Section 4 — Paper Synthesis
// ═══════════════════════════════════════════════════════════════════════════════

elements.synthesizeBtn.addEventListener('click', async () => {
  if (state.papers.length === 0) {
    alert('No papers to synthesize');
    return;
  }

  elements.synthesizeBtn.disabled = true;
  elements.synthesizeBtn.textContent = 'Synthesizing...';

  try {
    const result = await window.scribeAPI.synthesizePapers(state.papers);

    elements.synthesisResult.classList.remove('hidden');
    elements.synthesisResult.innerHTML = `
      <div><strong>Synthesis Complete</strong></div>
      <div>Papers synthesized: ${result.paperCount}</div>
      <div>${result.synthesis}</div>
      <div>Timestamp: ${new Date(result.timestamp).toLocaleString()}</div>
    `;

    // Advance generation (Fibonacci sequence)
    state.generation++;
    updateStats();

  } catch (error) {
    console.error('Synthesis error:', error);
    alert('Synthesis failed. See console for details.');
  } finally {
    elements.synthesizeBtn.disabled = false;
    elements.synthesizeBtn.textContent = 'Synthesize Research';
  }
});

// ═══════════════════════════════════════════════════════════════════════════════
// Section 5 — UI Updates
// ═══════════════════════════════════════════════════════════════════════════════

function updatePapersList() {
  if (state.papers.length === 0) {
    elements.papersList.innerHTML = '<div class="empty-state">No papers added yet. Classification results will appear here.</div>';
    return;
  }

  elements.papersList.innerHTML = state.papers
    .map((paper, i) => `
      <div class="paper-item">
        <div class="paper-category">${paper.category}</div>
        <div class="paper-confidence">Confidence: ${paper.confidence.toFixed(4)}</div>
      </div>
    `)
    .join('');
}

function updateStats() {
  elements.docCount.textContent = state.documents.length;
  elements.paperCount.textContent = state.papers.length;
  elements.generation.textContent = state.generation;

  // φ-weighted color intensity based on capacity
  const docRatio = state.documents.length / 2048;
  const paperRatio = state.papers.length / 256;

  elements.docCount.style.color = docRatio > 1 / PHI ? '#ff4444' : '#ffd700';
  elements.paperCount.style.color = paperRatio > 1 / PHI ? '#ff4444' : '#ffd700';
}

// ═══════════════════════════════════════════════════════════════════════════════
// Section 6 — Initialization
// ═══════════════════════════════════════════════════════════════════════════════

console.log('SCRIBE Renderer — Application Started');
console.log(`φ = ${PHI}`);
console.log(`SCRIBE API Version: ${window.scribeAPI.version}`);

updateStats();
