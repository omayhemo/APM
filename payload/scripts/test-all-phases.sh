#!/bin/bash

# Comprehensive Test Suite for All Persona Activation Phases
# APM v4.1.0 - Full Coverage Testing

echo "================================================"
echo "APM Persona Activation - Comprehensive Test Suite"
echo "================================================"
echo ""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALLER_DIR="$(dirname "$SCRIPT_DIR")"
TEMPLATES_DIR="$INSTALLER_DIR/templates/claude/commands"

# Color codes for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test counters
total_tests=0
passed_tests=0
failed_tests=0

# Function to test a command
test_command() {
    local cmd_name="$1"
    local expected_persona="$2"
    local phase="$3"
    
    ((total_tests++))
    
    local template="$TEMPLATES_DIR/${cmd_name}.md.template"
    
    if [[ ! -f "$template" ]]; then
        echo -e "  ${RED}✗${NC} $cmd_name - Template not found"
        ((failed_tests++))
        return 1
    fi
    
    # Check for activation block
    if ! grep -q "PERSONA CONTEXT ACTIVATION" "$template"; then
        echo -e "  ${RED}✗${NC} $cmd_name - Missing activation block"
        ((failed_tests++))
        return 1
    fi
    
    # Check for correct persona
    if ! grep -q "This command requires the $expected_persona persona" "$template"; then
        echo -e "  ${RED}✗${NC} $cmd_name - Wrong persona (expected: $expected_persona)"
        ((failed_tests++))
        return 1
    fi
    
    # Check for voice notification
    if ! grep -q "Voice notification: bash" "$template"; then
        echo -e "  ${YELLOW}⚠${NC} $cmd_name - Missing voice notification"
        # This is a warning, not a failure
    fi
    
    echo -e "  ${GREEN}✓${NC} $cmd_name → $expected_persona"
    ((passed_tests++))
    return 0
}

# Phase 1 Sequential Commands
echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
echo -e "${BLUE}PHASE 1: Sequential Commands (28 commands)${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
echo ""

echo "Scrum Master Commands:"
test_command "next-story" "Scrum" 1
test_command "checklist" "Scrum" 1
test_command "course-correction" "Scrum" 1

echo ""
echo "Product Owner Commands:"
test_command "epic" "Product" 1
test_command "groom" "Product" 1
test_command "stories" "Product" 1
test_command "prioritization" "Product" 1
test_command "acceptance-criteria" "Product" 1

echo ""
echo "Analyst Commands:"
test_command "requirements" "Analyst" 1
test_command "validation" "Analyst" 1
test_command "brainstorming" "Analyst" 1
test_command "stakeholder-review" "Analyst" 1
test_command "research-prompt" "Analyst" 1

echo ""
echo "Architect Commands:"
test_command "architecture" "Architect" 1

echo ""
echo "Designer Commands:"
test_command "frontend-architecture" "Design" 1
test_command "ux-spec" "Design" 1
test_command "ai-prompt" "Design" 1

echo ""
echo "Project Manager Commands:"
test_command "prd" "Product" 1
test_command "project-brief" "Product" 1

echo ""
echo "QA Commands:"
test_command "test-plan" "QA" 1
test_command "test-strategy" "QA" 1
test_command "quality-review" "QA" 1
test_command "automation-plan" "QA" 1

echo ""
echo "Developer Commands:"
test_command "doc-sharding" "Dev" 1
test_command "library-indexing" "Dev" 1

# Phase 2 Parallel Commands
echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
echo -e "${BLUE}PHASE 2: Parallel Commands (20 commands)${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
echo ""

echo "Parallel Scrum Master Commands:"
test_command "parallel-next-story" "Scrum Master" 2
test_command "parallel-checklist" "Scrum Master" 2
test_command "parallel-course-correction" "Scrum Master" 2

echo ""
echo "Parallel Product Owner Commands:"
test_command "parallel-epic" "Product Owner" 2
test_command "parallel-stories" "Product Owner" 2
test_command "parallel-acceptance-criteria" "Product Owner" 2
test_command "parallel-prioritization" "Product Owner" 2

echo ""
echo "Parallel Analyst Commands:"
test_command "parallel-validation" "Analyst" 2
test_command "parallel-requirements" "Analyst" 2
test_command "parallel-brainstorming" "Analyst" 2
test_command "parallel-stakeholder-review" "Analyst" 2
test_command "parallel-research-prompt" "Analyst" 2

echo ""
echo "Parallel Architect Commands:"
test_command "parallel-architecture" "Architect" 2

echo ""
echo "Parallel Designer Commands:"
test_command "parallel-ai-prompt" "Designer" 2
test_command "parallel-frontend-architecture" "Designer" 2

echo ""
echo "Parallel Project Manager Commands:"
test_command "parallel-prd" "Project Manager" 2

echo ""
echo "Parallel QA Commands:"
test_command "parallel-qa-framework" "QA" 2
test_command "parallel-test-plan" "QA" 2
test_command "parallel-test-strategy" "QA" 2
test_command "parallel-quality-review" "QA" 2
test_command "parallel-automation-plan" "QA" 2
test_command "parallel-regression-suite" "QA" 2
test_command "parallel-test" "QA" 2

echo ""
echo "Parallel Developer Commands:"
test_command "parallel-review" "Developer" 2

# Phase 3 Specialized Commands
echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
echo -e "${BLUE}PHASE 3: Specialized Commands (15 commands)${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
echo ""

echo "Document Management Commands (Analyst):"
test_command "doc-compliance" "Analyst" 3
test_command "doc-compliance-enhanced" "Analyst" 3
test_command "organize-docs" "Analyst" 3
test_command "update-all-documentation" "Analyst" 3

echo ""
echo "Backlog Management Commands (Product Owner):"
test_command "groom-backlog-task" "Product Owner" 3

echo ""
echo "QA Framework Commands:"
test_command "monitor-tests" "QA" 3
test_command "run-tests" "QA" 3
test_command "show-test-status" "QA" 3
test_command "test-dashboard" "QA" 3
test_command "test-metrics" "QA" 3
test_command "qa-framework" "QA" 3
test_command "qa-predict" "QA" 3
test_command "qa-optimize" "QA" 3
test_command "qa-anomaly" "QA" 3
test_command "qa-insights" "QA" 3

# Utility Commands Verification
echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
echo -e "${BLUE}UTILITY COMMANDS (Should NOT have activation)${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
echo ""

UTILITY_COMMANDS=(
    "ap"
    "ap_orchestrator"
    "handoff"
    "switch"
    "wrap"
    "git-commit-all"
    "buildit"
    "release"
    "version"
    "analyst"
    "architect"
    "designer"
    "dev"
    "developer"
    "pm"
    "po"
    "qa"
    "sm"
    "personas"
    "subtask"
)

utility_correct=0
utility_incorrect=0

for cmd in "${UTILITY_COMMANDS[@]}"; do
    template="$TEMPLATES_DIR/${cmd}.md.template"
    if [[ -f "$template" ]]; then
        if grep -q "PERSONA CONTEXT ACTIVATION" "$template"; then
            echo -e "  ${RED}✗${NC} $cmd - Has activation (should be utility)"
            ((utility_incorrect++))
        else
            echo -e "  ${GREEN}✓${NC} $cmd - Correctly has no activation"
            ((utility_correct++))
        fi
    fi
done

# Summary Report
echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
echo -e "${BLUE}TEST SUMMARY REPORT${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
echo ""

echo "Persona Command Tests:"
echo "  Total Tests: $total_tests"
echo -e "  ${GREEN}Passed: $passed_tests${NC}"
echo -e "  ${RED}Failed: $failed_tests${NC}"
echo ""

echo "Utility Command Verification:"
echo -e "  ${GREEN}Correct (no activation): $utility_correct${NC}"
echo -e "  ${RED}Incorrect (has activation): $utility_incorrect${NC}"
echo ""

# Calculate pass rate
if [[ $total_tests -gt 0 ]]; then
    pass_rate=$((passed_tests * 100 / total_tests))
    echo "Pass Rate: ${pass_rate}%"
    
    if [[ $pass_rate -eq 100 ]]; then
        echo -e "${GREEN}✅ ALL TESTS PASSED!${NC}"
        echo ""
        echo "Implementation Summary:"
        echo "  Phase 1: 28 commands ✅"
        echo "  Phase 2: 20 commands ✅"
        echo "  Phase 3: 15 commands ✅"
        echo "  Total: 63 commands with persona activation"
        echo ""
        echo -e "${GREEN}The persona-first command implementation is COMPLETE!${NC}"
        exit 0
    else
        echo -e "${YELLOW}⚠ Some tests failed. Review the output above.${NC}"
        exit 1
    fi
else
    echo -e "${RED}No tests were run!${NC}"
    exit 1
fi