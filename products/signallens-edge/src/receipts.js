export const RECEIPT_SCHEMA = 'signallens.relay_receipt.v1';

export async function sha256(value) {
  const text = typeof value === 'string' ? value : JSON.stringify(value, Object.keys(value || {}).sort());
  const data = new TextEncoder().encode(text);
  if (globalThis.crypto?.subtle) {
    const digest = await globalThis.crypto.subtle.digest('SHA-256', data);
    return Array.from(new Uint8Array(digest)).map((byte) => byte.toString(16).padStart(2, '0')).join('');
  }
  const { createHash } = await import('node:crypto');
  return createHash('sha256').update(text).digest('hex');
}

export function stable(value) {
  if (value === null || typeof value !== 'object') return value;
  if (Array.isArray(value)) return value.map(stable);
  return Object.fromEntries(Object.keys(value).sort().map((key) => [key, stable(value[key])]));
}

export function normalizeRelayReceipt(input = {}, actor = 'operator') {
  const receipt = input.receipt && typeof input.receipt === 'object' ? input.receipt : input;
  const source = String(receipt.source || receipt.system || receipt.producer || 'relay');
  const sourceReceiptSha256 = String(receipt.receipt_sha256 || receipt.receiptSha256 || receipt.hash || receipt.source_receipt_sha256 || '');
  const contentSha256 = String(receipt.content_sha256 || receipt.contentSha256 || '');
  const requestId = String(receipt.request_id || receipt.requestId || receipt.id || '');
  const event = String(receipt.event || receipt.type || 'relay.receipt');
  const createdAt = String(receipt.created_at || receipt.createdAt || receipt.recorded_at || new Date().toISOString());
  const payload = stable({
    schema: RECEIPT_SCHEMA,
    source,
    event,
    requestId,
    sourceReceiptSha256,
    contentSha256,
    actor: String(actor || 'operator'),
    vertical: String(receipt.vertical || input.vertical || 'general'),
    relay: stable(receipt),
    createdAt
  });
  return payload;
}

export async function sealRelayReceipt(input = {}, actor = 'operator') {
  const normalized = normalizeRelayReceipt(input, actor);
  const hash = await sha256(normalized);
  return { ...normalized, hash };
}

export function validateRelayReceipt(sealed) {
  const errors = [];
  if (sealed.schema !== RECEIPT_SCHEMA) errors.push('invalid_schema');
  if (!sealed.source) errors.push('source_required');
  if (!sealed.event) errors.push('event_required');
  if (sealed.sourceReceiptSha256 && !/^[a-f0-9]{64}$/i.test(sealed.sourceReceiptSha256)) errors.push('source_receipt_sha256_invalid');
  if (sealed.contentSha256 && !/^[a-f0-9]{64}$/i.test(sealed.contentSha256)) errors.push('content_sha256_invalid');
  if (!/^[a-f0-9]{64}$/i.test(sealed.hash || '')) errors.push('hash_invalid');
  return { ok: errors.length === 0, errors };
}

async function putReceipt(env, sealed) {
  const store = env.SIGNALLENS_RECEIPTS || env.RECEIPTS;
  if (store?.put) {
    await store.put(sealed.hash, JSON.stringify(sealed), {
      metadata: {
        schema: sealed.schema,
        source: sealed.source,
        event: sealed.event,
        requestId: sealed.requestId,
        createdAt: sealed.createdAt
      }
    });
    return 'kv';
  }
  if (env.RECEIPT_LOG?.write) {
    const writer = env.RECEIPT_LOG.getWriter();
    await writer.write(new TextEncoder().encode(JSON.stringify(sealed) + '\n'));
    writer.releaseLock();
    return 'stream';
  }
  return 'ack-only';
}

export async function ingestRelayReceipt(input = {}, env = {}, actor = 'operator') {
  const sealed = await sealRelayReceipt(input, actor);
  const validation = validateRelayReceipt(sealed);
  if (!validation.ok) {
    const error = new Error(validation.errors.join(','));
    error.status = 400;
    throw error;
  }
  const storage = await putReceipt(env, sealed);
  return {
    ok: true,
    schema: 'signallens.relay_receipt_ack.v1',
    storage,
    hash: sealed.hash,
    sourceReceiptSha256: sealed.sourceReceiptSha256,
    contentSha256: sealed.contentSha256,
    source: sealed.source,
    event: sealed.event,
    requestId: sealed.requestId,
    createdAt: sealed.createdAt
  };
}

export async function getStoredReceipt(hash, env = {}) {
  if (!/^[a-f0-9]{64}$/i.test(String(hash || ''))) return null;
  const store = env.SIGNALLENS_RECEIPTS || env.RECEIPTS;
  if (!store?.get) return null;
  const value = await store.get(String(hash), { type: 'json' });
  return value || null;
}
