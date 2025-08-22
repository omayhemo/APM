#!/bin/bash
# Pre-Distribution Quality Control Validation
# This script MUST pass before any distribution build
# Run: bash scripts/pre-distribution-validation.sh

set -e

# Configuration
PROJECT_ROOT="/mnt/c/Code/agentic-persona-mapping"
PAYLOAD_DIR="$PROJECT_ROOT/payload"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "==========================================="
echo "Pre-Distribution Quality Control Validation"
echo "==========================================="
echo ""

validation_failed=false

# Check 1: Command typos in shell scripts
echo "🔍 Checking for command typos in shell scripts..."
typos=("^cho$" "^cho " "^[[:space:]]*Wait[[:space:]]" "^ech " "^ecoh " "^ehco " "^wiat" "^Wiat" "^WAIT")

for script_file in $(find "$PAYLOAD_DIR" -name "*.sh" -type f); do
    for typo in "${typos[@]}"; do
        if grep -q "$typo" "$script_file" 2>/dev/null && ! grep -q "^[[:space:]]*#.*$(echo "$typo" | sed 's/\^//g; s/\[[^]]*\]//g')" "$script_file" 2>/dev/null; then
            echo -e "${RED}❌ CRITICAL: Command typo found in $script_file${NC}"
            echo "   Pattern: $typo"
            grep -n "$typo" "$script_file" | head -3
            validation_failed=true
        fi
    done
done

if [ "$validation_failed" = false ]; then
    echo -e "${GREEN}✅ No command typos found${NC}"
fi

# Check 2: VERSION consistency
echo ""
echo "🔍 Checking VERSION file consistency..."
payload_version=$(cat "$PAYLOAD_DIR/VERSION" 2>/dev/null || echo "MISSING")
dist_version=$(cat "$PROJECT_ROOT/dist/coherence-v"*"-installer/installer/VERSION" 2>/dev/null | head -1 || echo "MISSING")

if [ "$payload_version" = "MISSING" ]; then
    echo -e "${RED}❌ CRITICAL: Payload VERSION file missing${NC}"
    validation_failed=true
elif [ "$dist_version" != "MISSING" ] && [ "$payload_version" != "$dist_version" ]; then
    echo -e "${RED}❌ CRITICAL: VERSION mismatch${NC}"
    echo "   Payload: $payload_version"
    echo "   Distribution: $dist_version"
    validation_failed=true
else
    echo -e "${GREEN}✅ VERSION consistency validated: $payload_version${NC}"
fi

# Check 3: Critical files exist
echo ""
echo "🔍 Checking critical file existence..."
critical_files=(
    "$PAYLOAD_DIR/install.sh"
    "$PAYLOAD_DIR/VERSION"
    "$PAYLOAD_DIR/templates/claude/commands/coherence.md.template"
    "$PAYLOAD_DIR/templates/claude/output-styles/apm-orchestrator.md.template"
)

for file in "${critical_files[@]}"; do
    if [ ! -f "$file" ]; then
        echo -e "${RED}❌ CRITICAL: Missing file $file${NC}"
        validation_failed=true
    fi
done

if [ "$validation_failed" = false ]; then
    echo -e "${GREEN}✅ All critical files present${NC}"
fi

# Check 4: No auto-fix logic in installer
echo ""
echo "🔍 Checking for auto-fix logic in installer..."
if grep -q "Auto-fixed\|auto-fixed\|sed -i.*echo\|sed -i.*wait" "$PAYLOAD_DIR/install.sh" 2>/dev/null; then
    echo -e "${RED}❌ CRITICAL: Auto-fix logic found in installer${NC}"
    echo "   Installers should FAIL on errors, not fix them"
    grep -n "Auto-fixed\|auto-fixed\|sed -i.*echo\|sed -i.*wait" "$PAYLOAD_DIR/install.sh" | head -3
    validation_failed=true
else
    echo -e "${GREEN}✅ No auto-fix logic found in installer${NC}"
fi

# Final result
echo ""
echo "==========================================="
if [ "$validation_failed" = true ]; then
    echo -e "${RED}❌ VALIDATION FAILED${NC}"
    echo "   Distribution build MUST NOT proceed"
    echo "   Fix all issues above before building"
    echo "==========================================="
    exit 1
else
    echo -e "${GREEN}✅ VALIDATION PASSED${NC}"
    echo "   Distribution build can proceed safely"
    echo "==========================================="
    exit 0
fi