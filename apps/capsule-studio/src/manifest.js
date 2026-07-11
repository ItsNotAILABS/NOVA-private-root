import fsp from 'node:fs/promises';
import path from 'node:path';
import crypto from 'node:crypto';
import { workspacePath } from './workspaceStore.js';
import { writeAudit } from './auditLog.js';

export async function buildManifest(workspaceId) {
  const root = workspacePath(workspaceId);
  const files = [];
  async function walk(dir) {
    for (const entry of await fsp.readdir(dir, { withFileTypes: true })) {
      const full = path.join(dir, entry.name);
      const rel = path.relative(root, full);
      if (entry.isDirectory()) {
        await walk(full);
      } else {
        const data = await fsp.readFile(full);
        files.push({ path: rel, bytes: data.length, sha256: crypto.createHash('sha256').update(data).digest('hex') });
      }
    }
  }
  await walk(root);
  const manifest = {
    schema: 'nova.capsule-studio.manifest.v2',
    workspaceId,
    generatedAt: new Date().toISOString(),
    fileCount: files.length,
    totalBytes: files.reduce((sum, file) => sum + file.bytes, 0),
    files: files.sort((a, b) => a.path.localeCompare(b.path))
  };
  await fsp.mkdir(path.join(root, '.nova'), { recursive: true });
  await fsp.writeFile(path.join(root, '.nova', 'hash-manifest.json'), JSON.stringify(manifest, null, 2), 'utf8');
  await writeAudit('manifest.created', { workspaceId, fileCount: manifest.fileCount, totalBytes: manifest.totalBytes });
  return manifest;
}
