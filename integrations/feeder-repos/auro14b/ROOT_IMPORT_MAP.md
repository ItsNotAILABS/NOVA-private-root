# Auro14B Root Import Map

**Feeder:** `ItsNotAILABS/Auro14B`  
**Root:** `ItsNotAILABS/NOVA-private-root`  
**Priority:** critical model feed  
**Status:** native LLM scaffold feed

## Root destinations

```text
integrations/feeder-repos/auro14b/
models/auro/native-llm/
protocols/model-feeds/auro14b/
```

## Imported Auro artifacts

```text
native_llm/README.md
native_llm/configs/auro_14b_dev.json
native_llm/configs/auro_200b_target.json
native_llm/configs/tokenizer_200b.json
native_llm/configs/data_mixture_200b.json
native_llm/configs/eval_gates.json
native_llm/configs/serving_contract.json
bridge/feeder-manifest.json
bridge/ROOT_FEED_RECEIPT.md
```

## NOVA route

NOVA registers Auro as a model feed. It may import configs, receipts, model cards, serving contracts, and evaluation plans. It must not claim checkpoints exist until Auro emits checkpoint manifests and eval receipts.

## CAIN route

CAIN reviews model claims, data provenance, benchmark claims, security boundaries, public-release language, and unsafe weight release risks.

## ORO route

ORO maps Auro into user lanes: builder demos, internal model evaluation, public-safe model card preparation, and resource planning for training/inference.

## Hard boundary

Auro14B is now the priority model feeder, but this import map is not a training receipt and not a model-weight release. A 200B model requires actual compute, data, checkpoints, and evaluation proof.
