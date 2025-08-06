#!/bin/bash

# APM Installer Template Deduplication Script
# Purpose: Clean duplicate task templates that are now replaced by native slash commands
# Date: 2025-01-21

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}=== APM Installer Template Deduplication Script ===${NC}"
echo "This script will safely archive duplicate task templates that are now replaced by native slash commands"
echo ""

# Create backup directory with timestamp
BACKUP_DIR="installer/archive/templates-duplicated-by-slash-commands-$(date +%Y%m%d-%H%M%S)"
echo -e "${YELLOW}Creating backup directory: $BACKUP_DIR${NC}"
mkdir -p "$BACKUP_DIR"

# Template source directory
TEMPLATE_DIR="installer/templates/agents/tasks"

# List of parallel task template files to archive
PARALLEL_TEMPLATES=(
    "brainstorming-parallel.md.template"
    "checklist-run-parallel.md.template"
    "conduct-stakeholder-review-parallel.md.template"
    "correct-course-parallel.md.template"
    "create-ai-frontend-prompt-parallel.md.template"
    "create-architecture-parallel.md.template"
    "create-automation-plan-parallel.md.template"
    "create-deep-research-prompt-parallel.md.template"
    "create-epic-parallel.md.template"
    "create-frontend-architecture-parallel.md.template"
    "create-next-story-parallel.md.template"
    "create-prd-parallel.md.template"
    "create-requirements-parallel.md.template"
    "create-test-plan-parallel.md.template"
    "create-test-strategy-parallel.md.template"
    "create-user-stories-parallel.md.template"
    "define-acceptance-criteria-parallel.md.template"
    "doc-sharding-parallel.md.template"
    "execute-quality-review-parallel.md.template"
    "library-indexing-parallel.md.template"
    "prioritize-backlog-parallel.md.template"
    "validate-requirements-parallel.md.template"
)

# Additional duplicate templates
OTHER_DUPLICATE_TEMPLATES=(
    "groom-backlog-task.md.template"
)

# Archive parallel task template files
echo -e "${YELLOW}Archiving parallel task template files...${NC}"
ARCHIVED_COUNT=0
for file in "${PARALLEL_TEMPLATES[@]}"; do
    if [ -f "$TEMPLATE_DIR/$file" ]; then
        echo "  Moving: $file"
        mv "$TEMPLATE_DIR/$file" "$BACKUP_DIR/"
        ARCHIVED_COUNT=$((ARCHIVED_COUNT + 1))
        
        # Also move .backup versions if they exist
        if [ -f "$TEMPLATE_DIR/${file}.backup" ]; then
            echo "  Moving: ${file}.backup"
            mv "$TEMPLATE_DIR/${file}.backup" "$BACKUP_DIR/"
        fi
    else
        echo -e "  ${RED}Not found:${NC} $file"
    fi
done

# Archive other duplicate templates
echo -e "${YELLOW}Archiving other duplicate templates...${NC}"
for file in "${OTHER_DUPLICATE_TEMPLATES[@]}"; do
    if [ -f "$TEMPLATE_DIR/$file" ]; then
        echo "  Moving: $file"
        mv "$TEMPLATE_DIR/$file" "$BACKUP_DIR/"
        ARCHIVED_COUNT=$((ARCHIVED_COUNT + 1))
        
        # Also move .backup versions if they exist
        if [ -f "$TEMPLATE_DIR/${file}.backup" ]; then
            echo "  Moving: ${file}.backup"
            mv "$TEMPLATE_DIR/${file}.backup" "$BACKUP_DIR/"
        fi
    else
        echo -e "  ${RED}Not found:${NC} $file"
    fi
done

# Create a README in the archive directory
cat > "$BACKUP_DIR/README.md" << EOF
# Archived Template Files

**Archive Date:** $(date +"%Y-%m-%d %H:%M:%S")
**Reason:** These template files have been replaced by native Claude Code slash commands

## Why These Templates Were Archived

These template files duplicated functionality that is now implemented as native Claude Code slash commands. The slash commands provide:

1. **Better Performance**: Native Claude Code parallelism vs Task-based simulation
2. **Single Source of Truth**: Commands defined in one place
3. **Easier Maintenance**: Updates only needed in slash command files
4. **Consistent Implementation**: All commands follow the same pattern

## Impact on New Installations

- New APM installations will NOT receive these duplicate task files
- Users will get clean installations with only slash commands
- Prevents confusion between task files and slash commands
- Ensures optimal performance from day one

## Corresponding Slash Commands

| Archived Template File | Replacement Slash Command |
|----------------------|---------------------------|
| brainstorming-parallel.md.template | /parallel-brainstorming |
| checklist-run-parallel.md.template | /parallel-checklist |
| conduct-stakeholder-review-parallel.md.template | /parallel-stakeholder-review |
| correct-course-parallel.md.template | /parallel-course-correction |
| create-ai-frontend-prompt-parallel.md.template | /parallel-ai-prompt |
| create-architecture-parallel.md.template | /parallel-architecture |
| create-automation-plan-parallel.md.template | /parallel-automation-plan |
| create-deep-research-prompt-parallel.md.template | /parallel-research-prompt |
| create-epic-parallel.md.template | /parallel-epic |
| create-frontend-architecture-parallel.md.template | /parallel-frontend-architecture |
| create-next-story-parallel.md.template | /parallel-next-story |
| create-prd-parallel.md.template | /parallel-prd |
| create-requirements-parallel.md.template | /parallel-requirements |
| create-test-plan-parallel.md.template | /parallel-test-plan |
| create-test-strategy-parallel.md.template | /parallel-test-strategy |
| create-user-stories-parallel.md.template | /parallel-stories |
| define-acceptance-criteria-parallel.md.template | /parallel-acceptance-criteria |
| execute-quality-review-parallel.md.template | /parallel-quality-review |
| prioritize-backlog-parallel.md.template | /parallel-prioritization |
| validate-requirements-parallel.md.template | /parallel-validation |
| groom-backlog-task.md.template | /groom |

## Template Recovery

If these templates need to be restored (NOT recommended):
1. Copy them back to \`installer/templates/agents/tasks/\`
2. Ensure installer scripts expect them
3. Note: New installations will have duplicates and degraded performance

## Verification

Run verification script to confirm cleanup:
\`\`\`bash
./scripts/verify-installer-templates.sh
\`\`\`
EOF

echo ""
echo -e "${GREEN}=== Archive Summary ===${NC}"
echo "Archived $ARCHIVED_COUNT template files"
echo "Archive location: $BACKUP_DIR"
echo ""

# Count remaining template files
REMAINING=$(find "$TEMPLATE_DIR" -name "*.template" -type f | wc -l)
echo -e "${GREEN}Remaining template files:${NC} $REMAINING"

# Check for non-parallel base templates that might also be duplicates
echo ""
echo -e "${YELLOW}Checking for base template duplicates...${NC}"
BASE_DUPLICATES=(
    "brainstorming.md.template"
    "checklist-run-task.md.template"
    "conduct-stakeholder-review-task.md.template"
    "correct-course.md.template"
    "create-ai-frontend-prompt.md.template"
    "create-architecture.md.template"
    "create-automation-plan.md.template"
    "create-deep-research-prompt.md.template"
    "create-epic-task.md.template"
    "create-frontend-architecture.md.template"
    "create-next-story-task.md.template"
    "create-prd.md.template"
    "create-requirements-task.md.template"
    "create-test-plan.md.template"
    "create-test-strategy.md.template"
    "create-user-stories-task.md.template"
    "define-acceptance-criteria-task.md.template"
    "execute-quality-review.md.template"
    "prioritize-backlog-task.md.template"
    "validate-requirements.md.template"
)

BASE_FOUND=0
for file in "${BASE_DUPLICATES[@]}"; do
    if [ -f "$TEMPLATE_DIR/$file" ]; then
        echo -e "  ${YELLOW}Base duplicate found:${NC} $file"
        BASE_FOUND=$((BASE_FOUND + 1))
    fi
done

if [ $BASE_FOUND -gt 0 ]; then
    echo ""
    echo -e "${YELLOW}Found $BASE_FOUND base template duplicates.${NC}"
    echo "These are non-parallel versions that may also be duplicates of slash commands."
    echo "Run with --include-base to archive these as well."
else
    echo -e "${GREEN}No base template duplicates found.${NC}"
fi

echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo "1. Run verification script: ./scripts/verify-installer-templates.sh"
echo "2. Test fresh APM installation to ensure it works"
echo "3. Update installer documentation if needed"
echo "4. Consider archiving base templates if they're also duplicates"
echo ""
echo -e "${GREEN}Template deduplication complete!${NC}"