import http from "node:http";
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { createNovaPlatform } from "./platform.js";
import { createAuthGate } from "./authGate.js";
import { callOpenAI, gatewayStatus } from "./openaiGateway.js";
import { writeReceipt } from "./receipts.js";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const publicRoot = path.join(__dirname, "..", "public");
const platform = createNovaPlatform();
const authGate = createAuthGate();
const port = Number(process.env.PORT || process.env.NOVA_PLATFORM_PORT || 8899);

function send(res, status, body, headers = {}) {
  const text = typeof body === "string" ? body : JSON.stringify(body, null, 2);
  res.writeHead(status, { "content-type": "application/json; charset=utf-8", ...headers });
  res.end(text);
}

function sendStatic(res, filePath) {
  const ext = path.extname(filePath);
  const contentType = ext === ".html" ? "text/html; charset=utf-8" : ext === ".css" ? "text/css; charset=utf-8" : ext === ".js" ? "application/javascript; charset=utf-8" : "text/plain; charset=utf-8";
  fs.readFile(filePath, (err, data) => {
    if (err) return send(res, 404, { error: "not_found" });
    res.writeHead(200, { "content-type": contentType });
    res.end(data);
  });
}

async function readJson(req) {
  const chunks = [];
  for await (const chunk of req) chunks.push(chunk);
  const text = Buffer.concat(chunks).toString("utf8");
  return text ? JSON.parse(text) : {};
}

const server = http.createServer(async (req, res) => {
  try {
    const url = new URL(req.url, `http://${req.headers.host}`);

    if (req.method === "GET" && url.pathname === "/") return sendStatic(res, path.join(publicRoot, "index.html"));
    if (req.method === "GET" && url.pathname.startsWith("/public/")) return sendStatic(res, path.join(publicRoot, url.pathname.replace("/public/", "")));

    if (req.method === "GET" && url.pathname === "/api/health") {
      return send(res, 200, { ok: true, platform: platform.status(), auth: authGate.publicStatus(), openai: gatewayStatus() });
    }

    if (req.method === "GET" && url.pathname === "/api/apps") return send(res, 200, platform.listApps());
    if (req.method === "GET" && url.pathname === "/api/dashboard") return send(res, 200, platform.dashboard());

    if (url.pathname.startsWith("/api/operator") || url.pathname === "/api/ai/respond") {
      const auth = authGate.authorize(req);
      if (!auth.ok) return send(res, 401, { ok: false, error: auth.reason });
    }

    if (req.method === "POST" && url.pathname === "/api/operator/register-app") {
      const body = await readJson(req);
      const app = platform.registerApp(body);
      const receipt = await writeReceipt("app_registered", app);
      return send(res, 200, { ok: true, app, receipt });
    }

    if (req.method === "POST" && url.pathname === "/api/operator/receipt") {
      const body = await readJson(req);
      const receipt = await writeReceipt(body.type || "operator_event", body.payload || body);
      return send(res, 200, { ok: true, receipt });
    }

    if (req.method === "POST" && url.pathname === "/api/ai/respond") {
      const body = await readJson(req);
      const result = await callOpenAI({ input: body.input, model: body.model, metadata: { surface: "nova-app-platform", appId: body.appId || "operator" } });
      const receipt = await writeReceipt("ai_request", { ok: result.ok, appId: body.appId || "operator" });
      return send(res, result.ok ? 200 : 400, { ...result, receipt });
    }

    return send(res, 404, { ok: false, error: "route_not_found" });
  } catch (error) {
    return send(res, 500, { ok: false, error: error.message });
  }
});

server.listen(port, "127.0.0.1", () => {
  console.log(`NOVA App Platform listening at http://127.0.0.1:${port}`);
});

export { server };
