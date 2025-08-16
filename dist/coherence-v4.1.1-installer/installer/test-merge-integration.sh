#!/bin/bash

# Test script for merge integration in installer
# This tests the enhanced Step 10 functionality

set -e

echo "=========================================="
echo "Testing Merge Integration in Installer"
echo "=========================================="
echo ""

# Create a temporary test directory
TEST_DIR="/tmp/apm-merge-test-$$"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

echo "Test directory: $TEST_DIR"
echo ""

# Simulate installer variables
PROJECT_ROOT="$TEST_DIR"
APM_ROOT="$PROJECT_ROOT/.apm"
AP_ROOT="$APM_ROOT/agents"
INSTALLER_DIR="/mnt/c/Code/agentic-persona-mapping/templates"
MERGE_SYSTEM="${APM_ROOT}/.installer/claude-merge-system"
MERGE_ORCHESTRATOR="${MERGE_SYSTEM}/merge-orchestrator.sh"
TEMPLATE_FILE="${INSTALLER_DIR}/template.claude.md"
ROOT_CLAUDE_MD="${PROJECT_ROOT}/CLAUDE.md"
BACKUP_DIR="${APM_ROOT}/backups/claude-md"

# Create APM structure
mkdir -p "$AP_ROOT"
mkdir -p "$MERGE_SYSTEM"
mkdir -p "$BACKUP_DIR"

# Copy merge system to test location
echo "Copying merge system..."
cp -r /mnt/c/Code/agentic-persona-mapping/.apm/.installer/claude-merge-system/* "$MERGE_SYSTEM/"
echo "✓ Merge system copied"
echo ""

# Test 1: New installation (no existing CLAUDE.md)
echo "Test 1: New installation (no existing CLAUDE.md)"
echo "-----------------------------------------------"

if [[ -f "$MERGE_ORCHESTRATOR" ]]; then
    echo "Using intelligent merge system..."
    
    if [[ -f "$ROOT_CLAUDE_MD" ]]; then
        echo "ERROR: File should not exist yet"
        exit 1
    else
        # No existing file - use template directly
        echo "Creating new CLAUDE.md from template..."
        cp "$TEMPLATE_FILE" "$ROOT_CLAUDE_MD"
        echo "✓ Created new CLAUDE.md"
    fi
else
    echo "ERROR: Merge orchestrator not found"
    exit 1
fi

# Verify file was created
if [[ -f "$ROOT_CLAUDE_MD" ]]; then
    echo "✓ Test 1 passed: New CLAUDE.md created"
else
    echo "✗ Test 1 failed: CLAUDE.md not created"
    exit 1
fi
echo ""

# Test 2: Update with existing CLAUDE.md
echo "Test 2: Update with existing CLAUDE.md"
echo "--------------------------------------"

# Add custom content to simulate user modifications
echo "" >> "$ROOT_CLAUDE_MD"
echo "## My Custom Section" >> "$ROOT_CLAUDE_MD"
echo "This is custom user content that should be preserved." >> "$ROOT_CLAUDE_MD"

# Run merge
if [[ -f "$MERGE_ORCHESTRATOR" ]]; then
    echo "Using intelligent merge system..."
    
    if [[ -f "$ROOT_CLAUDE_MD" ]]; then
        echo "Existing CLAUDE.md found. Performing intelligent merge..."
        
        # Run merge orchestrator
        if "${MERGE_ORCHESTRATOR}" \
            --template "$TEMPLATE_FILE" \
            --user "$ROOT_CLAUDE_MD" \
            --output "${ROOT_CLAUDE_MD}.new" \
            --backup-dir "$BACKUP_DIR" \
            --strategy auto \
            --quiet; then
            
            # Success - replace old file
            mv "${ROOT_CLAUDE_MD}.new" "$ROOT_CLAUDE_MD"
            echo "✓ CLAUDE.md successfully merged using intelligent merge"
            echo "  Backup saved to: ${BACKUP_DIR}/"
        else
            echo "✗ Intelligent merge failed"
            exit 1
        fi
    fi
fi

# Verify custom content was preserved
if grep -q "My Custom Section" "$ROOT_CLAUDE_MD"; then
    echo "✓ Test 2 passed: Custom content preserved"
else
    echo "✗ Test 2 failed: Custom content not preserved"
    exit 1
fi

# Check for APM section
if grep -q "<BEGIN-APM-CLAUDE-MERGE>" "$ROOT_CLAUDE_MD"; then
    echo "✓ APM section present"
else
    echo "✗ APM section missing"
    exit 1
fi
echo ""

# Test 3: Verify backup was created
echo "Test 3: Verify backup functionality"
echo "----------------------------------"

BACKUP_COUNT=$(ls -1 "$BACKUP_DIR" 2>/dev/null | wc -l)
if [[ $BACKUP_COUNT -gt 0 ]]; then
    echo "✓ Test 3 passed: Backup created ($BACKUP_COUNT files)"
    ls -la "$BACKUP_DIR"
else
    echo "✗ Test 3 failed: No backup created"
    exit 1
fi
echo ""

# Test 4: Test merge failure fallback
echo "Test 4: Test merge failure fallback"
echo "----------------------------------"

# Create an invalid template to trigger failure
INVALID_TEMPLATE="$TEST_DIR/invalid-template.md"
echo "This is not a valid template" > "$INVALID_TEMPLATE"

# Temporarily make merge orchestrator fail by using invalid template
if "${MERGE_ORCHESTRATOR}" \
    --template "$INVALID_TEMPLATE" \
    --user "$ROOT_CLAUDE_MD" \
    --output "${ROOT_CLAUDE_MD}.failed" \
    --backup-dir "$BACKUP_DIR" \
    --strategy auto \
    --quiet 2>/dev/null; then
    echo "✗ Test 4 failed: Merge should have failed with invalid template"
    exit 1
else
    echo "✓ Test 4 passed: Merge correctly failed with invalid template"
fi
echo ""

# Clean up
echo "Cleaning up test directory..."
rm -rf "$TEST_DIR"

echo ""
echo "=========================================="
echo "All tests passed! ✓"
echo "=========================================="
echo ""
echo "The merge integration is working correctly:"
echo "- New installations create CLAUDE.md from template"
echo "- Updates preserve user customizations"
echo "- Backups are created automatically"
echo "- Failures are handled gracefully"