import { WorkspaceManager } from "./workspaceManager.js";
import { createAppFactory } from "./appFactory.js";
import { createQualityGate } from "./qualityGate.js";
import { createDeploymentPlanner } from "./deploymentPlanner.js";
import { writeReceipt } from "../receipts.js";

export class NovaIDERuntime {
  constructor({ workspaceManager = new WorkspaceManager(), qualityGate = createQualityGate(), appFactory = null, deploymentPlanner = createDeploymentPlanner() } = {}) {
    this.workspaceManager = workspaceManager;
    this.qualityGate = qualityGate;
    this.appFactory = appFactory || createAppFactory({ qualityGate });
    this.deploymentPlanner = deploymentPlanner;
    this.startedAt = new Date().toISOString();
  }

  async hydrate() {
    await this.workspaceManager.hydrate();
    return this;
  }

  status() {
    return {
      schema: "nova-ide-status-v0.1",
      ok: true,
      startedAt: this.startedAt,
      workspaces: this.workspaceManager.listWorkspaces().length,
      templates: this.appFactory.templates(),
      deploymentLanes: this.deploymentPlanner.lanes()
    };
  }

  async createWorkspace(input = {}) {
    const workspace = await this.workspaceManager.createWorkspace(input);
    const receipt = await writeReceipt("ide_workspace_created", { workspaceId: workspace.id, name: workspace.name });
    return { workspace, receipt };
  }

  async generateApp(input = {}) {
    const app = this.appFactory.generate(input);
    const { workspace } = await this.createWorkspace({ name: app.plan.title, template: app.plan.template.id, source: "app-factory", files: app.files, metadata: { appPlan: app.plan } });
    const receipt = await writeReceipt("ide_app_generated", { appId: app.plan.id, workspaceId: workspace.id, quality: app.quality });
    return { app, workspace, receipt };
  }

  async qualityCheck(workspaceId) {
    const files = this.workspaceManager.listFiles(workspaceId).map((meta) => this.workspaceManager.readFile(workspaceId, meta.file));
    const report = this.qualityGate.checkApp({ appId: workspaceId, files: files.map((item) => ({ path: item.file, content: item.content })) });
    const receipt = await writeReceipt("ide_quality_checked", { workspaceId, ok: report.ok, score: report.score });
    return { report, receipt };
  }

  async packageWorkspace(workspaceId, lane = "local-preview", approved = false) {
    const files = this.workspaceManager.listFiles(workspaceId).map((meta) => this.workspaceManager.readFile(workspaceId, meta.file));
    const workspace = this.workspaceManager.getWorkspace(workspaceId);
    const app = { id: workspaceId, title: workspace.name, files: files.map((item) => ({ path: item.file, content: item.content })) };
    const plan = this.deploymentPlanner.plan({ app, lane, approved });
    const receipt = await writeReceipt("ide_workspace_packaged", { workspaceId, lane, ok: plan.ok, manifestHash: plan.manifest?.manifestHash });
    return { plan, receipt };
  }
}

export async function createIDERuntime(options) {
  const runtime = new NovaIDERuntime(options);
  await runtime.hydrate();
  return runtime;
}
