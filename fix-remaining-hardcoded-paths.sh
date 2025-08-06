#!/bin/bash

# Script to fix remaining hardcoded paths in parallel command templates
# This replaces all remaining hardcoded paths with appropriate template variables

echo "Fixing remaining hardcoded paths in parallel command templates..."
cd /mnt/c/Code/agentic-persona-mapping/installer/templates/claude/commands/

# Find all files with remaining hardcoded paths
files_to_fix=$(grep -l "/mnt/c/Code/agentic-persona-mapping" *.template 2>/dev/null)

if [ -z "$files_to_fix" ]; then
    echo "No more hardcoded paths found!"
    exit 0
fi

echo "Files with hardcoded paths:"
echo "$files_to_fix"
echo ""

# Fix each file
for file in $files_to_fix; do
    echo "Processing: $file"
    
    # Create a backup
    cp "$file" "$file.backup-hardcoded-fix"
    
    # Replace common patterns
    # .apm/agents paths -> {{AP_ROOT}}
    sed -i 's|/mnt/c/Code/agentic-persona-mapping/\.apm/agents|{{AP_ROOT}}|g' "$file"
    
    # project_docs paths -> {{PROJECT_ROOT}}/project_docs
    sed -i 's|/mnt/c/Code/agentic-persona-mapping/project_docs|{{PROJECT_ROOT}}/project_docs|g' "$file"
    
    # Voice script replacements - map each voice script to its variable
    sed -i 's|bash /mnt/c/Code/agentic-persona-mapping/\.apm/agents/voice/speakOrchestrator\.sh|bash {{SPEAK_ORCHESTRATOR}}|g' "$file"
    sed -i 's|bash /mnt/c/Code/agentic-persona-mapping/\.apm/agents/voice/speakAnalyst\.sh|bash {{SPEAK_ANALYST}}|g' "$file"
    sed -i 's|bash /mnt/c/Code/agentic-persona-mapping/\.apm/agents/voice/speakArchitect\.sh|bash {{SPEAK_ARCHITECT}}|g' "$file"
    sed -i 's|bash /mnt/c/Code/agentic-persona-mapping/\.apm/agents/voice/speakDeveloper\.sh|bash {{SPEAK_DEVELOPER}}|g' "$file"
    sed -i 's|bash /mnt/c/Code/agentic-persona-mapping/\.apm/agents/voice/speakPm\.sh|bash {{SPEAK_PM}}|g' "$file"
    sed -i 's|bash /mnt/c/Code/agentic-persona-mapping/\.apm/agents/voice/speakPo\.sh|bash {{SPEAK_PO}}|g' "$file"
    sed -i 's|bash /mnt/c/Code/agentic-persona-mapping/\.apm/agents/voice/speakQa\.sh|bash {{SPEAK_QA}}|g' "$file"
    sed -i 's|bash /mnt/c/Code/agentic-persona-mapping/\.apm/agents/voice/speakSm\.sh|bash {{SPEAK_SM}}|g' "$file"
    sed -i 's|bash /mnt/c/Code/agentic-persona-mapping/\.apm/agents/voice/speakDesignArchitect\.sh|bash {{SPEAK_DESIGN_ARCHITECT}}|g' "$file"
    
    # General project root replacement (for any remaining paths)
    sed -i 's|/mnt/c/Code/agentic-persona-mapping|{{PROJECT_ROOT}}|g' "$file"
    
    echo "  ✓ Fixed $file"
done

echo ""
echo "All hardcoded paths have been fixed!"
echo "Backup files created with .backup-hardcoded-fix extension"

# Verify no more hardcoded paths remain
echo ""
echo "Verification - checking for any remaining hardcoded paths..."
remaining=$(grep -l "/mnt/c/Code/agentic-persona-mapping" *.template 2>/dev/null)
if [ -z "$remaining" ]; then
    echo "✅ SUCCESS: No hardcoded paths remaining!"
else
    echo "⚠️  WARNING: Some files still have hardcoded paths:"
    echo "$remaining"
fi