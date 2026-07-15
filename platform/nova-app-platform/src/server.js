import http from "node:http";
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { createNovaPlatform } from "./platform.js";
import { createAuthGate } from "./authGate.js";
import { callOpenAI, gatewayStatus } from "./openaiGateway.js";
import { writeReceipt, listReceipts, receiptChainStatus } from "./receipts.js";
import { surfaceRegistry, launchContract } from "./surfaceLinks.js";
import { createIDERuntime } from "./ide/ideRuntime.js";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const publicRoot = path.resolve(__dirname, "..", "public");
const platform = createNovaPlatform();
const authGate = createAuthGate();
const ideRuntime = await createIDERuntime();
const port = Number(process.env.PORT || process.env.NOVA_PLATFORM_PORT || 8899);
const MAX_BODY_BYTES = Number(process.env.NOVA_MAX_BODY_BYTES || 128 * 1024);
const requestBuckets = new Map();

function requestId() {
  return `nova_req_${Date.now()}_${Math.random().toString(16).slice(2)}`;
}

function originAllowed(origin) {
  if (!origin) return true;
  const allowed = (process.env.NOVA_ALLOWED_ORIGINS || "http://127.0.0.1:8899,http://localhost:8899").split(",").map((v) => v.trim()).filter(Boolean);
  return allowed.includes("*") || allowed.includes(origin);
}

function corsHeaders(req) {
  const origin = req.headers.origin;
  const allowOrigin = originAllowed(origin) ? (origin || "http://127.0.0.1:8899") : "http://127.0.0.1:8899";
  return {
    "access-control-allow-origin": allowOrigin,
    "access-control-allow-methods": "GET,POST,PUT,OPTIONS",
    "access-control-allow-headers": "content-type,x-nova-operator-token,x-nova-session,authorization",
    "access-control-max-age": "600",
    "vary": "origin"
  };
}

function securityHeaders() {
  return {
    "x-content-type-options": "nosniff",
    "referrer-policy": "no-referrer",
    "cache-control": "no-store"
  };
}

function send(req, res, status, body, headers = {}) {
  const text = typeof body === "string" ? body : JSON.stringify({ requestId: req.novaRequestId, ...body }, null, 2);
  res.writeHead(status, {
    "content-type": "application/json; charset=utf-8",
    ...corsHeaders(req),
    ...securityHeaders(),
    ...headers
  });
  res.end(text);
}

function sendStatic(req, res, requestedPath) {
  const resolved = path.resolve(requestedPath);
  if (!resolved.startsWith(publicRoot + path.sep) && resolved !== path.join(publicRoot, "index.html") && resolved !== path.join(publicRoot, "surfaces.html")) {
    return send(req, res, 403, { ok: false, error: "static_path_forbidden" });
  }
  const ext = path.extname(resolved);
  const contentType = ext === ".html" ? "text/html; charset=utf-8" : ext === ".css" ? "text/css; charset=utf-8" : ext === ".js" ? "application/javascript; charset=utf-8" : "text/plain; charset=utf-8";
  fs.readFile(resolved, (err, data) => {
    if (err) return send(req, res, 404, { ok: false, error: "not_found" });
    res.writeHead(200, { "content-type": contentType, ...corsHeaders(req), ...securityHeaders() });
    res.end(data);
  });
}

async function readJson(req) {
  const chunks = [];
  let size = 0;
  for await (const chunk of req) {
    size += chunk.length;
    if (size > MAX_BODY_BYTES) throw new Error("body_too_large");
    chunks.push(chunk);
  }
  const text = Buffer.concat(chunks).toString("utf8");
  if (!text) return {};
  return JSON.parse(text);
}

function rateLimit(req) {
  const key = req.socket.remoteAddress || "local";
  const now = Date.now();
  const windowMs = 60_000;
  const limit = Number(process.env.NOVA_RATE_LIMIT_PER_MINUTE || 120);
  const bucket = requestBuckets.get(key) || { start: now, count: 0 };
  if (now - bucket.start > windowMs) {
    bucket.start = now;
    bucket.count = 0;
  }
  bucket.count += 1;
  requestBuckets.set(key, bucket);
  return bucket.count <= limit;
}

function requireOperator(req, res) {
  const auth = authGate.authorize(req);
  if (!auth.ok) {
    send(req, res, 401, { ok: false, error: auth.reason });
    return null;
  }
  return auth;
}

const server = http.createServer(async (req, res) => {
  req.novaRequestId = requestId();
  try {
    if (!rateLimit(req)) return send(req, res, 429, { ok: false, error: "rate_limited" });
    if (req.method === "OPTIONS") return send(req, res, 204, {});

    const url = new URL(req.url, `http://${req.headers.host || "127.0.0.1"}`);
    if (!originAllowed(req.headers.origin)) return send(req, res, 403, { ok: false, error: "origin_not_allowed" });

    if (req.method === "GET" && url.pathname === "/") return sendStatic(req, res, path.join(publicRoot, "index.html"));
    if (req.method === "GET" && url.pathname === "/surfaces") return sendStatic(req, res, path.join(publicRoot, "surfaces.html"));
    if (req.method === "GET" && url.pathname === "/ide") return sendStatic(req, res, path.join(publicRoot, "ide.html"));
    if (req.method === "GET" && url.pathname.startsWith("/public/")) return sendStatic(req, res, path.join(publicRoot, decodeURIComponent(url.pathname.replace("/public/", ""))));

    if (req.method === "GET" && url.pathname === "/api/health") {
      return send(req, res, 200, { ok: true, platform: platform.status(), auth: authGate.publicStatus(), openai: gatewayStatus(), receipts: await receiptChainStatus(), ide: ideRuntime.status() });
    }

    if (req.method === "GET" && url.pathname === "/api/apps") return send(req, res, 200, { ok: true, apps: platform.listApps() });
    if (req.method === "GET" && url.pathname === "/api/dashboard") return send(req, res, 200, { ok: true, ...platform.dashboard(), surfaces: surfaceRegistry(), ide: ideRuntime.status() });
    if (req.method === "GET" && url.pathname === "/api/surfaces") return send(req, res, 200, { ok: true, ...surfaceRegistry() });

    if (req.method === "GET" && url.pathname.startsWith("/api/launch/")) {
      const id = url.pathname.split("/").pop();
      const contract = launchContract(id);
      return send(req, res, contract ? 200 : 404, contract ? { ok: true, ...contract } : { ok: false, error: "surface_not_found" });
    }

    if (req.method === "POST" && url.pathname === "/api/session") {
      const body = await readJson(req);
      const result = authGate.createSession({ token: body.operatorToken, label: body.label });
      if (result.ok) await writeReceipt("session_created", { label: result.session.label, expiresAt: result.session.expiresAt }, { requestId: req.novaRequestId });
      return send(req, res, result.ok ? 200 : 401, result);
    }

    if (req.method === "GET" && url.pathname === "/api/ide/status") return send(req, res, 200, { ok: true, ...ideRuntime.status() });
    if (req.method === "GET" && url.pathname === "/api/ide/workspaces") return send(req, res, 200, { ok: true, workspaces: ideRuntime.workspaceManager.listWorkspaces() });
    if (req.method === "POST" && url.pathname === "/api/ide/workspaces") {
      const body = await readJson(req);
      const result = await ideRuntime.createWorkspace(body);
      return send(req, res, 200, { ok: true, ...result });
    }
    if (req.method === "GET" && /^\/api\/ide\/workspace\/[^/]+\/files$/.test(url.pathname)) {
      const workspaceId = decodeURIComponent(url.pathname.split("/")[4]);
      return send(req, res, 200, { ok: true, workspaceId, files: ideRuntime.workspaceManager.listFiles(workspaceId) });
    }
    if (req.method === "GET" && /^\/api\/ide\/workspace\/[^/]+\/file$/.test(url.pathname)) {
      const workspaceId = decodeURIComponent(url.pathname.split("/")[4]);
      const file = url.searchParams.get("file");
      return send(req, res, 200, { ok: true, ...ideRuntime.workspaceManager.readFile(workspaceId, file) });
    }
    if (req.method === "PUT" && /^\/api\/ide\/workspace\/[^/]+\/file$/.test(url.pathname)) {
      const workspaceId = decodeURIComponent(url.pathname.split("/")[4]);
      const body = await readJson(req);
      const meta = await ideRuntime.workspaceManager.writeFile(workspaceId, body.file, body.content || "");
      const receipt = await writeReceipt("ide_file_saved", { workspaceId, file: meta.file, hash: meta.hash });
      return send(req, res, 200, { ok: true, meta, receipt });
    }
    if (req.method === "POST" && url.pathname === "/api/apps/generate") {
      const body = await readJson(req);
      const result = await ideRuntime.generateApp(body);
      return send(req, res, 200, { ok: true, ...result });
    }
    if (req.method === "GET" && url.pathname === "/api/apps/templates") return send(req, res, 200, { ok: true, templates: ideRuntime.appFactory.templates() });
    if (req.method === "POST" && url.pathname === "/api/quality/check-workspace") {
      const body = await readJson(req);
      const result = await ideRuntime.qualityCheck(body.workspaceId);
      return send(req, res, 200, { ok: true, ...result });
    }
    if (req.method === "POST" && url.pathname === "/api/apps/package") {
      const body = await readJson(req);
      const result = await ideRuntime.packageWorkspace(body.workspaceId, body.lane || "local-preview", Boolean(body.approved));
      return send(req, res, result.plan.ok ? 200 : 409, { ok: result.plan.ok, ...result });
    }

    if (url.pathname.startsWith("/api/operator") || url.pathname === "/api/ai/respond" || url.pathname === "/api/receipts") {
      var auth = requireOperator(req, res);
      if (!auth) return;
    }

    if (req.method === "GET" && url.pathname === "/api/receipts") {
      const limit = Math.min(Number(url.searchParams.get("limit") || 100), 500);
      return send(req, res, 200, { ok: true, chain: await receiptChainStatus(), receipts: await listReceipts({ limit }) });
    }

    if (req.method === "POST" && url.pathname === "/api/operator/register-app") {
      const body = await readJson(req);
      const app = platform.registerApp(body);
      const receipt = await writeReceipt("app_registered", app, { operator: auth.operator, requestId: req.novaRequestId });
      return send(req, res, 200, { ok: true, app, receipt });
    }

    if (req.method === "POST" && url.pathname === "/api/operator/receipt") {
      const body = await readJson(req);
      const receipt = await writeReceipt(body.type || "operator_event", body.payload || body, { operator: auth.operator, requestId: req.novaRequestId });
      return send(req, res, 200, { ok: true, receipt });
    }

    if (req.method === "POST" && url.pathname === "/api/ai/respond") {
      const body = await readJson(req);
      const result = await callOpenAI({ input: body.input, model: body.model, metadata: { appId: body.appId || "operator", requestId: req.novaRequestId } });
      const receipt = await writeReceipt("ai_request", { ok: result.ok, appId: body.appId || "operator", requestId: result.requestId }, { operator: auth.operator, requestId: req.novaRequestId });
      return send(req, res, result.ok ? 200 : 400, { ...result, receipt });
    }

    return send(req, res, 404, { ok: false, error: "route_not_found" });
  } catch (error) {
    const exposed = ["body_too_large", "invalid_app_id", "app_id_and_name_required", "invalid_receipt_type", "invalid_file_path", "workspace_not_found", "file_not_found", "invalid_deployment_lane", "files_must_be_array"].includes(error.message) ? error.message : "internal_error";
    return send(req, res, exposed === "internal_error" ? 500 : 400, { ok: false, error: exposed });
  }
});

server.listen(port, "127.0.0.1", () => {
  console.log(`NOVA App Platform listening at http://127.0.0.1:${port}`);
});

export { server };
