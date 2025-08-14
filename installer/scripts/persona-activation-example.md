# Example: Modified /next-story Command Template

## Before Modification:

```markdown
---
name: next-story
description: Sequential story creation with guided development
metadata:
  version: 1.0.0
  agent: Scrum Master
  performance: sequential
  approach: guided
---

# Sequential Next-story Command

**Scrum Master Agent Only**: Executes structured next-story...
```

## After Modification:

```markdown
---
name: next-story
description: Sequential story creation with guided development
metadata:
  version: 1.0.0
  agent: Scrum Master
  performance: sequential
  approach: guided
---

## 🎭 PERSONA CONTEXT ACTIVATION

**This command requires the Scrum Master persona.**

```markdown
*Loading Scrum Master context for optimal command execution...*

Quick Context Load (1-2 seconds):
- Loading Scrum Master configuration and expertise
- Loading relevant templates and frameworks  
- Voice notification: bash {{SPEAK_SM}} "Scrum Master context loaded for command execution"
- Workspace validation: Ensuring execution from {{PROJECT_ROOT}}

*Scrum Master context ready. Proceeding with command...*
```

# Sequential Next-story Command

**Scrum Master Agent Only**: Executes structured next-story...
[Rest of original content continues unchanged]
```

## Key Features:

1. **Lightweight**: Only 1-2 seconds overhead
2. **Voice Feedback**: Users hear which persona is handling their command
3. **No State Tracking**: Each command is self-contained
4. **Workspace Validation**: Ensures proper directory context
5. **Original Logic Preserved**: All existing command functionality remains

## Commands That Will Be Modified (75 total):

### High Priority (Phase 1):
- next-story → Scrum Master
- parallel-next-story → Scrum Master  
- epic → Product Owner
- parallel-epic → Product Owner
- groom → Product Owner
- qa-framework → QA
- run-tests → QA
- test-plan → QA

### Medium Priority (Phase 2):
- requirements → Analyst
- doc-compliance → Analyst
- organize-docs → Analyst
- architecture → Architect
- frontend-architecture → Design Architect
- prd → Project Manager

### All Parallel Commands (Phase 3):
All parallel-* versions of persona commands

## Commands That Will NOT Be Modified (30 total):

### Utility Commands (20):
- git-commit-all
- buildit
- release
- version
- session-note-setup
- wrap
- handoff
- switch
- etc.

### Direct Persona Activations (10):
- /analyst
- /architect
- /dev
- /pm
- /po
- /qa
- /sm
- etc.