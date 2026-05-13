// ═══════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// Module: skyhi_client/useSkyhiAuth.ts — Production Session Authentication
// Language: TypeScript (CPL: canister integration layer)
//
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
//
// PRODUCTION AUTH — REAL CANISTER SESSION MANAGEMENT
// Uses skyhi_group canister: createSession / validateSession / revokeSession
// Session tokens stored in localStorage, auto-validated on mount.
// No mock auth. No bypass. Real ICP canister sessions.
// ═══════════════════════════════════════════════════════════════════════════

import { useState, useEffect, useCallback, useRef } from 'react';
import { getSkyHiActor } from '../canister/skyhiGroupActor';

// ── Storage keys ──────────────────────────────────────────────────────────
const STORAGE_KEY_TOKEN   = 'skyhi_session_token';
const STORAGE_KEY_TIER    = 'skyhi_session_tier';
const STORAGE_KEY_CLIENT  = 'skyhi_client_id';
const STORAGE_KEY_EXPIRY  = 'skyhi_session_expiry';

// ── Session duration (15 minutes — matches canister SESSION_TTL) ─────────
const SESSION_TTL_MS = 15 * 60 * 1000;
// Re-validate 2 minutes before expiry
const REVALIDATE_MARGIN_MS = 2 * 60 * 1000;

// ── Tier type matching canister MembershipTier ────────────────────────────
export type ClientTier = 'free' | 'basic' | 'premium' | 'sovereign';

// ── Auth state ────────────────────────────────────────────────────────────
export interface SkyhiAuthState {
  /** Whether the user is authenticated with a valid session */
  authenticated: boolean;
  /** Whether auth is being checked (loading state) */
  loading: boolean;
  /** Current session token hash */
  sessionToken: string | null;
  /** Client identifier (company/user label) */
  clientId: string | null;
  /** Access tier */
  tier: ClientTier | null;
  /** Session expiry timestamp (ms) */
  expiresAt: number | null;
  /** Last error message */
  error: string | null;
  /** Login — calls createSession on the canister */
  login: (clientId: string, accessKey: string, tier: ClientTier) => Promise<boolean>;
  /** Logout — calls revokeSession on the canister and clears local state */
  logout: () => Promise<void>;
  /** Re-validate current session against canister */
  revalidate: () => Promise<boolean>;
}

// ── Hash helper — SHA-256 the access key for the canister token ──────────
async function hashAccessKey(accessKey: string): Promise<string> {
  const encoded = new TextEncoder().encode(accessKey);
  const hashBuffer = await crypto.subtle.digest('SHA-256', encoded);
  const hashArray = Array.from(new Uint8Array(hashBuffer));
  return hashArray.map(b => b.toString(16).padStart(2, '0')).join('');
}

// ── Tier conversion for canister call ────────────────────────────────────
function tierToVariant(tier: ClientTier): Record<string, null> {
  switch (tier) {
    case 'free':      return { free: null };
    case 'basic':     return { basic: null };
    case 'premium':   return { premium: null };
    case 'sovereign': return { sovereign: null };
    default:          return { free: null };
  }
}

// ── Persist helpers ──────────────────────────────────────────────────────
function persistSession(token: string, tier: ClientTier, clientId: string, expiresAt: number): void {
  try {
    localStorage.setItem(STORAGE_KEY_TOKEN,  token);
    localStorage.setItem(STORAGE_KEY_TIER,   tier);
    localStorage.setItem(STORAGE_KEY_CLIENT, clientId);
    localStorage.setItem(STORAGE_KEY_EXPIRY, String(expiresAt));
  } catch {
    // localStorage may be unavailable — session will be memory-only
  }
}

function loadPersistedSession(): { token: string; tier: ClientTier; clientId: string; expiresAt: number } | null {
  try {
    const token    = localStorage.getItem(STORAGE_KEY_TOKEN);
    const tier     = localStorage.getItem(STORAGE_KEY_TIER) as ClientTier | null;
    const clientId = localStorage.getItem(STORAGE_KEY_CLIENT);
    const expiry   = localStorage.getItem(STORAGE_KEY_EXPIRY);
    if (token && tier && clientId && expiry) {
      const expiresAt = parseInt(expiry, 10);
      if (expiresAt > Date.now()) {
        return { token, tier, clientId, expiresAt };
      }
    }
  } catch {
    // Ignore localStorage errors
  }
  return null;
}

function clearPersistedSession(): void {
  try {
    localStorage.removeItem(STORAGE_KEY_TOKEN);
    localStorage.removeItem(STORAGE_KEY_TIER);
    localStorage.removeItem(STORAGE_KEY_CLIENT);
    localStorage.removeItem(STORAGE_KEY_EXPIRY);
  } catch {
    // Ignore
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// HOOK
// ═══════════════════════════════════════════════════════════════════════════

export function useSkyhiAuth(): SkyhiAuthState {
  const [authenticated, setAuthenticated] = useState(false);
  const [loading,       setLoading]       = useState(true);
  const [sessionToken,  setSessionToken]  = useState<string | null>(null);
  const [clientId,      setClientId]      = useState<string | null>(null);
  const [tier,          setTier]          = useState<ClientTier | null>(null);
  const [expiresAt,     setExpiresAt]     = useState<number | null>(null);
  const [error,         setError]         = useState<string | null>(null);
  const mountedRef = useRef(true);

  // ── Validate session against canister ──────────────────────────────────
  const validateOnCanister = useCallback(async (token: string): Promise<boolean> => {
    try {
      const actor = await getSkyHiActor();
      const valid = await (actor.validateSession as (t: string) => Promise<boolean>)(token);
      return valid;
    } catch {
      // Canister unreachable — if token not expired locally, allow graceful degradation
      return false;
    }
  }, []);

  // ── Auto-validate on mount (check persisted session) ───────────────────
  useEffect(() => {
    mountedRef.current = true;
    (async () => {
      const persisted = loadPersistedSession();
      if (persisted) {
        // Validate against canister
        const valid = await validateOnCanister(persisted.token);
        if (mountedRef.current) {
          if (valid) {
            setSessionToken(persisted.token);
            setClientId(persisted.clientId);
            setTier(persisted.tier);
            setExpiresAt(persisted.expiresAt);
            setAuthenticated(true);
          } else {
            // Token expired on canister side — clear
            clearPersistedSession();
          }
          setLoading(false);
        }
      } else {
        if (mountedRef.current) setLoading(false);
      }
    })();
    return () => { mountedRef.current = false; };
  }, [validateOnCanister]);

  // ── Auto re-validate before expiry ─────────────────────────────────────
  useEffect(() => {
    if (!authenticated || !expiresAt || !sessionToken) return;
    const timeUntilRevalidate = Math.max(0, expiresAt - Date.now() - REVALIDATE_MARGIN_MS);
    const timerId = setTimeout(async () => {
      const valid = await validateOnCanister(sessionToken);
      if (mountedRef.current) {
        if (!valid) {
          setAuthenticated(false);
          setError('Session expired — please log in again');
          clearPersistedSession();
        }
      }
    }, timeUntilRevalidate);
    return () => clearTimeout(timerId);
  }, [authenticated, expiresAt, sessionToken, validateOnCanister]);

  // ── Login ──────────────────────────────────────────────────────────────
  const login = useCallback(async (cid: string, accessKey: string, t: ClientTier): Promise<boolean> => {
    setLoading(true);
    setError(null);
    try {
      // Hash the access key — canister stores tokenHash, not raw key
      const tokenHash = await hashAccessKey(accessKey);

      const actor = await getSkyHiActor();
      const result = await (actor.createSession as (
        hash: string,
        tier: Record<string, null>,
        label: string,
      ) => Promise<{ ok: bigint } | { err: string }>)(
        tokenHash,
        tierToVariant(t),
        cid,
      );

      if ('err' in result) {
        if (mountedRef.current) {
          setError(result.err);
          setLoading(false);
        }
        return false;
      }

      const exp = Date.now() + SESSION_TTL_MS;
      if (mountedRef.current) {
        setSessionToken(tokenHash);
        setClientId(cid);
        setTier(t);
        setExpiresAt(exp);
        setAuthenticated(true);
        setLoading(false);
        persistSession(tokenHash, t, cid, exp);
      }
      return true;
    } catch (e) {
      if (mountedRef.current) {
        setError(e instanceof Error ? e.message : 'Authentication failed — canister unreachable');
        setLoading(false);
      }
      return false;
    }
  }, []);

  // ── Logout ─────────────────────────────────────────────────────────────
  const logout = useCallback(async () => {
    if (sessionToken) {
      try {
        const actor = await getSkyHiActor();
        await (actor.revokeSession as (t: string) => Promise<boolean>)(sessionToken);
      } catch {
        // Best-effort revocation — clear local state regardless
      }
    }
    setAuthenticated(false);
    setSessionToken(null);
    setClientId(null);
    setTier(null);
    setExpiresAt(null);
    setError(null);
    clearPersistedSession();
  }, [sessionToken]);

  // ── Revalidate ─────────────────────────────────────────────────────────
  const revalidate = useCallback(async (): Promise<boolean> => {
    if (!sessionToken) return false;
    const valid = await validateOnCanister(sessionToken);
    if (!valid && mountedRef.current) {
      setAuthenticated(false);
      setError('Session invalidated');
      clearPersistedSession();
    }
    return valid;
  }, [sessionToken, validateOnCanister]);

  return {
    authenticated,
    loading,
    sessionToken,
    clientId,
    tier,
    expiresAt,
    error,
    login,
    logout,
    revalidate,
  };
}
