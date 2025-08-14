# QA Framework Command

## 🎭 PERSONA CONTEXT ACTIVATION

**This command requires the QA persona.**

```markdown
*Loading QA context for quality assurance...*

Quick Context Load (1-2 seconds):
- Loading QA configuration and expertise
- Loading relevant frameworks and methodologies
- Voice notification: bash $/mnt/c/Code/agentic-persona-mapping/.apm/agents/voice/speakQA.sh "QA context loaded for quality assurance"
- Workspace validation: Ensuring execution from /mnt/c/Code/agentic-persona-mapping

*QA context ready. Proceeding with command...*
```


This command provides access to the comprehensive QA Framework with AI/ML-powered testing capabilities, security scanning, performance testing, and advanced analytics.

## Process

When invoked WITHOUT a sub-command, the assistant will:

1. **Present Framework Menu Only**
   - Display available sub-commands and capabilities
   - Show framework documentation
   - DO NOT run any actual tests or npm commands
   - Wait for user to specify a sub-command

2. **Important**: This command is a MENU/DOCUMENTATION command
   - DO NOT execute npm test, npm run, or any other commands automatically
   - Only present options and wait for user selection
   - Actual test execution requires explicit sub-commands

3. **Execute ONLY with Explicit Sub-command**
   - `/qa-framework test-execute` - Run comprehensive test suites
   - `/qa-framework security-scan` - Execute SAST/DAST security analysis
   - `/qa-framework performance-test` - Run load and performance tests
   - `/qa-framework analytics` - Query test analytics and generate reports

## Sub-Commands

### test-execute
Runs comprehensive test suites including:
- Unit tests
- Integration tests (Playwright-powered for browser testing)
- API tests (REST, GraphQL, WebSocket)
- UI/E2E tests (exclusively using Playwright MCP)
- Cross-browser compatibility (Playwright multi-browser support)
- Mobile responsive tests (Playwright device emulation)

Example: `/qa-framework test-execute --type api --parallel`

### security-scan
Performs security analysis:
- SAST (Static Application Security Testing)
- DAST (Dynamic Application Security Testing)
- Dependency vulnerability scanning
- OWASP compliance checking
- Security best practices validation

Example: `/qa-framework security-scan --type sast --severity high`

### performance-test
Executes performance testing:
- Load testing with configurable scenarios
- Stress testing to find breaking points
- Endurance testing for memory leaks
- Spike testing for sudden load changes
- Performance regression detection

Example: `/qa-framework performance-test --type load --users 1000`

### analytics
Provides test analytics and insights:
- Test execution trends
- Failure pattern analysis
- Coverage metrics
- Performance benchmarks
- Quality gates evaluation

Example: `/qa-framework analytics --report dashboard --period 30d`

## Playwright MCP Integration for Browser Testing

### Primary Browser Testing Tool
The QA Framework **exclusively uses Playwright MCP** for all browser-based testing:

- **Browser Automation**: All UI tests use Playwright's MCP tools
- **Cross-Browser Testing**: Chrome, Firefox, Safari, Edge via Playwright
- **Mobile Testing**: Device emulation and responsive testing
- **Visual Testing**: Screenshot comparison and visual regression
- **Network Interception**: API mocking and request monitoring
- **Performance Metrics**: Core Web Vitals and page performance

### Playwright Test Examples
```bash
# UI test using Playwright MCP
mcp__playwright__browser_navigate --url "https://app.example.com"
mcp__playwright__browser_snapshot  # Capture page state
mcp__playwright__browser_click --element "Login button" --ref "#login-btn"
mcp__playwright__browser_type --element "Username field" --ref "#username" --text "testuser"

# Visual regression with Playwright
mcp__playwright__browser_take_screenshot --filename "baseline.png"
# ... make changes ...
mcp__playwright__browser_take_screenshot --filename "current.png"
# Compare screenshots for visual regression

# Mobile responsive testing
mcp__playwright__browser_resize --width 375 --height 667  # iPhone SE
mcp__playwright__browser_snapshot  # Verify mobile layout
```

## PostgreSQL MCP Test Execution Data Management

### Centralized Test Data Hub
When PostgreSQL MCP is available, the QA framework automatically creates a centralized test execution hub with optimized storage and retrieval:

### Core Framework Schema
```sql
-- Central schema for all QA framework operations
CREATE SCHEMA IF NOT EXISTS qa_framework;

CREATE TABLE qa_framework.test_executions (
  id SERIAL PRIMARY KEY,
  execution_id UUID DEFAULT gen_random_uuid(),
  test_suite TEXT NOT NULL,
  test_name TEXT NOT NULL,
  test_type TEXT NOT NULL, -- unit, integration, api, ui, security, performance
  status TEXT NOT NULL, -- passed, failed, skipped, error
  execution_time_ms INTEGER,
  error_message TEXT,
  stack_trace TEXT,
  environment TEXT,
  browser TEXT, -- for UI tests
  device TEXT, -- for mobile tests
  executed_at TIMESTAMP DEFAULT NOW(),
  commit_hash TEXT,
  branch TEXT,
  metadata JSONB,
  artifacts_path TEXT[] -- screenshots, logs, reports
);

CREATE TABLE qa_framework.test_suites (
  id SERIAL PRIMARY KEY,
  suite_name TEXT UNIQUE NOT NULL,
  suite_type TEXT NOT NULL,
  configuration JSONB,
  last_executed TIMESTAMP,
  total_tests INTEGER DEFAULT 0,
  passing_tests INTEGER DEFAULT 0,
  failing_tests INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE qa_framework.quality_gates (
  id SERIAL PRIMARY KEY,
  gate_name TEXT NOT NULL,
  gate_type TEXT NOT NULL, -- coverage, performance, security
  threshold_value DECIMAL(10,4),
  current_value DECIMAL(10,4),
  status TEXT, -- passed, failed, warning
  evaluated_at TIMESTAMP DEFAULT NOW(),
  execution_id UUID REFERENCES qa_framework.test_executions(execution_id)
);

-- High-performance indexes for test execution queries
CREATE INDEX idx_test_executions_suite_time ON qa_framework.test_executions(test_suite, executed_at DESC);
CREATE INDEX idx_test_executions_status_type ON qa_framework.test_executions(status, test_type);
CREATE INDEX idx_test_executions_commit ON qa_framework.test_executions(commit_hash, executed_at DESC);
CREATE INDEX idx_test_executions_environment ON qa_framework.test_executions(environment, executed_at DESC);
```

### Advanced Test Analytics Queries
```sql
-- Comprehensive test suite health dashboard
WITH suite_stats AS (
  SELECT 
    test_suite,
    test_type,
    COUNT(*) as total_executions,
    COUNT(*) FILTER (WHERE status = 'passed') as passed_count,
    COUNT(*) FILTER (WHERE status = 'failed') as failed_count,
    AVG(execution_time_ms) as avg_execution_time,
    PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY execution_time_ms) as p95_execution_time
  FROM qa_framework.test_executions
  WHERE executed_at >= NOW() - INTERVAL '7 days'
  GROUP BY test_suite, test_type
)
SELECT 
  test_suite,
  test_type,
  total_executions,
  ROUND((passed_count::float / total_executions * 100), 2) as success_rate,
  ROUND(avg_execution_time::numeric, 0) as avg_time_ms,
  ROUND(p95_execution_time::numeric, 0) as p95_time_ms,
  CASE 
    WHEN passed_count::float / total_executions > 0.95 THEN 'HEALTHY'
    WHEN passed_count::float / total_executions > 0.90 THEN 'WARNING'
    ELSE 'CRITICAL'
  END as health_status
FROM suite_stats
ORDER BY success_rate DESC, avg_execution_time;

-- Flaky test detection with statistical analysis
SELECT 
  test_name,
  test_suite,
  COUNT(*) as total_runs,
  COUNT(*) FILTER (WHERE status = 'failed') as failure_count,
  ROUND((COUNT(*) FILTER (WHERE status = 'failed')::float / COUNT(*) * 100), 2) as failure_rate,
  ROUND(STDDEV(execution_time_ms)::numeric, 0) as time_variance,
  array_agg(DISTINCT error_message) FILTER (WHERE error_message IS NOT NULL) as unique_errors
FROM qa_framework.test_executions
WHERE executed_at >= NOW() - INTERVAL '30 days'
GROUP BY test_name, test_suite
HAVING 
  COUNT(*) >= 10 AND 
  COUNT(*) FILTER (WHERE status = 'failed') > 0 AND
  COUNT(*) FILTER (WHERE status = 'failed')::float / COUNT(*) BETWEEN 0.05 AND 0.95
ORDER BY failure_rate DESC;
```

### Quality Gates Integration
```sql
-- Automated quality gate evaluation
INSERT INTO qa_framework.quality_gates (gate_name, gate_type, threshold_value, current_value, status, execution_id)
SELECT 
  'Test Coverage' as gate_name,
  'coverage' as gate_type,
  80.0 as threshold_value,
  (
    SELECT (metadata->>'coverage_percentage')::decimal
    FROM qa_framework.test_executions 
    WHERE execution_id = $1 
    AND metadata->>'coverage_percentage' IS NOT NULL
    LIMIT 1
  ) as current_value,
  CASE 
    WHEN (metadata->>'coverage_percentage')::decimal >= 80.0 THEN 'passed'
    WHEN (metadata->>'coverage_percentage')::decimal >= 70.0 THEN 'warning'
    ELSE 'failed'
  END as status,
  $1 as execution_id
FROM qa_framework.test_executions
WHERE execution_id = $1;
```

### Performance Benefits
- **100x faster test result queries** compared to file-based storage
- **Real-time test execution tracking** with immediate status updates
- **Advanced analytics** using PostgreSQL's statistical functions
- **Concurrent access** for multiple test runners
- **ACID compliance** ensuring data integrity during parallel test execution

## Implementation

When the command is invoked:

1. **Parallel Initialization** (5 tasks)
   ```
   Task 1: Load QA framework configuration
   Task 2: Check test environment status
   Task 3: Verify tool availability
   Task 4: Load historical test data
   Task 5: Initialize analytics engine
   ```

2. **Framework Activation**
   - Navigate to `.apm/qa-framework/` directory
   - Source framework environment
   - Load available plugins and extensions
   - Display framework dashboard

3. **Sub-command Processing**
   - Parse sub-command and options
   - Validate parameters
   - Execute appropriate framework scripts
   - Stream results in real-time
   - Generate comprehensive reports

4. **Results Integration**
   - Update test metrics in `.apm/qa-framework/metrics/`
   - Log results to analytics database
   - Trigger any configured webhooks
   - Update quality gates status

## Options

- `--type <type>` - Specify test type (unit, integration, api, ui, security, performance)
- `--parallel` - Enable parallel test execution
- `--tags <tags>` - Filter tests by tags
- `--env <environment>` - Target environment (dev, staging, prod)
- `--report <format>` - Output format (console, html, json, markdown)
- `--threshold <value>` - Set pass/fail threshold
- `--dry-run` - Preview what would be executed

## Integration with APM

This command integrates with:
- **QA Agent** - Activates QA persona for test planning
- **Developer Agent** - Coordinates on test failures
- **Architect Agent** - Validates architectural compliance
- **Analytics System** - Feeds data for predictions

## Example Usage

```bash
# Run all API tests in parallel
/qa-framework test-execute --type api --parallel

# Perform security scan with high severity focus
/qa-framework security-scan --severity high --report markdown

# Load test with 500 concurrent users
/qa-framework performance-test --type load --users 500 --duration 10m

# Generate quality dashboard for last sprint
/qa-framework analytics --report dashboard --period sprint
```

## Voice Notifications

Uses QA voice script for status updates:
```bash
bash ${AP_ROOT}/agents/voice/speakQa.sh "QA Framework activated. Initializing test environment..."
```

---
*Part of the APM QA Framework Suite*