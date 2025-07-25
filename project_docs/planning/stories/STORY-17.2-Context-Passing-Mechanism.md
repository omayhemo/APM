# Story 17.2: Implement Context Passing Mechanism

**Story ID**: 17.2  
**Epic**: Epic 17 - Parallel Commands to Native Sub-Agents Migration  
**Sprint**: 18 - Foundation Phase  
**Points**: 5  
**Priority**: High  
**Status**: Ready for Development  
**Dependencies**: Story 17.1

## Story Description

As a developer using native sub-agents, I want an efficient context passing mechanism so that sub-agents receive the necessary information without overwhelming their dedicated context windows.

## Business Value

Enable sub-agents to operate with relevant context while maintaining the performance benefits of dedicated context windows. This is critical for effective parallel execution.

## Acceptance Criteria

### 1. Context Extraction ✓
**Given** a parent agent with full project context  
**When** spawning a sub-agent for a specific task  
**Then** the system should:
- [ ] Extract only relevant context for the sub-agent's task
- [ ] Include essential project information (paths, configurations)
- [ ] Add task-specific requirements and constraints
- [ ] Maintain context size under 10% of available window
- [ ] Format context clearly in natural language

### 2. Natural Language Context Passing ✓
**Given** the need to pass context to a sub-agent  
**When** activating the agent  
**Then** the context should be:
- [ ] Embedded in the activation prompt naturally
- [ ] Clear and unambiguous
- [ ] Focused on the specific task
- [ ] Include relevant file paths and dependencies
- [ ] Avoid unnecessary technical details

### 3. Context Templates ✓
**Given** different types of parallel commands  
**When** creating context for sub-agents  
**Then** templates should exist for:
- [ ] Development tasks (file paths, dependencies, patterns)
- [ ] QA tasks (test requirements, coverage goals)
- [ ] Architecture tasks (design constraints, standards)
- [ ] Analysis tasks (data sources, criteria)
- [ ] Integration tasks (API contracts, interfaces)

### 4. Bidirectional Context ✓
**Given** sub-agents producing results  
**When** they complete their tasks  
**Then** the system should:
- [ ] Capture key findings and decisions
- [ ] Format results for parent agent consumption
- [ ] Preserve important context for other agents
- [ ] Enable context sharing between parallel agents
- [ ] Maintain context coherence across agents

### 5. Performance Optimization ✓
**Given** the need for efficient context passing  
**When** activating multiple sub-agents  
**Then** the system should:
- [ ] Minimize context duplication
- [ ] Share common context efficiently
- [ ] Measure context overhead (<10%)
- [ ] Optimize activation prompt length
- [ ] Cache frequently used context

## Technical Design

### Context Passing Pattern
```markdown
# Example activation with context:
"I need a Developer agent to implement the user authentication feature.

Context:
- Working directory: /project/src/auth
- Dependencies: express, passport, bcrypt
- Existing patterns: See /project/src/patterns/auth-pattern.js
- API contract: POST /api/auth/login expects {email, password}
- Test requirements: Unit tests with 80% coverage

Please implement the login endpoint following our established patterns."
```

### Context Templates

#### Development Context Template
```markdown
"I need a Developer agent to {task}.

Context:
- Working directory: {path}
- Dependencies: {dependencies}
- Related files: {files}
- Patterns to follow: {patterns}
- Constraints: {constraints}

{specific_instructions}"
```

#### QA Context Template
```markdown
"I need a QA agent to {test_task}.

Context:
- Component under test: {component}
- Test requirements: {requirements}
- Coverage goals: {coverage}
- Test data location: {data_path}
- Quality standards: {standards}

{specific_test_instructions}"
```

## Implementation Approach

1. **Identify Context Patterns** - Analyze existing Task tool usage for context needs
2. **Create Templates** - Build natural language templates for each persona
3. **Optimize Size** - Ensure context stays under 10% of window
4. **Test Effectiveness** - Verify sub-agents have sufficient context
5. **Document Patterns** - Create guide for context passing

## Architect's Implementation Details

### Context Optimization Strategy

#### 1. Smart Context Extraction
```javascript
// Context extraction utility
function extractRelevantContext(fullContext, taskType, targetAgent) {
  const contextBuilder = {
    // Always include core paths
    workingDirectory: fullContext.projectPath,
    
    // Task-specific extraction
    development: () => ({
      dependencies: extractDirectDependencies(fullContext.task),
      relatedFiles: findRelatedFiles(fullContext.task, 3), // Max 3 files
      patterns: extractRelevantPatterns(fullContext.codebase)
    }),
    
    qa: () => ({
      testRequirements: fullContext.testStrategy,
      coverageGoals: fullContext.qualityMetrics,
      testData: fullContext.testDataPath
    }),
    
    architecture: () => ({
      constraints: fullContext.architecturalDecisions,
      standards: fullContext.codingStandards,
      integrationPoints: extractIntegrationPoints(fullContext.task)
    })
  };
  
  return contextBuilder[taskType]();
}
```

#### 2. Context Size Management
```javascript
// Ensure context stays under 10% (20k tokens)
function optimizeContextSize(context) {
  const MAX_CONTEXT_TOKENS = 20000;
  
  // Priority-based trimming
  const priorities = {
    critical: ['workingDirectory', 'dependencies', 'task'],
    important: ['relatedFiles', 'patterns', 'constraints'],
    helpful: ['examples', 'documentation', 'history']
  };
  
  let currentSize = estimateTokens(context);
  
  if (currentSize > MAX_CONTEXT_TOKENS) {
    // Trim from lowest priority
    for (const priority of ['helpful', 'important']) {
      for (const field of priorities[priority]) {
        if (context[field] && currentSize > MAX_CONTEXT_TOKENS) {
          context[field] = summarize(context[field]);
          currentSize = estimateTokens(context);
        }
      }
    }
  }
  
  return context;
}
```

#### 3. Context Caching Pattern
```javascript
// Cache common context to reduce redundancy
const contextCache = new Map();

function getCachedContext(key) {
  const cached = contextCache.get(key);
  if (cached && !isStale(cached)) {
    return cached.context;
  }
  return null;
}

function cacheContext(key, context) {
  contextCache.set(key, {
    context,
    timestamp: Date.now(),
    hits: 0
  });
}
```

### Natural Language Context Formatting

#### Structured Context Block
```markdown
Context Structure:
┌─────────────────────────────────┐
│ Task Summary (1-2 sentences)    │
├─────────────────────────────────┤
│ Essential Context:              │
│ • Working paths                 │
│ • Key dependencies              │
│ • Critical constraints          │
├─────────────────────────────────┤
│ Task-Specific Details:          │
│ • Relevant files/patterns       │
│ • Requirements/standards        │
│ • Integration points            │
├─────────────────────────────────┤
│ Clear Instructions              │
└─────────────────────────────────┘
```

### Bidirectional Context Handling

#### Result Extraction Pattern
```javascript
// Extract key information from sub-agent results
function extractKeyFindings(agentResult) {
  return {
    decisions: extractDecisions(agentResult),
    createdArtifacts: extractArtifacts(agentResult),
    dependencies: extractNewDependencies(agentResult),
    warnings: extractWarnings(agentResult),
    nextSteps: extractNextSteps(agentResult)
  };
}

// Format for parent consumption
function formatForParent(findings) {
  return `
Sub-agent completed: ${findings.summary}

Key Decisions:
${findings.decisions.map(d => `- ${d}`).join('\n')}

Created:
${findings.createdArtifacts.map(a => `- ${a}`).join('\n')}

Important for other agents:
${findings.dependencies.map(d => `- ${d}`).join('\n')}
`;
}
```

### Performance Monitoring

```javascript
// Track context efficiency
const contextMetrics = {
  averageSize: 0,
  successRate: 0,
  cacheHitRate: 0,
  
  track(contextSize, success, cacheHit) {
    // Update rolling averages
    this.averageSize = (this.averageSize * 0.9) + (contextSize * 0.1);
    this.successRate = (this.successRate * 0.95) + (success ? 0.05 : 0);
    this.cacheHitRate = (this.cacheHitRate * 0.9) + (cacheHit ? 0.1 : 0);
  },
  
  report() {
    return {
      avgContextSize: `${this.averageSize} tokens`,
      successRate: `${(this.successRate * 100).toFixed(1)}%`,
      cacheEfficiency: `${(this.cacheHitRate * 100).toFixed(1)}%`
    };
  }
};
```

### Integration Considerations

1. **With Story 17.1 Framework**: Context passing must integrate seamlessly with the agent spawning mechanism
2. **With Progress Monitoring**: Include context size in progress reports
3. **With Backward Compatibility**: Support both new optimized and legacy full context modes

### Technical Challenges & Solutions

| Challenge | Solution |
|-----------|----------|
| Dynamic context needs | Build adaptive templates that expand based on task complexity |
| Cross-agent context sharing | Implement shared context pool with versioning |
| Context staleness | Add TTL and refresh mechanisms |
| Security concerns | Sanitize sensitive data before passing |

## Success Metrics

- Context size: <10% of available window (20k tokens max)
- Sub-agent success rate: >95% with provided context
- No context-related failures
- Clear, maintainable templates
- Efficient context sharing

## Example Implementation

```markdown
# For /parallel-sprint command context passing:

"I need a Developer agent to work on Story 17.2: Context Passing Mechanism.

Sprint Context:
- Current sprint: 18 (Foundation Phase)
- Sprint goal: Build native sub-agent coordination
- Dependencies: Story 17.1 must be complete
- Working directory: /mnt/c/Code/agentic-persona-mapping
- Key files: project_docs/planning/stories/STORY-17.2-*.md

Your task: Implement efficient context extraction and passing for sub-agents,
ensuring they receive only relevant information for their specific tasks."
```

## Risks and Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| Context too large | High | Strict size limits and templates |
| Missing critical context | Medium | Comprehensive templates |
| Context confusion | Low | Clear formatting standards |

## Definition of Done

- [ ] All acceptance criteria met
- [ ] Context templates created for all personas
- [ ] Context size optimization verified
- [ ] Integration with Story 17.1 framework
- [ ] Documentation complete
- [ ] Peer review completed

---

**Created**: 2025-07-25  
**Product Owner**: PO Agent  
**Target Completion**: Sprint 18 End