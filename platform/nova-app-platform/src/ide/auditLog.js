import { appendRecord, readRecords, sha256 } from "../storage.js";

const MAX_EVENT_TYPE = 80;
const MAX_ACTOR = 80;
const MAX_DETAIL_BYTES = Number(process.env.NOVA_IDE_AUDIT_MAX_DETAIL_BYTES || 64 * 1024);

function sanitize(value) {
  const text = JSON.stringify(value ?? {});
  if (Buffer.byteLength(text, "utf8") > MAX_DETAIL_BYTES) {
    return { truncated: true, hash: sha256(text), bytes: Buffer.byteLength(text, "utf8") };
  }
  return value ?? {};
}

export class AuditLog {
  constructor({ collection = "ide_audit" } = {}) {
    this.collection = collection;
  }

  async write(type, detail = {}, { actor = "operator", workspaceId = null, requestId = null } = {}) {
    if (!/^[a-z0-9][a-z0-9_.:-]{1,80}$/i.test(String(type || ""))) throw new Error("invalid_audit_event_type");
    const event = {
      schema: "nova-ide-audit-event-v0.1",
      type: String(type).slice(0, MAX_EVENT_TYPE),
      actor: String(actor || "operator").slice(0, MAX_ACTOR),
      workspaceId,
      requestId,
      detail: sanitize(detail),
      detailHash: sha256(detail ?? {}),
      createdAt: new Date().toISOString()
    };
    const record = await appendRecord(this.collection, event);
    return { ...event, recordHash: record.recordHash, recordId: record.id };
  }

  async list({ limit = 100, workspaceId = null } = {}) {
    const records = await readRecords(this.collection, { limit: Math.min(Number(limit || 100), 500) });
    const events = records.map((record) => ({ ...record.payload, recordId: record.id, recordHash: record.recordHash }));
    return workspaceId ? events.filter((event) => event.workspaceId === workspaceId) : events;
  }
}

export function createAuditLog(options) {
  return new AuditLog(options);
}
