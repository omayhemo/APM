#!/bin/bash

# Update command references in documentation files
# Created to complete comprehensive command renaming project

echo "📚 Updating command references in documentation files..."

# Create backup directory
backup_dir="/mnt/c/Code/agentic-persona-mapping/payload/templates/documentation/.backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$backup_dir"

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
    
    # Text references (for documentation)
    ["epic command"]="planning-epic command"
    ["stories command"]="planning-stories command"
    ["groom command"]="planning-groom command"
    ["checklist command"]="planning-checklist command"
    ["requirements command"]="planning-requirements command"
    ["stakeholder-review command"]="planning-stakeholder-review command"
    ["brainstorming command"]="planning-brainstorming command"
    ["architecture command"]="planning-architecture command"
    ["acceptance-criteria command"]="qa-acceptance-criteria command"
    ["quality-review command"]="qa-quality-review command"
    ["automation-plan command"]="qa-automation-plan command"
    ["sprint command"]="implementation-sprint command"
    ["validation command"]="planning-validation command"
    ["ux-spec command"]="planning-ux-spec command"
    ["requirement-validation command"]="planning-requirement-validation command"
)

# Function to update a single file
update_documentation_file() {
    local file="$1"
    echo "  📝 Processing: $file"
    
    # Create backup
    cp "$file" "$backup_dir/$(basename "$file").backup"
    
    # Apply all command mappings
    for old_cmd in "${!command_map[@]}"; do
        new_cmd="${command_map[$old_cmd]}"
        # Use more precise matching for documentation
        sed -i "s|${old_cmd}|${new_cmd}|g" "$file"
    done
    
    echo "    ✅ Updated: $file"
}

# Find all documentation files that contain old command references
doc_files=($(find /mnt/c/Code/agentic-persona-mapping/payload/templates/documentation -name "*.md" -exec grep -l "/epic\|/stories\|/groom\|/checklist\|/requirements\|/stakeholder-review\|/brainstorming\|/architecture\|/acceptance-criteria\|/quality-review\|/automation-plan\|/sprint\|/validation\|/ux-spec" {} \; 2>/dev/null))

echo "Found ${#doc_files[@]} documentation files requiring updates"

# Process each documentation file
for file in "${doc_files[@]}"; do
    if [ -f "$file" ]; then
        update_documentation_file "$file"
    else
        echo "  ⚠️  File not found: $file"
    fi
done

# Also update key configuration and support files
config_files=($(find /mnt/c/Code/agentic-persona-mapping/payload/templates -name "*.json" -o -name "*.yaml" -o -name "*.py" -o -name "*.sh" | xargs grep -l "/epic\|/stories\|/groom\|/checklist\|/requirements\|/stakeholder-review\|/brainstorming\|/architecture\|/acceptance-criteria\|/quality-review\|/automation-plan\|/sprint\|/validation\|/ux-spec" 2>/dev/null))

echo "Found ${#config_files[@]} configuration/support files requiring updates"

for file in "${config_files[@]}"; do
    if [ -f "$file" ]; then
        update_documentation_file "$file"
    fi
done

echo ""
echo "🎯 Documentation Update Summary:"
echo "   📄 Documentation files updated: ${#doc_files[@]}"
echo "   ⚙️  Configuration files updated: ${#config_files[@]}"
echo "   🔄 Total command mappings applied: ${#command_map[@]}"
echo "   💾 Backup files stored in: $backup_dir"
echo ""
echo "✅ Documentation command reference update completed successfully!"