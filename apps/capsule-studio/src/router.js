import { config, paths } from './config.js';
import { sendJson, serveStatic, readJson } from './http.js';
import { listTemplates } from './templateCatalog.js';
import { languageRegistry, runFile } from './runner.js';
import { buildManifest } from './manifest.js';
import { deployLocal } from './deployment.js';
import { buildAiApp, explainWorkspace } from './aiBuilder.js';
import { openAiStatus } from './openaiClient.js';
import { createWorkspace, listWorkspaces, listWorkspaceFiles, readWorkspaceFile, updateWorkspaceFile } from './workspaceStore.js';
import { readAudit } from './auditLog.js';
import { listOrganisms, getOrganism } from './internal-ai/organisms.js';
import { listGates } from './internal-ai/gates.js';
import { classifyCyberIntent, cyberGateReceipt } from './internal-ai/cyberSecurityGates.js';
import { routeInternalRequest, internalAiStatus } from './internal-ai/protocolRouter.js';
import { systemProtocolManifest, gateChecklist } from './internal-ai/systemProtocol.js';

export async function route(req, res) {
  const url = new URL(req.url, `http://${req.headers.host}`);
  const pathname = url.pathname;
  const method = req.method || 'GET';

  if (pathname === '/api/health') return sendJson(res, 200, { ok: true, app: config.appName, version: config.version, production: true, ai: openAiStatus(), internalAi: internalAiStatus().version });
  if (pathname === '/api/languages') return sendJson(res, 200, { languages: languageRegistry });
  if (pathname === '/api/templates') return sendJson(res, 200, { templates: listTemplates() });
  if (pathname === '/api/audit') return sendJson(res, 200, { events: await readAudit(Number(url.searchParams.get('limit') || 100)) });

  if (pathname === '/api/internal-ai/status') return sendJson(res, 200, internalAiStatus());
  if (pathname === '/api/internal-ai/protocol') return sendJson(res, 200, systemProtocolManifest());
  if (pathname === '/api/internal-ai/gates') return sendJson(res, 200, { gates: listGates(), checklist: gateChecklist() });
  if (pathname === '/api/internal-ai/organisms') return sendJson(res, 200, { organisms: listOrganisms() });
  if (pathname === '/api/internal-ai/organism') return sendJson(res, 200, getOrganism(url.searchParams.get('id') || 'NOVA'));
  if (pathname === '/api/internal-ai/cyber-gate' && method === 'POST') {
    const body = await readJson(req);
    return sendJson(res, 200, { classification: classifyCyberIntent(body.text || body.intent || ''), receipt: cyberGateReceipt(body.text || body.intent || '') });
  }
  if (pathname === '/api/internal-ai/route' && method === 'POST') {
    const body = await readJson(req);
    return sendJson(res, 200, routeInternalRequest({ organismId: body.organismId || 'NOVA', intentText: body.intentText || body.text || '', lane: body.lane || 'private-operator' }));
  }

  if (pathname === '/api/workspaces' && method === 'GET') return sendJson(res, 200, { workspaces: await listWorkspaces() });
  if (pathname === '/api/workspaces' && method === 'POST') {
    const body = await readJson(req);
    return sendJson(res, 201, await createWorkspace({ name: body.name, template: body.template || 'web', source: 'operator' }));
  }

  if (pathname === '/api/workspace/files' && method === 'GET') {
    const workspaceId = url.searchParams.get('workspaceId');
    return sendJson(res, 200, { files: await listWorkspaceFiles(workspaceId) });
  }
  if (pathname === '/api/workspace/file' && method === 'GET') {
    const workspaceId = url.searchParams.get('workspaceId');
    const file = url.searchParams.get('file');
    return sendJson(res, 200, await readWorkspaceFile(workspaceId, file));
  }
  if (pathname === '/api/workspace/file' && method === 'PUT') {
    const body = await readJson(req);
    return sendJson(res, 200, await updateWorkspaceFile(body.workspaceId, body.file, body.content));
  }

  if (pathname === '/api/run' && method === 'POST') {
    const body = await readJson(req);
    return sendJson(res, 200, await runFile(body.workspaceId, body.file));
  }
  if (pathname === '/api/manifest' && method === 'POST') {
    const body = await readJson(req);
    return sendJson(res, 200, await buildManifest(body.workspaceId));
  }
  if (pathname === '/api/deploy/local' && method === 'POST') {
    const body = await readJson(req);
    return sendJson(res, 200, await deployLocal(body.workspaceId));
  }

  if (pathname === '/api/ai/status') return sendJson(res, 200, openAiStatus());
  if (pathname === '/api/ai/build-app' && method === 'POST') return sendJson(res, 200, await buildAiApp(await readJson(req)));
  if (pathname === '/api/ai/explain' && method === 'POST') return sendJson(res, 200, await explainWorkspace(await readJson(req)));

  if (pathname.startsWith('/preview/')) {
    const [, , workspaceId, ...parts] = pathname.split('/');
    return serveStatic(res, `${paths.workspaces}/${workspaceId}`, parts.join('/') || 'index.html');
  }
  if (pathname.startsWith('/deployed/')) {
    const [, , workspaceId, ...parts] = pathname.split('/');
    return serveStatic(res, `${paths.deployments}/${workspaceId}`, parts.join('/') || 'index.html');
  }
  return serveStatic(res, config.publicDir, pathname.slice(1) || 'index.html');
}
