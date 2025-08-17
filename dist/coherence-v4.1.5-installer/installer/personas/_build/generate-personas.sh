#!/bin/bash
# Unified Persona Generation System
# Generates both APM and Claude persona templates from single JSON source

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PERSONAS_DIR="$(dirname "$SCRIPT_DIR")"
MASTER_DIR="$PERSONAS_DIR/_master"
INSTALLER_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
TEMPLATES_DIR="$INSTALLER_DIR/templates"

# Output directories
APM_OUTPUT_DIR="$TEMPLATES_DIR/agents/personas"
CLAUDE_OUTPUT_DIR="$TEMPLATES_DIR/claude/agents/personas"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# We'll implement our own simple template replacement for now
# The existing template processor expects specific arguments we don't need

# Helper function to extract JSON value
get_json_value() {
    local json_file="$1"
    local json_path="$2"
    
    if command -v jq &> /dev/null; then
        jq -r "$json_path" "$json_file"
    else
        # Fallback to basic parsing if jq not available
        grep "\"${json_path##*.}\":" "$json_file" | head -1 | cut -d'"' -f4
    fi
}

# Generate APM persona template
generate_apm_template() {
    local persona_json="$1"
    local persona_id=$(get_json_value "$persona_json" '.metadata.id')
    local output_file="$APM_OUTPUT_DIR/${persona_id}.md.template"
    
    echo -e "${YELLOW}Generating APM template for ${persona_id}...${NC}"
    
    # Start with content sections
    {
        # Role definition
        get_json_value "$persona_json" '.content_sections.role_definition'
        echo ""
        
        # Critical header
        get_json_value "$persona_json" '.content_sections.critical_header'
        echo ""
        
        # Research protocols if analyst
        if [ "$persona_id" = "analyst" ]; then
            get_json_value "$persona_json" '.content_sections.research_protocols'
            echo ""
            
            # Add mandatory research sequence
            echo "### 📋 MANDATORY RESEARCH SEQUENCE:"
            echo "1. **Search Project Docs**: Check {{PROJECT_ROOT}}/project_docs/ and {{SESSION_NOTES_PATH}}/"
            echo "2. **Search Codebase**: Use Grep/Glob tools to find existing implementations"
            echo "3. **Read Configurations**: Examine actual files, logs, and configurations"
            echo "4. **Research Externally**: Use WebSearch for authoritative sources when needed"
            echo "5. **Ask for Clarification**: Stop and ask specific questions when uncertain"
            echo ""
            
            # Add forbidden behaviors
            echo "### ❌ FORBIDDEN BEHAVIORS:"
            echo "- **Never say**: \"I assume...\", \"Probably...\", \"It should be...\", \"Typically...\""
            echo "- **Never guess** at: API endpoints, file paths, configuration values, requirements"
            echo "- **Never invent**: Technical specifications, user requirements, system constraints"
            echo ""
            
            # Add required evidence statements
            echo "### ✅ REQUIRED EVIDENCE STATEMENTS:"
            echo "- \"According to [specific file/source]...\""
            echo "- \"The existing code in [path] shows...\""
            echo "- \"Based on my search of [location], I found...\""
            echo "- \"I need clarification on [specific aspect] because [context]\""
            echo ""
            
            # Add escalation triggers
            echo "### 🚨 ESCALATION TRIGGERS - Stop and ask when:"
            echo "- Conflicting information found in different sources"
            echo "- Missing critical documentation or requirements"
            echo "- Ambiguous user requirements despite research"
            echo "- Security or data integrity implications discovered"
            echo ""
            echo "**Remember**: Better to ask one clarifying question than make ten wrong assumptions."
            echo ""
            echo "**Full protocols**: See {{AP_ROOT}}/docs/CRITICAL-RESEARCH-PROTOCOLS.md"
            echo ""
        fi
        
        # Voice notification section
        echo ""
        echo "- AP $(get_json_value "$persona_json" '.metadata.title') uses: \`bash \$SPEAK_$(echo "$persona_id" | tr '[:lower:]' '[:upper:]') \"MESSAGE\"\` for all Audio Notifications"
        echo "  - Example: \`bash \$SPEAK_$(echo "$persona_id" | tr '[:lower:]' '[:upper:]') \"$(get_json_value "$persona_json" '.metadata.title') agent activated\"\`"
        echo "  - The script expects text as a command line argument"
        echo "- **MUST FOLLOW**: @{{AP_PERSONAS}}/communication_standards.md for all communication protocols, including phase summaries and audio announcements"
        echo ""
        
        # Workspace boundaries
        get_json_value "$persona_json" '.content_sections.workspace_boundaries'
        echo ""
        
        # Add working directories
        echo "### PRIMARY WORKING DIRECTORIES"
        local primary_dir=$(get_json_value "$persona_json" '.configuration.working_directories.primary')
        local secondary_dir=$(get_json_value "$persona_json" '.configuration.working_directories.secondary')
        echo "- **Primary**: \`$primary_dir\` (main workspace)"
        echo "- **Output**: \`$secondary_dir\` (generated artifacts)"
        echo "- **Read-Only**: All other directories (research purposes)"
        echo ""
        
        # Add forbidden paths
        echo "### FORBIDDEN PATHS"
        echo ""
        echo "### WORKING DIRECTORY VERIFICATION"
        echo "**CRITICAL**: Before ANY file operation, verify working directory:"
        echo "\`\`\`bash"
        echo "# ALWAYS execute from project root"
        echo "cd {{PROJECT_ROOT}}"
        echo "pwd  # Should show: /path/to/your/project"
        echo "\`\`\`"
        echo ""
        echo "**PATH VALIDATION**: All file operations MUST use absolute paths starting with {{PROJECT_ROOT}}"
        echo "- ✅ CORRECT: \`{{PROJECT_ROOT}}/project_docs/requirements/analysis.md\`"
        echo "- ❌ WRONG: \`project_docs/requirements/analysis.md\`"
        echo "- ❌ WRONG: \`./project_docs/requirements/analysis.md\`"
        echo "- \`.apm/\` (APM infrastructure - completely ignore)"
        echo "- \`agents/\` (persona definitions)"
        echo "- \`.claude/\` (Claude configuration)"
        echo "- Any session note files or APM documentation"
        echo ""
        
        # Add remaining sections
        get_json_value "$persona_json" '.content_sections.initialization_sequence'
        echo ""
        
        # Add initialization details
        echo ""
        echo "**STEP 0: WORKING DIRECTORY VERIFICATION**"
        echo "0. **Change to project root**: \`cd {{PROJECT_ROOT}}\` and verify with \`pwd\`"
        echo ""
        echo "**When activated, follow this EXACT sequence:**"
        echo ""
        echo "1. **List session notes directory** (use LS tool): \`{{SESSION_NOTES_PATH}}/\`"
        echo "   - DO NOT try to read \"current_session.md\" - it doesn't exist"
        echo "   "
        echo "2. **List rules directory** (use LS tool): \`{{RULES_PATH}}/\`"
        echo "   - DO NOT try to read \"rules.md\" - it doesn't exist"
        echo "   "
        echo "3. **Create new session note** with timestamp: \`{{SESSION_NOTES_PATH}}/YYYY-MM-DD-HH-mm-ss-$(get_json_value "$persona_json" '.metadata.title')-Agent-Activation.md\`"
        echo ""
        echo "4. **Voice announcement**: \`bash \$SPEAK_$(echo "$persona_id" | tr '[:lower:]' '[:upper:]') \"$(get_json_value "$persona_json" '.metadata.title') agent activated. Loading configuration.\"\`"
        echo ""
        echo "5. **Execute parallel initialization**:"
        echo ""
        echo "**CRITICAL**: Upon activation, you MUST immediately execute parallel initialization:"
        echo ""
        echo "\`\`\`"
        echo "I'm initializing as the $(get_json_value "$persona_json" '.metadata.title') agent. Let me load all required context in parallel for optimal performance."
        echo ""
        echo "*Executing parallel initialization tasks:*"
        echo "[Use Task tool - ALL in single function_calls block]"
        
    } > "$output_file"
    
    echo -e "${GREEN}✓ Generated APM template: $output_file${NC}"
}

# Generate Claude persona template
generate_claude_template() {
    local persona_json="$1"
    local persona_id=$(get_json_value "$persona_json" '.metadata.id')
    local output_file="$CLAUDE_OUTPUT_DIR/${persona_id}.md.template"
    
    echo -e "${YELLOW}Generating Claude template for ${persona_id}...${NC}"
    
    # Create Claude version with metadata header
    {
        # HTML comment header
        echo "<!-- APM $(get_json_value "$persona_json" '.metadata.title') Agent Template - $(get_json_value "$persona_json" '.metadata.description') -->"
        echo "<!-- Template Version: {{MIGRATION_VERSION}} -->"
        echo "<!-- Agent: {{AGENT_NAME}} -->"
        echo "<!-- Compatible with: APM Framework $(get_json_value "$persona_json" '.metadata.apm_compatibility') -->"
        echo "<!-- Features: $(get_json_value "$persona_json" '.capabilities.core[]' | tr '\n' ', ') -->"
        echo ""
        
        # Include the role and critical sections
        get_json_value "$persona_json" '.content_sections.role_definition'
        echo ""
        get_json_value "$persona_json" '.content_sections.critical_header'
        echo ""
        
        # Add the core content (reuse the APM logic but inline)
        if [ "$persona_id" = "analyst" ]; then
            get_json_value "$persona_json" '.content_sections.research_protocols'
            # Include the detailed research sections
        fi
        
        # Add Claude-specific sections
        echo ""
        echo "## 📊 Template Metadata"
        echo "- **Agent Type**: $(get_json_value "$persona_json" '.metadata.description')"
        echo "- **Template Version**: {{MIGRATION_VERSION}}"
        echo "- **APM Compatibility**: $(get_json_value "$persona_json" '.metadata.apm_compatibility')"
        echo "- **Enterprise Features**: Native sub-agent parallel execution"
        echo "- **Backward Compatibility**: Full \`/$(get_json_value "$persona_json" '.metadata.id')\` command support"
        echo "- **Migration Status**: Production Ready"
        echo ""
        
        # Add migration footer
        echo "---"
        echo ""
        echo "<!-- Template Migration Footer -->"
        echo "**Migration Information:**"
        echo "- Original Agent: \`{{PROJECT_ROOT}}/.apm/agents/personas/$(get_json_value "$persona_json" '.metadata.id').md\`"
        echo "- Template Created: {{MIGRATION_DATE}}"
        echo "- Compatibility: Full backward compatibility with \`/$(get_json_value "$persona_json" '.metadata.id')\` command"
        echo "- Testing Required: Installer integration, voice system, parallel execution"
        echo "- Dependencies: APM voice scripts, project documentation structure"
        
    } > "$output_file"
    
    rm -f /tmp/temp_apm_${persona_id}.md
    
    echo -e "${GREEN}✓ Generated Claude template: $output_file${NC}"
}

# Main generation function
generate_persona() {
    local persona_json="$1"
    
    if [ ! -f "$persona_json" ]; then
        echo -e "${RED}Error: Persona file not found: $persona_json${NC}"
        return 1
    fi
    
    local persona_id=$(get_json_value "$persona_json" '.metadata.id')
    echo -e "${GREEN}Processing persona: ${persona_id}${NC}"
    
    # Generate APM template
    if [ "$(get_json_value "$persona_json" '.deployment.apm.enabled')" = "true" ]; then
        generate_apm_template "$persona_json"
    fi
    
    # Generate Claude template
    if [ "$(get_json_value "$persona_json" '.deployment.claude.enabled')" = "true" ]; then
        generate_claude_template "$persona_json"
    fi
    
    echo ""
}

# Main execution
main() {
    echo -e "${GREEN}═══════════════════════════════════════════${NC}"
    echo -e "${GREEN}   Unified Persona Generation System${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════${NC}"
    echo ""
    
    # Create output directories if they don't exist
    mkdir -p "$APM_OUTPUT_DIR"
    mkdir -p "$CLAUDE_OUTPUT_DIR"
    
    # Process all persona JSON files
    if [ -d "$MASTER_DIR" ]; then
        for persona_file in "$MASTER_DIR"/*.persona.json; do
            if [ -f "$persona_file" ]; then
                generate_persona "$persona_file"
            fi
        done
    else
        echo -e "${RED}Error: Master directory not found: $MASTER_DIR${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}═══════════════════════════════════════════${NC}"
    echo -e "${GREEN}   Generation Complete!${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════${NC}"
}

# Run main function
main "$@"