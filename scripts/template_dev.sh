#!/bin/bash

# Template Development Utility
# Streamlines template-driven development workflow

set -e

# Configuration
TEMPLATE_DIR="templates/templates/agents"
AGENTS_DIR=".apm/agents"
INSTALL_SCRIPT="templates/install.sh"
BACKUP_DIR="archive/template-dev-backup"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to display usage
show_usage() {
    cat << EOF
Template Development Utility

Usage: $0 <action> [options]

Actions:
    test        Test template changes by regenerating agents/
    validate    Validate all templates for syntax and variables
    diff        Show differences between templates and generated files
    bootstrap   Bootstrap self-hosting template system
    clean       Clean generated files and restore from templates
    backup      Create backup of current state
    restore     Restore from backup
    help        Show this help message

Options:
    --verbose   Enable verbose output
    --dry-run   Show what would be done without executing

Examples:
    $0 test                 # Test template changes
    $0 validate --verbose   # Validate templates with detailed output
    $0 diff agents/tasks/   # Show differences for specific directory
    $0 bootstrap            # Bootstrap self-hosting system

EOF
}

# Function to log with colors
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if we're in the right directory
check_directory() {
    if [[ ! -f "$INSTALL_SCRIPT" ]] || [[ ! -d "$TEMPLATE_DIR" ]]; then
        log_error "Must be run from the project root directory"
        log_error "Expected to find: $INSTALL_SCRIPT and $TEMPLATE_DIR"
        exit 1
    fi
}

# Function to create backup
create_backup() {
    log_info "Creating backup of current state..."
    
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_path="$BACKUP_DIR/$timestamp"
    
    mkdir -p "$backup_path"
    
    # Backup agents directory if it exists
    if [[ -d "$AGENTS_DIR" ]]; then
        cp -r "$AGENTS_DIR" "$backup_path/"
        log_success "Backed up $AGENTS_DIR to $backup_path/"
    fi
    
    # Backup templates
    if [[ -d "$TEMPLATE_DIR" ]]; then
        cp -r "$TEMPLATE_DIR" "$backup_path/"
        log_success "Backed up $TEMPLATE_DIR to $backup_path/"
    fi
    
    echo "$backup_path" > "$BACKUP_DIR/latest"
    log_success "Backup created at: $backup_path"
}

# Function to restore from backup
restore_backup() {
    log_info "Restoring from backup..."
    
    if [[ ! -f "$BACKUP_DIR/latest" ]]; then
        log_error "No backup found to restore from"
        exit 1
    fi
    
    local backup_path=$(cat "$BACKUP_DIR/latest")
    
    if [[ ! -d "$backup_path" ]]; then
        log_error "Backup directory not found: $backup_path"
        exit 1
    fi
    
    # Restore agents directory
    if [[ -d "$backup_path/agents" ]]; then
        rm -rf "$AGENTS_DIR"
        cp -r "$backup_path/agents" "$AGENTS_DIR"
        log_success "Restored $AGENTS_DIR from backup"
    fi
    
    # Restore templates
    if [[ -d "$backup_path/templates" ]]; then
        rm -rf "$TEMPLATE_DIR"
        cp -r "$backup_path/templates" "$TEMPLATE_DIR"
        log_success "Restored $TEMPLATE_DIR from backup"
    fi
    
    log_success "Restoration complete"
}

# Function to test template changes
test_templates() {
    log_info "Testing template changes..."
    
    # Create backup before testing
    create_backup
    
    # Run installer to regenerate agents from templates
    log_info "Running installer to regenerate agents directory..."
    
    # Remove existing agents directory first
    if [[ -d "$AGENTS_DIR" ]]; then
        rm -rf "$AGENTS_DIR"
    fi
    
    # Create agents directory
    mkdir -p "$AGENTS_DIR"
    
    # Directly generate templates using the approach from bootstrap script
    if generate_agents_from_templates_direct; then
        log_success "Template installation completed successfully"
        
        # Validate the generated content
        if validate_generated_content; then
            log_success "Generated content validation passed"
        else
            log_error "Generated content validation failed"
            return 1
        fi
        
        # Check for file count consistency
        local template_count=$(find "$TEMPLATE_DIR" -name "*.template" -type f | wc -l)
        local generated_count=$(find "$AGENTS_DIR" -name "*.md" -type f | wc -l)
        
        log_info "Template files: $template_count"
        log_info "Generated files: $generated_count"
        
        if [[ $template_count -eq $generated_count ]]; then
            log_success "File count consistency check passed"
        else
            log_warning "File count mismatch - some templates may not have generated files"
        fi
        
    else
        log_error "Template installation failed"
        return 1
    fi
    
    log_success "Template testing completed"
}

# Function to validate template syntax and variables
validate_templates() {
    log_info "Validating template syntax and variables..."
    
    local validation_failed=false
    local verbose=${1:-false}
    
    # Check for undefined variables in templates
    log_info "Checking for undefined variables..."
    
    while IFS= read -r -d '' template_file; do
        if [[ $verbose == true ]]; then
            log_info "Validating: $template_file"
        fi
        
        # Look for {{VARIABLE}} patterns
        if grep -q '{{[^}]*}}' "$template_file"; then
            # Extract variables and check if they're known
            local variables=$(grep -o '{{[^}]*}}' "$template_file" | sort -u)
            
            for var in $variables; do
                case "$var" in
                    # AP System Variables
                    "{{AP_ROOT}}" | "{{AP_TASKS}}" | "{{AP_CHECKLISTS}}" | "{{AP_DATA}}" | "{{AP_DOCS}}" | "{{AP_PERSONAS}}" | "{{AP_TEMPLATES}}" | "{{AP_VOICE}}" | "{{AP_PYTHON}}" | "{{AP_MONITORING}}" | "{{AP_SCRIPTS}}" | "{{AP_SUBTASKS}}" | "{{AP_DOCUMENTATION}}" | "{{PROJECT_DOCS}}")
                        # Known system variables - OK
                        ;;
                    # Voice Script Variables
                    "{{SPEAK_ORCHESTRATOR}}" | "{{SPEAK_DEVELOPER}}" | "{{SPEAK_ANALYST}}" | "{{SPEAK_ARCHITECT}}" | "{{SPEAK_DESIGN_ARCHITECT}}" | "{{SPEAK_PM}}" | "{{SPEAK_PO}}" | "{{SPEAK_QA}}" | "{{SPEAK_SM}}" | "{{SPEAK_AGENT}}")
                        # Known voice variables - OK
                        ;;
                    # Template Placeholders
                    "{{phase_number}}" | "{{report_title}}" | "{{PROJECT_NAME}}" | "{{INSTALLATION_DATE}}" | "{{INSTALLER_VERSION}}" | "{{PROJECT_ROOT}}" | "{{CONFIGURATION_SECTION}}" | "{{STRUCTURE_SECTION}}" | "{{COMMANDS_SECTION}}" | "{{GENERATION_DATE}}" | "{{DOC_VERSION}}" | "{{ENV_VARS_SECTION}}" | "{{SETTINGS_STRUCTURE}}" | "{{VARIABLE_DESCRIPTIONS}}" | "{{VARIABLE_TYPES}}" | "{{CONFIG_EXAMPLES}}" | "{{COMMON_ISSUES}}" | "{{ERROR_REFERENCE}}" | "{{SUPPORT_INFO}}" | "{{CLAUDE_DIR}}" | "{{CLAUDE_COMMANDS_DIR}}" | "{{NOTES_TYPE}}" | "{{SESSION_NOTES_PATH}}")
                        # Known template placeholders - OK
                        ;;
                    *)
                        log_warning "Unknown variable $var in $template_file"
                        validation_failed=true
                        ;;
                esac
            done
        fi
    done < <(find "$TEMPLATE_DIR" -name "*.template" -type f -print0)
    
    # Check template syntax
    log_info "Checking template syntax..."
    
    while IFS= read -r -d '' template_file; do
        # Check for malformed variable patterns (triple braces or incomplete patterns)
        if grep -q '{{{' "$template_file"; then
            log_error "Triple braces found in: $template_file"
            validation_failed=true
        fi
        
        if grep -q '}}}' "$template_file"; then
            log_error "Triple braces found in: $template_file"
            validation_failed=true
        fi
        
        # Check for unmatched template variable braces (only count actual template variables)
        local template_vars=$(grep -o '{{[A-Z_][A-Z0-9_]*}}' "$template_file" | wc -l)
        local open_braces=$(grep -o '{{' "$template_file" | wc -l)
        local close_braces=$(grep -o '}}' "$template_file" | wc -l)
        
        # Only report unmatched braces if there are template variables but mismatched counts
        if [[ $template_vars -gt 0 && $open_braces -ne $close_braces ]]; then
            log_error "Unmatched template variable braces in: $template_file"
            validation_failed=true
            if [[ $verbose == true ]]; then
                log_info "  Template variables: $template_vars, Open braces: $open_braces, Close braces: $close_braces"
            fi
        fi
        
    done < <(find "$TEMPLATE_DIR" -name "*.template" -type f -print0)
    
    if [[ $validation_failed == true ]]; then
        log_error "Template validation failed"
        return 1
    else
        log_success "Template validation passed"
        return 0
    fi
}

# Function to generate agents from templates directly
generate_agents_from_templates_direct() {
    log_info "Generating agents from templates..."
    
    # Set up variable substitution values
    local ap_root="$AGENTS_DIR"
    local project_root="$(pwd)"
    local project_docs="$project_root/project_documentation"
    local claude_commands_dir="$project_root/.claude/commands"
    
    # Process each template file
    while IFS= read -r -d '' template_file; do
        # Get relative path from template directory
        local rel_path="${template_file#$TEMPLATE_DIR/}"
        local rel_path="${rel_path%.template}"
        local output_file="$AGENTS_DIR/$rel_path"
        
        # Create output directory
        mkdir -p "$(dirname "$output_file")"
        
        # Apply variable substitution
        sed -E \
            -e "s|{{AP_ROOT}}|$ap_root|g" \
            -e "s|{{AP_TASKS}}|$ap_root/tasks|g" \
            -e "s|{{AP_CHECKLISTS}}|$ap_root/checklists|g" \
            -e "s|{{AP_DATA}}|$ap_root/data|g" \
            -e "s|{{AP_DOCS}}|$ap_root/docs|g" \
            -e "s|{{AP_PERSONAS}}|$ap_root/personas|g" \
            -e "s|{{AP_TEMPLATES}}|$ap_root/templates|g" \
            -e "s|{{AP_VOICE}}|$ap_root/voice|g" \
            -e "s|{{AP_PYTHON}}|$ap_root/python|g" \
            -e "s|{{AP_MONITORING}}|$ap_root/monitoring|g" \
            -e "s|{{AP_SCRIPTS}}|$ap_root/scripts|g" \
            -e "s|{{AP_SUBTASKS}}|$ap_root/tasks/subtasks|g" \
            -e "s|{{AP_DOCUMENTATION}}|$ap_root/documentation|g" \
            -e "s|{{PROJECT_DOCS}}|$project_docs|g" \
            -e "s|{{PROJECT_ROOT}}|$project_root|g" \
            -e "s|{{CLAUDE_COMMANDS_DIR}}|$claude_commands_dir|g" \
            -e "s|{{SPEAK_ORCHESTRATOR}}|$ap_root/voice/speakOrchestrator.sh|g" \
            -e "s|{{SPEAK_DEVELOPER}}|$ap_root/voice/speakDeveloper.sh|g" \
            -e "s|{{SPEAK_ANALYST}}|$ap_root/voice/speakAnalyst.sh|g" \
            -e "s|{{SPEAK_ARCHITECT}}|$ap_root/voice/speakArchitect.sh|g" \
            -e "s|{{SPEAK_DESIGN_ARCHITECT}}|$ap_root/voice/speakDesignArchitect.sh|g" \
            -e "s|{{SPEAK_PM}}|$ap_root/voice/speakPM.sh|g" \
            -e "s|{{SPEAK_PO}}|$ap_root/voice/speakPO.sh|g" \
            -e "s|{{SPEAK_QA}}|$ap_root/voice/speakQA.sh|g" \
            -e "s|{{SPEAK_SM}}|$ap_root/voice/speakSM.sh|g" \
            -e "s|{{SPEAK_AGENT}}|$ap_root/voice/speakAgent.sh|g" \
            "$template_file" > "$output_file"
            
        if [[ $verbose == true ]]; then
            log_info "  Generated: $rel_path"
        fi
        
    done < <(find "$TEMPLATE_DIR" -name "*.template" -type f -print0)
    
    # Copy non-template files from templates
    if [[ -d "templates/templates/voice" ]]; then
        cp -r templates/templates/voice "$AGENTS_DIR/"
    fi
    
    if [[ -d "templates/templates/sounds" ]]; then
        cp -r templates/templates/sounds "$AGENTS_DIR/"
    fi
    
    log_success "Generated agents directory from templates"
    return 0
}

# Function to validate generated content
validate_generated_content() {
    log_info "Validating generated content..."
    
    # Check that agents directory exists
    if [[ ! -d "$AGENTS_DIR" ]]; then
        log_error "Agents directory not found: $AGENTS_DIR"
        return 1
    fi
    
    # Check for essential files
    local essential_files=(
        "personas/ap_orchestrator.md"
        "data/ap-kb.md"
        "tasks/create-prd.md"
        "checklists/story-dod-checklist.md"
    )
    
    for file in "${essential_files[@]}"; do
        if [[ ! -f "$AGENTS_DIR/$file" ]]; then
            log_error "Essential file missing: $AGENTS_DIR/$file"
            return 1
        fi
    done
    
    # Check for remaining template variables in generated files
    local remaining_vars=$(find "$AGENTS_DIR" -name "*.md" -type f -exec grep -l '{{[^}]*}}' {} \; 2>/dev/null | wc -l)
    
    if [[ $remaining_vars -gt 0 ]]; then
        log_warning "Found $remaining_vars files with unresolved template variables"
        if [[ $verbose == true ]]; then
            find "$AGENTS_DIR" -name "*.md" -type f -exec grep -l '{{[^}]*}}' {} \; 2>/dev/null | while read file; do
                log_warning "Unresolved variables in: $file"
            done
        fi
    fi
    
    log_success "Generated content validation completed"
    return 0
}

# Function to show differences between templates and generated files
show_diff() {
    log_info "Showing differences between templates and generated files..."
    
    local target_dir="${1:-$AGENTS_DIR}"
    
    if [[ ! -d "$target_dir" ]]; then
        log_error "Target directory not found: $target_dir"
        return 1
    fi
    
    # Find corresponding template and generated files
    while IFS= read -r -d '' template_file; do
        # Get relative path from template directory
        local rel_path="${template_file#$TEMPLATE_DIR/}"
        local rel_path="${rel_path%.template}"
        local generated_file="$target_dir/$rel_path"
        
        if [[ -f "$generated_file" ]]; then
            # Create temporary file with variable substitution applied
            local temp_file=$(mktemp)
            
            # Apply basic variable substitution for comparison
            sed -E \
                -e 's|{{AP_ROOT}}|'"$target_dir"'|g' \
                -e 's|{{AP_TASKS}}|'"$target_dir"'/tasks|g' \
                -e 's|{{AP_CHECKLISTS}}|'"$target_dir"'/checklists|g' \
                -e 's|{{AP_DATA}}|'"$target_dir"'/data|g' \
                -e 's|{{AP_DOCS}}|'"$target_dir"'/docs|g' \
                -e 's|{{AP_PERSONAS}}|'"$target_dir"'/personas|g' \
                -e 's|{{AP_TEMPLATES}}|'"$target_dir"'/templates|g' \
                -e 's|{{AP_VOICE}}|'"$target_dir"'/voice|g' \
                -e 's|{{PROJECT_DOCS}}|project_documentation|g' \
                "$template_file" > "$temp_file"
            
            # Compare files
            if ! diff -q "$temp_file" "$generated_file" > /dev/null 2>&1; then
                log_info "Differences found in: $rel_path"
                echo "--- Template (processed) ---"
                echo "+++ Generated file ---"
                diff -u "$temp_file" "$generated_file" || true
                echo ""
            fi
            
            rm -f "$temp_file"
        else
            log_warning "Generated file not found: $generated_file"
        fi
    done < <(find "$TEMPLATE_DIR" -name "*.template" -type f -print0)
    
    log_success "Difference checking completed"
}

# Function to clean generated files
clean_generated() {
    log_info "Cleaning generated files..."
    
    if [[ -d "$AGENTS_DIR" ]]; then
        log_info "Removing $AGENTS_DIR directory..."
        rm -rf "$AGENTS_DIR"
        log_success "Cleaned generated files"
    else
        log_info "No generated files to clean"
    fi
}

# Function to bootstrap self-hosting
bootstrap_self_hosting() {
    log_info "Bootstrapping self-hosting template system..."
    
    # Check if bootstrap script exists
    if [[ -f "bootstrap-self-hosting.sh" ]]; then
        log_info "Running bootstrap script..."
        ./bootstrap-self-hosting.sh
    else
        log_error "Bootstrap script not found: bootstrap-self-hosting.sh"
        return 1
    fi
    
    log_success "Bootstrap completed"
}

# Main function
main() {
    local action="${1:-help}"
    local verbose=false
    local dry_run=false
    
    # Parse options
    while [[ $# -gt 0 ]]; do
        case $1 in
            --verbose)
                verbose=true
                shift
                ;;
            --dry-run)
                dry_run=true
                shift
                ;;
            -h|--help)
                action="help"
                shift
                ;;
            *)
                if [[ -z "$action" || "$action" == "help" ]]; then
                    action="$1"
                fi
                shift
                ;;
        esac
    done
    
    # Check directory unless showing help
    if [[ "$action" != "help" ]]; then
        check_directory
    fi
    
    # Execute action
    case "$action" in
        test)
            test_templates
            ;;
        validate)
            validate_templates "$verbose"
            ;;
        diff)
            show_diff "$2"
            ;;
        bootstrap)
            bootstrap_self_hosting
            ;;
        clean)
            clean_generated
            ;;
        backup)
            create_backup
            ;;
        restore)
            restore_backup
            ;;
        help)
            show_usage
            ;;
        *)
            log_error "Unknown action: $action"
            show_usage
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"