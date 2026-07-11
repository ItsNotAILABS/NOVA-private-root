import crypto from "node:crypto";

const DEFAULT_OPERATOR_TOKEN = "local-operator-token";
const DEFAULT_SESSION_TTL_MS = 1000 * 60 * 60 * 8;

export function readOperatorToken() {
  return process.env.NOVA_OPERATOR_TOKEN || DEFAULT_OPERATOR_TOKEN;
}

export function hashToken(token) {
  return crypto.createHash("sha256").update(String(token || "")).digest("hex");
}

function timingSafeEqualHex(a, b) {
  const left = Buffer.from(String(a || ""), "hex");
  const right = Buffer.from(String(b || ""), "hex");
  if (left.length !== right.length) return false;
  return crypto.timingSafeEqual(left, right);
}

function readBearer(req) {
  const value = req.headers.authorization || "";
  return value.startsWith("Bearer ") ? value.slice(7).trim() : "";
}

export function createAuthGate({ operatorToken = readOperatorToken(), sessionTtlMs = DEFAULT_SESSION_TTL_MS } = {}) {
  const expectedHash = hashToken(operatorToken);
  const sessions = new Map();

  function tokenValid(token) {
    return timingSafeEqualHex(hashToken(token), expectedHash);
  }

  function createSession({ token, label = "local-operator" } = {}) {
    if (!tokenValid(token)) return { ok: false, error: "missing_or_invalid_operator_token" };
    const sessionId = `nova_sess_${crypto.randomBytes(24).toString("hex")}`;
    const now = Date.now();
    const session = {
      id: sessionId,
      label: String(label || "local-operator").slice(0, 80),
      createdAt: new Date(now).toISOString(),
      expiresAt: new Date(now + sessionTtlMs).toISOString(),
      tokenHash: hashToken(sessionId)
    };
    sessions.set(session.tokenHash, session);
    return {
      ok: true,
      session: {
        id: session.id,
        label: session.label,
        createdAt: session.createdAt,
        expiresAt: session.expiresAt
      }
    };
  }

  function authorize(req) {
    const directToken = req.headers["x-nova-operator-token"] || "";
    if (directToken && tokenValid(directToken)) {
      return { ok: true, operator: "local-operator", mode: "operator_token", reason: null };
    }

    const sessionId = req.headers["x-nova-session"] || readBearer(req);
    const session = sessions.get(hashToken(sessionId));
    if (session && Date.parse(session.expiresAt) > Date.now()) {
      return { ok: true, operator: session.label, mode: "session", reason: null, sessionId: session.id };
    }

    return { ok: false, operator: null, mode: null, reason: "missing_or_invalid_operator_token" };
  }

  function revokeSession(sessionId) {
    return sessions.delete(hashToken(sessionId));
  }

  function publicStatus() {
    return {
      enabled: true,
      mode: operatorToken === DEFAULT_OPERATOR_TOKEN ? "local_default_token" : "environment_token",
      acceptedHeaders: ["x-nova-operator-token", "x-nova-session", "authorization"],
      sessionTtlMs,
      activeSessions: sessions.size
    };
  }

  return { authorize, createSession, revokeSession, publicStatus, tokenValid };
}
