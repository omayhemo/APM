# E-Commerce API Endpoints Specification

## API Base URL Structure
```
https://api.ecommerce.com/v1/{service}/{resource}
```

## 1. User Service API

### Authentication Endpoints
```http
POST   /v1/auth/register              # User registration
POST   /v1/auth/login                 # User login
POST   /v1/auth/logout                # User logout
POST   /v1/auth/refresh-token         # Refresh JWT token
POST   /v1/auth/forgot-password       # Password reset request
POST   /v1/auth/reset-password        # Password reset confirmation
POST   /v1/auth/verify-email          # Email verification
POST   /v1/auth/oauth/google          # Google OAuth login
POST   /v1/auth/oauth/facebook        # Facebook OAuth login
```

### User Management Endpoints
```http
GET    /v1/users/profile              # Get current user profile
PUT    /v1/users/profile              # Update user profile
DELETE /v1/users/profile              # Delete user account
GET    /v1/users/{userId}             # Get user by ID (admin only)
GET    /v1/users                      # List users (admin only)
PUT    /v1/users/{userId}/status      # Update user status (admin only)
```

### Address Management
```http
GET    /v1/users/addresses            # Get user addresses
POST   /v1/users/addresses            # Add new address
PUT    /v1/users/addresses/{addressId} # Update address
DELETE /v1/users/addresses/{addressId} # Delete address
PUT    /v1/users/addresses/{addressId}/default # Set default address
```

## 2. Product Service API

### Product Catalog
```http
GET    /v1/products                   # List products with pagination and filters
GET    /v1/products/{productId}       # Get product details
POST   /v1/products                   # Create product (admin only)
PUT    /v1/products/{productId}       # Update product (admin only)
DELETE /v1/products/{productId}       # Delete product (admin only)
GET    /v1/products/search            # Search products
GET    /v1/products/featured          # Get featured products
GET    /v1/products/recommendations/{userId} # Get personalized recommendations
```

### Categories
```http
GET    /v1/categories                 # List all categories
GET    /v1/categories/{categoryId}    # Get category details
POST   /v1/categories                 # Create category (admin only)
PUT    /v1/categories/{categoryId}    # Update category (admin only)
DELETE /v1/categories/{categoryId}    # Delete category (admin only)
GET    /v1/categories/{categoryId}/products # Get products in category
```

### Product Reviews
```http
GET    /v1/products/{productId}/reviews # Get product reviews
POST   /v1/products/{productId}/reviews # Add product review
PUT    /v1/reviews/{reviewId}         # Update review (author only)
DELETE /v1/reviews/{reviewId}         # Delete review (author/admin only)
POST   /v1/reviews/{reviewId}/helpful # Mark review as helpful
```

### Product Variants
```http
GET    /v1/products/{productId}/variants # Get product variants
POST   /v1/products/{productId}/variants # Add variant (admin only)
PUT    /v1/variants/{variantId}       # Update variant (admin only)
DELETE /v1/variants/{variantId}      # Delete variant (admin only)
```

## 3. Cart Service API

### Shopping Cart
```http
GET    /v1/cart                       # Get current user's cart
POST   /v1/cart/items                 # Add item to cart
PUT    /v1/cart/items/{itemId}        # Update cart item quantity
DELETE /v1/cart/items/{itemId}        # Remove item from cart
DELETE /v1/cart                       # Clear entire cart
POST   /v1/cart/merge                 # Merge guest cart with user cart
```

### Wishlist
```http
GET    /v1/wishlist                   # Get user's wishlist
POST   /v1/wishlist/items             # Add item to wishlist
DELETE /v1/wishlist/items/{itemId}    # Remove item from wishlist
POST   /v1/wishlist/{wishlistId}/share # Share wishlist
```

### Cart Sessions
```http
POST   /v1/cart/sessions              # Create guest cart session
PUT    /v1/cart/sessions/{sessionId}  # Update guest cart
GET    /v1/cart/sessions/{sessionId}  # Get guest cart
```

## 4. Order Service API

### Order Management
```http
POST   /v1/orders                     # Create order from cart
GET    /v1/orders                     # Get user's order history
GET    /v1/orders/{orderId}           # Get order details
PUT    /v1/orders/{orderId}/cancel    # Cancel order
GET    /v1/orders/{orderId}/status    # Get order status
POST   /v1/orders/{orderId}/return    # Request order return
```

### Order Tracking
```http
GET    /v1/orders/{orderId}/tracking  # Get shipment tracking info
POST   /v1/orders/{orderId}/confirm   # Confirm order delivery
```

### Admin Order Management
```http
GET    /v1/admin/orders               # List all orders (admin only)
PUT    /v1/admin/orders/{orderId}/status # Update order status (admin only)
POST   /v1/admin/orders/{orderId}/ship # Mark order as shipped (admin only)
POST   /v1/admin/orders/{orderId}/refund # Process refund (admin only)
```

## 5. Payment Service API

### Payment Processing
```http
POST   /v1/payments/intents           # Create payment intent
POST   /v1/payments/confirm           # Confirm payment
GET    /v1/payments/{paymentId}       # Get payment details
POST   /v1/payments/{paymentId}/refund # Process refund
```

### Payment Methods
```http
GET    /v1/payment-methods            # Get user's saved payment methods
POST   /v1/payment-methods            # Add payment method
PUT    /v1/payment-methods/{methodId} # Update payment method
DELETE /v1/payment-methods/{methodId} # Delete payment method
PUT    /v1/payment-methods/{methodId}/default # Set default payment method
```

### Billing
```http
GET    /v1/billing/invoices           # Get user's invoices
GET    /v1/billing/invoices/{invoiceId} # Get invoice details
POST   /v1/billing/invoices/{invoiceId}/download # Download invoice PDF
```

## 6. Inventory Service API

### Stock Management
```http
GET    /v1/inventory/{productId}      # Get product inventory
PUT    /v1/inventory/{productId}      # Update stock levels (admin only)
POST   /v1/inventory/reserve          # Reserve inventory for order
POST   /v1/inventory/release          # Release reserved inventory
GET    /v1/inventory/low-stock        # Get low stock alerts (admin only)
```

### Warehouse Management
```http
GET    /v1/warehouses                 # List warehouses (admin only)
GET    /v1/warehouses/{warehouseId}/inventory # Get warehouse inventory
POST   /v1/inventory/transfer         # Transfer stock between warehouses
```

## 7. Notification Service API

### Notification Management
```http
GET    /v1/notifications              # Get user notifications
PUT    /v1/notifications/{notificationId}/read # Mark notification as read
DELETE /v1/notifications/{notificationId} # Delete notification
PUT    /v1/notifications/read-all     # Mark all notifications as read
```

### Notification Preferences
```http
GET    /v1/notifications/preferences  # Get notification preferences
PUT    /v1/notifications/preferences  # Update notification preferences
POST   /v1/notifications/test         # Send test notification
```

### Subscription Management
```http
POST   /v1/notifications/subscribe    # Subscribe to push notifications
DELETE /v1/notifications/unsubscribe  # Unsubscribe from notifications
```

## 8. Analytics Service API

### User Analytics
```http
POST   /v1/analytics/events           # Track user events
GET    /v1/analytics/user-insights    # Get user behavior insights (admin only)
GET    /v1/analytics/conversion-funnel # Get conversion funnel data (admin only)
```

### Sales Analytics
```http
GET    /v1/analytics/sales            # Get sales analytics (admin only)
GET    /v1/analytics/revenue          # Get revenue analytics (admin only)
GET    /v1/analytics/popular-products # Get popular products data (admin only)
```

### Performance Analytics
```http
GET    /v1/analytics/performance      # Get API performance metrics (admin only)
GET    /v1/analytics/errors           # Get error analytics (admin only)
```

## Common Query Parameters

### Pagination
```
?page=1&limit=20&sort=created_at&order=desc
```

### Filtering
```
?category=electronics&price_min=100&price_max=500&brand=apple
```

### Fields Selection
```
?fields=id,name,price,description
```

### Search
```
?q=search_term&sort=relevance
```

## Response Formats

### Success Response
```json
{
  "success": true,
  "data": {...},
  "meta": {
    "page": 1,
    "limit": 20,
    "total": 100,
    "pages": 5
  }
}
```

### Error Response
```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input data",
    "details": [
      {
        "field": "email",
        "message": "Invalid email format"
      }
    ]
  }
}
```

## HTTP Status Codes

- `200 OK` - Successful GET, PUT requests
- `201 Created` - Successful POST requests
- `204 No Content` - Successful DELETE requests
- `400 Bad Request` - Invalid request data
- `401 Unauthorized` - Authentication required
- `403 Forbidden` - Insufficient permissions
- `404 Not Found` - Resource not found
- `409 Conflict` - Resource conflict (duplicate)
- `422 Unprocessable Entity` - Validation errors
- `429 Too Many Requests` - Rate limit exceeded
- `500 Internal Server Error` - Server error
- `503 Service Unavailable` - Service temporarily unavailable