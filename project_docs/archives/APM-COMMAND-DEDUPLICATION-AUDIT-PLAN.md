# APM Command Deduplication Audit Plan

**Date:** 2025-01-21  
**Purpose:** Ensure no duplication between native Claude Code slash commands and agent persona/task files  
**Status:** 🔄 PLANNED

---

## 🎯 Objective

Systematically audit all APM Framework files to:
1. Identify duplicate command definitions between slash commands and persona/task files
2. Remove redundant command descriptions from persona files
3. Ensure single source of truth for each command
4. Maintain references but eliminate duplications

---

## 📋 Audit Scope

### Files to Audit

#### 1. Agent Persona Files (9 files)
```
.apm/agents/personas/
├── analyst.md          # Check for parallel-requirements, parallel-brainstorming, etc.
├── architect.md        # Check for parallel-architecture
├── design-architect.md # Check for parallel-frontend-architecture, parallel-ai-prompt
├── developer.md        # Check for parallel-review, run-tests
├── pm.md              # Check for parallel-prd
├── po.md              # Check for groom, parallel-epic, parallel-stories, etc.
├── qa.md              # Check for parallel-test-*, parallel-quality-review, etc.
├── sm.md              # Check for parallel-next-story, parallel-checklist, etc.
└── sre.md             # Check for any command references
```

#### 2. Task Files (Unknown count)
```
.apm/agents/tasks/
├── *.md               # Check all task files for command definitions
```

#### 3. Template Files
```
.apm/agents/templates/
├── *.md               # Check for command templates or definitions
```

#### 4. Documentation Files
```
project_docs/
├── *.md               # Check for command documentation that might duplicate
.apm/agents/README.md  # Check for command listings
```

#### 5. Archive Files (Lower priority)
```
.apm/archive/tasks/    # Check if archived tasks have command definitions
```

---

## 🔍 Commands to Check for Duplication

### Product Owner Commands (6)
- `/groom` - CRITICAL, 18 sub-agents
- `/parallel-epic`
- `/parallel-stories` 
- `/parallel-acceptance-criteria`
- `/parallel-prioritization`
- `/parallel-validation`

### Analyst Commands (4)
- `/parallel-requirements`
- `/parallel-brainstorming`
- `/parallel-stakeholder-review`
- `/parallel-research-prompt`

### Scrum Master Commands (4)
- `/parallel-next-story`
- `/parallel-stories` (duplicate name with PO?)
- `/parallel-checklist`
- `/parallel-course-correction`

### QA Commands (4)
- `/parallel-test-strategy`
- `/parallel-automation-plan`
- `/parallel-test-plan`
- `/parallel-quality-review`

### Design Architect Commands (2)
- `/parallel-frontend-architecture`
- `/parallel-ai-prompt`

### Developer Commands (2)
- `/parallel-review`
- `/run-tests`

### Architect Commands (1)
- `/parallel-architecture`

### Product Manager Commands (1)
- `/parallel-prd`

---

## 🔄 Audit Process

### Phase 1: Discovery (Day 1)
1. **Scan Persona Files**
   - Search for command names (without slash)
   - Search for "parallel-" patterns
   - Search for task definitions that match command names
   - Document all findings

2. **Scan Task Files**
   - Identify task files that correspond to slash commands
   - Check if task files define same functionality
   - Note any implementation details that differ

3. **Create Duplication Report**
   - List all duplications found
   - Categorize by severity (exact duplicate vs reference)
   - Identify which version is authoritative

### Phase 2: Analysis (Day 2)
1. **Determine Keep/Remove Strategy**
   - Slash commands are authoritative (keep)
   - Persona references can remain as pointers
   - Task implementations should be removed/archived

2. **Identify Dependencies**
   - Which files reference the duplicated content
   - Impact of removing duplications
   - Required updates to maintain functionality

### Phase 3: Cleanup (Day 3-4)
1. **Update Persona Files**
   - Remove duplicate command implementations
   - Add references to slash commands instead
   - Ensure consistent command listing format

2. **Archive or Remove Task Files**
   - Archive task files that duplicate slash commands
   - Update references to point to slash commands
   - Maintain task files that complement (not duplicate)

3. **Update Documentation**
   - Ensure README files list slash commands
   - Remove duplicate command documentation
   - Add cross-references where appropriate

### Phase 4: Validation (Day 5)
1. **Test Each Agent**
   - Activate each agent and verify commands work
   - Check that references resolve correctly
   - Ensure no broken dependencies

2. **Update Installer Templates**
   - Verify templates reflect cleaned structure
   - Ensure new installations get deduplicated version
   - Test installation process

---

## 🎯 Success Criteria

### Must Have
- [ ] Zero duplicate command implementations
- [ ] All slash commands are single source of truth
- [ ] Persona files reference (not duplicate) slash commands
- [ ] No broken command references

### Should Have
- [ ] Consistent command documentation format
- [ ] Clear distinction between commands and tasks
- [ ] Updated agent README files
- [ ] Archived (not deleted) replaced content

### Nice to Have
- [ ] Command dependency mapping
- [ ] Command usage analytics hooks
- [ ] Automated duplication detection script

---

## 📊 Expected Findings

### Likely Duplications
1. **PO Agent**: `groom` task file probably exists
2. **All Agents**: `parallel-*` patterns in persona files
3. **Developer**: `run-tests` likely in developer.md
4. **QA Agent**: Test-related commands in qa.md

### Potential Issues
1. **Name Conflicts**: `parallel-stories` exists for both PO and SM
2. **Task Dependencies**: Some tasks may call other tasks
3. **Archive References**: Archived tasks referenced in active files
4. **Template Conflicts**: Templates may define command structures

---

## 🚀 Execution Steps

### Step 1: Create Audit Script
```bash
#!/bin/bash
# audit-commands.sh
echo "=== Command Duplication Audit ==="

# Check for each command pattern in persona files
for cmd in "groom" "parallel-epic" "parallel-stories" "parallel-requirements" "run-tests"; do
  echo "Checking for: $cmd"
  grep -r "$cmd" .apm/agents/personas/ --include="*.md"
  grep -r "$cmd" .apm/agents/tasks/ --include="*.md"
done
```

### Step 2: Manual Review Process
1. Open each persona file
2. Search for command patterns
3. Document findings in tracking sheet
4. Classify as: Duplicate, Reference, or Unique

### Step 3: Cleanup Execution
1. Create backup of all files before changes
2. Remove duplications systematically
3. Test after each agent's cleanup
4. Document all changes made

---

## 📝 Tracking Template

```markdown
## [Agent Name] Audit Results

### Commands Checked
- [ ] /command-name-1
- [ ] /command-name-2

### Duplications Found
| File | Command | Type | Action |
|------|---------|------|--------|
| personas/agent.md | parallel-x | Full duplicate | Remove, add reference |
| tasks/task.md | parallel-y | Partial | Archive task file |

### Changes Made
- Removed X from personas/agent.md (line Y-Z)
- Added reference to /command-name at line A
- Archived tasks/duplicate-task.md
```

---

## 🔒 Risk Mitigation

### Backup Strategy
1. Create `.backup/` directory with timestamp
2. Copy all files before modification
3. Maintain change log with exact modifications

### Rollback Plan
1. If issues detected, restore from backup
2. Document what caused the issue
3. Adjust plan and retry

### Testing Protocol
1. Test each command after cleanup
2. Verify agent initialization still works
3. Check session note creation
4. Confirm voice notifications

---

## 📅 Timeline

- **Day 1**: Discovery and audit (2-3 hours)
- **Day 2**: Analysis and planning (1-2 hours)
- **Day 3-4**: Cleanup execution (4-5 hours)
- **Day 5**: Validation and testing (2-3 hours)

**Total Estimated Effort**: 9-13 hours

---

## 🎯 Deliverables

1. **Audit Report**: Complete list of all duplications found
2. **Cleanup Log**: Detailed record of all changes made
3. **Updated Files**: Deduplicated persona and task files
4. **Test Results**: Validation that all commands still work
5. **Installer Updates**: Updated templates for distribution

---

## 🚨 Critical Considerations

1. **Don't Break Active Workflows**: Test thoroughly before deployment
2. **Maintain Backwards Compatibility**: Keep references working
3. **Document Everything**: Every change must be logged
4. **Preserve Intent**: Don't lose functionality in cleanup
5. **Version Control**: Commit after each major change

---

*This plan ensures systematic deduplication while maintaining framework integrity*