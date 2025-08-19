#!/bin/bash

# Comprehensive APM Template Generation and Configuration Test
# This script validates the APM installation without requiring system dependencies

set -e

echo "=========================================="
echo "APM Comprehensive Integration Test"
echo "=========================================="

# Test variables
TEST_DIR="/tmp/apm-comprehensive-test-$$"
PAYLOAD_DIR="/mnt/c/Code/agentic-persona-mapping/payload"

# Create test environment
echo "🔧 Setting up test environment..."
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

echo "✅ Test directory created: $TEST_DIR"

# Mock the installation process without system dependencies
echo "🚀 Running APM template processing test..."

# Create minimal directory structure for testing
mkdir -p .apm .claude project_docs

# Test template processor directly
echo "📋 Testing template processor..."

# Test 1: Verify template files exist
echo "🧪 Test 1: Template File Verification"
if [ ! -f "$PAYLOAD_DIR/templates/claude/output-styles/apm-orchestrator.md.template" ]; then
    echo "❌ Output styles template not found"
    exit 1
fi

if [ ! -f "$PAYLOAD_DIR/templates/claude/settings.json.template" ]; then
    echo "❌ Settings template not found"
    exit 1
fi

echo "✅ All template files found"

# Test 2: Template Processing Test
echo "🧪 Test 2: Template Variable Substitution"

# Define test variables (simulate what the installer would do)
export PROJECT_ROOT="$TEST_DIR"
export PROJECT_DOCS="$TEST_DIR/project_docs"
export APM_ROOT="$TEST_DIR/.apm"
export AP_ROOT="$TEST_DIR/.apm/agents"
export PROJECT_NAME="apm-comprehensive-test"
export CLAUDE_COMMANDS_DIR="$TEST_DIR/.claude/commands"
export PLANNING_ROOT=""
export NOTES_TYPE="markdown"
export SESSION_NOTES_PATH="$TEST_DIR/.apm/session_notes"
export RULES_PATH="$TEST_DIR/.apm/rules"
export ARCHIVE_PATH="$TEST_DIR/.apm/session_notes/archive"
export FALLBACK_SESSION_NOTES_PATH=""
export FALLBACK_RULES_PATH=""
export FALLBACK_ARCHIVE_PATH=""

# Create output-styles directory
mkdir -p "$TEST_DIR/.claude/output-styles"

# Process the output-styles template using environment variables
"$PAYLOAD_DIR/template-processor-bash.sh" \
  --env \
  "$PAYLOAD_DIR/templates/claude/output-styles/apm-orchestrator.md.template" \
  "$TEST_DIR/.claude/output-styles/apm-orchestrator.md"

# Process the settings template using environment variables  
"$PAYLOAD_DIR/template-processor-bash.sh" \
  --env \
  "$PAYLOAD_DIR/templates/claude/settings.json.template" \
  "$TEST_DIR/.claude/settings.json"

echo "✅ Template processing completed"

# Test 3: Verify template variable substitution
echo "🧪 Test 3: Variable Substitution Verification"

# Check that no template variables remain in output-styles
if grep -q "{{.*}}" "$TEST_DIR/.claude/output-styles/apm-orchestrator.md"; then
    echo "❌ Unprocessed template variables found in apm-orchestrator.md:"
    grep "{{.*}}" "$TEST_DIR/.claude/output-styles/apm-orchestrator.md"
    exit 1
fi

# Check that no template variables remain in settings.json
if grep -q "{{.*}}" "$TEST_DIR/.claude/settings.json"; then
    echo "❌ Unprocessed template variables found in settings.json:"
    grep "{{.*}}" "$TEST_DIR/.claude/settings.json"
    exit 1
fi

echo "✅ No unprocessed template variables found"

# Test 4: Verify specific substitutions
echo "🧪 Test 4: Specific Substitution Verification"

# Check PROJECT_ROOT substitution in output-styles
if ! grep -q "$TEST_DIR" "$TEST_DIR/.claude/output-styles/apm-orchestrator.md"; then
    echo "❌ PROJECT_ROOT not properly substituted in output-styles"
    exit 1
fi

# Check PROJECT_ROOT substitution in settings.json
if ! grep -q "\"PROJECT_ROOT\": \"$TEST_DIR\"" "$TEST_DIR/.claude/settings.json"; then
    echo "❌ PROJECT_ROOT not properly substituted in settings.json"
    exit 1
fi

echo "✅ Specific substitutions verified"

# Test 5: JSON Validity
echo "🧪 Test 5: JSON Structure Validation"

# Validate settings.json is valid JSON
if ! python3 -m json.tool "$TEST_DIR/.claude/settings.json" > /dev/null 2>&1; then
    echo "❌ Generated settings.json is not valid JSON"
    exit 1
fi

echo "✅ settings.json is valid JSON"

# Test 6: Output Style Configuration
echo "🧪 Test 6: Output Style Configuration"

# Check output_style section in settings.json
if ! grep -q '"default": "APM Orchestrator"' "$TEST_DIR/.claude/settings.json"; then
    echo "❌ APM Orchestrator not set as default output style"
    exit 1
fi

if ! grep -q '"APM Orchestrator"' "$TEST_DIR/.claude/settings.json"; then
    echo "❌ APM Orchestrator not in available styles"
    exit 1
fi

echo "✅ Output style configuration verified"

# Test 7: Content Structure Validation
echo "🧪 Test 7: Generated Content Structure"

# Check that the output-styles file contains key sections
required_sections=(
    "Core Behavioral Principles"
    "Communication Patterns"
    "Agent Coordination Protocols"
    "Session Management"
    "Persona Activation"
)

for section in "${required_sections[@]}"; do
    if ! grep -q "$section" "$TEST_DIR/.claude/output-styles/apm-orchestrator.md"; then
        echo "❌ Missing required section: $section"
        exit 1
    fi
done

echo "✅ All required content sections found"

# Test 8: Path Resolution Test
echo "🧪 Test 8: Path Resolution Verification"

# Check that paths in output-styles are absolute
if grep -q "PROJECT_ROOT" "$TEST_DIR/.claude/output-styles/apm-orchestrator.md"; then
    echo "❌ Relative path references found in output-styles"
    exit 1
fi

# Check specific path substitutions
expected_paths=(
    "$TEST_DIR/project_docs/"
    "$TEST_DIR/workspace/"
    "$TEST_DIR/.apm/session_notes/"
)

for path in "${expected_paths[@]}"; do
    if ! grep -q "$path" "$TEST_DIR/.claude/output-styles/apm-orchestrator.md"; then
        echo "❌ Expected path not found: $path"
        exit 1
    fi
done

echo "✅ Path resolution verified"

# Display sample output
echo ""
echo "📊 Sample Generated Content:"
echo "----------------------------"
echo "Output Style (first 20 lines):"
head -20 "$TEST_DIR/.claude/output-styles/apm-orchestrator.md"
echo ""
echo "Settings.json (output_style section):"
grep -A 8 '"output_style"' "$TEST_DIR/.claude/settings.json"
echo ""

# Summary
echo "=========================================="
echo "🎯 TEST SUMMARY"
echo "=========================================="
echo "✅ Template file verification"
echo "✅ Template variable substitution" 
echo "✅ Variable substitution verification"
echo "✅ Specific substitution verification"
echo "✅ JSON structure validation"
echo "✅ Output style configuration"
echo "✅ Generated content structure"
echo "✅ Path resolution verification"
echo ""
echo "🚀 ALL TESTS PASSED!"
echo ""
echo "Generated files:"
echo "- $TEST_DIR/.claude/output-styles/apm-orchestrator.md"
echo "- $TEST_DIR/.claude/settings.json"
echo ""

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

echo ""
echo "🎯 APM Template Generation and Configuration Test Complete!"