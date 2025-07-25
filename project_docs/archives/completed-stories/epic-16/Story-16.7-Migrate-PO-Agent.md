# Story 16.7: Migrate PO Agent

**Epic**: EPIC-016 (APM to Sub-Agents Migration)  
**Status**: Approved  
**Priority**: High  
**Story Points**: 5  
**Sprint**: 15  

## Story Statement

As a developer,  
I want to migrate the PO Agent from APM to native Claude Code sub-agent,  
so that product ownership capabilities are preserved with improved context management.

## Acceptance Criteria

1. [ ] PO agent definition created in `.claude/agents/po.md`
2. [ ] All product ownership capabilities preserved
3. [ ] Backlog grooming and story management functions maintained
4. [ ] Product vision and strategy capabilities intact
5. [ ] Voice notifications working with speakPo.sh
6. [ ] Session management and handoff functionality preserved
7. [ ] Backward compatibility with existing `/po` command maintained

## Tasks/Subtasks

- [ ] Create PO sub-agent definition file
  - [ ] Port persona from `.apm/agents/personas/po.md`
  - [ ] Configure required tools (Read, Write, Edit, Bash, TodoWrite)
  - [ ] Include product management-specific permissions
  
- [ ] Migrate product ownership capabilities
  - [ ] Port backlog grooming functions
  - [ ] Preserve story creation and management
  - [ ] Maintain product vision and strategy features
  - [ ] Ensure stakeholder requirement gathering
  
- [ ] Configure voice and session management
  - [ ] Link to speakPo.sh voice script
  - [ ] Preserve session note creation patterns
  - [ ] Maintain handoff capabilities
  
- [ ] Test and validate migration
  - [ ] Verify all PO commands functional
  - [ ] Test story grooming capabilities
  - [ ] Validate product strategy features
  - [ ] Confirm voice notifications working

## Dev Technical Guidance

```yaml
# PO Agent Structure:
---
name: po
description: Product Owner Agent for backlog management and product strategy
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
- Backlog grooming and prioritization
- Story creation and acceptance criteria
- Product vision and roadmap management  
- Stakeholder requirement gathering
- Feature specification and validation
```

## Story Progress Notes

**Agent Model Used**: Claude  
**Start Date**: TBD  
**Completion Date**: TBD  

### Completion Notes List:
- PO agent fully migrated with all capabilities
- Product ownership functions operational
- Voice notifications working
- Story management features preserved

### Change Log

| Change | Date-Time | Version | Description | Author |
|--------|-----------|---------|-------------|---------|
| Created | 2025-07-25 | 1.0 | Initial story creation | PO |