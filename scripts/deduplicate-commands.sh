#!/bin/bash

# APM Command Deduplication Script
# Purpose: Safely archive duplicate task files that are now replaced by native slash commands
# Date: 2025-01-21

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== APM Command Deduplication Script ===${NC}"
echo "This script will safely archive duplicate task files that are now replaced by native slash commands"
echo ""

# Create backup directory with timestamp
BACKUP_DIR=".apm/archive/tasks/duplicated-by-slash-commands-$(date +%Y%m%d-%H%M%S)"
echo -e "${YELLOW}Creating backup directory: $BACKUP_DIR${NC}"
mkdir -p "$BACKUP_DIR"

# List of parallel task files to archive
PARALLEL_FILES=(
    "brainstorming-parallel.md"
    "checklist-run-parallel.md"
    "conduct-stakeholder-review-parallel.md"
    "correct-course-parallel.md"
    "create-ai-frontend-prompt-parallel.md"
    "create-architecture-parallel.md"
    "create-automation-plan-parallel.md"
    "create-deep-research-prompt-parallel.md"
    "create-epic-parallel.md"
    "create-frontend-architecture-parallel.md"
    "create-next-story-parallel.md"
    "create-prd-parallel.md"
    "create-requirements-parallel.md"
    "create-test-plan-parallel.md"
    "create-test-strategy-parallel.md"
    "create-user-stories-parallel.md"
    "define-acceptance-criteria-parallel.md"
    "doc-sharding-parallel.md"
    "execute-quality-review-parallel.md"
    "library-indexing-parallel.md"
    "prioritize-backlog-parallel.md"
    "validate-requirements-parallel.md"
)

# Additional task files that are duplicated
OTHER_DUPLICATES=(
    "groom-backlog-task.md"
)

# Archive parallel task files
echo -e "${YELLOW}Archiving parallel task files...${NC}"
for file in "${PARALLEL_FILES[@]}"; do
    if [ -f ".apm/agents/tasks/$file" ]; then
        echo "  Moving: $file"
        mv ".apm/agents/tasks/$file" "$BACKUP_DIR/"
    else
        echo -e "  ${RED}Not found:${NC} $file"
    fi
done

# Archive other duplicate task files
echo -e "${YELLOW}Archiving other duplicate task files...${NC}"
for file in "${OTHER_DUPLICATES[@]}"; do
    if [ -f ".apm/agents/tasks/$file" ]; then
        echo "  Moving: $file"
        mv ".apm/agents/tasks/$file" "$BACKUP_DIR/"
    else
        echo -e "  ${RED}Not found:${NC} $file"
    fi
done

# Create a README in the archive directory
cat > "$BACKUP_DIR/README.md" << 'EOF'
# Archived Task Files

**Archive Date:** $(date +"%Y-%m-%d %H:%M:%S")
**Reason:** These task files have been replaced by native Claude Code slash commands

## Why These Files Were Archived

These task files duplicated functionality that is now implemented as native Claude Code slash commands. The slash commands provide:

1. **Better Performance**: Native Claude Code parallelism vs Task-based simulation
2. **Single Source of Truth**: Commands defined in one place
3. **Easier Maintenance**: Updates only needed in slash command files
4. **Consistent Implementation**: All commands follow the same pattern

## Corresponding Slash Commands

| Archived Task File | Replacement Slash Command |
|-------------------|---------------------------|
| brainstorming-parallel.md | /parallel-brainstorming |
| checklist-run-parallel.md | /parallel-checklist |
| conduct-stakeholder-review-parallel.md | /parallel-stakeholder-review |
| correct-course-parallel.md | /parallel-course-correction |
| create-ai-frontend-prompt-parallel.md | /parallel-ai-prompt |
| create-architecture-parallel.md | /parallel-architecture |
| create-automation-plan-parallel.md | /parallel-automation-plan |
| create-deep-research-prompt-parallel.md | /parallel-research-prompt |
| create-epic-parallel.md | /parallel-epic |
| create-frontend-architecture-parallel.md | /parallel-frontend-architecture |
| create-next-story-parallel.md | /parallel-next-story |
| create-prd-parallel.md | /parallel-prd |
| create-requirements-parallel.md | /parallel-requirements |
| create-test-plan-parallel.md | /parallel-test-plan |
| create-test-strategy-parallel.md | /parallel-test-strategy |
| create-user-stories-parallel.md | /parallel-stories |
| define-acceptance-criteria-parallel.md | /parallel-acceptance-criteria |
| execute-quality-review-parallel.md | /parallel-quality-review |
| prioritize-backlog-parallel.md | /parallel-prioritization |
| validate-requirements-parallel.md | /parallel-validation |
| groom-backlog-task.md | /groom |

## Recovery

If these files need to be restored:
1. Copy them back to `.apm/agents/tasks/`
2. Update persona files to reference task files instead of slash commands
3. Note: Performance will be degraded without native slash commands
EOF

echo ""
echo -e "${GREEN}=== Archive Summary ===${NC}"
echo "Archived $(ls -1 $BACKUP_DIR/*.md 2>/dev/null | wc -l) task files"
echo "Archive location: $BACKUP_DIR"
echo ""

# Count remaining task files
REMAINING=$(ls -1 .apm/agents/tasks/*.md 2>/dev/null | wc -l)
echo -e "${GREEN}Remaining task files:${NC} $REMAINING"

# Optional: Update persona files to clarify slash command usage
echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo "1. Test all agents to ensure they still function correctly"
echo "2. Update persona files to clearly reference slash commands"
echo "3. Verify installer templates are up to date"
echo "4. Run agent test suite to validate changes"
echo ""
echo -e "${GREEN}Deduplication complete!${NC}"