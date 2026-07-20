export interface Env {
  ASSETS: Fetcher;
  DB: D1Database;
  CONFIG: KVNamespace;
  ARTIFACTS: R2Bucket;
  BUILD_COORDINATOR: DurableObjectNamespace;
  BUILD_QUEUE: Queue<BuildMessage>;
  AI?: Ai;
  APP_ENV: string;
  EXTENDED_RUNTIME_URL: string;
  ICP_GATEWAY_URL: string;
}

type RuntimeLane = 'worker' | 'python-worker' | 'extended-runtime' | 'icp';
type BuildMessage = { buildId: string; projectId: string; lane: RuntimeLane };

type BuildManifest = {
  projectId: string;
  name: string;
  chainTarget: string;
  framework: string;
  runtimeLane: RuntimeLane;
  sourceRevision?: string;
  commands?: string[];
};

const json = (body: unknown, status = 200, headers: HeadersInit = {}) =>
  new Response(JSON.stringify(body), {
    status,
    headers: {
      'content-type': 'application/json; charset=utf-8',
      'cache-control': 'no-store',
      'x-content-type-options': 'nosniff',
      'referrer-policy': 'same-origin',
      ...headers,
    },
  });

const id = (prefix: string) => `${prefix}_${crypto.randomUUID().replaceAll('-', '')}`;
const now = () => new Date().toISOString();

function actor(request: Request): string {
  return request.headers.get('cf-access-authenticated-user-email') || request.headers.get('x-nova-actor') || 'local-operator';
}

async function parseJson<T>(request: Request): Promise<T> {
  const length = Number(request.headers.get('content-length') || 0);
  if (length > 1_000_000) throw new Error('request body too large');
  return request.json<T>();
}

async function audit(env: Env, actorId: string, topic: string, resourceType: string, resourceId: string, payload: unknown) {
  await env.DB.prepare(
    'INSERT INTO audit_events (id, actor_id, topic, resource_type, resource_id, payload_json, created_at) VALUES (?, ?, ?, ?, ?, ?, ?)'
  ).bind(id('evt'), actorId, topic, resourceType, resourceId, JSON.stringify(payload), now()).run();
}

async function createProject(request: Request, env: Env) {
  const input = await parseJson<{ name: string; slug?: string; chainTarget?: string; framework?: string }>(request);
  if (!input.name?.trim()) return json({ ok: false, error: 'name is required' }, 400);
  const projectId = id('prj');
  const createdAt = now();
  const slug = (input.slug || input.name).toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '');
  const owner = actor(request);
  await env.DB.prepare(
    'INSERT INTO projects (id, owner_id, name, slug, chain_target, framework, status, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)'
  ).bind(projectId, owner, input.name.trim(), slug, input.chainTarget || 'evm', input.framework || 'react-worker', 'draft', createdAt, createdAt).run();
  await audit(env, owner, 'project.created', 'project', projectId, input);
  return json({ ok: true, project: { id: projectId, owner_id: owner, name: input.name.trim(), slug, chain_target: input.chainTarget || 'evm', framework: input.framework || 'react-worker', status: 'draft', created_at: createdAt } }, 201);
}

async function listProjects(env: Env) {
  const result = await env.DB.prepare('SELECT * FROM projects ORDER BY created_at DESC LIMIT 100').all();
  return json({ ok: true, projects: result.results });
}

function chooseLane(manifest: BuildManifest): RuntimeLane {
  if (manifest.runtimeLane) return manifest.runtimeLane;
  if (manifest.chainTarget === 'icp') return 'icp';
  if ((manifest.commands || []).some((cmd) => /python|pip|fastapi/i.test(cmd))) return 'python-worker';
  if ((manifest.commands || []).some((cmd) => /subprocess|docker|cargo|dfx|filesystem/i.test(cmd))) return 'extended-runtime';
  return 'worker';
}

async function createBuild(request: Request, env: Env, projectId: string) {
  const project = await env.DB.prepare('SELECT * FROM projects WHERE id = ?').bind(projectId).first<Record<string, unknown>>();
  if (!project) return json({ ok: false, error: 'project not found' }, 404);
  const input = await parseJson<Partial<BuildManifest>>(request);
  const manifest: BuildManifest = {
    projectId,
    name: String(input.name || project.name),
    chainTarget: String(input.chainTarget || project.chain_target),
    framework: String(input.framework || project.framework),
    runtimeLane: chooseLane(input as BuildManifest),
    sourceRevision: input.sourceRevision,
    commands: Array.isArray(input.commands) ? input.commands.map(String) : [],
  };
  const buildId = id('bld');
  const createdAt = now();
  await env.DB.prepare(
    'INSERT INTO builds (id, project_id, status, source_revision, runtime_lane, manifest_json, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)'
  ).bind(buildId, projectId, 'queued', manifest.sourceRevision || null, manifest.runtimeLane, JSON.stringify(manifest), createdAt, createdAt).run();
  await env.BUILD_QUEUE.send({ buildId, projectId, lane: manifest.runtimeLane });
  await audit(env, actor(request), 'build.queued', 'build', buildId, manifest);
  return json({ ok: true, build: { id: buildId, project_id: projectId, status: 'queued', runtime_lane: manifest.runtimeLane, manifest, created_at: createdAt } }, 202);
}

async function getBuild(env: Env, buildId: string) {
  const build = await env.DB.prepare('SELECT * FROM builds WHERE id = ?').bind(buildId).first<Record<string, unknown>>();
  return build ? json({ ok: true, build: { ...build, manifest: JSON.parse(String(build.manifest_json || '{}')) } }) : json({ ok: false, error: 'build not found' }, 404);
}

async function routeApi(request: Request, env: Env): Promise<Response> {
  const url = new URL(request.url);
  if (request.method === 'GET' && url.pathname === '/api/health') {
    return json({ ok: true, app: 'NOVA Builder', environment: env.APP_ENV, architecture: 'cloudflare-native', lanes: ['worker', 'python-worker', 'extended-runtime', 'icp'], timestamp: now() });
  }
  if (request.method === 'GET' && url.pathname === '/api/projects') return listProjects(env);
  if (request.method === 'POST' && url.pathname === '/api/projects') return createProject(request, env);
  const projectBuildMatch = url.pathname.match(/^\/api\/projects\/([^/]+)\/builds$/);
  if (request.method === 'POST' && projectBuildMatch) return createBuild(request, env, projectBuildMatch[1]);
  const buildMatch = url.pathname.match(/^\/api\/builds\/([^/]+)$/);
  if (request.method === 'GET' && buildMatch) return getBuild(env, buildMatch[1]);
  return json({ ok: false, error: 'route not found' }, 404);
}

async function executeBuild(env: Env, message: BuildMessage) {
  const stub = env.BUILD_COORDINATOR.get(env.BUILD_COORDINATOR.idFromName(message.buildId));
  return stub.fetch('https://coordinator.internal/run', {
    method: 'POST',
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify(message),
  });
}

export class BuildCoordinator {
  constructor(private readonly state: DurableObjectState, private readonly env: Env) {}

  async fetch(request: Request): Promise<Response> {
    const url = new URL(request.url);
    if (request.method !== 'POST' || url.pathname !== '/run') return json({ ok: false, error: 'not found' }, 404);
    const message = await request.json<BuildMessage>();
    return this.state.blockConcurrencyWhile(async () => {
      const build = await this.env.DB.prepare('SELECT * FROM builds WHERE id = ?').bind(message.buildId).first<Record<string, unknown>>();
      if (!build) return json({ ok: false, error: 'build not found' }, 404);
      if (['completed', 'failed'].includes(String(build.status))) return json({ ok: true, build });
      await this.env.DB.prepare('UPDATE builds SET status = ?, updated_at = ? WHERE id = ?').bind('running', now(), message.buildId).run();
      try {
        const manifest = JSON.parse(String(build.manifest_json)) as BuildManifest;
        let result: Record<string, unknown>;
        if (message.lane === 'extended-runtime') {
          if (!this.env.EXTENDED_RUNTIME_URL) throw new Error('extended runtime is not configured');
          const response = await fetch(`${this.env.EXTENDED_RUNTIME_URL.replace(/\/$/, '')}/v1/builds`, {
            method: 'POST', headers: { 'content-type': 'application/json' }, body: JSON.stringify({ buildId: message.buildId, manifest })
          });
          if (!response.ok) throw new Error(`extended runtime failed with ${response.status}`);
          result = await response.json<Record<string, unknown>>();
        } else {
          const artifact = JSON.stringify({ buildId: message.buildId, manifest, generatedAt: now(), lane: message.lane }, null, 2);
          const artifactKey = `builds/${message.projectId}/${message.buildId}/manifest.json`;
          await this.env.ARTIFACTS.put(artifactKey, artifact, { httpMetadata: { contentType: 'application/json' } });
          result = { artifactKey, deploymentUrl: null, status: 'artifact-ready' };
        }
        await this.env.DB.prepare('UPDATE builds SET status = ?, artifact_key = ?, deployment_url = ?, updated_at = ? WHERE id = ?')
          .bind('completed', result.artifactKey || null, result.deploymentUrl || null, now(), message.buildId).run();
        await audit(this.env, 'build-coordinator', 'build.completed', 'build', message.buildId, result);
        return json({ ok: true, result });
      } catch (error) {
        const messageText = error instanceof Error ? error.message : String(error);
        await this.env.DB.prepare('UPDATE builds SET status = ?, error_message = ?, updated_at = ? WHERE id = ?')
          .bind('failed', messageText, now(), message.buildId).run();
        await audit(this.env, 'build-coordinator', 'build.failed', 'build', message.buildId, { error: messageText });
        return json({ ok: false, error: messageText }, 500);
      }
    });
  }
}

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    const url = new URL(request.url);
    if (url.pathname.startsWith('/api/') || url.pathname.startsWith('/engine/')) return routeApi(request, env);
    return env.ASSETS.fetch(request);
  },
  async queue(batch: MessageBatch<BuildMessage>, env: Env): Promise<void> {
    for (const message of batch.messages) {
      try {
        const response = await executeBuild(env, message.body);
        if (!response.ok) throw new Error(`coordinator returned ${response.status}`);
        message.ack();
      } catch {
        message.retry();
      }
    }
  },
  async scheduled(_event: ScheduledEvent, env: Env): Promise<void> {
    const stale = await env.DB.prepare("SELECT id, project_id, runtime_lane FROM builds WHERE status = 'queued' AND created_at < datetime('now', '-2 minutes') LIMIT 25").all<Record<string, string>>();
    for (const build of stale.results || []) await env.BUILD_QUEUE.send({ buildId: build.id, projectId: build.project_id, lane: build.runtime_lane as RuntimeLane });
  },
} satisfies ExportedHandler<Env, BuildMessage>;
