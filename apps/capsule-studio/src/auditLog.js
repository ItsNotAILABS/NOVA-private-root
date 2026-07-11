import fsp from 'node:fs/promises';
import path from 'node:path';
import crypto from 'node:crypto';
import { paths } from './config.js';

export async function writeAudit(event, payload = {}) {
  const record = {
    schema: 'nova.capsule-studio.audit.v1',
    id: crypto.randomUUID(),
    event,
    at: new Date().toISOString(),
    payload
  };
  await fsp.mkdir(path.dirname(paths.auditLog), { recursive: true });
  await fsp.appendFile(paths.auditLog, `${JSON.stringify(record)}\n`, 'utf8');
  return record;
}

export async function readAudit(limit = 100) {
  try {
    const text = await fsp.readFile(paths.auditLog, 'utf8');
    return text.trim().split('\n').filter(Boolean).slice(-limit).map((line) => JSON.parse(line));
  } catch {
    return [];
  }
}
