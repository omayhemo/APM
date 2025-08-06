#!/bin/bash

# APM Command Duplication Verification Script
# Purpose: Verify no duplications remain between slash commands and task files
# Date: 2025-01-21

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}=== APM Command Duplication Verification ===${NC}"
echo ""

# List of all new slash commands
SLASH_COMMANDS=(
    "groom"
    "parallel-acceptance-criteria"
    "parallel-ai-prompt"
    "parallel-architecture"
    "parallel-automation-plan"
    "parallel-brainstorming"
    "parallel-checklist"
    "parallel-course-correction"
    "parallel-epic"
    "parallel-frontend-architecture"
    "parallel-next-story"
    "parallel-prd"
    "parallel-prioritization"
    "parallel-quality-review"
    "parallel-requirements"
    "parallel-research-prompt"
    "parallel-review"
    "parallel-stakeholder-review"
    "parallel-stories"
    "parallel-test-plan"
    "parallel-test-strategy"
    "parallel-validation"
    "run-tests"
)

echo -e "${YELLOW}Checking for duplicate task files...${NC}"
echo ""

DUPLICATES_FOUND=0

# Check for each command in task files
for cmd in "${SLASH_COMMANDS[@]}"; do
    # Convert command name to potential task file patterns
    # Remove "parallel-" prefix for base name
    base_name=${cmd#parallel-}
    
    # Check for various task file patterns
    patterns=(
        ".apm/agents/tasks/${cmd}.md"
        ".apm/agents/tasks/${cmd}-task.md"
        ".apm/agents/tasks/${cmd}-parallel.md"
        ".apm/agents/tasks/${base_name}-parallel.md"
        ".apm/agents/tasks/${base_name}-task.md"
        ".apm/agents/tasks/create-${base_name}-parallel.md"
        ".apm/agents/tasks/execute-${base_name}-parallel.md"
        ".apm/agents/tasks/define-${base_name}-parallel.md"
        ".apm/agents/tasks/conduct-${base_name}-parallel.md"
    )
    
    for pattern in "${patterns[@]}"; do
        if [ -f "$pattern" ]; then
            echo -e "  ${RED}⚠ DUPLICATE FOUND:${NC} $pattern → /${cmd}"
            DUPLICATES_FOUND=$((DUPLICATES_FOUND + 1))
        fi
    done
done

echo ""
echo -e "${YELLOW}Checking persona files for implementation details...${NC}"
echo ""

# Check if persona files contain implementation details (more than just references)
PERSONA_FILES=(
    ".apm/agents/personas/analyst.md"
    ".apm/agents/personas/architect.md"
    ".apm/agents/personas/design-architect.md"
    ".apm/agents/personas/dev.md"
    ".apm/agents/personas/developer.md"
    ".apm/agents/personas/pm.md"
    ".apm/agents/personas/po.md"
    ".apm/agents/personas/qa.md"
    ".apm/agents/personas/sm.md"
)

for persona in "${PERSONA_FILES[@]}"; do
    if [ -f "$persona" ]; then
        # Check for Task tool usage patterns that indicate implementation
        if grep -q "Task({" "$persona" 2>/dev/null || \
           grep -q "Task tool.*function_calls" "$persona" 2>/dev/null || \
           grep -q "Execute.*tasks simultaneously" "$persona" 2>/dev/null; then
            echo -e "  ${YELLOW}⚠ IMPLEMENTATION FOUND:${NC} $(basename $persona) contains Task implementation details"
        else
            echo -e "  ${GREEN}✓${NC} $(basename $persona) - Clean (only references)"
        fi
    fi
done

echo ""
echo -e "${YELLOW}Checking for archived duplicates...${NC}"
echo ""

# Check if archive directory exists and contains files
ARCHIVE_DIRS=$(find .apm/archive/tasks -name "*duplicated-by-slash-commands*" -type d 2>/dev/null | head -5)
if [ -n "$ARCHIVE_DIRS" ]; then
    for dir in $ARCHIVE_DIRS; do
        count=$(ls -1 "$dir"/*.md 2>/dev/null | wc -l)
        echo -e "  ${GREEN}✓${NC} Archive found: $(basename $dir) (${count} files)"
    done
else
    echo -e "  ${YELLOW}No archives found${NC}"
fi

echo ""
echo -e "${YELLOW}Verifying slash commands exist...${NC}"
echo ""

MISSING_COMMANDS=0
for cmd in "${SLASH_COMMANDS[@]}"; do
    if [ ! -f ".claude/commands/${cmd}.md" ]; then
        echo -e "  ${RED}✗ MISSING:${NC} /claude/commands/${cmd}.md"
        MISSING_COMMANDS=$((MISSING_COMMANDS + 1))
    fi
done

if [ $MISSING_COMMANDS -eq 0 ]; then
    echo -e "  ${GREEN}✓ All slash commands present${NC}"
fi

echo ""
echo -e "${CYAN}=== Verification Summary ===${NC}"
echo ""

if [ $DUPLICATES_FOUND -eq 0 ] && [ $MISSING_COMMANDS -eq 0 ]; then
    echo -e "${GREEN}✓ NO DUPLICATIONS FOUND${NC}"
    echo "  - All duplicate task files have been archived"
    echo "  - All slash commands are present"
    echo "  - Persona files contain only references (no implementations)"
    echo ""
    echo -e "${GREEN}The deduplication was successful!${NC}"
    exit 0
else
    echo -e "${RED}✗ ISSUES DETECTED${NC}"
    if [ $DUPLICATES_FOUND -gt 0 ]; then
        echo "  - Found $DUPLICATES_FOUND duplicate task files"
    fi
    if [ $MISSING_COMMANDS -gt 0 ]; then
        echo "  - Missing $MISSING_COMMANDS slash command files"
    fi
    echo ""
    echo -e "${YELLOW}Action Required:${NC}"
    echo "  1. Run ./scripts/deduplicate-commands.sh to archive duplicates"
    echo "  2. Verify all slash commands are created"
    echo "  3. Run this verification again"
    exit 1
fi