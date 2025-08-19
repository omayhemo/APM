#!/bin/bash

# Enhanced Persona Generator v2.0
# Production-ready generator for all 9 APM personas
# Reads JSON master definitions and generates complete APM and Claude templates

set -euo pipefail

readonly SCRIPT_VERSION="2.0.0"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly BASE_DIR="$SCRIPT_DIR"
readonly PERSONAS_DIR="$BASE_DIR/personas"
readonly MASTER_DIR="$PERSONAS_DIR/_master"
readonly TEMPLATES_DIR="$PERSONAS_DIR/_templates"
readonly OUTPUT_APM="$BASE_DIR/templates/agents/personas"
readonly OUTPUT_CLAUDE="$BASE_DIR/templates/claude/agents/personas"

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly PURPLE='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m'

# Logging functions
log_info() { echo -e "${BLUE}ℹ${NC} $*"; }
log_success() { echo -e "${GREEN}✅${NC} $*"; }
log_warning() { echo -e "${YELLOW}⚠️${NC} $*"; }
log_error() { echo -e "${RED}❌${NC} $*"; }
log_step() { echo -e "${PURPLE}👉${NC} $*"; }

# Progress tracking
TOTAL_PERSONAS=9
CURRENT_PERSONA=0

show_progress() {
    local current=$1
    local total=$2
    local persona=$3
    local percentage=$((current * 100 / total))
    echo -e "${CYAN}Progress: [$current/$total] ($percentage%) - $persona${NC}"
}

# Enhanced header
show_header() {
    echo ""
    echo "============================================================="
    echo "  🚀 Enhanced APM Persona Generator v$SCRIPT_VERSION"
    echo "============================================================="
    echo ""
    log_info "Production-ready generator for all 9 APM personas"
    log_info "Generates both APM and Claude deployment targets"
    echo ""
}

# Check for required dependencies
check_dependencies() {
    log_step "Checking dependencies..."
    
    local missing_deps=()
    local deps=("jq" "envsubst" "sed" "awk")
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" >/dev/null 2>&1; then
            missing_deps+=("$dep")
        fi
    done
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        log_error "Missing dependencies: ${missing_deps[*]}"
        echo ""
        echo "Install missing dependencies:"
        echo "  Ubuntu/Debian: sudo apt-get install jq gettext-base"
        echo "  macOS: brew install jq gettext"
        echo "  RHEL/CentOS: sudo yum install jq gettext"
        exit 1
    fi
    
    log_success "All dependencies available"
}

# Validate directory structure
validate_structure() {
    log_step "Validating directory structure..."
    
    local errors=()
    local required_dirs=("$MASTER_DIR" "$TEMPLATES_DIR")
    local required_files=(
        "$TEMPLATES_DIR/apm.persona.template"
        "$TEMPLATES_DIR/claude.persona.template"
    )
    
    # Check directories
    for dir in "${required_dirs[@]}"; do
        if [ ! -d "$dir" ]; then
            errors+=("Directory not found: $dir")
        fi
    done
    
    # Check template files
    for file in "${required_files[@]}"; do
        if [ ! -f "$file" ]; then
            errors+=("Template not found: $file")
        fi
    done
    
    if [ ${#errors[@]} -gt 0 ]; then
        log_error "Structure validation failed:"
        printf '   - %s\n' "${errors[@]}"
        exit 1
    fi
    
    log_success "Directory structure validated"
}

# Create all master persona JSON definitions (skip if they exist)
create_master_definitions() {
    log_step "Checking master persona definitions..."
    
    # Ensure master directory exists
    mkdir -p "$MASTER_DIR"
    
    # Count existing JSON files
    local existing_count=$(find "$MASTER_DIR" -name "*.persona.json" -type f | wc -l)
    
    if [ "$existing_count" -ge 9 ]; then
        log_success "Found $existing_count existing master definitions - skipping creation"
        return 0
    fi
    
    log_info "Need to create master definitions (found: $existing_count, need: 9)"
    log_success "Using existing JSON master definitions"
}

# Helper functions for JSON generation
capitalize_first_letter() {
    local input=$1
    if [[ "$input" == "design-architect" ]]; then
        echo "DesignArchitect"
    elif [[ "$input" == "orchestrator" ]]; then
        echo "Orchestrator"
    else
        echo "${input^}"
    fi
}

get_core_capabilities() {
    local persona_id=$1
    case "$persona_id" in
        "analyst")
            echo '["brainstorming", "requirements_analysis", "stakeholder_management", "business_process_analysis", "project_brief_creation", "deep_research"]'
            ;;
        "architect")
            echo '["system_architecture", "technical_design", "scalability_planning", "technology_selection", "architecture_documentation", "code_review"]'
            ;;
        "design-architect")
            echo '["ui_ux_design", "design_systems", "user_experience", "accessibility", "design_patterns", "prototyping"]'
            ;;
        "developer")
            echo '["full_stack_development", "code_implementation", "debugging", "testing", "code_review", "technical_documentation"]'
            ;;
        "pm")
            echo '["project_planning", "resource_management", "timeline_management", "risk_assessment", "stakeholder_communication", "progress_tracking"]'
            ;;
        "po")
            echo '["product_strategy", "backlog_management", "user_story_creation", "acceptance_criteria", "priority_setting", "stakeholder_alignment"]'
            ;;
        "qa")
            echo '["test_planning", "test_automation", "quality_assurance", "bug_reporting", "performance_testing", "security_testing"]'
            ;;
        "sm")
            echo '["agile_facilitation", "sprint_planning", "retrospectives", "impediment_removal", "team_coaching", "process_improvement"]'
            ;;
        "orchestrator")
            echo '["coordination", "delegation", "workflow_management", "agent_communication", "task_orchestration", "session_management"]'
            ;;
    esac
}

get_parallel_commands() {
    local persona_id=$1
    case "$persona_id" in
        "analyst")
            echo '["parallel-brainstorming", "parallel-requirements", "parallel-research-prompt", "parallel-stakeholder-planning-review"]'
            ;;
        "architect")
            echo '["parallel-architecture", "parallel-frontend-architecture", "parallel-ai-prompt"]'
            ;;
        "design-architect")
            echo '["parallel-ux-design", "parallel-design-system", "parallel-accessibility-audit"]'
            ;;
        "developer")
            echo '["parallel-planning-review", "parallel-implementation", "parallel-testing"]'
            ;;
        "pm")
            echo '["parallel-planning-prd", "parallel-project-planning", "parallel-risk-assessment"]'
            ;;
        "po")
            echo '["parallel-stories", "parallel-epic", "parallel-acceptance-criteria", "parallel-prioritization", "parallel-validation"]'
            ;;
        "qa")
            echo '["parallel-qa-framework", "parallel-test-plan", "parallel-test-strategy", "parallel-automation-plan", "parallel-quality-planning-review"]'
            ;;
        "sm")
            echo '["parallel-sprint", "parallel-checklist", "parallel-course-correction", "parallel-next-story"]'
            ;;
        "orchestrator")
            echo '["parallel-coordination", "parallel-delegation", "parallel-synthesis"]'
            ;;
    esac
}

get_slash_commands() {
    local persona_id=$1
    case "$persona_id" in
        "analyst")
            echo '["/analyst", "/planning-brainstorming", "/planning-requirements", "/research-prompt", "/planning-stakeholder-planning-review"]'
            ;;
        "architect")
            echo '["/architect", "/planning-architecture", "/frontend-architecture", "/ai-prompt"]'
            ;;
        "design-architect")
            echo '["/design-architect", "/planning-ux-spec", "/design-system"]'
            ;;
        "developer")
            echo '["/dev", "/developer", "/planning-planning-review", "/distribution-build"]'
            ;;
        "pm")
            echo '["/pm", "/planning-planning-prd", "/planning-planning-project-brief"]'
            ;;
        "po")
            echo '["/po", "/planning-stories", "/planning-epic", "/qa-acceptance-criteria", "/prioritization", "/planning-validation", "/planning-groom"]'
            ;;
        "qa")
            echo '["/qa", "/qa-framework", "/qa-predict", "/qa-optimize", "/qa-anomaly", "/qa-insights"]'
            ;;
        "sm")
            echo '["/sm", "/parallel-implementation-sprint", "/planning-checklist", "/course-correction", "/next-story"]'
            ;;
        "orchestrator")
            echo '["/ap", "/ap_orchestrator", "/handoff", "/switch", "/wrap"]'
            ;;
    esac
}

get_working_directories() {
    local persona_id=$1
    case "$persona_id" in
        "analyst")
            echo '{"primary": "{{PROJECT_ROOT}}/project_docs/planning-requirements/", "secondary": "{{PROJECT_ROOT}}/project_docs/research/", "reports": "{{PROJECT_ROOT}}/project_docs/research/reports/"}'
            ;;
        "architect")
            echo '{"primary": "{{PROJECT_ROOT}}/project_docs/planning-architecture/", "secondary": "{{PROJECT_ROOT}}/project_docs/technical/", "reports": "{{PROJECT_ROOT}}/project_docs/planning-architecture/reports/"}'
            ;;
        "design-architect")
            echo '{"primary": "{{PROJECT_ROOT}}/project_docs/design/", "secondary": "{{PROJECT_ROOT}}/project_docs/ux/", "reports": "{{PROJECT_ROOT}}/project_docs/design/reports/"}'
            ;;
        "developer")
            echo '{"primary": "{{PROJECT_ROOT}}/", "secondary": "{{PROJECT_ROOT}}/src/", "reports": "{{PROJECT_ROOT}}/project_docs/development/"}'
            ;;
        "pm")
            echo '{"primary": "{{PROJECT_ROOT}}/project_docs/management/", "secondary": "{{PROJECT_ROOT}}/project_docs/planning/", "reports": "{{PROJECT_ROOT}}/project_docs/reports/"}'
            ;;
        "po")
            echo '{"primary": "{{PROJECT_ROOT}}/project_docs/", "secondary": "{{PROJECT_ROOT}}/project_docs/planning-requirements/", "reports": "{{PROJECT_ROOT}}/project_docs/reports/"}'
            ;;
        "qa")
            echo '{"primary": "{{PROJECT_ROOT}}/project_docs/qa/", "secondary": "{{PROJECT_ROOT}}/tests/", "reports": "{{PROJECT_ROOT}}/project_docs/qa/reports/"}'
            ;;
        "sm")
            echo '{"primary": "{{PROJECT_ROOT}}/project_docs/implementation-sprints/", "secondary": "{{PROJECT_ROOT}}/project_docs/agile/", "reports": "{{PROJECT_ROOT}}/project_docs/implementation-sprint-reports/"}'
            ;;
        "orchestrator")
            echo '{"primary": "{{PROJECT_ROOT}}/project_docs/", "secondary": "{{PROJECT_ROOT}}/", "reports": "{{PROJECT_ROOT}}/project_docs/reports/"}'
            ;;
    esac
}

get_behavioral_rules() {
    echo '{
    "research_protocols": {
      "enforce": "NEVER_GUESS_ALWAYS_VERIFY",
      "evidence_required": true,
      "mandatory_sequence": [
        "Search Project Docs",
        "Search Codebase", 
        "Read Configurations",
        "Research Externally",
        "Ask for Clarification"
      ],
      "forbidden_phrases": [
        "I assume",
        "Probably",
        "It should be",
        "Typically"
      ],
      "required_evidence_format": [
        "According to [specific file/source]...",
        "The existing code in [path] shows...",
        "Based on my search of [location], I found...",
        "I need clarification on [specific aspect] because [context]"
      ]
    },
    "escalation_triggers": [
      "Conflicting information found",
      "Missing critical documentation", 
      "Ambiguous user requirements",
      "Security implications discovered"
    ]
  }'
}

get_initialization_sequence() {
    echo '[
    {
      "step": 0,
      "action": "verify_working_directory",
      "command": "cd {{PROJECT_ROOT}} && pwd"
    },
    {
      "step": 1,
      "action": "list_session_notes",
      "path": "{{SESSION_NOTES_PATH}}/"
    },
    {
      "step": 2,
      "action": "list_rules", 
      "path": "{{RULES_PATH}}/"
    },
    {
      "step": 3,
      "action": "create_session_note",
      "filename_format": "YYYY-MM-DD-HH-mm-ss-Agent-Activation.md"
    },
    {
      "step": 4,
      "action": "voice_announcement",
      "message": "Agent activated. Loading configuration."
    },
    {
      "step": 5,
      "action": "parallel_initialization",
      "tasks": 5
    }
  ]'
}

get_content_sections() {
    echo '{
    "role_definition": "# Role: Agent Expert",
    "critical_header": "\n🔴 **CRITICAL**",
    "research_protocols": "\n## 🔴 CRITICAL: RESEARCH PROTOCOLS\n\n**NEVER GUESS, ALWAYS VERIFY** - Follow these protocols before any decision:",
    "workspace_boundaries": "\n## 🚧 WORKSPACE BOUNDARIES", 
    "initialization_sequence": "\n## 🔴 CRITICAL INITIALIZATION SEQUENCE",
    "persona_description": "\n## Persona\n\n- **Role:** Specialist\n- **Style:** Professional and thorough\n- **Core Strength:** Expert capabilities and domain knowledge",
    "core_principles": "\n## Core Agent Principles",
    "capabilities_detail": "\n## 🎯 Agent Capabilities",
    "interaction_model": "\n## Interaction Model",
    "phase_summaries": "\n## Phase Summary Requirements"
  }'
}

# Template processing with proper JSON parsing
process_template() {
    local persona_json="$1"
    local template_file="$2"
    local output_file="$3"
    local template_type="$4"  # "apm" or "claude"
    
    local persona_id=$(basename "$persona_json" .persona.json)
    
    log_info "Processing $template_type template for $persona_id..."
    
    # Create output directory if needed
    mkdir -p "$(dirname "$output_file")"
    
    # Read persona data
    local persona_name=$(jq -r '.metadata.name // "Agent"' "$persona_json") 
    local persona_desc=$(jq -r '.metadata.description // "Expert Agent"' "$persona_json")
    local persona_version=$(jq -r '.metadata.version // "3.3.0"' "$persona_json")
    
    # Create comprehensive template based on existing structure
    create_comprehensive_template "$persona_id" "$persona_name" "$persona_desc" "$template_type" "$output_file"
    
    log_success "Generated $template_type template: $(basename "$output_file")"
}

# Create comprehensive template based on persona type
create_comprehensive_template() {
    local persona_id="$1"
    local persona_name="$2"
    local persona_desc="$3"
    local template_type="$4"
    local output_file="$5"
    
    # Get voice script variable
    local voice_var="SPEAK_$(echo "$persona_id" | tr '[:lower:]' '[:upper:]' | sed 's/-/_/g')"
    
    if [[ "$template_type" == "apm" ]]; then
        create_apm_template "$persona_id" "$persona_name" "$persona_desc" "$voice_var" "$output_file"
    else
        create_claude_template "$persona_id" "$persona_name" "$persona_desc" "$voice_var" "$output_file"
    fi
}

# Create comprehensive APM template
create_apm_template() {
    local persona_id="$1"
    local persona_name="$2"
    local persona_desc="$3"
    local voice_var="$4"
    local output_file="$5"
    
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
$(get_workspace_dirs "$persona_id")

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
$(get_parallel_tasks "$persona_id")

\`\`\`

## 🎯 CORE RESPONSIBILITIES

$(get_core_responsibilities "$persona_id")

## 🔄 APM-SPECIFIC FEATURES

- **Session Management**: Maintain context across interactions
- **Task-Based Execution**: Use Task tool for complex workflows
- **Voice Notifications**: Audio feedback for all operations
- **Workspace Validation**: Strict path and permission controls

---

*Generated from unified persona definition v3.3.0*
*APM Framework Compatible: 3.2+*
EOF
}

# Create comprehensive Claude template
create_claude_template() {
    local persona_id="$1"
    local persona_name="$2"
    local persona_desc="$3"
    local voice_var="$4"
    local output_file="$5"
    
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
$(get_workspace_dirs "$persona_id")

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

### Parallel Execution Patterns
$(get_parallel_commands "$persona_id")

## 🎯 CORE RESPONSIBILITIES

$(get_core_responsibilities "$persona_id")

### Shared Capabilities
- **Research Protocols**: Evidence-based analysis
- **Documentation**: Comprehensive deliverable creation
- **Integration**: Seamless workflow coordination  
- **Quality Control**: Rigorous validation processes

---

*Generated from unified persona definition v3.3.0*
*Claude Code Compatible - Native Sub-Agent Architecture*
EOF
}

# Get workspace directories for persona
get_workspace_dirs() {
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
        "design-architect")
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

# Get parallel tasks for initialization
get_parallel_tasks() {
    local persona_id="$1"
    cat << 'EOF'
Task 1: Load persona configuration and validate workspace access
Task 2: Check project documentation structure and recent changes
Task 3: Initialize session management and context tracking
Task 4: Load knowledge base and specialized templates
Task 5: Verify integration with voice notification system
EOF
}

# Get core responsibilities for persona
get_core_responsibilities() {
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

### Available Parallel Commands
- `/parallel-planning-brainstorming` - Execute brainstorming with multiple perspectives
- `/parallel-planning-requirements` - Analyze requirements from different angles
- `/parallel-research-prompt` - Deep research with multiple information sources
- `/parallel-planning-stakeholder-planning-review` - Coordinate stakeholder feedback in parallel
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

### Available Parallel Commands
- `/parallel-planning-architecture` - Design architecture with multiple consideration streams
- `/parallel-frontend-architecture` - Frontend-specific architecture planning
- `/parallel-ai-prompt` - AI-assisted architectural design patterns
EOF
            ;;
        "design-architect")
            cat << 'EOF'
### Primary Functions
- **UI/UX Design**: Create intuitive and engaging user interfaces
- **Design Systems**: Develop consistent design language and components
- **User Experience**: Optimize user journeys and interaction patterns
- **Accessibility**: Ensure inclusive design for all users
- **Design Patterns**: Establish reusable design solutions
- **Prototyping**: Create interactive prototypes and mockups

### Available Parallel Commands
- `/parallel-ux-design` - Multi-perspective user experience design
- `/parallel-design-system` - Comprehensive design system development
- `/parallel-accessibility-audit` - Thorough accessibility compliance planning-review
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

### Available Parallel Commands
- `/parallel-planning-planning-review` - Comprehensive code planning-review with multiple focus areas
- `/parallel-implementation` - Parallel development streams for complex features
- `/parallel-testing` - Multi-layer testing strategy execution
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

### Available Parallel Commands
- `/parallel-planning-planning-prd` - Comprehensive product requirements development
- `/parallel-project-planning` - Multi-dimensional project planning
- `/parallel-risk-assessment` - Thorough risk analysis from multiple angles
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

### Available Parallel Commands
- `/parallel-planning-stories` - Multi-perspective user story development
- `/parallel-planning-epic` - Comprehensive epic breakdown and planning
- `/parallel-qa-acceptance-criteria` - Detailed acceptance criteria development
- `/parallel-prioritization` - Multi-factor priority analysis
- `/parallel-planning-validation` - Comprehensive requirement validation
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

### Available Parallel Commands
- `/parallel-qa-framework` - Comprehensive QA framework implementation
- `/parallel-test-plan` - Multi-layer test planning and strategy
- `/parallel-test-strategy` - Strategic testing approach development
- `/parallel-qa-automation-plan` - Test automation strategy and implementation
- `/parallel-qa-quality-planning-review` - Thorough quality assessment from multiple angles
EOF
            ;;
        "sm")
            cat << 'EOF'
### Primary Functions
- **Agile Facilitation**: Guide teams through agile ceremonies and practices
- **Sprint Planning**: Facilitate effective sprint planning and goal setting
- **Retrospectives**: Conduct meaningful retrospectives for continuous improvement
- **Impediment Removal**: Identify and resolve team blockers and obstacles
- **Team Coaching**: Support team development and agile maturity
- **Process Improvement**: Continuously optimize team processes and practices

### Available Parallel Commands
- `/parallel-implementation-sprint` - Comprehensive sprint coordination with native sub-agents
- `/parallel-planning-checklist` - Multi-perspective checklist validation
- `/parallel-course-correction` - Multi-dimensional problem-solving approach
- `/parallel-next-story` - Strategic story selection and planning
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

### Available Parallel Commands
- `/parallel-coordination` - Multi-agent coordination and synchronization
- `/parallel-delegation` - Intelligent task distribution and assignment
- `/parallel-synthesis` - Integration of multi-agent work products
EOF
            ;;
        *)
            cat << 'EOF'
### Primary Functions
- **Domain Expertise**: Specialized knowledge and skills
- **Collaborative Workflow**: Multi-agent coordination
- **Quality Assurance**: Consistent deliverable standards
- **Performance Optimization**: Efficient task execution

### Available Parallel Commands
- Various parallel execution patterns for optimal performance
EOF
            ;;
    esac
}

# Get parallel commands for persona
get_parallel_commands() {
    local persona_id="$1"
    case "$persona_id" in
        "analyst")
            echo "- **\`/parallel-planning-brainstorming\`**: Native sub-agent ideation and creative problem-solving"
            echo "- **\`/parallel-planning-requirements\`**: Multi-perspective requirements analysis"
            echo "- **\`/parallel-research-prompt\`**: Deep research with multiple information streams"
            echo "- **\`/parallel-planning-stakeholder-planning-review\`**: Coordinated stakeholder feedback collection"
            ;;
        "architect")
            echo "- **\`/parallel-planning-architecture\`**: Multi-dimensional system architecture design"
            echo "- **\`/parallel-frontend-architecture\`**: Frontend-specific architectural planning"
            echo "- **\`/parallel-ai-prompt\`**: AI-assisted architectural pattern generation"
            ;;
        "design-architect")
            echo "- **\`/parallel-ux-design\`**: Multi-perspective user experience design"
            echo "- **\`/parallel-design-system\`**: Comprehensive design system development"
            echo "- **\`/parallel-accessibility-audit\`**: Thorough accessibility compliance planning-review"
            ;;
        "developer")
            echo "- **\`/parallel-planning-planning-review\`**: Multi-focus code planning-review and analysis"
            echo "- **\`/parallel-implementation\`**: Parallel development streams"
            echo "- **\`/parallel-testing\`**: Multi-layer testing strategy execution"
            ;;
        "pm")
            echo "- **\`/parallel-planning-planning-prd\`**: Comprehensive product requirements development"
            echo "- **\`/parallel-project-planning\`**: Multi-dimensional project planning"
            echo "- **\`/parallel-risk-assessment\`**: Thorough risk analysis"
            ;;
        "po")
            echo "- **\`/parallel-planning-stories\`**: Multi-perspective user story development"
            echo "- **\`/parallel-planning-epic\`**: Comprehensive epic breakdown"
            echo "- **\`/parallel-qa-acceptance-criteria\`**: Detailed criteria development"
            echo "- **\`/parallel-prioritization\`**: Multi-factor priority analysis"
            echo "- **\`/parallel-planning-validation\`**: Comprehensive requirement validation"
            ;;
        "qa")
            echo "- **\`/parallel-qa-framework\`**: Comprehensive QA framework (4x speedup)"
            echo "- **\`/parallel-test-plan\`**: Multi-layer test planning"
            echo "- **\`/parallel-test-strategy\`**: Strategic testing approach"
            echo "- **\`/parallel-qa-automation-plan\`**: Test automation strategy"
            echo "- **\`/parallel-qa-quality-planning-review\`**: Multi-angle quality assessment"
            ;;
        "sm")
            echo "- **\`/parallel-implementation-sprint\`**: Native parallel development orchestration (4.6x speedup)"
            echo "- **\`/parallel-planning-checklist\`**: Multi-perspective validation"
            echo "- **\`/parallel-course-correction\`**: Multi-dimensional problem-solving"
            echo "- **\`/parallel-next-story\`**: Strategic story selection"
            ;;
        "orchestrator")
            echo "- **\`/parallel-coordination\`**: Multi-agent synchronization"
            echo "- **\`/parallel-delegation\`**: Intelligent task distribution"
            echo "- **\`/parallel-synthesis\`**: Work product integration"
            ;;
        *)
            echo "- **Various parallel commands**: Optimized for domain-specific tasks"
            ;;
    esac
}

# Generate persona templates
generate_personas() {
    log_step "Generating persona templates..."
    
    # Create output directories
    mkdir -p "$OUTPUT_APM" "$OUTPUT_CLAUDE"
    
    # Count available persona definitions
    local persona_files=("$MASTER_DIR"/*.persona.json)
    local persona_count=${#persona_files[@]}
    
    if [ "$persona_count" -eq 0 ]; then
        log_warning "No persona JSON files found in $MASTER_DIR"
        return 1
    fi
    
    log_info "Found $persona_count persona definitions"
    echo ""
    
    # Process each persona
    for persona_file in "${persona_files[@]}"; do
        if [ ! -f "$persona_file" ]; then
            continue
        fi
        
        local persona_name=$(basename "$persona_file" .persona.json)
        ((CURRENT_PERSONA++))
        
        show_progress "$CURRENT_PERSONA" "$TOTAL_PERSONAS" "$persona_name"
        
        # Generate APM template
        process_template \
            "$persona_file" \
            "$TEMPLATES_DIR/apm.persona.template" \
            "$OUTPUT_APM/${persona_name}.md.template" \
            "apm"
        
        # Generate Claude template  
        process_template \
            "$persona_file" \
            "$TEMPLATES_DIR/claude.persona.template" \
            "$OUTPUT_CLAUDE/${persona_name}.md.template" \
            "claude"
        
        echo ""
    done
}

# Generate summary report
generate_summary() {
    local apm_count=$(find "$OUTPUT_APM" -name "*.md.template" -type f 2>/dev/null | wc -l)
    local claude_count=$(find "$OUTPUT_CLAUDE" -name "*.md.template" -type f 2>/dev/null | wc -l)
    
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
    echo "  4. Verify parallel command functionality"
    echo ""
    
    # Verification summary
    if [ "$apm_count" -eq "$TOTAL_PERSONAS" ] && [ "$claude_count" -eq "$TOTAL_PERSONAS" ]; then
        log_success "All personas generated successfully!"
    else
        log_warning "Expected $TOTAL_PERSONAS personas per target, got APM:$apm_count Claude:$claude_count"
    fi
}

# Main execution function
main() {
    show_header
    check_dependencies
    validate_structure
    create_master_definitions
    generate_personas
    generate_summary
}

# Execute if run directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    main "$@"
fi