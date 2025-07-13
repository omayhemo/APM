# External API Integrations Architecture

## Integration Architecture Overview

### Integration Patterns
- **API Gateway Pattern**: Centralized external API management
- **Circuit Breaker Pattern**: Fault tolerance for external services
- **Adapter Pattern**: Consistent interfaces for different providers
- **Event-Driven Integration**: Asynchronous processing for non-critical operations
- **Webhook Management**: Handling external service notifications

### Integration Service Architecture
```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   E-Commerce    │    │   Integration    │    │   External      │
│   Services      │◄──►│   Gateway        │◄──►│   APIs          │
└─────────────────┘    └──────────────────┘    └─────────────────┘
                              │
                              ▼
                       ┌──────────────────┐
                       │   Message Queue  │
                       │   (Async Ops)    │
                       └──────────────────┘
```

## 1. Payment Gateway Integrations

### Multi-Provider Payment Architecture
```typescript
interface PaymentProviderInterface {
  createPaymentIntent(request: PaymentIntentRequest): Promise<PaymentIntentResponse>;
  confirmPayment(paymentId: string, details: PaymentDetails): Promise<PaymentResult>;
  refundPayment(paymentId: string, amount?: number): Promise<RefundResult>;
  getPaymentStatus(paymentId: string): Promise<PaymentStatus>;
  createCustomer(customerData: CustomerData): Promise<CustomerResult>;
  attachPaymentMethod(customerId: string, paymentMethod: PaymentMethodData): Promise<void>;
}
```

### Stripe Integration
```typescript
class StripePaymentProvider implements PaymentProviderInterface {
  private stripe: Stripe;
  
  constructor(private config: StripeConfig) {
    this.stripe = new Stripe(config.secretKey, {
      apiVersion: '2023-10-16',
      typescript: true
    });
  }
  
  async createPaymentIntent(request: PaymentIntentRequest): Promise<PaymentIntentResponse> {
    try {
      const paymentIntent = await this.stripe.paymentIntents.create({
        amount: request.amount,
        currency: request.currency,
        customer: request.customerId,
        payment_method_types: request.paymentMethods,
        metadata: {
          orderId: request.orderId,
          userId: request.userId
        },
        capture_method: 'manual' // For order verification
      });
      
      return {
        id: paymentIntent.id,
        clientSecret: paymentIntent.client_secret,
        status: paymentIntent.status,
        amount: paymentIntent.amount,
        currency: paymentIntent.currency
      };
    } catch (error) {
      throw new PaymentProviderError('Stripe payment intent creation failed', error);
    }
  }
  
  async confirmPayment(paymentId: string, details: PaymentDetails): Promise<PaymentResult> {
    const paymentIntent = await this.stripe.paymentIntents.confirm(paymentId, {
      payment_method: details.paymentMethodId,
      return_url: details.returnUrl
    });
    
    return {
      success: paymentIntent.status === 'succeeded',
      status: paymentIntent.status,
      transactionId: paymentIntent.id,
      charges: paymentIntent.charges.data.map(charge => ({
        id: charge.id,
        amount: charge.amount,
        status: charge.status,
        created: new Date(charge.created * 1000)
      }))
    };
  }
}
```

### PayPal Integration
```typescript
class PayPalPaymentProvider implements PaymentProviderInterface {
  private paypal: PayPalSDK;
  
  constructor(private config: PayPalConfig) {
    this.paypal = new PayPalSDK({
      client_id: config.clientId,
      client_secret: config.clientSecret,
      environment: config.environment // 'sandbox' or 'production'
    });
  }
  
  async createPaymentIntent(request: PaymentIntentRequest): Promise<PaymentIntentResponse> {
    const orderRequest = {
      intent: 'CAPTURE',
      purchase_units: [{
        amount: {
          currency_code: request.currency.toUpperCase(),
          value: (request.amount / 100).toString()
        },
        reference_id: request.orderId
      }],
      application_context: {
        return_url: request.returnUrl,
        cancel_url: request.cancelUrl
      }
    };
    
    const order = await this.paypal.orders.create(orderRequest);
    
    return {
      id: order.id,
      clientSecret: order.id, // PayPal uses order ID
      status: order.status,
      amount: request.amount,
      currency: request.currency,
      approvalUrl: order.links.find(link => link.rel === 'approve')?.href
    };
  }
}
```

### Payment Provider Factory
```typescript
class PaymentProviderFactory {
  private providers: Map<string, PaymentProviderInterface> = new Map();
  
  constructor() {
    this.registerProvider('stripe', new StripePaymentProvider(stripeConfig));
    this.registerProvider('paypal', new PayPalPaymentProvider(paypalConfig));
    this.registerProvider('square', new SquarePaymentProvider(squareConfig));
  }
  
  getProvider(providerId: string): PaymentProviderInterface {
    const provider = this.providers.get(providerId);
    if (!provider) {
      throw new Error(`Payment provider ${providerId} not found`);
    }
    return provider;
  }
  
  async processPayment(
    providerId: string, 
    request: PaymentIntentRequest
  ): Promise<PaymentIntentResponse> {
    const provider = this.getProvider(providerId);
    return await provider.createPaymentIntent(request);
  }
}
```

### Payment Webhook Handling
```typescript
interface WebhookHandler {
  handleStripeWebhook(event: StripeWebhookEvent): Promise<void>;
  handlePayPalWebhook(event: PayPalWebhookEvent): Promise<void>;
}

class PaymentWebhookService implements WebhookHandler {
  async handleStripeWebhook(event: StripeWebhookEvent): Promise<void> {
    switch (event.type) {
      case 'payment_intent.succeeded':
        await this.handlePaymentSuccess(event.data.object);
        break;
      case 'payment_intent.payment_failed':
        await this.handlePaymentFailure(event.data.object);
        break;
      case 'charge.dispute.created':
        await this.handleChargeback(event.data.object);
        break;
      default:
        console.log(`Unhandled Stripe event type: ${event.type}`);
    }
  }
  
  private async handlePaymentSuccess(paymentIntent: any): Promise<void> {
    const orderId = paymentIntent.metadata.orderId;
    await this.orderService.updateOrderStatus(orderId, 'PAID');
    await this.inventoryService.confirmReservation(orderId);
    await this.emailService.sendPaymentConfirmation(paymentIntent.metadata.userId);
  }
}
```

## 2. Shipping API Integrations

### Shipping Provider Interface
```typescript
interface ShippingProviderInterface {
  getRates(shipment: ShipmentRequest): Promise<ShippingRate[]>;
  createShipment(shipment: CreateShipmentRequest): Promise<ShipmentResult>;
  trackShipment(trackingNumber: string): Promise<TrackingInfo>;
  createLabel(shipmentId: string): Promise<LabelResult>;
  schedulePickup(pickup: PickupRequest): Promise<PickupResult>;
}
```

### FedEx Integration
```typescript
class FedExShippingProvider implements ShippingProviderInterface {
  private fedex: FedExAPI;
  
  constructor(private config: FedExConfig) {
    this.fedex = new FedExAPI({
      accountNumber: config.accountNumber,
      meterNumber: config.meterNumber,
      key: config.key,
      password: config.password,
      environment: config.environment
    });
  }
  
  async getRates(shipment: ShipmentRequest): Promise<ShippingRate[]> {
    const rateRequest = {
      RequestedShipment: {
        Shipper: {
          Address: shipment.fromAddress
        },
        Recipient: {
          Address: shipment.toAddress
        },
        PackageCount: shipment.packages.length,
        RequestedPackageLineItems: shipment.packages.map(pkg => ({
          Weight: { Units: 'LB', Value: pkg.weight },
          Dimensions: {
            Length: pkg.length,
            Width: pkg.width,
            Height: pkg.height,
            Units: 'IN'
          }
        }))
      }
    };
    
    const response = await this.fedex.ship.getRates(rateRequest);
    
    return response.RateReplyDetails.map(rate => ({
      serviceType: rate.ServiceType,
      serviceName: rate.ServiceDescription?.ServiceName,
      totalCharges: parseFloat(rate.RatedShipmentDetails[0].ShipmentRateDetail.TotalNetCharge.Amount),
      currency: rate.RatedShipmentDetails[0].ShipmentRateDetail.TotalNetCharge.Currency,
      deliveryDate: rate.DeliveryTimestamp,
      transitTime: rate.TransitTime
    }));
  }
  
  async trackShipment(trackingNumber: string): Promise<TrackingInfo> {
    const trackRequest = {
      SelectionDetails: [{
        PackageIdentifier: {
          Type: 'TRACKING_NUMBER_OR_DOORTAG',
          Value: trackingNumber
        }
      }]
    };
    
    const response = await this.fedex.track.getTrackingInfo(trackRequest);
    const trackDetail = response.CompletedTrackDetails[0].TrackDetails[0];
    
    return {
      trackingNumber,
      status: trackDetail.StatusDetail.Description,
      estimatedDelivery: trackDetail.EstimatedDeliveryTimestamp,
      actualDelivery: trackDetail.ActualDeliveryTimestamp,
      events: trackDetail.Events.map(event => ({
        timestamp: event.Timestamp,
        status: event.EventDescription,
        location: event.Address
      }))
    };
  }
}
```

### UPS Integration
```typescript
class UPSShippingProvider implements ShippingProviderInterface {
  private ups: UPSAPI;
  
  constructor(private config: UPSConfig) {
    this.ups = new UPSAPI({
      username: config.username,
      password: config.password,
      accessKey: config.accessKey,
      environment: config.environment
    });
  }
  
  async getRates(shipment: ShipmentRequest): Promise<ShippingRate[]> {
    const rateRequest = {
      UPSSecurity: this.ups.getSecurityCredentials(),
      RateRequest: {
        Request: {
          RequestOption: 'Rate'
        },
        Shipment: {
          Shipper: {
            Address: this.formatAddress(shipment.fromAddress)
          },
          ShipTo: {
            Address: this.formatAddress(shipment.toAddress)
          },
          Package: shipment.packages.map(pkg => ({
            PackagingType: { Code: '02' },
            Dimensions: {
              UnitOfMeasurement: { Code: 'IN' },
              Length: pkg.length.toString(),
              Width: pkg.width.toString(),
              Height: pkg.height.toString()
            },
            PackageWeight: {
              UnitOfMeasurement: { Code: 'LBS' },
              Weight: pkg.weight.toString()
            }
          }))
        }
      }
    };
    
    const response = await this.ups.rating.getRates(rateRequest);
    
    return response.RateResponse.RatedShipment.map(rate => ({
      serviceType: rate.Service.Code,
      serviceName: rate.Service.Description,
      totalCharges: parseFloat(rate.TotalCharges.MonetaryValue),
      currency: rate.TotalCharges.CurrencyCode,
      deliveryDate: rate.GuaranteedDelivery?.DeliveryByTime
    }));
  }
}
```

### Shipping Service Orchestrator
```typescript
class ShippingService {
  private providers: Map<string, ShippingProviderInterface> = new Map();
  
  constructor() {
    this.providers.set('fedex', new FedExShippingProvider(fedexConfig));
    this.providers.set('ups', new UPSShippingProvider(upsConfig));
    this.providers.set('usps', new USPSShippingProvider(uspsConfig));
    this.providers.set('dhl', new DHLShippingProvider(dhlConfig));
  }
  
  async getShippingRates(shipment: ShipmentRequest): Promise<ShippingRate[]> {
    const ratePromises = Array.from(this.providers.entries()).map(
      async ([providerId, provider]) => {
        try {
          const rates = await provider.getRates(shipment);
          return rates.map(rate => ({ ...rate, providerId }));
        } catch (error) {
          console.error(`Error getting rates from ${providerId}:`, error);
          return [];
        }
      }
    );
    
    const allRates = await Promise.all(ratePromises);
    return allRates.flat().sort((a, b) => a.totalCharges - b.totalCharges);
  }
  
  async createShipment(
    providerId: string, 
    shipment: CreateShipmentRequest
  ): Promise<ShipmentResult> {
    const provider = this.providers.get(providerId);
    if (!provider) {
      throw new Error(`Shipping provider ${providerId} not found`);
    }
    
    return await provider.createShipment(shipment);
  }
}
```

## 3. Inventory Management Integrations

### External Inventory Provider Interface
```typescript
interface InventoryProviderInterface {
  getInventoryLevels(skus: string[]): Promise<InventoryLevel[]>;
  updateInventoryLevels(updates: InventoryUpdate[]): Promise<void>;
  reserveInventory(reservation: InventoryReservation): Promise<ReservationResult>;
  releaseReservation(reservationId: string): Promise<void>;
  getSupplierInfo(supplierId: string): Promise<SupplierInfo>;
  createPurchaseOrder(order: PurchaseOrderRequest): Promise<PurchaseOrderResult>;
}
```

### TradeGecko Integration
```typescript
class TradeGeckoInventoryProvider implements InventoryProviderInterface {
  private api: TradeGeckoAPI;
  
  constructor(private config: TradeGeckoConfig) {
    this.api = new TradeGeckoAPI({
      clientId: config.clientId,
      clientSecret: config.clientSecret,
      redirectUri: config.redirectUri,
      environment: config.environment
    });
  }
  
  async getInventoryLevels(skus: string[]): Promise<InventoryLevel[]> {
    const variants = await this.api.variants.all({
      sku: skus.join(',')
    });
    
    const stockLevels = await Promise.all(
      variants.map(variant => 
        this.api.stockLevels.all({ variant_id: variant.id })
      )
    );
    
    return stockLevels.flat().map(stock => ({
      sku: stock.variant.sku,
      quantity: stock.available,
      reserved: stock.allocated,
      warehouse: stock.location.label,
      lastUpdated: new Date(stock.updated_at)
    }));
  }
  
  async reserveInventory(reservation: InventoryReservation): Promise<ReservationResult> {
    const allocations = await Promise.all(
      reservation.items.map(item =>
        this.api.stockAllocations.create({
          variant_id: item.variantId,
          quantity: item.quantity,
          order_id: reservation.orderId
        })
      )
    );
    
    return {
      reservationId: reservation.orderId,
      status: 'reserved',
      expiresAt: new Date(Date.now() + 15 * 60 * 1000), // 15 minutes
      allocations: allocations.map(alloc => ({
        id: alloc.id,
        sku: alloc.variant.sku,
        quantity: alloc.quantity
      }))
    };
  }
}
```

### NetSuite Integration
```typescript
class NetSuiteInventoryProvider implements InventoryProviderInterface {
  private netsuite: NetSuiteAPI;
  
  constructor(private config: NetSuiteConfig) {
    this.netsuite = new NetSuiteAPI({
      accountId: config.accountId,
      consumerKey: config.consumerKey,
      consumerSecret: config.consumerSecret,
      tokenId: config.tokenId,
      tokenSecret: config.tokenSecret
    });
  }
  
  async getInventoryLevels(skus: string[]): Promise<InventoryLevel[]> {
    const search = this.netsuite.search({
      type: 'inventoryitem',
      filters: [
        ['itemid', 'anyof', skus],
        'AND',
        ['isinactive', 'is', 'F']
      ],
      columns: [
        'itemid',
        'displayname',
        'quantityavailable',
        'quantityreserved',
        'quantityonorder',
        'location'
      ]
    });
    
    const results = await search.run();
    
    return results.map(item => ({
      sku: item.getValue('itemid'),
      quantity: parseInt(item.getValue('quantityavailable') || '0'),
      reserved: parseInt(item.getValue('quantityreserved') || '0'),
      onOrder: parseInt(item.getValue('quantityonorder') || '0'),
      warehouse: item.getText('location'),
      lastUpdated: new Date()
    }));
  }
  
  async createPurchaseOrder(order: PurchaseOrderRequest): Promise<PurchaseOrderResult> {
    const purchaseOrder = this.netsuite.record.create({
      type: 'purchaseorder'
    });
    
    purchaseOrder.setValue('entity', order.supplierId);
    purchaseOrder.setValue('trandate', new Date());
    
    order.items.forEach((item, index) => {
      purchaseOrder.setSublistValue({
        sublistId: 'item',
        fieldId: 'item',
        line: index,
        value: item.itemId
      });
      
      purchaseOrder.setSublistValue({
        sublistId: 'item',
        fieldId: 'quantity',
        line: index,
        value: item.quantity
      });
      
      purchaseOrder.setSublistValue({
        sublistId: 'item',
        fieldId: 'rate',
        line: index,
        value: item.unitPrice
      });
    });
    
    const poId = purchaseOrder.save();
    
    return {
      purchaseOrderId: poId.toString(),
      status: 'pending_approval',
      totalAmount: order.items.reduce((sum, item) => 
        sum + (item.quantity * item.unitPrice), 0
      ),
      estimatedDelivery: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000)
    };
  }
}
```

## 4. Integration Resilience and Error Handling

### Circuit Breaker Implementation
```typescript
class CircuitBreaker {
  private failures = 0;
  private lastFailTime = 0;
  private state: 'CLOSED' | 'OPEN' | 'HALF_OPEN' = 'CLOSED';
  
  constructor(
    private threshold: number = 5,
    private timeout: number = 60000,
    private monitoringPeriod: number = 10000
  ) {}
  
  async execute<T>(operation: () => Promise<T>): Promise<T> {
    if (this.state === 'OPEN') {
      if (Date.now() - this.lastFailTime > this.timeout) {
        this.state = 'HALF_OPEN';
      } else {
        throw new Error('Circuit breaker is OPEN');
      }
    }
    
    try {
      const result = await operation();
      this.onSuccess();
      return result;
    } catch (error) {
      this.onFailure();
      throw error;
    }
  }
  
  private onSuccess(): void {
    this.failures = 0;
    this.state = 'CLOSED';
  }
  
  private onFailure(): void {
    this.failures++;
    this.lastFailTime = Date.now();
    
    if (this.failures >= this.threshold) {
      this.state = 'OPEN';
    }
  }
}
```

### Retry Mechanism
```typescript
class RetryHandler {
  async executeWithRetry<T>(
    operation: () => Promise<T>,
    maxRetries: number = 3,
    backoffMs: number = 1000
  ): Promise<T> {
    let lastError: Error;
    
    for (let attempt = 0; attempt <= maxRetries; attempt++) {
      try {
        return await operation();
      } catch (error) {
        lastError = error as Error;
        
        if (attempt < maxRetries && this.isRetryableError(error)) {
          const delay = backoffMs * Math.pow(2, attempt);
          await this.sleep(delay);
          continue;
        }
        
        throw error;
      }
    }
    
    throw lastError!;
  }
  
  private isRetryableError(error: any): boolean {
    const retryableStatusCodes = [429, 500, 502, 503, 504];
    return retryableStatusCodes.includes(error.status) ||
           error.code === 'ECONNRESET' ||
           error.code === 'ETIMEDOUT';
  }
  
  private sleep(ms: number): Promise<void> {
    return new Promise(resolve => setTimeout(resolve, ms));
  }
}
```

### Integration Health Monitoring
```typescript
interface HealthCheck {
  name: string;
  status: 'healthy' | 'degraded' | 'unhealthy';
  responseTime: number;
  lastChecked: Date;
  details?: any;
}

class IntegrationHealthService {
  private healthChecks: Map<string, HealthCheck> = new Map();
  
  async checkAllIntegrations(): Promise<HealthCheck[]> {
    const checks = [
      this.checkStripeHealth(),
      this.checkFedExHealth(),
      this.checkInventoryHealth()
    ];
    
    const results = await Promise.allSettled(checks);
    
    return results.map((result, index) => {
      if (result.status === 'fulfilled') {
        return result.value;
      } else {
        return {
          name: ['stripe', 'fedex', 'inventory'][index],
          status: 'unhealthy' as const,
          responseTime: 0,
          lastChecked: new Date(),
          details: { error: result.reason.message }
        };
      }
    });
  }
  
  private async checkStripeHealth(): Promise<HealthCheck> {
    const start = Date.now();
    
    try {
      await stripe.balance.retrieve();
      return {
        name: 'stripe',
        status: 'healthy',
        responseTime: Date.now() - start,
        lastChecked: new Date()
      };
    } catch (error) {
      return {
        name: 'stripe',
        status: 'unhealthy',
        responseTime: Date.now() - start,
        lastChecked: new Date(),
        details: { error: error.message }
      };
    }
  }
}
```