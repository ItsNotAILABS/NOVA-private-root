import { WorkspaceManager } from "./workspaceManager.js";
import { createAppFactory } from "./appFactory.js";
import { createQualityGate } from "./qualityGate.js";
import { createDeploymentPlanner } from "./deploymentPlanner.js";
import { createAuditLog } from "./auditLog.js";
import { createCommandRunner } from "./commandRunner.js";
import { createCommercialReadinessGate } from "./commercialReadiness.js";
import { writeReceipt } from "../receipts.js";

export class NovaIDERuntime {
  constructor({ workspaceManager = new WorkspaceManager(), qualityGate = createQualityGate(), appFactory = null, deploymentPlanner = createDeploymentPlanner(), auditLog = createAuditLog(), readinessGate = createCommercialReadinessGate() } = {}) {
    this.workspaceManager = workspaceManager;
    this.qualityGate = qualityGate;
    this.appFactory = appFactory || createAppFactory({ qualityGate });
    this.deploymentPlanner = deploymentPlanner;
    this.auditLog = auditLog;
    this.commandRunner = createCommandRunner({ workspaceManager, auditLog });
    this.readinessGate = readinessGate;
    this.commandRuns = new Map();
    this.packagePlans = new Map();
    this.startedAt = new Date().toISOString();
  }

  async hydrate() {
    await this.workspaceManager.hydrate();
    await this.auditLog.write("ide_runtime_hydrated", { workspaces: this.workspaceManager.listWorkspaces().length });
    return this;
  }

  status() {
    return {
      schema: "nova-ide-status-v0.2-commercial",
      ok: true,
      commercialGrade: true,
      startedAt: this.startedAt,
      workspaces: this.workspaceManager.listWorkspaces().length,
      templates: this.appFactory.templates(),
      deploymentLanes: this.deploymentPlanner.lanes(),
      commandBoundary: this.commandRunner.commands(),
      controls: ["audit_log", "safe_file_vault", "allowlisted_commands", "timeout_kill", "output_hashing", "commercial_readiness_gate", "receipt_chain"]
    };
  }

  async createWorkspace(input = {}) {
    const workspace = await this.workspaceManager.createWorkspace(input);
    await this.auditLog.write("workspace_created", { name: workspace.name, template: workspace.template }, { workspaceId: workspace.id });
    const receipt = await writeReceipt("ide_workspace_created", { workspaceId: workspace.id, name: workspace.name });
    return { workspace, receipt };
  }

  async generateApp(input = {}) {
    const app = this.appFactory.generate(input);
    const { workspace } = await this.createWorkspace({ name: app.plan.title, template: app.plan.template.id, source: "app-factory", files: app.files, metadata: { appPlan: app.plan } });
    await this.auditLog.write("app_generated", { appId: app.plan.id, template: app.plan.template.id, quality: app.quality }, { workspaceId: workspace.id });
    const receipt = await writeReceipt("ide_app_generated", { appId: app.plan.id, workspaceId: workspace.id, quality: app.quality });
    return { app, workspace, receipt };
  }

  async qualityCheck(workspaceId) {
    const files = this.workspaceManager.listFiles(workspaceId).map((meta) => this.workspaceManager.readFile(workspaceId, meta.file));
    const report = this.qualityGate.checkApp({ appId: workspaceId, files: files.map((item) => ({ path: item.file, content: item.content })) });
    await this.auditLog.write("quality_checked", { ok: report.ok, score: report.score, findings: report.findings || report.missing }, { workspaceId });
    const receipt = await writeReceipt("ide_quality_checked", { workspaceId, ok: report.ok, score: report.score });
    return { report, receipt };
  }

  async runCommand(workspaceId, commandId, options = {}) {
    const run = await this.commandRunner.run(workspaceId, commandId, options);
    const existing = this.commandRuns.get(workspaceId) || [];
    existing.push(run);
    this.commandRuns.set(workspaceId, existing.slice(-50));
    const receipt = await writeReceipt("ide_command_run", { workspaceId, commandId, ok: run.ok, exitCode: run.exitCode, outputHash: run.outputHash });
    return { run, receipt };
  }

  async packageWorkspace(workspaceId, lane = "local-preview", approved = false) {
    const files = this.workspaceManager.listFiles(workspaceId).map((meta) => this.workspaceManager.readFile(workspaceId, meta.file));
    const workspace = this.workspaceManager.getWorkspace(workspaceId);
    const app = { id: workspaceId, title: workspace.name, files: files.map((item) => ({ path: item.file, content: item.content })) };
    const plan = this.deploymentPlanner.plan({ app, lane, approved });
    this.packagePlans.set(workspaceId, plan);
    await this.auditLog.write("workspace_packaged", { lane, ok: plan.ok, manifestHash: plan.manifest?.manifestHash }, { workspaceId });
    const receipt = await writeReceipt("ide_workspace_packaged", { workspaceId, lane, ok: plan.ok, manifestHash: plan.manifest?.manifestHash });
    return { plan, receipt };
  }

  async commercialReadiness(workspaceId) {
    const workspace = this.workspaceManager.getWorkspace(workspaceId);
    const files = this.workspaceManager.listFiles(workspaceId).map((meta) => this.workspaceManager.readFile(workspaceId, meta.file)).map((item) => ({ path: item.file, content: item.content }));
    const report = this.readinessGate.evaluate({ workspace, files, commandRuns: this.commandRuns.get(workspaceId) || [], packagePlan: this.packagePlans.get(workspaceId) || null });
    await this.auditLog.write("commercial_readiness_checked", { ok: report.ok, score: report.score, findings: report.findings }, { workspaceId });
    const receipt = await writeReceipt("ide_commercial_readiness", { workspaceId, ok: report.ok, score: report.score, reportHash: report.reportHash });
    return { report, receipt };
  }

  async audit({ limit = 100, workspaceId = null } = {}) {
    return { events: await this.auditLog.list({ limit, workspaceId }) };
  }
}

export async function createIDERuntime(options) {
  const runtime = new NovaIDERuntime(options);
  await runtime.hydrate();
  return runtime;
}
