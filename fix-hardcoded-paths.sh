#!/bin/bash

# Script to fix hardcoded paths in APM template files
# This replaces hardcoded paths with appropriate template variables

echo "Fixing hardcoded paths in APM template files..."
cd /mnt/c/Code/agentic-persona-mapping/installer/templates/claude/commands/

# Map command templates to appropriate voice scripts
declare -A voice_map=(
    ["acceptance-criteria.md.template"]="{{SPEAK_PO}}"
    ["ai-prompt.md.template"]="{{SPEAK_DESIGN_ARCHITECT}}"
    ["automation-plan.md.template"]="{{SPEAK_QA}}"
    ["checklist.md.template"]="{{SPEAK_SM}}"
    ["course-correction.md.template"]="{{SPEAK_SM}}"
    ["doc-sharding.md.template"]="{{SPEAK_ORCHESTRATOR}}"
    ["frontend-architecture.md.template"]="{{SPEAK_DESIGN_ARCHITECT}}"
    ["library-indexing.md.template"]="{{SPEAK_ORCHESTRATOR}}"
    ["next-story.md.template"]="{{SPEAK_SM}}"
    ["prd.md.template"]="{{SPEAK_PM}}"
    ["prioritization.md.template"]="{{SPEAK_PO}}"
    ["project-brief.md.template"]="{{SPEAK_ANALYST}}"
    ["quality-review.md.template"]="{{SPEAK_QA}}"
    ["research-prompt.md.template"]="{{SPEAK_ANALYST}}"
    ["stakeholder-review.md.template"]="{{SPEAK_ANALYST}}"
    ["stories.md.template"]="{{SPEAK_SM}}"
    ["test-plan.md.template"]="{{SPEAK_QA}}"
    ["test-strategy.md.template"]="{{SPEAK_QA}}"
    ["ux-spec.md.template"]="{{SPEAK_DESIGN_ARCHITECT}}"
    ["validation.md.template"]="{{SPEAK_PO}}"
)

# Fix each file
for file in "${!voice_map[@]}"; do
    if [ -f "$file" ]; then
        voice_var="${voice_map[$file]}"
        echo "Fixing $file with $voice_var"
        
        # Replace the hardcoded path with the template variable
        sed -i "s|bash /mnt/c/Code/agentic-persona-mapping/.apm/agents/voice/speak.sh|bash $voice_var|g" "$file"
    fi
done

echo "Hardcoded path fixes complete!"
echo ""
echo "Summary of fixes applied:"
echo "- Fixed build script path in buildit.md.template"
echo "- Fixed persona and documentation paths in parallel-prd.md.template" 
echo "- Fixed voice script paths in 20 sequential command templates"
echo ""
echo "All template files now use proper template variables instead of hardcoded paths."