from __future__ import annotations

from pathlib import Path
from typing import Any

import torch
import torch.nn.functional as F
from lm_eval.api.model import LM
from auro_foundry.generation import load_model


class AuroHarnessLM(LM):
    """EleutherAI lm-eval adapter for an Auro Foundry checkpoint."""

    def __init__(self, checkpoint: str | Path, device: str = "cpu") -> None:
        super().__init__()
        self.model, self.tokenizer, self.metadata, self._device = load_model(checkpoint, device)
        self._batch_size = 1

