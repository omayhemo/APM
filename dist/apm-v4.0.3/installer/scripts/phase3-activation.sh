#!/bin/bash

# Phase 3: Add persona activation to remaining specialized commands
# APM v4.0.0 - Final Coverage Implementation

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALLER_DIR="$(dirname "$SCRIPT_DIR")"
TEMPLATES_DIR="$INSTALLER_DIR/templates/claude/commands"

# Color codes for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "================================================"
echo "APM Phase 3: Final Command Activation v1.0"
echo "================================================"
echo ""

# Mapping of remaining commands to personas
declare -A PHASE3_PERSONA_MAP=(
    # Document Management Commands
    ["doc-compliance"]="Analyst"
    ["doc-compliance-enhanced"]="Analyst"
    ["organize-docs"]="Analyst"
    ["update-all-documentation"]="Analyst"
    
    # Backlog Management
    ["groom-backlog-task"]="Product Owner"
    
    # QA Framework Commands
    ["monitor-tests"]="QA"
    ["run-tests"]="QA"
    ["show-test-status"]="QA"
    ["test-dashboard"]="QA"
    ["test-metrics"]="QA"
    ["qa-framework"]="QA"
    ["qa-predict"]="QA"
    ["qa-optimize"]="QA"
    ["qa-anomaly"]="QA"
    ["qa-insights"]="QA"
)

# Map personas to SPEAK variables
declare -A SPEAK_VARS=(
    ["Analyst"]="SPEAK_ANALYST"
    ["Product Owner"]="SPEAK_PO"
    ["QA"]="SPEAK_QA"
)

# Function to add persona activation
add_activation() {
    local file="$1"
    local persona="$2"
    local speak_var="${SPEAK_VARS[$persona]}"
    local cmd_name=$(basename "$file" .md.template)
    
    if [[ -z "$speak_var" ]]; then
        echo -e "${YELLOW}Warning: No SPEAK variable for persona '$persona'${NC}"
        return 1
    fi
    
    # Determine command type for appropriate messaging
    local cmd_type="command execution"
    if [[ "$cmd_name" == *"doc"* ]] || [[ "$cmd_name" == *"documentation"* ]]; then
        cmd_type="documentation management"
    elif [[ "$cmd_name" == *"test"* ]] || [[ "$cmd_name" == *"qa"* ]]; then
        cmd_type="quality assurance"
    elif [[ "$cmd_name" == *"groom"* ]] || [[ "$cmd_name" == *"backlog"* ]]; then
        cmd_type="backlog management"
    fi
    
    # Create activation block
    local activation_block="
## 🎭 PERSONA CONTEXT ACTIVATION

**This command requires the $persona persona.**

\`\`\`markdown
*Loading $persona context for $cmd_type...*

Quick Context Load (1-2 seconds):
- Loading $persona configuration and expertise
- Loading relevant frameworks and methodologies
- Voice notification: bash \${{$speak_var}} \"$persona context loaded for $cmd_type\"
- Workspace validation: Ensuring execution from {{PROJECT_ROOT}}

*$persona context ready. Proceeding with command...*
\`\`\`
"
    
    # Create temp file
    local temp_file="${file}.tmp"
    
    # Check if file has frontmatter
    if head -1 "$file" | grep -q "^---$"; then
        # File has frontmatter, add after it
        awk -v activation="$activation_block" '
        BEGIN { metadata_count = 0; added = 0 }
        /^---$/ { 
            metadata_count++
            print
            if (metadata_count == 2 && !added) {
                print activation
                added = 1
            }
            next
        }
        { print }
        END {
            # If no closing metadata found, add at end
            if (metadata_count == 1 && !added) {
                print "---"
                print activation
            }
        }
        ' "$file" > "$temp_file"
    else
        # No frontmatter, add after first line (title)
        {
            head -1 "$file"
            echo "$activation_block"
            tail -n +2 "$file"
        } > "$temp_file"
    fi
    
    # Verify and replace
    if grep -q "PERSONA CONTEXT ACTIVATION" "$temp_file"; then
        mv "$temp_file" "$file"
        return 0
    else
        rm -f "$temp_file"
        return 1
    fi
}

# Main processing
echo "Processing Phase 3 commands..."
echo ""

processed=0
skipped=0
failed=0

# Sort commands by category for organized output
echo "📚 Document Management Commands (Analyst):"
echo "-------------------------------------------"
for cmd_name in "doc-compliance" "doc-compliance-enhanced" "organize-docs" "update-all-documentation"; do
    template="$TEMPLATES_DIR/${cmd_name}.md.template"
    
    if [[ ! -f "$template" ]]; then
        echo -e "${YELLOW}Template not found: $cmd_name${NC}"
        ((failed++))
        continue
    fi
    
    persona="${PHASE3_PERSONA_MAP[$cmd_name]}"
    echo -n "Processing: $cmd_name → $persona ... "
    
    # Check if already has activation
    if grep -q "PERSONA CONTEXT ACTIVATION" "$template"; then
        echo -e "${YELLOW}Already has activation${NC}"
        ((skipped++))
        continue
    fi
    
    if add_activation "$template" "$persona"; then
        echo -e "${GREEN}✓ Added${NC}"
        ((processed++))
    else
        echo -e "${RED}✗ Failed${NC}"
        ((failed++))
    fi
done

echo ""
echo "📋 Backlog Management Commands (Product Owner):"
echo "------------------------------------------------"
cmd_name="groom-backlog-task"
template="$TEMPLATES_DIR/${cmd_name}.md.template"

if [[ -f "$template" ]]; then
    persona="${PHASE3_PERSONA_MAP[$cmd_name]}"
    echo -n "Processing: $cmd_name → $persona ... "
    
    if grep -q "PERSONA CONTEXT ACTIVATION" "$template"; then
        echo -e "${YELLOW}Already has activation${NC}"
        ((skipped++))
    elif add_activation "$template" "$persona"; then
        echo -e "${GREEN}✓ Added${NC}"
        ((processed++))
    else
        echo -e "${RED}✗ Failed${NC}"
        ((failed++))
    fi
fi

echo ""
echo "🧪 QA Framework Commands (QA):"
echo "-------------------------------"
for cmd_name in "monitor-tests" "run-tests" "show-test-status" "test-dashboard" "test-metrics" "qa-framework" "qa-predict" "qa-optimize" "qa-anomaly" "qa-insights"; do
    template="$TEMPLATES_DIR/${cmd_name}.md.template"
    
    if [[ ! -f "$template" ]]; then
        echo -e "${YELLOW}Template not found: $cmd_name${NC}"
        ((failed++))
        continue
    fi
    
    persona="${PHASE3_PERSONA_MAP[$cmd_name]}"
    echo -n "Processing: $cmd_name → $persona ... "
    
    # Check if already has activation
    if grep -q "PERSONA CONTEXT ACTIVATION" "$template"; then
        echo -e "${YELLOW}Already has activation${NC}"
        ((skipped++))
        continue
    fi
    
    if add_activation "$template" "$persona"; then
        echo -e "${GREEN}✓ Added${NC}"
        ((processed++))
    else
        echo -e "${RED}✗ Failed${NC}"
        ((failed++))
    fi
done

# Also check for parallel-sprint (orchestration level, might need special handling)
echo ""
echo "🎯 Special Cases:"
echo "-----------------"
if [[ -f "$TEMPLATES_DIR/parallel-sprint.md.template" ]]; then
    echo "parallel-sprint: Orchestration command (no single persona) - Skipping"
fi

echo ""
echo "================================================"
echo "Phase 3 Summary:"
echo "  Processed: $processed templates"
echo "  Skipped: $skipped templates"
echo "  Failed: $failed templates"
echo "================================================"

if [[ $processed -gt 0 ]]; then
    echo -e "${GREEN}✓ Phase 3: Successfully enhanced $processed commands${NC}"
else
    echo -e "${YELLOW}No new templates were modified${NC}"
fi

if [[ $failed -gt 0 ]]; then
    echo -e "${RED}⚠ $failed templates failed to process${NC}"
    exit 1
fi

echo ""
echo "Overall Implementation Status:"
echo "  Phase 1: 28 sequential commands ✅"
echo "  Phase 2: 20 parallel commands ✅"
echo "  Phase 3: $processed specialized commands ✅"
echo "  Total: $((28 + 20 + processed)) commands with persona activation"

exit 0