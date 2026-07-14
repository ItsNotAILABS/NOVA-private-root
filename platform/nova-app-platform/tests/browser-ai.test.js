import assert from "node:assert/strict";
import { BrowserAIRuntime } from "../src/browserAI/runtime.js";
import { parseBrowserCommand, routeAgent, listBrowserAgents } from "../src/browserAI/intentRouter.js";
import { BrowserNeuroCore } from "../src/browserAI/neuroCore.js";

const parsed = parseBrowserCommand("summarize this page and save a note");
assert.equal(parsed.intent, "summarize");
assert.equal(parsed.agent.id, "synapticus");
assert.ok(parsed.confidence > 0.5);

assert.equal(routeAgent("open-url").id, "terminalis");
assert.ok(listBrowserAgents().length >= 8);

const neuro = new BrowserNeuroCore();
neuro.observe("read-page", { url: "https://example.test" });
neuro.pulse();
assert.ok(neuro.getState().heart.messages >= 1);
assert.ok(neuro.getState().brain.pathways >= 1);

const runtime = new BrowserAIRuntime();
const command = runtime.command("open github.com in a new tab", { page: { title: "Home", url: "https://local.test", text: "hello world" } });
assert.equal(command.parsed.intent, "tab-open");
assert.equal(command.action.agent.id, "terminalis");
assert.ok(command.action.plan.steps.some((step) => step.id === "receipt"));

const page = runtime.ingestPage({ title: "Browser AI", url: "https://nova.local", text: "NOVA browser AI first class runtime", linkCount: 1 });
assert.equal(page.ok, true);
assert.equal(page.page.wordCount, 6);
assert.ok(runtime.status().templeStats.total >= 1);
assert.ok(runtime.history().length >= 1);

console.log("NOVA browser AI tests passed");
