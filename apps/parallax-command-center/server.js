import http from 'node:http';
import { config } from './src/config.js';
import { route } from './src/router.js';
import { ensureState } from './src/state.js';
import { startAutomationScheduler, stopAutomationScheduler } from './src/automationScheduler.js';

const server = http.createServer(async (req, res) => {
  try {
    await route(req, res);
  } catch (error) {
    res.writeHead(500, { 'content-type': 'application/json; charset=utf-8' });
    res.end(JSON.stringify({ ok: false, error: error.message }));
  }
});

await ensureState();
startAutomationScheduler(config.automation);

server.listen(config.port, config.host, () => {
  console.log(`${config.appName} v${config.version} live at http://${config.host}:${config.port}`);
  console.log(`paper automation ${config.automation.enabled ? 'enabled' : 'disabled'} · interval ${config.automation.intervalMs}ms`);
});

function shutdown() {
  stopAutomationScheduler();
  server.close(() => process.exit(0));
}

process.on('SIGINT', shutdown);
process.on('SIGTERM', shutdown);
