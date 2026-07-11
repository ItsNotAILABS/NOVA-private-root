import assert from "node:assert/strict";
import fs from "node:fs";
import os from "node:os";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { createNovaPlatform } from "../src/platform.js";
import { normalizeApp } from "../src/appRegistry.js";
import { createAuthGate, hashToken } from "../src/authGate.js";
import { gatewayStatus, sanitizeInput, normalizeModel } from "../src/openaiGateway.js";
import { appendRecord, readRecords, verifyRecordChain } from "../src/storage.js";
import { writeReceipt, listReceipts, receiptChainStatus } from "../src/receipts.js";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const appRoot = path.resolve(__dirname, "..");
process.env.NOVA_PLATFORM_VAULT = fs.mkdtempSync(path.join(os.tmpdir(), "nova-platform-test-"));

const platform = createNovaPlatform();
assert.equal(platform.status().name, "NOVA App Platform");
assert.ok(platform.listApps().length >= 5);

const app = normalizeApp({ id: "test-app", name: "Test App", description: "Test" });
assert.equal(app.id, "test-app");
assert.equal(app.enabled, true);
assert.throws(() => normalizeApp({ id: "Bad App", name: "Bad" }), /invalid_app_id/);

const gate = createAuthGate({ operatorToken: "secret", sessionTtlMs: 1000 * 60 });
assert.equal(gate.authorize({ headers: { "x-nova-operator-token": "secret" } }).ok, true);
assert.equal(gate.authorize({ headers: { "x-nova-operator-token": "wrong" } }).ok, false);
const session = gate.createSession({ token: "secret", label: "test-operator" });
assert.equal(session.ok, true);
assert.equal(gate.authorize({ headers: { authorization: `Bearer ${session.session.id}` } }).ok, true);
assert.equal(hashToken("a").length, 64);

const status = gatewayStatus();
assert.equal(status.provider, "openai");
assert.equal(typeof status.configured, "boolean");
assert.equal(status.keyExposedToBrowser, false);
assert.equal(sanitizeInput(" hello "), " hello ");
assert.equal(normalizeModel("gpt-5.5"), "gpt-5.5");
assert.throws(() => normalizeModel("bad model with spaces"), /invalid_model/);

await appendRecord("events", { type: "one" });
await appendRecord("events", { type: "two" });
const events = await readRecords("events");
assert.equal(events.length, 2);
assert.equal(verifyRecordChain(events).ok, true);

const receipt = await writeReceipt("test_event", { ok: true }, { operator: "test" });
assert.equal(receipt.schema, "nova-platform-receipt-v0.2");
assert.equal((await listReceipts()).length, 1);
assert.equal((await receiptChainStatus()).ok, true);

const publicDir = path.join(appRoot, "public");
assert.ok(fs.existsSync(path.join(publicDir, "index.html")));
assert.ok(fs.existsSync(path.join(publicDir, "app.js")));
assert.ok(fs.existsSync(path.join(publicDir, "platform-bridge.js")));

console.log("NOVA app platform tests passed");
