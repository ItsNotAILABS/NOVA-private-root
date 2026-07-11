import { config } from './config.js';
import { createWorkspace } from './workspaceStore.js';
import { deployLocal } from './deployment.js';
import { callOpenAIJson, openAiStatus } from './openaiClient.js';
import { writeAudit } from './auditLog.js';
import { getTemplate } from './templateCatalog.js';

function boundedPrompt(prompt) {
  const value = String(prompt || '').trim();
  if (!value) throw new Error('prompt is required');
  if (value.length > config.maxPromptLength) throw new Error(`prompt is too long; max ${config.maxPromptLength} chars`);
  return value;
}

function fallbackApp(prompt, reason = 'OpenAI unavailable') {
  const title = prompt.slice(0, 72) || 'NOVA Generated App';
  const files = getTemplate('web').files(title);
  files['app.js'] += `\nconst note=document.createElement('p');note.textContent=${JSON.stringify(reason)};document.querySelector('main')?.appendChild(note);\n`;
  return {
    title,
    summary: `Generated with local fallback. ${reason}`,
    files
  };
}

function normalizeGeneratedApp(payload, prompt) {
  const app = payload && typeof payload === 'object' ? payload : fallbackApp(prompt, 'invalid model payload');
  const files = app.files && typeof app.files === 'object' ? app.files : {};
  if (!files['index.html']) throw new Error('generated app missing index.html');
  if (!files['styles.css']) files['styles.css'] = 'body{font-family:system-ui;margin:40px}';
  if (!files['app.js']) files['app.js'] = "console.log('generated app live');\n";
  return {
    title: String(app.title || prompt).slice(0, 80),
    summary: String(app.summary || 'Generated app'),
    files: {
      'index.html': String(files['index.html']),
      'styles.css': String(files['styles.css']),
      'app.js': String(files['app.js'])
    }
  };
}

export async function buildAiApp({ prompt, mode = 'web-app' } = {}) {
  const cleanPrompt = boundedPrompt(prompt);
  const system = [
    'You are NOVA Capsule Studio App Builder.',
    'Return strict JSON only.',
    'Schema: {"title":"...","summary":"...","files":{"index.html":"...","styles.css":"...","app.js":"..."}}.',
    'Build polished complete browser apps only.',
    'No markdown, no commentary, no external assets required.'
  ].join(' ');
  let generated;
  let source = 'openai';
  try {
    const payload = await callOpenAIJson({ system, prompt: `Mode: ${mode}\nRequest: ${cleanPrompt}` });
    generated = normalizeGeneratedApp(payload, cleanPrompt);
  } catch (error) {
    generated = fallbackApp(cleanPrompt, error.message);
    source = 'local-fallback';
  }
  const workspace = await createWorkspace({ name: generated.title, template: 'web', files: generated.files, source, metadata: { prompt: cleanPrompt, mode } });
  const deployment = await deployLocal(workspace.id);
  await writeAudit('ai.app.built', { workspaceId: workspace.id, source, title: generated.title, mode });
  return {
    ok: true,
    ai: openAiStatus(),
    workspace,
    deployment,
    generated: { title: generated.title, summary: generated.summary, source }
  };
}

export async function explainWorkspace({ workspaceId, files = [] } = {}) {
  return {
    ok: true,
    workspaceId,
    summary: `Workspace ${workspaceId} contains ${files.length} visible source files.`,
    recommendations: [
      'Preview the entry file first.',
      'Generate a manifest before deployment.',
      'Use local deploy for browser-visible demos.',
      'Keep OPENAI_API_KEY on the server only.'
    ]
  };
}
