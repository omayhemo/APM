# APM to Claude Code Sub-Agents Migration Plan

**Date**: 2025-07-25  
**Author**: AP Orchestrator  
**Status**: Draft Plan  

## Executive Summary

This document outlines a comprehensive migration strategy to transform the Agentic Persona Mapping (APM) framework from command-based personas to native Claude Code sub-agents, while preserving all existing persona definitions, capabilities, and behavioral patterns.

## Key Principle: Preserve Existing Personas

**YES - This design maintains ALL your existing personas with:**
- Exact same roles and responsibilities
- Same behavioral patterns and communication styles
- Same specialized capabilities (parallel execution, AI/ML features)
- Same voice notifications and session management
- Same workspace boundaries and rules

## Migration Strategy Overview

### Phase 1: Foundation (Week 1)
- Create `.claude/agents/` directory structure
- Convert core agents (Developer, Architect, QA) while preserving their exact personas
- Implement orchestrator as primary coordinator with same delegation patterns

### Phase 2: Enhancement (Week 2)
- Migrate specialized agents (PM, PO, SM, Analyst, Design Architect)
- Port ALL parallel execution capabilities unchanged
- Integrate existing voice notification system

### Phase 3: Advanced Features (Week 3)
- Preserve all AI/ML QA capabilities
- Maintain parallel sprint coordination functionality
- Create agent chaining workflows matching current handoff patterns

### Phase 4: Transition (Week 4)
- Dual-mode operation: Both `/ap` commands and sub-agent invocation work
- Gradual transition preserving user workflows
- Update documentation while maintaining backward compatibility

## Detailed Persona Preservation

### 1. Sub-Agent Structure (Mirrors Current APM)

```
.claude/agents/
├── orchestrator.md      # AP Orchestrator persona preserved
├── developer.md         # Developer persona with all parallel capabilities
├── architect.md         # Architect with same decisive leadership style
├── qa.md               # QA with full AI/ML framework
├── pm.md               # PM with investigative approach
├── po.md               # PO as backlog guardian
├── sm.md               # SM with parallel sprint capabilities
├── analyst.md          # Analyst with brainstorming expertise
└── design-architect.md # Design Architect with UI/UX focus
```

### 2. Persona Definition Template (Preserving Existing Content)

```markdown
---
name: developer
description: Expert Senior Software Engineer & Code Quality Guardian
tools:
  - Read
  - Write
  - Edit
  - MultiEdit
  - Bash
  - Grep
  - Glob
  - Task
---

# Developer Sub-Agent

[ENTIRE CONTENT FROM .apm/agents/personas/dev.md COPIED HERE]

## Core Responsibilities [PRESERVED]
- Story implementation with comprehensive testing
- Code quality and security enforcement  
- Performance optimization
- Mandatory backlog.md updates

## Working Directories [UNCHANGED]
- Primary: workspace/src/
- Tests: workspace/tests/
- Forbidden: .apm/, .claude/

## Parallel Capabilities [FULLY MAINTAINED]
- /parallel-review: 9 parallel analysis tasks
- Multi-developer coordination support

## Voice Notifications [PRESERVED]
bash {{APM_ROOT}}/agents/voice/speakDeveloper.sh "message"
```

### 3. Preserving Unique Persona Characteristics

#### AP Orchestrator
- Central coordination hub (unchanged)
- Session note management (preserved)
- Delegation patterns (maintained)
- Voice announcements for all actions

#### Analyst Agent  
- Brainstorming BA and RA Expert (same role)
- Creative problem-solving focus (preserved)
- Parallel requirements analysis (maintained)

#### Architect Agent
- Decisive Solution Architect persona (unchanged)
- Technical leadership style (preserved)
- Parallel architecture creation (maintained)

#### Developer Agent
- Code Quality Guardian mindset (preserved)
- Story-focused implementation (unchanged)
- Parallel code review capabilities (maintained)

#### PM Agent
- Investigative Product Strategist (same approach)
- Market-savvy perspective (preserved)
- Parallel PRD creation (maintained)

#### PO Agent
- Technical Product Owner role (unchanged)
- Backlog guardian responsibility (preserved)
- Parallel validation capabilities (maintained)

#### QA Agent
- Full AI/ML framework (completely preserved)
- Test prediction, optimization, anomaly detection (unchanged)
- Parallel test execution (maintained)

#### SM Agent
- Revolutionary parallel sprint capability (preserved)
- 2-4 developer coordination (unchanged)
- Sprint facilitation expertise (maintained)

#### Design Architect
- UI/UX & Frontend focus (preserved)
- Accessibility expertise (unchanged)
- Component architecture approach (maintained)

### 4. Preserving Advanced Features

#### Parallel Execution (100% Preserved)
```python
# Same parallel patterns in sub-agent prompts:
"Execute these tasks in parallel using Task tool:
- Task 1: Load PRD and requirements
- Task 2: Load architecture template
- Task 3: Check existing documentation
- Task 4: Load communication standards
- Task 5: Load technical constraints"
```

#### Voice Notifications (Unchanged)
```bash
# Exact same voice scripts referenced:
bash /mnt/c/Code/agentic-persona-mapping/.apm/agents/voice/speakDeveloper.sh "Status update"
```

#### Session Management (Maintained)
- Same session note format
- Same directory structure  
- Same archival process
- Same handoff documentation

### 5. Command Compatibility Matrix

| Current Command | Sub-Agent Invocation | Behavior |
|----------------|---------------------|----------|
| `/ap` | "Hey orchestrator" | Identical initialization sequence |
| `/dev` | "Hey developer" | Same persona activation |
| `/architect` | "Hey architect" | Same decisive approach |
| `/qa` | "Hey qa" | Full framework access |
| `/parallel-sprint` | Via orchestrator | Same multi-dev coordination |
| `/qa-predict` | Via qa agent | Same ML capabilities |

### 6. Migration Benefits Without Loss

1. **Native Integration**: Better Claude Code integration
2. **Preserved Personas**: ALL behavioral patterns maintained
3. **Enhanced Context**: Dedicated windows per persona
4. **Backward Compatible**: Existing workflows continue
5. **Same Capabilities**: Zero feature regression

### 7. What Changes vs What Stays

#### What Changes (Technical Implementation):
- Storage location: `.apm/` → `.claude/agents/`
- Invocation method: Commands → Sub-agent mentions
- Context management: Shared → Dedicated windows

#### What Stays the Same (Personas & Capabilities):
- ALL persona definitions and roles
- ALL behavioral patterns and styles
- ALL parallel execution capabilities
- ALL voice notifications
- ALL session management
- ALL specialized features (AI/ML, etc.)
- ALL workspace boundaries
- ALL communication standards

## Implementation Approach

### Step 1: Direct Content Migration
Copy entire persona content from `.apm/agents/personas/*.md` to `.claude/agents/*.md` with only technical wrapper changes.

### Step 2: Preserve All Capabilities
Ensure every parallel command, voice script, and specialized feature is maintained in the new structure.

### Step 3: Dual-Mode Operation
Run both systems in parallel during transition to ensure no workflow disruption.

### Step 4: Gradual Transition
Allow users to use familiar `/ap` commands while learning sub-agent invocation.

## Success Criteria

- ✅ All 8 personas migrated with identical capabilities
- ✅ No behavioral changes in any persona
- ✅ All parallel features functional
- ✅ Voice notifications working
- ✅ Session management preserved
- ✅ Backward compatibility maintained
- ✅ Zero feature regression

## Summary

This migration plan ensures that **ALL your carefully crafted personas are preserved exactly as designed**. The only changes are technical improvements in how Claude Code manages and invokes these personas, while their roles, behaviors, capabilities, and unique characteristics remain completely unchanged.

The APM framework's sophisticated persona definitions, parallel execution capabilities, and specialized features will continue to function identically, just with better native integration into Claude Code's sub-agent system.