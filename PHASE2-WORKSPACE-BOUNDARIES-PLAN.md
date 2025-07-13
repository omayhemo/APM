# Phase 2: Workspace Boundaries Implementation Plan

## Overview
Implement structural directory organization to prevent agents from focusing on APM infrastructure when working on project deliverables. This applies to NEW INSTALLATIONS ONLY - no backward compatibility or migrations.

## New Directory Structure

### Target Structure
```
project-root/
├── .apm/                  ← APM infrastructure (hidden from agents)
│   ├── agents/
│   ├── .claude/
│   └── session_notes/
├── workspace/             ← Agent working area
│   ├── src/              ← Project source code
│   ├── tests/            ← Project tests
│   └── components/       ← Reusable components
├── project_docs/         ← Project-specific documentation
│   ├── requirements/
│   ├── architecture/
│   └── specifications/
└── deliverables/         ← Project outputs
    ├── reports/
    ├── releases/
    └── artifacts/
```

## Implementation Tasks

### Task 1: Update Installer Script
**File:** `installer/install.sh`

**Changes Required:**
1. **Path Variables (lines ~360-370)**
   ```bash
   # OLD:
   AP_ROOT="$PROJECT_ROOT/agents"
   CLAUDE_DIR="$PROJECT_ROOT/.claude"
   PROJECT_DOCS="$PROJECT_ROOT/project_documentation"
   
   # NEW:
   APM_ROOT="$PROJECT_ROOT/.apm"
   AP_ROOT="$APM_ROOT/agents"
   CLAUDE_DIR="$APM_ROOT/.claude"
   WORKSPACE_ROOT="$PROJECT_ROOT/workspace"
   PROJECT_DOCS="$PROJECT_ROOT/project_docs"
   DELIVERABLES="$PROJECT_ROOT/deliverables"
   SESSION_NOTES_PATH="$APM_ROOT/session_notes"
   RULES_PATH="$APM_ROOT/rules"
   ARCHIVE_PATH="$APM_ROOT/session_notes/archive"
   ```

2. **Directory Creation (lines ~500-510)**
   ```bash
   # Create APM infrastructure (hidden)
   ensure_dir "$APM_ROOT"
   ensure_dir "$AP_ROOT"
   ensure_dir "$CLAUDE_DIR"
   ensure_dir "$SESSION_NOTES_PATH"
   ensure_dir "$RULES_PATH" 
   ensure_dir "$ARCHIVE_PATH"
   
   # Create project workspace
   ensure_dir "$WORKSPACE_ROOT"
   ensure_dir "$WORKSPACE_ROOT/src"
   ensure_dir "$WORKSPACE_ROOT/tests"
   ensure_dir "$WORKSPACE_ROOT/components"
   
   # Create project documentation
   ensure_dir "$PROJECT_DOCS"
   ensure_dir "$PROJECT_DOCS/requirements"
   ensure_dir "$PROJECT_DOCS/architecture"
   ensure_dir "$PROJECT_DOCS/specifications"
   
   # Create deliverables
   ensure_dir "$DELIVERABLES"
   ensure_dir "$DELIVERABLES/reports"
   ensure_dir "$DELIVERABLES/releases"
   ensure_dir "$DELIVERABLES/artifacts"
   ```

3. **Template Variable Updates (lines ~280-320)**
   Add new variables to `replace_variables()` function:
   ```bash
   sed -i "s|{{APM_ROOT}}|$APM_ROOT|g" "$temp_file"
   sed -i "s|{{WORKSPACE_ROOT}}|$WORKSPACE_ROOT|g" "$temp_file"
   sed -i "s|{{DELIVERABLES}}|$DELIVERABLES|g" "$temp_file"
   ```

### Task 2: Update CLAUDE.md Templates
**Files:** 
- `installer/templates/CLAUDE.md.markdown.template`
- `installer/templates/CLAUDE.md.obsidian.template`

**Changes Required:**
1. **Environment Configuration Section (lines ~40-45)**
   ```markdown
   ## Environment Configuration
   
   This project uses the AP method with workspace boundaries.
   
   - APM Infrastructure: {{APM_ROOT}} (agents should ignore)
   - Project Workspace: {{WORKSPACE_ROOT}}
   - Project Documentation: {{PROJECT_DOCS}}
   - Deliverables Output: {{DELIVERABLES}}
   - Session Notes: {{SESSION_NOTES_PATH}}
   - Rules: {{RULES_PATH}}
   ```

2. **Add Workspace Boundaries Section (after line ~45)**
   ```markdown
   ## 🚧 WORKSPACE BOUNDARIES
   
   **CRITICAL**: Agents must respect workspace boundaries to avoid APM infrastructure.
   
   ### ✅ ALLOWED DIRECTORIES
   - `{{WORKSPACE_ROOT}}/` - All project source code and components
   - `{{PROJECT_DOCS}}/` - Project-specific documentation
   - `{{DELIVERABLES}}/` - Project outputs and artifacts
   
   ### ❌ FORBIDDEN DIRECTORIES  
   - `{{APM_ROOT}}/` - APM infrastructure (hidden)
   - `.claude/` - Claude configuration
   - `agents/` - Persona definitions
   - Any session note files
   
   ### 🔍 PATH VALIDATION
   Before any file operation, verify:
   - Path starts with allowed workspace directory
   - Path does NOT contain forbidden directories
   - Focus on project deliverables, not APM infrastructure
   ```

3. **Update AP Command Instructions (lines ~150-160)**
   ```markdown
   ### /ap - Launch AP Orchestrator (alias for /ap_orchestrator)
   **IMPORTANT**: This makes YOU become the AP Orchestrator.
   - Step 1: Check session notes directory using LS tool: `{{SESSION_NOTES_PATH}}/`
   - Step 2: Check rules directory using LS tool: `{{RULES_PATH}}/`
   - Step 3: Create new session note FILE with timestamp (not a directory)
   - Step 4: Use speakOrchestrator.sh for ALL responses
   - Step 5: Act as the Orchestrator (coordinate, delegate, guide)
   - Step 6: Work within project workspace: `{{WORKSPACE_ROOT}}/`
   ```

### Task 3: Update All Persona Files
**Files:** All files in `agents/personas/`
- `dev.md`, `pm.md`, `po.md`, `architect.md`, `design-architect.md`, `analyst.md`, `qa.md`, `sm.md`

**Changes Required:**
Add workspace boundary section after role definition (~line 15):

```markdown
## 🚧 WORKSPACE BOUNDARIES

### PRIMARY WORKING DIRECTORIES
- **[PERSONA-SPECIFIC]** - See persona-specific boundaries below
- **Project Documentation**: `project_docs/` 
- **Deliverables Output**: `deliverables/`

### FORBIDDEN PATHS
- `.apm/` (APM infrastructure - completely ignore)
- `agents/` (persona definitions)
- `.claude/` (Claude configuration)
- Any session note files or APM documentation

### PATH VALIDATION REQUIRED
Before any file operation:
1. Verify path starts with allowed workspace directory
2. Verify path does NOT contain forbidden directories
3. Focus ONLY on project deliverables, never APM infrastructure

## [PERSONA-SPECIFIC BOUNDARIES]
```

**Persona-Specific Boundaries:**

**Developer (dev.md):**
```markdown
- **Primary**: `workspace/src/` (source code)
- **Secondary**: `workspace/tests/` (test files)
- **Read-Only**: `project_docs/` (specifications)
- **Output**: `deliverables/releases/` (build artifacts)
```

**Product Manager (pm.md):**
```markdown
- **Primary**: `project_docs/requirements/` (PRDs, requirements)
- **Secondary**: `deliverables/reports/` (project reports)
- **Read-Only**: `workspace/` (understanding implementation)
```

**Product Owner (po.md):**
```markdown
- **Primary**: `project_docs/` (all project documentation)
- **Secondary**: `deliverables/` (all project outputs)
- **Limited**: `workspace/` (validation only, no modification)
```

**Architect (architect.md):**
```markdown
- **Primary**: `project_docs/architecture/` (system design)
- **Secondary**: `workspace/` (understanding codebase)
- **Output**: `deliverables/artifacts/` (architecture diagrams)
```

**Design Architect (design-architect.md):**
```markdown
- **Primary**: `project_docs/specifications/` (UI/UX specs)
- **Secondary**: `workspace/components/` (component design)
- **Output**: `deliverables/artifacts/` (design assets)
```

**QA (qa.md):**
```markdown
- **Primary**: `workspace/tests/` (test files)
- **Secondary**: `deliverables/reports/` (test reports)
- **Read-Only**: `workspace/src/`, `project_docs/` (validation)
```

**Analyst (analyst.md):**
```markdown
- **Primary**: `project_docs/requirements/` (research, analysis)
- **Output**: `deliverables/reports/` (analysis reports)
- **Read-Only**: All other directories (research purposes)
```

**Scrum Master (sm.md):**
```markdown
- **Primary**: `project_docs/` (project planning)
- **Secondary**: `deliverables/reports/` (sprint reports)
- **Read-Only**: `workspace/` (progress assessment)
```

### Task 4: Update Task Files
**Files:** All files in `agents/tasks/`

**Changes Required:**
Update output paths in all task files:

**Pattern to Replace:**
```markdown
Save your [output] to: `project_documentation/base/[filename]`
```

**Replace With:**
```markdown
Save your [output] to: `project_docs/[category]/[filename]`
OR
Save your [output] to: `deliverables/[type]/[filename]`
```

**Specific Files and Changes:**
- `create-prd.md`: Output to `project_docs/requirements/prd.md`
- `create-architecture.md`: Output to `project_docs/architecture/system-architecture.md`
- `create-frontend-architecture.md`: Output to `project_docs/architecture/frontend-architecture.md`
- `create-uxui-spec.md`: Output to `project_docs/specifications/uxui-spec.md`
- `create-test-plan.md`: Output to `project_docs/requirements/test-plan.md`
- `create-test-strategy.md`: Output to `project_docs/requirements/test-strategy.md`

### Task 5: Update Settings Template
**File:** `installer/templates/claude/settings.json.template`

**Changes Required:**
Add new environment variables:
```json
{
  "env": {
    "APM_ROOT": "{{APM_ROOT}}",
    "AP_ROOT": "{{AP_ROOT}}",
    "WORKSPACE_ROOT": "{{WORKSPACE_ROOT}}",
    "PROJECT_DOCS": "{{PROJECT_DOCS}}",
    "DELIVERABLES": "{{DELIVERABLES}}",
    "SESSION_NOTES_PATH": "{{SESSION_NOTES_PATH}}",
    "RULES_PATH": "{{RULES_PATH}}",
    "ARCHIVE_PATH": "{{ARCHIVE_PATH}}"
  }
}
```

### Task 6: Update Voice Scripts
**Files:** All files in `agents/voice/`

**Changes Required:**
Update path resolution logic to work from `.apm/agents/voice/`:
```bash
# OLD:
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AP_ROOT="$(dirname "$SCRIPT_DIR")"

# NEW:
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AP_ROOT="$(dirname "$SCRIPT_DIR")"
APM_ROOT="$(dirname "$AP_ROOT")"
PROJECT_ROOT="$(dirname "$APM_ROOT")"
```

### Task 7: Update Template Files
**Files:** All files in `agents/templates/`

**Changes Required:**
Update save location comments:
```markdown
<!-- OLD: Save as: project_documentation/base/[filename] -->
<!-- NEW: Save as: project_docs/[category]/[filename] -->
```

### Task 8: Update Command Templates
**Files:** All files in `installer/templates/claude/commands/`

**Changes Required:**
Add workspace context to command instructions:
```markdown
## WORKSPACE CONTEXT
Work within project boundaries:
- Project files: {{WORKSPACE_ROOT}}
- Documentation: {{PROJECT_DOCS}}  
- Outputs: {{DELIVERABLES}}

IGNORE APM infrastructure at {{APM_ROOT}}
```

### Task 9: Update Build Script
**File:** `build-distribution.sh`

**Changes Required:**
Ensure distribution creates `.apm` structure:
```bash
# Copy agents to .apm directory in distribution
mkdir -p "$DIST_DIR/.apm"
cp -r agents/ "$DIST_DIR/.apm/"
cp -r installer/ "$DIST_DIR/"
```

### Task 10: Update .gitignore Template
**File:** `installer/templates/gitignore.template`

**Changes Required:**
Update ignore patterns for new structure:
```gitignore
# APM Infrastructure (hidden)
.apm/session_notes/
.apm/.claude/hooks/

# Workspace (project-specific ignores)
workspace/node_modules/
workspace/.env
workspace/dist/

# Deliverables (temporary outputs)
deliverables/temp/
deliverables/*.tmp
```

## Validation Plan

### Post-Implementation Testing
1. **Fresh Installation Test**
   - Run installer on clean environment
   - Verify directory structure created correctly
   - Test agent persona activation

2. **Agent Boundary Test**
   - Activate each persona type
   - Verify they only work in designated directories
   - Confirm they ignore `.apm/` infrastructure

3. **Workflow Test**
   - Create sample project workflow
   - Verify outputs go to correct locations
   - Confirm no APM file modifications

## Success Criteria
- ✅ All personas respect workspace boundaries
- ✅ No accidental APM infrastructure modifications
- ✅ Clean separation between APM and project content
- ✅ Project deliverables organized in logical structure
- ✅ Installation creates correct directory hierarchy

## Estimated Effort
- **Development**: 2-3 days
- **Testing**: 1 day  
- **Documentation**: 0.5 day
- **Total**: 3.5-4.5 days

## Risk Mitigation
- Test with multiple project types before release
- Validate all persona types work within boundaries
- Ensure voice scripts function from new locations
- Verify template processing handles new variables