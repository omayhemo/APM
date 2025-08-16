#!/bin/bash

# Simple APM Template Validation Test
# This script validates existing generated files from the previous test

set -e

echo "=========================================="
echo "APM Template Validation Test"
echo "=========================================="

# Use the existing test directory from the successful installation
TEST_DIR="/tmp/apm-integration-test-55232"

if [ ! -d "$TEST_DIR" ]; then
    echo "❌ Test directory not found: $TEST_DIR"
    echo "Please run the main installation test first"
    exit 1
fi

echo "🔍 Validating generated files in: $TEST_DIR"

# Test 1: Verify output-styles directory and file
echo "🧪 Test 1: Output-styles Directory Verification"

if [ ! -d "$TEST_DIR/.claude/output-styles" ]; then
    echo "❌ Output-styles directory not created"
    exit 1
fi

if [ ! -f "$TEST_DIR/.claude/output-styles/apm-orchestrator.md" ]; then
    echo "❌ APM orchestrator output style file not created"
    exit 1
fi

echo "✅ Output-styles directory and file verified"

# Test 2: Template variable substitution verification
echo "🧪 Test 2: Template Variable Substitution"

# Check that no template variables remain in output-styles
if grep -q "{{.*}}" "$TEST_DIR/.claude/output-styles/apm-orchestrator.md"; then
    echo "❌ Unprocessed template variables found in apm-orchestrator.md:"
    grep "{{.*}}" "$TEST_DIR/.claude/output-styles/apm-orchestrator.md"
    exit 1
fi

echo "✅ No unprocessed template variables in output-styles"

# Test 3: Settings.json verification
echo "🧪 Test 3: Settings.json Configuration"

if [ ! -f "$TEST_DIR/.claude/settings.json" ]; then
    echo "❌ settings.json not created"
    exit 1
fi

# Check that no template variables remain in settings.json
if grep -q "{{.*}}" "$TEST_DIR/.claude/settings.json"; then
    echo "❌ Unprocessed template variables found in settings.json:"
    grep "{{.*}}" "$TEST_DIR/.claude/settings.json"
    exit 1
fi

echo "✅ settings.json properly processed"

# Test 4: JSON validity
echo "🧪 Test 4: JSON Structure Validation"

if ! python3 -m json.tool "$TEST_DIR/.claude/settings.json" > /dev/null 2>&1; then
    echo "❌ Generated settings.json is not valid JSON"
    exit 1
fi

echo "✅ settings.json is valid JSON"

# Test 5: Output style configuration
echo "🧪 Test 5: Output Style Configuration"

if ! grep -q '"default": "APM Orchestrator"' "$TEST_DIR/.claude/settings.json"; then
    echo "❌ APM Orchestrator not set as default output style"
    exit 1
fi

if ! grep -q '"APM Orchestrator"' "$TEST_DIR/.claude/settings.json"; then
    echo "❌ APM Orchestrator not in available styles"
    exit 1
fi

echo "✅ Output style configuration verified"

# Test 6: Path substitution verification
echo "🧪 Test 6: Path Substitution Verification"

# Check that paths in output-styles are absolute and contain the test directory
if ! grep -q "$TEST_DIR" "$TEST_DIR/.claude/output-styles/apm-orchestrator.md"; then
    echo "❌ PROJECT_ROOT not properly substituted in output-styles"
    exit 1
fi

# Check that settings.json has the right PROJECT_ROOT
if ! grep -q "\"PROJECT_ROOT\": \"$TEST_DIR\"" "$TEST_DIR/.claude/settings.json"; then
    echo "❌ PROJECT_ROOT not properly substituted in settings.json"
    exit 1
fi

echo "✅ Path substitutions verified"

# Test 7: Content structure verification
echo "🧪 Test 7: Content Structure Verification"

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

# Test 8: Environment variable configuration
echo "🧪 Test 8: Environment Variable Configuration"

# Check key environment variables in settings.json
required_env_vars=(
    "APM_ROOT"
    "AP_ROOT"
    "PROJECT_ROOT"
    "PROJECT_DOCS"
    "CLAUDE_COMMANDS_DIR"
)

for var in "${required_env_vars[@]}"; do
    if ! grep -q "\"$var\":" "$TEST_DIR/.claude/settings.json"; then
        echo "❌ Missing environment variable: $var"
        exit 1
    fi
done

echo "✅ Environment variables properly configured"

# Display sample output
echo ""
echo "📊 Generated File Samples:"
echo "========================="
echo ""
echo "Output-styles file (first 10 lines):"
echo "-------------------------------------"
head -10 "$TEST_DIR/.claude/output-styles/apm-orchestrator.md"
echo ""
echo "Settings.json output_style section:"
echo "-----------------------------------"
grep -A 8 '"output_style"' "$TEST_DIR/.claude/settings.json"
echo ""
echo "Environment variables (sample):"
echo "-------------------------------"
grep -A 5 '"env"' "$TEST_DIR/.claude/settings.json" | head -10
echo ""

# Test 9: File sizes verification
echo "🧪 Test 9: File Size Verification"

output_size=$(stat -c%s "$TEST_DIR/.claude/output-styles/apm-orchestrator.md")
settings_size=$(stat -c%s "$TEST_DIR/.claude/settings.json")

if [ "$output_size" -lt 3000 ]; then
    echo "❌ Output-styles file too small ($output_size bytes) - may be incomplete"
    exit 1
fi

if [ "$settings_size" -lt 3000 ]; then
    echo "❌ Settings.json file too small ($settings_size bytes) - may be incomplete"
    exit 1
fi

echo "✅ File sizes verified (output-styles: ${output_size} bytes, settings.json: ${settings_size} bytes)"

# Summary
echo ""
echo "=========================================="
echo "🎯 VALIDATION SUMMARY"
echo "=========================================="
echo "✅ Output-styles directory and file verification"
echo "✅ Template variable substitution"
echo "✅ Settings.json properly processed"
echo "✅ JSON structure validation"
echo "✅ Output style configuration"
echo "✅ Path substitution verification"
echo "✅ Content structure verification"
echo "✅ Environment variable configuration"
echo "✅ File size verification"
echo ""
echo "🚀 ALL VALIDATIONS PASSED!"
echo ""
echo "Generated files verified:"
echo "- $TEST_DIR/.claude/output-styles/apm-orchestrator.md"
echo "- $TEST_DIR/.claude/settings.json"
echo ""
echo "🎯 APM Template Generation and Configuration Validation Complete!"