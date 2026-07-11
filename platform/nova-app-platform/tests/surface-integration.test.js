import assert from "node:assert/strict";
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { surfaceRegistry, launchContract, listSurfaces } from "../src/surfaceLinks.js";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const appRoot = path.resolve(__dirname, "..");

const registry = surfaceRegistry();
assert.equal(registry.schema, "nova-platform-surface-contract-v0.1");
assert.equal(registry.boundary.browserReceivesOpenAIKey, false);
assert.equal(registry.boundary.writeRoutesRequireOperatorToken, true);
assert.ok(listSurfaces().some((surface) => surface.id === "nova-phone"));
assert.ok(listSurfaces().some((surface) => surface.id === "capsule-studio"));

const phone = launchContract("nova-phone");
assert.equal(phone.surface.id, "nova-phone");
assert.ok(phone.bridgeScript.includes("platform-bridge.js"));

const capsule = launchContract("capsule-studio");
assert.equal(capsule.surface.id, "capsule-studio");
assert.ok(capsule.requiredEnv.includes("NOVA_OPERATOR_TOKEN"));

assert.equal(launchContract("missing"), null);

const publicDir = path.join(appRoot, "public");
assert.ok(fs.existsSync(path.join(publicDir, "platform-bridge.js")));
assert.ok(fs.existsSync(path.join(publicDir, "surfaces.html")));

console.log("NOVA surface integration tests passed");
