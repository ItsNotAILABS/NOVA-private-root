import fs from 'node:fs';
import path from 'node:path';
import crypto from 'node:crypto';

export function sha256(value) {
  return crypto.createHash('sha256').update(JSON.stringify(value)).digest('hex');
}

export class PlatformVault {
  constructor(rootDir = process.env.NOVA_PLATFORM_VAULT || path.join(process.cwd(), '.nova-platform-vault')) {
    this.rootDir = rootDir;
    this.stateFile = path.join(rootDir, 'state.json');
    this.receiptFile = path.join(rootDir, 'receipts.jsonl');
  }

  ensure() {
    fs.mkdirSync(this.rootDir, { recursive: true });
  }

  defaultState() {
    return {
      schema: 'nova-app-platform-state-v0.1',
      createdAt: new Date().toISOString(),
      sessions: [],
      apps: [],
      events: []
    };
  }

  load() {
    this.ensure();
    if (!fs.existsSync(this.stateFile)) return this.defaultState();
    const envelope = JSON.parse(fs.readFileSync(this.stateFile, 'utf8'));
    if (sha256(envelope.state) !== envelope.stateHash) throw new Error('NOVA platform state hash mismatch');
    return envelope.state;
  }

  save(state) {
    this.ensure();
    const envelope = { schema: 'nova-app-platform-envelope-v0.1', savedAt: new Date().toISOString(), state, stateHash: sha256(state) };
    const tmp = `${this.stateFile}.tmp`;
    fs.writeFileSync(tmp, JSON.stringify(envelope, null, 2));
    fs.renameSync(tmp, this.stateFile);
    const receipt = this.receipt('state_saved', { stateHash: envelope.stateHash, stateFile: this.stateFile });
    fs.appendFileSync(this.receiptFile, JSON.stringify(receipt) + '\n');
    return { envelope, receipt };
  }

  receipt(type, payload) {
    const receipt = { type, timestamp: new Date().toISOString(), payload };
    receipt.hash = sha256(receipt);
    return receipt;
  }

  listReceipts() {
    this.ensure();
    if (!fs.existsSync(this.receiptFile)) return [];
    return fs.readFileSync(this.receiptFile, 'utf8').trim().split('\n').filter(Boolean).map((line) => JSON.parse(line));
  }
}
