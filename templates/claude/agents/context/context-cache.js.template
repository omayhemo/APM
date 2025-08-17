/**
 * Context Caching System
 * Reduces redundancy by caching and reusing common context
 * Implements TTL and intelligent cache management
 */

class ContextCache {
  constructor(options = {}) {
    this.cache = new Map();
    this.maxSize = options.maxSize || 100; // Maximum cache entries
    this.defaultTTL = options.defaultTTL || 900000; // 15 minutes default
    this.cleanupInterval = options.cleanupInterval || 300000; // 5 minutes
    
    // Start periodic cleanup
    this.startCleanup();
    
    // Track metrics
    this.metrics = {
      hits: 0,
      misses: 0,
      evictions: 0,
      totalSaved: 0
    };
  }
  
  // Generate cache key from context parameters
  generateKey(taskType, targetAgent, taskDescription) {
    // Create a stable key from parameters
    const keyComponents = [
      taskType,
      targetAgent,
      // Hash task description to handle variations
      this.hashString(taskDescription)
    ];
    
    return keyComponents.join(':');
  }
  
  // Get cached context
  get(key) {
    const entry = this.cache.get(key);
    
    if (!entry) {
      this.metrics.misses++;
      return null;
    }
    
    // Check if expired
    if (this.isExpired(entry)) {
      this.cache.delete(key);
      this.metrics.misses++;
      return null;
    }
    
    // Update access time and hit count
    entry.lastAccessed = Date.now();
    entry.hits++;
    this.metrics.hits++;
    
    return entry.context;
  }
  
  // Set context in cache
  set(key, context, ttl = null) {
    // Check cache size limit
    if (this.cache.size >= this.maxSize) {
      this.evictLRU();
    }
    
    const entry = {
      context: this.cloneContext(context),
      created: Date.now(),
      lastAccessed: Date.now(),
      ttl: ttl || this.defaultTTL,
      hits: 0,
      size: this.estimateSize(context)
    };
    
    this.cache.set(key, entry);
    this.metrics.totalSaved += entry.size;
    
    return true;
  }
  
  // Get or compute context
  getOrCompute(key, computeFn, ttl = null) {
    const cached = this.get(key);
    if (cached) {
      return { context: cached, cached: true };
    }
    
    const computed = computeFn();
    this.set(key, computed, ttl);
    
    return { context: computed, cached: false };
  }
  
  // Check if entry is expired
  isExpired(entry) {
    return Date.now() - entry.created > entry.ttl;
  }
  
  // Check if entry is stale (for external checking)
  isStale(entry) {
    // Consider stale if not accessed for half the TTL
    const staleThreshold = entry.ttl / 2;
    return Date.now() - entry.lastAccessed > staleThreshold;
  }
  
  // Evict least recently used entry
  evictLRU() {
    let oldestKey = null;
    let oldestTime = Date.now();
    
    for (const [key, entry] of this.cache.entries()) {
      if (entry.lastAccessed < oldestTime) {
        oldestTime = entry.lastAccessed;
        oldestKey = key;
      }
    }
    
    if (oldestKey) {
      this.cache.delete(oldestKey);
      this.metrics.evictions++;
    }
  }
  
  // Start periodic cleanup
  startCleanup() {
    this.cleanupTimer = setInterval(() => {
      this.cleanup();
    }, this.cleanupInterval);
  }
  
  // Clean up expired entries
  cleanup() {
    const now = Date.now();
    const keysToDelete = [];
    
    for (const [key, entry] of this.cache.entries()) {
      if (now - entry.created > entry.ttl) {
        keysToDelete.push(key);
      }
    }
    
    keysToDelete.forEach(key => {
      this.cache.delete(key);
    });
  }
  
  // Get cache metrics
  getMetrics() {
    const hitRate = this.metrics.hits + this.metrics.misses > 0
      ? (this.metrics.hits / (this.metrics.hits + this.metrics.misses)) * 100
      : 0;
    
    return {
      size: this.cache.size,
      hits: this.metrics.hits,
      misses: this.metrics.misses,
      hitRate: `${hitRate.toFixed(1)}%`,
      evictions: this.metrics.evictions,
      totalSaved: `${(this.metrics.totalSaved / 1024).toFixed(1)}KB`,
      avgEntrySize: this.cache.size > 0
        ? `${(this.getTotalSize() / this.cache.size / 1024).toFixed(1)}KB`
        : '0KB'
    };
  }
  
  // Get total size of cached data
  getTotalSize() {
    let total = 0;
    for (const entry of this.cache.values()) {
      total += entry.size;
    }
    return total;
  }
  
  // Estimate size of context object
  estimateSize(obj) {
    return JSON.stringify(obj).length;
  }
  
  // Deep clone context to prevent mutations
  cloneContext(context) {
    return JSON.parse(JSON.stringify(context));
  }
  
  // Simple string hash for cache keys
  hashString(str) {
    let hash = 0;
    for (let i = 0; i < str.length; i++) {
      const char = str.charCodeAt(i);
      hash = ((hash << 5) - hash) + char;
      hash = hash & hash; // Convert to 32-bit integer
    }
    return hash.toString(16);
  }
  
  // Clear cache
  clear() {
    this.cache.clear();
    this.metrics = {
      hits: 0,
      misses: 0,
      evictions: 0,
      totalSaved: 0
    };
  }
  
  // Stop cleanup timer
  destroy() {
    if (this.cleanupTimer) {
      clearInterval(this.cleanupTimer);
    }
    this.clear();
  }
}

// Singleton instance for shared context cache
let sharedCache = null;

// Get or create shared cache instance
function getSharedCache() {
  if (!sharedCache) {
    sharedCache = new ContextCache({
      maxSize: 200,
      defaultTTL: 1800000, // 30 minutes for shared cache
      cleanupInterval: 600000 // 10 minutes
    });
  }
  return sharedCache;
}

// Cache helper functions
const contextCache = {
  // Get cached context
  getCachedContext(key) {
    return getSharedCache().get(key);
  },
  
  // Cache context
  cacheContext(key, context, ttl = null) {
    return getSharedCache().set(key, context, ttl);
  },
  
  // Get or compute with caching
  getOrCompute(key, computeFn, ttl = null) {
    return getSharedCache().getOrCompute(key, computeFn, ttl);
  },
  
  // Generate cache key
  generateKey(taskType, targetAgent, taskDescription) {
    return getSharedCache().generateKey(taskType, targetAgent, taskDescription);
  },
  
  // Get cache metrics
  getMetrics() {
    return getSharedCache().getMetrics();
  },
  
  // Clear cache
  clear() {
    return getSharedCache().clear();
  }
};

module.exports = {
  ContextCache,
  contextCache,
  getSharedCache
};