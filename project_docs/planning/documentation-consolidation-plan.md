# Documentation Consolidation Plan

**Date**: 2025-07-23  
**Author**: Product Owner  
**Status**: Draft

## Current State

The APM agents folder has documentation scattered across three directories:

### 1. `/docs` folder (9 files)
- Quick reference guides (PARALLEL-*.md, PO-GROOM-*.md)
- Implementation reports
- 2 outdated files (TASK-*.md)

### 2. `/documentation` folder (1 file)
- parallel-retrofit-process.md (detailed process guide)

### 3. `/enhancements` folder (1 file)
- qa-senior-capabilities-enhancement-plan.md
- **This is sprint-related work that belongs in project_docs**

## Problems
1. Confusing to have both `/docs` and `/documentation` folders
2. Enhancement plans are project artifacts, not APM infrastructure
3. Harder to find relevant documentation

## Proposed Solution

### 1. Consolidate Documentation Folders
- Keep `/docs` as the single documentation directory
- Move `parallel-retrofit-process.md` from `/documentation` to `/docs`
- Delete empty `/documentation` folder
- Update templates to reflect this structure

### 2. Relocate Enhancement Plans
- Move `qa-senior-capabilities-enhancement-plan.md` to `/project_docs/planning/enhancements/`
- Create enhancements subfolder in project planning
- Delete `/enhancements` folder from APM agents
- This keeps project work separate from APM infrastructure

### 3. Clean Up Outdated Files
- Remove TASK-QUICK-REFERENCE.md
- Remove TASK-MANAGEMENT-GUIDE.md

## Final Structure

```
.apm/agents/
  docs/                                 # Single documentation folder
    PARALLEL-HANDOFF-*.md              # Keep
    PARALLEL-INITIALIZATION-*.md       # Keep
    PARALLEL-SUBTASK-*.md             # Keep
    PO-GROOM-QUICK-REFERENCE.md       # Keep
    ap-manager.md                      # Keep
    parallel-retrofit-process.md       # Moved from /documentation
    (Remove TASK-*.md files)

project_docs/
  planning/
    enhancements/                      # New folder
      qa-senior-capabilities-enhancement-plan.md  # Moved from agents
```

## Benefits
1. Single, clear location for APM documentation
2. Project work kept in project_docs where it belongs
3. Cleaner, more logical structure
4. Easier to maintain and find documents

## Implementation
Update Story 7.6 to include these consolidation tasks.