#!/bin/bash

# Test script for persona activation validation
# APM v4.1.0 - Phase 1 Testing

echo "================================================"
echo "Persona Activation Testing Script"
echo "================================================"
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALLER_DIR="$(dirname "$SCRIPT_DIR")"
TEMPLATES_DIR="$INSTALLER_DIR/templates/claude/commands"

# Test function
test_activation() {
    local template="$1"
    local expected_persona="$2"
    
    echo "Testing: $(basename "$template")"
    
    # Check if activation block exists
    if grep -q "PERSONA CONTEXT ACTIVATION" "$template"; then
        echo -e "  ${GREEN}✓${NC} Activation block found"
        
        # Check for correct persona
        if grep -q "This command requires the $expected_persona persona" "$template"; then
            echo -e "  ${GREEN}✓${NC} Correct persona: $expected_persona"
        else
            echo -e "  ${RED}✗${NC} Wrong persona or not found"
            return 1
        fi
        
        # Check for voice notification
        if grep -q "Voice notification: bash" "$template"; then
            echo -e "  ${GREEN}✓${NC} Voice notification present"
        else
            echo -e "  ${YELLOW}⚠${NC} Voice notification missing"
        fi
        
        # Check for workspace validation
        if grep -q "Workspace validation: Ensuring execution from" "$template"; then
            echo -e "  ${GREEN}✓${NC} Workspace validation present"
        else
            echo -e "  ${YELLOW}⚠${NC} Workspace validation missing"
        fi
        
        return 0
    else
        echo -e "  ${RED}✗${NC} No activation block found"
        return 1
    fi
}

# High-priority commands to test (Phase 1)
echo "Phase 1: High-Priority Commands"
echo "--------------------------------"
echo ""

# Test each Phase 1 command
declare -A test_commands=(
    ["next-story.md.template"]="Scrum"
    ["epic.md.template"]="Product"
    ["groom.md.template"]="Product"
    ["test-plan.md.template"]="QA"
    ["requirements.md.template"]="Analyst"
    ["architecture.md.template"]="Architect"
    ["frontend-architecture.md.template"]="Design"
    ["prd.md.template"]="Product"
)

passed=0
failed=0

for template in "${!test_commands[@]}"; do
    persona="${test_commands[$template]}"
    template_path="$TEMPLATES_DIR/$template"
    
    if [[ -f "$template_path" ]]; then
        if test_activation "$template_path" "$persona"; then
            ((passed++))
        else
            ((failed++))
        fi
    else
        echo "Template not found: $template"
        ((failed++))
    fi
    echo ""
done

echo "================================================"
echo "Test Summary:"
echo "  Passed: $passed"
echo "  Failed: $failed"
echo "================================================"

if [[ $failed -eq 0 ]]; then
    echo -e "${GREEN}✓ All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}✗ Some tests failed${NC}"
    exit 1
fi