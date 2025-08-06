# Document Location Enforcement System - Installation Guide
**Version**: 1.0  
**Date**: 2025-01-06  
**Deployment Time**: ~10 minutes

## Overview

This guide walks you through installing the **Document Location Enforcement System** that ensures all documents are created in their designated locations with proper naming conventions.

## Prerequisites

- APM Framework v3.3.0 or higher installed
- Python 3.8+ available
- Write access to `.apm/` directory
- Claude Code with hooks support

## Installation Steps

### Step 1: Deploy the Document Registry

1. **Copy the registry template to your APM config directory:**

```bash
# Create config directory if it doesn't exist
mkdir -p .apm/config

# Copy the registry template (assuming you've run the installer)
cp installer/templates/config/document-registry.json.template .apm/config/document-registry.json

# Or manually create it from the template
```

2. **Verify variable substitution:**

The registry uses these variables that should be replaced during installation:
- `{{PROJECT_ROOT}}` → Your project root directory
- `{{PROJECT_DOCS}}` → `project_docs/`
- `{{APM_ROOT}}` → `.apm/`
- `{{SESSION_NOTES_PATH}}` → `.apm/session_notes/`

### Step 2: Install the Pre-Tool Hook

1. **Create hooks directory:**

```bash
mkdir -p .apm/hooks
```

2. **Copy the hook script:**

```bash
cp installer/templates/hooks/pre_tool_use_location_enforcer.py .apm/hooks/
chmod +x .apm/hooks/pre_tool_use_location_enforcer.py
```

3. **Test the hook standalone:**

```bash
python3 .apm/hooks/pre_tool_use_location_enforcer.py
```

You should see test output showing path corrections.

### Step 3: Configure Claude Code Settings

1. **Update `.claude/settings.json`:**

```json
{
  "env": {
    "HOOK_PRE_TOOL_USE_ENABLED": "true",
    "HOOK_PRE_TOOL_USE_SCRIPT": ".apm/hooks/pre_tool_use_location_enforcer.py",
    "PROJECT_ROOT": "/path/to/your/project",
    "APM_ROOT": "/path/to/your/project/.apm"
  }
}
```

2. **Create the hook wrapper (if needed):**

Some Claude Code versions may need a wrapper script. Create `.apm/hooks/pre_tool_use_wrapper.sh`:

```bash
#!/bin/bash
python3 .apm/hooks/pre_tool_use_location_enforcer.py "$@"
```

Make it executable:
```bash
chmod +x .apm/hooks/pre_tool_use_wrapper.sh
```

### Step 4: Create Required Directory Structure

The system expects certain directories to exist:

```bash
# Create all required directories
mkdir -p project_docs/{backlog,planning,architecture,qa,reports,general}
mkdir -p project_docs/planning/{stories,epics,retrospectives,roadmaps}
mkdir -p project_docs/architecture/{decisions,specifications,diagrams}
mkdir -p project_docs/qa/{test-plans,test-results,defects}
mkdir -p .apm/logs
mkdir -p .apm/session_notes/archive
```

### Step 5: Verify Installation

1. **Test document creation:**

Create a test file to verify the hook is working:

```bash
# In Claude Code, try creating a test document
/write file_path="test.md" content="# Test Plan\n\nThis is a test"

# Should see:
# ✅ Created at correct location: project_docs/qa/test-plans/TEST-PLAN-2025-01-06-001.md
```

2. **Check the logs:**

```bash
# Check if override log directory was created
ls -la .apm/logs/

# If any overrides were used, you'll see:
# location-overrides.json
```

## Configuration Options

### Customizing Document Types

Edit `.apm/config/document-registry.json` to add new document types:

```json
"new_doc_type": {
  "location": "project_docs/custom/",
  "type": "collection",
  "naming": {
    "pattern": "CUSTOM-{date}-{seq}.md",
    "date_format": "YYYY-MM-DD",
    "seq_format": "\\d{3}"
  },
  "allow_subfolders": true,
  "detection": {
    "filename_patterns": ["custom", "special"],
    "content_markers": ["Custom Section", "Special Content"],
    "agent_hints": ["Developer"]
  }
}
```

### Adjusting Detection Sensitivity

The system uses weighted scoring:
- Filename patterns: 40%
- Content markers: 40%
- Agent hints: 20%

Confidence threshold is 50%. To adjust, modify the hook script:

```python
# In pre_tool_use_location_enforcer.py
if doc_type == 'uncertain' or confidence < 50:  # Change 50 to desired threshold
```

### Emergency Override Usage

To bypass location enforcement in emergencies:

```bash
/write file_path="emergency.md" --force-location justification="Urgent hotfix documentation"
```

This will:
1. Allow the write to proceed
2. Log the override with justification
3. Alert if threshold exceeded (default: 5 in 24 hours)

## Troubleshooting

### Hook Not Activating

1. **Check settings.json:**
```bash
cat .claude/settings.json | grep HOOK
```

2. **Verify Python path:**
```bash
which python3
# Update shebang in hook script if needed
```

3. **Check hook permissions:**
```bash
ls -la .apm/hooks/pre_tool_use_location_enforcer.py
# Should be executable (rwxr-xr-x)
```

### Incorrect Path Corrections

1. **Review detection patterns:**
```bash
# Check what patterns matched
python3 -c "from pre_tool_use_location_enforcer import *; print(detect_document_type('test.md', {'content': 'test'}, {}))"
```

2. **Adjust patterns in registry:**
- Add more specific filename patterns
- Add unique content markers
- Update agent hints

### Performance Issues

1. **Check file counts:**
```bash
find project_docs -name "*.md" | wc -l
```

2. **If slow with many files:**
- The system does full analysis each time (by design)
- Consider implementing caching (not in initial design per requirements)

## Monitoring

### View Override Usage

```bash
# Check override log
cat .apm/logs/location-overrides.json | jq '.'

# Count recent overrides
cat .apm/logs/location-overrides.json | jq '. | length'
```

### Track Correction Statistics

The hook adds metadata to corrected files:
- `_location_corrected`: true
- `_original_path`: What was requested
- `_doc_type`: Detected type

## Rollback

To disable the system temporarily:

1. **Disable in settings:**
```json
{
  "env": {
    "HOOK_PRE_TOOL_USE_ENABLED": "false"
  }
}
```

2. **Or rename the hook:**
```bash
mv .apm/hooks/pre_tool_use_location_enforcer.py .apm/hooks/pre_tool_use_location_enforcer.py.disabled
```

## Best Practices

1. **Regular Registry Updates**: Review and update document types monthly
2. **Monitor Override Usage**: Weekly review of override logs
3. **Agent Training**: Inform team about automatic corrections
4. **Subfolder Strategy**: Use consistent subfolder patterns
5. **Backup Registry**: Keep a backup of your customized registry

## Support

For issues or questions:
1. Check the design document: `APM-DOCUMENT-LOCATION-ENFORCEMENT-DESIGN.md`
2. Review the enforcement logs: `.apm/logs/`
3. Test with standalone script: `python3 .apm/hooks/pre_tool_use_location_enforcer.py`

## Success Indicators

You'll know the system is working when:
- ✅ Documents appear in correct directories automatically
- ✅ Naming conventions are consistently applied
- ✅ Agents see "Created at correct location" messages
- ✅ No orphaned documents in root or wrong directories
- ✅ Override usage is <1% of document creation

---

**Next Steps**: After installation, monitor the system for a week and adjust detection patterns based on actual usage patterns.