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

    @property
    def batch_size(self) -> int:
        return self._batch_size

    @property
    def device(self) -> torch.device:
        return self._device

    @property
    def rank(self) -> int:
        return 0

    @property
    def world_size(self) -> int:
        return 1

    @property
    def eot_token_id(self) -> int:
        return self.tokenizer.eos_id

    @property
    def max_length(self) -> int:
        return int(self.model.config.max_seq_len)

    @property
    def max_gen_toks(self) -> int:
        return min(128, self.max_length // 2)

    @property
    def tokenizer_name(self) -> str:
        return self.tokenizer.tokenizer_id

    def tok_encode(self, string: str, **_: Any) -> list[int]:
        return self.tokenizer.encode(string)

    def tok_decode(self, tokens: list[int], **_: Any) -> str:
        return self.tokenizer.decode(tokens)

    @torch.no_grad()
    def _score(self, context: str, continuation: str) -> tuple[float, bool]:
        context_ids = self.tokenizer.encode(context, add_bos=True)
        continuation_ids = self.tokenizer.encode(continuation)
        if not continuation_ids:
            return 0.0, True
        continuation_ids = continuation_ids[-(self.max_length - 1):]
        room = self.max_length + 1 - len(continuation_ids)
        context_ids = context_ids[-max(1, room):]
        combined = context_ids + continuation_ids
        input_ids = torch.tensor([combined[:-1]], dtype=torch.long, device=self._device)
        logits = self.model(input_ids).logits[0]
        start = len(context_ids) - 1
        logits = logits[start:start + len(continuation_ids)]
        targets = torch.tensor(continuation_ids, dtype=torch.long, device=self._device)
        log_probs = F.log_softmax(logits.float(), dim=-1)
        selected = log_probs.gather(-1, targets[:, None]).squeeze(-1)
        greedy = bool(torch.equal(logits.argmax(dim=-1), targets))
        return float(selected.sum().cpu()), greedy

    def loglikelihood(self, requests, disable_tqdm: bool = False):
        del disable_tqdm
        return [self._score(*request.args) for request in requests]

    def loglikelihood_rolling(self, requests, disable_tqdm: bool = False):
        del disable_tqdm
        return [self._score("", request.args[0])[0] for request in requests]

    @torch.no_grad()
    def generate_until(self, requests, disable_tqdm: bool = False):
        del disable_tqdm
        results: list[str] = []
        for request in requests:
            prompt, options = request.args
            options = dict(options or {})
            until = options.get("until", [])
            if isinstance(until, str):
                until = [until]
            max_tokens = int(options.get("max_gen_toks", self.max_gen_toks))
            token_ids = self.tokenizer.encode(prompt, add_bos=True)
            input_ids = torch.tensor([token_ids], dtype=torch.long, device=self._device)
            output = self.model.generate(
                input_ids,
                max_new_tokens=min(max_tokens, self.max_gen_toks),
                temperature=0.0,
                top_k=None,
                top_p=None,
                eos_token_id=self.tokenizer.eos_id,
            )
            text = self.tokenizer.decode(output[0, len(token_ids):].tolist())
            for stop in until:
                if stop and stop in text:
                    text = text.split(stop, 1)[0]
            results.append(text)
        return results
