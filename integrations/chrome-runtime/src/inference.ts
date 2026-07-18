import type { InferenceRequest, InferenceResult } from './types.js';

export class WebGPUInference {
  private pipeline: any;
  private backend: 'webgpu' | 'wasm' = 'wasm';

  async initialize(modelId: string): Promise<'webgpu' | 'wasm'> {
    const { pipeline, env } = await import('@huggingface/transformers');
    env.allowLocalModels = true;
    const hasWebGPU = 'gpu' in navigator;
    this.backend = hasWebGPU ? 'webgpu' : 'wasm';
    this.pipeline = await pipeline('text-generation', modelId, {
      device: this.backend,
      dtype: hasWebGPU ? 'q4' : 'q8'
    });
    return this.backend;
  }

  async generate(request: InferenceRequest): Promise<InferenceResult> {
    if (!this.pipeline) await this.initialize(request.modelId);
    const started = performance.now();
    const output = await this.pipeline(request.prompt, {
      max_new_tokens: request.maxNewTokens ?? 128,
      temperature: request.temperature ?? 0.2,
      do_sample: (request.temperature ?? 0.2) > 0
    });
    const text = Array.isArray(output) ? String(output[0]?.generated_text ?? '') : String(output);
    return {
      backend: this.backend,
      text,
      latencyMs: performance.now() - started,
      modelId: request.modelId
    };
  }
}
