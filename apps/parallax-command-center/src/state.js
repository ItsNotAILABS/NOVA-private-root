import crypto from 'node:crypto';
import fs from 'node:fs/promises';
import path from 'node:path';
import { config } from './config.js';

const now = () => new Date().toISOString();
const id = (prefix) => `${prefix}_${crypto.randomUUID().replaceAll('-', '').slice(0, 18)}`;
const hash = (value) => crypto.createHash('sha256').update(JSON.stringify(value)).digest('hex');

const seedState = () => ({
  schema: 'parallax.command-center.state.v1',
  created_at: now(),
  updated_at: now(),
  environment: 'local-paper-testnet',
  markets: [
    { symbol: 'BTC-USD', venue: 'public-market-data', status: 'watch', price: 64120.5, change: 1.82, volume: 920_400_000 },
    { symbol: 'ETH-USD', venue: 'public-market-data', status: 'watch', price: 3488.2, change: -0.44, volume: 481_300_000 },
    { symbol: 'ICP-USD', venue: 'public-market-data', status: 'watch', price: 9.42, change: 3.21, volume: 28_100_000 },
    { symbol: 'SOL-USD', venue: 'public-market-data', status: 'watch', price: 172.76, change: 0.95, volume: 305_700_000 }
  ],
  portfolio: {
    nav: 1_250_000,
    cash: 785_000,
    paper_pnl: 18_442.18,
    gross_exposure: 0.37,
    net_exposure: 0.12,
    positions: [
      { symbol: 'BTC-USD', side: 'long', quantity: 2.4, average: 62500, mark: 64120.5 },
      { symbol: 'ETH-USD', side: 'short', quantity: 38, average: 3522, mark: 3488.2 }
    ]
  },
  agents: [
    { id: 'agent_nova_hft', name: 'NOVA HFT', role: 'strategy-execution', status: 'ready', model: 'polyglot-runtime', risk: 'medium', capabilities: ['signal', 'backtest', 'paper-order'], created_at: now() },
    { id: 'agent_argos_clear', name: 'ARGOS-CLEAR', role: 'clearing-receipts', status: 'ready', model: 'policy-runtime', risk: 'low', capabilities: ['settlement', 'receipt', 'accounting'], created_at: now() },
    { id: 'agent_plax_sns', name: 'PLAX-SNS-GOV', role: 'token-governance', status: 'ready', model: 'governance-runtime', risk: 'high', capabilities: ['proposal', 'policy', 'notary-prep'], created_at: now() }
  ],
  strategies: [
    { id: 'strategy_momentum_alpha', name: 'Momentum Alpha', market: 'BTC-USD', timeframe: '15m', signal: 'ema-cross', risk_limit: 0.01, status: 'paper', created_at: now() },
    { id: 'strategy_mean_reversion', name: 'Mean Reversion Grid', market: 'ETH-USD', timeframe: '5m', signal: 'z-score', risk_limit: 0.008, status: 'paper', created_at: now() }
  ],
  workflows: [
    { id: 'workflow_signal_to_receipt', name: 'Signal to Receipt', status: 'active', stages: ['market-data', 'signal-agent', 'risk-gate', 'paper-order', 'clearing', 'receipt'], created_at: now() }
  ],
  orders: [],
  backtests: [],
  receipts: [],
  tokenomics: {
    PXAI: 0,
    PXGPU: 0,
    PXCRED: 0,
    PXBYTE: 0,
    PXNOVA: 0,
    PXRCPT: 0,
    PXTEAM: 0
  },
  governance: {
    mode: 'paper-testnet-internal-credit',
    human_approval_threshold_usd: 25_000,
    max_order_notional_usd: 100_000,
    max_strategy_risk_limit: 0.03,
    live_execution: false,
    custody: false,
    public_token_sale: false
  }
});

let state;

export async function ensureState() {
  await fs.mkdir(config.dataDir, { recursive: true });
  try {
    state = JSON.parse(await fs.readFile(config.stateFile, 'utf8'));
  } catch {
    state = seedState();
    await persist();
  }
  return state;
}

export function getState() {
  if (!state) throw new Error('state not initialized');
  return state;
}

export async function persist() {
  state.updated_at = now();
  const temp = `${config.stateFile}.tmp`;
  await fs.writeFile(temp, `${JSON.stringify(state, null, 2)}\n`, 'utf8');
  await fs.rename(temp, config.stateFile);
}

export async function mutate(type, payload, operation) {
  const result = await operation(state);
  const receipt = appendReceipt(type, payload, result);
  applyAccounting(payload, receipt, result);
  await persist();
  return { result, receipt, tokenomics: state.tokenomics };
}

function appendReceipt(type, input, output) {
  const previous = state.receipts.at(-1)?.hash || 'GENESIS';
  const body = {
    id: id('rcpt'),
    type,
    timestamp: now(),
    previous_hash: previous,
    input_hash: hash(input),
    output_hash: hash(output),
    environment: state.environment
  };
  body.hash = hash(body);
  state.receipts.push(body);
  state.tokenomics.PXRCPT += 1;
  state.tokenomics.PXCRED += 1;
  return body;
}

function applyAccounting(input, receipt, output) {
  const bytes = Buffer.byteLength(JSON.stringify({ input, output, receipt }), 'utf8');
  state.tokenomics.PXBYTE += bytes;
  state.tokenomics.PXNOVA += Math.max(1, Math.ceil(bytes / 1024));
  state.tokenomics.PXAI += 1;
}

export function createId(prefix) {
  return id(prefix);
}

export function verifyReceiptChain() {
  let previous = 'GENESIS';
  for (const receipt of state.receipts) {
    const { hash: stored, ...body } = receipt;
    if (body.previous_hash !== previous || hash(body) !== stored) return false;
    previous = stored;
  }
  return true;
}
