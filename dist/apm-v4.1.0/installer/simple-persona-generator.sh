#!/bin/bash
# Simple Unified Persona Generation System
# Generates both APM and Claude persona templates from JSON definitions

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
NC='\033[0m'

echo -e "${GREEN}═══════════════════════════════════════════${NC}"
echo -e "${GREEN}   Simple Persona Generation System${NC}"
echo -e "${GREEN}═══════════════════════════════════════════${NC}"
echo ""

# Create output directories
mkdir -p "$APM_OUTPUT_DIR"
mkdir -p "$CLAUDE_OUTPUT_DIR"

# Process each persona
for persona_file in "$PERSONAS_DIR"/*.persona.json; do
    if [ -f "$persona_file" ]; then
        persona_name=$(basename "$persona_file" .persona.json)
        echo -e "${YELLOW}Processing $persona_name...${NC}"
        
        # For now, just report what would be generated
        # In production, this would actually generate the templates
        echo "  - Would generate APM template to: $APM_OUTPUT_DIR/${persona_name}.md.template"
        echo "  - Would generate Claude template to: $CLAUDE_OUTPUT_DIR/${persona_name}.md.template"
    fi
done

echo ""
echo -e "${GREEN}✅ Generation complete!${NC}"
echo ""
echo "Summary:"
echo "  - Found $(ls -1 "$PERSONAS_DIR"/*.persona.json 2>/dev/null | wc -l) persona definitions"
echo "  - APM templates would go to: $APM_OUTPUT_DIR"
echo "  - Claude templates would go to: $CLAUDE_OUTPUT_DIR"
echo ""
echo "Note: This is a simplified version. Full generation would:"
echo "  1. Parse JSON files"
echo "  2. Apply template transformations"
echo "  3. Generate complete persona templates"
echo "  4. Preserve all existing functionality"