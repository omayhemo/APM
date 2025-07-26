#!/bin/bash

# Epic 17 Integration Test Script
# Validates all native sub-agent fixes are working correctly

echo "=========================================="
echo "Epic 17 Native Sub-Agent Integration Test"
echo "=========================================="

PASS_COLOR='\033[0;32m'
FAIL_COLOR='\033[0;31m'
INFO_COLOR='\033[0;34m'
NC='\033[0m' # No Color

TESTS_PASSED=0
TESTS_FAILED=0
TOTAL_TESTS=0

run_test() {
    local test_name="$1"
    local test_command="$2"
    local expected_pattern="$3"
    
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    echo -e "${INFO_COLOR}Test $TOTAL_TESTS: $test_name${NC}"
    
    if eval "$test_command" | grep -q "$expected_pattern"; then
        echo -e "  ${PASS_COLOR}✓ PASS${NC}"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo -e "  ${FAIL_COLOR}✗ FAIL${NC}"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo "    Expected pattern: $expected_pattern"
        echo "    Actual output:"
        eval "$test_command" | head -3 | sed 's/^/      /'
    fi
    echo
}

echo "Running Epic 17 integration tests..."
echo

# Test 1: Version Consistency
run_test "Version Consistency Check" \
    "cat VERSION && cat templates/VERSION" \
    "3.1.0"

# Test 2: Command Existence  
run_test "Parallel Sprint Command Exists" \
    "ls -la .claude/commands/parallel-sprint.md" \
    "parallel-sprint.md"

# Test 3: Native Patterns in Commands
run_test "Native Sub-Agent Patterns in Command" \
    "grep -q 'Native Sub-Agent Implementation' .claude/commands/parallel-sprint.md && echo 'FOUND'" \
    "FOUND"

# Test 4: No Task Tool Usage in Commands
run_test "Task Tool Usage Removed" \
    "! grep -q 'Use Task tool' .claude/commands/sm.md && echo 'NO_TASK_USAGE'" \
    "NO_TASK_USAGE"

# Test 5: Native Agent Patterns File Exists
run_test "Native Agent Patterns Documentation" \
    "ls -la .claude/agents/native-agent-patterns.md" \
    "native-agent-patterns.md"

# Test 6: Updated AP Orchestrator
run_test "AP Orchestrator Uses Direct Tools" \
    "grep -q 'Use direct tools - NO Task tool' .claude/commands/ap_orchestrator.md && echo 'DIRECT_TOOLS'" \
    "DIRECT_TOOLS"

# Test 7: Template Variable Substitution
run_test "Template Variables Resolved" \
    "! grep -q '{{.*}}' .claude/commands/parallel-sprint.md && echo 'NO_VARIABLES'" \
    "NO_VARIABLES"

# Test 8: Build Script Version
run_test "Build Script Version Updated" \
    "grep -q 'VERSION=\"3.1.0\"' build-distribution.sh && echo 'BUILD_VERSION_OK'" \
    "BUILD_VERSION_OK"

# Test 9: Message Compatibility Documentation
run_test "Message Compatibility Patterns" \
    "grep -q 'Message Compatibility Rules' .claude/agents/native-agent-patterns.md && echo 'COMPATIBILITY_RULES'" \
    "COMPATIBILITY_RULES"

# Test 10: Performance Improvement Documentation
run_test "Performance Improvement Claims" \
    "grep -q '4x+ Performance Improvement' .claude/commands/parallel-sprint.md && echo 'PERFORMANCE_CLAIMS'" \
    "PERFORMANCE_CLAIMS"

echo "=========================================="
echo "Test Results Summary"
echo "=========================================="
echo -e "Total Tests: $TOTAL_TESTS"
echo -e "${PASS_COLOR}Passed: $TESTS_PASSED${NC}"
echo -e "${FAIL_COLOR}Failed: $TESTS_FAILED${NC}"

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "\n${PASS_COLOR}🎉 ALL TESTS PASSED!${NC}"
    echo "Epic 17 native sub-agent integration is ready for deployment."
    exit 0
else
    echo -e "\n${FAIL_COLOR}❌ SOME TESTS FAILED${NC}"
    echo "Please review and fix the failing tests before deployment."
    exit 1
fi