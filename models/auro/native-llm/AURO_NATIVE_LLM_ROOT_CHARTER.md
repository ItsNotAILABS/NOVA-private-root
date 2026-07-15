# Auro Native LLM Root Charter

**Root status:** critical model feeder registered  
**Auro repo:** `ItsNotAILABS/Auro14B`  
**Root repo:** `ItsNotAILABS/NOVA-private-root`  
**Model lanes:** `Auro-14B-Dev`, `Auro-200B-Base`, `Auro-200B-Instruct`, `Auro-200B-NOVA`

## Purpose

Auro is the native model lane for the NOVA system. The current repo foundation is MESIE: a spectral intelligence engine with transformer, embedding, intelligence protocol, training/inference, and cognitive integration language. The root charter treats MESIE as the structured intelligence substrate and adds a text-generation LLM path on top of it.

## Root interpretation

Auro is not represented as a completed 200B checkpoint. It is represented as the feeder that can become the native 200B model family after the required compute, corpus, tokenizer, training, eval, safety, and serving receipts exist.

## Required artifacts before promotion

- tokenizer model and tokenizer receipt
- data mixture shards and data manifest receipt
- training run config and loss receipts
- sharded checkpoint manifest
- benchmark/eval receipts
- safety and privacy receipt
- serving smoke-test receipt
- public model card update

## NOVA / CAIN / ORO routing

```text
NOVA -> registers model configs, receipts, serving contracts, and runtime import plans
CAIN -> reviews false claims, data risks, benchmark claims, and unsafe release boundaries
ORO  -> maps Auro into demo lanes, internal evaluation lanes, and resource planning
```

## Production line

1. validate scaffold configs
2. train/validate tokenizer
3. curate corpus and hash shards
4. run 14B development lane first
5. evaluate and serve 14B lane
6. escalate architecture/resources for 200B lane
7. emit checkpoint/eval/safety receipts before any public model claim
