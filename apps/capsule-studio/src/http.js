import fsp from 'node:fs/promises';
import path from 'node:path';

export function sendJson(res, code, payload) {
  res.writeHead(code, {
    'content-type': 'application/json; charset=utf-8',
    'cache-control': 'no-store',
    'x-content-type-options': 'nosniff'
  });
  res.end(JSON.stringify(payload, null, 2));
}

export function sendText(res, code, body, type = 'text/plain; charset=utf-8') {
  res.writeHead(code, {
    'content-type': type,
    'cache-control': 'no-store',
    'x-content-type-options': 'nosniff'
  });
  res.end(body);
}

export async function readJson(req, limitBytes = 1_000_000) {
  const chunks = [];
  let total = 0;
  for await (const chunk of req) {
    total += chunk.length;
    if (total > limitBytes) throw new Error('request body too large');
    chunks.push(chunk);
  }
  if (!chunks.length) return {};
  const text = Buffer.concat(chunks).toString('utf8');
  return JSON.parse(text);
}

export function contentType(file) {
  const ext = path.extname(file).toLowerCase();
  if (ext === '.html') return 'text/html; charset=utf-8';
  if (ext === '.css') return 'text/css; charset=utf-8';
  if (ext === '.js' || ext === '.mjs') return 'application/javascript; charset=utf-8';
  if (ext === '.json') return 'application/json; charset=utf-8';
  if (ext === '.svg') return 'image/svg+xml';
  if (ext === '.png') return 'image/png';
  if (ext === '.jpg' || ext === '.jpeg') return 'image/jpeg';
  return 'application/octet-stream';
}

export async function serveStatic(res, root, rel = 'index.html') {
  try {
    const target = safeJoin(root, rel || 'index.html');
    const data = await fsp.readFile(target);
    res.writeHead(200, { 'content-type': contentType(target), 'cache-control': 'no-store', 'x-content-type-options': 'nosniff' });
    res.end(data);
  } catch {
    sendText(res, 404, 'not found');
  }
}

export function safeJoin(root, rel = '') {
  const base = path.resolve(root);
  const target = path.resolve(base, rel);
  if (!target.startsWith(base)) throw new Error('path escapes root');
  return target;
}

export function routeKey(method, pathname) {
  return `${method.toUpperCase()} ${pathname}`;
}
