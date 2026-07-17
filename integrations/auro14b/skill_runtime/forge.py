from __future__ import annotations
import argparse, json
from collections import Counter
from pathlib import Path
from core import Library, sha, cj

FIX = [
    ('derive a quantitative benchmark score and validate the formula', {'matdaemon-math-verification'}),
    ('run this Python worker safely in an isolated sandbox and give me a receipt', {'capsula-governed-execution'}),
    ('preserve identity and memory continuity across recurrent cognitive cycles', {'brain-ai-cognitive-continuity'}),
    ('analyze MESIE phase coherence and spectral consolidation', {'mesie-spectral-reasoning'}),
    ('patch this GitHub repository, run tests, and debug the API', {'