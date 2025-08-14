#!/bin/bash
# Enhanced Unified Persona Generation System
# Generates both APM and Claude persona templates from JSON master definitions

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PERSONAS_DIR="$SCRIPT_DIR/personas/_master"
TEMPLATES_DIR="$SCRIPT_DIR/templates"

# Output directories
APM_OUTPUT_DIR="$TEMPLATES_DIR/agents/personas"
CLAUDE_OUTPUT_DIR="$TEMPLATES_DIR/claude/agents/personas"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}═══════════════════════════════════════════${NC}"
echo -e "${GREEN}   Enhanced Persona Generation System v4.0.0${NC}"
echo -e "${GREEN}═══════════════════════════════════════════${NC}"
echo ""

# Create output directories
mkdir -p "$APM_OUTPUT_DIR"
mkdir -p "$CLAUDE_OUTPUT_DIR"

# Function to extract JSON value
get_json_value() {
    local file="$1"
    local path="$2"
    python3 -c "import json; data=json.load(open('$file')); keys='$path'.split('.'); result=data; [result:=result.get(k,'') for k in keys]; print(result if isinstance(result, str) else json.dumps(result))"
}

# Function to generate APM persona template
generate_apm_template() {
    local json_file="$1"
    local persona_name="$2"
    local output_file="$3"
    
    # Extract metadata
    local title=$(get_json_value "$json_file" "metadata.title")
    local description=$(get_json_value "$json_file" "metadata.description")
    local voice_script=$(get_json_value "$json_file" "configuration.voice_script")
    
    # Extract directories
    local primary_dir=$(get_json_value "$json_file" "configuration.working_directories.primary")
    local secondary_dir=$(get_json_value "$json_file" "configuration.working_directories.secondary")
    local output_dir=$(get_json_value "$json_file" "configuration.working_directories.output")
    
    # Build the template content
    cat > "$output_file" << 'EOF'
# Role: {{TITLE}} Agent

🔴 **CRITICAL**

## 🔴 CRITICAL: RESEARCH PROTOCOLS

**NEVER GUESS, ALWAYS VERIFY** - Follow these protocols before any decision:

### 📋 MANDATORY RESEARCH SEQUENCE:
1. **Search Project Docs**: Check {{PROJECT_ROOT}}/project_docs/ and {{SESSION_NOTES_PATH}}/
2. **Search Codebase**: Use Grep/Glob tools to find existing implementations
3. **Read Configurations**: Examine actual files, logs, and configurations
4. **Research Externally**: Use WebSearch for authoritative sources when needed
5. **Ask for Clarification**: Stop and ask specific questions when uncertain

### ❌ FORBIDDEN BEHAVIORS:
- **Never say**: "I assume...", "Probably...", "It should be...", "Typically..."
- **Never guess** at: API endpoints, file paths, configuration values, requirements
- **Never invent**: Technical specifications, user requirements, system constraints

### ✅ REQUIRED EVIDENCE STATEMENTS:
- "According to [specific file/source]..."
- "The existing code in [path] shows..."
- "Based on my search of [location], I found..."
- "I need clarification on [specific aspect] because [context]"

### 🚨 ESCALATION TRIGGERS - Stop and ask when:
- Conflicting information found in different sources
- Missing critical documentation or requirements
- Ambiguous user requirements despite research
- Security or data integrity implications discovered

**Remember**: Better to ask one clarifying question than make ten wrong assumptions.

**Full protocols**: See {{AP_ROOT}}/docs/CRITICAL-RESEARCH-PROTOCOLS.md


- AP {{TITLE}} uses: `bash $SPEAK_{{TITLE_UPPER}} "MESSAGE"` for all Audio Notifications
- Example: `bash $SPEAK_{{TITLE_UPPER}} "{{EXAMPLE_MESSAGE}}"`
- Note: The script expects text as a command line argument
- **MUST FOLLOW**: @{{AP_PERSONAS}}/communication_standards.md for all communication protocols

## 🚧 WORKSPACE BOUNDARIES

### PRIMARY WORKING DIRECTORIES
- **Primary**: `{{PRIMARY_DIR}}`
- **Secondary**: `{{SECONDARY_DIR}}`
EOF

    # Add output directory if exists
    if [ -n "$output_dir" ] && [ "$output_dir" != "null" ]; then
        echo "- **Output**: \`$output_dir\`" >> "$output_file"
    fi
    
    cat >> "$output_file" << 'EOF'
- **Read-Only**: `{{PROJECT_ROOT}}/project_docs/` (specifications)

### FORBIDDEN PATHS
- `.apm/` (APM infrastructure - completely ignore)
- `agents/` (persona definitions)
- `.claude/` (Claude configuration)
- Any session note files or APM documentation

### PATH VALIDATION REQUIRED
Before any file operation:
1. Verify path starts with allowed workspace directory
2. Verify path does NOT contain forbidden directories
3. Focus ONLY on project deliverables, never APM infrastructure

### WORKING DIRECTORY VERIFICATION
**CRITICAL**: Before ANY file operation, verify working directory:
```bash
# ALWAYS execute from project root
cd {{PROJECT_ROOT}}
pwd  # Should show: /path/to/your/project
```

**PATH VALIDATION**: All file operations MUST use absolute paths starting with {{PROJECT_ROOT}}
- ✅ CORRECT: `{{PROJECT_ROOT}}/project_docs/requirements/analysis.md`
- ❌ WRONG: `project_docs/requirements/analysis.md`
- ❌ WRONG: `./project_docs/requirements/analysis.md`

## 🔴 CRITICAL INITIALIZATION SEQUENCE

**STEP 0: WORKING DIRECTORY VERIFICATION**
0. **Change to project root**: `cd {{PROJECT_ROOT}}` and verify with `pwd`

**When activated, follow this EXACT sequence:**

1. **List session notes directory** (use LS tool): `{{SESSION_NOTES_PATH}}/`
   - DO NOT try to read "current_session.md" - it doesn't exist
   
2. **List rules directory** (use LS tool): `{{RULES_PATH}}/`  
   - DO NOT try to read "rules.md" - it doesn't exist
   
3. **Create new session note** with timestamp: `{{SESSION_NOTES_PATH}}/YYYY-MM-DD-HH-mm-ss-{{TITLE}}-Agent-Activation.md`

4. **Voice announcement**: `bash $SPEAK_{{TITLE_UPPER}} "{{TITLE}} agent activated. Loading configuration."`

5. **Execute parallel initialization**:

**CRITICAL**: Upon activation, you MUST immediately execute parallel initialization using native sub-agents for 4x performance.

EOF

    # Perform substitutions based on JSON values
    sed -i "s|{{TITLE}}|$title|g" "$output_file"
    sed -i "s|{{TITLE_UPPER}}|${title^^}|g" "$output_file"
    sed -i "s|{{PRIMARY_DIR}}|$primary_dir|g" "$output_file"
    sed -i "s|{{SECONDARY_DIR}}|$secondary_dir|g" "$output_file"
    
    # Add persona-specific example message
    case "$persona_name" in
        dev)
            sed -i "s|{{EXAMPLE_MESSAGE}}|Story implementation complete, all tests passing|g" "$output_file"
            ;;
        qa)
            sed -i "s|{{EXAMPLE_MESSAGE}}|Test suite execution complete, coverage at 95 percent|g" "$output_file"
            ;;
        pm)
            sed -i "s|{{EXAMPLE_MESSAGE}}|Product requirements document created successfully|g" "$output_file"
            ;;
        po)
            sed -i "s|{{EXAMPLE_MESSAGE}}|Backlog grooming complete, stories prioritized|g" "$output_file"
            ;;
        *)
            sed -i "s|{{EXAMPLE_MESSAGE}}|Task completed successfully|g" "$output_file"
            ;;
    esac
}

# Function to generate Claude subagent template
generate_claude_template() {
    local json_file="$1"
    local persona_name="$2"
    local output_file="$3"
    
    # Extract metadata
    local title=$(get_json_value "$json_file" "metadata.title")
    local description=$(get_json_value "$json_file" "metadata.description")
    
    # Create streamlined Claude template
    cat > "$output_file" << EOF
# ${title} Agent - Claude Subagent

## Role
${description}

## Core Capabilities
EOF
    
    # Add capabilities from JSON
    python3 << PYTHON >> "$output_file"
import json
data = json.load(open('$json_file'))
for capability in data.get('capabilities', {}).get('core', []):
    print(f"- {capability.replace('_', ' ').title()}")
PYTHON
    
    cat >> "$output_file" << 'EOF'

## Activation
This agent is activated via the APM framework using native sub-agent architecture.

## Working Directories
- Primary: {{PROJECT_ROOT}}/workspace/
- Documentation: {{PROJECT_ROOT}}/project_docs/

## Session Management
- Session notes: {{SESSION_NOTES_PATH}}/
- Rules: {{RULES_PATH}}/

**Note**: This is a streamlined Claude subagent template. Full functionality is provided through the APM framework.
EOF
}

# Process each persona
SUCCESS_COUNT=0
FAILED_COUNT=0

for persona_file in "$PERSONAS_DIR"/*.persona.json; do
    if [ -f "$persona_file" ]; then
        persona_name=$(basename "$persona_file" .persona.json)
        echo -e "${YELLOW}Processing $persona_name...${NC}"
        
        # Check if deployment is enabled
        apm_enabled=$(get_json_value "$persona_file" "deployment.apm.enabled" 2>/dev/null || echo "true")
        claude_enabled=$(get_json_value "$persona_file" "deployment.claude.enabled" 2>/dev/null || echo "true")
        
        # Generate APM template if enabled
        if [ "$apm_enabled" = "true" ] || [ "$apm_enabled" = "True" ]; then
            apm_output="$APM_OUTPUT_DIR/${persona_name}.md.template"
            if generate_apm_template "$persona_file" "$persona_name" "$apm_output"; then
                echo -e "  ${GREEN}✓${NC} Generated APM template: $apm_output"
                ((SUCCESS_COUNT++))
            else
                echo -e "  ${RED}✗${NC} Failed to generate APM template"
                ((FAILED_COUNT++))
            fi
        fi
        
        # Generate Claude template if enabled
        if [ "$claude_enabled" = "true" ] || [ "$claude_enabled" = "True" ]; then
            # Handle special case for dev -> developer mapping
            claude_name="$persona_name"
            if [ "$persona_name" = "dev" ]; then
                claude_name="developer"
            fi
            
            claude_output="$CLAUDE_OUTPUT_DIR/${claude_name}.md.template"
            if generate_claude_template "$persona_file" "$persona_name" "$claude_output"; then
                echo -e "  ${GREEN}✓${NC} Generated Claude template: $claude_output"
                ((SUCCESS_COUNT++))
            else
                echo -e "  ${RED}✗${NC} Failed to generate Claude template"
                ((FAILED_COUNT++))
            fi
        fi
        
        echo ""
    fi
done

# Summary
echo -e "${GREEN}═══════════════════════════════════════════${NC}"
echo -e "${GREEN}          Generation Complete!${NC}"
echo -e "${GREEN}═══════════════════════════════════════════${NC}"
echo ""
echo "Summary:"
echo "  - Personas processed: $(ls -1 "$PERSONAS_DIR"/*.persona.json 2>/dev/null | wc -l)"
echo -e "  - Templates generated: ${GREEN}$SUCCESS_COUNT${NC}"
if [ "$FAILED_COUNT" -gt 0 ]; then
    echo -e "  - Failed generations: ${RED}$FAILED_COUNT${NC}"
fi
echo ""
echo "Output locations:"
echo "  - APM templates: $APM_OUTPUT_DIR/"
echo "  - Claude templates: $CLAUDE_OUTPUT_DIR/"
echo ""
echo "To use in build process:"
echo "  1. Run this script during build-distribution.sh"
echo "  2. Templates will be included in distribution package"
echo "  3. install.sh will deploy them to target project"