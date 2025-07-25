# Story 16.5: Implement Orchestrator Coordinator

**Epic**: EPIC-016 (APM to Sub-Agents Migration)  
**Status**: Approved  
**Priority**: High  
**Story Points**: 3  
**Sprint**: 14  

## Story Statement

As a user,  
I want an Orchestrator Coordinator that can route to and coordinate sub-agents,  
so that I have seamless agent coordination and delegation capabilities in the new system.

## Acceptance Criteria

1. [ ] Orchestrator coordinator implemented in `.claude/agents/orchestrator.md`
2. [ ] Agent routing capabilities functional (can delegate to other sub-agents)
3. [ ] Parallel task coordination preserved
4. [ ] Voice notifications working with speakOrchestrator.sh
5. [ ] Session management and handoff capabilities intact
6. [ ] Backward compatibility with `/ap` and `/ap_orchestrator` commands
7. [ ] Integration with all migrated sub-agents working

## Tasks/Subtasks

- [ ] Create Orchestrator sub-agent definition
  - [ ] Port orchestrator persona from `.apm/agents/personas/orchestrator.md`
  - [ ] Configure comprehensive tool permissions
  - [ ] Include agent delegation capabilities
  
- [ ] Implement agent routing logic
  - [ ] Create delegation patterns for sub-agents
  - [ ] Preserve parallel task coordination
  - [ ] Maintain session handoff capabilities
  
- [ ] Configure coordination features
  - [ ] Link to speakOrchestrator.sh voice script
  - [ ] Preserve session note management
  - [ ] Maintain multi-agent workflow capabilities
  
- [ ] Test integration with migrated agents
  - [ ] Verify delegation to Developer, Architect, QA agents
  - [ ] Test parallel coordination features
  - [ ] Validate voice and session management

## Dev Technical Guidance

```yaml
# Orchestrator Structure:
---
name: orchestrator
description: Central coordinator for multi-agent workflows and delegation
tools:
  - Read
  - Write
  - Edit
  - Bash
  - Grep
  - Glob
  - TodoWrite
  - MultiEdit
  # All tools needed for comprehensive coordination
---

# Key coordination patterns:
- Agent delegation and routing
- Parallel task orchestration
- Session management and handoffs
- Multi-agent workflow coordination
```

## Story Progress Notes

**Agent Model Used**: Claude  
**Start Date**: TBD  
**Completion Date**: TBD  

### Completion Notes List:
- Orchestrator coordinator fully functional
- All delegation capabilities working
- Integration with sub-agents complete
- Voice notifications operational

### Change Log

| Change | Date-Time | Version | Description | Author |
|--------|-----------|---------|-------------|---------|
| Created | 2025-07-25 | 1.0 | Initial story creation | PO |