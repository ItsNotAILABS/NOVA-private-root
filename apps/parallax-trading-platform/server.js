import http from 'node:http';
import { config } from './src/config.js';
import { initStore } from './src/store.js';
import { route } from './src/router.js';
import { handleBackendApi } from './src/backendApi.js';

await initStore();

const server = http.createServer(async (req, res) => {
  const url = new URL(req.url, `http://${req.headers.host || 'localhost'}`);
  const handled = await handleBackendApi(req, res, url);
  if (!handled) await route(req, res);
});
server.requestTimeout = 15_000;
server.headersTimeout = 20_000;
server.keepAliveTimeout = 5_000;

server.listen(config.port, config.host, () => {
  console.log(`${config.appName} v${config.version} running at http://${config.host}:${config.port}`);
});

const shutdown = () => server.close(() => process.exit(0));
process.on('SIGINT', shutdown);
process.on('SIGTERM', shutdown);
