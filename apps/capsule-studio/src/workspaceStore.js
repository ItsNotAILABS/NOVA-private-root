import fsp from 'node:fs/promises';
import path from 'node:path';
import crypto from 'node:crypto';
import { paths } from './config.js';
import { safeJoin } from './http.js';
import { getTemplate } from './templateCatalog.js';
import { writeAudit } from './auditLog.js';

export async function ensureStorage() {
  await fsp.mkdir(paths.workspaces, { recursive: true });
  await fsp.mkdir(paths.deployments, { recursive: true });
}

export function slug(input) {
  return String(input || 'nova-project').toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/(^-|-$)/g, '') || 'nova-project';
}

export function workspacePath(workspaceId) {
  return safeJoin(paths.workspaces, workspaceId);
}

export async function writeWorkspaceFiles(workspace, files) {
  for (const [name, content] of Object.entries(files || {})) {
    const target = safeJoin(workspace, name);
    await fsp.mkdir(path.dirname(target), { recursive: true });
    await fsp.writeFile(target, String(content), 'utf8');
  }
}

export async function createWorkspace({ name = 'NOVA Workspace', template = 'web', files = null, source = 'template', metadata = {} } = {}) {
  await ensureStorage();
  const id = `${Date.now()}-${crypto.randomUUID().slice(0, 8)}-${slug(name)}`;
  const root = path.join(paths.workspaces, id);
  const selected = getTemplate(template);
  await fsp.mkdir(path.join(root, '.nova', 'receipts'), { recursive: true });
  await writeWorkspaceFiles(root, files || selected.files(name));
  const record = {
    schema: 'nova.capsule-studio.workspace.v1',
    id,
    name,
    template: selected.id,
    entry: selected.entry,
    source,
    status: 'active',
    path: root,
    preview: `/preview/${id}/${selected.entry}`,
    deployed: `/deployed/${id}/${selected.entry}`,
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
    metadata
  };
  await fsp.writeFile(path.join(root, '.nova', 'workspace.json'), JSON.stringify(record, null, 2), 'utf8');
  await writeAudit('workspace.created', { id, name, template: selected.id, source });
  return record;
}

export async function readWorkspace(workspaceId) {
  const root = workspacePath(workspaceId);
  const file = path.join(root, '.nova', 'workspace.json');
  const record = JSON.parse(await fsp.readFile(file, 'utf8'));
  return record;
}

export async function listWorkspaces() {
  await ensureStorage();
  const entries = await fsp.readdir(paths.workspaces, { withFileTypes: true });
  const records = [];
  for (const entry of entries) {
    if (!entry.isDirectory()) continue;
    try {
      records.push(await readWorkspace(entry.name));
    } catch {
      records.push({ id: entry.name, name: entry.name, status: 'unknown', path: path.join(paths.workspaces, entry.name) });
    }
  }
  return records.sort((a, b) => String(b.createdAt || '').localeCompare(String(a.createdAt || '')));
}

export async function listWorkspaceFiles(workspaceId) {
  const root = workspacePath(workspaceId);
  const files = [];
  async function walk(dir) {
    for (const entry of await fsp.readdir(dir, { withFileTypes: true })) {
      const full = path.join(dir, entry.name);
      const rel = path.relative(root, full);
      if (rel.startsWith('.nova')) continue;
      if (entry.isDirectory()) await walk(full);
      else files.push({ path: rel, bytes: (await fsp.stat(full)).size });
    }
  }
  await walk(root);
  return files.sort((a, b) => a.path.localeCompare(b.path));
}

export async function readWorkspaceFile(workspaceId, file) {
  const root = workspacePath(workspaceId);
  const target = safeJoin(root, file);
  const content = await fsp.readFile(target, 'utf8');
  return { workspaceId, path: file, content };
}

export async function updateWorkspaceFile(workspaceId, file, content) {
  const root = workspacePath(workspaceId);
  const target = safeJoin(root, file);
  await fsp.mkdir(path.dirname(target), { recursive: true });
  await fsp.writeFile(target, String(content), 'utf8');
  const record = await readWorkspace(workspaceId);
  record.updatedAt = new Date().toISOString();
  await fsp.writeFile(path.join(root, '.nova', 'workspace.json'), JSON.stringify(record, null, 2), 'utf8');
  await writeAudit('workspace.file.updated', { workspaceId, file });
  return { ok: true, workspaceId, path: file };
}
