# Story 16.10: Migrate Design Architect Agent

**Epic**: EPIC-016 (APM to Sub-Agents Migration)  
**Status**: Approved  
**Priority**: High  
**Story Points**: 5  
**Sprint**: 15  

## Story Statement

As a developer,  
I want to migrate the Design Architect Agent from APM to native Claude Code sub-agent,  
so that UI/UX design and system design capabilities are preserved with improved context management.

## Acceptance Criteria

1. [ ] Design Architect agent definition created in `.claude/agents/design-architect.md`
2. [ ] All UI/UX design capabilities preserved
3. [ ] System design and architecture functions maintained
4. [ ] Design pattern and best practices guidance intact
5. [ ] Voice notifications working with speakDesignArchitect.sh
6. [ ] Session management and handoff functionality preserved
7. [ ] Backward compatibility with existing `/design-architect` command maintained

## Tasks/Subtasks

- [ ] Create Design Architect sub-agent definition file
  - [ ] Port persona from `.apm/agents/personas/design-architect.md`
  - [ ] Configure required tools (Read, Write, Edit, Bash, WebSearch)
  - [ ] Include design-specific permissions
  
- [ ] Migrate design architecture capabilities
  - [ ] Port UI/UX design guidance functions
  - [ ] Preserve system architecture design
  - [ ] Maintain design pattern recommendations
  - [ ] Ensure accessibility and usability expertise
  
- [ ] Configure voice and session management
  - [ ] Link to speakDesignArchitect.sh voice script
  - [ ] Preserve session note creation patterns
  - [ ] Maintain handoff capabilities
  
- [ ] Test and validate migration
  - [ ] Verify all Design Architect commands functional
  - [ ] Test design guidance capabilities
  - [ ] Validate architecture design features
  - [ ] Confirm voice notifications working

## Dev Technical Guidance

```yaml
# Design Architect Structure:
---
name: design-architect
description: Design Architect Agent for UI/UX and system design
tools:
  - Read
  - Write
  - Edit
  - Bash
  - Grep
  - Glob
  - TodoWrite
  - MultiEdit
  - WebSearch
  - WebFetch
---

# Key capabilities to preserve:
- UI/UX design principles and guidance
- System architecture and design patterns
- Accessibility and usability best practices
- Design system creation and maintenance
- Cross-platform design considerations
```

## Story Progress Notes

**Agent Model Used**: Claude  
**Start Date**: TBD  
**Completion Date**: TBD  

### Completion Notes List:
- Design Architect agent fully migrated
- All design capabilities operational
- Voice notifications working
- Architecture design features preserved

### Change Log

| Change | Date-Time | Version | Description | Author |
|--------|-----------|---------|-------------|---------|
| Created | 2025-07-25 | 1.0 | Initial story creation | PO |