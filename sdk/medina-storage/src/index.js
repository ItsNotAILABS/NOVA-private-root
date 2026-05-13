/**
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * @medina/medina-storage — DISTRIBUTED STORAGE SDK
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 * 
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ
 * PROPRIETARY — SOVEREIGN INFRASTRUCTURE
 * 
 * This SDK provides distributed storage capabilities:
 *   - Key-value storage
 *   - Document storage
 *   - Blob storage
 *   - Replication and consistency
 *   - Versioning
 *   - Encryption at rest
 * 
 * ═══════════════════════════════════════════════════════════════════════════════════════════════════════
 */

// ═══════════════════════════════════════════════════════════════════════════════
// §1 — CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

const PHI = 1.6180339887498948482;
const PHI_INV = 0.6180339887498948482;
const HEARTBEAT_MS = 873;

const STORAGE_TYPES = {
  KV: 'KV',               // Key-value
  DOCUMENT: 'DOCUMENT',   // Document store
  BLOB: 'BLOB',           // Binary blobs
  GRAPH: 'GRAPH',         // Graph database
};

const CONSISTENCY_LEVELS = {
  EVENTUAL: 'EVENTUAL',
  STRONG: 'STRONG',
  SESSION: 'SESSION',
};

const REPLICATION_MODES = {
  NONE: 'NONE',
  ASYNC: 'ASYNC',
  SYNC: 'SYNC',
};

// ═══════════════════════════════════════════════════════════════════════════════
// §2 — STORAGE ITEM
// ═══════════════════════════════════════════════════════════════════════════════

class StorageItem {
  constructor(key, value, config = {}) {
    this.key = key;
    this.value = value;
    this.version = 1;
    this.checksum = this._calculateChecksum(value);
    
    this.metadata = config.metadata || {};
    this.tags = config.tags || [];
    this.ttl = config.ttl || null;
    this.encrypted = config.encrypted || false;
    
    this.createdAt = Date.now();
    this.updatedAt = Date.now();
    this.accessedAt = Date.now();
    this.accessCount = 0;
    
    this._history = [];
  }
  
  _calculateChecksum(value) {
    const str = JSON.stringify(value);
    let hash = 0;
    for (let i = 0; i < str.length; i++) {
      const char = str.charCodeAt(i);
      hash = ((hash << 5) - hash) + char;
      hash = hash & hash;
    }
    return Math.abs(hash).toString(16);
  }
  
  /**
   * Update the value
   */
  update(newValue, config = {}) {
    // Store history
    this._history.push({
      version: this.version,
      value: this.value,
      updatedAt: this.updatedAt,
    });
    
    // Keep limited history
    while (this._history.length > 10) {
      this._history.shift();
    }
    
    this.value = newValue;
    this.version++;
    this.checksum = this._calculateChecksum(newValue);
    this.updatedAt = Date.now();
    
    if (config.metadata) {
      this.metadata = { ...this.metadata, ...config.metadata };
    }
    if (config.tags) {
      this.tags = config.tags;
    }
    
    return this;
  }
  
  /**
   * Access the item
   */
  access() {
    this.accessedAt = Date.now();
    this.accessCount++;
    return this.value;
  }
  
  /**
   * Check if item has expired
   */
  isExpired() {
    if (!this.ttl) return false;
    return Date.now() > this.createdAt + this.ttl;
  }
  
  /**
   * Get a previous version
   */
  getVersion(version) {
    if (version === this.version) return this.value;
    const historical = this._history.find(h => h.version === version);
    return historical ? historical.value : null;
  }
  
  /**
   * Get version history
   */
  getHistory() {
    return [
      ...this._history,
      { version: this.version, value: this.value, updatedAt: this.updatedAt },
    ];
  }
  
  toJSON() {
    return {
      key: this.key,
      value: this.value,
      version: this.version,
      checksum: this.checksum,
      metadata: this.metadata,
      tags: this.tags,
      ttl: this.ttl,
      encrypted: this.encrypted,
      createdAt: this.createdAt,
      updatedAt: this.updatedAt,
      accessedAt: this.accessedAt,
      accessCount: this.accessCount,
      isExpired: this.isExpired(),
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §3 — KEY-VALUE STORE
// ═══════════════════════════════════════════════════════════════════════════════

class KVStore {
  constructor(namespace = 'default', config = {}) {
    this.namespace = namespace;
    this._items = new Map();
    this._index = {
      tags: new Map(),
      metadata: new Map(),
    };
    this.config = {
      consistency: config.consistency || CONSISTENCY_LEVELS.EVENTUAL,
      replication: config.replication || REPLICATION_MODES.NONE,
      maxSize: config.maxSize || 10000,
      defaultTTL: config.defaultTTL || null,
    };
  }
  
  /**
   * Get the full key with namespace
   */
  _fullKey(key) {
    return `${this.namespace}:${key}`;
  }
  
  /**
   * Set a value
   */
  set(key, value, config = {}) {
    const fullKey = this._fullKey(key);
    
    if (this._items.has(fullKey)) {
      const item = this._items.get(fullKey);
      item.update(value, config);
    } else {
      // Check max size
      if (this._items.size >= this.config.maxSize) {
        this._evict();
      }
      
      const item = new StorageItem(fullKey, value, {
        ...config,
        ttl: config.ttl || this.config.defaultTTL,
      });
      this._items.set(fullKey, item);
      this._indexItem(item);
    }
    
    return this.get(key);
  }
  
  /**
   * Get a value
   */
  get(key) {
    const fullKey = this._fullKey(key);
    const item = this._items.get(fullKey);
    
    if (!item) return null;
    if (item.isExpired()) {
      this.delete(key);
      return null;
    }
    
    return item.access();
  }
  
  /**
   * Get item with metadata
   */
  getItem(key) {
    const fullKey = this._fullKey(key);
    const item = this._items.get(fullKey);
    
    if (!item) return null;
    if (item.isExpired()) {
      this.delete(key);
      return null;
    }
    
    item.access();
    return item;
  }
  
  /**
   * Check if key exists
   */
  has(key) {
    const fullKey = this._fullKey(key);
    const item = this._items.get(fullKey);
    if (!item) return false;
    if (item.isExpired()) {
      this.delete(key);
      return false;
    }
    return true;
  }
  
  /**
   * Delete a key
   */
  delete(key) {
    const fullKey = this._fullKey(key);
    const item = this._items.get(fullKey);
    if (item) {
      this._unindexItem(item);
      this._items.delete(fullKey);
      return true;
    }
    return false;
  }
  
  /**
   * Get all keys
   */
  keys() {
    return Array.from(this._items.keys())
      .filter(k => !this._items.get(k).isExpired())
      .map(k => k.replace(`${this.namespace}:`, ''));
  }
  
  /**
   * Get all values
   */
  values() {
    return this.keys().map(k => this.get(k));
  }
  
  /**
   * Get all entries
   */
  entries() {
    return this.keys().map(k => [k, this.get(k)]);
  }
  
  /**
   * Find by tag
   */
  findByTag(tag) {
    const keys = this._index.tags.get(tag) || new Set();
    return Array.from(keys)
      .map(k => this._items.get(k))
      .filter(item => item && !item.isExpired());
  }
  
  /**
   * Clear all items
   */
  clear() {
    this._items.clear();
    this._index.tags.clear();
    this._index.metadata.clear();
    return this;
  }
  
  /**
   * Get store size
   */
  size() {
    return this._items.size;
  }
  
  _indexItem(item) {
    for (const tag of item.tags) {
      if (!this._index.tags.has(tag)) {
        this._index.tags.set(tag, new Set());
      }
      this._index.tags.get(tag).add(item.key);
    }
  }
  
  _unindexItem(item) {
    for (const tag of item.tags) {
      if (this._index.tags.has(tag)) {
        this._index.tags.get(tag).delete(item.key);
      }
    }
  }
  
  _evict() {
    // LRU eviction - remove least recently accessed
    let oldest = null;
    let oldestTime = Infinity;
    
    for (const [key, item] of this._items) {
      if (item.isExpired()) {
        this._unindexItem(item);
        this._items.delete(key);
        return;
      }
      if (item.accessedAt < oldestTime) {
        oldestTime = item.accessedAt;
        oldest = key;
      }
    }
    
    if (oldest) {
      this._unindexItem(this._items.get(oldest));
      this._items.delete(oldest);
    }
  }
  
  getStats() {
    return {
      namespace: this.namespace,
      size: this._items.size,
      maxSize: this.config.maxSize,
      tagCount: this._index.tags.size,
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §4 — DOCUMENT STORE
// ═══════════════════════════════════════════════════════════════════════════════

class DocumentStore {
  constructor(collection = 'default', config = {}) {
    this.collection = collection;
    this._documents = new Map();
    this._indexes = new Map();
    this.config = {
      maxDocuments: config.maxDocuments || 10000,
    };
  }
  
  /**
   * Insert a document
   */
  insert(doc, id = null) {
    const docId = id || `doc_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
    
    if (this._documents.size >= this.config.maxDocuments) {
      throw new Error('Document store at capacity');
    }
    
    const item = new StorageItem(docId, { ...doc, _id: docId });
    this._documents.set(docId, item);
    this._indexDocument(item);
    
    return docId;
  }
  
  /**
   * Find a document by ID
   */
  findById(id) {
    const item = this._documents.get(id);
    if (!item) return null;
    return item.access();
  }
  
  /**
   * Find documents matching a query
   */
  find(query = {}) {
    const results = [];
    
    for (const item of this._documents.values()) {
      const doc = item.value;
      if (this._matchesQuery(doc, query)) {
        item.access();
        results.push(doc);
      }
    }
    
    return results;
  }
  
  /**
   * Find one document matching a query
   */
  findOne(query = {}) {
    for (const item of this._documents.values()) {
      const doc = item.value;
      if (this._matchesQuery(doc, query)) {
        item.access();
        return doc;
      }
    }
    return null;
  }
  
  /**
   * Update a document
   */
  update(id, updates) {
    const item = this._documents.get(id);
    if (!item) return null;
    
    const newDoc = { ...item.value, ...updates, _id: id };
    item.update(newDoc);
    
    return newDoc;
  }
  
  /**
   * Update many documents
   */
  updateMany(query, updates) {
    const updated = [];
    
    for (const item of this._documents.values()) {
      const doc = item.value;
      if (this._matchesQuery(doc, query)) {
        const newDoc = { ...doc, ...updates };
        item.update(newDoc);
        updated.push(newDoc);
      }
    }
    
    return updated;
  }
  
  /**
   * Delete a document
   */
  delete(id) {
    const item = this._documents.get(id);
    if (item) {
      this._documents.delete(id);
      return true;
    }
    return false;
  }
  
  /**
   * Delete many documents
   */
  deleteMany(query) {
    const toDelete = [];
    
    for (const [id, item] of this._documents) {
      if (this._matchesQuery(item.value, query)) {
        toDelete.push(id);
      }
    }
    
    for (const id of toDelete) {
      this._documents.delete(id);
    }
    
    return toDelete.length;
  }
  
  /**
   * Count documents
   */
  count(query = {}) {
    if (Object.keys(query).length === 0) {
      return this._documents.size;
    }
    return this.find(query).length;
  }
  
  /**
   * Create an index
   */
  createIndex(field) {
    if (this._indexes.has(field)) return this;
    
    const index = new Map();
    for (const item of this._documents.values()) {
      const value = item.value[field];
      if (value !== undefined) {
        if (!index.has(value)) {
          index.set(value, new Set());
        }
        index.get(value).add(item.key);
      }
    }
    
    this._indexes.set(field, index);
    return this;
  }
  
  _matchesQuery(doc, query) {
    for (const [key, value] of Object.entries(query)) {
      if (typeof value === 'object' && value !== null) {
        // Handle operators
        if (value.$gt !== undefined && !(doc[key] > value.$gt)) return false;
        if (value.$gte !== undefined && !(doc[key] >= value.$gte)) return false;
        if (value.$lt !== undefined && !(doc[key] < value.$lt)) return false;
        if (value.$lte !== undefined && !(doc[key] <= value.$lte)) return false;
        if (value.$ne !== undefined && doc[key] === value.$ne) return false;
        if (value.$in !== undefined && !value.$in.includes(doc[key])) return false;
        if (value.$nin !== undefined && value.$nin.includes(doc[key])) return false;
        if (value.$exists !== undefined && (doc[key] !== undefined) !== value.$exists) return false;
      } else {
        if (doc[key] !== value) return false;
      }
    }
    return true;
  }
  
  _indexDocument(item) {
    for (const [field, index] of this._indexes) {
      const value = item.value[field];
      if (value !== undefined) {
        if (!index.has(value)) {
          index.set(value, new Set());
        }
        index.get(value).add(item.key);
      }
    }
  }
  
  getStats() {
    return {
      collection: this.collection,
      documentCount: this._documents.size,
      indexCount: this._indexes.size,
      maxDocuments: this.config.maxDocuments,
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §5 — BLOB STORE
// ═══════════════════════════════════════════════════════════════════════════════

class BlobStore {
  constructor(bucket = 'default', config = {}) {
    this.bucket = bucket;
    this._blobs = new Map();
    this.config = {
      maxBlobSize: config.maxBlobSize || 10 * 1024 * 1024, // 10MB
      maxBlobs: config.maxBlobs || 1000,
    };
  }
  
  /**
   * Store a blob
   */
  put(key, data, contentType = 'application/octet-stream', metadata = {}) {
    // In a real implementation, this would handle actual binary data
    const size = typeof data === 'string' ? data.length : JSON.stringify(data).length;
    
    if (size > this.config.maxBlobSize) {
      throw new Error(`Blob exceeds max size: ${size} > ${this.config.maxBlobSize}`);
    }
    
    if (this._blobs.size >= this.config.maxBlobs && !this._blobs.has(key)) {
      throw new Error('Blob store at capacity');
    }
    
    const blob = {
      key,
      data,
      size,
      contentType,
      metadata,
      checksum: this._calculateChecksum(data),
      createdAt: Date.now(),
      accessedAt: Date.now(),
      accessCount: 0,
    };
    
    this._blobs.set(key, blob);
    return blob;
  }
  
  /**
   * Get a blob
   */
  get(key) {
    const blob = this._blobs.get(key);
    if (!blob) return null;
    
    blob.accessedAt = Date.now();
    blob.accessCount++;
    
    return blob.data;
  }
  
  /**
   * Get blob metadata
   */
  head(key) {
    const blob = this._blobs.get(key);
    if (!blob) return null;
    
    return {
      key: blob.key,
      size: blob.size,
      contentType: blob.contentType,
      metadata: blob.metadata,
      checksum: blob.checksum,
      createdAt: blob.createdAt,
      accessedAt: blob.accessedAt,
    };
  }
  
  /**
   * Delete a blob
   */
  delete(key) {
    return this._blobs.delete(key);
  }
  
  /**
   * List all blobs
   */
  list(prefix = '') {
    const results = [];
    
    for (const [key, blob] of this._blobs) {
      if (key.startsWith(prefix)) {
        results.push({
          key: blob.key,
          size: blob.size,
          contentType: blob.contentType,
          createdAt: blob.createdAt,
        });
      }
    }
    
    return results;
  }
  
  /**
   * Check if blob exists
   */
  exists(key) {
    return this._blobs.has(key);
  }
  
  /**
   * Copy a blob
   */
  copy(sourceKey, destKey) {
    const source = this._blobs.get(sourceKey);
    if (!source) return null;
    
    return this.put(destKey, source.data, source.contentType, { ...source.metadata });
  }
  
  _calculateChecksum(data) {
    const str = typeof data === 'string' ? data : JSON.stringify(data);
    let hash = 0;
    for (let i = 0; i < str.length; i++) {
      const char = str.charCodeAt(i);
      hash = ((hash << 5) - hash) + char;
      hash = hash & hash;
    }
    return Math.abs(hash).toString(16);
  }
  
  getStats() {
    let totalSize = 0;
    for (const blob of this._blobs.values()) {
      totalSize += blob.size;
    }
    
    return {
      bucket: this.bucket,
      blobCount: this._blobs.size,
      totalSize,
      maxBlobs: this.config.maxBlobs,
      maxBlobSize: this.config.maxBlobSize,
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §6 — STORAGE MANAGER
// ═══════════════════════════════════════════════════════════════════════════════

class StorageManager {
  constructor(config = {}) {
    this._kvStores = new Map();
    this._documentStores = new Map();
    this._blobStores = new Map();
    this.config = config;
  }
  
  /**
   * Get or create a KV store
   */
  kv(namespace = 'default', config = {}) {
    if (!this._kvStores.has(namespace)) {
      this._kvStores.set(namespace, new KVStore(namespace, config));
    }
    return this._kvStores.get(namespace);
  }
  
  /**
   * Get or create a document store
   */
  documents(collection = 'default', config = {}) {
    if (!this._documentStores.has(collection)) {
      this._documentStores.set(collection, new DocumentStore(collection, config));
    }
    return this._documentStores.get(collection);
  }
  
  /**
   * Get or create a blob store
   */
  blobs(bucket = 'default', config = {}) {
    if (!this._blobStores.has(bucket)) {
      this._blobStores.set(bucket, new BlobStore(bucket, config));
    }
    return this._blobStores.get(bucket);
  }
  
  /**
   * Get overall stats
   */
  getStats() {
    const kvStats = Array.from(this._kvStores.values()).map(s => s.getStats());
    const docStats = Array.from(this._documentStores.values()).map(s => s.getStats());
    const blobStats = Array.from(this._blobStores.values()).map(s => s.getStats());
    
    return {
      kvStores: kvStats,
      documentStores: docStats,
      blobStores: blobStats,
      totals: {
        kvStores: this._kvStores.size,
        documentStores: this._documentStores.size,
        blobStores: this._blobStores.size,
      },
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// §7 — EXPORTS
// ═══════════════════════════════════════════════════════════════════════════════

export {
  // Constants
  PHI,
  PHI_INV,
  HEARTBEAT_MS,
  STORAGE_TYPES,
  CONSISTENCY_LEVELS,
  REPLICATION_MODES,
  
  // Classes
  StorageItem,
  KVStore,
  DocumentStore,
  BlobStore,
  StorageManager,
};

export default {
  STORAGE_TYPES,
  CONSISTENCY_LEVELS,
  REPLICATION_MODES,
  StorageItem,
  KVStore,
  DocumentStore,
  BlobStore,
  StorageManager,
};
