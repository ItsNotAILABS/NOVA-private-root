/**
 * ═══════════════════════════════════════════════════════════════════════════
 * @medina/medina-registry — SOVEREIGN PRIVATE REGISTRY
 * ═══════════════════════════════════════════════════════════════════════════
 * 
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ
 * PROPRIETARY — SOVEREIGN INFRASTRUCTURE
 * 
 * Your own npm/git for sovereign SDK distribution.
 * SDKs should be self-organizing — callable by the system itself,
 * living inside sovereign infrastructure.
 * ═══════════════════════════════════════════════════════════════════════════
 */

// ═══ §1 — Registry Constants ═══

const REGISTRY_VERSION = '1.0.0';
const REGISTRY_NAMESPACE = '@medina';

// ═══ §2 — Pre-registered Core SDKs ═══

const CORE_SDKS = {
  '@medina/meridian-sovereign-os': {
    name: '@medina/meridian-sovereign-os',
    version: '1.0.0',
    description: 'Core OS',
    category: 'core',
  },
  '@medina/civitas-intelligentiae': {
    name: '@medina/civitas-intelligentiae',
    version: '1.0.0',
    description: 'AI Civilization',
    category: 'intelligence',
  },
  '@medina/organism-icp': {
    name: '@medina/organism-icp',
    version: '1.0.0',
    description: 'ICP/Blockchain agents',
    category: 'blockchain',
  },
  '@medina/medina-queries': {
    name: '@medina/medina-queries',
    version: '1.0.0',
    description: 'Read operations (internal + external)',
    category: 'data',
  },
  '@medina/medina-calls': {
    name: '@medina/medina-calls',
    version: '1.0.0',
    description: 'Write operations (internal + external)',
    category: 'data',
  },
  '@medina/medina-timers': {
    name: '@medina/medina-timers',
    version: '1.0.0',
    description: 'Mathematical timers',
    category: 'timing',
  },
  '@medina/medina-heart': {
    name: '@medina/medina-heart',
    version: '1.0.0',
    description: 'Self-bootstrapping heart',
    category: 'core',
  },
  '@medina/medina-registry': {
    name: '@medina/medina-registry',
    version: '1.0.0',
    description: 'Sovereign private registry',
    category: 'core',
  },
  '@medina/organism-bootstrap': {
    name: '@medina/organism-bootstrap',
    version: '1.0.0',
    description: 'ICP deployment',
    category: 'deployment',
  },
  '@medina/birth-ai': {
    name: '@medina/birth-ai',
    version: '1.0.0',
    description: 'Main SDK for birthing AI entities',
    category: 'core',
  },
  '@medina/medina-tools': {
    name: '@medina/medina-tools',
    version: '1.0.0',
    description: 'PDF, virtual computer, file operations',
    category: 'tools',
  },
  '@medina/medina-tasks': {
    name: '@medina/medina-tasks',
    version: '1.0.0',
    description: 'Task scheduling and execution',
    category: 'scheduling',
  },
  '@medina/medina-multimodal': {
    name: '@medina/medina-multimodal',
    version: '1.0.0',
    description: 'Image, audio, video processing',
    category: 'multimodal',
  },
  '@medina/medina-builder': {
    name: '@medina/medina-builder',
    version: '1.0.0',
    description: 'SDK that builds other SDKs',
    category: 'meta',
  },
};

// ═══ §3 — SovereignRegistry Class ═══

class SovereignRegistry {
  constructor(config = {}) {
    this.namespace = config.namespace || REGISTRY_NAMESPACE;
    this.version = REGISTRY_VERSION;
    this.packages = new Map();
    this.dependencies = new Map();
    this.installed = new Map();
    
    // Pre-register core SDKs
    this._initCoreSDKs();
  }
  
  _initCoreSDKs() {
    for (const [name, sdk] of Object.entries(CORE_SDKS)) {
      this.packages.set(name, sdk);
    }
  }
  
  /**
   * Publish a package to the registry
   */
  publish(packageDef) {
    const name = packageDef.name;
    if (!name) {
      throw new Error('Package must have a name');
    }
    
    // Validate namespace
    if (!name.startsWith(this.namespace + '/')) {
      throw new Error('Package name must start with ' + this.namespace + '/');
    }
    
    const pkg = {
      name: name,
      version: packageDef.version || '1.0.0',
      description: packageDef.description || '',
      category: packageDef.category || 'custom',
      dependencies: packageDef.dependencies || [],
      publishedAt: Date.now(),
    };
    
    this.packages.set(name, pkg);
    
    // Track dependencies
    for (const dep of pkg.dependencies) {
      if (!this.dependencies.has(dep)) {
        this.dependencies.set(dep, []);
      }
      this.dependencies.get(dep).push(name);
    }
    
    return pkg;
  }
  
  /**
   * Install a package
   */
  install(packageName) {
    const pkg = this.packages.get(packageName);
    if (!pkg) {
      throw new Error('Package not found: ' + packageName);
    }
    
    // Install dependencies first
    for (const dep of (pkg.dependencies || [])) {
      if (!this.installed.has(dep)) {
        this.install(dep);
      }
    }
    
    // Mark as installed
    this.installed.set(packageName, {
      ...pkg,
      installedAt: Date.now(),
    });
    
    return this.installed.get(packageName);
  }
  
  /**
   * Get package info
   */
  get(packageName) {
    return this.packages.get(packageName) || null;
  }
  
  /**
   * List all packages
   */
  list() {
    return Array.from(this.packages.values());
  }
  
  /**
   * List by category
   */
  listByCategory(category) {
    return this.list().filter(pkg => pkg.category === category);
  }
  
  /**
   * Get dependents of a package
   */
  getDependents(packageName) {
    return this.dependencies.get(packageName) || [];
  }
  
  /**
   * Get installed packages
   */
  listInstalled() {
    return Array.from(this.installed.values());
  }
  
  /**
   * Check if package is installed
   */
  isInstalled(packageName) {
    return this.installed.has(packageName);
  }
  
  /**
   * Get registry state
   */
  getState() {
    return {
      namespace: this.namespace,
      version: this.version,
      totalPackages: this.packages.size,
      installedPackages: this.installed.size,
      categories: this._getCategories(),
    };
  }
  
  _getCategories() {
    const categories = {};
    for (const pkg of this.packages.values()) {
      const cat = pkg.category || 'uncategorized';
      if (!categories[cat]) {
        categories[cat] = 0;
      }
      categories[cat]++;
    }
    return categories;
  }
}

// ═══ §4 — Global Registry Instance ═══

const globalRegistry = new SovereignRegistry();

// ═══ §5 — Helper Functions ═══

function createRegistry(config) {
  return new SovereignRegistry(config);
}

function publish(packageDef) {
  return globalRegistry.publish(packageDef);
}

function install(packageName) {
  return globalRegistry.install(packageName);
}

function listPackages() {
  return globalRegistry.list();
}

function getPackage(name) {
  return globalRegistry.get(name);
}

// ═══ Exports ═══

export {
  // Constants
  REGISTRY_VERSION,
  REGISTRY_NAMESPACE,
  CORE_SDKS,
  
  // Class
  SovereignRegistry,
  
  // Global registry
  globalRegistry,
  
  // Helper functions
  createRegistry,
  publish,
  install,
  listPackages,
  getPackage,
};

export default {
  REGISTRY_VERSION,
  REGISTRY_NAMESPACE,
  CORE_SDKS,
  SovereignRegistry,
  globalRegistry,
  createRegistry,
  publish,
  install,
  listPackages,
  getPackage,
};
