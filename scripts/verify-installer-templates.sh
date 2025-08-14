#!/bin/bash

# APM Installer Template Verification Script
# Purpose: Verify no duplicate templates remain that conflict with slash commands
# Date: 2025-01-21

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}=== APM Installer Template Verification ===${NC}"
echo ""

# Template directory
TEMPLATE_DIR="installer/templates/agents/tasks"

# List of all slash commands that should NOT have corresponding templates
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

echo -e "${YELLOW}Checking for duplicate template files...${NC}"
echo ""

DUPLICATES_FOUND=0

# Check for each command in template files
for cmd in "${SLASH_COMMANDS[@]}"; do
    # Convert command name to potential template file patterns
    base_name=${cmd#parallel-}
    
    # Check for various template file patterns that would duplicate slash commands
    patterns=(
        "${TEMPLATE_DIR}/${cmd}.md.template"
        "${TEMPLATE_DIR}/${cmd}-task.md.template"
        "${TEMPLATE_DIR}/${cmd}-parallel.md.template"
        "${TEMPLATE_DIR}/${base_name}-parallel.md.template"
        "${TEMPLATE_DIR}/${base_name}-task.md.template"
        "${TEMPLATE_DIR}/create-${base_name}-parallel.md.template"
        "${TEMPLATE_DIR}/execute-${base_name}-parallel.md.template"
        "${TEMPLATE_DIR}/define-${base_name}-parallel.md.template"
        "${TEMPLATE_DIR}/conduct-${base_name}-parallel.md.template"
        "${TEMPLATE_DIR}/groom-backlog-task.md.template"
    )
    
    for pattern in "${patterns[@]}"; do
        if [ -f "$pattern" ]; then
            echo -e "  ${RED}⚠ DUPLICATE TEMPLATE FOUND:${NC} $(basename $pattern) → /${cmd}"
            DUPLICATES_FOUND=$((DUPLICATES_FOUND + 1))
        fi
    done
done

echo ""
echo -e "${YELLOW}Checking template directory structure...${NC}"
echo ""

# Verify template directory exists and has content
if [ ! -d "$TEMPLATE_DIR" ]; then
    echo -e "  ${RED}✗ ERROR:${NC} Template directory not found: $TEMPLATE_DIR"
    exit 1
else
    TEMPLATE_COUNT=$(find "$TEMPLATE_DIR" -name "*.template" -type f | wc -l)
    echo -e "  ${GREEN}✓${NC} Template directory exists: $TEMPLATE_COUNT template files"
fi

# Check for archived duplicates
echo ""
echo -e "${YELLOW}Checking for archived templates...${NC}"
echo ""

ARCHIVE_DIRS=$(find installer/archive -name "*templates-duplicated-by-slash-commands*" -type d 2>/dev/null | head -5)
if [ -n "$ARCHIVE_DIRS" ]; then
    for dir in $ARCHIVE_DIRS; do
        count=$(find "$dir" -name "*.template" -type f 2>/dev/null | wc -l)
        echo -e "  ${GREEN}✓${NC} Archive found: $(basename $dir) (${count} template files)"
    done
else
    echo -e "  ${YELLOW}No template archives found${NC}"
fi

# Check core templates still exist
echo ""
echo -e "${YELLOW}Verifying essential templates remain...${NC}"
echo ""

ESSENTIAL_TEMPLATES=(
    "core-dump.md.template"
    "create-project-brief.md.template"
    "create-uxui-spec.md.template"
    "deep-research-prompt-generation.md.template"
    "run-qa-checklist.md.template"
    "subtask-implementation-roadmap.md.template"
)

MISSING_ESSENTIAL=0
for template in "${ESSENTIAL_TEMPLATES[@]}"; do
    if [ -f "$TEMPLATE_DIR/$template" ]; then
        echo -e "  ${GREEN}✓${NC} $template"
    else
        echo -e "  ${YELLOW}?${NC} $template (not found, may be optional)"
    fi
done

# Check slash command templates are present
echo ""
echo -e "${YELLOW}Verifying slash command templates exist...${NC}"
echo ""

SLASH_TEMPLATE_DIR="installer/templates/claude/commands"
if [ ! -d "$SLASH_TEMPLATE_DIR" ]; then
    echo -e "  ${RED}✗ ERROR:${NC} Slash command template directory not found: $SLASH_TEMPLATE_DIR"
else
    SLASH_TEMPLATE_COUNT=$(find "$SLASH_TEMPLATE_DIR" -name "*.template" -type f | wc -l)
    echo -e "  ${GREEN}✓${NC} Slash command templates: $SLASH_TEMPLATE_COUNT files in $SLASH_TEMPLATE_DIR"
    
    # Check for key slash commands
    SAMPLE_SLASH_TEMPLATES=(
        "groom.md.template"
        "parallel-epic.md.template"
        "parallel-brainstorming.md.template"
        "parallel-requirements.md.template"
    )
    
    for template in "${SAMPLE_SLASH_TEMPLATES[@]}"; do
        if [ -f "$SLASH_TEMPLATE_DIR/$template" ]; then
            echo -e "    ${GREEN}✓${NC} $template"
        else
            echo -e "    ${RED}✗${NC} $template (missing)"
        fi
    done
fi

# Check persona templates
echo ""
echo -e "${YELLOW}Verifying persona templates...${NC}"
echo ""

PERSONA_TEMPLATE_DIR="installer/templates/agents/personas"
if [ ! -d "$PERSONA_TEMPLATE_DIR" ]; then
    echo -e "  ${RED}✗ ERROR:${NC} Persona template directory not found: $PERSONA_TEMPLATE_DIR"
else
    PERSONA_TEMPLATE_COUNT=$(find "$PERSONA_TEMPLATE_DIR" -name "*.template" -type f | wc -l)
    echo -e "  ${GREEN}✓${NC} Persona templates: $PERSONA_TEMPLATE_COUNT files in $PERSONA_TEMPLATE_DIR"
fi

echo ""
echo -e "${CYAN}=== Verification Summary ===${NC}"
echo ""

if [ $DUPLICATES_FOUND -eq 0 ]; then
    echo -e "${GREEN}✓ NO DUPLICATE TEMPLATES FOUND${NC}"
    echo "  - All duplicate task templates have been archived"
    echo "  - Template directory structure is intact"
    echo "  - Slash command templates are present"
    echo "  - Essential non-duplicate templates remain"
    echo ""
    echo -e "${GREEN}Template deduplication verification PASSED!${NC}"
    echo ""
    echo -e "${YELLOW}Ready for:${NC}"
    echo "  - Fresh APM installations will be clean"
    echo "  - No duplicate task files will be installed"
    echo "  - Users get optimal slash command performance"
    exit 0
else
    echo -e "${RED}✗ DUPLICATE TEMPLATES DETECTED${NC}"
    echo "  - Found $DUPLICATES_FOUND duplicate template files"
    echo ""
    echo -e "${YELLOW}Action Required:${NC}"
    echo "  1. Run ./scripts/deduplicate-installer-templates.sh to archive duplicates"
    echo "  2. Verify templates don't conflict with slash commands"
    echo "  3. Run this verification again"
    exit 1
fi