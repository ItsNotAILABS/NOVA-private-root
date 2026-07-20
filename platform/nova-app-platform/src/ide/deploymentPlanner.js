import { sha256 } from "../storage.js";

const LANES = [
  { id: "local-preview", name: "Local Preview", live: false },
  { id: "static-export", name: "Static Export", live: false },
  { id: "pwa-export", name: "PWA Export", live: false },
  { id: "browser-extension", name: "Browser Extension Package", live: false },
  { id: "node-service", name: "Node Service Package", live: false },
  { id: "icp-package", name: "ICP Canister Package", live: false, requiresApproval: true },
  { id: "nova-capsule", name: "NOVA Capsule Package", live: false }
];

export class DeploymentPlanner {
  lanes() {
    return LANES.map((lane) => ({ ...lane }));
  }

  plan({ app, lane = "local-preview", approved = false } = {}) {
    const selected = LANES.find((item) => item.id === lane);
    if (!selected) throw new Error("invalid_deployment_lane");
    if (selected.requiresApproval && !approved) {
      return {
        schema: "nova-deployment-plan-v0.1",
        ok: false,
        status: "approval_required",
        lane: selected,
        appId: app?.plan?.id || app?.id || "unknown",
        createdAt: new Date().toISOString()
      };
    }
    const files = app?.files || [];
    const manifest = {
      schema: "nova-deployment-manifest-v0.1",
      appId: app?.plan?.id || app?.id || "unknown",
      title: app?.plan?.title || app?.title || "NOVA App",
      lane: selected.id,
      fileCount: files.length,
      fileHashes: files.map((file) => ({ path: file.path, hash: sha256(file.content || "") })),
      createdAt: new Date().toISOString()
    };
    manifest.manifestHash = sha256(manifest);
    return { schema: "nova-deployment-plan-v0.1", ok: true, status: "packaged", lane: selected, manifest };
  }
}

export function createDeploymentPlanner() {
  return new DeploymentPlanner();
}
