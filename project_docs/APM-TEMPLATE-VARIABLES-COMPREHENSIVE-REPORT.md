# APM Template Variables Comprehensive Report

## Executive Summary

This report documents all template variables found in the APM (Agentic Persona Mapping) framework, analyzing their definitions, usage locations, and identifying potentially undefined variables that could cause template processing errors.

## Variable Definition Locations

### Primary Definition Source: `/mnt/c/Code/agentic-persona-mapping/installer/install.sh`

All template variables are processed in lines 340-378 of the install.sh script using sed replacement:

```bash
# Template processing function (lines 340-378)
sed $sed_inplace "s|{{VARIABLE_NAME}}|$VARIABLE_VALUE|g" "$temp_file"
```

## Comprehensive Variable Analysis

### ✅ PROPERLY DEFINED VARIABLES

| Variable | Definition Location | Definition Line | Resolved Value | Usage Count |
|----------|-------------------|----------------|----------------|-------------|
| `{{PROJECT_NAME}}` | install.sh | 630 | `$(basename "$PROJECT_ROOT")` | 4 files |
| `{{PROJECT_ROOT}}` | install.sh | 127 | `"$TARGET_DIR"` | 45+ files |
| `{{APM_ROOT}}` | install.sh | 130 | `"$PROJECT_ROOT/.apm"` | 15+ files |
| `{{AP_ROOT}}` | install.sh | 131 | `"$APM_ROOT/agents"` | 80+ files |
| `{{PROJECT_DOCS}}` | install.sh | 635 | `"$PROJECT_ROOT/project_docs"` | 25+ files |
| `{{BACKLOG_PATH}}` | install.sh | 636 | `"project_docs"` | 8 files |
| `{{CLAUDE_DIR}}` | install.sh | 633 | `"$PROJECT_ROOT/.claude"` | 2 files |
| `{{CLAUDE_COMMANDS_DIR}}` | install.sh | 634 | `"$CLAUDE_DIR/commands"` | 3 files |
| `{{NOTES_TYPE}}` | install.sh | 646 | `"markdown"` | 2 files |
| `{{SESSION_NOTES_PATH}}` | install.sh | 637,650 | `"$APM_ROOT/session_notes"` | 12+ files |
| `{{RULES_PATH}}` | install.sh | 638,651 | `"$APM_ROOT/rules"` | 8 files |
| `{{ARCHIVE_PATH}}` | install.sh | 639,652 | `"$APM_ROOT/session_notes/archive"` | 6 files |

### Voice Script Variables (All Properly Defined)
| Variable | Definition Location | Definition Line | Resolved Value |
|----------|-------------------|----------------|----------------|
| `{{SPEAK_ORCHESTRATOR}}` | install.sh | 661 | `"$AP_ROOT/voice/speakOrchestrator.sh"` |
| `{{SPEAK_DEVELOPER}}` | install.sh | 662 | `"$AP_ROOT/voice/speakDeveloper.sh"` |
| `{{SPEAK_ARCHITECT}}` | install.sh | 663 | `"$AP_ROOT/voice/speakArchitect.sh"` |
| `{{SPEAK_ANALYST}}` | install.sh | 664 | `"$AP_ROOT/voice/speakAnalyst.sh"` |
| `{{SPEAK_QA}}` | install.sh | 665 | `"$AP_ROOT/voice/speakQA.sh"` |
| `{{SPEAK_PM}}` | install.sh | 666 | `"$AP_ROOT/voice/speakPM.sh"` |
| `{{SPEAK_PO}}` | install.sh | 667 | `"$AP_ROOT/voice/speakPO.sh"` |
| `{{SPEAK_SM}}` | install.sh | 668 | `"$AP_ROOT/voice/speakSM.sh"` |
| `{{SPEAK_DESIGN_ARCHITECT}}` | install.sh | 669 | `"$AP_ROOT/voice/speakDesignArchitect.sh"` |
| `{{SPEAK_AGENT}}` | install.sh | 685 | `"$AP_ROOT/voice/speakAgent.sh"` |

### APM Configuration Variables (All Properly Defined)
| Variable | Definition Location | Definition Line | Resolved Value |
|----------|-------------------|----------------|----------------|
| `{{AP_CONFIG_FILE}}` | install.sh | 672 | `"$AP_ROOT/ide-ap-orchestrator.cfg.md"` |
| `{{AP_KB_FILE}}` | install.sh | 673 | `"$AP_ROOT/data/ap-kb.md"` |
| `{{AP_CHECKLISTS}}` | install.sh | 674 | `"$AP_ROOT/checklists"` |
| `{{AP_DATA}}` | install.sh | 675 | `"$AP_ROOT/data"` |
| `{{AP_PERSONAS}}` | install.sh | 676 | `"$AP_ROOT/personas"` |
| `{{AP_TASKS}}` | install.sh | 677 | `"$AP_ROOT/tasks"` |
| `{{AP_TEMPLATES}}` | install.sh | 678 | `"$AP_ROOT/templates"` |
| `{{AP_DOCS}}` | install.sh | 679 | `"$AP_ROOT/docs"` |
| `{{AP_VOICE}}` | install.sh | 680 | `"$AP_ROOT/voice"` |
| `{{AP_PYTHON}}` | install.sh | 681 | `"$AP_ROOT/python"` |
| `{{AP_MONITORING}}` | install.sh | 682 | `"$AP_ROOT/monitoring"` |
| `{{AP_SCRIPTS}}` | install.sh | 683 | `"$AP_ROOT/scripts"` |
| `{{AP_SUBTASKS}}` | install.sh | 684 | `"$AP_ROOT/tasks/subtasks"` |

## 🚨 UNDEFINED VARIABLES - CRITICAL ISSUES

### Variables Used in Templates But NOT Defined in install.sh:

| Variable | Used In Files | Potential Impact | Status |
|----------|---------------|------------------|---------|
| `{{FALLBACK_SESSION_NOTES_PATH}}` | settings.json.template | Template processing will leave literal `{{FALLBACK_SESSION_NOTES_PATH}}` | ❌ UNDEFINED |
| `{{FALLBACK_RULES_PATH}}` | settings.json.template | Template processing will leave literal `{{FALLBACK_RULES_PATH}}` | ❌ UNDEFINED |
| `{{FALLBACK_ARCHIVE_PATH}}` | settings.json.template | Template processing will leave literal `{{FALLBACK_ARCHIVE_PATH}}` | ❌ UNDEFINED |
| `{{PLANNING_ROOT}}` | settings.json.template | Template processing will leave literal `{{PLANNING_ROOT}}` | ❌ UNDEFINED |
| `{{WORKSPACE_ROOT}}` | Multiple template files | Template processing will leave literal `{{WORKSPACE_ROOT}}` | ❌ UNDEFINED |

## Detailed Usage Analysis

### High-Usage Variables (40+ Occurrences)
- `{{PROJECT_ROOT}}` - Used in 45+ template files across all command templates
- `{{AP_ROOT}}` - Used in 80+ template files, primarily in persona and command templates

### Template-Specific Variables
Found in backlog templates but definitions not in install.sh:
- `{{LAST_UPDATE_DATE}}`
- `{{BACKLOG_VERSION}}`
- `{{TOTAL_EPICS}}`
- `{{TOTAL_POINTS}}`
- `{{COMPLETED_POINTS}}`
- `{{CURRENT_SPRINT}}`
- `{{SPRINT_GOAL}}`
- Multiple timestamp and status variables

## File-by-File Variable Usage

### Most Variable-Heavy Templates:
1. `/installer/templates/project_documentation/backlog.md.template` - 50+ variables
2. `/installer/templates/claude/settings.json.template` - 25+ variables  
3. `/installer/templates/CLAUDE.md.markdown.template` - 20+ variables
4. Command templates in `/installer/templates/claude/commands/` - 10+ variables each

### Settings.json Template Critical Variables:
```json
{
  "env": {
    "APM_ROOT": "{{APM_ROOT}}",
    "AP_ROOT": "{{AP_ROOT}}",
    "PROJECT_ROOT": "{{PROJECT_ROOT}}",
    "PROJECT_DOCS": "{{PROJECT_ROOT}}/project_docs",
    "PLANNING_ROOT": "{{PLANNING_ROOT}}", // ❌ UNDEFINED
    "FALLBACK_SESSION_NOTES_PATH": "{{FALLBACK_SESSION_NOTES_PATH}}", // ❌ UNDEFINED
    "FALLBACK_RULES_PATH": "{{FALLBACK_RULES_PATH}}", // ❌ UNDEFINED
    "FALLBACK_ARCHIVE_PATH": "{{FALLBACK_ARCHIVE_PATH}}" // ❌ UNDEFINED
  }
}
```

## Critical Findings

### 🔴 Template Processing Errors
The following variables are referenced in sed replacement (lines 351-353, 378) but are never defined:
- `FALLBACK_SESSION_NOTES_PATH` - Used in line 351 replacement
- `FALLBACK_RULES_PATH` - Used in line 352 replacement  
- `FALLBACK_ARCHIVE_PATH` - Used in line 353 replacement
- `PLANNING_ROOT` - Used in line 378 replacement

This means these templates will have literal `{{VARIABLE_NAME}}` text in the final processed files.

### 🔴 Missing Variable Definitions Required
Based on usage patterns, these variables should be defined in install.sh:

```bash
# Suggested additions to install.sh:
WORKSPACE_ROOT="$PROJECT_ROOT"  # or "$PROJECT_ROOT/src"
PLANNING_ROOT="$PROJECT_DOCS/planning"
FALLBACK_SESSION_NOTES_PATH="$PROJECT_DOCS/session_notes"
FALLBACK_RULES_PATH="$PROJECT_DOCS/rules"  
FALLBACK_ARCHIVE_PATH="$PROJECT_DOCS/session_notes/archive"
```

## Recommendations

### Immediate Actions Required:
1. **Fix Undefined Variables**: Add missing variable definitions to install.sh before line 340
2. **Validate Template Processing**: Test all template files after variable definition fixes
3. **Review Backlog Templates**: Many backlog template variables appear to be placeholder content
4. **Audit Usage**: Remove unused variables or ensure all referenced variables are defined

### Template Processing Validation:
Run this command to verify no literal `{{}}` remain in processed files:
```bash
grep -r "{{[A-Z_]*}}" /path/to/processed/templates/
```

## File Paths Referenced

### Template Source Directory:
`/mnt/c/Code/agentic-persona-mapping/installer/templates/`

### Key Template Files:
- **Configuration**: `claude/settings.json.template`
- **Documentation**: `CLAUDE.md.markdown.template`
- **Commands**: `claude/commands/*.md.template` (50+ files)
- **Project Docs**: `project_documentation/*.template`
- **Agent Infrastructure**: `agents/shared/*.template`

### Installation Script:
`/mnt/c/Code/agentic-persona-mapping/installer/install.sh`

## Conclusion

The APM framework uses 30+ template variables with most properly defined in install.sh. However, **5 critical variables are undefined**, causing template processing failures. The framework would benefit from:

1. Immediate fix for undefined variables
2. Template processing validation 
3. Removal of unused placeholder variables
4. Documentation of variable naming conventions

**Priority**: CRITICAL - Template processing errors will cause installation failures.