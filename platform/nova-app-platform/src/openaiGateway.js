const OPENAI_API_URL = "https://api.openai.com/v1/responses";
const DEFAULT_MODEL = "gpt-5.5";
const MAX_INPUT_CHARS = Number(process.env.NOVA_MAX_AI_INPUT_CHARS || 12000);
const TIMEOUT_MS = Number(process.env.NOVA_OPENAI_TIMEOUT_MS || 30000);
const MODEL_PATTERN = /^[a-zA-Z0-9._:-]{2,80}$/;

export function openaiConfigured() {
  return Boolean(process.env.OPENAI_API_KEY);
}

export function normalizeModel(model) {
  const candidate = String(model || process.env.NOVA_OPENAI_MODEL || DEFAULT_MODEL).trim();
  if (!MODEL_PATTERN.test(candidate)) throw new Error("invalid_model");
  return candidate;
}

export function gatewayStatus() {
  return {
    provider: "openai",
    configured: openaiConfigured(),
    keySource: openaiConfigured() ? "OPENAI_API_KEY" : null,
    model: process.env.NOVA_OPENAI_MODEL || DEFAULT_MODEL,
    timeoutMs: TIMEOUT_MS,
    maxInputChars: MAX_INPUT_CHARS,
    keyExposedToBrowser: false
  };
}

export function sanitizeInput(input) {
  const safeInput = String(input || "").slice(0, MAX_INPUT_CHARS);
  if (!safeInput.trim()) throw new Error("empty_input");
  return safeInput;
}

function extractOutputText(payload) {
  if (payload?.output_text) return payload.output_text;
  const parts = [];
  for (const item of payload?.output || []) {
    for (const content of item.content || []) {
      if ((content.type === "output_text" || content.type === "text") && content.text) parts.push(content.text);
    }
  }
  return parts.join("\n");
}

export async function callOpenAI({ input, model, metadata, instructions } = {}) {
  const requestId = `nova_ai_${Date.now()}_${Math.random().toString(16).slice(2)}`;

  if (!openaiConfigured()) {
    return { ok: false, requestId, error: "OPENAI_API_KEY_not_configured", output: null };
  }

  let safeInput;
  let safeModel;
  try {
    safeInput = sanitizeInput(input);
    safeModel = normalizeModel(model);
  } catch (error) {
    return { ok: false, requestId, error: error.message, output: null };
  }

  const controller = new AbortController();
  const timer = setTimeout(() => controller.abort(), TIMEOUT_MS);

  try {
    const response = await fetch(OPENAI_API_URL, {
      method: "POST",
      signal: controller.signal,
      headers: {
        "content-type": "application/json",
        authorization: `Bearer ${process.env.OPENAI_API_KEY}`,
        "x-stainless-package-version": "nova-app-platform/0.2"
      },
      body: JSON.stringify({
        model: safeModel,
        input: safeInput,
        instructions: instructions || "You are operating inside the NOVA App Platform. Respect operator boundaries, do not claim disabled deploy lanes are live, and never request or reveal API keys.",
        metadata: {
          surface: "nova-app-platform",
          requestId,
          ...(metadata || {})
        }
      })
    });

    const payload = await response.json().catch(() => ({}));
    if (!response.ok) {
      return {
        ok: false,
        requestId,
        error: payload?.error?.message || `openai_http_${response.status}`,
        output: null,
        status: response.status
      };
    }

    return {
      ok: true,
      requestId,
      error: null,
      output: extractOutputText(payload),
      model: safeModel,
      usage: payload.usage || null
    };
  } catch (error) {
    return {
      ok: false,
      requestId,
      error: error.name === "AbortError" ? "openai_timeout" : error.message,
      output: null
    };
  } finally {
    clearTimeout(timer);
  }
}
