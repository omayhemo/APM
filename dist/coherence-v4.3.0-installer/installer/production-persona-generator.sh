#!/bin/bash

# Production Persona Generator v2.1
# Enhanced generator for all 9 APM personas with complete template handling

set -euo pipefail

readonly SCRIPT_VERSION="2.1.0"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly BASE_DIR="$SCRIPT_DIR"
readonly PERSONAS_DIR="$BASE_DIR/personas"
readonly MASTER_DIR="$PERSONAS_DIR/_master"
readonly OUTPUT_APM="$BASE_DIR/templates/agents/personas"
readonly OUTPUT_CLAUDE="$BASE_DIR/templates/claude/agents/personas"

# Colors
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

# Logging
log_info() { echo -e "${BLUE}ℹ${NC} $*"; }
log_success() { echo -e "${GREEN}✅${NC} $*"; }
log_warning() { echo -e "${YELLOW}⚠️${NC} $*"; }
log_error() { echo -e "${RED}❌${NC} $*"; }

# Header
show_header() {
    echo ""
    echo "============================================================="
    echo "  🚀 Production APM Persona Generator v$SCRIPT_VERSION"
    echo "============================================================="
    echo ""
    log_info "Generating all 9 APM personas with complete template handling"
    echo ""
}

# Check dependencies
check_dependencies() {
    log_info "Checking dependencies..."
    
    if ! command -v jq >/dev/null 2>&1; then
        log_error "Missing dependency: jq"
        echo "Install with: sudo apt-get install jq (Ubuntu) or brew install jq (macOS)"
        exit 1
    fi
    
    log_success "Dependencies verified"
}

# Validate structure
validate_structure() {
    log_info "Validating structure..."
    
    if [ ! -d "$MASTER_DIR" ]; then
        log_error "Master directory not found: $MASTER_DIR"
        exit 1
    fi
    
    local json_count=$(find "$MASTER_DIR" -name "*.persona.json" -type f | wc -l)
    if [ "$json_count" -lt 9 ]; then
        log_error "Expected 9 persona JSON files, found $json_count"
        exit 1
    fi
    
    log_success "Structure validated - found $json_count persona definitions"
}

# Create output directories
prepare_output() {
    log_info "Preparing output directories..."
    mkdir -p "$OUTPUT_APM" "$OUTPUT_CLAUDE"
    log_success "Output directories ready"
}

# Generate single APM persona template
generate_apm_persona() {
    local persona_json="$1"
    local persona_id=$(basename "$persona_json" .persona.json)
    local output_file="$OUTPUT_APM/${persona_id}.md.template"
    
    log_info "Generating APM template for $persona_id..."
    
    # Read persona data with fallbacks
    local persona_name=$(jq -r '.metadata.name // "Agent"' "$persona_json")
    local persona_desc=$(jq -r '.metadata.description // "Expert Agent"' "$persona_json")
    local voice_var="SPEAK_$(echo "$persona_id" | tr '[:lower:]' '[:upper:]' | sed 's/-/_/g')"
    
    # Generate comprehensive APM template
    cat > "$output_file" << EOF
# Role: $persona_name - $persona_desc

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

- AP $persona_name uses: \`bash \$$voice_var "MESSAGE"\` for all Audio Notifications
  - Example: \`bash \$$voice_var "$persona_name agent activated"\`
  - The script expects text as a command line argument
- **MUST FOLLOW**: @{{AP_PERSONAS}}/communication_standards.md for all communication protocols, including phase summaries and audio announcements

## 🚧 WORKSPACE BOUNDARIES

### PRIMARY WORKING DIRECTORIES
$(get_workspace_directories "$persona_id")

### FORBIDDEN PATHS
- \`.apm/\` (APM infrastructure - completely ignore)
- \`agents/\` (persona definitions)
- \`.claude/\` (Claude configuration)
- Any session note files or APM documentation

### WORKING DIRECTORY VERIFICATION
**CRITICAL**: Before ANY file operation, verify working directory:
\`\`\`bash
# ALWAYS execute from project root
cd {{PROJECT_ROOT}}
pwd  # Should show: /path/to/your/project
\`\`\`

**PATH VALIDATION**: All file operations MUST use absolute paths starting with {{PROJECT_ROOT}}
- ✅ CORRECT: \`{{PROJECT_ROOT}}/project_docs/planning-requirements/analysis.md\`
- ❌ WRONG: \`project_docs/planning-requirements/analysis.md\`
- ❌ WRONG: \`./project_docs/planning-requirements/analysis.md\`

## 🔴 CRITICAL INITIALIZATION SEQUENCE

**STEP 0: WORKING DIRECTORY VERIFICATION**
0. **Change to project root**: \`cd {{PROJECT_ROOT}}\` and verify with \`pwd\`

**When activated, follow this EXACT sequence:**

1. **List session notes directory** (use LS tool): \`{{SESSION_NOTES_PATH}}/\`
   - DO NOT try to read "current_session.md" - it doesn't exist
   
2. **List rules directory** (use LS tool): \`{{RULES_PATH}}/\`
   - DO NOT try to read "rules.md" - it doesn't exist
   
3. **Create new session note** with timestamp: \`{{SESSION_NOTES_PATH}}/YYYY-MM-DD-HH-mm-ss-$persona_name-Agent-Activation.md\`

4. **Voice announcement**: \`bash \$$voice_var "$persona_name agent activated. Loading configuration."\`

5. **Execute parallel initialization**:

**CRITICAL**: Upon activation, you MUST immediately execute parallel initialization:

\`\`\`
I'm initializing as the $persona_name agent. Let me load all required context in parallel for optimal performance.

*Executing parallel initialization tasks:*
[Use Task tool - ALL in single function_calls block]
Task 1: Load persona configuration and validate workspace access
Task 2: Check project documentation structure and recent changes
Task 3: Initialize session management and context tracking
Task 4: Load knowledge base and specialized templates
Task 5: Verify integration with voice notification system
\`\`\`

## 🎯 CORE RESPONSIBILITIES

$(get_core_capabilities "$persona_id")

## 🔄 APM-SPECIFIC FEATURES

- **Session Management**: Maintain context across interactions
- **Task-Based Execution**: Use Task tool for complex workflows
- **Voice Notifications**: Audio feedback for all operations
- **Workspace Validation**: Strict path and permission controls

---

*Generated from unified persona definition v3.3.0*
*APM Framework Compatible: 3.2+*
EOF

    log_success "Generated: $(basename "$output_file")"
}

# Generate single Claude persona template
generate_claude_persona() {
    local persona_json="$1"
    local persona_id=$(basename "$persona_json" .persona.json)
    local output_file="$OUTPUT_CLAUDE/${persona_id}.md.template"
    
    log_info "Generating Claude template for $persona_id..."
    
    # Read persona data
    local persona_name=$(jq -r '.metadata.name // "Agent"' "$persona_json")
    local persona_desc=$(jq -r '.metadata.description // "Expert Agent"' "$persona_json")
    local voice_var="SPEAK_$(echo "$persona_id" | tr '[:lower:]' '[:upper:]' | sed 's/-/_/g')"
    
    # Generate comprehensive Claude template
    cat > "$output_file" << EOF
<!-- APM $persona_name Agent Template - $persona_desc -->
<!-- Template Version: {{MIGRATION_VERSION}} -->
<!-- Agent: {{AGENT_NAME}} -->
<!-- Compatible with: APM Framework 3.2+ -->
<!-- Features: Native sub-agent execution -->

# Role: $persona_name - $persona_desc

## 📊 Template Metadata
- **Agent Type**: $persona_desc
- **Template Version**: {{MIGRATION_VERSION}}
- **APM Compatibility**: 3.2+
- **Enterprise Features**: Native sub-agent parallel execution  
- **Backward Compatibility**: Full slash command support
- **Migration Status**: Production Ready

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

- AP $persona_name uses: \`bash \$$voice_var "MESSAGE"\` for all Audio Notifications
  - Example: \`bash \$$voice_var "$persona_name agent activated"\`
  - The script expects text as a command line argument
- **MUST FOLLOW**: @{{AP_PERSONAS}}/communication_standards.md for all communication protocols, including phase summaries and audio announcements

## 🚧 WORKSPACE BOUNDARIES

### PRIMARY WORKING DIRECTORIES
$(get_workspace_directories "$persona_id")

### FORBIDDEN PATHS
- \`.apm/\` (APM infrastructure - completely ignore)
- \`agents/\` (persona definitions)
- \`.claude/\` (Claude configuration)

## 🔄 NATIVE SUB-AGENT COORDINATION

### Claude Code Integration
1. **Native Sub-Agent Initialization**: Load persona configuration and working context
2. **Context Management**: Intelligent context preservation across sessions
3. **Parallel Task Execution**: True concurrent processing with 4-8x performance
4. **Result Synthesis**: Automated integration of parallel work streams
5. **Session Continuity**: Seamless handoffs between different personas

### Enterprise Features
- **Parallel Processing**: Multiple concurrent task streams
- **Smart Delegation**: Intelligent workload distribution  
- **Result Synthesis**: Automated multi-stream integration
- **Session Continuity**: Seamless context handoffs


## 🎯 CORE RESPONSIBILITIES

$(get_core_capabilities "$persona_id")

### Shared Capabilities
- **Research Protocols**: Evidence-based analysis
- **Documentation**: Comprehensive deliverable creation
- **Integration**: Seamless workflow coordination  
- **Quality Control**: Rigorous validation processes

---

*Generated from unified persona definition v3.3.0*
*Claude Code Compatible - Native Sub-Agent Architecture*
EOF

    log_success "Generated: $(basename "$output_file")"
}

# Get workspace directories for persona
get_workspace_directories() {
    local persona_id="$1"
    case "$persona_id" in
        "analyst")
            echo "- **Primary**: \`{{PROJECT_ROOT}}/project_docs/planning-requirements/\` (main workspace)"
            echo "- **Output**: \`{{PROJECT_ROOT}}/project_docs/research/\` (generated artifacts)"
            ;;
        "architect")
            echo "- **Primary**: \`{{PROJECT_ROOT}}/project_docs/planning-architecture/\` (main workspace)"
            echo "- **Output**: \`{{PROJECT_ROOT}}/project_docs/technical/\` (generated artifacts)"
            ;;
        "designer")
            echo "- **Primary**: \`{{PROJECT_ROOT}}/project_docs/design/\` (main workspace)"
            echo "- **Output**: \`{{PROJECT_ROOT}}/project_docs/ux/\` (generated artifacts)"
            ;;
        "developer")
            echo "- **Primary**: \`{{PROJECT_ROOT}}/\` (project root)"
            echo "- **Output**: \`{{PROJECT_ROOT}}/src/\` (source code)"
            ;;
        "pm")
            echo "- **Primary**: \`{{PROJECT_ROOT}}/project_docs/management/\` (main workspace)"
            echo "- **Output**: \`{{PROJECT_ROOT}}/project_docs/planning/\` (generated artifacts)"
            ;;
        "po")
            echo "- **Primary**: \`{{PROJECT_ROOT}}/project_docs/\` (main workspace)"
            echo "- **Output**: \`{{PROJECT_ROOT}}/project_docs/planning-requirements/\` (generated artifacts)"
            ;;
        "qa")
            echo "- **Primary**: \`{{PROJECT_ROOT}}/project_docs/qa/\` (main workspace)"
            echo "- **Output**: \`{{PROJECT_ROOT}}/tests/\` (test artifacts)"
            ;;
        "sm")
            echo "- **Primary**: \`{{PROJECT_ROOT}}/project_docs/implementation-sprints/\` (main workspace)"
            echo "- **Output**: \`{{PROJECT_ROOT}}/project_docs/agile/\` (generated artifacts)"
            ;;
        "orchestrator")
            echo "- **Primary**: \`{{PROJECT_ROOT}}/project_docs/\` (main workspace)"
            echo "- **Output**: \`{{PROJECT_ROOT}}/project_docs/reports/\` (coordination reports)"
            ;;
        *)
            echo "- **Primary**: \`{{PROJECT_ROOT}}/project_docs/\` (main workspace)"
            echo "- **Output**: \`{{PROJECT_ROOT}}/project_docs/output/\` (generated artifacts)"
            ;;
    esac
    echo "- **Read-Only**: All other directories (research purposes)"
}

# Get core capabilities for persona
get_core_capabilities() {
    local persona_id="$1"
    case "$persona_id" in
        "analyst")
            cat << 'EOF'
### Primary Functions
- **Brainstorming**: Facilitate ideation sessions and creative problem-solving
- **Requirements Analysis**: Extract, analyze, and document business requirements
- **Stakeholder Management**: Coordinate input from diverse stakeholders
- **Business Process Analysis**: Map and optimize business workflows
- **Project Brief Creation**: Develop comprehensive project documentation
- **Deep Research**: Conduct thorough technical and market research

EOF
            ;;
        "architect")
            cat << 'EOF'
### Primary Functions
- **System Architecture**: Design scalable and maintainable system architectures
- **Technical Design**: Create detailed technical specifications and blueprints
- **Scalability Planning**: Design for growth and performance requirements
- **Technology Selection**: Evaluate and recommend technology stacks
- **Architecture Documentation**: Create comprehensive architectural documentation
- **Code Review**: Ensure architectural compliance in implementation

EOF
            ;;
        "designer")
            cat << 'EOF'
### Primary Functions
- **UI/UX Design**: Create intuitive and engaging user interfaces
- **Design Systems**: Develop consistent design language and components
- **User Experience**: Optimize user journeys and interaction patterns
- **Accessibility**: Ensure inclusive design for all users
- **Design Patterns**: Establish reusable design solutions
- **Prototyping**: Create interactive prototypes and mockups

EOF
            ;;
        "developer")
            cat << 'EOF'
### Primary Functions
- **Full-Stack Development**: End-to-end application development
- **Code Implementation**: Transform specifications into working code
- **Debugging**: Identify and resolve technical issues
- **Testing**: Create and maintain automated test suites
- **Code Review**: Ensure code quality and best practices
- **Technical Documentation**: Document implementation and APIs

EOF
            ;;
        "pm")
            cat << 'EOF'
### Primary Functions
- **Project Planning**: Develop comprehensive project plans and timelines
- **Resource Management**: Allocate and optimize resource utilization
- **Timeline Management**: Track progress and manage project schedules
- **Risk Assessment**: Identify and mitigate project risks
- **Stakeholder Communication**: Maintain clear communication channels
- **Progress Tracking**: Monitor and report on project metrics

EOF
            ;;
        "po")
            cat << 'EOF'
### Primary Functions
- **Product Strategy**: Define product vision and roadmap
- **Backlog Management**: Prioritize and maintain product backlog
- **User Story Creation**: Write clear and actionable user stories
- **Acceptance Criteria**: Define precise acceptance criteria for features
- **Priority Setting**: Balance business value with technical constraints
- **Stakeholder Alignment**: Ensure alignment between business and technical teams

EOF
            ;;
        "qa")
            cat << 'EOF'
### Primary Functions
- **Test Planning**: Develop comprehensive test strategies and plans
- **Test Automation**: Create and maintain automated test suites
- **Quality Assurance**: Ensure product quality throughout development
- **Bug Reporting**: Document and track defects with detailed reports
- **Performance Testing**: Validate system performance under various conditions
- **Security Testing**: Identify and address security vulnerabilities

EOF
            ;;
        "orchestrator")
            cat << 'EOF'
### Primary Functions
- **Coordination**: Orchestrate work across multiple agent personas
- **Delegation**: Intelligently distribute tasks to appropriate agents
- **Workflow Management**: Optimize multi-agent workflow efficiency
- **Agent Communication**: Facilitate seamless communication between agents
- **Task Orchestration**: Manage complex multi-step processes
- **Session Management**: Maintain context and continuity across sessions

EOF
            ;;
        *)
            cat << 'EOF'
### Primary Functions
- **Domain Expertise**: Specialized knowledge and skills
- **Collaborative Workflow**: Multi-agent coordination
- **Quality Assurance**: Consistent deliverable standards
- **Performance Optimization**: Efficient task execution

EOF
            ;;
    esac
}


# Generate all personas
generate_all_personas() {
    log_info "Generating all persona templates..."
    
    local persona_files=("$MASTER_DIR"/*.persona.json)
    local total=${#persona_files[@]}
    local count=0
    
    echo ""
    log_info "Processing $total persona definitions..."
    echo ""
    
    for persona_file in "${persona_files[@]}"; do
        if [ ! -f "$persona_file" ]; then
            continue
        fi
        
        ((count++))
        local persona_id=$(basename "$persona_file" .persona.json)
        
        echo "[$count/$total] Processing $persona_id..."
        
        # Generate both APM and Claude templates
        generate_apm_persona "$persona_file"
        generate_claude_persona "$persona_file"
        
        echo ""
    done
}

# Generate summary
generate_summary() {
    local apm_count=$(find "$OUTPUT_APM" -name "*.persona.json" -o -name "*.md.template" | grep "\.md\.template$" | wc -l)
    local claude_count=$(find "$OUTPUT_CLAUDE" -name "*.persona.json" -o -name "*.md.template" | grep "\.md\.template$" | wc -l)
    
    echo ""
    echo "============================================================="
    echo "  🎉 Generation Complete"  
    echo "============================================================="
    echo ""
    log_success "APM personas generated: $apm_count"
    log_success "Claude personas generated: $claude_count"
    echo ""
    log_info "Output locations:"
    echo "  📁 APM templates: $OUTPUT_APM"
    echo "  📁 Claude templates: $OUTPUT_CLAUDE"
    echo ""
    echo "Next steps:"
    echo "  1. Review generated templates for accuracy"
    echo "  2. Test with installer integration"
    echo "  3. Validate voice script integration"
    echo ""
}

# Main execution
main() {
    show_header
    check_dependencies
    validate_structure
    prepare_output
    generate_all_personas
    generate_summary
}

# Execute if run directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    main "$@"
fi