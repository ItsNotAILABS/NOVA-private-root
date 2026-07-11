import fsp from 'node:fs/promises';
import path from 'node:path';
import { paths } from './config.js';
import { safeJoin } from './http.js';
import { workspacePath, readWorkspace } from './workspaceStore.js';
import { buildManifest } from './manifest.js';
import { writeAudit } from './auditLog.js';

export async function deployLocal(workspaceId) {
  const workspace = workspacePath(workspaceId);
  const meta = await readWorkspace(workspaceId);
  const target = safeJoin(paths.deployments, workspaceId);
  await fsp.rm(target, { recursive: true, force: true });
  await fsp.mkdir(target, { recursive: true });
  for (const name of await fsp.readdir(workspace)) {
    if (name === '.nova') continue;
    await fsp.cp(path.join(workspace, name), path.join(target, name), { recursive: true });
  }
  const manifest = await buildManifest(workspaceId);
  const packet = {
    schema: 'nova.capsule-studio.local-deployment.v2',
    ok: true,
    workspaceId,
    entry: meta.entry || 'index.html',
    target,
    url: `/deployed/${workspaceId}/${meta.entry || 'index.html'}`,
    manifest,
    deployedAt: new Date().toISOString()
  };
  await fsp.writeFile(path.join(workspace, '.nova', 'deployment.json'), JSON.stringify(packet, null, 2), 'utf8');
  await writeAudit('deployment.local.created', { workspaceId, url: packet.url });
  return packet;
}
