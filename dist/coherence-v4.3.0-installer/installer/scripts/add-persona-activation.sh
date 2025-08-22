#!/bin/bash

# Script to add lightweight persona activation to command templates
# Part of APM v4.1.0 - Persona-First Command Implementation

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALLER_DIR="$(dirname "$SCRIPT_DIR")"
TEMPLATES_DIR="$INSTALLER_DIR/templates/claude/commands"

# Color codes for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "================================================"
echo "APM Persona Activation Integration Script v1.0"
echo "================================================"
echo ""

# Persona mapping based on approved correlation list
declare -A PERSONA_MAP=(
    ["Product Owner"]="po"
    ["Product"]="po"
    ["Scrum Master"]="sm"
    ["Scrum"]="sm"
    ["QA"]="qa"
    ["QA Engineer"]="qa"
    ["Analyst"]="analyst"
    ["Architect"]="architect"
    ["Designer"]="designer"
    ["Design"]="designer"
    ["Project Manager"]="pm"
    ["Project"]="pm"
    ["Developer"]="dev"
    ["Dev"]="dev"
)

# Commands that should NOT be modified (utilities and orchestration)
SKIP_COMMANDS=(
    "ap.md.template"
    "ap_orchestrator.md.template"
    "handoff.md.template"
    "switch.md.template"
    "wrap.md.template"
    "wrap.md.markdown.template"
    "session-note-setup.md.template"
    "session-note-setup.md.markdown.template"
    "personas.md.template"
    "subtask.md.template"
    "git-commit-all.md.template"
    "buildit.md.template"
    "release.md.template"
    "version.md.template"
    "analyst.md.template"
    "architect.md.template"
    "designer.md.template"
    "dev.md.template"
    "developer.md.template"
    "pm.md.template"
    "po.md.template"
    "qa.md.template"
)

# Function to check if command should be skipped
should_skip() {
    local file="$1"
    local basename=$(basename "$file")
    
    for skip in "${SKIP_COMMANDS[@]}"; do
        if [[ "$basename" == "$skip" ]]; then
            return 0
        fi
    done
    return 1
}

# Function to extract agent from metadata
extract_agent() {
    local file="$1"
    # Look for agent: line in metadata
    agent=$(awk '/^metadata:$/,/^---$/ {if(/agent:/) print $2}' "$file" | head -1)
    # Remove quotes if present
    agent="${agent//\"/}"
    agent="${agent//\'/}"
    echo "$agent"
}

# Function to add persona activation to a template
add_persona_activation() {
    local file="$1"
    local agent="$2"
    local persona_cmd="${PERSONA_MAP[$agent]}"
    
    if [[ -z "$persona_cmd" ]]; then
        echo -e "${YELLOW}Warning: No persona mapping for agent '$agent'${NC}"
        return 1
    fi
    
    # Create the activation block
    # Convert persona_cmd to uppercase for SPEAK variable
    local speak_var="SPEAK_${persona_cmd^^}"
    speak_var="${speak_var//-/_}"  # Replace dashes with underscores
    
    local activation_block="
## 🎭 PERSONA CONTEXT ACTIVATION

**This command requires the $agent persona.**

\`\`\`markdown
*Loading $agent context for optimal command execution...*

Quick Context Load (1-2 seconds):
- Loading $agent configuration and expertise
- Loading relevant templates and frameworks  
- Voice notification: bash \${{$speak_var}} \"$agent context loaded for command execution\"
- Workspace validation: Ensuring execution from {{PROJECT_ROOT}}

*$agent context ready. Proceeding with command...*
\`\`\`
"
    
    # Create a temporary file
    local temp_file="${file}.tmp"
    
    # Process the file
    awk -v block="$activation_block" '
    BEGIN { 
        metadata_ended = 0
        activation_added = 0
    }
    /^---$/ { 
        metadata_ended++
        print
        if (metadata_ended == 2 && !activation_added) {
            print block
            activation_added = 1
        }
        next
    }
    /^## 🎭 PERSONA CONTEXT ACTIVATION$/ {
        # Skip existing activation blocks
        while (getline && !/^## /) {}
        if (/^## /) print
        next
    }
    { print }
    ' "$file" > "$temp_file"
    
    # Replace the original file
    mv "$temp_file" "$file"
    
    return 0
}

# Main processing
echo "Scanning command templates..."
echo ""

processed=0
skipped=0
failed=0

for template in "$TEMPLATES_DIR"/*.template; do
    basename=$(basename "$template")
    
    # Check if should skip
    if should_skip "$template"; then
        echo -e "${YELLOW}Skipping${NC}: $basename (utility/orchestration command)"
        ((skipped++))
        continue
    fi
    
    # Extract agent
    agent=$(extract_agent "$template")
    
    if [[ -z "$agent" || "$agent" == "Orchestrator" || "$agent" == "null" ]]; then
        echo -e "${YELLOW}Skipping${NC}: $basename (no persona required)"
        ((skipped++))
        continue
    fi
    
    # Add persona activation
    echo -e "Processing: $basename (Agent: $agent)"
    if add_persona_activation "$template" "$agent"; then
        echo -e "${GREEN}✓ Added persona activation${NC}"
        ((processed++))
    else
        echo -e "${RED}✗ Failed to add activation${NC}"
        ((failed++))
    fi
    echo ""
done

echo "================================================"
echo "Summary:"
echo "  Processed: $processed templates"
echo "  Skipped: $skipped templates"
echo "  Failed: $failed templates"
echo "================================================"

if [[ $processed -gt 0 ]]; then
    echo -e "${GREEN}✓ Persona activation successfully added to $processed commands${NC}"
else
    echo -e "${YELLOW}No templates were modified${NC}"
fi

if [[ $failed -gt 0 ]]; then
    echo -e "${RED}⚠ $failed templates failed to process${NC}"
    exit 1
fi

echo ""
echo "Next steps:"
echo "1. Review the modified templates"
echo "2. Test a few commands to ensure proper activation"
echo "3. Run the installer to deploy changes"

exit 0