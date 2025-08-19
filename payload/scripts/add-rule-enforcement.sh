#!/bin/bash

# Script to add mandatory rule loading to all agent activation commands
# APM v4.1.0 - Rule Enforcement Implementation

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALLER_DIR="$(dirname "$SCRIPT_DIR")"
COMMANDS_DIR="$INSTALLER_DIR/templates/claude/commands"

# Color codes for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "================================================"
echo "APM Rule Enforcement Implementation v1.0"
echo "================================================"
echo ""

# List of agent activation commands that need rule loading
AGENT_COMMANDS=(
    "po"
    "sm"
    "qa"
    "analyst"
    "architect"
    "dev"
    "developer"
    "pm"
    "design-architect"
    "ap_orchestrator"
)

# Function to add rule loading task to a template
add_rule_loading() {
    local file="$1"
    local agent_name="$2"
    
    echo "Processing: $agent_name"
    
    # Check if already has rule loading
    if grep -q "Load.*mandatory.*rules\|Load all rules from" "$file" 2>/dev/null; then
        echo -e "${YELLOW}  Already has rule loading${NC}"
        return 1
    fi
    
    # Determine the task number by counting existing tasks
    local task_count=$(grep -c "^- Task [0-9]:" "$file")
    local new_task_num=$((task_count + 1))
    
    # For AP Orchestrator, we need to modify the existing pattern
    if [[ "$agent_name" == "ap_orchestrator" ]]; then
        # AP Orchestrator already lists rules directory but doesn't read them
        # We need to add actual rule reading after the listing
        
        # Find the line with "Task 5" and add rule loading as Task 6
        sed -i "/^- Task 5: Load available persona list from {{AP_ROOT}}\/personas\//a\\
- Task 6: Load and read ALL mandatory rules from {{AP_ROOT}}/rules/\\
Working Directory: Ensure execution from {{PROJECT_ROOT}} with \\\`cd {{PROJECT_ROOT}}\\\`" "$file"
        
        # Update the task prompts section
        sed -i "/^5\. \"Get list of all available persona files for agent activation\"/a\\
6. \"Read ALL rule files in the rules directory and extract mandatory requirements, enforcement policies, and compliance standards that MUST be followed\"" "$file"
        
        # Add rule adherence reminder after initialization
        sed -i "/^3\. Confirm: \"✓ AP Orchestrator initialized with comprehensive APM system knowledge\"/a\\
4. Confirm: \"✓ All mandatory rules loaded and will be strictly enforced\"" "$file"
        
        echo -e "${GREEN}  ✓ Added rule loading to AP Orchestrator${NC}"
        return 0
    fi
    
    # For other agents, add rule loading before the closing backticks
    # Find the line with the last task and add our new task after it
    local temp_file="${file}.tmp"
    
    # Process the file
    awk -v task_num="$new_task_num" '
    /^```$/ && !done {
        # Add the new task before closing the code block
        print "- Task " task_num ": Load and read ALL mandatory rules from {{AP_ROOT}}/rules/"
        print "Working Directory: Ensure execution from {{PROJECT_ROOT}} with `cd {{PROJECT_ROOT}}`"
        done = 1
    }
    { print }
    ' "$file" > "$temp_file"
    
    # Now add to the task prompts section
    # Find the section that starts with "### Initialization Task Prompts:" or similar
    awk -v task_num="$new_task_num" '
    /^### (Initialization Task Prompts|Task Prompts):/ { 
        in_prompts = 1
        print
        next
    }
    /^### / && in_prompts {
        # End of prompts section, add our prompt before next section
        print task_num ". \"Read ALL rule files in the rules directory and extract mandatory requirements, enforcement policies, and compliance standards that MUST be followed\""
        print ""
        in_prompts = 0
    }
    { print }
    ' "$temp_file" > "${file}.tmp2"
    
    # Add rule adherence statement in Post-Initialization section
    awk '
    /^### Post-Initialization:/ {
        in_post = 1
        print
        next
    }
    /^After ALL tasks complete:/ && in_post {
        print
        getline
        print
        while (getline && /^[0-9]\./) {
            print
        }
        print "4. Confirm: \"✓ All mandatory rules loaded from {{AP_ROOT}}/rules/ and will be strictly enforced\""
        print "5. CRITICAL: Agent MUST adhere to ALL rules throughout the session"
        in_post = 0
        if (NF > 0) print
        next
    }
    { print }
    ' "${file}.tmp2" > "$temp_file"
    
    mv "$temp_file" "$file"
    rm -f "${file}.tmp2"
    
    echo -e "${GREEN}  ✓ Added rule loading to $agent_name${NC}"
    return 0
}

# Process each agent command
echo -e "${BLUE}Adding Mandatory Rule Loading to Agent Activations${NC}"
echo "----------------------------------------------------"
echo ""

processed=0
skipped=0
failed=0

for agent in "${AGENT_COMMANDS[@]}"; do
    template="$COMMANDS_DIR/${agent}.md.template"
    
    if [[ ! -f "$template" ]]; then
        echo -e "${YELLOW}Template not found: $agent${NC}"
        ((failed++))
        continue
    fi
    
    if add_rule_loading "$template" "$agent"; then
        ((processed++))
    else
        ((skipped++))
    fi
    echo ""
done

# Now add a specific section about rule enforcement to each template
echo -e "${BLUE}Adding Rule Enforcement Sections${NC}"
echo "---------------------------------"
echo ""

for agent in "${AGENT_COMMANDS[@]}"; do
    template="$COMMANDS_DIR/${agent}.md.template"
    
    if [[ ! -f "$template" ]]; then
        continue
    fi
    
    # Check if already has rule enforcement section
    if grep -q "## 📋 MANDATORY RULE COMPLIANCE" "$template"; then
        echo "$agent - Already has rule enforcement section"
        continue
    fi
    
    # Add rule enforcement section before "## Available After Activation" or at end
    cat >> "$template" << 'EOF'

## 📋 MANDATORY RULE COMPLIANCE

**CRITICAL**: This agent MUST read and enforce ALL rules from {{AP_ROOT}}/rules/ including but not limited to:
- **Backlog Management**: Update backlog.md immediately after ANY work item changes
- **Documentation Standards**: Follow all documentation formatting and structure rules
- **Security Policies**: Adhere to all security and access control rules
- **Quality Standards**: Maintain all quality and testing requirements
- **Communication Protocols**: Follow all inter-agent communication standards

**ENFORCEMENT**: Failure to follow rules will result in:
1. Immediate session note documentation of violation
2. Corrective action requirement before proceeding
3. Escalation to user if rules cannot be followed

**VERIFICATION**: Agent must periodically verify rule compliance by:
- Checking backlog.md is current after story/planning-epic work
- Validating documentation meets standards
- Ensuring all security protocols are followed
EOF
    
    echo -e "${GREEN}✓ Added rule enforcement section to $agent${NC}"
done

# Create a verification script
echo ""
echo -e "${BLUE}Creating Rule Verification Script${NC}"
echo "----------------------------------"

cat > "$SCRIPT_DIR/verify-rule-loading.sh" << 'SCRIPT'
#!/bin/bash

# Verify that all agent templates have rule loading

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALLER_DIR="$(dirname "$SCRIPT_DIR")"
COMMANDS_DIR="$INSTALLER_DIR/templates/claude/commands"

echo "Verifying Rule Loading in Agent Templates"
echo "=========================================="
echo ""

AGENTS=("po" "sm" "qa" "analyst" "architect" "dev" "developer" "pm" "design-architect" "ap_orchestrator")

for agent in "${AGENTS[@]}"; do
    template="$COMMANDS_DIR/${agent}.md.template"
    
    if [[ ! -f "$template" ]]; then
        echo "✗ $agent - Template not found"
        continue
    fi
    
    if grep -q "Load and read ALL mandatory rules" "$template"; then
        echo "✓ $agent - Has rule loading task"
    else
        echo "✗ $agent - Missing rule loading task"
    fi
    
    if grep -q "MANDATORY RULE COMPLIANCE" "$template"; then
        echo "  ✓ Has enforcement section"
    else
        echo "  ✗ Missing enforcement section"
    fi
    echo ""
done
SCRIPT

chmod +x "$SCRIPT_DIR/verify-rule-loading.sh"

echo ""
echo "================================================"
echo "Summary:"
echo "  Processed: $processed templates"
echo "  Skipped: $skipped templates"
echo "  Failed: $failed templates"
echo "================================================"

if [[ $processed -gt 0 ]]; then
    echo -e "${GREEN}✓ Successfully added rule enforcement to $processed agents${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Run verification: ./verify-rule-loading.sh"
    echo "2. Test an agent activation to ensure rules are loaded"
    echo "3. Build the distribution"
else
    echo -e "${YELLOW}No templates were modified${NC}"
fi

exit 0