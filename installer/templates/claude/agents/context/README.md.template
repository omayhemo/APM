# Context Passing Mechanism

A comprehensive system for efficiently passing context to sub-agents while maintaining performance and relevance.

## Overview

The Context Passing Mechanism enables parent agents to spawn sub-agents with precisely the right amount of context needed for their specific tasks. It implements intelligent extraction, optimization, caching, and monitoring to ensure sub-agents receive relevant information without overwhelming their dedicated context windows.

## Key Features

- **Smart Context Extraction**: Extracts only relevant context for specific task types
- **Priority-based Optimization**: Trims context to stay under 10% of available window (20k tokens max)
- **Intelligent Caching**: Reduces redundancy through TTL-based caching
- **Performance Monitoring**: Tracks efficiency metrics and optimization effectiveness
- **Bidirectional Context**: Captures key findings from sub-agents for parent consumption
- **Natural Language Templates**: Clear, structured context formatting for different agent types

## Architecture

### Core Components

1. **Context Manager** (`context-manager.js`) - Main orchestrator
2. **Context Extractor** (`context-extractor.js`) - Extracts relevant context by task type
3. **Context Optimizer** (`context-optimizer.js`) - Ensures size limits through priority-based trimming
4. **Context Cache** (`context-cache.js`) - Manages caching for efficiency
5. **Bidirectional Context** (`bidirectional-context.js`) - Processes sub-agent results
6. **Performance Monitor** (`performance-monitor.js`) - Tracks metrics and optimization
7. **Context Templates** (`context-templates.md`) - Natural language formatting templates

## Usage

### Basic Context Preparation

```javascript
const { getContextManager } = require('./context-manager.js');

const contextManager = getContextManager();

// Prepare context for a Developer agent
const result = await contextManager.prepareContext(
  fullContext,           // Complete parent context
  'development',         // Task type
  'developer',          // Target agent type
  'Implement user authentication feature' // Specific instructions
);

if (result.success) {
  const naturalLanguageContext = contextManager.formatContextForAgent(
    result.context,
    'development'
  );
  
  // Use naturalLanguageContext to activate sub-agent
  console.log(naturalLanguageContext);
}
```

### Processing Sub-Agent Results

```javascript
// After sub-agent completes its task
const processedResult = contextManager.processSubAgentResult(
  result.contextId,
  subAgentOutput
);

if (processedResult.success) {
  console.log('Key Findings:', processedResult.findings);
  console.log('Formatted Result:', processedResult.formattedResult);
}
```

## Context Templates

The system provides pre-built templates for different agent types:

### Development Context
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

### QA Context
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

### Architecture Context
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

## Optimization Strategy

### Priority-Based Trimming

Context fields are prioritized for optimization:

1. **Critical** (Always preserved):
   - Working directory
   - Dependencies
   - Task description
   - Target agent

2. **Important** (Summarized if needed):
   - Related files
   - Patterns
   - Constraints
   - Test requirements

3. **Helpful** (Trimmed first):
   - Examples
   - Documentation
   - History
   - Suggestions

### Size Management

- Maximum context size: 20,000 tokens (10% of available window)
- Intelligent field-specific optimization
- Aggressive trimming for oversized contexts
- Token estimation and validation

## Caching System

### Cache Features

- **TTL-based expiration**: Default 15 minutes
- **LRU eviction**: Removes least recently used entries
- **Size monitoring**: Tracks cache efficiency
- **Hit rate optimization**: Improves over time

### Cache Key Strategy

Cache keys are generated from:
- Task type
- Target agent type
- Hashed task description

This enables reuse for similar tasks while maintaining specificity.

## Performance Monitoring

### Tracked Metrics

- **Context size**: Average, max, trends
- **Success rate**: Context effectiveness
- **Cache hit rate**: Caching efficiency
- **Processing time**: Optimization overhead
- **Agent-specific breakdown**: Per-agent type metrics

### Performance Reports

```javascript
// Get current metrics
const metrics = contextManager.getMetrics();

// Generate detailed report
const report = contextManager.generatePerformanceReport();
```

### Success Metrics

- Context size: <10% of available window (20k tokens max)
- Sub-agent success rate: >95% with provided context
- Cache hit rate: >60% for efficiency
- Processing time: <5 seconds for context preparation

## Integration with Story 17.1

The Context Passing Mechanism integrates seamlessly with the Native Sub-Agent Framework:

1. **Activation Integration**: Context is prepared and formatted during agent spawning
2. **Progress Monitoring**: Context size included in progress reports  
3. **Backward Compatibility**: Supports both optimized and legacy full context modes
4. **Session Management**: Context IDs track active sub-agent sessions

## Configuration Options

```javascript
const contextManager = getContextManager({
  maxContextSize: 20000,      // Maximum tokens
  enableCaching: true,        // Enable context caching
  enableOptimization: true,   // Enable size optimization
  enableMonitoring: true,     // Enable performance tracking
  cacheTimeout: 900000        // Cache TTL (15 minutes)
});
```

## Error Handling

The system includes robust error handling:

- **Validation**: Ensures critical fields are preserved
- **Fallbacks**: Graceful degradation for optimization failures
- **Monitoring**: Tracks and alerts on performance issues
- **Recovery**: Maintains functionality even with cache failures

## Security Considerations

- **Data Sanitization**: Sensitive information filtered before passing
- **Context Isolation**: Each sub-agent receives only necessary context
- **Cache Security**: Cached contexts are properly isolated
- **Audit Trail**: Context passing events are logged for monitoring

## Best Practices

1. **Be Specific**: Clearly state what needs to be done
2. **Be Concise**: Every word should add value to the context
3. **Be Organized**: Use consistent template structure
4. **Be Relevant**: Only include context needed for the specific task
5. **Be Clear**: Avoid ambiguity in instructions

## Troubleshooting

### Common Issues

1. **Context Too Large**: 
   - Enable optimization
   - Review template verbosity
   - Increase aggressive trimming

2. **Low Success Rate**:
   - Review failed context passes
   - Improve template relevance
   - Add missing critical information

3. **Poor Cache Performance**:
   - Review cache key strategy
   - Adjust TTL settings
   - Monitor cache hit patterns

4. **Slow Processing**:
   - Optimize extraction logic
   - Reduce context complexity
   - Enable caching

## Future Enhancements

- **AI-powered context relevance scoring**
- **Dynamic template adjustment based on success rates**
- **Cross-agent context sharing pools**
- **Real-time context optimization suggestions**
- **Integration with external knowledge bases**

## Examples

See `context-templates.md` for comprehensive examples of context formatting for each agent type.

## Metrics Dashboard

The system provides comprehensive metrics for monitoring context passing efficiency:

- Context size trends
- Success rate by agent type
- Cache performance
- Optimization effectiveness
- Processing time analysis

This enables continuous improvement of the context passing mechanism based on real usage patterns.