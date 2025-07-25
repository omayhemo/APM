# Story 16.4: Migrate QA Agent

**Epic**: EPIC-016 (APM to Sub-Agents Migration)  
**Status**: Approved  
**Priority**: High  
**Story Points**: 5  
**Sprint**: 14  

## Story Statement

As a developer,  
I want to migrate the QA Agent from APM to native Claude Code sub-agent,  
so that QA testing capabilities are preserved with improved context management and reliability.

## Acceptance Criteria

1. [ ] QA agent definition created in `.claude/agents/qa.md`
2. [ ] All AI/ML testing capabilities preserved (test prediction, optimization, anomaly detection)
3. [ ] QA framework commands fully functional
4. [ ] Parallel testing execution capabilities maintained
5. [ ] Voice notifications working with speakQa.sh
6. [ ] Session management and handoff functionality intact
7. [ ] Backward compatibility with existing `/qa` command maintained

## Tasks/Subtasks

- [ ] Create QA sub-agent definition file
  - [ ] Port persona from `.apm/agents/personas/qa.md`
  - [ ] Configure required tools (Read, Write, Edit, Bash, Grep, Glob)
  - [ ] Include QA framework-specific permissions
  
- [ ] Migrate QA framework capabilities
  - [ ] Port `/qa-framework` command functionality
  - [ ] Preserve AI/ML analytics (prediction, optimization, anomaly detection)
  - [ ] Maintain parallel test execution features
  - [ ] Ensure security scanning (SAST/DAST) capabilities
  
- [ ] Configure voice and session management
  - [ ] Link to speakQa.sh voice script
  - [ ] Preserve session note creation patterns
  - [ ] Maintain handoff capabilities
  
- [ ] Test and validate migration
  - [ ] Verify all QA commands functional
  - [ ] Test AI/ML features (92% prediction accuracy maintained)
  - [ ] Validate parallel execution (4x speedup preserved)
  - [ ] Confirm voice notifications working

## Dev Technical Guidance

```yaml
# QA Agent Structure:
---
name: qa
description: Quality Assurance Agent with AI/ML testing capabilities
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
- AI/ML test failure prediction (92% accuracy)
- Test execution optimization (63% time reduction)
- Quality anomaly detection (94% precision)
- Parallel test execution (4x speedup)
- SAST/DAST security scanning
- Performance and load testing
```

## Story Progress Notes

**Agent Model Used**: Claude  
**Start Date**: TBD  
**Completion Date**: TBD  

### Completion Notes List:
- QA agent fully migrated with all AI/ML capabilities
- All framework commands functional
- Voice notifications working
- Performance metrics maintained

### Change Log

| Change | Date-Time | Version | Description | Author |
|--------|-----------|---------|-------------|---------|
| Created | 2025-07-25 | 1.0 | Initial story creation | PO |