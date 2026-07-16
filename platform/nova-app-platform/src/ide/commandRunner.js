import { spawn } from "node:child_process";
import path from "node:path";
import { appendRecord, sha256 } from "../storage.js";

const DEFAULT_TIMEOUT_MS = Number(process.env.NOVA_IDE_COMMAND_TIMEOUT_MS || 20_000);
const MAX_OUTPUT_BYTES = Number(process.env.NOVA_IDE_MAX_OUTPUT_BYTES || 256 * 1024);

const COMMANDS = {
  "validate-static": {
    label: "Validate static workspace",
    command: process.execPath,
    args: ["--check"],
    fileRequired: "app.js",
    approvalRequired: false
  },
  "node-test": {
    label: "Run Node validation test",
    command: process.execPath,
    args: [],
    fileRequired: "tests/app.test.js",
    approvalRequired: false
  },
  "node-service-test": {
    label: "Run Node service test",
    command: process.execPath,
    args: [],
    fileRequired: "tests/service.test.js",
    approvalRequired: false
  },
  "extension-test": {
    label: "Run browser extension manifest test",
    command: process.execPath,
    args: [],
    fileRequired: "tests/extension.test.js",
    approvalRequired: false
  }
};

function bounded(buffer, chunk) {
  const next = buffer + String(chunk || "");
  if (Buffer.byteLength(next, "utf8") <= MAX_OUTPUT_BYTES) return next;
  return next.slice(0, MAX_OUTPUT_BYTES) + "\n[output_truncated]";
}

export class CommandRunnerBoundary {
  constructor({ workspaceManager, auditLog = null } = {}) {
    if (!workspaceManager) throw new Error("workspace_manager_required");
    this.workspaceManager = workspaceManager;
    this.auditLog = auditLog;
  }

  commands() {
    return Object.entries(COMMANDS).map(([id, spec]) => ({ id, label: spec.label, approvalRequired: spec.approvalRequired, fileRequired: spec.fileRequired }));
  }

  async run(workspaceId, commandId, { approved = false, requestId = null } = {}) {
    const spec = COMMANDS[commandId];
    if (!spec) throw new Error("command_not_allowed");
    if (spec.approvalRequired && !approved) throw new Error("command_approval_required");
    this.workspaceManager.getWorkspace(workspaceId);
    const workspaceDir = this.workspaceManager.vault.workspaceDir(workspaceId);
    const required = spec.fileRequired;
    const targetFile = required && this.workspaceManager.vault.exists(workspaceId, required) ? required : null;
    if (required && !targetFile) throw new Error("command_required_file_missing");

    const args = [...spec.args, ...(targetFile ? [path.join(workspaceDir, targetFile)] : [])];
    const startedAt = new Date().toISOString();
    const started = Date.now();
    const result = await execute(spec.command, args, workspaceDir);
    const endedAt = new Date().toISOString();
    const envelope = {
      schema: "nova-ide-command-run-v0.1",
      workspaceId,
      commandId,
      label: spec.label,
      ok: result.exitCode === 0 && !result.timedOut,
      exitCode: result.exitCode,
      signal: result.signal,
      timedOut: result.timedOut,
      durationMs: Date.now() - started,
      stdout: result.stdout,
      stderr: result.stderr,
      outputHash: sha256({ stdout: result.stdout, stderr: result.stderr }),
      startedAt,
      endedAt
    };
    const record = await appendRecord("ide_command_runs", envelope);
    if (this.auditLog) await this.auditLog.write("command_run", { commandId, ok: envelope.ok, exitCode: envelope.exitCode }, { workspaceId, requestId });
    return { ...envelope, recordId: record.id, recordHash: record.recordHash };
  }
}

function execute(command, args, cwd) {
  return new Promise((resolve) => {
    let stdout = "";
    let stderr = "";
    let settled = false;
    const child = spawn(command, args, { cwd, shell: false, windowsHide: true, env: { ...process.env, NODE_ENV: "test" } });
    const timer = setTimeout(() => {
      if (!settled) child.kill("SIGTERM");
    }, DEFAULT_TIMEOUT_MS);
    child.stdout.on("data", (chunk) => { stdout = bounded(stdout, chunk); });
    child.stderr.on("data", (chunk) => { stderr = bounded(stderr, chunk); });
    child.on("error", (error) => {
      if (settled) return;
      settled = true;
      clearTimeout(timer);
      resolve({ exitCode: 1, signal: null, timedOut: false, stdout, stderr: bounded(stderr, error.message) });
    });
    child.on("close", (exitCode, signal) => {
      if (settled) return;
      settled = true;
      clearTimeout(timer);
      resolve({ exitCode, signal, timedOut: signal === "SIGTERM", stdout, stderr });
    });
  });
}

export function createCommandRunner(options) {
  return new CommandRunnerBoundary(options);
}
