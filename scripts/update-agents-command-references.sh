#!/bin/bash

# Update command references in agents directory templates
# Created as part of comprehensive command renaming project

echo "🔄 Updating command references in agents directory templates..."

# Create backup directory
mkdir -p /mnt/c/Code/agentic-persona-mapping/payload/templates/agents/.backup-$(date +%Y%m%d-%H%M%S)

# Define the command mapping for all renamed commands
declare -A command_map=(
    ["/epic"]="/planning-epic"
    ["/stories"]="/planning-stories"
    ["/groom"]="/planning-groom"
    ["/checklist"]="/planning-checklist"
    ["/requirements"]="/planning-requirements"
    ["/stakeholder-review"]="/planning-stakeholder-review"
    ["/brainstorming"]="/planning-brainstorming"
    ["/architecture"]="/planning-architecture"
    ["/acceptance-criteria"]="/qa-acceptance-criteria"
    ["/quality-review"]="/qa-quality-review"
    ["/automation-plan"]="/qa-automation-plan"
    ["/sprint"]="/implementation-sprint"
    ["/validation"]="/planning-validation"
    ["/ux-spec"]="/planning-ux-spec"
    ["/requirement-validation"]="/planning-requirement-validation"
    
    # Also update without leading slash for text references
    ["epic"]="planning-epic"
    ["stories"]="planning-stories"
    ["groom"]="planning-groom"
    ["checklist"]="planning-checklist"
    ["requirements"]="planning-requirements"
    ["stakeholder-review"]="planning-stakeholder-review"
    ["brainstorming"]="planning-brainstorming"
    ["architecture"]="planning-architecture"
    ["acceptance-criteria"]="qa-acceptance-criteria"
    ["quality-review"]="qa-quality-review"
    ["automation-plan"]="qa-automation-plan"
    ["sprint"]="implementation-sprint"
    ["validation"]="planning-validation"
    ["ux-spec"]="planning-ux-spec"
    ["requirement-validation"]="planning-requirement-validation"
)

# Function to update a single file
update_file() {
    local file="$1"
    echo "  📝 Processing: $file"
    
    # Create backup
    cp "$file" "$file.backup"
    
    # Apply all command mappings
    for old_cmd in "${!command_map[@]}"; do
        new_cmd="${command_map[$old_cmd]}"
        # Use word boundaries to prevent partial matches
        sed -i "s/\b${old_cmd}\b/${new_cmd}/g" "$file"
    done
    
    echo "    ✅ Updated: $file"
}

# Process all files found by the grep search
files=(
    "/mnt/c/Code/agentic-persona-mapping/payload/templates/agents/templates/test-strategy-tmpl.md.template"
    "/mnt/c/Code/agentic-persona-mapping/payload/templates/agents/templates/front-end-architecture-tmpl.md.template"
    "/mnt/c/Code/agentic-persona-mapping/payload/templates/agents/templates/epic-tmpl.md.template"
    "/mnt/c/Code/agentic-persona-mapping/payload/templates/agents/templates/doc-sharding-tmpl.md.template"
    "/mnt/c/Code/agentic-persona-mapping/payload/templates/agents/tasks/run-qa-checklist.md.template"
    "/mnt/c/Code/agentic-persona-mapping/payload/templates/agents/shared/path-constants.md.template"
    "/mnt/c/Code/agentic-persona-mapping/payload/templates/agents/scripts/doc-compliance-validator.sh"
    "/mnt/c/Code/agentic-persona-mapping/payload/templates/agents/scripts/README.md.template"
    "/mnt/c/Code/agentic-persona-mapping/payload/templates/agents/personas/sm/commands/parallel-checklist.md.template"
    "/mnt/c/Code/agentic-persona-mapping/payload/templates/agents/personas/sm.md.template"
    "/mnt/c/Code/agentic-persona-mapping/payload/templates/agents/personas/qa.md.template"
    "/mnt/c/Code/agentic-persona-mapping/payload/templates/agents/personas/po.md.template"
    "/mnt/c/Code/agentic-persona-mapping/payload/templates/agents/personas/pm.md.template"
    "/mnt/c/Code/agentic-persona-mapping/payload/templates/agents/personas/orchestrator.md.template"
    "/mnt/c/Code/agentic-persona-mapping/payload/templates/agents/personas/developer.md.template"
    "/mnt/c/Code/agentic-persona-mapping/payload/templates/agents/personas/dev.md.template"
    "/mnt/c/Code/agentic-persona-mapping/payload/templates/agents/personas/design-architect.md.template"
    "/mnt/c/Code/agentic-persona-mapping/payload/templates/agents/personas/architect.md.template"
    "/mnt/c/Code/agentic-persona-mapping/payload/templates/agents/personas/analyst.md.template"
    "/mnt/c/Code/agentic-persona-mapping/payload/templates/agents/personas/analyst-demo.md.template"
    "/mnt/c/Code/agentic-persona-mapping/payload/templates/agents/personas/PERSONA-UPDATE-TEMPLATE.md.template"
    "/mnt/c/Code/agentic-persona-mapping/payload/templates/agents/personas/DOCUMENT_COMPLIANCE_RULES.md"
    "/mnt/c/Code/agentic-persona-mapping/payload/templates/agents/ide-ap-orchestrator.cfg.md.template"
    # Removed obsolete template references - cleaned up in template obsolescence review
    "/mnt/c/Code/agentic-persona-mapping/payload/templates/agents/data/ap-kb.md.template"
    "/mnt/c/Code/agentic-persona-mapping/payload/templates/agents/checklists/po-master-checklist.md.template"
)

# Process each file
for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        update_file "$file"
    else
        echo "  ⚠️  File not found: $file"
    fi
done

echo ""
echo "🎯 Summary:"
echo "   📄 Total files processed: ${#files[@]}"
echo "   🔄 Command mappings applied: ${#command_map[@]}"
echo "   💾 Backup files created with .backup extension"
echo ""
echo "✅ Command reference update in agents directory completed successfully!"