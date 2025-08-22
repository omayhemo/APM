#!/bin/bash
# Simplified Persona Generation System for APM Installer
# Generates Claude subagent files and APM persona files from _master templates

set -euo pipefail

# Script configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PERSONAS_DIR="$(dirname "$SCRIPT_DIR")"
MASTER_DIR="$PERSONAS_DIR/_master"
TEMPLATE_DIR="$PERSONAS_DIR/_templates"
CLAUDE_TEMPLATE="$TEMPLATE_DIR/claude.persona.template"

# Target directories (passed as arguments or defaults)
TARGET_ROOT="${1:-/tmp/apm-install-test}"
CLAUDE_OUTPUT_DIR="$TARGET_ROOT/.claude/agents"
APM_OUTPUT_DIR="$TARGET_ROOT/.apm/agents/personas"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'  
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Logging functions
log_info() { echo -e "${BLUE}ℹ${NC} $*"; }
log_success() { echo -e "${GREEN}✅${NC} $*"; }
log_warning() { echo -e "${YELLOW}⚠️${NC} $*"; }
log_error() { echo -e "${RED}❌${NC} $*"; }

# Header
echo ""
echo -e "${GREEN}═══════════════════════════════════════════${NC}"
echo -e "${GREEN}   APM Simplified Persona Generation${NC}"
echo -e "${GREEN}═══════════════════════════════════════════${NC}"
echo ""

# Validate inputs
if [ ! -d "$MASTER_DIR" ]; then
    log_error "Master directory not found: $MASTER_DIR"
    exit 1
fi

if [ ! -f "$CLAUDE_TEMPLATE" ]; then
    log_error "Claude template not found: $CLAUDE_TEMPLATE"
    exit 1
fi

# Create target directories
log_info "Creating target directories..."
mkdir -p "$CLAUDE_OUTPUT_DIR"
mkdir -p "$APM_OUTPUT_DIR"

# Extract persona name and description from template file
extract_persona_info() {
    local template_file="$1"
    local role_line=$(grep -m1 "^# Role:" "$template_file" || echo "")
    
    if [ -z "$role_line" ]; then
        echo "Unknown Agent|Generic Agent Description"
        return
    fi
    
    # Extract name and description from "# Role: Name - Description" or "# Role: Name"
    local full_role="${role_line#\# Role: }"
    
    if [[ "$full_role" == *" - "* ]]; then
        local name="${full_role%% - *}"
        local description="${full_role#* - }"
        echo "$name|$description"
    else
        echo "$full_role|$full_role"
    fi
}

# Generate Claude subagent file from master template
generate_claude_subagent() {
    local master_file="$1"
    local base_name=$(basename "$master_file" .md.template)
    local output_file="$CLAUDE_OUTPUT_DIR/${base_name}.md"
    
    log_info "Generating Claude subagent: ${base_name}.md"
    
    # Extract persona information
    local persona_info=$(extract_persona_info "$master_file")
    local persona_name="${persona_info%|*}"
    local persona_desc="${persona_info#*|}"
    
    # Generate the Claude subagent file
    {
        echo "---"
        echo "name: $persona_name"
        echo "description: $persona_desc"
        echo "---"
        echo ""
        cat "$master_file"
    } > "$output_file"
    
    log_success "Created: $output_file"
}

# Generate APM persona file from master template
generate_apm_persona() {
    local master_file="$1"
    local base_name=$(basename "$master_file" .md.template)
    local output_file="$APM_OUTPUT_DIR/${base_name}.md"
    
    log_info "Generating APM persona: ${base_name}.md"
    
    # For APM personas, we just copy the master file (removing .template extension)
    cp "$master_file" "$output_file"
    
    log_success "Created: $output_file"
}

# Clean up obsolete files and directories in Claude agents
cleanup_obsolete_claude_files() {
    log_info "Cleaning up obsolete Claude agents files..."
    
    # Obsolete directories to remove
    local obsolete_dirs=(
        "chaining"
        "context" 
        "coordination"
        "documentation"
        "dual-mode"
        "implementation-sprint-coordination"
        "migration"
        "monitoring"
        "qa-framework"
        "sprint-coordination"
        "user-guide"
        "voice"
    )
    
    # Obsolete files to remove
    local obsolete_files=(
        "parallel-execution-patterns.md"
        "synthesis-patterns.md"
        "task-coordination.md"
    )
    
    # Remove obsolete directories
    for dir in "${obsolete_dirs[@]}"; do
        if [ -d "$CLAUDE_OUTPUT_DIR/$dir" ]; then
            log_warning "Removing obsolete directory: $dir"
            rm -rf "$CLAUDE_OUTPUT_DIR/$dir"
        fi
    done
    
    # Remove obsolete files  
    for file in "${obsolete_files[@]}"; do
        if [ -f "$CLAUDE_OUTPUT_DIR/$file" ]; then
            log_warning "Removing obsolete file: $file"
            rm -f "$CLAUDE_OUTPUT_DIR/$file"
        fi
    done
    
    log_success "Cleanup completed"
}

# Process all persona templates
log_info "Processing persona templates in: $MASTER_DIR"
processed_count=0

for template_file in "$MASTER_DIR"/*.md.template; do
    if [ ! -f "$template_file" ]; then
        continue
    fi
    
    base_name=$(basename "$template_file" .md.template)
    
    # Skip ap_orchestrator as it's a reference file
    if [ "$base_name" = "ap_orchestrator" ]; then
        log_warning "Skipping reference file: $base_name"
        continue
    fi
    
    echo ""
    log_info "Processing: $base_name"
    
    # Generate both Claude subagent and APM persona files
    generate_claude_subagent "$template_file"
    generate_apm_persona "$template_file"
    
    processed_count=$((processed_count + 1))
done

# Clean up obsolete files
echo ""
cleanup_obsolete_claude_files

# Summary
echo ""
echo -e "${GREEN}═══════════════════════════════════════════${NC}"
echo -e "${GREEN}          Generation Complete!${NC}" 
echo -e "${GREEN}═══════════════════════════════════════════${NC}"
echo ""
echo "Summary:"
echo "  - Templates processed: $processed_count"
echo "  - Claude subagents created in: $CLAUDE_OUTPUT_DIR"
echo "  - APM personas created in: $APM_OUTPUT_DIR"
echo "  - Obsolete files cleaned up"
echo ""
log_success "Simplified persona generation completed successfully!"