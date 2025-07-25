# Story 16.8: Migrate SM Agent

**Epic**: EPIC-016 (APM to Sub-Agents Migration)  
**Status**: Approved  
**Priority**: High  
**Story Points**: 5  
**Sprint**: 15  

## Story Statement

As a developer,  
I want to migrate the SM Agent from APM to native Claude Code sub-agent,  
so that Scrum Master capabilities including parallel sprint coordination are preserved.

## Acceptance Criteria

1. [ ] SM agent definition created in `.claude/agents/sm.md`
2. [ ] All Scrum Master capabilities preserved
3. [ ] Parallel sprint coordination functionality maintained
4. [ ] Sprint facilitation and team coaching features intact
5. [ ] Voice notifications working with speakSm.sh
6. [ ] Session management and handoff functionality preserved
7. [ ] Backward compatibility with existing `/sm` command maintained

## Tasks/Subtasks

- [ ] Create SM sub-agent definition file
  - [ ] Port persona from `.apm/agents/personas/sm.md`
  - [ ] Configure required tools (Read, Write, Edit, Bash, TodoWrite)
  - [ ] Include Scrum Master-specific permissions
  
- [ ] Migrate Scrum Master capabilities
  - [ ] Port sprint facilitation functions
  - [ ] Preserve parallel sprint coordination (revolutionary feature)
  - [ ] Maintain team coaching and impediment removal
  - [ ] Ensure ceremony facilitation features
  
- [ ] Configure voice and session management
  - [ ] Link to speakSm.sh voice script
  - [ ] Preserve session note creation patterns
  - [ ] Maintain handoff capabilities
  
- [ ] Test and validate migration
  - [ ] Verify all SM commands functional
  - [ ] Test parallel sprint coordination features
  - [ ] Validate sprint facilitation capabilities
  - [ ] Confirm voice notifications working

## Dev Technical Guidance

```yaml
# SM Agent Structure:
---
name: sm
description: Scrum Master Agent with parallel sprint coordination capabilities
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
- Parallel sprint coordination (revolutionary capability)
- Sprint planning and retrospective facilitation
- Impediment identification and removal
- Team coaching and process improvement
- Multi-developer coordination (2-4 concurrent agents)
```

## Story Progress Notes

**Agent Model Used**: Claude  
**Start Date**: TBD  
**Completion Date**: TBD  

### Completion Notes List:
- SM agent fully migrated with all capabilities
- Parallel sprint coordination preserved
- Voice notifications working
- Team facilitation features operational

### Change Log

| Change | Date-Time | Version | Description | Author |
|--------|-----------|---------|-------------|---------|
| Created | 2025-07-25 | 1.0 | Initial story creation | PO |