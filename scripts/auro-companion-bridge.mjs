#!/usr/bin/env node
import { exec } from "node:child_process";
import { createServer } from "node:http";
import { URL } from "node:url";

const PORT = Number(process.env.AURO_BRIDGE_PORT ?? 8787);
const HOST = process.env.AURO_BRIDGE_HOST ?? "127.0.0.1";
const ALLOW_EXEC = process.env.AURO_ALLOW_EXEC === "1";
const API_TOKEN = process.env.AURO_BRIDGE_TOKEN ?? "";

function respondJson(res, status, payload) {
  res.statusCode = status;
  res.setHeader("Content-Type", "application/json");
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader("Access-Control-Allow-Headers", "content-type,x-auro-token");
  res.end(JSON.stringify(payload));
}

function isTokenValid(req) {
  if (!API_TOKEN) return true;
  const token = req.headers["x-auro-token"];
  return typeof token === "string" && token === API_TOKEN;
}

function classifyCommand(input) {
  const lower = input.trim().toLowerCase();
  if (lower.startsWith("open ")) return { kind: "open", value: input.slice(5).trim() };
  if (lower.startsWith("run ")) return { kind: "run", value: input.slice(4).trim() };
  if (lower === "pwd") return { kind: "run", value: "pwd" };
  if (lower === "date") return { kind: "run", value: "date" };
  if (lower === "status") return { kind: "run", value: "git status --short" };
  if (lower.startsWith("say ")) return { kind: "say", value: input.slice(4).trim() };
  return { kind: "unknown", value: input };
}

function shellCommandFor(kind, value) {
  if (kind === "open") {
    const escaped = value.replace(/"/g, '\\"');
    return `xdg-open "${escaped}"`;
  }
  if (kind === "say") {
    const escaped = value.replace(/"/g, '\\"');
    return `printf "%s" "${escaped}"`;
  }
  if (kind === "run") return value;
  return "";
}

const server = createServer((req, res) => {
  if (req.method === "OPTIONS") {
    res.statusCode = 204;
    res.setHeader("Access-Control-Allow-Origin", "*");
    res.setHeader("Access-Control-Allow-Headers", "content-type,x-auro-token");
    res.end();
    return;
  }

  const url = new URL(req.url ?? "/", `http://${HOST}:${PORT}`);

  if (url.pathname === "/health" && req.method === "GET") {
    respondJson(res, 200, {
      ok: true,
      service: "auro-companion-bridge",
      allowExec: ALLOW_EXEC,
      host: HOST,
      port: PORT,
    });
    return;
  }

  if (url.pathname === "/chat" && req.method === "POST") {
    let body = "";
    req.on("data", (chunk) => {
      body += chunk;
      if (body.length > 64_000) {
        respondJson(res, 413, { ok: false, error: "Payload too large" });
        req.destroy();
      }
    });
    req.on("end", () => {
      try {
        const parsed = JSON.parse(body || "{}");
        const message = String(parsed.message ?? "").trim();
        if (!message) {
          respondJson(res, 400, { ok: false, error: "message is required" });
          return;
        }
        const lower = message.toLowerCase();
        let reply = "AURO local bridge online. Use /help in the Companion UI for controls.";
        if (lower.includes("status")) {
          reply = "Bridge status: online. Command execution depends on AURO_ALLOW_EXEC=1 and /shell on.";
        } else if (lower.includes("heart") || lower.includes("ccve")) {
          reply = "CCVE is wired in backend runtime and surfaced to frontend queries.";
        } else if (lower.includes("computer") || lower.includes("run")) {
          reply = "Enable shell in UI with /shell on, then use /run <command>.";
        }
        respondJson(res, 200, { ok: true, reply });
      } catch (err) {
        respondJson(res, 400, { ok: false, error: `Invalid JSON: ${String(err)}` });
      }
    });
    return;
  }

  if (url.pathname !== "/command" || req.method !== "POST") {
    respondJson(res, 404, { ok: false, error: "Not found" });
    return;
  }

  if (!isTokenValid(req)) {
    respondJson(res, 401, { ok: false, error: "Unauthorized" });
    return;
  }

  let body = "";
  req.on("data", (chunk) => {
    body += chunk;
    if (body.length > 64_000) {
      respondJson(res, 413, { ok: false, error: "Payload too large" });
      req.destroy();
    }
  });

  req.on("end", () => {
    try {
      const parsed = JSON.parse(body || "{}");
      const command = String(parsed.command ?? "").trim();
      if (!command) {
        respondJson(res, 400, { ok: false, error: "command is required" });
        return;
      }

      const intent = classifyCommand(command);
      const resolved = shellCommandFor(intent.kind, intent.value);

      if (!ALLOW_EXEC) {
        respondJson(res, 200, {
          ok: true,
          dryRun: true,
          allowExec: false,
          intent,
          resolvedCommand: resolved,
          message:
            "Bridge is in dry-run mode. Start with AURO_ALLOW_EXEC=1 to execute commands.",
        });
        return;
      }

      if (!resolved) {
        respondJson(res, 400, {
          ok: false,
          error: "Unsupported command",
          intent,
        });
        return;
      }

      exec(resolved, { cwd: process.cwd(), timeout: 30_000 }, (error, stdout, stderr) => {
        respondJson(res, 200, {
          ok: !error,
          allowExec: true,
          intent,
          resolvedCommand: resolved,
          code: error ? (error.code ?? 1) : 0,
          stdout: stdout ?? "",
          stderr: stderr ?? "",
          error: error ? String(error.message ?? error) : null,
        });
      });
    } catch (err) {
      respondJson(res, 400, { ok: false, error: `Invalid JSON: ${String(err)}` });
    }
  });
});

server.listen(PORT, HOST, () => {
  // eslint-disable-next-line no-console
  console.log(
    `[AURO Companion Bridge] listening on http://${HOST}:${PORT} (ALLOW_EXEC=${ALLOW_EXEC ? "1" : "0"})`
  );
});
