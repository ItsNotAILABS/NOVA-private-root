// ═══════════════════════════════════════════════════════════════════════════
// PARALLAX SERVICE WORKER — NOVA SOVEREIGN PWA
// Language: JavaScript (service workers must be .js — CPL: JS layer)
// Strategy: cache-first for static assets, network-first for canister API
// ═══════════════════════════════════════════════════════════════════════════

const CACHE_NAME  = 'parallax-v1';
const API_PREFIX  = '/api/';        // ICP canister calls
const IC_PREFIX   = 'https://icp-api.io'; // IC boundary node

// Assets we cache immediately on install
const PRECACHE = [
  '/',
  '/index.html',
  '/manifest.json',
];

// ── Install: pre-cache shell ──────────────────────────────────────────────
self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => cache.addAll(PRECACHE))
  );
  self.skipWaiting();
});

// ── Activate: clear old caches ────────────────────────────────────────────
self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((keys) =>
      Promise.all(
        keys
          .filter((k) => k !== CACHE_NAME)
          .map((k) => caches.delete(k))
      )
    )
  );
  self.clients.claim();
});

// ── Fetch: network-first for API, cache-first for assets ─────────────────
self.addEventListener('fetch', (event) => {
  const { request } = event;
  const url = request.url;

  // Canister / IC API calls: always go network, never cache
  if (url.includes(API_PREFIX) || url.includes(IC_PREFIX)) {
    event.respondWith(
      fetch(request).catch(() =>
        new Response(
          JSON.stringify({ error: 'PARALLAX offline — canister unreachable' }),
          { status: 503, headers: { 'Content-Type': 'application/json' } }
        )
      )
    );
    return;
  }

  // Static assets: cache-first with network fallback
  event.respondWith(
    caches.match(request).then((cached) => {
      if (cached) return cached;
      return fetch(request).then((response) => {
        // Only cache GET 200 responses
        if (request.method !== 'GET' || !response || response.status !== 200) {
          return response;
        }
        const clone = response.clone();
        caches.open(CACHE_NAME).then((cache) => cache.put(request, clone));
        return response;
      });
    })
  );
});

// ── Message: skipWaiting from main thread ─────────────────────────────────
self.addEventListener('message', (event) => {
  if (event.data && event.data.type === 'SKIP_WAITING') {
    self.skipWaiting();
  }
});
