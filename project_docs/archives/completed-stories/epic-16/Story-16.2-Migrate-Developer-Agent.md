# Story 16.2: Migrate Developer Agent to Sub-Agent

**Epic**: EPIC-016 (APM to Sub-Agents Migration)  
**Status**: Approved  
**Priority**: High  
**Story Points**: 5  
**Sprint**: 14  
**Dependencies**: Story 15.1  

## Story Statement

As a developer,  
I want to migrate the Developer agent to Claude Code sub-agent format,  
so that it maintains all existing capabilities while leveraging native sub-agent features.

## Acceptance Criteria

1. [ ] Developer agent migrated to `.claude/agents/developer.md`
2. [ ] All existing behaviors preserved (Code Quality Guardian mindset)
3. [ ] Parallel code review capabilities maintained (`/parallel-review`)
4. [ ] Voice notifications functional (`speakDeveloper.sh`)
5. [ ] Workspace boundaries enforced (workspace/src/, workspace/tests/)
6. [ ] Initialization protocol ported (5 parallel tasks)
7. [ ] Tool permissions configured appropriately
8. [ ] Communication standards followed
9. [ ] Session management integration working
10. [ ] Backward compatibility with `/dev` command

## Tasks/Subtasks

- [ ] Content Migration
  - [ ] Copy persona content from `.apm/agents/personas/dev.md`
  - [ ] Adapt to sub-agent YAML frontmatter format
  - [ ] Preserve all behavioral patterns and responsibilities
  
- [ ] Capability Preservation
  - [ ] Port parallel review functionality
  - [ ] Maintain code quality enforcement rules
  - [ ] Preserve story implementation approach
  - [ ] Keep performance optimization guidelines
  
- [ ] Integration Tasks
  - [ ] Configure tool permissions (Read, Write, Edit, MultiEdit, Bash, Grep, Glob, Task)
  - [ ] Integrate voice notification system
  - [ ] Maintain workspace boundary enforcement
  - [ ] Port initialization protocol
  
- [ ] Testing & Validation
  - [ ] Test sub-agent invocation ("Hey developer")
  - [ ] Verify parallel capabilities work
  - [ ] Confirm voice notifications function
  - [ ] Validate workspace boundaries
  - [ ] Test backward compatibility with `/dev`

## Dev Technical Guidance

- Preserve the exact persona content from the APM system
- Ensure the sub-agent can execute parallel tasks using Task tool
- Maintain the same voice script calls: `bash {{APM_ROOT}}/agents/voice/speakDeveloper.sh`
- Keep workspace boundaries: Primary (workspace/src/), Secondary (workspace/tests/), Forbidden (.apm/, .claude/)

## Story Progress Notes

**Agent Model Used**: Claude  
**Start Date**: TBD  
**Completion Date**: TBD  

### Completion Notes List:
- Developer agent fully migrated
- All parallel capabilities preserved
- Voice notifications working
- Backward compatibility verified

### Change Log

| Change | Date-Time | Version | Description | Author |
|--------|-----------|---------|-------------|---------|
| Created | 2025-07-25 | 1.0 | Initial story creation | PO |