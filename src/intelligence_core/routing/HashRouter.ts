// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// HASH ROUTING — Sovereign Hash-Based Navigation (BUILD №48)
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// Hash routing for the NOVA organism. This is NOT frontend routing — this is
// intelligent routing through the organism's internal pathways.
//
// Routes:
//   #/organism/{id}               — Access organism by ID
//   #/agent/{id}                  — Access agent by ID
//   #/domain/{domainId}           — Access knowledge domain
//   #/state/{stateCode}           — Access state system adapter
//   #/compute/{operation}         — Trigger computation
//   #/stream/{topic}              — Subscribe to stream topic
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

import { PHI, PHI_INV } from '../../frontend/src/math/core';
import { COREOGRAPH, Message } from '../engines/COREOGRAPH';
import { NEXORIS } from '../engines/NEXORIS';

// ═══════════════════════════════════════════════════════════════════════════════
// §1 — ROUTE TYPES
// ═══════════════════════════════════════════════════════════════════════════════

export type RouteType = 
  | 'ORGANISM'
  | 'AGENT'
  | 'DOMAIN'
  | 'STATE'
  | 'COMPUTE'
  | 'STREAM'
  | 'ENGINE'
  | 'ADAPTER'
  | 'KNOWLEDGE'
  | 'RUNTIME';

export interface ParsedRoute {
  type: RouteType;
  path: string;
  id: string;
  params: Record<string, string>;
  hash: string;
  valid: boolean;
}

export interface RouteHandler {
  pattern: RegExp;
  type: RouteType;
  handler: (route: ParsedRoute) => Promise<RouteResult>;
}

export interface RouteResult {
  success: boolean;
  data: unknown;
  error?: string;
  routedTo: string;
  latencyMs: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// §2 — HASH ROUTER
// ═══════════════════════════════════════════════════════════════════════════════

export class HashRouter {
  private handlers: RouteHandler[] = [];
  private history: ParsedRoute[] = [];
  private subscribers: Map<string, (route: ParsedRoute) => void> = new Map();

  constructor() {
    this._registerDefaultHandlers();
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // ROUTE PARSING
  // ─────────────────────────────────────────────────────────────────────────────

  parse(hash: string): ParsedRoute {
    // Remove leading # if present
    const cleanHash = hash.startsWith('#') ? hash.slice(1) : hash;
    
    // Split into path and query
    const [path, queryString] = cleanHash.split('?');
    const params: Record<string, string> = {};
    
    if (queryString) {
      for (const pair of queryString.split('&')) {
        const [key, value] = pair.split('=');
        if (key) params[key] = decodeURIComponent(value ?? '');
      }
    }

    // Match against patterns
    for (const handler of this.handlers) {
      const match = path?.match(handler.pattern);
      if (match) {
        return {
          type: handler.type,
          path: path ?? '',
          id: match[1] ?? '',
          params,
          hash,
          valid: true,
        };
      }
    }

    return {
      type: 'ORGANISM',
      path: path ?? '',
      id: '',
      params,
      hash,
      valid: false,
    };
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // ROUTING
  // ─────────────────────────────────────────────────────────────────────────────

  async route(hash: string): Promise<RouteResult> {
    const start = Date.now();
    const parsed = this.parse(hash);
    
    // Record in history
    this.history.push(parsed);
    if (this.history.length > 100) {
      this.history.shift();
    }

    // Store in NEXORIS
    NEXORIS.set('router:currentRoute', hash);
    NEXORIS.set('router:lastRouteAt', Date.now());

    // Notify subscribers
    for (const [_id, callback] of this.subscribers) {
      callback(parsed);
    }

    // Find and execute handler
    for (const handler of this.handlers) {
      if (parsed.type === handler.type && parsed.valid) {
        try {
          const result = await handler.handler(parsed);
          return {
            ...result,
            latencyMs: Date.now() - start,
          };
        } catch (e) {
          return {
            success: false,
            data: null,
            error: e instanceof Error ? e.message : 'Unknown error',
            routedTo: parsed.type,
            latencyMs: Date.now() - start,
          };
        }
      }
    }

    return {
      success: false,
      data: null,
      error: 'No handler found',
      routedTo: 'UNKNOWN',
      latencyMs: Date.now() - start,
    };
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // HANDLER REGISTRATION
  // ─────────────────────────────────────────────────────────────────────────────

  register(
    pattern: RegExp,
    type: RouteType,
    handler: (route: ParsedRoute) => Promise<RouteResult>
  ): void {
    this.handlers.push({ pattern, type, handler });
  }

  private _registerDefaultHandlers(): void {
    // #/organism/{id}
    this.register(
      /^\/organism\/(.+)$/,
      'ORGANISM',
      async (route) => {
        COREOGRAPH.broadcast('ROUTE:ORGANISM', 'ROUTER', { organismId: route.id });
        return {
          success: true,
          data: { organismId: route.id },
          routedTo: 'ORGANISM',
          latencyMs: 0,
        };
      }
    );

    // #/agent/{id}
    this.register(
      /^\/agent\/(.+)$/,
      'AGENT',
      async (route) => {
        const status = COREOGRAPH.getAgentStatus(route.id);
        COREOGRAPH.send('ROUTE:AGENT', 'ROUTER', route.id, { agentId: route.id });
        return {
          success: !!status,
          data: { agentId: route.id, status },
          routedTo: 'AGENT',
          latencyMs: 0,
        };
      }
    );

    // #/domain/{id}
    this.register(
      /^\/domain\/(.+)$/,
      'DOMAIN',
      async (route) => {
        COREOGRAPH.broadcast('ROUTE:DOMAIN', 'ROUTER', { domainId: route.id });
        return {
          success: true,
          data: { domainId: route.id },
          routedTo: 'DOMAIN',
          latencyMs: 0,
        };
      }
    );

    // #/state/{code}
    this.register(
      /^\/state\/(.+)$/,
      'STATE',
      async (route) => {
        COREOGRAPH.broadcast('ROUTE:STATE', 'ROUTER', { stateCode: route.id });
        return {
          success: true,
          data: { stateCode: route.id },
          routedTo: 'STATE',
          latencyMs: 0,
        };
      }
    );

    // #/compute/{operation}
    this.register(
      /^\/compute\/(.+)$/,
      'COMPUTE',
      async (route) => {
        COREOGRAPH.broadcast('ROUTE:COMPUTE', 'ROUTER', { 
          operation: route.id, 
          params: route.params 
        });
        return {
          success: true,
          data: { operation: route.id, params: route.params },
          routedTo: 'COMPUTE',
          latencyMs: 0,
        };
      }
    );

    // #/stream/{topic}
    this.register(
      /^\/stream\/(.+)$/,
      'STREAM',
      async (route) => {
        COREOGRAPH.broadcast('ROUTE:STREAM', 'ROUTER', { topic: route.id });
        return {
          success: true,
          data: { topic: route.id },
          routedTo: 'STREAM',
          latencyMs: 0,
        };
      }
    );

    // #/engine/{name}
    this.register(
      /^\/engine\/(.+)$/,
      'ENGINE',
      async (route) => {
        COREOGRAPH.broadcast('ROUTE:ENGINE', 'ROUTER', { engineName: route.id });
        return {
          success: true,
          data: { engineName: route.id },
          routedTo: 'ENGINE',
          latencyMs: 0,
        };
      }
    );

    // #/knowledge/{domainId}
    this.register(
      /^\/knowledge\/(.+)$/,
      'KNOWLEDGE',
      async (route) => {
        COREOGRAPH.broadcast('ROUTE:KNOWLEDGE', 'ROUTER', { domainId: route.id });
        return {
          success: true,
          data: { domainId: route.id },
          routedTo: 'KNOWLEDGE',
          latencyMs: 0,
        };
      }
    );

    // #/runtime/{action}
    this.register(
      /^\/runtime\/(.+)$/,
      'RUNTIME',
      async (route) => {
        COREOGRAPH.broadcast('ROUTE:RUNTIME', 'ROUTER', { action: route.id });
        return {
          success: true,
          data: { action: route.id },
          routedTo: 'RUNTIME',
          latencyMs: 0,
        };
      }
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // SUBSCRIPTION
  // ─────────────────────────────────────────────────────────────────────────────

  subscribe(id: string, callback: (route: ParsedRoute) => void): () => void {
    this.subscribers.set(id, callback);
    return () => this.subscribers.delete(id);
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // NAVIGATION
  // ─────────────────────────────────────────────────────────────────────────────

  navigate(hash: string): Promise<RouteResult> {
    return this.route(hash);
  }

  navigateToOrganism(id: string): Promise<RouteResult> {
    return this.route(`#/organism/${id}`);
  }

  navigateToAgent(id: string): Promise<RouteResult> {
    return this.route(`#/agent/${id}`);
  }

  navigateToDomain(id: string): Promise<RouteResult> {
    return this.route(`#/domain/${id}`);
  }

  navigateToState(code: string): Promise<RouteResult> {
    return this.route(`#/state/${code}`);
  }

  navigateToCompute(operation: string, params?: Record<string, string>): Promise<RouteResult> {
    let hash = `#/compute/${operation}`;
    if (params) {
      const query = Object.entries(params)
        .map(([k, v]) => `${k}=${encodeURIComponent(v)}`)
        .join('&');
      hash += `?${query}`;
    }
    return this.route(hash);
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // QUERIES
  // ─────────────────────────────────────────────────────────────────────────────

  getCurrentRoute(): string {
    return NEXORIS.get('router:currentRoute') as string ?? '';
  }

  getHistory(): ParsedRoute[] {
    return [...this.history];
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // HASH GENERATION
  // ─────────────────────────────────────────────────────────────────────────────

  generateHash(type: RouteType, id: string, params?: Record<string, string>): string {
    let base = '';
    switch (type) {
      case 'ORGANISM': base = `/organism/${id}`; break;
      case 'AGENT': base = `/agent/${id}`; break;
      case 'DOMAIN': base = `/domain/${id}`; break;
      case 'STATE': base = `/state/${id}`; break;
      case 'COMPUTE': base = `/compute/${id}`; break;
      case 'STREAM': base = `/stream/${id}`; break;
      case 'ENGINE': base = `/engine/${id}`; break;
      case 'KNOWLEDGE': base = `/knowledge/${id}`; break;
      case 'RUNTIME': base = `/runtime/${id}`; break;
      case 'ADAPTER': base = `/adapter/${id}`; break;
    }

    if (params && Object.keys(params).length > 0) {
      const query = Object.entries(params)
        .map(([k, v]) => `${k}=${encodeURIComponent(v)}`)
        .join('&');
      base += `?${query}`;
    }

    return `#${base}`;
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SINGLETON EXPORT
// ═══════════════════════════════════════════════════════════════════════════════

export const HASH_ROUTER = new HashRouter();

// ═══════════════════════════════════════════════════════════════════════════════
// CONVENIENCE EXPORTS
// ═══════════════════════════════════════════════════════════════════════════════

export function route(hash: string): Promise<RouteResult> {
  return HASH_ROUTER.route(hash);
}

export function navigate(hash: string): Promise<RouteResult> {
  return HASH_ROUTER.navigate(hash);
}
