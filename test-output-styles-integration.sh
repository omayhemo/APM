#!/bin/bash

# Test script for APM Orchestrator output styles integration
# This script tests whether the installation script correctly processes output-styles

set -e

echo "=========================================="
echo "APM Output Styles Integration Test"
echo "=========================================="

# Test variables
TEST_DIR="/tmp/apm-integration-test-$$"
PAYLOAD_DIR="/mnt/c/Code/agentic-persona-mapping/payload"

# Create test environment
echo "Setting up test environment..."
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

# Run installation with defaults (non-interactive)
echo "Running APM installation with output-styles integration..."
echo "Command: $PAYLOAD_DIR/install.sh --defaults ."

# Check if the installer exists
if [ ! -f "$PAYLOAD_DIR/install.sh" ]; then
    echo "❌ Error: Installation script not found at $PAYLOAD_DIR/install.sh"
    exit 1
fi

# Check if template exists
if [ ! -f "$PAYLOAD_DIR/templates/claude/output-styles/apm-orchestrator.md.template" ]; then
    echo "❌ Error: APM orchestrator template not found"
    exit 1
fi

echo "✅ Prerequisites verified"

# Run the installer
"$PAYLOAD_DIR/install.sh" --defaults .

# Verify output-styles directory was created
if [ ! -d ".claude/output-styles" ]; then
    echo "❌ Error: .claude/output-styles directory was not created"
    exit 1
fi

echo "✅ Output-styles directory created successfully"

# Verify the apm-orchestrator.md file was created
if [ ! -f ".claude/output-styles/apm-orchestrator.md" ]; then
    echo "❌ Error: apm-orchestrator.md was not created"
    exit 1
fi

echo "✅ APM orchestrator output style file created"

# Verify template variables were substituted
if grep -q "{{PROJECT_ROOT}}" ".claude/output-styles/apm-orchestrator.md"; then
    echo "❌ Error: Template variables were not substituted (found {{PROJECT_ROOT}})"
    exit 1
fi

if grep -q "{{PROJECT_DOCS}}" ".claude/output-styles/apm-orchestrator.md"; then
    echo "❌ Error: Template variables were not substituted (found {{PROJECT_DOCS}})"
    exit 1
fi

echo "✅ Template variables were successfully substituted"

# Show a sample of the processed file
echo ""
echo "Sample from processed apm-orchestrator.md file:"
echo "----------------------------------------------"
head -20 ".claude/output-styles/apm-orchestrator.md"
echo "----------------------------------------------"

echo ""
echo "✅ All tests passed! Output styles integration is working correctly."
echo ""
echo "Generated file: $(pwd)/.claude/output-styles/apm-orchestrator.md"

# Cleanup option
echo ""
read -p "Clean up test directory? [y/N]: " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    cd /
    rm -rf "$TEST_DIR"
    echo "✅ Test directory cleaned up"
else
    echo "📁 Test directory preserved at: $TEST_DIR"
fi