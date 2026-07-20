import assert from 'node:assert/strict';
import { spawn } from 'node:child_process';
import { setTimeout as sleep } from 'node:timers/promises';

const child = spawn(process.execPath, ['server.js'], { cwd: new URL('..', import.meta.url), env: { ...process.env, PARALLAX_PORT: '8941' }, stdio: 'pipe' });
try {
  await sleep(700);
  const base = 'http://127.0.0.1:8941';
  const health = await fetch(`${base}/api/health`).then(r => r.json());
  assert.equal(health.ok, true);
  const created = await fetch(`${base}/api/agents`, { method:'POST', headers:{'content-type':'application/json'}, body:JSON.stringify({ name:'Validator Agent', role:'research', capabilities:['signal'] }) }).then(r => r.json());
  assert.equal(created.ok, true);
  const denied = await fetch(`${base}/api/governance/evaluate`, { method:'POST', headers:{'content-type':'application/json'}, body:JSON.stringify({ action:'live-broker-route' }) }).then(r => r.json());
  assert.equal(denied.result.decision, 'deny');
  const state = await fetch(`${base}/api/state`).then(r => r.json());
  assert.ok(state.state.receipts.length >= 2);
  const index = await fetch(base).then(r => r.text());
  assert.ok(index.includes('PARALLAX Agentic Command Center'));
  console.log('OK: command center frontend, API, agent creation, governance denial, and receipts validated');
} finally { child.kill(); }
