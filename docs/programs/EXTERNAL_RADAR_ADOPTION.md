# External Repo Radar Adoption Map

This document converts external repository signals into internal engineering moves. It is not a dependency wish list. Every item must end in adopt, benchmark, monitor, reject, or replace.

## Decision classes

- **ADOPT** — integrate a compatible capability.
- **BENCHMARK** — test against an internal implementation before deciding.
- **TRACK** — monitor upstream changes that may affect protocol or compatibility.
- **REFERENCE** — use as an architectural or operational comparison point.
- **REJECT** — explicitly avoid a pattern because it violates internal invariants.

## Radar map

| External repo | Signal | Internal systems | Decision | Required move |
|---|---|---|---|---|
| vllm-project/vllm | DeepSeek-V4 hardening, Transformers v5, multi-tier KV offload, unified reasoning/tool parser, async scheduling | AURO, Auro14B, NOVA runtime | BENCHMARK | Build AURO serving benchmark covering throughput, latency, KV pressure, tool-call parsing, and offload economics. |
| huggingface/transformers | v5.9 compatibility, multimodal/audio serving, tool forwarding, tokenizer and kernel changes | AURO, Auro14B, MESIE | TRACK | Add compatibility matrix, tokenizer drift tests, model config snapshots, and pinned upgrade gates. |
| langchain-ai/langchain | SSRF hardening, path sanitization, tracing metadata, model profile drift warnings | SignalLens, NEXUS Relay, ForgeBridge-MCP | REFERENCE | Create common outbound-fetch policy, path confinement library, trace metadata contract, and drift alerting. |
| run-llama/llama_index | multimodal synthesis, ingestion cache preservation, tool context propagation, memory integrations | MedinaMemorySystems, Relay, SignalLens | BENCHMARK | Compare retrieval quality, context propagation, ingestion durability, and memory abstraction boundaries. |
| microsoft/autogen | maintenance mode and migration to Microsoft Agent Framework | NOVA, NEUROSWARMAI, connector control plane | TRACK | Avoid framework lock-in; require internal agent contracts and migration adapters. |
| crewAIInc/crewAI | installable skills and enterprise orchestration packaging | x-mcp-skills, organism-bots-mcp-server, NEXUS | REFERENCE | Package internal capabilities as installable governed skills with evidence and policy manifests. |
| BerriAI/litellm | MCP OAuth, guardrail spans, provider migration, timeout controls, behavior-pinning tests | AURO gateway, NOVA routing, ForgeBridge-MCP | BENCHMARK | Build provider behavior contract tests, timeout policies, OTEL spans, OAuth compatibility, and routing cost telemetry. |
| qdrant/qdrant | compression, named vector mutation, memory pressure controls, internal auth, restore hardening | MedinaMemorySystems | ADOPT | Implement Qdrant adapter with named vectors, pressure gates, snapshot tests, and authenticated internal transport. |
| milvus-io/milvus | external collections, snapshots, ordered query, multi-vector, disk-backed search | MedinaMemorySystems, LOOM | TRACK | Define large-scale memory backend interface and benchmark multi-vector entity retrieval. |
| ray-project/ray | gRPC streaming, autoscaling, gang scheduling, workload placement, checkpointing | AURO distributed execution, cloudcolony | REFERENCE | Use as distributed-execution baseline; document where Cloudflare/local runtimes intentionally differ. |
| modelcontextprotocol/servers | educational reference servers, security history | NOVA IoT MCP, ForgeBridge-MCP, organism-bots-mcp-server | REJECT AS PRODUCTION TEMPLATE | Maintain production MCP profile with auth, confinement, replay protection, receipts, quotas, and policy gates. |
| modelcontextprotocol/typescript-sdk | v2 pre-alpha, Streamable HTTP, auth helpers, package split | PhoneAI, NOVA MCP, ForgeBridge-MCP | TRACK | Keep protocol adapter boundary; add version negotiation and v1/v2 conformance fixtures before locking transport assumptions. |
| ggml-org/llama.cpp | broad local-runtime packaging and model parser expansion | AURO local runtime, PhoneAI edge execution | BENCHMARK | Establish local-runtime matrix across Windows, Android, iOS, Linux, CUDA, Vulkan, and CPU-only paths. |

## Cross-cutting adoption programs

### Model serving compatibility program

Internal owner systems: AURO and Auro14B.

Deliverables:

- serving abstraction independent of one backend
- vLLM, llama.cpp, and provider API adapters
- prompt/tool-call normalization
- tokenizer and chat-template fingerprinting
- KV-cache policy benchmark
- measured cost and latency receipts
- regression corpus for provider behavior

### Memory infrastructure program

Internal owner system: MedinaMemorySystems.

Deliverables:

- local SQLite/file backend
- Qdrant backend
- large-scale backend interface compatible with Milvus-class features
- named and multi-vector records
- memory pressure policy
- snapshot, restore, and corruption tests
- retrieval quality benchmark
- lineage-preserving ingestion

### Production MCP program

Internal owner systems: ForgeBridge-MCP and nova-connector-control-plane.

Deliverables:

- canonical JSON-RPC protocol layer
- stdio and Streamable HTTP transports
- authenticated principal model
- authorization and capability policy
- atomic nonce persistence
- durable signed receipts
- resource and path confinement
- rate and cost quotas
- approval proposal binding
- protocol conformance test suite

### Outbound network security program

Internal owner systems: CyberSecurity-AI, NEXUS Relay, SignalLens.

Deliverables:

- DNS resolution before connection
- private, loopback, link-local, and metadata range rejection
- redirect revalidation
- DNS rebinding defenses
- protocol allowlist
- response byte and time limits
- identity quotas
- signed fetch receipts
- measured infrastructure usage

## Review cadence

- Weekly: new releases and breaking changes.
- Monthly: adoption decisions and benchmark results.
- Before alpha release: protocol, security, model-runtime, and memory-backend compatibility freeze.
- Before production release: rerun all external comparison benchmarks and record exact upstream versions.
