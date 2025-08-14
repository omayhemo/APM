#!/bin/bash

# Phase 2: Add persona activation to parallel commands
# APM v4.0.0 - Parallel Command Enhancement

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALLER_DIR="$(dirname "$SCRIPT_DIR")"
TEMPLATES_DIR="$INSTALLER_DIR/templates/claude/commands"

# Color codes for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "================================================"
echo "APM Phase 2: Parallel Command Activation v1.0"
echo "================================================"
echo ""

# Mapping of parallel commands to personas
declare -A PARALLEL_PERSONA_MAP=(
    ["parallel-next-story"]="Scrum Master"
    ["parallel-checklist"]="Scrum Master"
    ["parallel-course-correction"]="Scrum Master"
    ["parallel-epic"]="Product Owner"
    ["parallel-stories"]="Product Owner"
    ["parallel-acceptance-criteria"]="Product Owner"
    ["parallel-prioritization"]="Product Owner"
    ["parallel-validation"]="Analyst"
    ["parallel-requirements"]="Analyst"
    ["parallel-brainstorming"]="Analyst"
    ["parallel-stakeholder-review"]="Analyst"
    ["parallel-research-prompt"]="Analyst"
    ["parallel-architecture"]="Architect"
    ["parallel-ai-prompt"]="Design Architect"
    ["parallel-frontend-architecture"]="Design Architect"
    ["parallel-prd"]="Project Manager"
    ["parallel-qa-framework"]="QA"
    ["parallel-test-plan"]="QA"
    ["parallel-test-strategy"]="QA"
    ["parallel-quality-review"]="QA"
    ["parallel-automation-plan"]="QA"
    ["parallel-regression-suite"]="QA"
    ["parallel-test"]="QA"
    ["parallel-review"]="Developer"
)

# Map personas to SPEAK variables
declare -A SPEAK_VARS=(
    ["Scrum Master"]="SPEAK_SM"
    ["Product Owner"]="SPEAK_PO"
    ["Analyst"]="SPEAK_ANALYST"
    ["Architect"]="SPEAK_ARCHITECT"
    ["Design Architect"]="SPEAK_DESIGN_ARCHITECT"
    ["Project Manager"]="SPEAK_PM"
    ["QA"]="SPEAK_QA"
    ["Developer"]="SPEAK_DEV"
)

# Commands to skip (orchestration level)
SKIP_PARALLEL=(
    "parallel-sprint"
)

# Function to check if should skip
should_skip() {
    local cmd="$1"
    for skip in "${SKIP_PARALLEL[@]}"; do
        if [[ "$cmd" == "$skip" ]]; then
            return 0
        fi
    done
    return 1
}

# Function to add metadata and persona activation
add_metadata_and_activation() {
    local file="$1"
    local persona="$2"
    local speak_var="${SPEAK_VARS[$persona]}"
    
    if [[ -z "$speak_var" ]]; then
        echo -e "${YELLOW}Warning: No SPEAK variable for persona '$persona'${NC}"
        return 1
    fi
    
    # Create metadata header
    local metadata_block="---
name: $(basename "$file" .md.template)
description: Parallel execution with native sub-agents
metadata:
  version: 2.0.0
  agent: $persona
  performance: parallel
  approach: native-subagents
---"
    
    # Create activation block
    local activation_block="
## 🎭 PERSONA CONTEXT ACTIVATION

**This command requires the $persona persona.**

\`\`\`markdown
*Loading $persona context for parallel execution...*

Quick Context Load (1-2 seconds):
- Loading $persona configuration and expertise
- Preparing parallel execution framework
- Voice notification: bash \${{$speak_var}} \"$persona ready for parallel execution\"
- Workspace validation: Ensuring execution from {{PROJECT_ROOT}}

*$persona context ready. Launching parallel streams...*
\`\`\`"
    
    # Create temporary file
    local temp_file="${file}.tmp"
    
    # Check if file already has metadata
    if grep -q "^---$" "$file" | head -1; then
        echo -e "${YELLOW}File already has metadata, skipping metadata addition${NC}"
        # Just add activation after existing metadata
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
        ' "$file" > "$temp_file"
    else
        # Add both metadata and activation
        echo "$metadata_block" > "$temp_file"
        echo "$activation_block" >> "$temp_file"
        echo "" >> "$temp_file"
        cat "$file" >> "$temp_file"
    fi
    
    # Replace original file
    mv "$temp_file" "$file"
    return 0
}

# Main processing
echo "Processing parallel command templates..."
echo ""

processed=0
skipped=0
failed=0

for cmd_name in "${!PARALLEL_PERSONA_MAP[@]}"; do
    template="$TEMPLATES_DIR/${cmd_name}.md.template"
    persona="${PARALLEL_PERSONA_MAP[$cmd_name]}"
    
    if [[ ! -f "$template" ]]; then
        echo -e "${YELLOW}Template not found: $cmd_name${NC}"
        ((failed++))
        continue
    fi
    
    if should_skip "$cmd_name"; then
        echo -e "${YELLOW}Skipping${NC}: $cmd_name (orchestration command)"
        ((skipped++))
        continue
    fi
    
    echo "Processing: $cmd_name → $persona"
    
    # Check if already has activation
    if grep -q "PERSONA CONTEXT ACTIVATION" "$template"; then
        echo -e "${YELLOW}  Already has activation, skipping${NC}"
        ((skipped++))
        continue
    fi
    
    if add_metadata_and_activation "$template" "$persona"; then
        echo -e "${GREEN}✓ Added metadata and activation${NC}"
        ((processed++))
    else
        echo -e "${RED}✗ Failed to add activation${NC}"
        ((failed++))
    fi
    echo ""
done

# Also process QA commands that were skipped
echo "Processing additional QA commands..."
qa_commands=("qa-framework" "qa-predict" "qa-optimize" "qa-anomaly" "qa-insights" "run-tests" "monitor-tests" "show-test-status" "test-dashboard" "test-metrics")

for cmd in "${qa_commands[@]}"; do
    template="$TEMPLATES_DIR/${cmd}.md.template"
    
    if [[ ! -f "$template" ]]; then
        continue
    fi
    
    # Check if already processed
    if grep -q "PERSONA CONTEXT ACTIVATION" "$template"; then
        echo -e "${YELLOW}$cmd already has activation${NC}"
        ((skipped++))
        continue
    fi
    
    echo "Processing: $cmd → QA"
    
    # Add basic metadata if missing
    if ! grep -q "^---$" "$template" | head -1; then
        # Create temp file with metadata
        temp_file="${template}.tmp"
        cat > "$temp_file" << EOF
---
name: $cmd
description: QA framework command
metadata:
  version: 1.0.0
  agent: QA
  performance: sequential
  approach: qa-framework
---

## 🎭 PERSONA CONTEXT ACTIVATION

**This command requires the QA persona.**

\`\`\`markdown
*Loading QA context for command execution...*

Quick Context Load (1-2 seconds):
- Loading QA configuration and test frameworks
- Loading quality metrics and validation rules
- Voice notification: bash \${{SPEAK_QA}} "QA context loaded for $cmd"
- Workspace validation: Ensuring execution from {{PROJECT_ROOT}}

*QA context ready. Proceeding with command...*
\`\`\`

EOF
        cat "$template" >> "$temp_file"
        mv "$temp_file" "$template"
        echo -e "${GREEN}✓ Added metadata and activation${NC}"
        ((processed++))
    else
        ((skipped++))
    fi
    echo ""
done

echo "================================================"
echo "Phase 2 Summary:"
echo "  Processed: $processed templates"
echo "  Skipped: $skipped templates"
echo "  Failed: $failed templates"
echo "================================================"

if [[ $processed -gt 0 ]]; then
    echo -e "${GREEN}✓ Phase 2: Successfully enhanced $processed commands${NC}"
else
    echo -e "${YELLOW}No new templates were modified${NC}"
fi

if [[ $failed -gt 0 ]]; then
    echo -e "${RED}⚠ $failed templates failed to process${NC}"
    exit 1
fi

echo ""
echo "Next steps:"
echo "1. Test a parallel command to verify activation"
echo "2. Build the distribution with updated templates"
echo "3. Document Phase 2 completion"

exit 0