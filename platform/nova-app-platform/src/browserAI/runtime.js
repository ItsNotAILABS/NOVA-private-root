import { BrowserNeuroCore } from "./neuroCore.js";
import { parseBrowserCommand, listBrowserAgents } from "./intentRouter.js";

const MAX_HISTORY = 200;
const MAX_MEMORY = 100;
const MAX_TEMPLE = 200;

export class BrowserAIRuntime {
  constructor({ name = "NOVA Browser AI" } = {}) {
    this.name = name;
    this.version = "0.1.0";
    this.startedAt = Date.now();
    this.neuro = new BrowserNeuroCore("nova-browser-ai");
    this.commandHistory = [];
    this.memory = [];
    this.temple = { research: [], theory: [], decisions: [], frameworks: [], insights: [] };
  }

  status() {
    this.neuro.pulse();
    return {
      schema: "nova-browser-ai-status-v0.1",
      name: this.name,
      version: this.version,
      uptimeMs: Date.now() - this.startedAt,
      agents: listBrowserAgents(),
      commandCount: this.commandHistory.length,
      memoryTurns: this.memory.length,
      templeStats: this.templeStats(),
      neuro: this.neuro.getState(),
      capabilities: this.capabilities()
    };
  }

  capabilities() {
    return [
      { id: "intent-routing", status: "active", boundary: "plans commands; execution stays behind browser/platform permission surfaces" },
      { id: "page-context", status: "active", boundary: "accepts explicit page snapshots only" },
      { id: "memory-temple", status: "active", boundary: "local runtime memory; no silent external write" },
      { id: "receipt-required-actions", status: "active", boundary: "write and AI routes must emit platform receipts" },
      { id: "openai-gateway", status: "server-side", boundary: "browser never receives OPENAI_API_KEY" }
    ];
  }

  command(input, context = {}) {
    const parsed = parseBrowserCommand(input);
    const action = this.buildAction(parsed, context);
    const record = {
      id: `browser_cmd_${Date.now()}_${this.commandHistory.length + 1}`,
      input: String(input || "").slice(0, 12000),
      parsed,
      action,
      contextSummary: summarizeContext(context),
      createdAt: new Date().toISOString()
    };
    this.neuro.observe(parsed.intent, { agent: parsed.agent.id, confidence: parsed.confidence });
    this.remember("operator", record.input, parsed.intent);
    this.commandHistory.unshift(record);
    if (this.commandHistory.length > MAX_HISTORY) this.commandHistory.pop();
    return record;
  }

  buildAction(parsed, context = {}) {
    const base = { type: parsed.intent, agent: parsed.agent, payload: {}, requiresReceipt: true, executableInBrowserExtension: true };
    switch (parsed.intent) {
      case "open-url": base.payload.url = parsed.params.url || ""; break;
      case "tab-switch": base.payload.tabIndex = parsed.params.tabIndex || 1; break;
      case "tab-open": base.payload.url = parsed.params.url || "chrome://newtab"; break;
      case "tab-close": base.payload.tabIndex = parsed.params.tabIndex || null; break;
      case "search": base.payload.query = parsed.params.query || parsed.raw; break;
      case "find-text":
      case "highlight": base.payload.query = parsed.params.query || ""; break;
      case "take-note": base.payload.note = parsed.params.note || parsed.raw; break;
      case "read-page":
      case "summarize": base.payload.page = summarizePage(context.page || {}); break;
      case "create-document":
      case "create-pdf": base.payload.title = parsed.params.title || "Browser Document"; base.payload.source = parsed.raw; break;
      case "screenshot": base.payload.format = "png"; break;
      default: base.payload.message = parsed.raw;
    }
    base.plan = this.planFor(base, context);
    return base;
  }

  planFor(action, context = {}) {
    const page = summarizePage(context.page || {});
    const steps = [];
    steps.push({ id: "observe", label: "Observe current browser/page context", done: Boolean(page.title || page.url) });
    steps.push({ id: "route", label: `Route intent through ${action.agent.name}`, done: true });
    if (["read-page", "summarize"].includes(action.type)) steps.push({ id: "compress", label: "Compress page text into operator-safe summary", done: Boolean(page.wordCount || page.textSample) });
    if (["open-url", "tab-open", "tab-close", "tab-switch", "screenshot", "highlight"].includes(action.type)) steps.push({ id: "permission", label: "Require browser extension/user execution permission", done: false });
    steps.push({ id: "receipt", label: "Emit platform receipt for command/action", done: false });
    return { schema: "nova-browser-ai-plan-v0.1", steps };
  }

  ingestPage(page = {}) {
    const summary = summarizePage(page);
    this.neuro.observe("page-context", { url: summary.url, words: summary.wordCount });
    this.remember("page", `${summary.title} ${summary.url} ${summary.textSample}`, "page-context");
    return { ok: true, page: summary, neuro: this.neuro.getState() };
  }

  remember(role, text, intent = "chat") {
    const entry = { role, text: String(text || "").slice(0, 1000), intent, createdAt: new Date().toISOString() };
    this.memory.push(entry);
    if (this.memory.length > MAX_MEMORY) this.memory.shift();
    const cat = categorize(entry.text, intent);
    this.temple[cat].unshift(entry);
    if (this.temple[cat].length > MAX_TEMPLE) this.temple[cat].pop();
    return entry;
  }

  templeStats() {
    const stats = {};
    let total = 0;
    for (const key of Object.keys(this.temple)) { stats[key] = this.temple[key].length; total += stats[key]; }
    return { total, stats };
  }

  history({ limit = 25 } = {}) {
    return this.commandHistory.slice(0, Math.min(Number(limit) || 25, MAX_HISTORY));
  }
}

export const browserAI = new BrowserAIRuntime();

export function summarizePage(page = {}) {
  const text = String(page.text || page.bodyText || "");
  return {
    title: String(page.title || "").slice(0, 200),
    url: String(page.url || "").slice(0, 500),
    wordCount: Number(page.wordCount || (text ? text.split(/\s+/).filter(Boolean).length : 0)),
    headingCount: Array.isArray(page.headings) ? page.headings.length : 0,
    linkCount: Number(page.linkCount || 0),
    imageCount: Number(page.imageCount || 0),
    textSample: text.slice(0, 1500)
  };
}

function summarizeContext(context = {}) {
  return { hasPage: Boolean(context.page), page: context.page ? summarizePage(context.page) : null, source: context.source || "operator" };
}

function categorize(text, intent) {
  const value = `${intent} ${text}`.toLowerCase();
  if (/research|paper|study|source|analysis|reference/.test(value)) return "research";
  if (/framework|architecture|workflow|system|process|structure/.test(value)) return "frameworks";
  if (/decide|decision|build|implement|ship|merge|create/.test(value)) return "decisions";
  if (/theory|model|principle|concept|hypothesis/.test(value)) return "theory";
  return "insights";
}
