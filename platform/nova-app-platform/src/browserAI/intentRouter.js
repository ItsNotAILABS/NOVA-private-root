export const BROWSER_AGENTS = [
  { id: "protocollum", name: "PROTOCOLLUM", domain: "Protocol governance, safety boundaries, receipts, and rule enforcement" },
  { id: "terminalis", name: "TERMINALIS", domain: "Browser navigation, tabs, focus, URL opening, and operator command routing" },
  { id: "organismus", name: "ORGANISMUS", domain: "Memory, notes, continuity, longitudinal browser state, and local organism lifecycle" },
  { id: "orchestrator", name: "ORCHESTRATOR", domain: "Multi-step browser AI planning and task sequencing" },
  { id: "synapticus", name: "SYNAPTICUS", domain: "Page reading, summarization, extraction, and semantic compression" },
  { id: "substratum", name: "SUBSTRATUM", domain: "Screenshots, permissions, platform substrate, and browser capability checks" },
  { id: "universum", name: "UNIVERSUM", domain: "Search, page find, knowledge graph, and cross-page context" },
  { id: "canistrum", name: "CANISTRUM", domain: "Deployment, capsules, exports, and app publishing lanes" }
];

const INTENT_RULES = [
  { intent: "tab-switch", keywords: ["switch tab", "go to tab", "activate tab", "change tab", "focus tab"] },
  { intent: "tab-open", keywords: ["new tab", "open tab", "create tab", "add tab"] },
  { intent: "tab-close", keywords: ["close tab", "kill tab", "remove tab", "shut tab"] },
  { intent: "open-url", keywords: ["open url", "go to", "navigate to", "visit", "browse to", "open site", "open page"] },
  { intent: "read-page", keywords: ["read page", "read this", "get content", "page content", "extract text", "get text"] },
  { intent: "summarize", keywords: ["summarize", "summary", "tldr", "brief", "overview", "digest"] },
  { intent: "search", keywords: ["search", "look up", "find online", "query", "research"] },
  { intent: "find-text", keywords: ["find text", "find on page", "search page", "ctrl f", "locate text", "find"] },
  { intent: "highlight", keywords: ["highlight", "mark", "emphasize", "underline"] },
  { intent: "take-note", keywords: ["take note", "save note", "add note", "write note", "remember", "note this", "jot down"] },
  { intent: "list-notes", keywords: ["list notes", "show notes", "my notes", "all notes", "view notes", "get notes"] },
  { intent: "create-document", keywords: ["create document", "new document", "make document", "write document", "draft"] },
  { intent: "create-pdf", keywords: ["create pdf", "generate pdf", "make pdf", "export pdf", "save pdf", "pdf"] },
  { intent: "screenshot", keywords: ["screenshot", "screen capture", "capture screen", "snap", "take screenshot", "grab screen"] },
  { intent: "browser-plan", keywords: ["plan", "browser plan", "do this", "workflow", "steps", "automation"] },
  { intent: "chat", keywords: ["chat", "talk", "tell me", "hey nova", "jarvis", "hello", "help"] }
];

const AGENT_BY_INTENT = {
  "tab-switch": "terminalis",
  "tab-open": "terminalis",
  "tab-close": "terminalis",
  "open-url": "terminalis",
  "read-page": "synapticus",
  summarize: "synapticus",
  search: "universum",
  "find-text": "universum",
  highlight: "universum",
  "take-note": "organismus",
  "list-notes": "organismus",
  "create-document": "protocollum",
  "create-pdf": "protocollum",
  screenshot: "substratum",
  "browser-plan": "orchestrator",
  chat: "orchestrator"
};

export function listBrowserAgents() {
  return BROWSER_AGENTS.map((agent) => ({ ...agent }));
}

export function routeAgent(intent) {
  const id = AGENT_BY_INTENT[intent] || "orchestrator";
  return BROWSER_AGENTS.find((agent) => agent.id === id) || BROWSER_AGENTS[3];
}

export function parseBrowserCommand(input = "") {
  const raw = String(input || "").slice(0, 12000);
  const text = raw.toLowerCase().trim();
  const tokens = text.split(/\s+/).filter(Boolean);
  let intent = "chat";
  let confidence = 0.3;
  const matchedKeywords = [];
  const params = {};

  for (const rule of INTENT_RULES) {
    const keyword = rule.keywords.find((kw) => text.includes(kw));
    if (keyword) {
      intent = rule.intent;
      confidence = Math.min(0.98, 0.7 + keyword.length / Math.max(text.length, 1) * 0.3);
      matchedKeywords.push(keyword);
      break;
    }
  }

  const urlMatch = text.match(/(?:https?:\/\/[^\s]+|www\.[^\s]+|[a-z0-9-]+\.[a-z]{2,}(?:\/[^\s]*)?)/i);
  if (urlMatch) {
    params.url = urlMatch[0].startsWith("http") ? urlMatch[0] : `https://${urlMatch[0]}`;
    if (intent === "chat") {
      intent = "open-url";
      confidence = 0.8;
    }
  }

  const tabMatch = text.match(/tab\s*(?:#?\s*)?(\d+)/);
  if (tabMatch) params.tabIndex = Number(tabMatch[1]);

  if (intent === "search") params.query = stripLead(text, ["search for", "search", "look up", "find online", "query", "research"]);
  if (intent === "find-text" || intent === "highlight") params.query = stripLead(text, ["find text", "find on page", "search page", "locate text", "find", "highlight", "mark"]);
  if (intent === "take-note") params.note = stripLead(raw, ["take note", "save note", "add note", "write note", "remember", "note this", "jot down"]);
  if (intent === "create-document" || intent === "create-pdf") params.title = stripLead(text, ["create document", "new document", "make document", "write document", "draft", "create pdf", "generate pdf", "make pdf", "export pdf"]) || "Untitled Browser Document";

  const agent = routeAgent(intent);
  return {
    raw,
    intent,
    confidence: Math.round(confidence * 100) / 100,
    matchedKeywords,
    params,
    tokens,
    agent,
    createdAt: new Date().toISOString()
  };
}

function stripLead(value, prefixes) {
  let out = String(value || "").trim();
  const lc = out.toLowerCase();
  for (const prefix of prefixes) {
    const idx = lc.indexOf(prefix);
    if (idx !== -1) {
      out = out.slice(idx + prefix.length).trim();
      break;
    }
  }
  return out.replace(/^[:–\-]\s*/, "").trim();
}
