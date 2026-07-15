import assert from "node:assert/strict";
import fs from "node:fs";
import os from "node:os";
import path from "node:path";

const root = fs.mkdtempSync(path.join(os.tmpdir(), "nova-ide-test-"));
process.env.NOVA_PLATFORM_VAULT = root;

const { WorkspaceManager } = await import("../src/ide/workspaceManager.js");
const { FileSystemVault, assertSafeFile } = await import("../src/ide/fileVault.js");
const { createAppFactory } = await import("../src/ide/appFactory.js");
const { createQualityGate } = await import("../src/ide/qualityGate.js");
const { createDeploymentPlanner } = await import("../src/ide/deploymentPlanner.js");
const { createIDERuntime } = await import("../src/ide/ideRuntime.js");

assert.throws(() => assertSafeFile("../secret"), /invalid_file_path/);

const vault = new FileSystemVault(path.join(root, "ide"));
const manager = new WorkspaceManager({ vault });
const workspace = await manager.createWorkspace({ name: "OIS Dashboard" });
assert.ok(workspace.id.includes("ois-dashboard"));
assert.ok(manager.listFiles(workspace.id).some((file) => file.file === "index.html"));

await manager.writeFile(workspace.id, "src/status.js", "export const ok = true;\n");
assert.equal(manager.readFile(workspace.id, "src/status.js").content.includes("ok"), true);

const factory = createAppFactory();
const generated = factory.generate({ prompt: "Build an OIS project dashboard with rooms and punch list" });
assert.equal(generated.quality.ok, true);
assert.ok(generated.files.some((file) => file.path === "manifest.json"));
assert.ok(generated.files.some((file) => file.path.includes("test")));

const extension = factory.generate({ prompt: "Build a Chrome browser extension to summarize current page" });
assert.equal(extension.plan.template.id, "browser-extension");

const gate = createQualityGate();
const bad = gate.checkApp({ files: [{ path: "index.html", content: "sk-secretsecretsecretsecretsecret" }] });
assert.equal(bad.ok, false);
assert.ok(bad.failures.length >= 1);

const planner = createDeploymentPlanner();
const packaged = planner.plan({ app: generated, lane: "local-preview" });
assert.equal(packaged.ok, true);
assert.ok(packaged.manifest.manifestHash);
const blocked = planner.plan({ app: generated, lane: "icp-package" });
assert.equal(blocked.status, "approval_required");

const runtime = await createIDERuntime({ workspaceManager: manager });
const appResult = await runtime.generateApp({ prompt: "Build a static field report app" });
assert.ok(appResult.workspace.id);
const check = await runtime.qualityCheck(appResult.workspace.id);
assert.equal(check.report.ok, true);
const pkg = await runtime.packageWorkspace(appResult.workspace.id, "local-preview");
assert.equal(pkg.plan.ok, true);

console.log("NOVA IDE runtime tests passed");
