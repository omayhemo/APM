#!/bin/bash

# Unified Persona Generator v1.0
# Generates both APM and Claude deployment targets from master persona definitions
# Eliminates duplication and ensures consistency

set -e

PERSONA_GENERATOR_VERSION="1.0.0"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$(dirname "$SCRIPT_DIR")"
MASTER_DIR="$BASE_DIR/_master"
TEMPLATES_DIR="$BASE_DIR/_templates"
OUTPUT_APM="$(dirname "$BASE_DIR")/templates/agents/personas"
OUTPUT_CLAUDE="$(dirname "$BASE_DIR")/templates/claude/agents/personas"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "=========================================="
echo "  Unified Persona Generator v$PERSONA_GENERATOR_VERSION"
echo "=========================================="
echo ""

# Check dependencies
check_dependencies() {
    local missing_deps=()
    
    if ! command -v yq >/dev/null 2>&1; then
        missing_deps+=("yq")
    fi
    
    if ! command -v envsubst >/dev/null 2>&1; then
        missing_deps+=("envsubst")
    fi
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        echo -e "${RED}❌ Missing dependencies: ${missing_deps[*]}${NC}"
        echo ""
        echo "Install missing dependencies:"
        echo "  Ubuntu/Debian: sudo apt-get install yq gettext"
        echo "  macOS: brew install yq gettext"
        echo "  RHEL/CentOS: sudo yum install yq gettext"
        exit 1
    fi
}

# Validate directory structure
validate_structure() {
    local errors=()
    
    if [ ! -d "$MASTER_DIR" ]; then
        errors+=("Master directory not found: $MASTER_DIR")
    fi
    
    if [ ! -d "$TEMPLATES_DIR" ]; then
        errors+=("Templates directory not found: $TEMPLATES_DIR")
    fi
    
    if [ ! -f "$TEMPLATES_DIR/apm.persona.template" ]; then
        errors+=("APM template not found: $TEMPLATES_DIR/apm.persona.template")
    fi
    
    if [ ! -f "$TEMPLATES_DIR/claude.persona.template" ]; then
        errors+=("Claude template not found: $TEMPLATES_DIR/claude.persona.template")
    fi
    
    if [ ${#errors[@]} -gt 0 ]; then
        echo -e "${RED}❌ Structure validation failed:${NC}"
        for error in "${errors[@]}"; do
            echo "   - $error"
        done
        exit 1
    fi
    
    echo -e "${GREEN}✅ Directory structure validated${NC}"
}

# Generate persona for specific target
generate_persona() {
    local persona_file="$1"
    local target="$2"  # "apm" or "claude"
    local output_dir="$3"
    
    local persona_name=$(basename "$persona_file" .persona.yaml)
    local template_file="$TEMPLATES_DIR/${target}.persona.template"
    local output_file="$output_dir/${persona_name}.md.template"
    
    echo -e "${BLUE}Generating ${target^^} persona: ${persona_name}${NC}"
    
    # Create output directory if it doesn't exist
    mkdir -p "$output_dir"
    
    # Extract persona data and process template
    # This is a simplified version - in practice, we'd use a proper template engine
    # like Jinja2 or a custom processor that can handle the YAML structure
    
    # For now, create a basic implementation that demonstrates the concept
    local temp_data=$(mktemp)
    yq eval '.' "$persona_file" > "$temp_data"
    
    # Basic template processing (would be more sophisticated in real implementation)
    cp "$template_file" "$output_file"
    
    # Replace basic persona data
    local persona_name_value=$(yq eval '.persona.name' "$persona_file")
    local persona_role_value=$(yq eval '.persona.role' "$persona_file")
    local persona_version_value=$(yq eval '.persona.version' "$persona_file")
    
    sed -i.bak "s/\${persona.name}/$persona_name_value/g" "$output_file"
    sed -i.bak "s/\${persona.role}/$persona_role_value/g" "$output_file"
    sed -i.bak "s/\${persona.version}/$persona_version_value/g" "$output_file"
    
    # Clean up backup file
    rm -f "$output_file.bak"
    
    # Clean up temp file
    rm -f "$temp_data"
    
    echo -e "   ${GREEN}✅ Generated: ${output_file}${NC}"
}

# Main execution
main() {
    echo "Checking dependencies..."
    check_dependencies
    echo ""
    
    echo "Validating structure..."
    validate_structure
    echo ""
    
    # Count persona files
    local persona_count=$(find "$MASTER_DIR" -name "*.persona.yaml" -type f | wc -l)
    if [ "$persona_count" -eq 0 ]; then
        echo -e "${YELLOW}⚠️  No persona files found in $MASTER_DIR${NC}"
        exit 0
    fi
    
    echo -e "${BLUE}Found $persona_count persona definitions${NC}"
    echo ""
    
    # Create output directories
    mkdir -p "$OUTPUT_APM" "$OUTPUT_CLAUDE"
    
    # Generate personas for both targets
    echo "Generating APM personas..."
    for persona_file in "$MASTER_DIR"/*.persona.yaml; do
        generate_persona "$persona_file" "apm" "$OUTPUT_APM"
    done
    echo ""
    
    echo "Generating Claude personas..."  
    for persona_file in "$MASTER_DIR"/*.persona.yaml; do
        generate_persona "$persona_file" "claude" "$OUTPUT_CLAUDE"
    done
    echo ""
    
    # Summary
    local apm_count=$(find "$OUTPUT_APM" -name "*.md.template" -type f | wc -l)
    local claude_count=$(find "$OUTPUT_CLAUDE" -name "*.md.template" -type f | wc -l)
    
    echo "=========================================="
    echo "  Generation Complete"
    echo "=========================================="
    echo -e "${GREEN}✅ APM personas generated: $apm_count${NC}"
    echo -e "${GREEN}✅ Claude personas generated: $claude_count${NC}"
    echo -e "${BLUE}📁 APM output: $OUTPUT_APM${NC}"
    echo -e "${BLUE}📁 Claude output: $OUTPUT_CLAUDE${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Review generated templates"
    echo "2. Test with installer script"
    echo "3. Validate both deployment targets"
    echo ""
}

# Check if running directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    main "$@"
fi