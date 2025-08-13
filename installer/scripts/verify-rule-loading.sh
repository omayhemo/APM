#!/bin/bash

# Verify that all agent templates have rule loading

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALLER_DIR="$(dirname "$SCRIPT_DIR")"
COMMANDS_DIR="$INSTALLER_DIR/templates/claude/commands"

echo "Verifying Rule Loading in Agent Templates"
echo "=========================================="
echo ""

AGENTS=("po" "sm" "qa" "analyst" "architect" "dev" "developer" "pm" "design-architect" "ap_orchestrator")

for agent in "${AGENTS[@]}"; do
    template="$COMMANDS_DIR/${agent}.md.template"
    
    if [[ ! -f "$template" ]]; then
        echo "✗ $agent - Template not found"
        continue
    fi
    
    if grep -q "Load and read ALL mandatory rules\|Load_Mandatory_Rules" "$template"; then
        echo "✓ $agent - Has rule loading task"
    else
        echo "✗ $agent - Missing rule loading task"
    fi
    
    if grep -q "MANDATORY RULE COMPLIANCE" "$template"; then
        echo "  ✓ Has enforcement section"
    else
        echo "  ✗ Missing enforcement section"
    fi
    echo ""
done
