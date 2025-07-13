# Rate Limiting Strategies for E-Commerce API

## Rate Limiting Architecture

### Multi-Tier Rate Limiting Approach

#### 1. API Gateway Level (Global Limits)
- **DDoS Protection**: 10,000 requests/minute per IP
- **Burst Protection**: 100 requests/second per IP
- **Geographic Limits**: Country-specific limits for risk mitigation

#### 2. Service Level (Per-Service Limits)
- **User Service**: Authentication-heavy, lower limits
- **Product Service**: Read-heavy, higher limits
- **Payment Service**: Transaction-critical, strict limits
- **Cart Service**: Session-based, moderate limits

#### 3. User Tier Level (Per-User Limits)
- **Guest Users**: Basic access limits
- **Registered Customers**: Standard limits
- **Premium Customers**: Enhanced limits
- **Partners/Vendors**: Business-level limits
- **Admin Users**: Administrative limits

#### 4. Endpoint Level (Per-Operation Limits)
- **Read Operations**: Higher limits
- **Write Operations**: Lower limits
- **Critical Operations**: Strictest limits

## User Tier Definitions and Limits

### Guest Users (Unauthenticated)
```yaml
guest_users:
  identification: "IP Address + Device Fingerprint"
  limits:
    global: "1,000 requests/hour"
    burst: "50 requests/minute"
    concurrent: "10 connections"
  
  endpoint_limits:
    # Product browsing
    "GET /products": "300 requests/hour"
    "GET /categories": "100 requests/hour"
    "GET /products/search": "200 requests/hour"
    
    # Cart operations (session-based)
    "POST /cart/sessions": "20 requests/hour"
    "GET /cart/sessions/*": "200 requests/hour"
    "PUT /cart/sessions/*": "100 requests/hour"
    
    # Registration
    "POST /auth/register": "5 requests/hour"
    "POST /auth/verify-email": "10 requests/hour"
    
    # Prohibited endpoints
    "POST /orders": "forbidden"
    "GET /profile": "forbidden"
    "POST /reviews": "forbidden"
  
  restrictions:
    - "No order placement"
    - "No account operations"
    - "Limited cart session duration (1 hour)"
    - "No access to premium content"
```

### Registered Customers (Basic Tier)
```yaml
basic_customers:
  identification: "User ID from JWT token"
  limits:
    global: "5,000 requests/hour"
    burst: "100 requests/minute"
    concurrent: "20 connections"
  
  endpoint_limits:
    # Product operations
    "GET /products": "1,000 requests/hour"
    "GET /categories": "200 requests/hour"
    "GET /products/search": "500 requests/hour"
    "POST /products/*/reviews": "10 requests/day"
    
    # Account operations
    "GET /profile": "100 requests/hour"
    "PUT /profile": "20 requests/hour"
    "GET /orders": "200 requests/hour"
    "POST /orders": "50 requests/day"
    
    # Cart and wishlist
    "GET /cart": "500 requests/hour"
    "POST /cart/items": "200 requests/hour"
    "GET /wishlist": "100 requests/hour"
    "POST /wishlist/items": "100 requests/hour"
    
    # Payment operations
    "POST /payments/intents": "100 requests/day"
    "GET /payment-methods": "50 requests/hour"
    "POST /payment-methods": "10 requests/day"
    
    # Notifications
    "GET /notifications": "200 requests/hour"
    
  enhanced_features:
    - "Order placement and tracking"
    - "Review submission"
    - "Wishlist management"
    - "Basic customer support"
```

### Premium Customers (Premium Tier)
```yaml
premium_customers:
  identification: "User ID + Premium Flag in JWT"
  limits:
    global: "10,000 requests/hour"
    burst: "200 requests/minute"
    concurrent: "50 connections"
  
  endpoint_limits:
    # Enhanced product access
    "GET /products": "2,000 requests/hour"
    "GET /products/recommendations": "200 requests/hour"
    "GET /products/premium": "500 requests/hour"
    "POST /products/*/reviews": "20 requests/day"
    
    # Account operations
    "GET /profile": "200 requests/hour"
    "PUT /profile": "50 requests/hour"
    "GET /orders": "500 requests/hour"
    "POST /orders": "100 requests/day"
    
    # Enhanced cart operations
    "GET /cart": "1,000 requests/hour"
    "POST /cart/items": "500 requests/hour"
    "POST /cart/merge": "50 requests/hour"
    
    # Priority payment processing
    "POST /payments/intents": "200 requests/day"
    "GET /payment-methods": "100 requests/hour"
    "POST /payment-methods": "20 requests/day"
    
    # Analytics access
    "GET /analytics/user-insights": "100 requests/hour"
    
  enhanced_features:
    - "Priority order processing"
    - "Early access to products"
    - "Enhanced recommendations"
    - "Priority customer support"
    - "Advanced analytics"
```

### Business Partners/Vendors
```yaml
business_partners:
  identification: "Partner API Key + User ID"
  limits:
    global: "50,000 requests/hour"
    burst: "500 requests/minute"
    concurrent: "100 connections"
  
  endpoint_limits:
    # Product management
    "GET /products": "5,000 requests/hour"
    "POST /products": "100 requests/hour"
    "PUT /products/*": "200 requests/hour"
    "DELETE /products/*": "50 requests/hour"
    
    # Inventory management
    "GET /inventory/*": "2,000 requests/hour"
    "PUT /inventory/*": "500 requests/hour"
    "POST /inventory/reserve": "1,000 requests/hour"
    
    # Order management
    "GET /orders": "2,000 requests/hour"
    "PUT /orders/*/status": "500 requests/hour"
    
    # Analytics and reporting
    "GET /analytics/sales": "200 requests/hour"
    "GET /analytics/revenue": "100 requests/hour"
    
  enhanced_features:
    - "Bulk operations"
    - "Webhook endpoints"
    - "Advanced analytics"
    - "Priority API support"
```

### Administrative Users
```yaml
admin_users:
  identification: "Admin Role in JWT + Admin API Key"
  limits:
    global: "100,000 requests/hour"
    burst: "1,000 requests/minute"
    concurrent: "200 connections"
  
  endpoint_limits:
    # User management
    "GET /users": "1,000 requests/hour"
    "PUT /users/*/status": "200 requests/hour"
    "DELETE /users/*": "50 requests/hour"
    
    # System operations
    "GET /admin/*": "5,000 requests/hour"
    "POST /admin/*": "1,000 requests/hour"
    "PUT /admin/*": "1,000 requests/hour"
    
    # Analytics and monitoring
    "GET /analytics/*": "unlimited"
    "GET /monitoring/*": "unlimited"
    
  special_privileges:
    - "No rate limiting on read operations"
    - "Elevated limits on critical operations"
    - "System monitoring access"
    - "Emergency override capabilities"
```

## Rate Limiting Implementation

### Redis-Based Rate Limiting
```typescript
interface RateLimitConfig {
  windowSize: number; // Time window in seconds
  maxRequests: number; // Max requests in window
  burstLimit: number; // Burst allowance
  blockDuration: number; // Block duration on limit exceeded
}

class RedisRateLimiter {
  async checkLimit(
    identifier: string,
    config: RateLimitConfig
  ): Promise<RateLimitResult> {
    const key = `rate_limit:${identifier}`;
    const now = Date.now();
    const windowStart = now - (config.windowSize * 1000);
    
    // Sliding window log implementation
    await this.redis.zremrangebyscore(key, 0, windowStart);
    const currentCount = await this.redis.zcard(key);
    
    if (currentCount >= config.maxRequests) {
      return {
        allowed: false,
        remainingRequests: 0,
        resetTime: windowStart + (config.windowSize * 1000),
        retryAfter: config.blockDuration
      };
    }
    
    await this.redis.zadd(key, now, `${now}-${Math.random()}`);
    await this.redis.expire(key, config.windowSize);
    
    return {
      allowed: true,
      remainingRequests: config.maxRequests - currentCount - 1,
      resetTime: windowStart + (config.windowSize * 1000)
    };
  }
}
```

### Distributed Rate Limiting
```typescript
interface DistributedRateLimitConfig {
  algorithm: 'sliding_window' | 'token_bucket' | 'fixed_window';
  storage: 'redis' | 'hazelcast' | 'etcd';
  consistency: 'eventual' | 'strong';
  syncInterval: number; // Sync interval for distributed counters
}

// Token bucket algorithm for burst handling
class TokenBucketRateLimiter {
  async checkLimit(
    identifier: string,
    bucketSize: number,
    refillRate: number
  ): Promise<RateLimitResult> {
    const key = `token_bucket:${identifier}`;
    const now = Date.now();
    
    const bucket = await this.redis.hmget(key, 'tokens', 'last_refill');
    let tokens = parseFloat(bucket[0]) || bucketSize;
    let lastRefill = parseInt(bucket[1]) || now;
    
    // Calculate tokens to add based on time elapsed
    const elapsed = (now - lastRefill) / 1000;
    const tokensToAdd = elapsed * refillRate;
    tokens = Math.min(bucketSize, tokens + tokensToAdd);
    
    if (tokens < 1) {
      return {
        allowed: false,
        remainingRequests: 0,
        retryAfter: (1 - tokens) / refillRate
      };
    }
    
    tokens -= 1;
    await this.redis.hmset(key, 'tokens', tokens, 'last_refill', now);
    await this.redis.expire(key, 3600); // 1 hour TTL
    
    return {
      allowed: true,
      remainingRequests: Math.floor(tokens)
    };
  }
}
```

## Dynamic Rate Limiting

### Adaptive Limits Based on System Load
```typescript
interface AdaptiveRateLimiting {
  triggers: {
    cpu_usage: 80; // Reduce limits when CPU > 80%
    memory_usage: 85; // Reduce limits when memory > 85%
    response_time: 2000; // Reduce limits when response time > 2s
    error_rate: 5; // Reduce limits when error rate > 5%
  };
  
  adjustments: {
    high_load: 0.5; // Reduce limits to 50% under high load
    medium_load: 0.75; // Reduce limits to 75% under medium load
    normal_load: 1.0; // Normal limits
    low_load: 1.25; // Increase limits by 25% under low load
  };
}
```

### User Behavior-Based Adjustments
```typescript
interface BehaviorBasedLimits {
  good_actors: {
    criteria: "No violations in 30 days + High engagement";
    bonus_multiplier: 1.5;
    additional_burst: 50;
  };
  
  suspicious_actors: {
    criteria: "Multiple violations + Unusual patterns";
    penalty_multiplier: 0.25;
    additional_monitoring: true;
  };
  
  new_users: {
    criteria: "Account age < 7 days";
    conservative_limits: true;
    gradual_increase: "10% per day";
  };
}
```

## Rate Limit Headers

### Standard Rate Limit Headers
```http
# Current rate limit status
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 456
X-RateLimit-Reset: 1609459200
X-RateLimit-Reset-After: 3600

# Rate limit scope
X-RateLimit-Scope: user
X-RateLimit-Resource: /api/products

# Retry information
Retry-After: 3600

# Additional context
X-RateLimit-Policy: sliding-window
X-RateLimit-Tier: premium
```

### Custom Headers for Enhanced Information
```http
# Burst allowance
X-RateLimit-Burst-Limit: 100
X-RateLimit-Burst-Remaining: 23

# Multiple limit tracking
X-RateLimit-Hourly: 1000
X-RateLimit-Daily: 10000
X-RateLimit-Monthly: 100000

# Cost-based limiting
X-RateLimit-Cost: 1
X-RateLimit-Cost-Remaining: 4567
```

## Rate Limiting Bypass and Overrides

### Emergency Override System
```typescript
interface EmergencyOverride {
  conditions: [
    'system_maintenance',
    'critical_business_operation',
    'security_incident_response',
    'data_migration'
  ];
  
  override_levels: {
    level_1: "50% increase in limits";
    level_2: "100% increase in limits";
    level_3: "Remove all limits for specific operations";
    level_4: "Global rate limit suspension";
  };
  
  approval_required: {
    level_1: "team_lead";
    level_2: "engineering_manager";
    level_3: "director";
    level_4: "cto";
  };
  
  duration_limits: {
    level_1: "1 hour";
    level_2: "30 minutes";
    level_3: "15 minutes";
    level_4: "5 minutes";
  };
}
```

### Whitelist and Blacklist Management
```typescript
interface AccessControl {
  whitelist: {
    ip_addresses: string[];
    user_ids: string[];
    api_keys: string[];
    purposes: [
      'partner_integration',
      'monitoring_tools',
      'internal_services',
      'emergency_access'
    ];
  };
  
  blacklist: {
    ip_addresses: string[];
    user_ids: string[];
    patterns: string[];
    reasons: [
      'abuse_detected',
      'security_violation',
      'terms_violation',
      'fraud_suspicion'
    ];
    auto_expiry: "24 hours";
  };
}
```

## Monitoring and Alerting

### Rate Limit Metrics
```typescript
interface RateLimitMetrics {
  requests_allowed: number;
  requests_denied: number;
  average_response_time: number;
  top_limited_endpoints: string[];
  top_limited_users: string[];
  limit_violations_by_tier: Record<string, number>;
  burst_usage_patterns: Record<string, number>;
}
```

### Alerting Configuration
```yaml
alerts:
  high_denial_rate:
    condition: "denial_rate > 10%"
    severity: "warning"
    notification: ["engineering-team"]
  
  rate_limit_abuse:
    condition: "user_violations > 100/hour"
    severity: "critical"
    notification: ["security-team", "engineering-team"]
  
  system_overload:
    condition: "adaptive_limits_triggered"
    severity: "critical"
    notification: ["ops-team", "engineering-team"]
  
  api_gateway_issues:
    condition: "gateway_errors > 5%"
    severity: "critical"
    notification: ["ops-team"]
```