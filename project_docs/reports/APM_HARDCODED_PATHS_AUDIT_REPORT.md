# APM Template Hardcoded Paths Audit Report

**Date:** August 6, 2025  
**Status:** CRITICAL - Extensive hardcoding found  
**Total Files Analyzed:** 443 template files  
**Files with Hardcoded Paths:** 198 (44.7%)

## Executive Summary

This audit reveals **extensive hardcoded path usage across APM template system**, creating significant installation portability and maintenance issues. **198 out of 443 template files (44.7%) contain hardcoded paths** that should be templated variables.

### Critical Impact Analysis
- **🔴 CRITICAL:** `/mnt/c/Code/agentic-persona-mapping` - Found in 250+ occurrences across 134 files
- **🟠 HIGH:** Build script path hardcoding affects distribution generation
- **🟠 HIGH:** Voice script paths prevent cross-platform compatibility  
- **🟡 MEDIUM:** Project structure paths limit installation flexibility
- **🟡 MEDIUM:** Workspace references assume specific directory structures

## 🚨 CRITICAL HARDCODED PATHS

### Category 1: Absolute Project Root Paths

**Pattern:** `/mnt/c/Code/agentic-persona-mapping`  
**Count:** 250+ occurrences across 134 files  
**Impact:** CRITICAL - Prevents installation anywhere except exact source location

#### Most Critical Instances:

**File:** `/mnt/c/Code/agentic-persona-mapping/installer/templates/claude/commands/buildit.md.template`  
**Line:** 19  
**Hardcoded Path:** `/mnt/c/code/agentic-persona/build-distribution.sh`  
**Type:** Absolute path to build script  
**Impact:** HIGH - Prevents build command from working in any other location  
**Suggested Variable:** `{{PROJECT_ROOT}}/build-distribution.sh`

**File:** `/mnt/c/Code/agentic-persona-mapping/installer/templates/agents/monitoring/parallel-performance-system.md.template`  
**Line:** 66  
**Hardcoded Path:** `/mnt/c/Code/agentic-persona-mapping/.claude/metrics/parallel_performance.json`  
**Type:** Absolute path to metrics database  
**Impact:** HIGH - Breaks performance monitoring on different installations  
**Suggested Variable:** `{{PROJECT_ROOT}}/.claude/metrics/parallel_performance.json`

**File:** `/mnt/c/Code/agentic-persona-mapping/installer/templates/hooks/pre_tool_use_debug_host.py`  
**Line:** 144  
**Hardcoded Path:** `/mnt/c/Code/agentic-persona-mapping/.apm/agents/voice/speakOrchestrator.sh`  
**Type:** Absolute path to voice script  
**Impact:** HIGH - Voice notifications fail on other installations  
**Suggested Variable:** `{{APM_ROOT}}/agents/voice/speakOrchestrator.sh`

### Category 2: Voice Script Hardcoding

**Pattern:** `bash /mnt/c/Code/agentic-persona-mapping/.apm/agents/voice/speak*.sh`  
**Count:** 89 occurrences across 67 command files  
**Impact:** HIGH - All voice notifications broken on non-source installations

#### Representative Examples:

**Files Affected:** All `/claude/commands/*.md.template` files  
**Example Line:** `bash /mnt/c/Code/agentic-persona-mapping/.apm/agents/voice/speakAnalyst.sh "Sequential requirements analysis beginning..."`  
**Type:** Absolute path to voice scripts  
**Impact:** HIGH - Voice system completely non-functional  
**Suggested Variable:** `bash {{APM_ROOT}}/agents/voice/speakAnalyst.sh`

### Category 3: Session Management Hardcoding

**Pattern:** `/mnt/c/Code/agentic-persona-mapping/.apm/session_notes/`  
**Count:** 47 occurrences across 28 files  
**Impact:** MEDIUM - Session management paths incorrect

#### Key Examples:

**File:** `/mnt/c/Code/agentic-persona-mapping/installer/templates/claude/commands/wrap.md.template`  
**Lines:** 13, 15  
**Hardcoded Paths:**  
- `/mnt/c/Code/agentic-persona-mapping/.apm/session_notes`
- `/mnt/c/Code/agentic-persona-mapping/.apm/session_notes/archive`  
**Type:** Absolute paths to session directories  
**Impact:** MEDIUM - Session wrapping functionality broken  
**Suggested Variables:**  
- `{{APM_ROOT}}/session_notes`
- `{{APM_ROOT}}/session_notes/archive`

### Category 4: Documentation Path Hardcoding

**Pattern:** `project_docs/`, `templates/`  
**Count:** 538 occurrences for `project_docs/`, 204 for `templates/`  
**Impact:** MEDIUM - Documentation references incorrect

#### Critical Example:

**File:** `/mnt/c/Code/agentic-persona-mapping/installer/templates/claude/commands/update-all-documentation.md.template`  
**Lines:** 12-47  
**Hardcoded Paths:** 35+ absolute documentation paths  
**Type:** Complete documentation structure hardcoded  
**Impact:** MEDIUM - Documentation update command completely broken  
**Suggested Variables:** Multiple `{{PROJECT_ROOT}}/`, `{{APM_ROOT}}/` substitutions needed

## 📊 DETAILED BREAKDOWN BY CATEGORY

### 1. `/mnt/c/` WSL Paths
- **Files Affected:** 134
- **Total Occurrences:** 250+
- **Severity:** CRITICAL
- **Fix Priority:** P0 - Must be resolved before release

### 2. `.apm/` Directory References  
- **Files Affected:** 89
- **Total Occurrences:** 253
- **Severity:** HIGH
- **Fix Priority:** P0 - Core APM functionality affected

### 3. `project_docs/` References
- **Files Affected:** 102  
- **Total Occurrences:** 538
- **Severity:** MEDIUM
- **Fix Priority:** P1 - Documentation and backlog management affected

### 4. `workspace/` References
- **Files Affected:** 69
- **Total Occurrences:** 223
- **Severity:** MEDIUM  
- **Fix Priority:** P1 - Development workflow assumptions

## 🔧 RECOMMENDED TEMPLATE VARIABLES

### Primary Variables Needed:

```bash
# Core Installation Paths
{{PROJECT_ROOT}}           # Base installation directory
{{APM_ROOT}}              # .apm directory location
{{WORKSPACE_ROOT}}        # User's workspace directory

# Specific Subdirectories  
{{SESSION_NOTES_DIR}}     # {{APM_ROOT}}/session_notes
{{SESSION_ARCHIVE_DIR}}   # {{APM_ROOT}}/session_notes/archive
{{RULES_DIR}}            # {{APM_ROOT}}/rules
{{VOICE_DIR}}            # {{APM_ROOT}}/agents/voice
{{PERSONAS_DIR}}         # {{APM_ROOT}}/agents/personas

# Documentation Paths
{{PROJECT_DOCS_DIR}}     # project_docs directory
{{BACKLOG_PATH}}         # {{PROJECT_DOCS_DIR}}/backlog.md
{{TEMPLATES_DIR}}        # installer/templates directory

# Configuration Paths
{{CLAUDE_CONFIG_DIR}}    # .claude directory
{{METRICS_DIR}}          # .claude/metrics directory
```

## 🚨 CRITICAL FIXES REQUIRED

### Priority 0 (CRITICAL - Breaks Installation)

1. **Voice Script Paths** (89 files)
   - Replace all `/mnt/c/Code/agentic-persona-mapping/.apm/agents/voice/` with `{{VOICE_DIR}}/`
   - Affects ALL command templates

2. **Build Script Path** (1 file)
   - `buildit.md.template` line 19: Fix build script reference
   - Prevents distribution building

3. **Performance Monitoring** (1 file)  
   - Fix metrics database path in `parallel-performance-system.md.template`
   - Breaks performance tracking

### Priority 1 (HIGH - Major Features Broken)

4. **Session Management** (28 files)
   - Replace hardcoded session_notes paths
   - Affects session wrapping, handoffs

5. **Documentation Updates** (1 file)
   - Fix `update-all-documentation.md.template` with 35+ path substitutions
   - Documentation maintenance broken

6. **Context Integration** (2 files)
   - Fix JavaScript integration examples
   - Affects sub-agent coordination

## 📋 REMEDIATION PLAN

### Phase 1: Template Variable Definition
1. Define comprehensive variable set in installer
2. Create variable substitution mapping
3. Test variable resolution logic

### Phase 2: Critical Path Fixes (P0)
1. **Voice Scripts** - Mass replacement across 89 command files
2. **Build System** - Fix distribution generation
3. **Performance Monitoring** - Fix metrics paths

### Phase 3: Feature Path Fixes (P1)  
1. **Session Management** - 28 files
2. **Documentation System** - 1 large file + references
3. **Context Integration** - JavaScript examples

### Phase 4: Documentation Path Fixes (P2)
1. **project_docs/** - 538 occurrences across 102 files
2. **workspace/** - 223 occurrences across 69 files
3. **templates/** - 204 occurrences across 89 files

## 🎯 SUCCESS METRICS

### Installation Portability Test
- [ ] APM installs successfully in `/opt/apm/`
- [ ] APM installs successfully in `~/Applications/apm/`
- [ ] APM installs successfully in `C:\Tools\APM\` (Windows)

### Functionality Validation
- [ ] Voice notifications work from any installation location
- [ ] Session management works from any location  
- [ ] Build system works from any location
- [ ] All personas activate correctly
- [ ] Documentation updates work correctly

## 📝 IMPLEMENTATION NOTES

### Variable Substitution Strategy
1. **Install-time substitution** - Replace variables during installation
2. **Runtime resolution** - Some paths may need runtime discovery
3. **Config-based paths** - Store paths in configuration files

### Testing Approach
1. **Fresh Installation Tests** - Test on clean systems
2. **Cross-Platform Tests** - Linux, macOS, Windows WSL
3. **Multiple Location Tests** - Various installation directories

### Risk Mitigation
1. **Backward Compatibility** - Maintain support for existing installations during transition
2. **Gradual Rollout** - Fix critical paths first, then documentation paths
3. **Rollback Plan** - Keep original templates as backup during migration

---

**CRITICAL RECOMMENDATION:** This hardcoding issue represents a **BLOCKER for v3.3.0 release**. The extensive hardcoding makes APM completely non-portable and breaks core functionality when installed anywhere other than the exact source development location. **Immediate action required** to implement proper template variable substitution before any distribution or deployment.