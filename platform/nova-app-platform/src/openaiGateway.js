const OPENAI_API_URL = "https://api.openai.com/v1/responses";

export function openaiConfigured() {
  return Boolean(process.env.OPENAI_API_KEY);
}

export function gatewayStatus() {
  return {
    provider: "openai",
    configured: openaiConfigured(),
    keySource: openaiConfigured() ? "OPENAI_API_KEY" : null,
    model: process.env.NOVA_OPENAI_MODEL || "gpt-5.5"
  };
}

export async function callOpenAI({ input, model, metadata } = {}) {
  if (!openaiConfigured()) {
    return {
      ok: false,
      error: "OPENAI_API_KEY_not_configured",
      output: null
    };
  }

  const safeInput = String(input || "").slice(0, 12000);
  if (!safeInput.trim()) {
    return { ok: false, error: "empty_input", output: null };
  }

  const response = await fetch(OPENAI_API_URL, {
    method: "POST",
    headers: {
      "content-type": "application/json",
      authorization: `Bearer ${process.env.OPENAI_API_KEY}`
    },
    body: JSON.stringify({
      model: model || process.env.NOVA_OPENAI_MODEL || "gpt-5.5",
      input: safeInput,
      metadata: metadata || { surface: "nova-app-platform" }
    })
  });

  const payload = await response.json().catch(() => ({}));
  if (!response.ok) {
    return {
      ok: false,
      error: payload?.error?.message || `openai_http_${response.status}`,
      output: null
    };
  }

  return {
    ok: true,
    error: null,
    output: payload.output_text || extractOutputText(payload),
    raw: payload
  };
}

function extractOutputText(payload) {
  const output = payload?.output || [];
  const parts = [];
  for (const item of output) {
    for (const content of item.content || []) {
      if (content.type === "output_text" && content.text) parts.push(content.text);
    }
  }
  return parts.join("\n");
}
