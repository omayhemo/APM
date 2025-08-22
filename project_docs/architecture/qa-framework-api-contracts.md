# QA Framework API Contracts

## Introduction

This document defines the formal API contracts between the APM QA Agent and the QA Framework. These contracts ensure reliable, type-safe communication across the adapter layer while maintaining backward compatibility and extensibility.

## Contract Versioning

- **Current Version**: 1.0.0
- **Compatibility**: Semantic versioning (MAJOR.MINOR.PATCH)
- **Breaking Changes**: Require major version bump
- **Deprecation Policy**: 2 sprint notice before removal

## Core API Contracts

### 1. Test Execution Contract

#### Command: `/qa test-execute`

**Request Contract**
```typescript
interface TestExecuteRequest {
  version: "1.0.0";
  command: "test-execute";
  parameters: {
    suite: string;              // Required: Test suite identifier
    parallel?: boolean;         // Optional: Enable parallel execution (default: true)
    timeout?: number;          // Optional: Timeout in seconds (default: 300)
    environment?: string;      // Optional: Target environment (default: "test")
    tags?: string[];          // Optional: Filter tests by tags
    reportFormat?: "json" | "html" | "xml"; // Optional: Report format (default: "json")
  };
  context: {
    sessionId: string;        // APM session identifier
    agentId: "qa";           // Agent identifier
    timestamp: string;       // ISO 8601 timestamp
    workspace: string;       // Current workspace path
  };
}
```

**Response Contract**
```typescript
interface TestExecuteResponse {
  version: "1.0.0";
  status: "success" | "partial" | "failure";
  executionId: string;        // Unique execution identifier
  summary: {
    total: number;           // Total tests executed
    passed: number;          // Tests passed
    failed: number;          // Tests failed
    skipped: number;         // Tests skipped
    duration: number;        // Total execution time (ms)
    coverage?: number;       // Code coverage percentage
  };
  failures?: Array<{
    testName: string;
    error: string;
    stackTrace?: string;
    screenshot?: string;     // Path to failure screenshot
  }>;
  artifacts: {
    report: string;          // Path to detailed report
    logs: string;           // Path to execution logs
    coverage?: string;      // Path to coverage report
  };
  metadata: {
    frameworkVersion: string;
    executionTime: number;   // Adapter processing time (ms)
    parallelStreams?: number;
  };
}
```

### 2. Security Scan Contract

#### Command: `/qa security-scan`

**Request Contract**
```typescript
interface SecurityScanRequest {
  version: "1.0.0";
  command: "security-scan";
  parameters: {
    type: "sast" | "dast" | "both";     // Scan type
    target: string;                      // Project path or URL
    severity?: "critical" | "high" | "medium" | "low"; // Minimum severity
    compliance?: Array<"owasp" | "cwe" | "pci-dss" | "hipaa">; // Standards
    excludePaths?: string[];             // Paths to exclude
    timeout?: number;                    // Timeout in seconds (default: 600)
  };
  context: TestExecuteRequest["context"];
}
```

**Response Contract**
```typescript
interface SecurityScanResponse {
  version: "1.0.0";
  status: "success" | "failure";
  scanId: string;
  summary: {
    critical: number;
    high: number;
    medium: number;
    low: number;
    totalVulnerabilities: number;
    scanDuration: number;    // ms
  };
  vulnerabilities: Array<{
    id: string;             // CVE or CWE identifier
    severity: "critical" | "high" | "medium" | "low";
    title: string;
    description: string;
    location: {
      file: string;
      line?: number;
      column?: number;
    };
    remediation: string;
    references: string[];
  }>;
  compliance: {
    standard: string;
    passed: boolean;
    violations: string[];
  }[];
  artifacts: {
    fullReport: string;     // Path to detailed report
    sarif?: string;        // SARIF format report
  };
}
```

### 3. Performance Test Contract

#### Command: `/qa performance-test`

**Request Contract**
```typescript
interface PerformanceTestRequest {
  version: "1.0.0";
  command: "performance-test";
  parameters: {
    scenario: string;                    // Test scenario name
    users: number;                       // Virtual users
    duration: number;                    // Test duration (seconds)
    rampUp?: number;                    // Ramp-up time (seconds)
    targetRPS?: number;                 // Target requests per second
    thresholds?: {
      p95ResponseTime?: number;         // 95th percentile (ms)
      p99ResponseTime?: number;         // 99th percentile (ms)
      errorRate?: number;               // Max error rate (%)
      throughput?: number;              // Min throughput (rps)
    };
  };
  context: TestExecuteRequest["context"];
}
```

**Response Contract**
```typescript
interface PerformanceTestResponse {
  version: "1.0.0";
  status: "success" | "degraded" | "failure";
  testId: string;
  metrics: {
    throughput: {
      mean: number;         // Requests per second
      max: number;
      min: number;
    };
    responseTime: {
      mean: number;         // Milliseconds
      median: number;
      p95: number;
      p99: number;
      max: number;
    };
    errors: {
      total: number;
      rate: number;        // Percentage
      types: Record<string, number>;
    };
    concurrent: {
      users: number;
      connections: number;
    };
  };
  thresholdResults: Array<{
    metric: string;
    threshold: number;
    actual: number;
    passed: boolean;
  }>;
  artifacts: {
    report: string;
    graphs: string[];      // Paths to performance graphs
    raw: string;          // Raw performance data
  };
}
```

### 4. Analytics Query Contract

#### Command: `/qa analytics`

**Request Contract**
```typescript
interface AnalyticsQueryRequest {
  version: "1.0.0";
  command: "analytics-query";
  parameters: {
    query: "failure-prediction" | "test-optimization" | "coverage-trends" | "performance-history";
    timeRange?: {
      start: string;       // ISO 8601
      end: string;         // ISO 8601
    };
    filters?: {
      suites?: string[];
      tags?: string[];
      environment?: string;
    };
    limit?: number;        // Result limit (default: 100)
  };
  context: TestExecuteRequest["context"];
}
```

**Response Contract**
```typescript
interface AnalyticsQueryResponse {
  version: "1.0.0";
  status: "success" | "failure";
  queryId: string;
  results: {
    type: string;          // Query type echoed back
    data: Array<any>;      // Query-specific data structure
    insights: Array<{
      type: "warning" | "suggestion" | "trend";
      message: string;
      confidence: number;  // 0-1
      actionable: boolean;
      suggestedAction?: string;
    }>;
    visualization?: {
      type: "chart" | "table" | "heatmap";
      config: any;         // Visualization configuration
    };
  };
  metadata: {
    executionTime: number; // ms
    dataPoints: number;
    cacheHit: boolean;
  };
}
```

### 5. Framework Status Contract

#### Command: `/qa framework-status`

**Request Contract**
```typescript
interface FrameworkStatusRequest {
  version: "1.0.0";
  command: "framework-status";
  parameters: {
    components?: string[]; // Specific components to check
    detailed?: boolean;    // Include detailed diagnostics
  };
  context: TestExecuteRequest["context"];
}
```

**Response Contract**
```typescript
interface FrameworkStatusResponse {
  version: "1.0.0";
  status: "healthy" | "degraded" | "unhealthy";
  components: Array<{
    name: string;
    status: "healthy" | "degraded" | "unhealthy";
    version: string;
    uptime: number;        // Seconds
    lastError?: string;
    metrics?: {
      cpu: number;         // Percentage
      memory: number;      // MB
      activeTests: number;
      queuedTests: number;
    };
  }>;
  system: {
    totalMemory: number;   // MB
    availableMemory: number;
    cpuCount: number;
    loadAverage: number[];
  };
  capabilities: {
    maxParallel: number;
    supportedFormats: string[];
    enabledIntegrations: string[];
  };
}
```

## Error Contract

All API responses may return errors following this contract:

```typescript
interface ErrorResponse {
  version: "1.0.0";
  status: "error";
  error: {
    code: string;          // Machine-readable error code
    message: string;       // Human-readable message
    details?: any;         // Additional error context
    timestamp: string;     // ISO 8601
    requestId?: string;    // Original request ID
    suggestions?: string[]; // Suggested fixes
  };
  recovery?: {
    retryable: boolean;
    retryAfter?: number;   // Seconds
    fallback?: string;     // Alternative command
  };
}
```

### Standard Error Codes

| Code | Description | HTTP Equivalent |
|------|-------------|-----------------|
| `INVALID_REQUEST` | Malformed request | 400 |
| `UNAUTHORIZED` | Missing/invalid auth | 401 |
| `FORBIDDEN` | Insufficient permissions | 403 |
| `NOT_FOUND` | Resource not found | 404 |
| `TIMEOUT` | Operation timeout | 408 |
| `CONFLICT` | Resource conflict | 409 |
| `RATE_LIMITED` | Too many requests | 429 |
| `INTERNAL_ERROR` | Framework error | 500 |
| `NOT_IMPLEMENTED` | Feature not available | 501 |
| `SERVICE_UNAVAILABLE` | Framework offline | 503 |

## Adapter Implementation Requirements

### 1. Request Validation
```bash
validate_request() {
  local request=$1
  local schema=$2
  
  # Validate against JSON schema
  echo "$request" | jq --slurpfile schema "$schema" \
    'if . as $data | $schema[0] | . as $s | $data | type == $s.type then true else false end'
}
```

### 2. Version Negotiation
```bash
negotiate_version() {
  local requested=$1
  local supported=("1.0.0" "1.1.0")
  
  # Find compatible version
  for version in "${supported[@]}"; do
    if [[ "$version" == "$requested"* ]]; then
      echo "$version"
      return 0
    fi
  done
  
  return 1
}
```

### 3. Response Transformation
```bash
transform_response() {
  local framework_response=$1
  local contract_version=$2
  
  # Apply version-specific transformations
  case "$contract_version" in
    "1.0.0")
      transform_v1_response "$framework_response"
      ;;
    *)
      echo "$framework_response"
      ;;
  esac
}
```

## Contract Testing

### 1. Contract Test Suite
```bash
# Test request validation
test_valid_request() {
  local request='{"version":"1.0.0","command":"test-execute","parameters":{"suite":"unit"}}'
  validate_request "$request" "schemas/test-execute-request.json"
  assert_equals $? 0
}

# Test response generation
test_response_format() {
  local response=$(execute_test_suite "unit")
  validate_response "$response" "schemas/test-execute-response.json"
  assert_equals $? 0
}
```

### 2. Backward Compatibility Tests
```bash
# Ensure old requests still work
test_backward_compatibility() {
  local old_request='{"version":"0.9.0","command":"run-tests","suite":"unit"}'
  local response=$(handle_legacy_request "$old_request")
  assert_not_null "$response"
}
```

## Performance Guarantees

| Operation | Max Latency | Throughput |
|-----------|-------------|------------|
| Request Validation | 10ms | 10,000/sec |
| Response Transform | 50ms | 2,000/sec |
| Framework Call | 500ms | 100/sec |
| Result Aggregation | 100ms | 1,000/sec |

## Migration Guide

### From Direct Framework Calls
```bash
# Old way (direct)
qa-framework/core/test-engine.sh execute --suite=unit

# New way (via adapter)
/qa test-execute --suite=unit
```

### Response Handling
```bash
# Old way
result=$(run_tests)
if [[ "$result" == *"PASSED"* ]]; then
  echo "Tests passed"
fi

# New way
response=$(/qa test-execute --suite=unit)
status=$(echo "$response" | jq -r '.status')
if [[ "$status" == "success" ]]; then
  echo "Tests passed"
fi
```

---

*API Contracts defined by: Architect Agent*  
*Version: 1.0.0*  
*Status: Ready for Implementation*