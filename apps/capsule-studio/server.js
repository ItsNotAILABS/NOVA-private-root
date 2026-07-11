import http from 'node:http';
import { config } from './src/config.js';
import { sendJson } from './src/http.js';
import { ensureStorage } from './src/workspaceStore.js';
import { route } from './src/router.js';
import { writeAudit } from './src/auditLog.js';

const server = http.createServer(async (req, res) => {
  try {
    await route(req, res);
  } catch (error) {
    await writeAudit('server.error', { message: error.message, stack: error.stack?.split('\n').slice(0, 4) });
    sendJson(res, 500, { ok: false, error: error.message });
  }
});

await ensureStorage();
await writeAudit('server.start', { host: config.host, port: config.port, version: config.version });
server.listen(config.port, config.host, () => {
  console.log(`${config.appName} v${config.version} live at http://${config.host}:${config.port}`);
});
