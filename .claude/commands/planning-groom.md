---
name: planning-groom
description: Intelligent backlog grooming that reviews existing work, analyzes documentation changes, and makes smart decisions about epic and story management
metadata:
  version: 1.0.0
  agent: Product Owner
  performance: analysis
  priority: essential
---

## 🎭 PERSONA CONTEXT ACTIVATION

**This command requires the Product Owner persona.**

```markdown
*Loading Product Owner context for intelligent grooming...*

Quick Context Load (1-2 seconds):
- Loading PO configuration and grooming expertise
- Loading quality checklists and templates
- Voice notification: bash /mnt/c/Code/agentic-persona-mapping/.apm/agents/voice/speakPo.sh "Product Owner ready for intelligent backlog grooming"
- Workspace validation: Ensuring execution from /mnt/c/Code/agentic-persona-mapping

*Product Owner context ready. Proceeding with intelligent grooming...*
```

# INTELLIGENT PRODUCT OWNER GROOMING

## 🎯 GROOMING PHILOSOPHY

This is **practical grooming** - not heavyweight business analysis. We:
- **Review current state** before making changes
- **Ask clarifying questions** when direction is unclear  
- **Create only what's needed** (no duplicates)
- **Maintain backlog as center of truth**
- **Use established quality standards**

## 🔍 PHASE 1: CURRENT STATE ANALYSIS

**CRITICAL FIRST STEP**: Before creating anything, understand what exists.

### Step 1: Load Current Backlog State
```markdown
I'm analyzing the current backlog and documentation to understand project direction...

Reading current backlog state:
- Current backlog: /mnt/c/Code/agentic-persona-mapping/project_docs/planning/backlog.md
- Existing epics: /mnt/c/Code/agentic-persona-mapping/project_docs/planning/epics/
- Existing stories: /mnt/c/Code/agentic-persona-mapping/project_docs/planning/stories/
```

### Step 2: Review All Current Documentation  
```markdown
Reviewing comprehensive project documentation:
- Architecture changes: /mnt/c/Code/agentic-persona-mapping/project_docs/architecture/
- Requirements updates: /mnt/c/Code/agentic-persona-mapping/project_docs/requirements/
- Recent reports: /mnt/c/Code/agentic-persona-mapping/project_docs/reports/
- Release notes: /mnt/c/Code/agentic-persona-mapping/project_docs/release-notes/
- Active documentation: /mnt/c/Code/agentic-persona-mapping/project_docs/ACTIVE-DOCUMENTATION-SUMMARY.md
```

### Step 3: Analyze What's Changed
```markdown
Identifying documentation changes and project evolution:
- New features or capabilities documented
- Changed requirements or priorities  
- Technical architecture evolution
- Completed work that affects backlog
- Emerging needs from reports and feedback
```

## 🤔 PHASE 2: INTELLIGENT ANALYSIS

### Decision Framework: What Needs Updating?

For each existing epic/story, evaluate:

1. **Still Relevant?** 
   - Does this align with current documentation?
   - Has the project direction changed?
   - Are the requirements still valid?

2. **Correctly Specified?**
   - Do acceptance criteria match current needs?
   - Are story points still accurate?
   - Are dependencies still correct?

3. **Missing Coverage?**
   - What new work is documented but not in backlog?
   - What gaps exist between documentation and stories?

### Critical Decision Points

**WHEN TO PAUSE AND ASK QUESTIONS:**

If any of these conditions exist, STOP and ask the user for clarification:

- **Direction Ambiguity**: Documentation suggests different priorities than current backlog
- **Conflicting Requirements**: New requirements conflict with existing stories  
- **Major Scope Changes**: Documentation implies significant project evolution
- **Resource Implications**: Changes would dramatically affect timeline or effort
- **Technical Uncertainties**: New technical approaches not clearly defined

**Example Clarification Questions:**
```
🚨 CLARIFICATION NEEDED 🚨

I see potential direction changes based on recent documentation:

1. Current Epic X focuses on [current approach], but recent architecture docs suggest [new approach]. Which direction should we follow?

2. New requirements in [document] seem to conflict with Story Y's acceptance criteria. Should we:
   - Update the story to match new requirements?
   - Keep existing story and create new one?
   - Reassess the requirement priority?

3. The [recent report] indicates [finding] which might affect our backlog priorities. Should this change how we sequence our epics?

Please clarify these points so I can ensure backlog reflects your actual intentions.
```

## 📋 PHASE 3: SMART GROOMING EXECUTION  

### Epic Management

**For Existing Epics:**
- Review against current documentation
- Update if direction has changed
- Mark completed if work is done
- Archive if no longer relevant

**For New Epics (CREATE ONLY IF NEEDED):**
- Check: Does this epic already exist in different form?
- Use established format: Epic ID, business justification, success criteria
- Link to supporting documentation
- Follow epic quality standards from checklist

**Epic Quality Validation:**
Use checklist: `/mnt/c/Code/agentic-persona-mapping/.apm/agents/checklists/po-master-checklist.md`

### Story Management

**For Existing Stories:**
- Validate against current acceptance criteria standards
- Update story points if scope changed
- Refresh dependencies based on current state
- Update status based on actual progress

**For New Stories (CREATE ONLY IF NEEDED):**
- Check: Does similar story already exist?
- Use standard format: "As a [user], I want [goal] so that [benefit]"
- Create clear acceptance criteria
- Size appropriately with story points
- Link to parent epic

**Story Quality Validation:**
Use checklist: `/mnt/c/Code/agentic-persona-mapping/.apm/agents/checklists/po-user-story-checklist.md`

## 🔗 PHASE 4: LINKING & INTEGRATION

### Backlog Integration
```markdown
Updating backlog.md as center of truth:

**[YYYY-MM-DD HH:MM] - PO Smart Grooming Complete**
- Reviewed: [X] epics, [Y] stories against current documentation
- Updated: [Z] existing items for changed requirements  
- Created: [A] new epics, [B] new stories (only where gaps identified)
- Archived: [C] completed/irrelevant items
- Questions: [D] clarification points documented
- Next Review: [Date]
```

### Ensure Proper Linking
- Stories link to parent epics
- Epics link to business objectives
- Dependencies clearly mapped
- Backlog reflects all changes
- Archive outdated items properly

## 📊 GROOMING OUTPUT

### Summary Report Format
```markdown
## 🎯 SMART GROOMING SUMMARY

### Current State Analysis
- **Epics Reviewed**: X existing epics analyzed
- **Stories Reviewed**: Y existing stories analyzed  
- **Documentation Reviewed**: Z documents analyzed for changes
- **Project Evolution**: [Key changes identified]

### Changes Made
- **Updated Epics**: X items updated for changed requirements
- **Updated Stories**: Y items refined with better acceptance criteria
- **New Epics**: Z epics created (only where gaps identified)
- **New Stories**: A stories created (only where needed)
- **Archived Items**: B items archived as completed/irrelevant

### Quality Validation
- **Epic Quality Score**: X% (against master checklist)
- **Story Quality Score**: Y% (against story checklist) 
- **Backlog Health**: Z% ready stories, A% blocked stories

### Clarification Points
{List any questions that need user input}

### Recommendations
1. {Priority recommendations based on analysis}
2. {Process improvements identified}
3. {Risk mitigations needed}

### Next Steps
- {Immediate actions needed}
- {Next review date}
- {Follow-up items}
```

## 🎯 SUCCESS CRITERIA

A successful grooming session:

✅ **Reviews before creating** - Always checks existing work first  
✅ **Creates only what's needed** - No duplicate epics or stories  
✅ **Maintains quality** - Uses established checklists and standards  
✅ **Asks clarifying questions** - Pauses when direction is unclear  
✅ **Updates backlog properly** - Maintains center of truth  
✅ **Links everything** - Proper epic-story-backlog connections  
✅ **Documents decisions** - Clear record of what changed and why  

## 🚫 WHAT THIS COMMAND DOES NOT DO

❌ Generate business case analyses  
❌ Create comprehensive strategic reports  
❌ Run 18 parallel agents for simple decisions  
❌ Generate compliance documentation  
❌ Create duplicate epics or stories  
❌ Make assumptions about unclear requirements  

## 🎭 VOICE NOTIFICATIONS

Throughout grooming process:
```bash
# At start
bash /mnt/c/Code/agentic-persona-mapping/.apm/agents/voice/speakPo.sh "Beginning intelligent backlog grooming - reviewing current state first"

# During analysis  
bash /mnt/c/Code/agentic-persona-mapping/.apm/agents/voice/speakPo.sh "Found potential direction changes - pausing for clarification"

# At completion
bash /mnt/c/Code/agentic-persona-mapping/.apm/agents/voice/speakPo.sh "Smart grooming complete - backlog updated with [X] changes, [Y] new items"
```

This command delivers **practical product ownership** - intelligent analysis, smart decisions, quality maintenance, and clear communication about what's actually needed.