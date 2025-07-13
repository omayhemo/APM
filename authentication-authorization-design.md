# Authentication and Authorization Design

## Authentication Strategy

### Multi-Modal Authentication Approach

#### 1. JWT (JSON Web Tokens) - Primary Authentication
- **Access Tokens**: Short-lived (15 minutes) for API access
- **Refresh Tokens**: Long-lived (7 days) for token renewal
- **Algorithm**: RS256 (RSA Signature with SHA-256)
- **Claims Structure**:
```json
{
  "iss": "ecommerce.com",
  "sub": "user_id",
  "aud": "ecommerce-api",
  "exp": 1609459200,
  "iat": 1609458300,
  "jti": "unique_token_id",
  "scope": "read:profile write:cart",
  "role": "customer",
  "tier": "premium",
  "session_id": "session_uuid"
}
```

#### 2. OAuth 2.0 Integration
- **Google OAuth 2.0**: Social login integration
- **Facebook OAuth 2.0**: Social login integration
- **Apple Sign-In**: iOS/macOS integration
- **OpenID Connect**: For identity layer

#### 3. API Key Authentication
- **Partner APIs**: For third-party integrations
- **Webhook Endpoints**: For external service notifications
- **Admin Tools**: For internal system access

### Authentication Flow Diagrams

#### Standard Login Flow
```
1. User → POST /auth/login (email, password)
2. API → Validate credentials
3. API → Generate JWT tokens
4. API → Return access_token + refresh_token
5. Client → Store tokens securely
6. Client → Use access_token in Authorization header
```

#### OAuth Flow
```
1. User → Click "Login with Google"
2. Client → Redirect to Google OAuth
3. Google → User grants permission
4. Google → Redirect to callback URL with code
5. API → Exchange code for Google access token
6. API → Fetch user profile from Google
7. API → Create/update user account
8. API → Generate internal JWT tokens
9. API → Return tokens to client
```

#### Token Refresh Flow
```
1. Client → Access token expires (401 response)
2. Client → POST /auth/refresh-token (refresh_token)
3. API → Validate refresh token
4. API → Generate new access token
5. API → Return new access_token
6. Client → Retry original request with new token
```

## Authorization Framework

### Role-Based Access Control (RBAC)

#### User Roles
```yaml
roles:
  guest:
    description: "Unauthenticated users"
    permissions:
      - read:products
      - read:categories
      - create:cart_session
  
  customer:
    description: "Registered customers"
    inherits: guest
    permissions:
      - read:profile
      - write:profile
      - read:orders
      - write:orders
      - read:cart
      - write:cart
      - read:wishlist
      - write:wishlist
      - write:reviews
  
  premium_customer:
    description: "Premium tier customers"
    inherits: customer
    permissions:
      - read:premium_content
      - early_access:products
      - priority_support
  
  vendor:
    description: "Product vendors"
    permissions:
      - read:vendor_products
      - write:vendor_products
      - read:vendor_orders
      - read:vendor_analytics
  
  admin:
    description: "System administrators"
    permissions:
      - "*" # All permissions
  
  moderator:
    description: "Content moderators"
    permissions:
      - read:all_reviews
      - moderate:reviews
      - moderate:users
      - read:reports
```

### Permission-Based Authorization

#### Permission Naming Convention
```
{action}:{resource}:{scope?}
```

Examples:
- `read:products` - Read product catalog
- `write:orders:own` - Write user's own orders
- `admin:users:all` - Admin access to all users
- `moderate:reviews` - Moderate product reviews

#### Resource-Level Permissions
```yaml
permissions:
  # Product Management
  - read:products
  - write:products
  - delete:products
  - moderate:products
  
  # User Management
  - read:profile:own
  - write:profile:own
  - read:users:all
  - admin:users:all
  
  # Order Management
  - read:orders:own
  - write:orders:own
  - read:orders:all
  - admin:orders:all
  
  # Financial Operations
  - read:payments:own
  - process:payments
  - refund:payments
  - read:financial_reports
```

### Authorization Middleware

#### JWT Verification Middleware
```typescript
interface AuthMiddleware {
  verifyToken(token: string): Promise<UserContext>;
  checkPermission(permission: string): boolean;
  checkRole(role: string): boolean;
  checkResourceAccess(resource: string, resourceId: string): boolean;
}

interface UserContext {
  userId: string;
  role: string;
  permissions: string[];
  tier: string;
  sessionId: string;
}
```

#### Permission Checking Examples
```typescript
// Check if user can read all orders (admin only)
@RequirePermission('read:orders:all')
async getAllOrders() { ... }

// Check if user can access their own order
@RequireResourceAccess('orders')
async getOrder(@Param('orderId') orderId: string) { ... }

// Check user tier for premium features
@RequireTier('premium')
async getPremiumContent() { ... }
```

## Security Implementation

### Token Security

#### Access Token Security
```typescript
interface AccessTokenConfig {
  algorithm: 'RS256';
  expiresIn: '15m';
  issuer: 'ecommerce.com';
  audience: 'ecommerce-api';
  keyRotation: '30d';
}
```

#### Refresh Token Security
```typescript
interface RefreshTokenConfig {
  algorithm: 'HS256';
  expiresIn: '7d';
  storage: 'database'; // Store in database with user mapping
  rotateOnUse: true; // Generate new refresh token on each use
  revokeOnSuspiciousActivity: true;
}
```

### Security Headers and Middleware

#### Required Security Headers
```http
Authorization: Bearer <access_token>
X-API-Version: v1
X-Request-ID: unique_request_id
X-Client-Version: 1.2.3
X-Device-ID: device_identifier (for mobile apps)
```

#### Security Middleware Stack
```typescript
const securityMiddleware = [
  helmet(), // Security headers
  rateLimit(), // Rate limiting
  jwtVerification(), // Token validation
  permissionCheck(), // Authorization
  auditLog(), // Security logging
  csrfProtection(), // CSRF protection
];
```

### Multi-Factor Authentication (MFA)

#### MFA Implementation
```typescript
interface MFAConfig {
  methods: ['totp', 'sms', 'email'];
  required_for: ['admin', 'financial_operations'];
  backup_codes: true;
  session_duration_with_mfa: '24h';
  session_duration_without_mfa: '2h';
}
```

#### MFA Flow
```
1. User → Login with username/password
2. API → Validate credentials
3. API → Check if MFA required for user/operation
4. API → Send MFA challenge (SMS/Email/TOTP)
5. User → Provide MFA code
6. API → Validate MFA code
7. API → Generate JWT with MFA claim
8. API → Return tokens
```

## Session Management

### Session Storage Strategy
```typescript
interface SessionConfig {
  storage: 'redis'; // Distributed session storage
  ttl: 3600; // 1 hour session timeout
  sliding_expiration: true; // Extend on activity
  concurrent_sessions: 3; // Max concurrent sessions
  device_tracking: true; // Track session devices
}
```

### Session Data Structure
```typescript
interface SessionData {
  sessionId: string;
  userId: string;
  deviceInfo: {
    userAgent: string;
    ipAddress: string;
    deviceId: string;
    location?: GeoLocation;
  };
  authMethods: ['password', 'mfa'?];
  lastActivity: Date;
  permissions: string[];
  metadata: Record<string, any>;
}
```

## OAuth Provider Configurations

### Google OAuth Configuration
```typescript
interface GoogleOAuthConfig {
  clientId: process.env.GOOGLE_OAUTH_CLIENT_ID;
  clientSecret: process.env.GOOGLE_OAUTH_CLIENT_SECRET;
  redirectUri: 'https://api.ecommerce.com/auth/oauth/google/callback';
  scopes: ['openid', 'profile', 'email'];
  responseType: 'code';
  accessType: 'offline';
}
```

### Facebook OAuth Configuration
```typescript
interface FacebookOAuthConfig {
  appId: process.env.FACEBOOK_APP_ID;
  appSecret: process.env.FACEBOOK_APP_SECRET;
  redirectUri: 'https://api.ecommerce.com/auth/oauth/facebook/callback';
  scopes: ['email', 'public_profile'];
  responseType: 'code';
}
```

## API Key Management

### API Key Types
```typescript
enum ApiKeyType {
  PARTNER = 'partner',
  WEBHOOK = 'webhook', 
  INTERNAL = 'internal',
  MOBILE_APP = 'mobile_app'
}

interface ApiKey {
  id: string;
  name: string;
  type: ApiKeyType;
  key: string; // Hashed in database
  permissions: string[];
  rateLimit: RateLimitConfig;
  expiresAt?: Date;
  isActive: boolean;
  lastUsed?: Date;
  metadata: Record<string, any>;
}
```

### API Key Usage
```http
# Header-based authentication
X-API-Key: your_api_key_here

# Query parameter (less secure, for webhooks only)
GET /api/webhooks/stripe?api_key=your_api_key_here
```

## Security Best Practices

### Token Storage Recommendations

#### Web Applications
```typescript
// Use secure, httpOnly cookies for refresh tokens
const refreshTokenCookie = {
  httpOnly: true,
  secure: true, // HTTPS only
  sameSite: 'strict',
  maxAge: 7 * 24 * 60 * 60 * 1000, // 7 days
  path: '/auth/refresh'
};

// Store access tokens in memory (not localStorage)
// Use secure storage libraries for sensitive data
```

#### Mobile Applications
```typescript
// Use platform-specific secure storage
interface SecureStorage {
  ios: 'Keychain Services';
  android: 'Android Keystore';
  encryption: 'AES-256';
  biometric_protection: true;
}
```

### Security Monitoring

#### Suspicious Activity Detection
```typescript
interface SecurityMonitoring {
  failed_login_attempts: {
    threshold: 5;
    window: '15m';
    action: 'account_lock';
  };
  
  unusual_access_patterns: {
    different_country: 'alert';
    different_device: 'mfa_required';
    concurrent_sessions_exceeded: 'revoke_oldest';
  };
  
  token_anomalies: {
    token_reuse: 'revoke_session';
    expired_token_usage: 'security_log';
    malformed_token: 'rate_limit_source';
  };
}
```

#### Audit Logging
```typescript
interface AuditLog {
  timestamp: Date;
  userId?: string;
  sessionId?: string;
  action: string;
  resource: string;
  ipAddress: string;
  userAgent: string;
  outcome: 'success' | 'failure';
  metadata: Record<string, any>;
}
```