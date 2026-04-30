/**
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * @medina/medina-auth — AUTHENTICATION AND PERMISSIONS SDK
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * 
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ
 * PROPRIETARY — SOVEREIGN INFRASTRUCTURE
 * 
 * This SDK provides authentication and authorization:
 *   - Identity management
 *   - Permission system
 *   - Role-based access control
 *   - Token management
 *   - Principal validation (ICP)
 *   - API key management
 * 
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 */

// ═══════════════════════════════════════════════════════════════════════════════
// §1 — CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

const PHI = 1.6180339887498948482;
const PHI_INV = 0.6180339887498948482;
const HEARTBEAT_MS = 873;

const IDENTITY_TYPES = {
  USER: 'USER',
  AGENT: 'AGENT',
  SERVICE: 'SERVICE',
  CANISTER: 'CANISTER',
  ANONYMOUS: 'ANONYMOUS',
};

const PERMISSION_TYPES = {
  READ: 'READ',
  WRITE: 'WRITE',
  EXECUTE: 'EXECUTE',
  DELETE: 'DELETE',
  ADMIN: 'ADMIN',
};

const TOKEN_TYPES = {
  ACCESS: 'ACCESS',
  REFRESH: 'REFRESH',
  API_KEY: 'API_KEY',
  PRINCIPAL: 'PRINCIPAL',
};

const AUTH_EVENTS = {
  LOGIN: 'LOGIN',
  LOGOUT: 'LOGOUT',
  TOKEN_ISSUED: 'TOKEN_ISSUED',
  TOKEN_REVOKED: 'TOKEN_REVOKED',
  PERMISSION_GRANTED: 'PERMISSION_GRANTED',
  PERMISSION_DENIED: 'PERMISSION_DENIED',
  ROLE_ASSIGNED: 'ROLE_ASSIGNED',
};

// ═══════════════════════════════════════════════════════════════════════════════
// §2 — IDENTITY
// ═══════════════════════════════════════════════════════════════════════════════

class Identity {
  constructor(config) {
    this.id = config.id || `id_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
    this.type = config.type || IDENTITY_TYPES.USER;
    this.name = config.name || 'Anonymous';
    this.principal = config.principal || null; // ICP principal
    this.metadata = config.metadata || {};
    
    this.roles = new Set(config.roles || []);
    this.permissions = new Map();
    this.tokens = new Map();
    
    this.createdAt = Date.now();
    this.lastActiveAt = Date.now();
    this.isActive = true;
  }
  
  /**
   * Add a role to this identity
   */
  addRole(role) {
    this.roles.add(role);
    return this;
  }
  
  /**
   * Remove a role from this identity
   */
  removeRole(role) {
    this.roles.delete(role);
    return this;
  }
  
  /**
   * Check if identity has a role
   */
  hasRole(role) {
    return this.roles.has(role);
  }
  
  /**
   * Grant a permission on a resource
   */
  grantPermission(resource, permission) {
    if (!this.permissions.has(resource)) {
      this.permissions.set(resource, new Set());
    }
    this.permissions.get(resource).add(permission);
    return this;
  }
  
  /**
   * Revoke a permission on a resource
   */
  revokePermission(resource, permission) {
    if (this.permissions.has(resource)) {
      this.permissions.get(resource).delete(permission);
    }
    return this;
  }
  
  /**
   * Check if identity has permission on a resource
   */
  hasPermission(resource, permission) {
    // Admin has all permissions
    if (this.roles.has('admin')) return true;
    
    if (!this.permissions.has(resource)) return false;
    return this.permissions.get(resource).has(permission);
  }
  
  /**
   * Update last active timestamp
   */
  touch() {
    this.lastActiveAt = Date.now();
    return this;
  }
  
  /**
   * Deactivate identity
   */
  deactivate() {
    this.isActive = false;
    this.tokens.clear();
    return this;
  }
  
  toJSON() {
    return {
      id: this.id,
      type: this.type,
      name: this.name,
      principal: this.principal,
      roles: Array.from(this.roles),
      permissions: Object.fromEntries(
        Array.from(this.permissions.entries()).map(([k, v]) => [k, Array.from(v)])
      ),
      createdAt: this.createdAt,
      lastActiveAt: this.lastActiveAt,
      isActive: this.isActive,
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §3 — TOKEN
// ═══════════════════════════════════════════════════════════════════════════════

class Token {
  constructor(config) {
    this.id = config.id || `tok_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
    this.type = config.type || TOKEN_TYPES.ACCESS;
    this.identityId = config.identityId;
    this.value = config.value || this._generateTokenValue();
    
    this.issuedAt = Date.now();
    this.expiresAt = config.expiresAt || this._calculateExpiry();
    this.lastUsedAt = null;
    this.usageCount = 0;
    this.maxUsage = config.maxUsage || null;
    
    this.scopes = config.scopes || ['*'];
    this.metadata = config.metadata || {};
    this.isRevoked = false;
  }
  
  _generateTokenValue() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    let result = '';
    for (let i = 0; i < 64; i++) {
      result += chars.charAt(Math.floor(Math.random() * chars.length));
    }
    return result;
  }
  
  _calculateExpiry() {
    switch (this.type) {
      case TOKEN_TYPES.ACCESS:
        return Date.now() + (60 * 60 * 1000); // 1 hour
      case TOKEN_TYPES.REFRESH:
        return Date.now() + (7 * 24 * 60 * 60 * 1000); // 7 days
      case TOKEN_TYPES.API_KEY:
        return Date.now() + (365 * 24 * 60 * 60 * 1000); // 1 year
      default:
        return Date.now() + (60 * 60 * 1000);
    }
  }
  
  /**
   * Check if token is valid
   */
  isValid() {
    if (this.isRevoked) return false;
    if (Date.now() > this.expiresAt) return false;
    if (this.maxUsage && this.usageCount >= this.maxUsage) return false;
    return true;
  }
  
  /**
   * Use the token
   */
  use() {
    if (!this.isValid()) {
      throw new Error('Token is not valid');
    }
    this.lastUsedAt = Date.now();
    this.usageCount++;
    return this;
  }
  
  /**
   * Revoke the token
   */
  revoke() {
    this.isRevoked = true;
    return this;
  }
  
  /**
   * Refresh token expiry
   */
  refresh() {
    if (this.type === TOKEN_TYPES.REFRESH && this.isValid()) {
      this.expiresAt = this._calculateExpiry();
    }
    return this;
  }
  
  /**
   * Check if token has a scope
   */
  hasScope(scope) {
    return this.scopes.includes('*') || this.scopes.includes(scope);
  }
  
  toJSON() {
    return {
      id: this.id,
      type: this.type,
      identityId: this.identityId,
      issuedAt: this.issuedAt,
      expiresAt: this.expiresAt,
      lastUsedAt: this.lastUsedAt,
      usageCount: this.usageCount,
      scopes: this.scopes,
      isValid: this.isValid(),
      isRevoked: this.isRevoked,
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §4 — ROLE
// ═══════════════════════════════════════════════════════════════════════════════

class Role {
  constructor(name, config = {}) {
    this.name = name;
    this.description = config.description || '';
    this.permissions = new Map(); // resource -> Set of permissions
    this.inherits = config.inherits || []; // Roles this role inherits from
    this.createdAt = Date.now();
  }
  
  /**
   * Add permission to role
   */
  addPermission(resource, permission) {
    if (!this.permissions.has(resource)) {
      this.permissions.set(resource, new Set());
    }
    this.permissions.get(resource).add(permission);
    return this;
  }
  
  /**
   * Remove permission from role
   */
  removePermission(resource, permission) {
    if (this.permissions.has(resource)) {
      this.permissions.get(resource).delete(permission);
    }
    return this;
  }
  
  /**
   * Check if role has permission
   */
  hasPermission(resource, permission) {
    if (this.permissions.has(resource)) {
      if (this.permissions.get(resource).has(permission)) return true;
    }
    // Check wildcard
    if (this.permissions.has('*')) {
      if (this.permissions.get('*').has(permission)) return true;
      if (this.permissions.get('*').has('*')) return true;
    }
    return false;
  }
  
  toJSON() {
    return {
      name: this.name,
      description: this.description,
      permissions: Object.fromEntries(
        Array.from(this.permissions.entries()).map(([k, v]) => [k, Array.from(v)])
      ),
      inherits: this.inherits,
      createdAt: this.createdAt,
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §5 — AUTH MANAGER
// ═══════════════════════════════════════════════════════════════════════════════

class AuthManager {
  constructor(config = {}) {
    this._identities = new Map();
    this._tokens = new Map();
    this._roles = new Map();
    this._eventLog = [];
    this._eventLogLimit = 1000;
    
    // Create default roles
    this._createDefaultRoles();
  }
  
  _createDefaultRoles() {
    // Admin role
    const admin = new Role('admin', { description: 'Full system access' });
    admin.addPermission('*', '*');
    this._roles.set('admin', admin);
    
    // User role
    const user = new Role('user', { description: 'Standard user access' });
    user.addPermission('*', PERMISSION_TYPES.READ);
    user.addPermission('own:*', PERMISSION_TYPES.WRITE);
    this._roles.set('user', user);
    
    // Agent role
    const agent = new Role('agent', { description: 'AI agent access' });
    agent.addPermission('*', PERMISSION_TYPES.READ);
    agent.addPermission('*', PERMISSION_TYPES.EXECUTE);
    this._roles.set('agent', agent);
    
    // Service role
    const service = new Role('service', { description: 'Service account access' });
    service.addPermission('api:*', '*');
    this._roles.set('service', service);
  }
  
  _logEvent(type, data) {
    const event = {
      type,
      data,
      timestamp: Date.now(),
    };
    this._eventLog.push(event);
    while (this._eventLog.length > this._eventLogLimit) {
      this._eventLog.shift();
    }
    return event;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // §5.1 — IDENTITY MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /**
   * Create a new identity
   */
  createIdentity(config) {
    const identity = new Identity(config);
    this._identities.set(identity.id, identity);
    return identity;
  }
  
  /**
   * Get identity by ID
   */
  getIdentity(id) {
    return this._identities.get(id);
  }
  
  /**
   * Get identity by principal
   */
  getIdentityByPrincipal(principal) {
    for (const identity of this._identities.values()) {
      if (identity.principal === principal) {
        return identity;
      }
    }
    return null;
  }
  
  /**
   * Deactivate an identity
   */
  deactivateIdentity(id) {
    const identity = this._identities.get(id);
    if (identity) {
      identity.deactivate();
      // Revoke all tokens
      for (const token of this._tokens.values()) {
        if (token.identityId === id) {
          token.revoke();
        }
      }
    }
    return identity;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // §5.2 — TOKEN MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /**
   * Issue a new token
   */
  issueToken(identityId, type = TOKEN_TYPES.ACCESS, config = {}) {
    const identity = this._identities.get(identityId);
    if (!identity) {
      throw new Error(`Identity not found: ${identityId}`);
    }
    
    if (!identity.isActive) {
      throw new Error('Identity is not active');
    }
    
    const token = new Token({
      ...config,
      type,
      identityId,
    });
    
    this._tokens.set(token.value, token);
    identity.tokens.set(token.id, token);
    
    this._logEvent(AUTH_EVENTS.TOKEN_ISSUED, {
      tokenId: token.id,
      identityId,
      type,
    });
    
    return token;
  }
  
  /**
   * Validate a token
   */
  validateToken(tokenValue) {
    const token = this._tokens.get(tokenValue);
    if (!token) return { valid: false, reason: 'Token not found' };
    if (!token.isValid()) return { valid: false, reason: 'Token expired or revoked' };
    
    const identity = this._identities.get(token.identityId);
    if (!identity) return { valid: false, reason: 'Identity not found' };
    if (!identity.isActive) return { valid: false, reason: 'Identity not active' };
    
    token.use();
    identity.touch();
    
    return { valid: true, token, identity };
  }
  
  /**
   * Revoke a token
   */
  revokeToken(tokenValue) {
    const token = this._tokens.get(tokenValue);
    if (token) {
      token.revoke();
      this._logEvent(AUTH_EVENTS.TOKEN_REVOKED, {
        tokenId: token.id,
        identityId: token.identityId,
      });
    }
    return token;
  }
  
  /**
   * Clean up expired tokens
   */
  cleanupTokens() {
    const expired = [];
    for (const [value, token] of this._tokens) {
      if (!token.isValid()) {
        expired.push(value);
      }
    }
    for (const value of expired) {
      this._tokens.delete(value);
    }
    return expired.length;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // §5.3 — ROLE MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /**
   * Create a new role
   */
  createRole(name, config = {}) {
    const role = new Role(name, config);
    this._roles.set(name, role);
    return role;
  }
  
  /**
   * Get a role
   */
  getRole(name) {
    return this._roles.get(name);
  }
  
  /**
   * Assign a role to an identity
   */
  assignRole(identityId, roleName) {
    const identity = this._identities.get(identityId);
    const role = this._roles.get(roleName);
    
    if (!identity) throw new Error(`Identity not found: ${identityId}`);
    if (!role) throw new Error(`Role not found: ${roleName}`);
    
    identity.addRole(roleName);
    
    this._logEvent(AUTH_EVENTS.ROLE_ASSIGNED, {
      identityId,
      roleName,
    });
    
    return identity;
  }
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // §5.4 — AUTHORIZATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /**
   * Check if an identity can perform an action on a resource
   */
  authorize(identityId, resource, permission) {
    const identity = this._identities.get(identityId);
    if (!identity || !identity.isActive) {
      this._logEvent(AUTH_EVENTS.PERMISSION_DENIED, {
        identityId,
        resource,
        permission,
        reason: 'Identity not found or inactive',
      });
      return false;
    }
    
    // Check direct permissions
    if (identity.hasPermission(resource, permission)) {
      this._logEvent(AUTH_EVENTS.PERMISSION_GRANTED, {
        identityId,
        resource,
        permission,
        source: 'direct',
      });
      return true;
    }
    
    // Check role permissions
    for (const roleName of identity.roles) {
      const role = this._roles.get(roleName);
      if (role && this._checkRolePermission(role, resource, permission)) {
        this._logEvent(AUTH_EVENTS.PERMISSION_GRANTED, {
          identityId,
          resource,
          permission,
          source: 'role',
          role: roleName,
        });
        return true;
      }
    }
    
    this._logEvent(AUTH_EVENTS.PERMISSION_DENIED, {
      identityId,
      resource,
      permission,
      reason: 'No matching permission',
    });
    return false;
  }
  
  _checkRolePermission(role, resource, permission, visited = new Set()) {
    if (visited.has(role.name)) return false; // Prevent cycles
    visited.add(role.name);
    
    if (role.hasPermission(resource, permission)) return true;
    
    // Check inherited roles
    for (const inheritedName of role.inherits) {
      const inherited = this._roles.get(inheritedName);
      if (inherited && this._checkRolePermission(inherited, resource, permission, visited)) {
        return true;
      }
    }
    
    return false;
  }
  
  /**
   * Create an authorization guard function
   */
  createGuard(resource, permission) {
    return (tokenValue) => {
      const validation = this.validateToken(tokenValue);
      if (!validation.valid) {
        return { authorized: false, reason: validation.reason };
      }
      
      const authorized = this.authorize(validation.identity.id, resource, permission);
      return {
        authorized,
        identity: validation.identity,
        reason: authorized ? null : 'Permission denied',
      };
    };
  }
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // §5.5 — STATS AND STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  getStats() {
    return {
      identityCount: this._identities.size,
      activeIdentities: Array.from(this._identities.values()).filter(i => i.isActive).length,
      tokenCount: this._tokens.size,
      validTokens: Array.from(this._tokens.values()).filter(t => t.isValid()).length,
      roleCount: this._roles.size,
      eventLogSize: this._eventLog.length,
    };
  }
  
  getEventLog(limit = 100) {
    return this._eventLog.slice(-limit);
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §6 — EXPORTS
// ═══════════════════════════════════════════════════════════════════════════════

export {
  // Constants
  PHI,
  PHI_INV,
  HEARTBEAT_MS,
  IDENTITY_TYPES,
  PERMISSION_TYPES,
  TOKEN_TYPES,
  AUTH_EVENTS,
  
  // Classes
  Identity,
  Token,
  Role,
  AuthManager,
};

export default {
  IDENTITY_TYPES,
  PERMISSION_TYPES,
  TOKEN_TYPES,
  AUTH_EVENTS,
  Identity,
  Token,
  Role,
  AuthManager,
};
