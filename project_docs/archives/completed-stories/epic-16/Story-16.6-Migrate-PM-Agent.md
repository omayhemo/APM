# Story 16.6: Migrate PM Agent

**Epic**: EPIC-016 (APM to Sub-Agents Migration)  
**Status**: Approved  
**Priority**: High  
**Story Points**: 5  
**Sprint**: 15  

## Story Statement

As a developer,  
I want to migrate the PM Agent from APM to native Claude Code sub-agent,  
so that project management capabilities are preserved with improved context management.

## Acceptance Criteria

1. [ ] PM agent definition created in `.claude/agents/pm.md`
2. [ ] All project management capabilities preserved
3. [ ] Backlog management functions maintained
4. [ ] Sprint planning and tracking capabilities intact
5. [ ] Voice notifications working with speakPm.sh
6. [ ] Session management and handoff functionality preserved
7. [ ] Backward compatibility with existing `/pm` command maintained

## Tasks/Subtasks

- [ ] Create PM sub-agent definition file
  - [ ] Port persona from `.apm/agents/personas/pm.md`
  - [ ] Configure required tools (Read, Write, Edit, Bash, TodoWrite)
  - [ ] Include project management-specific permissions
  
- [ ] Migrate project management capabilities
  - [ ] Port backlog management functions
  - [ ] Preserve sprint planning capabilities
  - [ ] Maintain project tracking and reporting
  - [ ] Ensure stakeholder communication features
  
- [ ] Configure voice and session management
  - [ ] Link to speakPm.sh voice script
  - [ ] Preserve session note creation patterns
  - [ ] Maintain handoff capabilities
  
- [ ] Test and validate migration
  - [ ] Verify all PM commands functional
  - [ ] Test backlog management features
  - [ ] Validate sprint planning capabilities
  - [ ] Confirm voice notifications working

## Dev Technical Guidance

```yaml
# PM Agent Structure:
---
name: pm
description: Project Manager Agent for sprint planning and project coordination
tools:
  - Read
  - Write
  - Edit
  - Bash
  - Grep
  - Glob
  - TodoWrite
  - MultiEdit
---

# Key capabilities to preserve:
- Sprint planning and management
- Backlog grooming and prioritization
- Project tracking and reporting
- Stakeholder communication
- Risk management and mitigation
```

## Story Progress Notes

**Agent Model Used**: Claude  
**Start Date**: TBD  
**Completion Date**: TBD  

### Completion Notes List:
- PM agent fully migrated with all capabilities
- Project management functions operational
- Voice notifications working
- Handoff capabilities preserved

### Change Log

| Change | Date-Time | Version | Description | Author |
|--------|-----------|---------|-------------|---------|
| Created | 2025-07-25 | 1.0 | Initial story creation | PO |