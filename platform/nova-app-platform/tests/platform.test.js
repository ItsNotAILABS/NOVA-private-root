import assert from "node:assert/strict";
import fs from "node:fs";
import path from "node:path";
import { createNovaPlatform } from "../src/platform.js";
import { normalizeApp } from "../src/appRegistry.js";
import { createAuthGate, hashToken } from "../src/authGate.js";
import { gatewayStatus } from "../src/openaiGateway.js";

const platform = createNovaPlatform();
assert.equal(platform.status().name, "NOVA App Platform");
assert.ok(platform.listApps().length >= 3);

const app = normalizeApp({ id: "test-app", name: "Test App", description: "Test" });
assert.equal(app.id, "test-app");
assert.equal(app.enabled, true);

assert.throws(() => normalizeApp({ id: "Bad App", name: "Bad" }), /invalid_app_id/);

const gate = createAuthGate({ operatorToken: "secret" });
assert.equal(gate.authorize({ headers: { "x-nova-operator-token": "secret" } }).ok, true);
assert.equal(gate.authorize({ headers: { "x-nova-operator-token": "wrong" } }).ok, false);
assert.equal(hashToken("a").length, 64);

const status = gatewayStatus();
assert.equal(status.provider, "openai");
assert.equal(typeof status.configured, "boolean");

const publicDir = path.join(process.cwd(), "public");
assert.ok(fs.existsSync(path.join(publicDir, "index.html")));
assert.ok(fs.existsSync(path.join(publicDir, "app.js")));

console.log("NOVA app platform tests passed");
