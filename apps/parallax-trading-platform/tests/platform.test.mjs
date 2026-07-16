import test from 'node:test';
import assert from 'node:assert/strict';
import { spawn } from 'node:child_process';
import { setTimeout as sleep } from 'node:timers/promises';

const cwd = new URL('..', import.meta.url);
const env = { ...process.env, PARALLAX_PLATFORM_PORT:'8966', PARALLAX_TRADINGVIEW_TOKEN:'test-token', PARALLAX_DATA_DIR:`/tmp/parallax-platform-${Date.now()}` };

test('full PARALLAX trader workflow', async () => {
  const child = spawn(process.execPath, ['server.js'], { cwd, env, stdio:'ignore' });
  try {
    await sleep(700);
    const base='http://127.0.0.1:8966';
    const health=await fetch(`${base}/api/health`).then(r=>r.json());
    assert.equal(health.ok,true);
    assert.equal(health.receipt_chain_valid,true);
    const ui=await fetch(base).then(r=>r.text());
    assert.match(ui,/PARALLAX Trading Platform/);

    const strategy=await fetch(`${base}/api/strategies`,{method:'POST',headers:{'content-type':'application/json'},body:JSON.stringify({name:'E2E Strategy',symbol:'BTCUSD',timeframe:'15',status:'active',risk_limit:.01,default_notional:1200,mode:'paper'})}).then(r=>r.json());
    assert.equal(strategy.ok,true);

    const bot=await fetch(`${base}/api/bots`,{method:'POST',headers:{'content-type':'application/json'},body:JSON.stringify({name:'E2E Bot',strategy_id:strategy.result.id,trigger:'tradingview',status:'active',max_notional:2000,mode:'paper'})}).then(r=>r.json());
    assert.equal(bot.ok,true);

    const alertResponse=await fetch(`${base}/api/tradingview/webhook`,{method:'POST',headers:{'content-type':'application/json','x-parallax-webhook-token':'test-token'},body:JSON.stringify({alert_id:'e2e-alert',symbol:'BTCUSD',action:'buy',price:65000,notional:1000,strategy_id:strategy.result.id,bot_id:bot.result.id,timeframe:'15'})});
    assert.equal(alertResponse.status,201);
    const alert=await alertResponse.json();
    assert.equal(alert.ok,true);
    assert.equal(alert.result.status,'filled-paper');
    assert.ok(alert.receipt.hash);

    const bad=await fetch(`${base}/api/tradingview/webhook`,{method:'POST',headers:{'content-type':'application/json','x-parallax-webhook-token':'wrong'},body:JSON.stringify({symbol:'BTCUSD',action:'buy',price:65000})});
    assert.equal(bad.status,401);

    const wallet=await fetch(`${base}/api/wallets`,{method:'POST',headers:{'content-type':'application/json'},body:JSON.stringify({label:'Test Wallet',network:'ethereum',address:'0x1111111111111111111111111111111111111111',environment:'testnet'})}).then(r=>r.json());
    assert.equal(wallet.ok,true);

    const intent=await fetch(`${base}/api/wallets/intents`,{method:'POST',headers:{'content-type':'application/json'},body:JSON.stringify({wallet_id:wallet.result.id,asset:'USDC',amount:'25',destination:'0x2222222222222222222222222222222222222222',mode:'testnet'})}).then(r=>r.json());
    assert.equal(intent.result.status,'unsigned-human-approval-required');

    const receipts=await fetch(`${base}/api/receipts`).then(r=>r.json());
    assert.equal(receipts.valid,true);
    assert.ok(receipts.receipts.length>=4);
  } finally { child.kill(); }
});
