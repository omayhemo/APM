# APM Communication Protocols and Phase Summary Requirements

**Extracted from**: `/mnt/c/Code/agentic-persona-mapping/.apm/agents/personas/communication_standards.md`  
**Date**: 2025-01-14  
**Source Files Analyzed**:
- `/mnt/c/Code/agentic-persona-mapping/.apm/agents/personas/communication_standards.md`
- `/mnt/c/Code/agentic-persona-mapping/.apm/agents/orchestrator/rules.md`
- `/mnt/c/Code/agentic-persona-mapping/.apm/agents/docs/PARALLEL-HANDOFF-IMPLEMENTATION-REPORT.md`

---

## 1. Phase Summary Requirements

### Mandatory Phase Completion Protocol

At the **end of every major phase or significant task**, agents **MUST provide a concise summary of outcomes and clear next steps**.

### Summary Format Requirements

- Summaries must be in **list or bullet format**
- Must highlight any **blockers, decisions, and follow-up actions**
- Use the standardized template below

### Official Phase Summary Template

```markdown
🎯 ### Phase {{phase_number}} Highlights

### 📋 SUMMARY REPORT — {{report_title}}

===== STATUS CHECKLIST =====
✅  <Completed Item> — <Note>
🚧  <In Progress Item> — <Current Status>
❌  <Failed Item> — <Issue Description>
🕒  <Blocked Item> — <Reason/Dependency>
⚠️  <At Risk> — <Potential Problem>

===== PROGRESS =====
<Label>  🟩🟩🟨⬜⬜  60%

===== TODO =====
[ ]  🚧  <Task To Start>
[~]  🕒  <Task In Progress>
[x]  ✅  <Completed Task>
[-]  🚫  <Cancelled/Removed>
[!]  ⚠️  <Needs Attention>

===== KEY BLOCKERS =====
⚠️ <Blocker> — <Mitigation Plan>

===== NEXT STEPS =====
➡️ <Immediate Action>

===== NOTES & INSIGHTS =====
🧠 <Lesson Learned or Special Note>
```

---

## 2. Audio Communication Protocols

### Critical High Verbosity TTS Requirements

**All Agents must use their corresponding script for communicating all information spoken by the agent.**

### Mandatory Audio Announcements

#### Before CLI Commands
- **BEFORE any CLI command**: Announce what command you plan to run and why

#### Task Management
- **Task management**: Announce start, progress, and completion of every task
- **Planning**: Announce what you're planning to work on next

#### Error Handling
- **Error handling**: Immediately announce any errors encountered

#### User Interaction
- **Questions/Input needed**: Use espeak to get user attention when needing approval or input
- **Service management**: Always ask user to restart services - announce this request with espeak

#### Analysis & Code Changes
- **Analysis**: Announce when checking logs, completing analysis, summarizing findings
- **Code changes**: Announce before making any file modifications
- **Verification**: Announce test results and validation steps

#### Maximum Verbosity Requirement
- Use the appropriate script based on which AP agent is active to say **EVERY STEP** you're doing
- **Maximum verbosity** is required for all operations

---

## 3. Agent Handoff Protocols

### Handoff Command Enhancement

**Purpose**: Seamless agent-to-agent transition with full context transfer

**Key Features**:
- **Parallel Context Transfer**: 5 simultaneous tasks for efficient handoff
- **Work Preservation**: Current agent summarizes achievements and decisions
- **Artifact Transfer**: Relevant documents and work products identified
- **Transition Notes**: Specific guidance for incoming agent
- **Template Preloading**: Target agent's tools ready immediately

### Parallel Handoff Tasks

1. Create handoff summary of current work and decisions
2. Load target persona configuration 
3. Check for work artifacts relevant to target persona
4. Prepare transition notes for seamless continuation
5. Load target persona's required templates and checklists

### Handoff Summary Format

```markdown
## Handoff Summary from [Current Agent] to [Target Agent]

### Work Completed:
- [List of completed items]

### Key Decisions:
- [Important decisions made]

### Current Status:
- [Where things stand]

### Next Steps:
- [What needs to be done]

### Relevant Artifacts:
- [Files, documents, or resources]

### Special Considerations:
- [Any warnings, blockers, or important context]
```

---

## 4. Session Switch Protocols

### Switch Command Enhancement

**Purpose**: Clean session breaks with context compaction and archival

**Key Features**:
- **Session Compaction**: Reduces token usage through summarization
- **Parallel Archival**: Work artifacts preserved simultaneously
- **Clean Transitions**: Clear breakpoints between work phases
- **Focused Activation**: New agent starts fresh but informed

### Parallel Switch Tasks

1. Create comprehensive session summary and key insights
2. Archive current work artifacts and decisions
3. Load target persona configuration
4. Generate transition brief for incoming agent
5. Load target persona's templates and workspace setup

### Session Compaction Format

Includes additional sections beyond the basic handoff format:
- **Session Overview** (duration, focus)
- **Achievements**
- **Insights & Learnings**
- **Specific guidance for next agent**

---

## 5. Core Orchestrator Rules

### File Operations
1. **Use LS tool** to list directories before attempting to read files
2. **Use voice scripts** for all major announcements and transitions

### Session Management
3. **Create session notes** with proper timestamps
4. **Follow communication standards** from loaded configuration

### AP Orchestrator Activation Sequence

When activating as AP Orchestrator:
1. List session notes directory using LS tool
2. List rules directory using LS tool
3. Create new session note with timestamp
4. Use voice script for greeting
5. Continue as the orchestrator persona

---

## 6. Performance Metrics

### Handoff Performance
- Handoff time: ~5-7 seconds (vs 20-30 sequential)
- Context quality: Enhanced through structured extraction

### Switch Performance
- Switch time: ~6-8 seconds (vs 25-35 sequential)
- Memory efficiency: Compaction reduces token usage

### Overall System Performance
- **Performance Gains**: 70-80% reduction in transition times
- **Context Integrity**: Structured transfer ensures nothing is lost

---

## 7. Best Practices

### For Handoffs
1. Complete current work to logical stopping point
2. Document all decisions with rationale
3. Identify specific next steps
4. Transfer relevant artifacts explicitly
5. Provide clear instructions if needed

### For Switches
1. Use at natural work boundaries
2. Finish current thoughts completely
3. Highlight any blockers prominently
4. Archive by session for future reference
5. Be specific about priorities for next agent

---

## 8. Implementation Status

### Quality Assurance Validation
- ✅ Both commands follow identical structural pattern
- ✅ Explicit native sub-agent usage specified
- ✅ Single function_calls block requirement clear
- ✅ Post-execution protocols defined
- ✅ Context formats standardized
- ✅ Templates updated for distribution

### Pattern Applications
This parallel pattern extends to:
- Multi-agent collaboration scenarios
- Batch processing of multiple stories
- Parallel validation across checkpoints
- Distributed analysis tasks

---

## Summary

The APM framework implements comprehensive communication protocols that ensure:

1. **Structured Phase Reporting**: Mandatory summary format with status tracking
2. **Maximum Audio Verbosity**: Complete voice narration of all activities
3. **Efficient Agent Transitions**: Parallel handoff and switch protocols
4. **Context Preservation**: Structured formats ensure no information loss
5. **Performance Optimization**: 70-80% reduction in transition times through parallel execution

All protocols are designed to maintain context integrity while maximizing efficiency and providing clear user feedback through both visual and audio channels.