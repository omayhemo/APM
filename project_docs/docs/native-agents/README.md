# Native Sub-Agents Documentation

## Overview

Native sub-agents represent the evolution of the APM framework, providing direct integration with Claude Code CLI for superior performance and reliability.

## What are Native Sub-Agents?

Native sub-agents are APM agents that work directly with Claude Code's built-in capabilities rather than through the Task tool wrapper. This approach provides:

- **Direct tool access**: Agents use Read, Write, Bash, and other tools directly
- **Natural language coordination**: Human-readable agent activation
- **Parallel execution**: True concurrent multi-agent workflows
- **Better error handling**: Native error messages and recovery
- **Performance improvements**: 4-8x faster execution

## Architecture Benefits

### Before (Task-based)
```javascript
Task(description="Activate Developer", 
     prompt="Complex JSON structure...", 
     subagent_type="general-purpose")
```

### After (Native)
```
I need a Developer agent to implement Story 5.1.
Context: [Natural language context]
Please begin implementation following our standards.
```

## Key Features

1. **Context Preservation**: Agents maintain context through natural language
2. **Progress Visibility**: Real-time updates without wrapper overhead
3. **Error Recovery**: Graceful handling of failures
4. **Resource Efficiency**: Lower memory and CPU usage

## Available Native Agents

All 9 APM personas now support native operation:
- Orchestrator
- Developer
- Architect
- QA
- PM
- PO
- SM
- Analyst
- Design Architect

## Migration Status

✅ **Completed in v3.1.0** (Epic 17)
- All agents migrated to native patterns
- Backward compatibility maintained
- Performance validated at 4-8x improvement

## Best Practices

1. Use natural language for agent coordination
2. Provide clear context in activation messages
3. Leverage parallel execution for multi-agent workflows
4. Monitor session notes for coordination patterns

## Examples

See [Migration Guide](../migration/migration-guide.md) for conversion examples and [API Reference](../api/parallel-commands.md) for command documentation.

---
*Last updated: 2025-01-26*  
*Part of APM v3.1.0 - Native Sub-Agents Release*