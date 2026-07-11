import fs from 'node:fs';
import path from 'node:path';
import { sha256 } from './platform.js';

export class PlatformVault {
  constructor(rootDir = process.env.NOVA_PLATFORM_VAULT || path.join(process.cwd(), '.nova-platform-vault')) {
    this.rootDir = rootDir;
    this.stateFile = path.join(rootDir, 'platform-state.json');
    this.receiptsFile = path.join(rootDir, 'receipts.jsonl');
  }

  ensure() {
    fs.mkdirSync(this.rootDir, { recursive: true });
  }

  saveState(state) {
    this.ensure();
    const envelope = {
      schema: 'nova-app-platform-envelope-v0.1',
      savedAt: new Date().toISOString(),
      state,
      stateHash: sha256(state)
    };
    const tmp = `${this.stateFile}.tmp`;
    fs.writeFileSync(tmp, JSON.stringify(envelope, null, 2));
    fs.renameSync(tmp, this.stateFile);
    const receipt = this.writeReceipt('platform_state_saved', { stateHash: envelope.stateHash });
    return { envelope, receipt };
  }

  loadState() {
    this.ensure();
    if (!fs.existsSync(this.stateFile)) return null;
    const envelope = JSON.parse(fs.readFileSync(this.stateFile, 'utf8'));
    const actual = sha256(envelope.state);
    if (actual !== envelope.stateHash) throw new Error('platform state hash mismatch');
    return envelope;
  }

  writeReceipt(type, payload = {}) {
    this.ensure();
    const receipt = { type, timestamp: new Date().toISOString(), payload };
    receipt.hash = sha256(receipt);
    fs.appendFileSync(this.receiptsFile, JSON.stringify(receipt) + '\n');
    return receipt;
  }

  listReceipts() {
    this.ensure();
    if (!fs.existsSync(this.receiptsFile)) return [];
    return fs.readFileSync(this.receiptsFile, 'utf8').split('\n').filter(Boolean).map((line) => JSON.parse(line));
  }
}
