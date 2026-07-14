import { BrowserNeuroCore } from "./neuroCore.js";
import { parseBrowserCommand, listBrowserAgents } from "./intentRouter.js";

const MAX_HISTORY = 200;
const MAX_MEMORY = 100;
const MAX_TEMPLE_ENTRIES = 200;

export class BrowserAIRuntime {
  constructor({ name = "NOVA Browser AI" } = {}) {
    this.name = name;
    this.version = "0.1.0";
    this.startedAt = Date.now();
    this.neuro = new BrowserNeuroCore("nova-browser-ai");
    this.commandHistory = [];
    this