# API Testing Strategies and Validation

## Testing Strategy Overview

### Testing Pyramid for APIs
```
                    ┌─────────────────┐
                    │   E2E Tests     │ <- 10%
                    │   (Slow/Expensive)
                ┌───┴─────────────────┴───┐
                │   Integration Tests     │ <- 20%
                │   (API Contract Tests)  │
            ┌───┴─────────────────────────┴───┐
            │        Unit Tests               │ <- 70%
            │   (Business Logic/Models)       │
            └─────────────────────────────────┘
```

### Multi-Layer Testing Approach
```yaml
testing_layers:
  unit_tests:
    scope: "individual_functions_methods"
    tools: ["Jest", "PyTest", "JUnit"]
    coverage_target: "90%"
    execution: "on_every_commit"
    
  integration_tests:
    scope: "service_interactions"
    tools: ["Postman", "Newman", "REST Assured"]
    coverage_target: "100%_of_endpoints"
    execution: "on_pull_request"
    
  contract_tests:
    scope: "api_contracts_between_services"
    tools: ["Pact", "Spring Cloud Contract"]
    coverage_target: "all_service_boundaries"
    execution: "on_deployment"
    
  end_to_end_tests:
    scope: "complete_user_journeys"
    tools: ["Cypress", "Playwright", "TestCafe"]
    coverage_target: "critical_user_flows"
    execution: "on_release"
    
  performance_tests:
    scope: "load_stress_endurance"
    tools: ["K6", "Artillery", "JMeter"]
    coverage_target: "sla_compliance"
    execution: "scheduled_and_release"
    
  security_tests:
    scope: "vulnerabilities_auth_authorization"
    tools: ["OWASP ZAP", "Burp Suite", "Snyk"]
    coverage_target: "security_requirements"
    execution: "scheduled_and_release"
```

## Unit Testing Strategy

### Business Logic Testing
```typescript
// Example: Order calculation unit tests
describe('OrderCalculationService', () => {
  let service: OrderCalculationService;
  
  beforeEach(() => {
    service = new OrderCalculationService();
  });
  
  describe('calculateTotal', () => {
    it('should calculate correct total with tax and shipping', () => {
      const order = {
        items: [
          { price: 100, quantity: 2 },
          { price: 50, quantity: 1 }
        ],
        shippingCost: 10,
        taxRate: 0.1
      };
      
      const result = service.calculateTotal(order);
      
      expect(result).toEqual({
        subtotal: 250,
        tax: 25,
        shipping: 10,
        total: 285
      });
    });
    
    it('should handle zero tax rate', () => {
      const order = {
        items: [{ price: 100, quantity: 1 }],
        shippingCost: 5,
        taxRate: 0
      };
      
      const result = service.calculateTotal(order);
      
      expect(result.tax).toBe(0);
      expect(result.total).toBe(105);
    });
    
    it('should throw error for negative prices', () => {
      const order = {
        items: [{ price: -10, quantity: 1 }],
        shippingCost: 0,
        taxRate: 0
      };
      
      expect(() => service.calculateTotal(order))
        .toThrow('Price cannot be negative');
    });
  });
});
```

### Repository/Data Layer Testing
```typescript
describe('ProductRepository', () => {
  let repository: ProductRepository;
  let mockDatabase: jest.Mocked<Database>;
  
  beforeEach(() => {
    mockDatabase = createMockDatabase();
    repository = new ProductRepository(mockDatabase);
  });
  
  describe('findById', () => {
    it('should return product when found', async () => {
      const productId = 'prod_123';
      const expectedProduct = { id: productId, name: 'Test Product' };
      
      mockDatabase.query.mockResolvedValue([expectedProduct]);
      
      const result = await repository.findById(productId);
      
      expect(result).toEqual(expectedProduct);
      expect(mockDatabase.query).toHaveBeenCalledWith(
        'SELECT * FROM products WHERE id = ?',
        [productId]
      );
    });
    
    it('should return null when product not found', async () => {
      mockDatabase.query.mockResolvedValue([]);
      
      const result = await repository.findById('nonexistent');
      
      expect(result).toBeNull();
    });
    
    it('should handle database errors', async () => {
      mockDatabase.query.mockRejectedValue(new Error('Database error'));
      
      await expect(repository.findById('prod_123'))
        .rejects.toThrow('Database error');
    });
  });
});
```

## Integration Testing Strategy

### API Endpoint Testing with Postman/Newman
```json
{
  "info": {
    "name": "E-Commerce API Integration Tests",
    "description": "Comprehensive API integration test suite"
  },
  "item": [
    {
      "name": "Authentication Flow",
      "item": [
        {
          "name": "User Registration",
          "request": {
            "method": "POST",
            "header": [
              {
                "key": "Content-Type",
                "value": "application/json"
              }
            ],
            "body": {
              "mode": "raw",
              "raw": "{\n  \"email\": \"{{$randomEmail}}\",\n  \"password\": \"SecurePass123!\",\n  \"firstName\": \"{{$randomFirstName}}\",\n  \"lastName\": \"{{$randomLastName}}\"\n}"
            },
            "url": "{{baseUrl}}/auth/register"
          },
          "event": [
            {
              "listen": "test",
              "script": {
                "exec": [
                  "pm.test('Registration successful', function () {",
                  "    pm.response.to.have.status(201);",
                  "});",
                  "",
                  "pm.test('Response has correct structure', function () {",
                  "    const response = pm.response.json();",
                  "    pm.expect(response).to.have.property('success', true);",
                  "    pm.expect(response.data).to.have.property('userId');",
                  "    pm.expect(response.data).to.have.property('email');",
                  "});",
                  "",
                  "// Store user data for subsequent tests",
                  "if (pm.response.code === 201) {",
                  "    const response = pm.response.json();",
                  "    pm.environment.set('userId', response.data.userId);",
                  "    pm.environment.set('userEmail', response.data.email);",
                  "}"
                ]
              }
            }
          ]
        },
        {
          "name": "User Login",
          "request": {
            "method": "POST",
            "header": [
              {
                "key": "Content-Type",
                "value": "application/json"
              }
            ],
            "body": {
              "mode": "raw",
              "raw": "{\n  \"email\": \"{{userEmail}}\",\n  \"password\": \"SecurePass123!\"\n}"
            },
            "url": "{{baseUrl}}/auth/login"
          },
          "event": [
            {
              "listen": "test",
              "script": {
                "exec": [
                  "pm.test('Login successful', function () {",
                  "    pm.response.to.have.status(200);",
                  "});",
                  "",
                  "pm.test('Response contains tokens', function () {",
                  "    const response = pm.response.json();",
                  "    pm.expect(response.data).to.have.property('accessToken');",
                  "    pm.expect(response.data).to.have.property('refreshToken');",
                  "    pm.expect(response.data).to.have.property('expiresIn');",
                  "});",
                  "",
                  "// Store access token for authenticated requests",
                  "if (pm.response.code === 200) {",
                  "    const response = pm.response.json();",
                  "    pm.environment.set('accessToken', response.data.accessToken);",
                  "    pm.environment.set('refreshToken', response.data.refreshToken);",
                  "}"
                ]
              }
            }
          ]
        }
      ]
    },
    {
      "name": "Product Management",
      "item": [
        {
          "name": "Get Products List",
          "request": {
            "method": "GET",
            "header": [],
            "url": {
              "raw": "{{baseUrl}}/products?page=1&limit=10",
              "host": ["{{baseUrl}}"],
              "path": ["products"],
              "query": [
                {"key": "page", "value": "1"},
                {"key": "limit", "value": "10"}
              ]
            }
          },
          "event": [
            {
              "listen": "test",
              "script": {
                "exec": [
                  "pm.test('Products retrieved successfully', function () {",
                  "    pm.response.to.have.status(200);",
                  "});",
                  "",
                  "pm.test('Response has pagination metadata', function () {",
                  "    const response = pm.response.json();",
                  "    pm.expect(response).to.have.property('meta');",
                  "    pm.expect(response.meta).to.have.property('page');",
                  "    pm.expect(response.meta).to.have.property('total');",
                  "});",
                  "",
                  "pm.test('Products array is present', function () {",
                  "    const response = pm.response.json();",
                  "    pm.expect(response.data).to.be.an('array');",
                  "});",
                  "",
                  "// Store first product ID for detail tests",
                  "if (pm.response.code === 200) {",
                  "    const response = pm.response.json();",
                  "    if (response.data.length > 0) {",
                  "        pm.environment.set('firstProductId', response.data[0].id);",
                  "    }",
                  "}"
                ]
              }
            }
          ]
        }
      ]
    }
  ]
}
```

### Database Integration Testing
```typescript
describe('User Service Database Integration', () => {
  let userService: UserService;
  let testDatabase: TestDatabase;
  
  beforeAll(async () => {
    testDatabase = await setupTestDatabase();
    userService = new UserService(testDatabase);
  });
  
  afterAll(async () => {
    await testDatabase.cleanup();
  });
  
  beforeEach(async () => {
    await testDatabase.truncateAll();
  });
  
  describe('createUser', () => {
    it('should create user and return user data', async () => {
      const userData = {
        email: 'test@example.com',
        password: 'hashedPassword',
        firstName: 'John',
        lastName: 'Doe'
      };
      
      const result = await userService.createUser(userData);
      
      expect(result).toMatchObject({
        id: expect.any(String),
        email: userData.email,
        firstName: userData.firstName,
        lastName: userData.lastName,
        createdAt: expect.any(Date)
      });
      
      // Verify user exists in database
      const dbUser = await testDatabase.query(
        'SELECT * FROM users WHERE id = ?',
        [result.id]
      );
      expect(dbUser).toHaveLength(1);
    });
    
    it('should enforce unique email constraint', async () => {
      const userData = {
        email: 'duplicate@example.com',
        password: 'password',
        firstName: 'John',
        lastName: 'Doe'
      };
      
      await userService.createUser(userData);
      
      await expect(userService.createUser(userData))
        .rejects.toThrow('Email already exists');
    });
  });
});
```

## Contract Testing Strategy

### Consumer-Driven Contract Testing with Pact
```typescript
// Consumer side (Frontend/Mobile app)
import { Pact } from '@pact-foundation/pact';
import { UserService } from '../services/UserService';

describe('User Service Contract', () => {
  const provider = new Pact({
    consumer: 'Frontend App',
    provider: 'User Service',
    port: 1234,
    log: path.resolve(process.cwd(), 'logs', 'pact.log'),
    dir: path.resolve(process.cwd(), 'pacts'),
    logLevel: 'INFO'
  });
  
  beforeAll(() => provider.setup());
  afterAll(() => provider.finalize());
  afterEach(() => provider.verify());
  
  describe('GET /users/{id}', () => {
    it('should return user when user exists', async () => {
      const expectedUser = {
        id: '123',
        email: 'user@example.com',
        firstName: 'John',
        lastName: 'Doe'
      };
      
      await provider.addInteraction({
        state: 'user with id 123 exists',
        uponReceiving: 'a request to get user 123',
        withRequest: {
          method: 'GET',
          path: '/users/123',
          headers: {
            'Authorization': 'Bearer token123',
            'Accept': 'application/json'
          }
        },
        willRespondWith: {
          status: 200,
          headers: {
            'Content-Type': 'application/json'
          },
          body: {
            success: true,
            data: expectedUser
          }
        }
      });
      
      const userService = new UserService('http://localhost:1234');
      const result = await userService.getUser('123');
      
      expect(result).toEqual(expectedUser);
    });
    
    it('should return 404 when user does not exist', async () => {
      await provider.addInteraction({
        state: 'user with id 999 does not exist',
        uponReceiving: 'a request to get user 999',
        withRequest: {
          method: 'GET',
          path: '/users/999',
          headers: {
            'Authorization': 'Bearer token123',
            'Accept': 'application/json'
          }
        },
        willRespondWith: {
          status: 404,
          headers: {
            'Content-Type': 'application/json'
          },
          body: {
            success: false,
            error: {
              code: 'USER_NOT_FOUND',
              message: 'User not found'
            }
          }
        }
      });
      
      const userService = new UserService('http://localhost:1234');
      
      await expect(userService.getUser('999'))
        .rejects.toThrow('User not found');
    });
  });
});
```

### Provider Side Contract Verification
```typescript
// Provider side (API service)
import { Verifier } from '@pact-foundation/pact';
import { app } from '../src/app';

describe('User Service Provider Contract', () => {
  it('should satisfy all consumer contracts', () => {
    const opts = {
      provider: 'User Service',
      providerBaseUrl: 'http://localhost:3000',
      pactUrls: [
        path.resolve(__dirname, '../pacts/frontend-app-user-service.json')
      ],
      stateHandlers: {
        'user with id 123 exists': async () => {
          // Set up test data
          await testDatabase.users.create({
            id: '123',
            email: 'user@example.com',
            firstName: 'John',
            lastName: 'Doe'
          });
        },
        'user with id 999 does not exist': async () => {
          // Ensure user doesn't exist
          await testDatabase.users.deleteMany({ id: '999' });
        }
      },
      requestFilter: (req, res, next) => {
        // Add authentication for test requests
        req.headers.authorization = 'Bearer valid-test-token';
        next();
      }
    };
    
    return new Verifier(opts).verifyProvider();
  });
});
```

## Performance Testing Strategy

### Load Testing with K6
```javascript
import http from 'k6/http';
import { check, sleep } from 'k6';
import { Rate } from 'k6/metrics';

// Custom metrics
const errorRate = new Rate('errors');

export let options = {
  stages: [
    { duration: '2m', target: 100 }, // Ramp up to 100 users
    { duration: '5m', target: 100 }, // Stay at 100 users
    { duration: '2m', target: 200 }, // Ramp up to 200 users
    { duration: '5m', target: 200 }, // Stay at 200 users
    { duration: '2m', target: 0 },   // Ramp down to 0 users
  ],
  thresholds: {
    http_req_duration: ['p(95)<500'], // 95% of requests under 500ms
    http_req_failed: ['rate<0.01'],   // Error rate under 1%
    errors: ['rate<0.01'],            // Custom error rate under 1%
  },
};

export default function() {
  const baseUrl = 'https://api.ecommerce.com/v2';
  
  // Test product listing
  let response = http.get(`${baseUrl}/products?page=1&limit=20`);
  
  const success = check(response, {
    'product list status is 200': (r) => r.status === 200,
    'product list response time < 500ms': (r) => r.timings.duration < 500,
    'product list has data': (r) => JSON.parse(r.body).data.length > 0,
  });
  
  errorRate.add(!success);
  
  if (success) {
    const products = JSON.parse(response.body).data;
    const randomProduct = products[Math.floor(Math.random() * products.length)];
    
    // Test product details
    response = http.get(`${baseUrl}/products/${randomProduct.id}`);
    
    check(response, {
      'product detail status is 200': (r) => r.status === 200,
      'product detail response time < 300ms': (r) => r.timings.duration < 300,
    });
  }
  
  sleep(1);
}

// Stress test configuration
export function stressTest() {
  return {
    executor: 'ramping-vus',
    startVUs: 0,
    stages: [
      { duration: '10m', target: 1000 }, // Ramp up to 1000 users
      { duration: '30m', target: 1000 }, // Stay at 1000 users
      { duration: '10m', target: 0 },    // Ramp down
    ],
    thresholds: {
      http_req_duration: ['p(95)<1000'], // More lenient for stress test
      http_req_failed: ['rate<0.05'],    // 5% error rate acceptable under stress
    },
  };
}
```

### Database Performance Testing
```typescript
describe('Database Performance Tests', () => {
  let database: Database;
  
  beforeAll(async () => {
    database = await setupTestDatabase();
    await seedTestData(10000); // Seed with realistic data volume
  });
  
  describe('Product Search Performance', () => {
    it('should handle complex search queries within SLA', async () => {
      const startTime = Date.now();
      
      const results = await database.query(`
        SELECT p.*, c.name as category_name, 
               AVG(r.rating) as avg_rating,
               COUNT(r.id) as review_count
        FROM products p
        JOIN categories c ON p.category_id = c.id
        LEFT JOIN reviews r ON p.id = r.product_id
        WHERE p.name ILIKE ?
          AND p.price BETWEEN ? AND ?
          AND p.status = 'active'
        GROUP BY p.id, c.name
        HAVING COUNT(r.id) > 5
        ORDER BY avg_rating DESC, p.created_at DESC
        LIMIT 20
      `, ['%laptop%', 500, 2000]);
      
      const duration = Date.now() - startTime;
      
      expect(duration).toBeLessThan(500); // 500ms SLA
      expect(results.length).toBeGreaterThan(0);
    });
    
    it('should handle concurrent read operations', async () => {
      const concurrentQueries = Array(50).fill(null).map((_, index) =>
        database.query('SELECT * FROM products WHERE id = ?', [`prod_${index}`])
      );
      
      const startTime = Date.now();
      await Promise.all(concurrentQueries);
      const duration = Date.now() - startTime;
      
      expect(duration).toBeLessThan(1000); // All queries under 1 second
    });
  });
});
```

## Security Testing Strategy

### Authentication and Authorization Testing
```typescript
describe('Authentication Security Tests', () => {
  describe('JWT Token Security', () => {
    it('should reject requests with expired tokens', async () => {
      const expiredToken = generateExpiredToken();
      
      const response = await request(app)
        .get('/api/v2/profile')
        .set('Authorization', `Bearer ${expiredToken}`);
      
      expect(response.status).toBe(401);
      expect(response.body.error.code).toBe('EXPIRED_TOKEN');
    });
    
    it('should reject requests with malformed tokens', async () => {
      const malformedToken = 'invalid.token.here';
      
      const response = await request(app)
        .get('/api/v2/profile')
        .set('Authorization', `Bearer ${malformedToken}`);
      
      expect(response.status).toBe(401);
      expect(response.body.error.code).toBe('INVALID_TOKEN');
    });
    
    it('should reject requests with tampered tokens', async () => {
      const validToken = generateValidToken({ userId: 'user123' });
      const tamperedToken = validToken.slice(0, -10) + 'tampered123';
      
      const response = await request(app)
        .get('/api/v2/profile')
        .set('Authorization', `Bearer ${tamperedToken}`);
      
      expect(response.status).toBe(401);
    });
  });
  
  describe('Rate Limiting Security', () => {
    it('should implement rate limiting on login attempts', async () => {
      const loginData = {
        email: 'test@example.com',
        password: 'wrongpassword'
      };
      
      // Attempt multiple failed logins
      const attempts = Array(6).fill(null).map(() =>
        request(app)
          .post('/api/v2/auth/login')
          .send(loginData)
      );
      
      const responses = await Promise.all(attempts);
      
      // First 5 should be 401 (unauthorized)
      responses.slice(0, 5).forEach(response => {
        expect(response.status).toBe(401);
      });
      
      // 6th should be 429 (rate limited)
      expect(responses[5].status).toBe(429);
    });
  });
  
  describe('Input Validation Security', () => {
    it('should prevent SQL injection in search queries', async () => {
      const maliciousQuery = "'; DROP TABLE products; --";
      
      const response = await request(app)
        .get('/api/v2/products')
        .query({ search: maliciousQuery });
      
      expect(response.status).toBe(200); // Should not crash
      expect(response.body.data).toBeDefined(); // Should return safe results
    });
    
    it('should prevent XSS in user input', async () => {
      const xssPayload = '<script>alert("xss")</script>';
      
      const response = await request(app)
        .post('/api/v2/products/123/reviews')
        .set('Authorization', `Bearer ${validToken}`)
        .send({
          rating: 5,
          title: xssPayload,
          content: 'Review content'
        });
      
      if (response.status === 201) {
        // If created, ensure XSS payload is sanitized
        expect(response.body.data.title).not.toContain('<script>');
      } else {
        // Should reject malicious input
        expect(response.status).toBe(400);
      }
    });
  });
});
```

### OWASP ZAP Integration
```yaml
# .github/workflows/security-scan.yml
name: Security Scan
on:
  pull_request:
  schedule:
    - cron: '0 2 * * *' # Daily at 2 AM

jobs:
  security-scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Start application
        run: |
          docker-compose up -d
          sleep 30 # Wait for services to start
      
      - name: Run OWASP ZAP Baseline Scan
        uses: zaproxy/action-baseline@v0.6.1
        with:
          target: 'http://localhost:3000'
          rules_file_name: '.zap/rules.tsv'
          cmd_options: '-a'
      
      - name: Run OWASP ZAP Full Scan
        uses: zaproxy/action-full-scan@v0.4.0
        with:
          target: 'http://localhost:3000'
          rules_file_name: '.zap/rules.tsv'
          cmd_options: '-a'
      
      - name: Upload ZAP results
        uses: actions/upload-artifact@v2
        with:
          name: zap-reports
          path: report_html.html
```

## End-to-End Testing Strategy

### User Journey Testing with Playwright
```typescript
import { test, expect } from '@playwright/test';

test.describe('E-Commerce User Journey', () => {
  test('complete purchase flow', async ({ page }) => {
    // Start at homepage
    await page.goto('/');
    
    // Search for product
    await page.fill('[data-testid="search-input"]', 'laptop');
    await page.click('[data-testid="search-button"]');
    
    // Verify search results
    await expect(page.locator('[data-testid="product-list"]')).toBeVisible();
    await expect(page.locator('[data-testid="product-item"]')).toHaveCountGreaterThan(0);
    
    // Click on first product
    await page.click('[data-testid="product-item"]:first-child');
    
    // Verify product details page
    await expect(page.locator('[data-testid="product-title"]')).toBeVisible();
    await expect(page.locator('[data-testid="product-price"]')).toBeVisible();
    
    // Add to cart
    await page.click('[data-testid="add-to-cart-button"]');
    
    // Verify cart notification
    await expect(page.locator('[data-testid="cart-notification"]')).toBeVisible();
    
    // Go to cart
    await page.click('[data-testid="cart-icon"]');
    
    // Verify cart page
    await expect(page.locator('[data-testid="cart-items"]')).toBeVisible();
    await expect(page.locator('[data-testid="cart-total"]')).toBeVisible();
    
    // Proceed to checkout
    await page.click('[data-testid="checkout-button"]');
    
    // Login (if not already logged in)
    if (await page.locator('[data-testid="login-form"]').isVisible()) {
      await page.fill('[data-testid="email-input"]', 'test@example.com');
      await page.fill('[data-testid="password-input"]', 'password123');
      await page.click('[data-testid="login-button"]');
    }
    
    // Fill shipping address
    await page.fill('[data-testid="first-name"]', 'John');
    await page.fill('[data-testid="last-name"]', 'Doe');
    await page.fill('[data-testid="address"]', '123 Main St');
    await page.fill('[data-testid="city"]', 'Anytown');
    await page.fill('[data-testid="postal-code"]', '12345');
    await page.selectOption('[data-testid="country"]', 'US');
    
    // Continue to payment
    await page.click('[data-testid="continue-to-payment"]');
    
    // Fill payment information (test card)
    await page.fill('[data-testid="card-number"]', '4242424242424242');
    await page.fill('[data-testid="expiry"]', '12/25');
    await page.fill('[data-testid="cvc"]', '123');
    await page.fill('[data-testid="card-name"]', 'John Doe');
    
    // Place order
    await page.click('[data-testid="place-order-button"]');
    
    // Verify order confirmation
    await expect(page.locator('[data-testid="order-confirmation"]')).toBeVisible();
    await expect(page.locator('[data-testid="order-number"]')).toBeVisible();
    
    // Extract order number for verification
    const orderNumber = await page.textContent('[data-testid="order-number"]');
    expect(orderNumber).toMatch(/^ORD-\d+$/);
  });
});
```

## Test Data Management

### Test Data Factory
```typescript
class TestDataFactory {
  static createUser(overrides: Partial<User> = {}): User {
    return {
      id: `user_${faker.datatype.uuid()}`,
      email: faker.internet.email(),
      firstName: faker.name.firstName(),
      lastName: faker.name.lastName(),
      phoneNumber: faker.phone.phoneNumber(),
      role: 'customer',
      tier: 'basic',
      isEmailVerified: true,
      createdAt: new Date(),
      updatedAt: new Date(),
      ...overrides
    };
  }
  
  static createProduct(overrides: Partial<Product> = {}): Product {
    return {
      id: `prod_${faker.datatype.uuid()}`,
      name: faker.commerce.productName(),
      description: faker.commerce.productDescription(),
      sku: faker.random.alphaNumeric(8).toUpperCase(),
      price: parseFloat(faker.commerce.price()),
      categoryId: `cat_${faker.datatype.uuid()}`,
      brand: faker.company.companyName(),
      status: 'active',
      inventory: {
        quantity: faker.datatype.number({ min: 0, max: 1000 }),
        trackQuantity: true,
        lowStockThreshold: 10
      },
      createdAt: new Date(),
      updatedAt: new Date(),
      ...overrides
    };
  }
  
  static createOrder(overrides: Partial<Order> = {}): Order {
    const items = Array(faker.datatype.number({ min: 1, max: 5 }))
      .fill(null)
      .map(() => this.createOrderItem());
    
    const subtotal = items.reduce((sum, item) => sum + item.totalPrice, 0);
    const taxAmount = subtotal * 0.1;
    const shippingAmount = 10;
    
    return {
      id: `ord_${faker.datatype.uuid()}`,
      orderNumber: `ORD-${faker.datatype.number({ min: 100000, max: 999999 })}`,
      userId: `user_${faker.datatype.uuid()}`,
      status: 'pending',
      items,
      subtotal,
      taxAmount,
      shippingAmount,
      totalAmount: subtotal + taxAmount + shippingAmount,
      currency: 'USD',
      paymentStatus: 'pending',
      createdAt: new Date(),
      updatedAt: new Date(),
      ...overrides
    };
  }
  
  private static createOrderItem(): OrderItem {
    const quantity = faker.datatype.number({ min: 1, max: 3 });
    const unitPrice = parseFloat(faker.commerce.price());
    
    return {
      id: `item_${faker.datatype.uuid()}`,
      productId: `prod_${faker.datatype.uuid()}`,
      productName: faker.commerce.productName(),
      sku: faker.random.alphaNumeric(8).toUpperCase(),
      quantity,
      unitPrice,
      totalPrice: quantity * unitPrice
    };
  }
}
```

### Test Database Management
```typescript
class TestDatabaseManager {
  private database: Database;
  
  constructor(database: Database) {
    this.database = database;
  }
  
  async seedTestData(scenario: string): Promise<void> {
    switch (scenario) {
      case 'basic_ecommerce':
        await this.seedBasicEcommerce();
        break;
      case 'large_catalog':
        await this.seedLargeCatalog();
        break;
      case 'multi_tenant':
        await this.seedMultiTenant();
        break;
      default:
        throw new Error(`Unknown test scenario: ${scenario}`);
    }
  }
  
  private async seedBasicEcommerce(): Promise<void> {
    // Create categories
    const categories = Array(10).fill(null).map(() => 
      TestDataFactory.createCategory()
    );
    await this.database.categories.insertMany(categories);
    
    // Create products
    const products = Array(100).fill(null).map(() => 
      TestDataFactory.createProduct({
        categoryId: faker.random.arrayElement(categories).id
      })
    );
    await this.database.products.insertMany(products);
    
    // Create users
    const users = Array(50).fill(null).map(() => 
      TestDataFactory.createUser()
    );
    await this.database.users.insertMany(users);
    
    // Create orders
    const orders = Array(200).fill(null).map(() => 
      TestDataFactory.createOrder({
        userId: faker.random.arrayElement(users).id
      })
    );
    await this.database.orders.insertMany(orders);
  }
  
  async cleanup(): Promise<void> {
    const tables = ['orders', 'products', 'categories', 'users', 'order_items'];
    
    for (const table of tables) {
      await this.database.query(`TRUNCATE TABLE ${table} CASCADE`);
    }
  }
}
```

## Test Execution and CI/CD Integration

### GitHub Actions Workflow
```yaml
name: API Test Suite
on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  unit-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Setup Node.js
        uses: actions/setup-node@v2
        with:
          node-version: '18'
          cache: 'npm'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Run unit tests
        run: npm run test:unit
      
      - name: Upload coverage
        uses: codecov/codecov-action@v2
        with:
          files: ./coverage/lcov.info

  integration-tests:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgres:13
        env:
          POSTGRES_PASSWORD: password
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
      redis:
        image: redis:6
        options: >-
          --health-cmd "redis-cli ping"
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
    
    steps:
      - uses: actions/checkout@v2
      
      - name: Setup Node.js
        uses: actions/setup-node@v2
        with:
          node-version: '18'
          cache: 'npm'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Setup test database
        run: npm run db:test:setup
        env:
          DATABASE_URL: postgresql://postgres:password@localhost:5432/test_db
      
      - name: Run integration tests
        run: npm run test:integration
        env:
          DATABASE_URL: postgresql://postgres:password@localhost:5432/test_db
          REDIS_URL: redis://localhost:6379

  contract-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Run Pact tests
        run: npm run test:contract
      
      - name: Publish Pact contracts
        if: github.ref == 'refs/heads/main'
        run: npm run pact:publish
        env:
          PACT_BROKER_TOKEN: ${{ secrets.PACT_BROKER_TOKEN }}

  e2e-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Setup Node.js
        uses: actions/setup-node@v2
        with:
          node-version: '18'
          cache: 'npm'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Install Playwright
        run: npx playwright install
      
      - name: Start application
        run: |
          npm run build
          npm run start:prod &
          sleep 30
      
      - name: Run E2E tests
        run: npm run test:e2e
      
      - name: Upload test results
        uses: actions/upload-artifact@v2
        if: failure()
        with:
          name: playwright-report
          path: playwright-report/

  performance-tests:
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v2
      
      - name: Setup K6
        uses: grafana/setup-k6-action@v1
      
      - name: Run performance tests
        run: k6 run tests/performance/load-test.js
        env:
          BASE_URL: https://staging-api.ecommerce.com
      
      - name: Upload performance results
        uses: actions/upload-artifact@v2
        with:
          name: k6-results
          path: results.json
```

<function_calls>
<invoke name="TodoWrite">
<parameter name="todos">[{"id": "1", "content": "Design overall API architecture and microservices vs monolith decision", "status": "completed", "priority": "high"}, {"id": "2", "content": "Define RESTful API endpoints structure for all core services", "status": "completed", "priority": "high"}, {"id": "3", "content": "Design authentication and authorization patterns (JWT, OAuth)", "status": "completed", "priority": "high"}, {"id": "4", "content": "Create rate limiting strategies for different user tiers", "status": "completed", "priority": "medium"}, {"id": "5", "content": "Define API versioning approach and strategy", "status": "completed", "priority": "medium"}, {"id": "6", "content": "Design external API integrations (payment, shipping, inventory)", "status": "completed", "priority": "high"}, {"id": "7", "content": "Create detailed API contract specifications (OpenAPI/Swagger)", "status": "completed", "priority": "medium"}, {"id": "8", "content": "Define error handling patterns and response standards", "status": "completed", "priority": "medium"}, {"id": "9", "content": "Create API documentation standards and guidelines", "status": "completed", "priority": "low"}, {"id": "10", "content": "Design testing strategies for API integration and validation", "status": "completed", "priority": "low"}]