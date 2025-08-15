# APM Documentation Generation Paths - Comprehensive Report

## Executive Summary

The APM system has well-defined documentation paths and workspace boundaries for each agent persona. However, there appears to be a disconnect between the defined paths and where some documents are being created. The handoff and transition documents are correctly being placed in the session notes directory, but other documentation may be landing in the root folder due to missing path specifications or improper use of Write tools.

## Key Findings

### 1. Workspace Boundaries (Per Agent)

Each agent persona has clearly defined workspace boundaries:

#### **Analyst Agent**
- **Primary**: `project_docs/requirements/` (research, analysis)
- **Output**: `deliverables/reports/` (analysis reports)
- **Read-Only**: All other directories

#### **Product Manager (PM) Agent**
- **Primary**: `project_docs/base/` (PRDs, project foundation)
- **Secondary**: `deliverables/artifacts/` (roadmaps, presentations)
- **Read-Only**: `workspace/` (understanding technical context)

#### **Product Owner (PO) Agent**
- **Primary**: `project_docs/` (all project documentation)
- **Secondary**: `deliverables/` (all project outputs)
- **Limited**: `workspace/` (validation only, no modification)

#### **Architect Agent**
- **Primary**: `project_docs/architecture/` (system design)
- **Secondary**: `workspace/` (understanding codebase)
- **Output**: `deliverables/artifacts/` (architecture diagrams)

#### **Design Architect Agent**
- **Primary**: `project_docs/specifications/` (UI/UX specs)
- **Secondary**: `workspace/components/` (component design)
- **Output**: `deliverables/artifacts/` (design assets)

#### **Developer Agent**
- **Primary**: `workspace/src/` (source code)
- **Secondary**: `workspace/tests/` (test files)
- **Read-Only**: `project_docs/` (specifications)
- **Output**: `deliverables/releases/` (build artifacts)

#### **QA Agent**
- **Primary**: `workspace/tests/` (test files)
- **Secondary**: `deliverables/reports/` (test reports)
- **Read-Only**: `workspace/src/`, `project_docs/` (validation)

#### **Scrum Master (SM) Agent**
- **Primary**: `project_docs/` (project planning)
- **Secondary**: `deliverables/reports/` (sprint reports)
- **Read-Only**: `workspace/` (progress assessment)

### 2. Forbidden Paths (All Agents)

All agents are explicitly forbidden from accessing:
- `.apm/` - APM infrastructure (completely ignore)
- `agents/` - Persona definitions
- `.claude/` - Claude configuration
- Any session note files or APM documentation

### 3. Handoff Documentation

Handoff documents are correctly managed in a dedicated directory:
- **Location**: `/mnt/c/Code/agentic-persona-mapping/.apm/session_notes/handoffs/`
- **Format**: `YYYY-MM-DD-HH-mm-ss-[source]-to-[target]-handoff.md`
- **Purpose**: Session artifacts (not project deliverables)

Examples found:
- `2025-07-25-11-15-00-po-to-sm-handoff.md`
- `2025-07-18-09-02-53-analyst-to-pm-handoff.md`
- `2025-07-18-09-39-54-pm-to-po-handoff.md`

### 4. Documentation Generation Issues

The investigation revealed several potential causes for documents appearing in the root folder:

1. **No explicit Write/MultiEdit calls found** in agent personas
2. **References to "Obsidian MCP"** for documentation creation (lines 177 in dev.md, line 240 in analyst.md)
3. **Automatic handoff document generation** mentioned but implementation not visible
4. **Missing path validation** before document creation

### 5. Key Path Variables

The system uses these primary path variables:
- `project_docs/` - Main project documentation
- `deliverables/` - Project outputs and artifacts
- `workspace/` - Source code and implementation
- `.apm/session_notes/` - Session artifacts and handoffs

## Root Cause Analysis

Documents are likely appearing in the root folder due to:

1. **Missing Path Prefixes**: When agents create documents without specifying full paths
2. **Obsidian MCP Integration**: The system mentions using "Obsidian MCP" which may default to root
3. **Template Processing**: Some templates may not properly substitute path variables
4. **User Working Directory**: Agents may create files relative to where the user launched Claude

## Recommendations

### Immediate Fixes

1. **Update Agent Personas** to always use absolute paths:
   ```markdown
   When creating any document, ALWAYS use full absolute paths:
   - Research reports: `/project_docs/requirements/[filename].md`
   - Architecture docs: `/project_docs/architecture/[filename].md`
   - Test reports: `/deliverables/reports/[filename].md`
   ```

2. **Add Path Validation** to each agent's workflow:
   ```markdown
   Before creating any file:
   1. Verify the target directory exists
   2. Ensure path starts with allowed workspace directory
   3. Never create files in project root
   ```

3. **Remove Obsidian MCP References** or configure it properly:
   - Either remove mentions of Obsidian MCP
   - Or add clear configuration for output directories

### Long-term Solutions

1. **Create Document Management Task**: A standardized task that all agents use for document creation with built-in path validation

2. **Add Path Constants**: Define clear path constants in each agent:
   ```markdown
   ## Document Paths
   REQUIREMENTS_PATH = /project_docs/requirements/
   ARCHITECTURE_PATH = /project_docs/architecture/
   REPORTS_PATH = /deliverables/reports/
   ```

3. **Implement Write Wrapper**: Create a wrapper function that enforces path rules before any file write

4. **Add Cleanup Task**: Regular task to identify and move misplaced documents

## Affected Files

Files that need updating:
- `.apm/agents/personas/analyst.md` (line 240 - Obsidian MCP reference)
- `.apm/agents/personas/dev.md` (line 177 - Obsidian MCP reference)
- All persona files - Add explicit path validation rules
- Task files that mention "automatic handoff document"

## Conclusion

The APM system has well-defined workspace boundaries and documentation paths, but lacks enforcement mechanisms. Documents are appearing in the root folder because agents are creating files without proper path prefixes or validation. The solution requires updating agent personas with explicit path rules and removing/configuring external tools like Obsidian MCP that may default to root directory creation.