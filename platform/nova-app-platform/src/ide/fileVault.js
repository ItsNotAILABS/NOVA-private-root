import fs from "node:fs";
import path from "node:path";
import crypto from "node:crypto";
import { ensureDir, writeAtomic, platformVaultRoot, sha256 } from "../storage.js";

const MAX_FILE_BYTES = Number(process.env.NOVA_IDE_MAX_FILE_BYTES || 512 * 1024);
const SAFE_FILE = /^[a-z0-9][a-z0-9._\-/]{0,220}$/i;

export function ideRoot() {
  return path.join(platformVaultRoot(), "ide-workspaces");
}

export function safeId(value, prefix = "nova") {
  const base = String(value || "").toLowerCase().replace(/[^a-z0-9-]+/g, "-").replace(/^-+|-+$/g, "").slice(0, 64);
  return base || `${prefix}-${crypto.randomBytes(4).toString("hex")}`;
}

export function assertSafeFile(file) {
  const candidate = String(file || "").replace(/\\/g, "/").replace(/^\/+/, "");
  if (!candidate || candidate.includes("..") || !SAFE_FILE.test(candidate)) throw new Error("invalid_file_path");
  return candidate;
}

export class FileSystemVault {
  constructor(rootDir = ideRoot()) {
    this.rootDir = path.resolve(rootDir);
    ensureDir(this.rootDir);
  }

  workspaceDir(workspaceId) {
    const id = safeId(workspaceId, "workspace");
    const dir = path.resolve(this.rootDir, id);
    if (!dir.startsWith(this.rootDir + path.sep)) throw new Error("workspace_path_forbidden");
    return dir;
  }

  filePath(workspaceId, file) {
    const relative = assertSafeFile(file);
    const resolved = path.resolve(this.workspaceDir(workspaceId), relative);
    if (!resolved.startsWith(this.workspaceDir(workspaceId) + path.sep)) throw new Error("file_path_forbidden");
    return resolved;
  }

  ensureWorkspace(workspaceId) {
    const dir = this.workspaceDir(workspaceId);
    ensureDir(dir);
    return dir;
  }

  writeFile(workspaceId, file, content) {
    const text = String(content ?? "");
    if (Buffer.byteLength(text, "utf8") > MAX_FILE_BYTES) throw new Error("file_too_large");
    const filePath = this.filePath(workspaceId, file);
    writeAtomic(filePath, text);
    return this.describeFile(workspaceId, file);
  }

  readFile(workspaceId, file) {
    const filePath = this.filePath(workspaceId, file);
    if (!fs.existsSync(filePath)) throw new Error("file_not_found");
    return { file: assertSafeFile(file), content: fs.readFileSync(filePath, "utf8"), meta: this.describeFile(workspaceId, file) };
  }

  exists(workspaceId, file) {
    return fs.existsSync(this.filePath(workspaceId, file));
  }

  listFiles(workspaceId) {
    const dir = this.ensureWorkspace(workspaceId);
    const out = [];
    const walk = (current) => {
      for (const entry of fs.readdirSync(current, { withFileTypes: true })) {
        const absolute = path.join(current, entry.name);
        const relative = path.relative(dir, absolute).replace(/\\/g, "/");
        if (entry.isDirectory()) walk(absolute);
        else out.push(this.describeAbsolute(relative, absolute));
      }
    };
    walk(dir);
    return out.sort((a, b) => a.file.localeCompare(b.file));
  }

  writeMany(workspaceId, files) {
    const written = [];
    for (const file of files || []) written.push(this.writeFile(workspaceId, file.path, file.content));
    return written;
  }

  manifest(workspaceId) {
    const files = this.listFiles(workspaceId);
    return {
      schema: "nova-ide-file-manifest-v0.1",
      workspaceId: safeId(workspaceId, "workspace"),
      fileCount: files.length,
      files,
      manifestHash: sha256(files.map((f) => ({ file: f.file, hash: f.hash })))
    };
  }

  describeFile(workspaceId, file) {
    const safe = assertSafeFile(file);
    return this.describeAbsolute(safe, this.filePath(workspaceId, safe));
  }

  describeAbsolute(file, absolute) {
    const stat = fs.statSync(absolute);
    const content = fs.readFileSync(absolute);
    return { file, bytes: stat.size, updatedAt: stat.mtime.toISOString(), hash: sha256(content.toString("utf8")) };
  }
}
