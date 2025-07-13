# Error Handling Patterns and Response Standards

## Error Response Philosophy

### Consistent Error Structure
All API errors follow a standardized response format to ensure predictable client integration and debugging:

```json
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "Human-readable error message",
    "details": [...],
    "timestamp": "2024-01-15T10:30:00Z",
    "requestId": "req_123456789",
    "documentation": "https://docs.ecommerce.com/errors/ERROR_CODE"
  }
}
```

### Error Design Principles
1. **Consistency**: All errors follow the same structure
2. **Clarity**: Error messages are clear and actionable
3. **Security**: No sensitive information in error responses
4. **Debugging**: Include request ID for troubleshooting
5. **Documentation**: Link to relevant documentation
6. **Internationalization**: Support for multiple languages

## HTTP Status Code Standards

### Success Codes (2xx)
```typescript
enum SuccessStatus {
  OK = 200,                    // Successful GET, PUT, PATCH
  CREATED = 201,               // Successful POST (resource creation)
  ACCEPTED = 202,              // Async operation started
  NO_CONTENT = 204,            // Successful DELETE, or empty response
  PARTIAL_CONTENT = 206        // Partial response (pagination, range requests)
}
```

### Client Error Codes (4xx)
```typescript
enum ClientErrorStatus {
  BAD_REQUEST = 400,           // Invalid request syntax or data
  UNAUTHORIZED = 401,          // Authentication required
  PAYMENT_REQUIRED = 402,      // Payment failure
  FORBIDDEN = 403,             // Authorization failure
  NOT_FOUND = 404,             // Resource not found
  METHOD_NOT_ALLOWED = 405,    // HTTP method not supported
  NOT_ACCEPTABLE = 406,        // Content negotiation failure
  CONFLICT = 409,              // Resource conflict (duplicate)
  GONE = 410,                  // Resource permanently deleted
  PAYLOAD_TOO_LARGE = 413,     // Request body too large
  UNSUPPORTED_MEDIA_TYPE = 415, // Content-Type not supported
  UNPROCESSABLE_ENTITY = 422,  // Validation errors
  TOO_MANY_REQUESTS = 429,     // Rate limit exceeded
  UNAVAILABLE_FOR_LEGAL_REASONS = 451 // Legal compliance
}
```

### Server Error Codes (5xx)
```typescript
enum ServerErrorStatus {
  INTERNAL_SERVER_ERROR = 500, // Generic server error
  NOT_IMPLEMENTED = 501,       // Feature not implemented
  BAD_GATEWAY = 502,           // Upstream service error
  SERVICE_UNAVAILABLE = 503,   // Service temporarily down
  GATEWAY_TIMEOUT = 504,       // Upstream service timeout
  INSUFFICIENT_STORAGE = 507   // Server storage full
}
```

## Error Classification System

### Error Categories
```typescript
enum ErrorCategory {
  VALIDATION = 'validation',
  AUTHENTICATION = 'authentication',
  AUTHORIZATION = 'authorization',
  BUSINESS_LOGIC = 'business_logic',
  EXTERNAL_SERVICE = 'external_service',
  SYSTEM = 'system',
  RATE_LIMITING = 'rate_limiting',
  DEPRECATED = 'deprecated'
}
```

### Error Severity Levels
```typescript
enum ErrorSeverity {
  LOW = 'low',        // Minor issues, non-blocking
  MEDIUM = 'medium',  // Significant issues, some functionality affected
  HIGH = 'high',      // Major issues, core functionality affected
  CRITICAL = 'critical' // System-wide issues, service unavailable
}
```

## Detailed Error Patterns

### 1. Validation Errors (400 Bad Request)
```typescript
interface ValidationError {
  code: 'VALIDATION_ERROR';
  message: 'Invalid input data';
  details: ValidationDetail[];
}

interface ValidationDetail {
  field: string;
  value?: any;
  message: string;
  code: string;
  constraint?: string;
}
```

**Example Response:**
```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input data",
    "details": [
      {
        "field": "email",
        "value": "invalid-email",
        "message": "Email must be a valid email address",
        "code": "INVALID_EMAIL_FORMAT",
        "constraint": "email"
      },
      {
        "field": "password",
        "message": "Password must be at least 8 characters long",
        "code": "PASSWORD_TOO_SHORT",
        "constraint": "minLength"
      },
      {
        "field": "age",
        "value": 15,
        "message": "Age must be at least 18",
        "code": "AGE_BELOW_MINIMUM",
        "constraint": "minimum"
      }
    ],
    "timestamp": "2024-01-15T10:30:00Z",
    "requestId": "req_123456789"
  }
}
```

### 2. Authentication Errors (401 Unauthorized)
```typescript
enum AuthenticationErrorCode {
  MISSING_TOKEN = 'MISSING_TOKEN',
  INVALID_TOKEN = 'INVALID_TOKEN',
  EXPIRED_TOKEN = 'EXPIRED_TOKEN',
  MALFORMED_TOKEN = 'MALFORMED_TOKEN',
  INVALID_CREDENTIALS = 'INVALID_CREDENTIALS',
  ACCOUNT_LOCKED = 'ACCOUNT_LOCKED',
  ACCOUNT_DISABLED = 'ACCOUNT_DISABLED',
  EMAIL_NOT_VERIFIED = 'EMAIL_NOT_VERIFIED',
  MFA_REQUIRED = 'MFA_REQUIRED',
  INVALID_MFA_CODE = 'INVALID_MFA_CODE'
}
```

**Examples:**
```json
{
  "success": false,
  "error": {
    "code": "EXPIRED_TOKEN",
    "message": "Authentication token has expired",
    "details": {
      "expiredAt": "2024-01-15T10:25:00Z",
      "tokenType": "access_token"
    },
    "timestamp": "2024-01-15T10:30:00Z",
    "requestId": "req_123456789",
    "documentation": "https://docs.ecommerce.com/auth/token-refresh"
  }
}
```

```json
{
  "success": false,
  "error": {
    "code": "MFA_REQUIRED",
    "message": "Multi-factor authentication required",
    "details": {
      "availableMethods": ["sms", "email", "authenticator"],
      "sessionId": "session_abc123"
    },
    "timestamp": "2024-01-15T10:30:00Z",
    "requestId": "req_123456789"
  }
}
```

### 3. Authorization Errors (403 Forbidden)
```typescript
enum AuthorizationErrorCode {
  INSUFFICIENT_PERMISSIONS = 'INSUFFICIENT_PERMISSIONS',
  RESOURCE_ACCESS_DENIED = 'RESOURCE_ACCESS_DENIED',
  OPERATION_NOT_ALLOWED = 'OPERATION_NOT_ALLOWED',
  ACCOUNT_SUSPENDED = 'ACCOUNT_SUSPENDED',
  FEATURE_NOT_AVAILABLE = 'FEATURE_NOT_AVAILABLE',
  GEOGRAPHIC_RESTRICTION = 'GEOGRAPHIC_RESTRICTION',
  TIME_RESTRICTION = 'TIME_RESTRICTION'
}
```

**Example:**
```json
{
  "success": false,
  "error": {
    "code": "INSUFFICIENT_PERMISSIONS",
    "message": "You don't have permission to perform this action",
    "details": {
      "requiredPermissions": ["admin:users:write"],
      "currentPermissions": ["read:profile", "write:orders"],
      "resource": "users",
      "action": "update"
    },
    "timestamp": "2024-01-15T10:30:00Z",
    "requestId": "req_123456789"
  }
}
```

### 4. Business Logic Errors (422 Unprocessable Entity)
```typescript
enum BusinessLogicErrorCode {
  INSUFFICIENT_INVENTORY = 'INSUFFICIENT_INVENTORY',
  PRODUCT_UNAVAILABLE = 'PRODUCT_UNAVAILABLE',
  ORDER_ALREADY_PROCESSED = 'ORDER_ALREADY_PROCESSED',
  PAYMENT_ALREADY_CAPTURED = 'PAYMENT_ALREADY_CAPTURED',
  REFUND_NOT_ALLOWED = 'REFUND_NOT_ALLOWED',
  SHIPPING_NOT_AVAILABLE = 'SHIPPING_NOT_AVAILABLE',
  PROMO_CODE_INVALID = 'PROMO_CODE_INVALID',
  CART_EMPTY = 'CART_EMPTY',
  ORDER_TOTAL_MISMATCH = 'ORDER_TOTAL_MISMATCH'
}
```

**Examples:**
```json
{
  "success": false,
  "error": {
    "code": "INSUFFICIENT_INVENTORY",
    "message": "Not enough inventory available for requested quantity",
    "details": {
      "productId": "prod_123",
      "requestedQuantity": 5,
      "availableQuantity": 2,
      "sku": "SHOE-001"
    },
    "timestamp": "2024-01-15T10:30:00Z",
    "requestId": "req_123456789"
  }
}
```

### 5. External Service Errors (502/503/504)
```typescript
enum ExternalServiceErrorCode {
  PAYMENT_GATEWAY_ERROR = 'PAYMENT_GATEWAY_ERROR',
  SHIPPING_SERVICE_ERROR = 'SHIPPING_SERVICE_ERROR',
  INVENTORY_SERVICE_ERROR = 'INVENTORY_SERVICE_ERROR',
  EMAIL_SERVICE_ERROR = 'EMAIL_SERVICE_ERROR',
  SMS_SERVICE_ERROR = 'SMS_SERVICE_ERROR',
  EXTERNAL_API_TIMEOUT = 'EXTERNAL_API_TIMEOUT',
  EXTERNAL_API_UNAVAILABLE = 'EXTERNAL_API_UNAVAILABLE'
}
```

**Example:**
```json
{
  "success": false,
  "error": {
    "code": "PAYMENT_GATEWAY_ERROR",
    "message": "Payment processing temporarily unavailable",
    "details": {
      "provider": "stripe",
      "providerErrorCode": "service_error",
      "retryAfter": 30,
      "supportContact": "support@ecommerce.com"
    },
    "timestamp": "2024-01-15T10:30:00Z",
    "requestId": "req_123456789"
  }
}
```

### 6. Rate Limiting Errors (429 Too Many Requests)
```typescript
interface RateLimitError {
  code: 'RATE_LIMIT_EXCEEDED';
  message: string;
  details: {
    limit: number;
    remaining: number;
    resetTime: string;
    retryAfter: number;
    scope: 'user' | 'ip' | 'api_key';
  };
}
```

**Example:**
```json
{
  "success": false,
  "error": {
    "code": "RATE_LIMIT_EXCEEDED",
    "message": "Rate limit exceeded for your user tier",
    "details": {
      "limit": 1000,
      "remaining": 0,
      "resetTime": "2024-01-15T11:00:00Z",
      "retryAfter": 1800,
      "scope": "user",
      "tier": "basic"
    },
    "timestamp": "2024-01-15T10:30:00Z",
    "requestId": "req_123456789"
  }
}
```

## Error Handling Implementation

### Error Handler Middleware
```typescript
class ApiErrorHandler {
  static handle(error: Error, req: Request, res: Response, next: NextFunction) {
    const requestId = req.headers['x-request-id'] as string || generateRequestId();
    const timestamp = new Date().toISOString();
    
    // Log error for monitoring
    logger.error('API Error', {
      error: error.message,
      stack: error.stack,
      requestId,
      url: req.url,
      method: req.method,
      userId: req.user?.id,
      userAgent: req.headers['user-agent']
    });
    
    if (error instanceof ValidationError) {
      return res.status(400).json({
        success: false,
        error: {
          code: 'VALIDATION_ERROR',
          message: 'Invalid input data',
          details: error.details,
          timestamp,
          requestId
        }
      });
    }
    
    if (error instanceof AuthenticationError) {
      return res.status(401).json({
        success: false,
        error: {
          code: error.code,
          message: error.message,
          details: error.details,
          timestamp,
          requestId,
          documentation: `https://docs.ecommerce.com/errors/${error.code}`
        }
      });
    }
    
    if (error instanceof BusinessLogicError) {
      return res.status(422).json({
        success: false,
        error: {
          code: error.code,
          message: error.message,
          details: error.details,
          timestamp,
          requestId
        }
      });
    }
    
    // Generic server error
    res.status(500).json({
      success: false,
      error: {
        code: 'INTERNAL_SERVER_ERROR',
        message: 'An unexpected error occurred',
        timestamp,
        requestId,
        documentation: 'https://docs.ecommerce.com/support'
      }
    });
  }
}
```

### Custom Error Classes
```typescript
abstract class ApiError extends Error {
  abstract code: string;
  abstract statusCode: number;
  details?: any;
  
  constructor(message: string, details?: any) {
    super(message);
    this.details = details;
    this.name = this.constructor.name;
  }
}

class ValidationError extends ApiError {
  code = 'VALIDATION_ERROR';
  statusCode = 400;
  
  constructor(details: ValidationDetail[]) {
    super('Invalid input data');
    this.details = details;
  }
}

class AuthenticationError extends ApiError {
  statusCode = 401;
  
  constructor(code: string, message: string, details?: any) {
    super(message);
    this.code = code;
    this.details = details;
  }
}

class AuthorizationError extends ApiError {
  statusCode = 403;
  
  constructor(code: string, message: string, details?: any) {
    super(message);
    this.code = code;
    this.details = details;
  }
}

class BusinessLogicError extends ApiError {
  statusCode = 422;
  
  constructor(code: string, message: string, details?: any) {
    super(message);
    this.code = code;
    this.details = details;
  }
}

class ExternalServiceError extends ApiError {
  statusCode = 502;
  
  constructor(code: string, message: string, details?: any) {
    super(message);
    this.code = code;
    this.details = details;
  }
}
```

### Error Recovery Patterns

#### Circuit Breaker for External Services
```typescript
class ExternalServiceHandler {
  async callExternalService<T>(
    serviceName: string,
    operation: () => Promise<T>
  ): Promise<T> {
    try {
      return await this.circuitBreaker.execute(operation);
    } catch (error) {
      if (error instanceof TimeoutError) {
        throw new ExternalServiceError(
          'EXTERNAL_API_TIMEOUT',
          `${serviceName} service timeout`,
          { service: serviceName, timeout: true }
        );
      }
      
      if (error instanceof ServiceUnavailableError) {
        throw new ExternalServiceError(
          'EXTERNAL_API_UNAVAILABLE',
          `${serviceName} service unavailable`,
          { service: serviceName, retryAfter: 60 }
        );
      }
      
      throw error;
    }
  }
}
```

#### Graceful Degradation
```typescript
class ProductService {
  async getProduct(productId: string): Promise<Product> {
    try {
      // Try to get enhanced product data with reviews
      const [product, reviews] = await Promise.all([
        this.productRepository.findById(productId),
        this.reviewService.getProductReviews(productId)
      ]);
      
      return { ...product, reviews };
    } catch (error) {
      if (error instanceof ExternalServiceError) {
        // Fallback to basic product data without reviews
        logger.warn('Review service unavailable, returning basic product data', {
          productId,
          error: error.message
        });
        
        const product = await this.productRepository.findById(productId);
        return {
          ...product,
          reviews: {
            averageRating: null,
            totalReviews: 0,
            recentReviews: []
          }
        };
      }
      
      throw error;
    }
  }
}
```

## Error Monitoring and Alerting

### Error Metrics
```typescript
interface ErrorMetrics {
  totalErrors: number;
  errorsByStatusCode: Record<number, number>;
  errorsByCode: Record<string, number>;
  errorsByEndpoint: Record<string, number>;
  errorsByUser: Record<string, number>;
  averageResponseTime: number;
  errorRate: number; // percentage
  criticalErrors: number;
}
```

### Error Alerting Rules
```yaml
alerting_rules:
  high_error_rate:
    condition: "error_rate > 5%"
    duration: "5m"
    severity: "warning"
    channels: ["slack-engineering"]
  
  critical_error_spike:
    condition: "critical_errors > 10"
    duration: "1m"
    severity: "critical"
    channels: ["slack-engineering", "pagerduty"]
  
  external_service_failure:
    condition: "external_service_errors > 50%"
    duration: "2m"
    severity: "critical"
    channels: ["slack-ops", "slack-engineering"]
  
  authentication_failures:
    condition: "auth_failures > 100/hour"
    duration: "5m"
    severity: "warning"
    channels: ["slack-security"]
```

### Error Tracking Integration
```typescript
class ErrorTracker {
  static trackError(error: ApiError, context: RequestContext) {
    // Send to error tracking service (Sentry, Bugsnag, etc.)
    Sentry.captureException(error, {
      tags: {
        errorCode: error.code,
        statusCode: error.statusCode,
        endpoint: context.endpoint,
        method: context.method
      },
      user: {
        id: context.userId,
        email: context.userEmail
      },
      extra: {
        requestId: context.requestId,
        details: error.details
      }
    });
    
    // Custom analytics
    Analytics.track('api_error', {
      errorCode: error.code,
      statusCode: error.statusCode,
      endpoint: context.endpoint,
      userId: context.userId,
      requestId: context.requestId
    });
  }
}
```

## Client-Side Error Handling Guidelines

### Error Response Processing
```typescript
interface ApiResponse<T> {
  success: boolean;
  data?: T;
  error?: {
    code: string;
    message: string;
    details?: any;
    timestamp: string;
    requestId: string;
    documentation?: string;
  };
}

class ApiClient {
  async handleResponse<T>(response: Response): Promise<T> {
    const data: ApiResponse<T> = await response.json();
    
    if (!data.success) {
      const error = new ApiClientError(
        data.error!.code,
        data.error!.message,
        data.error!.details,
        response.status
      );
      
      // Handle specific error types
      switch (data.error!.code) {
        case 'EXPIRED_TOKEN':
          await this.refreshToken();
          throw new RetryableError(error);
        
        case 'RATE_LIMIT_EXCEEDED':
          const retryAfter = data.error!.details.retryAfter;
          throw new RateLimitError(error, retryAfter);
        
        case 'INSUFFICIENT_INVENTORY':
          throw new InventoryError(error, data.error!.details);
        
        default:
          throw error;
      }
    }
    
    return data.data!;
  }
}
```

### Error Recovery Strategies
```typescript
class ErrorRecoveryService {
  async withRetry<T>(
    operation: () => Promise<T>,
    maxRetries: number = 3
  ): Promise<T> {
    let lastError: Error;
    
    for (let attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        return await operation();
      } catch (error) {
        lastError = error;
        
        if (!this.isRetryable(error) || attempt === maxRetries) {
          throw error;
        }
        
        const delay = this.calculateBackoff(attempt);
        await this.sleep(delay);
      }
    }
    
    throw lastError!;
  }
  
  private isRetryable(error: any): boolean {
    if (error instanceof RetryableError) return true;
    if (error instanceof RateLimitError) return true;
    
    const retryableStatusCodes = [429, 500, 502, 503, 504];
    return retryableStatusCodes.includes(error.statusCode);
  }
  
  private calculateBackoff(attempt: number): number {
    return Math.min(1000 * Math.pow(2, attempt - 1), 30000);
  }
}
```