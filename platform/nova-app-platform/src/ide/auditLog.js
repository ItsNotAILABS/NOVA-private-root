import { appendRecord, readRecords, sha256 } from "../storage.js";

const MAX_EVENT_TYPE = 80;
const MAX_ACTOR = 80;
const MAX_DETAIL_BYTES = Number(process.env.NOVA_IDE_AUDIT_MAX_DETAIL_BYTES || 64 * 1024);

function sanitize(value) {
  const text = JSON.stringify(value ?? {});
  if (Buffer.byteLength(text, "utf8") > MAX_DETAIL_BYTES) return { truncated: true, hash: sha256(text), bytes