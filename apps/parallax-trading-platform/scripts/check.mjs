import fs from 'node:fs/promises';

const required = [
  'server.js','src/config.js','src/store.js','src/security.js','src/tradingEngine.js','src/router.js',
  'public/index.html','public/styles.css','public/app.js','tests/platform.test.mjs','README.md'
];
for (const file of required) await fs.access(new URL(`../${file}`, import.meta.url));
const app = await fs.readFile(new URL('../public/app.js', import.meta.url), 'utf8');
for (const marker of ['TradingView','Create Bot','Register Wallet','Receipt Ledger']) {
  if (!app.includes(marker)) throw new Error(`missing frontend marker: ${marker}`);
}
const router = await fs.readFile(new URL('../src/router.js', import.meta.url), 'utf8');
for (const marker of ['/api/tradingview/webhook','/api/bots','/api/wallets','/api/orders/']) {
  if (!router.includes(marker)) throw new Error(`missing API marker: ${marker}`);
}
console.log('PARALLAX platform integrity check passed');
