# Installer Cleanup Fix - Implementation Plan

**Date**: 2025-07-23  
**Author**: Product Owner  
**Status**: Draft

## Problem Statement

The current installer script (`templates/install.sh`) properly preserves the installer files in `.apm/.installer/` but leaves the `install.sh` file in the project root after installation. This creates clutter and confusion for users.

## Current Behavior

1. User extracts distribution to a directory
2. User runs `./installer/install.sh` or copies `install.sh` to project root
3. Installer creates `.apm/.installer/` and preserves installer files
4. Installer removes various distribution files (LICENSE, VERSION, etc.)
5. **BUG**: `install.sh` remains in project root if copied there

## Root Cause Analysis

The installer script (lines 1515-1567) handles preservation and cleanup:
- Preserves installer in `.apm/.installer/` ✓
- Removes tar.gz archive ✓
- Removes LICENSE/VERSION from root ✓
- Removes installer directory from distribution ✓
- **Missing**: Doesn't remove `install.sh` from project root

The issue occurs when users:
1. Copy `install.sh` to their project root before running
2. Run the installer from within the project directory

## Proposed Solution

### 1. Add Self-Cleanup Logic

Add logic to remove the installer script itself from the project root after successful installation:

```bash
# After line 1567, add:
# Remove installer script from project root if it exists
INSTALLER_SCRIPT="$PROJECT_ROOT/install.sh"
if [ -f "$INSTALLER_SCRIPT" ] && [ "$INSTALLER_SCRIPT" != "$0" ]; then
    # Verify this is our installer script by checking for unique content
    if grep -q "AP Mapping Installation Script" "$INSTALLER_SCRIPT" 2>/dev/null; then
        rm -f "$INSTALLER_SCRIPT"
        echo "- Removed installer script from project root"
    fi
fi
```

### 2. Handle Edge Cases

Consider scenarios where removal might fail:
- Script is still running (use delayed removal)
- Permission issues
- Script was renamed

### 3. Improved Installation Instructions

Update distribution README to clarify best practices:
```markdown
## Installation Best Practices

1. Extract the distribution archive
2. Run installer directly from extraction directory:
   ```
   cd apm-v2.4.1
   ./installer/install.sh /path/to/your/project
   ```
3. Avoid copying install.sh to your project first
```

## Implementation Details

### Changes to `templates/install.sh`:

1. **Add Self-Identification** (line ~10):
```bash
# Script identification for cleanup
INSTALLER_SIGNATURE="AP Mapping Installation Script - Template-based installer"
```

2. **Add Cleanup Function** (after line 1567):
```bash
# Clean up installer script from project root
cleanup_installer_script() {
    local installer_in_root="$PROJECT_ROOT/install.sh"
    
    # Don't remove if we're running from this location
    if [ "$(readlink -f "$0")" = "$(readlink -f "$installer_in_root")" ]; then
        # Schedule removal after script completes
        cat > "$PROJECT_ROOT/.apm/.installer/cleanup-installer.sh" << 'EOF'
#!/bin/bash
sleep 2
if [ -f "$1" ] && grep -q "AP Mapping Installation Script" "$1" 2>/dev/null; then
    rm -f "$1"
    rm -f "$0"  # Remove this cleanup script too
fi
EOF
        chmod +x "$PROJECT_ROOT/.apm/.installer/cleanup-installer.sh"
        nohup "$PROJECT_ROOT/.apm/.installer/cleanup-installer.sh" "$installer_in_root" >/dev/null 2>&1 &
        echo "- Scheduled installer cleanup"
    elif [ -f "$installer_in_root" ]; then
        # Safe to remove directly
        if grep -q "$INSTALLER_SIGNATURE" "$installer_in_root" 2>/dev/null; then
            rm -f "$installer_in_root"
            echo "- Removed installer script from project root"
        fi
    fi
}

# Call cleanup function
cleanup_installer_script
```

### Testing Scenarios

1. **Test 1**: Install from distribution directory
   - Expected: No install.sh in project root

2. **Test 2**: Copy install.sh to project root first
   - Expected: install.sh removed after installation

3. **Test 3**: Run install.sh from project root
   - Expected: Delayed removal after script completes

4. **Test 4**: Permission issues
   - Expected: Warning message, manual removal instructions

## Risk Assessment

- **Low Risk**: Only removes files matching our signature
- **Safe Guards**: 
  - Signature verification before removal
  - Doesn't remove if script is currently executing from that location
  - Delayed removal for self-execution scenario

## Implementation Steps

1. Update `templates/install.sh` with cleanup logic
2. Test all installation scenarios
3. Update distribution build process if needed
4. Document in release notes

## Success Criteria

- No `install.sh` left in project root after installation
- All installation methods work correctly
- No accidental file deletions
- Clear user feedback about cleanup actions

---
*Plan created by Product Owner on 2025-07-23*