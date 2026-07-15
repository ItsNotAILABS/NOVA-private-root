const REQUIRED_APP_FILES = ["manifest.json", "README.md"];
const SECRET_PATTERNS = [
  /sk-[a-zA-Z0-9_-]{20,}/,
  /OPENAI_API_KEY\s*=\s*["'][^"']+["']/,
  /api[_-]?key\s*[:=]\s*["'][^"']{12,}["']/i,
  /secret\s*[:=]\s*["'][^"']{12,}["']/i
];

export function normalizeFiles(files = []) {
  if (!Array.isArray(files)) throw new Error("files_must_be_array");
  return files.map((file) => ({
    path: String(file.path || "").replace(/\\/g, "/"),
    content: String(file.content || "")
  })).filter((file) => file.path && !file.path.includes(".."));
}

export function scanSecrets(files = []) {
  const findings = [];
  for (const file of normalizeFiles(files)) {
    for (const pattern of SECRET_PATTERNS) {
      if (pattern.test(file.content)) findings.push({ path: file.path, reason: "possible_secret" });
    }
  }
  return findings;
}

export function evaluateAppCompleteness(files = []) {
  const normalized = normalizeFiles(files);
  const paths = new Set(normalized.map((file) => file.path));
  const missing = [];
  for (const required of REQUIRED_APP_FILES) if (!paths.has(required)) missing.push(required);
  const hasEntrypoint = ["index.html", "src/index.js", "src/main.js", "app.js", "server.js"].some((p) => paths.has(p));
  if (!hasEntrypoint) missing.push("runnable_entrypoint");
  const hasTest = normalized.some((file) => /(^|\/)(tests?|__tests__)\//.test(file.path) || /\.test\.(js|ts)$/.test(file.path));
  if (!hasTest) missing.push("validation_test");
  const score = Math.max(0, 100 - missing.length * 20 - scanSecrets(normalized).length * 50);
  return { ok: missing.length === 0, score, missing, fileCount: normalized.length };
}

export class QualityGate {
  checkWorkspace(workspace) {
    const files = Array.isArray(workspace?.files) ? workspace.files : [];
    return this.checkApp({ files, appId: workspace?.id || "workspace" });
  }

  checkApp({ files