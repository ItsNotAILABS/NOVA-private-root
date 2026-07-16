import { createId } from './state.js';

const supportedNetworks = new Set(['ethereum','bitcoin','internet-computer','solana','polygon','arbitrum','base','testnet']);

export function registerWallet(input = {}) {
  const network = String(input.network || '').toLowerCase();
  if (!supportedNetworks.has(network)) throw new Error('unsupported wallet network');
  const address = String(input.address || '').trim();
  if (!address) throw new Error('wallet address is required');
  if (input.private_key || input.seed_phrase || input.mnemonic) throw new Error('private keys and seed phrases are never accepted');
  return {
    id: createId('wallet'),
    name: input.name || `${network} wallet`,
    network,
    address,
    account_type: input.account_type || 'external-non-custodial',
    environment: input.environment || 'testnet',
    permissions: Array.isArray(input.permissions) ? input.permissions : ['read-balances','prepare-transactions'],
    status: 'registered',
    created_at: new Date().toISOString()
  };
}

export function createTransactionIntent({ wallet, input, governance }) {
  if (!wallet) throw new Error('wallet not found');
  if (!['testnet','paper','internal-credit'].includes(input.mode || wallet.environment)) throw new Error('mainnet transaction submission is disabled');
  const amount = Number(input.amount || 0);
  if (!(amount > 0)) throw new Error('transaction amount must be positive');
  const destination = String(input.destination || '').trim();
  if (!destination) throw new Error('transaction destination is required');
  return {
    id: createId('txi'),
    wallet_id: wallet.id,
    network: wallet.network,
    destination,
    asset: input.asset || 'UNKNOWN',
    amount,
    mode: input.mode || wallet.environment,
    status: 'awaiting-external-signature',
    human_approval_required: true,
    live_submission_allowed: Boolean(governance?.wallet_live_submission) && false,
    unsigned_payload: input.unsigned_payload || null,
    created_at: new Date().toISOString()
  };
}
