# Context Templates for Sub-Agent Activation

This file contains natural language templates for passing context to sub-agents efficiently.

## Development Context Template

```markdown
I need a Developer agent to {task}.

Context:
- Working directory: {workingDirectory}
- Dependencies: {dependencies}
- Related files: {relatedFiles}
- Patterns to follow: {patterns}
- Test requirements: {testRequirements}
- Constraints: {constraints}

{specificInstructions}
```

### Example Usage:
```markdown
I need a Developer agent to implement the user authentication feature.

Context:
- Working directory: /project/src/auth
- Dependencies: express, passport, bcrypt, jsonwebtoken
- Related files: 
  - /project/src/models/User.js
  - /project/src/middleware/auth.js
  - /project/src/routes/auth.routes.js
- Patterns to follow: Repository pattern for data access, middleware for authentication
- Test requirements: Unit tests with 80% coverage, integration tests for all endpoints
- Constraints: Must support OAuth2.0, session timeout after 30 minutes

Please implement the login endpoint following our established patterns and ensure all tests pass.
```

## QA Context Template

```markdown
I need a QA agent to {testTask}.

Context:
- Component under test: {componentUnderTest}
- Test requirements: {testRequirements}
- Coverage goals: {coverageGoals}
- Test data location: {testDataPath}
- Quality standards: {qualityStandards}

{specificTestInstructions}
```

### Example Usage:
```markdown
I need a QA agent to create comprehensive test coverage for the payment processing module.

Context:
- Component under test: /project/src/payments/PaymentProcessor.js
- Test requirements: Unit tests, integration tests, edge case coverage
- Coverage goals: 90% line coverage, 85% branch coverage
- Test data location: /project/tests/fixtures/payment-data.json
- Quality standards: All critical paths tested, performance benchmarks met

Please create test suites that validate all payment methods and error scenarios.
```

## Architecture Context Template

```markdown
I need an Architect agent to {architectureTask}.

Context:
- System boundaries: {systemBoundaries}
- Architectural constraints: {constraints}
- Design patterns: {designPatterns}
- Integration points: {integrationPoints}
- Standards to follow: {standards}

{specificArchitectureInstructions}
```

### Example Usage:
```markdown
I need an Architect agent to design the microservices communication layer.

Context:
- System boundaries: User service, Order service, Payment service, Notification service
- Architectural constraints: Must support 10k concurrent users, <100ms latency
- Design patterns: Event-driven architecture, CQRS for order processing
- Integration points: REST APIs for sync, RabbitMQ for async communication
- Standards to follow: OpenAPI 3.0 for API specs, CloudEvents for event format

Please design the service mesh configuration and inter-service communication protocols.
```

## Analysis Context Template

```markdown
I need an Analyst agent to {analysisTask}.

Context:
- Data sources: {dataSources}
- Analysis criteria: {analysisCriteria}
- Reporting requirements: {reportingRequirements}
- Historical context: {historicalContext}
- Stakeholders: {stakeholders}

{specificAnalysisInstructions}
```

### Example Usage:
```markdown
I need an Analyst agent to analyze the performance metrics from the last sprint.

Context:
- Data sources: JIRA sprint data, Git commit history, CI/CD pipeline logs
- Analysis criteria: Velocity trends, bug density, cycle time, code churn
- Reporting requirements: Executive summary, detailed metrics, visual charts
- Historical context: Previous 3 sprints showed declining velocity
- Stakeholders: Product Owner, Development Team, CTO

Please provide insights on sprint performance and recommendations for improvement.
```

## Integration Context Template

```markdown
I need an Integration specialist to {integrationTask}.

Context:
- API contracts: {apiContracts}
- Interface definitions: {interfaces}
- Dependencies: {dependencies}
- Communication protocols: {protocols}
- Error handling patterns: {errorHandling}

{specificIntegrationInstructions}
```

### Example Usage:
```markdown
I need an Integration specialist to implement the third-party payment gateway integration.

Context:
- API contracts: POST /api/v1/payments, GET /api/v1/payments/{id}
- Interface definitions: PaymentGatewayInterface, PaymentResult, PaymentError
- Dependencies: Internal: OrderService, External: StripeAPI v2023-10
- Communication protocols: HTTPS with mTLS, webhook callbacks for async updates
- Error handling patterns: Exponential backoff for retries, circuit breaker pattern

Please implement the integration following our security standards and error handling practices.
```

## Context Size Guidelines

### Priority Levels:
1. **Critical** (Always include):
   - Task description
   - Working directory/paths
   - Direct dependencies
   - Target agent type

2. **Important** (Include if relevant):
   - Related files (max 3-5)
   - Patterns/standards (max 5)
   - Constraints/planning-requirements
   - Test/quality goals

3. **Helpful** (Include if space allows):
   - Examples
   - Historical context
   - Documentation links
   - Previous decisions

### Size Optimization Tips:
- Use bullet points instead of paragraphs
- Reference files by path rather than including content
- Summarize standards/patterns rather than full descriptions
- Link to detailed docs instead of embedding
- Focus on what's needed for the specific task

## Context Passing Best Practices

1. **Be Specific**: Clearly state what needs to be done
2. **Be Concise**: Every word should add value
3. **Be Organized**: Use consistent structure
4. **Be Relevant**: Only include context needed for the task
5. **Be Clear**: Avoid ambiguity in instructions

## Bidirectional Context Format

When sub-agents complete their tasks, they should return context in this format:

```markdown
## Task Completion Summary

**Task**: {completedTask}
**Status**: {status}
**Duration**: {duration}

### Key Decisions:
- {decision1}
- {decision2}

### Created Artifacts:
- {artifact1}: {path/description}
- {artifact2}: {path/description}

### Dependencies Added/Modified:
- {dependency1}: {version/reason}
- {dependency2}: {version/reason}

### Important for Other Agents:
- {sharedContext1}
- {sharedContext2}

### Warnings/Issues:
- {warning1}
- {warning2}

### Next Steps:
- {nextStep1}
- {nextStep2}
```

This ensures parent agents and peer agents can efficiently consume the results and maintain context coherence across the system.