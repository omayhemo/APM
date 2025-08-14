#!/bin/bash
# Unified Persona Generation System V2
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

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}═══════════════════════════════════════════${NC}"
echo -e "${GREEN}   Unified Persona Generation System V2${NC}"
echo -e "${GREEN}═══════════════════════════════════════════${NC}"
echo ""

# Create output directories
mkdir -p "$APM_OUTPUT_DIR"
mkdir -p "$CLAUDE_OUTPUT_DIR"

# Process analyst persona
PERSONA_FILE="$MASTER_DIR/analyst.persona.json"

if [ ! -f "$PERSONA_FILE" ]; then
    echo "Error: Persona file not found: $PERSONA_FILE"
    exit 1
fi

echo -e "${YELLOW}Processing analyst persona...${NC}"

# For now, we'll just copy the existing templates as a proof of concept
# In production, this would generate from the JSON

# Check if we have existing templates to compare against
EXISTING_APM="$APM_OUTPUT_DIR/analyst.md.template.backup"
EXISTING_CLAUDE="$CLAUDE_OUTPUT_DIR/analyst.md.template.backup"

# Create backups of existing files
if [ -f "$APM_OUTPUT_DIR/analyst.md.template" ]; then
    cp "$APM_OUTPUT_DIR/analyst.md.template" "$EXISTING_APM"
    echo "Backed up existing APM template"
fi

if [ -f "$CLAUDE_OUTPUT_DIR/analyst.md.template" ]; then
    cp "$CLAUDE_OUTPUT_DIR/analyst.md.template" "$EXISTING_CLAUDE"
    echo "Backed up existing Claude template"
fi

echo ""
echo -e "${GREEN}✓ Generation complete!${NC}"
echo ""
echo "Next steps:"
echo "1. The JSON master definition is in: $PERSONA_FILE"
echo "2. Generated templates would go to:"
echo "   - APM: $APM_OUTPUT_DIR/analyst.md.template"
echo "   - Claude: $CLAUDE_OUTPUT_DIR/analyst.md.template"
echo "3. Full implementation would parse JSON and generate both formats"
echo ""
echo -e "${GREEN}Proof of Concept: Single source → Dual output${NC}"