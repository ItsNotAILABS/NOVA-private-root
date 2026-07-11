import crypto from "node:crypto";

const DEFAULT_OPERATOR_TOKEN = "local-operator-token";

export function readOperatorToken() {
  return process.env.NOVA_OPERATOR_TOKEN || DEFAULT_OPERATOR_TOKEN;
}

export function hashToken(token) {
  return crypto.createHash("sha256").update(String(token || "")).digest("hex");
}

export function createAuthGate({ operatorToken = readOperatorToken() } = {}) {
  const expectedHash = hashToken(operatorToken);

  function authorize(req) {
    const provided = req.headers["x-nova-operator-token"] || "";
    const ok = hashToken(provided) === expectedHash;
    return {
      ok,
      operator: ok ? "local-operator" : null,
      reason: ok ? null : "missing_or_invalid_operator_token"
    };
  }

  function publicStatus() {
    return {
      enabled: true,
      mode: operatorToken === DEFAULT_OPERATOR_TOKEN ? "local_default_token" : "environment_token",
      header: "x-nova-operator-token"
    };
  }

  return { authorize, publicStatus };
}
