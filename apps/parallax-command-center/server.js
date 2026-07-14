import http from 'node:http';
import { config } from './src/config.js';
import { route } from './src/router.js';

const server = http.createServer(async (req, res) => {
  try {
    await route(req, res);
  } catch (error) {
    res.writeHead(500, { 'content-type': 'application/json; charset=utf-8' });
    res.end(JSON.stringify({ ok: false, error: error.message }));
  }
});

server.listen(config.port, config.host, () => {
  console.log(`${config.appName} v${config.version} live at http://${config.host}:${config.port}`);
});
