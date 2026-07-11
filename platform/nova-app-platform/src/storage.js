import fs from "node:fs";
import path from "node:path";
import crypto from "node:crypto";

export function stableStringify(value) {
  if (value === null || typeof value !== "object") return JSON.stringify(value);
  if (Array.isArray(value)) return `[${value.map(stableStringify).join(",")}]`;
  return `{${Object.keys(value).sort().map((key) => `${JSON.stringify(key)}:${stableStringify(value[key])}`).join(",")}}`;
}

export function sha256(value) {
  return crypto.createHash("sha256").update(typeof value === "string" ? value : stableStringify(value)).digest("hex");
}

export function platformVaultRoot() {
  return path.resolve(process.env.NOVA_PLATFORM_VAULT || path.join(process.cwd(), ".nova-platform-vault"));
}

export function assertSafeCollection(collection) {
  if (!/^[a-z0-9][a-z0-9_-]{1,64}$/i.test(String(collection || ""))) throw new Error("invalid_collection");
  return collection;
}

export function ensureDir(dir) {
  fs.mkdirSync(dir, { recursive: true });
}

export function writeAtomic(filePath, content) {
  ensureDir(path.dirname(filePath));
  const tmp = `${filePath}.${process.pid}.${Date.now()}.tmp`;
  fs.writeFileSync(tmp, content);
  fs.renameSync(tmp, filePath);
}

function collectionFile(collection) {
  assertSafeCollection(collection);
  return path.join(platformVaultRoot(), `${collection}.jsonl`);
}

function readJsonl(filePath) {
  if (!fs.existsSync(filePath)) return [];
  const text = fs.readFileSync(filePath, "utf8").trim();
  if (!text) return [];
  return text.split("\n").filter(Boolean).map((line) => JSON.parse(line));
}

export async function appendRecord(collection, payload, options = {}) {
  const filePath = collectionFile(collection);
  ensureDir(path.dirname(filePath));
  const existing = readJsonl(filePath);
  const previousHash = existing.length ? existing[existing.length - 1].recordHash : null;
  const record = {
    schema: "nova-platform-record-v0.2",
    id: options.id || `nova_${collection}_${Date.now()}_${crypto.randomBytes(6).toString("hex")}`,
    collection,
    createdAt: new Date().toISOString(),
    previousHash,
    payload
  };
  record.recordHash = sha256(record);
  fs.appendFileSync(filePath, `${JSON.stringify(record)}\n`);
  return record;
}

export async function readRecords(collection, { limit = 100 } = {}) {
  const records = readJsonl(collectionFile(collection));
  return records.slice(Math.max(0, records.length - limit));
}

export function verifyRecordChain(records) {
  let previousHash = null;
  for (const record of records) {
    const { recordHash, ...unsigned } = record;
    if (record.previousHash !== previousHash) return { ok: false, error: "previous_hash_mismatch", record };
    if (sha256(unsigned) !== recordHash) return { ok: false, error: "record_hash_mismatch", record };
    previousHash = recordHash;
  }
  return { ok: true, count: records.length, headHash: previousHash };
}

export class PlatformVault {
  constructor(rootDir = platformVaultRoot()) {
    this.rootDir = path.resolve(rootDir);
    this.stateFile = path.join(this.rootDir, "state.json");
  }

  ensure() {
    ensureDir(this.rootDir);
  }

  defaultState() {
    return {
      schema: "nova-app-platform-state-v0.2",
      createdAt: new Date().toISOString(),
      apps: [],
      sessions: [],
      events: []
    };
  }

  load() {
    this.ensure();
    if (!fs.existsSync(this.stateFile)) return this.defaultState();
    const envelope = JSON.parse(fs.readFileSync(this.stateFile, "utf8"));
    if (sha256(envelope.state) !== envelope.stateHash) throw new Error("state_hash_mismatch");
    return envelope.state;
  }

  save(state) {
    this.ensure();
    const envelope = {
      schema: "nova-app-platform-envelope-v0.2",
      savedAt: new Date().toISOString(),
      state,
      stateHash: sha256(state)
    };
    writeAtomic(this.stateFile, JSON.stringify(envelope, null, 2));
    return appendRecord("state", { stateHash: envelope.stateHash, stateFile: this.stateFile });
  }

  listReceipts() {
    return readRecords("receipts", { limit: 500 });
  }
}
