#!/usr/bin/env node
import readline from 'node:readline';

const baseUrl = process.env.PARALLAX_URL || 'http://127.0.0.1:8940';

const tools = [
  { name:'parallax_health', description:'Read PARALLAX platform health and receipt-chain state.', inputSchema:{ type:'object', properties:{} } },
  { name:'list_agents', description:'List PARALLAX agents.', inputSchema:{ type:'object', properties:{} } },
  { name:'create_bot', description:'Create a governed paper-trading bot.', inputSchema:{ type:'object', required:['name'], properties:{ name:{type:'string'}, trigger:{type:'string'}, strategy_id:{type:'string'}, symbols:{type:'array',items:{type:'string'}}, default_notional:{type:'number'}, actions:{type:'array',items:{type:'string'}} } } },
  { name:'run_automation', description:'Run a strategy through signal, risk, paper-order, clearing, and receipt stages.', inputSchema:{ type:'object', properties:{ strategy_id:{type:'string'}, symbol:{type:'string'}, notional:{type:'number'} } } },
  { name:'register_wallet', description:'Register a public wallet address without accepting private keys.', inputSchema:{ type:'object', required:['network','address'], properties:{ name:{type:'string'}, network:{type:'string'}, address:{type:'string'}, environment:{type:'string'} } } },
  { name:'create_wallet_intent', description:'Prepare a testnet or paper transaction intent for external signing.', inputSchema:{ type:'object', required:['wallet_id','destination','asset','amount'], properties:{ wallet_id:{type:'string'}, destination:{type:'string'}, asset:{type:'string'}, amount:{type:'number'}, mode:{type:'string'} } } },
  { name:'ecosystem_status', description:'Probe configured PARALLAX sibling runtimes.', inputSchema:{ type:'object', properties:{} } }
];

async function api(path, options = {}) {
  const response = await fetch(`${baseUrl}${path}`, { headers:{'content-type':'application/json', ...(options.headers || {})}, ...options });
  const text = await response.text();
  let data;
  try { data = JSON.parse(text); } catch { data = { raw:text }; }
  if (!response.ok) throw new Error(data.error || `HTTP ${response.status}`);
  return data;
}

async function callTool(name, args) {
  switch (name) {
    case 'parallax_health': return api('/api/health');
    case 'list_agents': return api('/api/agents');
    case 'create_bot': return api('/api/bots', { method:'POST', body:JSON.stringify({ ...args, mode:'paper' }) });
    case 'run_automation': return api('/api/automation/run', { method:'POST', body:JSON.stringify({ ...args, mode:'paper' }) });
    case 'register_wallet': return api('/api/wallets', { method:'POST', body:JSON.stringify(args) });
    case 'create_wallet_intent': return api('/api/wallets/intents', { method:'POST', body:JSON.stringify(args) });
    case 'ecosystem_status': return api('/api/ecosystem/status');
    default: throw new Error(`unknown tool: ${name}`);
  }
}

const rl = readline.createInterface({ input:process.stdin, crlfDelay:Infinity });
for await (const line of rl) {
  if (!line.trim()) continue;
  let request;
  try {
    request = JSON.parse(line);
    let result;
    if (request.method === 'initialize') {
      result = { protocolVersion:'2025-03-26', capabilities:{ tools:{} }, serverInfo:{ name:'parallax-mcp', version:'0.1.0' } };
    } else if (request.method === 'notifications/initialized') {
      continue;
    } else if (request.method === 'tools/list') {
      result = { tools };
    } else if (request.method === 'tools/call') {
      const output = await callTool(request.params?.name, request.params?.arguments || {});
      result = { content:[{ type:'text', text:JSON.stringify(output, null, 2) }] };
    } else {
      throw new Error(`unsupported method: ${request.method}`);
    }
    process.stdout.write(`${JSON.stringify({ jsonrpc:'2.0', id:request.id, result })}\n`);
  } catch (error) {
    process.stdout.write(`${JSON.stringify({ jsonrpc:'2.0', id:request?.id ?? null, error:{ code:-32000, message:error.message } })}\n`);
  }
}
