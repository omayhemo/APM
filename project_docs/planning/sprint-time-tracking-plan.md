# Sprint Time Tracking System - Implementation Plan

**Date**: 2025-07-23  
**Author**: Product Owner  
**Status**: Draft

## Executive Summary

This plan outlines the implementation of a comprehensive time tracking system for sprints and tasks within the APM framework. The system will automatically track start/end timestamps, calculate durations, and archive completed sprints.

## Requirements

### Sprint Level Tracking
1. **Sprint Start Timestamp**: When first developer begins work
2. **Sprint End Timestamp**: When all stories are completed
3. **Sprint Duration**: Calculated total time (end - start)
4. **Sprint Archive**: Move completed sprints to `planning/sprint-archive/`

### Task Level Tracking
1. **Task Start Timestamp**: When developer begins work on task
2. **Task End Timestamp**: When task is marked complete
3. **Task Duration**: Calculated time spent (end - start)
4. **Cumulative Time**: Track total time across multiple work sessions

### Backlog.md Format Updates

#### Current Sprint Section Format
```markdown
### Sprint Tracking

| Sprint | Planned Points | Started | Completed | Duration | Status |
|--------|---------------|---------|-----------|----------|--------|
| Sprint 1 | 13 | 2025-01-20 09:00:00 | 2025-01-22 16:30:00 | 2d 7h 30m | Completed |
| Sprint 2 | 14 | 2025-07-23 10:30:00 | - | - | In Progress |
```

#### Story Format with Time Tracking
```markdown
### Story 2.1: Section Classification System
- **Status**: In Progress
- **Started**: 2025-07-23 10:30:00
- **Completed**: -
- **Duration**: 3h 45m (ongoing)
- **Work Sessions**:
  - 2025-07-23 10:30:00 - 12:15:00 (1h 45m) - Initial implementation
  - 2025-07-23 14:00:00 - 16:00:00 (2h) - Testing and refinement
```

## Implementation Components

### 1. Backlog.md Template Updates
- Add Sprint Tracking table
- Add time tracking fields to story template
- Add work session tracking for interrupted work

### 2. Agent Persona Updates

#### Developer Agent
- **New Responsibility**: Update task timestamps when starting/completing work
- **Commands**: 
  - `/start-task [story-id]` - Mark task start with timestamp
  - `/complete-task [story-id]` - Mark task complete with timestamp
- **Automatic Tracking**: Update duration calculations in backlog

#### Scrum Master Agent
- **New Responsibility**: Track sprint start/end times
- **Commands**:
  - `/start-sprint [sprint-id]` - Mark sprint start
  - `/complete-sprint [sprint-id]` - Mark sprint complete and archive
- **Sprint Archival**: Move to `planning/sprint-archive/[SPRINT-ID]-Completed.md`

#### Product Owner Agent
- **New Responsibility**: Enforce time tracking compliance
- **Validation**: Ensure all stories have proper timestamps
- **Reporting**: Generate time-based metrics

### 3. CLAUDE.md Template Updates

Add new section:
```markdown
## ⏱️ TIME TRACKING REQUIREMENTS

**MANDATORY FOR ALL AGENTS**: Time tracking must be maintained for all sprints and tasks.

### Sprint Time Tracking
- **Sprint Start**: Mark timestamp when first developer begins work
- **Sprint End**: Mark timestamp when all stories complete
- **Sprint Archive**: Move to planning/sprint-archive/ when done

### Task Time Tracking  
- **Task Start**: Mark timestamp when beginning work on any story
- **Task End**: Mark timestamp when marking story as Done
- **Work Sessions**: Track interrupted work with session timestamps
- **Duration Calculation**: Auto-calculate and update in backlog.md

### Enforcement
- Developer agents MUST update timestamps
- Scrum Master MUST track sprint times
- Product Owner MUST validate compliance
```

### 4. New Checklists

#### Developer Time Tracking Checklist
```markdown
- [ ] Before starting work: Update story with start timestamp
- [ ] During work: Note any interruptions/resume times
- [ ] After completing: Update story with end timestamp
- [ ] Calculate duration: Update total time spent
- [ ] Update backlog.md: Commit time tracking updates
```

#### Sprint Completion Checklist
```markdown
- [ ] Verify all stories completed
- [ ] Update sprint end timestamp
- [ ] Calculate sprint duration
- [ ] Create sprint archive file
- [ ] Move sprint details to archive
- [ ] Update backlog metrics
```

## Technical Implementation

### 1. Timestamp Format
- Standard: `YYYY-MM-DD HH:MM:SS` (24-hour format)
- Timezone: Use project's configured timezone (default UTC)

### 2. Duration Calculation
- Format: `Xd Yh Zm` (days, hours, minutes)
- For ongoing work: Show "(ongoing)" suffix
- Precision: Round to nearest minute

### 3. Archive Structure
```
planning/
  sprint-archive/
    Sprint-1-Completed.md
    Sprint-2-Completed.md
    ...
```

### 4. Automated Scripts
- Create helper scripts for timestamp formatting
- Duration calculation utilities
- Archive automation scripts

## Rollout Plan

### Phase 1: Infrastructure (1 story point)
- Update backlog.md template
- Create sprint-archive directory structure
- Add timestamp utilities

### Phase 2: Agent Updates (3 story points)
- Update Developer persona with time tracking
- Update Scrum Master with sprint tracking
- Update Product Owner with validation rules

### Phase 3: Documentation (2 story points)
- Update CLAUDE.md template
- Create time tracking checklists
- Add examples to all templates

### Phase 4: Testing & Validation (2 story points)
- Test with sample sprint
- Validate calculations
- Refine based on feedback

## Success Metrics
- 100% of tasks have start/end timestamps
- Sprint durations accurately calculated
- All completed sprints properly archived
- Time tracking adds < 1 minute overhead per task

## Risks & Mitigation
- **Risk**: Agents forget to track time
  - **Mitigation**: Add pre-flight checks to agent commands
- **Risk**: Timezone confusion
  - **Mitigation**: Standardize on UTC with clear documentation
- **Risk**: Archive corruption
  - **Mitigation**: Create backups before archiving

## Next Steps
1. Create epic and stories in backlog
2. Prioritize against current work
3. Assign to appropriate sprint
4. Begin implementation

---
*Plan created by Product Owner on 2025-07-23*