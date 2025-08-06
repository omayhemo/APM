# Claude Code Parallel Agent Bug Report

## Problem
**BUG**: Claude Code fails when launching 6+ parallel sub-agents despite documentation stating support for up to 10 concurrent sub-agents. Results in Node.js MaxListenersExceededWarning and API connection failures with "fetch failed" errors.

## Root Cause
- Node.js default EventListener limit: 50
- Each sub-agent creates multiple abort listeners
- 6+ agents exceed this limit, breaking connection handling

## Immediate Workarounds

### 1. Limit Parallel Agents
- Maximum 3-4 agents per batch
- Stagger launches with 2-3 second delays between batches

### 2. Environment Settings
```bash
export NODE_OPTIONS="--max-old-space-size=4096 --max-http-header-size=16384"
export UV_THREADPOOL_SIZE=128
```

**Note**: The event listener limit (`MaxListenersExceededWarning`) cannot be set via NODE_OPTIONS. It must be set programmatically in Claude Code itself with `process.setMaxListeners(100)` or similar.

### 3. Recommended Limits
- Code Review: 3-4 agents max
- Development: 4 agents max
- Architecture: 2-3 agents max
- Testing: 3 agents max

## Required Fix from Anthropic
**This is a platform bug that violates documented capabilities.** Claude Code team needs to:

1. Add `process.setMaxListeners(100)` or similar to handle documented 10 sub-agent limit
2. Implement proper connection pooling for sub-agents  
3. Better manage AbortSignal listeners to prevent leaks
4. Update the platform to match documented concurrent sub-agent capabilities

**Expected**: 10 concurrent sub-agents as documented
**Actual**: Crashes at 6+ sub-agents with MaxListenersExceededWarning

## Testing
Before launching multiple agents:
```bash
ss -tn | grep -E ':443|:80' | wc -l
```
If > 30 connections, wait before launching more.