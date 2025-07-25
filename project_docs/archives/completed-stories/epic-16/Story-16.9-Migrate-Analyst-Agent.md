# Story 16.9: Migrate Analyst Agent

**Epic**: EPIC-016 (APM to Sub-Agents Migration)  
**Status**: Approved  
**Priority**: High  
**Story Points**: 5  
**Sprint**: 15  

## Story Statement

As a developer,  
I want to migrate the Analyst Agent from APM to native Claude Code sub-agent,  
so that business analysis and requirements gathering capabilities are preserved.

## Acceptance Criteria

1. [ ] Analyst agent definition created in `.claude/agents/analyst.md`
2. [ ] All business analysis capabilities preserved
3. [ ] Requirements gathering and documentation functions maintained
4. [ ] Data analysis and reporting features intact
5. [ ] Voice notifications working with speakAnalyst.sh
6. [ ] Session management and handoff functionality preserved  
7. [ ] Backward compatibility with existing `/analyst` command maintained

## Tasks/Subtasks

- [ ] Create Analyst sub-agent definition file
  - [ ] Port persona from `.apm/agents/personas/analyst.md`
  - [ ] Configure required tools (Read, Write, Edit, Bash, Grep, Glob)
  - [ ] Include business analysis-specific permissions
  
- [ ] Migrate business analysis capabilities
  - [ ] Port requirements gathering functions
  - [ ] Preserve data analysis and visualization
  - [ ] Maintain stakeholder interview and documentation
  - [ ] Ensure process analysis and improvement features
  
- [ ] Configure voice and session management
  - [ ] Link to speakAnalyst.sh voice script
  - [ ] Preserve session note creation patterns
  - [ ] Maintain handoff capabilities
  
- [ ] Test and validate migration
  - [ ] Verify all Analyst commands functional
  - [ ] Test requirements gathering capabilities
  - [ ] Validate data analysis features
  - [ ] Confirm voice notifications working

## Dev Technical Guidance

```yaml
# Analyst Agent Structure:
---
name: analyst
description: Business Analyst Agent for requirements gathering and process analysis
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
- Business requirements gathering and documentation
- Stakeholder interview facilitation
- Process analysis and improvement recommendations
- Data analysis and visualization
- Gap analysis and solution design
```

## Story Progress Notes

**Agent Model Used**: Claude  
**Start Date**: TBD  
**Completion Date**: TBD  

### Completion Notes List:
- Analyst agent fully migrated with all capabilities
- Business analysis functions operational
- Voice notifications working
- Requirements gathering features preserved

### Change Log

| Change | Date-Time | Version | Description | Author |
|--------|-----------|---------|-------------|---------|
| Created | 2025-07-25 | 1.0 | Initial story creation | PO |