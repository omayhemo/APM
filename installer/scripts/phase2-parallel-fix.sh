#!/bin/bash

# Phase 2 Fix: Properly add persona activation to parallel commands
# APM v4.0.0 - Corrected Version

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALLER_DIR="$(dirname "$SCRIPT_DIR")"
TEMPLATES_DIR="$INSTALLER_DIR/templates/claude/commands"

# Color codes for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "================================================"
echo "APM Phase 2 Fix: Parallel Command Activation"
echo "================================================"
echo ""

# Test with one file first
test_file="$TEMPLATES_DIR/parallel-epic.md.template"

echo "Testing with: parallel-epic.md.template"
echo ""

# Check current state
echo "Checking for existing activation block..."
if grep -q "PERSONA CONTEXT ACTIVATION" "$test_file"; then
    echo -e "${YELLOW}File already has activation${NC}"
    exit 0
fi

echo "No activation found. Adding now..."

# Create the activation block for Product Owner
activation_block="
## 🎭 PERSONA CONTEXT ACTIVATION

**This command requires the Product Owner persona.**

\`\`\`markdown
*Loading Product Owner context for parallel execution...*

Quick Context Load (1-2 seconds):
- Loading Product Owner configuration and expertise
- Preparing parallel execution framework
- Voice notification: bash \${{SPEAK_PO}} \"Product Owner ready for parallel epic creation\"
- Workspace validation: Ensuring execution from {{PROJECT_ROOT}}

*Product Owner context ready. Launching parallel streams...*
\`\`\`
"

# Create temp file
temp_file="${test_file}.tmp"

# Add activation at the beginning (after the title)
{
    # Read first line (title)
    head -1 "$test_file"
    # Add activation block
    echo "$activation_block"
    # Add rest of file (skip first line)
    tail -n +2 "$test_file"
} > "$temp_file"

# Check if temp file was created successfully
if [[ -f "$temp_file" ]]; then
    echo "Temp file created. Checking content..."
    if grep -q "PERSONA CONTEXT ACTIVATION" "$temp_file"; then
        echo -e "${GREEN}✓ Activation block added successfully${NC}"
        # Replace original file
        mv "$temp_file" "$test_file"
        echo -e "${GREEN}✓ File updated${NC}"
    else
        echo -e "${RED}✗ Failed to add activation${NC}"
        rm -f "$temp_file"
        exit 1
    fi
else
    echo -e "${RED}✗ Failed to create temp file${NC}"
    exit 1
fi

echo ""
echo "Now let's apply to all parallel commands..."
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

processed=0
skipped=0
failed=0

for cmd_name in "${!PARALLEL_PERSONA_MAP[@]}"; do
    template="$TEMPLATES_DIR/${cmd_name}.md.template"
    persona="${PARALLEL_PERSONA_MAP[$cmd_name]}"
    speak_var="${SPEAK_VARS[$persona]}"
    
    if [[ ! -f "$template" ]]; then
        echo -e "${YELLOW}Template not found: $cmd_name${NC}"
        ((failed++))
        continue
    fi
    
    echo "Processing: $cmd_name → $persona"
    
    # Check if already has activation
    if grep -q "PERSONA CONTEXT ACTIVATION" "$template" 2>/dev/null; then
        echo -e "${YELLOW}  Already has activation, skipping${NC}"
        ((skipped++))
        continue
    fi
    
    # Create activation block for this persona
    activation_block="
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
\`\`\`
"
    
    # Create temp file
    temp_file="${template}.tmp"
    
    # Add activation after first line
    {
        head -1 "$template"
        echo "$activation_block"
        tail -n +2 "$template"
    } > "$temp_file"
    
    # Verify and replace
    if grep -q "PERSONA CONTEXT ACTIVATION" "$temp_file" 2>/dev/null; then
        mv "$temp_file" "$template"
        echo -e "${GREEN}✓ Added activation${NC}"
        ((processed++))
    else
        rm -f "$temp_file"
        echo -e "${RED}✗ Failed to add activation${NC}"
        ((failed++))
    fi
    echo ""
done

echo "================================================"
echo "Phase 2 Fix Summary:"
echo "  Processed: $processed templates"
echo "  Skipped: $skipped templates"
echo "  Failed: $failed templates"
echo "================================================"

if [[ $processed -gt 0 ]]; then
    echo -e "${GREEN}✓ Successfully fixed $processed parallel commands${NC}"
fi

exit 0