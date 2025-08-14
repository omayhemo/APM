#!/bin/bash

# Test script to verify hooks are using correct field names
# Run this in a project where APM is installed to test the hooks

echo "Hook Field Name Test Script"
echo "==========================="
echo ""
echo "This script tests if the hooks are correctly handling Claude Code field names"
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if we're in an APM-installed project
if [ ! -d ".claude/hooks" ]; then
    echo -e "${RED}Error: .claude/hooks directory not found${NC}"
    echo "Please run this from a project where APM is installed"
    exit 1
fi

# Test 1: Check if pre_tool_use_location_enforcer.py exists
echo "Test 1: Checking if Document Location Enforcer is installed..."
if [ -f ".claude/hooks/pre_tool_use_location_enforcer.py" ]; then
    echo -e "${GREEN}✓ Document Location Enforcer found${NC}"
else
    echo -e "${RED}✗ Document Location Enforcer NOT found - stories will be created in wrong locations${NC}"
fi
echo ""

# Test 2: Check if document registry exists
echo "Test 2: Checking if document registry configuration exists..."
if [ -f ".apm/config/document-registry.json" ]; then
    echo -e "${GREEN}✓ Document registry found${NC}"
else
    echo -e "${YELLOW}⚠ Document registry not found - enforcer may not work properly${NC}"
fi
echo ""

# Test 3: Test pre_tool_use.py with Claude Code field names
echo "Test 3: Testing pre_tool_use.py with Claude Code field format..."
TEST_JSON='{
  "tool_name": "Write",
  "tool_input": {
    "file_path": "/tmp/test-story.md",
    "content": "# Test Story"
  }
}'

if [ -f ".claude/hooks/pre_tool_use.py" ]; then
    result=$(echo "$TEST_JSON" | python3 .claude/hooks/pre_tool_use.py 2>&1)
    
    # Check if it processed the tool correctly
    if echo "$result" | grep -q "Processing tool: Write"; then
        echo -e "${GREEN}✓ Hook correctly identified tool_name as 'Write'${NC}"
    else
        echo -e "${RED}✗ Hook failed to identify tool_name${NC}"
        echo "Output: $result"
    fi
    
    # Check if Document Location Enforcer ran
    if [ -f ".claude/hooks/logs/pre_tool_use.log" ]; then
        if tail -5 .claude/hooks/logs/pre_tool_use.log | grep -q "Running Document Location Enforcement"; then
            echo -e "${GREEN}✓ Document Location Enforcer activated${NC}"
        elif tail -5 .claude/hooks/logs/pre_tool_use.log | grep -q "Document Location Enforcer not installed"; then
            echo -e "${YELLOW}⚠ Document Location Enforcer not imported successfully${NC}"
        else
            echo -e "${YELLOW}⚠ Could not determine if enforcer ran${NC}"
        fi
    fi
else
    echo -e "${RED}✗ pre_tool_use.py not found${NC}"
fi
echo ""

# Test 4: Test with old field names (should still work for backward compatibility)
echo "Test 4: Testing backward compatibility with old field names..."
OLD_JSON='{
  "tool": "Write",
  "parameters": {
    "file_path": "/tmp/test-story.md",
    "content": "# Test Story"
  }
}'

if [ -f ".claude/hooks/pre_tool_use.py" ]; then
    result=$(echo "$OLD_JSON" | python3 .claude/hooks/pre_tool_use.py 2>&1)
    
    if echo "$result" | grep -q "Processing tool: Write"; then
        echo -e "${GREEN}✓ Hook maintains backward compatibility${NC}"
    else
        echo -e "${YELLOW}⚠ Hook may not be backward compatible${NC}"
    fi
else
    echo -e "${RED}✗ pre_tool_use.py not found${NC}"
fi
echo ""

# Test 5: Check log for recent errors
echo "Test 5: Checking for recent errors in hook logs..."
if [ -f ".claude/hooks/logs/pre_tool_use.log" ]; then
    errors=$(tail -50 .claude/hooks/logs/pre_tool_use.log | grep -c "ERROR")
    if [ "$errors" -eq 0 ]; then
        echo -e "${GREEN}✓ No recent errors in pre_tool_use.log${NC}"
    else
        echo -e "${YELLOW}⚠ Found $errors error(s) in recent logs${NC}"
        echo "Recent errors:"
        tail -50 .claude/hooks/logs/pre_tool_use.log | grep "ERROR" | tail -3
    fi
fi
echo ""

# Summary
echo "Summary"
echo "-------"
echo "Run this test after installing APM to verify hooks are working correctly."
echo "If Document Location Enforcer is not working, stories may be created in wrong locations."
echo ""
echo "To manually test the import, run:"
echo "  cd .claude/hooks && python3 -c 'from pre_tool_use_location_enforcer import DocumentLocationEnforcer; print(\"Import successful\")'"