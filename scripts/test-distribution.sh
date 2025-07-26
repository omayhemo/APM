#!/bin/bash

# Distribution Testing Script
# Validates the complete installation process and template system integrity

set -e

# Configuration
DIST_DIR="dist"
TEST_DIR="test-installation"
VALIDATION_FAILED=false

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# Function to run distribution tests
test_distribution() {
    log_info "Starting comprehensive distribution testing..."
    
    # Clean up previous test
    if [[ -d "$TEST_DIR" ]]; then
        log_info "Cleaning previous test directory..."
        rm -rf "$TEST_DIR"
    fi
    
    # Create test directory
    mkdir -p "$TEST_DIR"
    cd "$TEST_DIR"
    
    # Find and extract distribution
    local dist_file=$(find "../$DIST_DIR" -name "apm-v*.tar.gz" | head -1)
    if [[ -z "$dist_file" ]]; then
        log_error "No distribution file found in $DIST_DIR"
        return 1
    fi
    
    log_info "Found distribution: $(basename "$dist_file")"
    log_info "Extracting distribution..."
    tar -xzf "$dist_file"
    
    # Check if files were extracted (tar creates files in current directory)
    if [[ ! -f "templates/install.sh" ]]; then
        log_error "Distribution extraction failed - installer not found"
        return 1
    fi
    
    log_success "Distribution extracted successfully"
    
    # Test 1: Validate distribution structure
    log_info "Test 1: Validating distribution structure..."
    test_distribution_structure
    
    # Test 2: Validate template system
    log_info "Test 2: Validating template system..."
    test_template_system
    
    # Test 3: Test installation process
    log_info "Test 3: Testing installation process..."
    test_installation_process
    
    # Test 4: Validate generated content
    log_info "Test 4: Validating generated content..."
    test_generated_content
    
    # Test 5: Test template regeneration
    log_info "Test 5: Testing template regeneration..."
    test_template_regeneration
    
    # Return to original directory
    cd ../../
    
    if [[ $VALIDATION_FAILED == true ]]; then
        log_error "Distribution testing failed"
        return 1
    else
        log_success "All distribution tests passed"
        return 0
    fi
}

# Test distribution structure
test_distribution_structure() {
    local required_files=(
        "templates/install.sh"
        "templates/templates/agents"
        ".apm/agents"
        ".apm/README.md"
        "VERSION"
        "LICENSE"
    )
    
    for file in "${required_files[@]}"; do
        if [[ ! -e "$file" ]]; then
            log_error "Required file/directory missing: $file"
            VALIDATION_FAILED=true
        fi
    done
    
    if [[ $VALIDATION_FAILED == false ]]; then
        log_success "Distribution structure validation passed"
    fi
}

# Test template system
test_template_system() {
    # Check template count
    local template_count=$(find templates/templates/agents -name "*.template" -type f | wc -l)
    local generated_count=$(find .apm/agents -name "*.md" -type f | wc -l)
    
    if [[ $template_count -eq 0 ]]; then
        log_error "No template files found"
        VALIDATION_FAILED=true
    elif [[ $generated_count -eq 0 ]]; then
        log_error "No generated agent files found"
        VALIDATION_FAILED=true
    else
        log_success "Template system: $template_count templates → $generated_count generated files"
    fi
    
    # Check critical templates
    local critical_templates=(
        "templates/templates/agents/personas/ap_orchestrator.md.template"
        "templates/templates/agents/data/ap-kb.md.template"
        "templates/templates/agents/tasks/create-prd.md.template"
        "templates/templates/agents/checklists/story-dod-checklist.md.template"
    )
    
    for template in "${critical_templates[@]}"; do
        if [[ ! -f "$template" ]]; then
            log_error "Critical template missing: $template"
            VALIDATION_FAILED=true
        fi
    done
    
    if [[ $VALIDATION_FAILED == false ]]; then
        log_success "Template system validation passed"
    fi
}

# Test installation process
test_installation_process() {
    log_info "Testing installation with defaults..."
    
    # Create test target directory with absolute path
    local test_target="$(pwd)/test-install"
    mkdir -p "$test_target"
    
    # Run installer with defaults (defaults flag must be first)
    # Provide input for session notes choice (2 = markdown files)
    if echo -e "test-install\n2\n" | ./templates/install.sh --defaults "$test_target" >/dev/null 2>&1; then
        log_success "Installation completed successfully"
    else
        log_error "Installation failed"
        VALIDATION_FAILED=true
        return 1
    fi
    
    # Validate installation output
    if [[ -d "$test_target/.apm/agents" ]]; then
        log_success "Agents directory created successfully"
    else
        log_error "Agents directory not created"
        VALIDATION_FAILED=true
    fi
    
    # Check file count consistency
    local installed_count=$(find "$test_target/.apm/agents" -name "*.md" -type f | wc -l)
    local source_count=$(find .apm/agents -name "*.md" -type f | wc -l)
    
    if [[ $installed_count -eq $source_count ]]; then
        log_success "Installation file count matches source: $installed_count files"
    else
        log_warning "Installation file count mismatch: $installed_count vs $source_count"
    fi
}

# Test generated content
test_generated_content() {
    # Check for template variable resolution
    local unresolved_vars=$(find .apm/agents -name "*.md" -type f -exec grep -l '{{[^}]*}}' {} \; 2>/dev/null | wc -l)
    
    if [[ $unresolved_vars -gt 0 ]]; then
        log_warning "Found $unresolved_vars files with unresolved template variables"
        if [[ $unresolved_vars -gt 10 ]]; then
            log_error "Too many unresolved template variables"
            VALIDATION_FAILED=true
        fi
    else
        log_success "All template variables resolved correctly"
    fi
    
    # Check essential files exist
    local essential_files=(
        ".apm/agents/personas/ap_orchestrator.md"
        ".apm/agents/data/ap-kb.md"
        ".apm/agents/tasks/create-prd.md"
        ".apm/agents/checklists/story-dod-checklist.md"
    )
    
    for file in "${essential_files[@]}"; do
        if [[ ! -f "$file" ]]; then
            log_error "Essential generated file missing: $file"
            VALIDATION_FAILED=true
        fi
    done
    
    if [[ $VALIDATION_FAILED == false ]]; then
        log_success "Generated content validation passed"
    fi
}

# Test template regeneration
test_template_regeneration() {
    log_info "Testing template regeneration capability..."
    
    # Create test target for regeneration with absolute path
    local regen_target="$(pwd)/test-regeneration"
    mkdir -p "$regen_target"
    
    # Test installer can regenerate (defaults flag must be first)
    # Provide input for session notes choice (2 = markdown files)
    if echo -e "test-regeneration\n2\n" | ./installer/install.sh --defaults "$regen_target" >/dev/null 2>&1; then
        log_success "Template regeneration successful"
    else
        log_error "Template regeneration failed"
        VALIDATION_FAILED=true
        return 1
    fi
    
    # Compare regenerated content with original
    local original_files=$(find .apm/agents -name "*.md" -type f | sort)
    local regen_files=$(find "$regen_target/.apm/agents" -name "*.md" -type f | sed "s|$regen_target/.apm/agents|.apm/agents|g" | sort)
    
    if [[ "$original_files" == "$regen_files" ]]; then
        log_success "Regenerated content matches original"
    else
        log_warning "Regenerated content differs from original"
    fi
}

# Function to show usage
show_usage() {
    cat << EOF
Distribution Testing Script

Usage: $0 [options]

Options:
    --verbose   Enable verbose output
    --clean     Clean test directory before running
    --help      Show this help message

This script validates the complete distribution package including:
- Distribution structure validation
- Template system integrity
- Installation process testing
- Generated content validation
- Template regeneration capability

EOF
}

# Main function
main() {
    local verbose=false
    local clean=false
    
    # Parse options
    while [[ $# -gt 0 ]]; do
        case $1 in
            --verbose)
                verbose=true
                shift
                ;;
            --clean)
                clean=true
                shift
                ;;
            -h|--help)
                show_usage
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
    done
    
    # Clean if requested
    if [[ $clean == true ]]; then
        log_info "Cleaning test directory..."
        rm -rf "$TEST_DIR"
    fi
    
    # Check if we're in the right directory
    if [[ ! -d "$DIST_DIR" ]]; then
        log_error "Must be run from project root (no $DIST_DIR found)"
        exit 1
    fi
    
    # Run distribution tests
    if test_distribution; then
        echo ""
        log_success "🎉 Distribution testing completed successfully!"
        echo ""
        echo "✅ All tests passed - distribution is ready for release"
        exit 0
    else
        echo ""
        log_error "❌ Distribution testing failed"
        echo ""
        echo "Please review the errors above and rebuild the distribution"
        exit 1
    fi
}

# Run main function with all arguments
main "$@"