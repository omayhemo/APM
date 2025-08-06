#\!/bin/bash

# Fix remaining hardcoded paths in template files

echo "Fixing remaining hardcoded paths in template files..."

# Fix monitoring template
sed -i.backup-final 's|/mnt/c/Code/agentic-persona-mapping|{{PROJECT_ROOT}}|g' installer/templates/agents/monitoring/parallel-performance-system.md.template

# Fix context example template  
sed -i.backup-final 's|/mnt/c/Code/agentic-persona-mapping|{{PROJECT_ROOT}}|g' installer/templates/claude/agents/context/integration-example.js.template

# Fix developer persona template
sed -i.backup-final 's|/mnt/c/Code/agentic-persona-mapping|{{PROJECT_ROOT}}|g' installer/templates/claude/agents/personas/developer.md.template

echo "✅ Fixed all remaining template files"

# Verify no hardcoded paths remain
echo ""
echo "Verifying no hardcoded paths remain..."
if find installer/templates -name "*.template" -not -name "*.backup*" -exec grep -l "/mnt/c/[Cc]ode/agentic-persona" {} \; | grep -q .; then
    echo "❌ FAILURE: Some hardcoded paths still remain\!"
    find installer/templates -name "*.template" -not -name "*.backup*" -exec grep -l "/mnt/c/[Cc]ode/agentic-persona" {} \;
else
    echo "✅ SUCCESS: All hardcoded paths have been replaced with template variables\!"
fi
