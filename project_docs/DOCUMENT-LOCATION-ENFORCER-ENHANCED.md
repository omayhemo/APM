# Document Location Enforcer - Enhanced Directory Protection

## Problem Solved

The PM agent (and potentially other agents) were creating epic and story folders directly under `project_docs/` instead of the correct location under `project_docs/planning/`. This violated the APM document structure standards.

### Incorrect Structure (What PM Was Creating)
```
project_docs/
├── epics/           ❌ WRONG - Created by PM
│   ├── epic-01-infrastructure.md
│   └── epic-02-features.md
└── stories/         ❌ WRONG - Created by PM
    ├── story-001-login.md
    └── story-002-dashboard.md
```

### Correct Structure (What Should Be Created)
```
project_docs/
└── planning/        ✅ CORRECT - Proper hierarchy
    ├── epics/
    │   ├── epic-01-infrastructure.md
    │   └── epic-02-features.md
    └── stories/
        ├── story-001-login.md
        └── story-002-dashboard.md
```

## Solution Implemented

The Document Location Enforcer has been enhanced with **three layers of protection**:

### 1. Bash Command Interception
- **Intercepts**: `mkdir` commands that create folders in wrong locations
- **Corrects**: Automatically redirects to proper `planning/` subdirectory
- **Logs**: Records all corrections for audit

### 2. Direct Path Correction
- **Intercepts**: `Write` and `Edit` operations to wrong paths
- **Corrects**: File paths before they're created
- **Prevents**: Files from being created in non-existent wrong directories

### 3. Intelligent Document Type Detection
- **Analyzes**: Content, filename patterns, and agent context
- **Routes**: Documents to their designated locations
- **Enforces**: Naming conventions and structure

## Technical Implementation

### New Method: `process_bash_command()`
```python
def process_bash_command(self, params: dict, context: dict = None) -> dict:
    """
    Process Bash commands to prevent directory creation in wrong locations
    """
    # Intercepts and corrects:
    # - mkdir project_docs/epics → mkdir project_docs/planning/epics
    # - mkdir project_docs/stories → mkdir project_docs/planning/stories
```

### Enhanced Path Checking
```python
# Direct path violation checking
direct_corrections = {
    r'(.*/)?project_docs/epics/': r'\1project_docs/planning/epics/',
    r'(.*/)?project_docs/stories/': r'\1project_docs/planning/stories/',
}
```

## Coverage

### Commands Protected
- ✅ `mkdir` - Directory creation
- ✅ `mkdir -p` - Recursive directory creation
- ✅ `touch` - File creation with parent dirs
- ✅ `echo > file` - Output redirection
- ✅ `Write` tool - Direct file writing
- ✅ `Edit` tool - File editing
- ✅ `MultiEdit` tool - Batch editing

### Document Types Enforced
- ✅ Epics → `project_docs/planning/epics/`
- ✅ Stories → `project_docs/planning/stories/`
- ✅ Retrospectives → `project_docs/planning/retrospectives/`
- ✅ Roadmaps → `project_docs/planning/roadmaps/`
- ✅ Test Plans → `project_docs/qa/test-plans/`
- ✅ Test Results → `project_docs/qa/test-results/`
- ✅ Architecture Decisions → `project_docs/architecture/decisions/`
- ✅ Specifications → `project_docs/architecture/specifications/`

## Audit Trail

All corrections are logged to:
- **Directory Corrections**: `.apm/logs/directory-corrections.json`
- **Location Overrides**: `.apm/logs/location-overrides.json`

### Log Entry Format
```json
{
  "timestamp": "2025-01-08T15:30:00",
  "agent": "PM",
  "original_command": "mkdir project_docs/epics",
  "corrected_command": "mkdir project_docs/planning/epics",
  "correction_type": "directory_structure"
}
```

## User Experience

When an agent attempts to create folders/files in wrong locations:

```
📁 Directory structure enforced for PM agent
   ❌ Blocked: Creating folders directly under project_docs/
   ✅ Corrected: Folders will be created under project_docs/planning/
```

## Benefits

1. **Automatic Compliance**: No manual intervention needed
2. **Transparent**: Agents see corrections in real-time
3. **Auditable**: Complete trail of all corrections
4. **Configurable**: Can be customized via document-registry.json
5. **Non-Breaking**: Corrections happen silently, work continues

## Configuration

The enforcer uses the document registry at:
```
.apm/config/document-registry.json
```

### Key Configuration
```json
{
  "document_types": {
    "story": {
      "location": "{{PROJECT_DOCS}}/planning/stories/",
      "type": "collection",
      "allow_subfolders": true
    },
    "epic": {
      "location": "{{PROJECT_DOCS}}/planning/epics/",
      "type": "collection",
      "allow_subfolders": true
    }
  }
}
```

## Testing

To test the enforcer:

1. **Try Creating Wrong Directory**:
   ```bash
   mkdir project_docs/epics
   # Automatically corrected to: mkdir project_docs/planning/epics
   ```

2. **Try Writing File to Wrong Location**:
   ```python
   Write("project_docs/stories/story-001.md", content)
   # Automatically corrected to: project_docs/planning/stories/story-001.md
   ```

3. **Check Audit Logs**:
   ```bash
   cat .apm/logs/directory-corrections.json
   ```

## Rollback

If needed, enforcement can be disabled by:
1. Removing the hook from `.apm/hooks/pre_tool_use.py`
2. Or using the override flag: `--force-location`

## Summary

The Document Location Enforcer now provides **comprehensive protection** against document structure violations, ensuring all APM agents follow the standardized folder hierarchy. The PM agent (or any other agent) can no longer "shit all over the document structure" - all attempts to create folders/files in wrong locations are automatically corrected and logged.

---

**Status**: ✅ FIXED - Document structure is now fully protected
**Impact**: All agents will have their folder/file creation automatically corrected
**Deployment**: Include updated `pre_tool_use_location_enforcer.py` in next build