#!/bin/bash

# Phase 3: Identify remaining commands without persona activation

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALLER_DIR="$(dirname "$SCRIPT_DIR")"
TEMPLATES_DIR="$INSTALLER_DIR/templates/claude/commands"

echo "================================================"
echo "Phase 3: Identifying Remaining Commands"
echo "================================================"
echo ""

echo "Commands WITHOUT Persona Activation:"
echo "-------------------------------------"

cd "$TEMPLATES_DIR"
for file in *.template; do
    if ! grep -q "PERSONA CONTEXT ACTIVATION" "$file"; then
        # Extract command name
        cmd_name=$(basename "$file" .md.template)
        echo "  - $cmd_name"
    fi
done

echo ""
echo "Analyzing which commands should get activation..."
echo ""

# Commands that should NOT get activation (utilities and direct persona activations)
UTILITY_COMMANDS=(
    "ap"
    "ap_orchestrator"
    "handoff"
    "switch"
    "wrap"
    "wrap.markdown"
    "session-note-setup"
    "session-note-setup.markdown"
    "git-commit-all"
    "buildit"
    "release"
    "version"
    "analyst"
    "architect"
    "design-architect"
    "dev"
    "developer"
    "pm"
    "po"
    "qa"
    "sm"
    "personas"
    "subtask"
)

# Commands that SHOULD get activation
SHOULD_ACTIVATE=(
    "doc-compliance"
    "doc-compliance-enhanced"
    "organize-docs"
    "update-all-documentation"
    "groom-backlog-task"
    "monitor-tests"
    "run-tests"
    "show-test-status"
    "test-dashboard"
    "test-metrics"
    "qa-framework"
    "qa-predict"
    "qa-optimize"
    "qa-anomaly"
    "qa-insights"
)

echo "Commands that SHOULD have persona activation:"
echo "----------------------------------------------"
for cmd in "${SHOULD_ACTIVATE[@]}"; do
    file="${cmd}.md.template"
    if [ -f "$file" ]; then
        if ! grep -q "PERSONA CONTEXT ACTIVATION" "$file"; then
            echo "  ✗ $cmd - Missing activation"
        else
            echo "  ✓ $cmd - Already has activation"
        fi
    fi
done

echo ""
echo "Commands that should REMAIN as utilities:"
echo "-----------------------------------------"
for cmd in "${UTILITY_COMMANDS[@]}"; do
    file="${cmd}.md.template"
    if [ -f "$file" ]; then
        echo "  - $cmd"
    fi
done

echo ""
echo "================================================"
echo "Phase 3 Analysis Complete"
echo "================================================"