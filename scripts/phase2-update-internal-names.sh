#!/bin/bash

# Phase 2: Update internal name references in renamed command templates
# Ensures YAML frontmatter matches new file names

echo "🔧 Phase 2: Updating internal name references in renamed templates..."

# Create backup directory
backup_dir="/mnt/c/Code/agentic-persona-mapping/.backup-phase2-internal-names-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$backup_dir"

# Define the name mapping for Phase 2 commands
declare -A phase2_name_mapping=(
    ["implementation-library-indexing"]="implementation-library-indexing"
    ["documentation-organize"]="documentation-organize"
    ["planning-prd"]="planning-prd"
    ["planning-project-brief"]="planning-project-brief"
    ["distribution-release"]="distribution-release"
    ["planning-review"]="planning-review"
    ["distribution-build"]="distribution-build"
    ["documentation-compliance"]="documentation-compliance"
    ["documentation-shard"]="documentation-shard"
    ["distribution-commit"]="distribution-commit"
)

# Base directory for command templates
commands_dir="/mnt/c/Code/agentic-persona-mapping/payload/templates/claude/commands"

echo "📁 Command templates directory: $commands_dir"
echo "💾 Backup directory: $backup_dir"
echo ""

# Function to update internal name in a template file
update_internal_name() {
    local new_name="$1"
    local template_file="$commands_dir/${new_name}.md.template"
    
    echo "  📝 Updating internal name: ${new_name}.md.template"
    
    # Check if file exists
    if [ ! -f "$template_file" ]; then
        echo "    ❌ Template file not found: $template_file"
        return 1
    fi
    
    # Create backup
    cp "$template_file" "$backup_dir/${new_name}.md.template.backup"
    
    # Update the name field in YAML frontmatter
    # Handle different possible formats: "name: old_name", "name:", or no name field
    if grep -q "^name:" "$template_file"; then
        # Update existing name field
        sed -i "s/^name:.*/name: $new_name/" "$template_file"
        echo "    ✅ Updated existing name field to: $new_name"
    else
        # Add name field after first line (after ---)
        sed -i "1a\\name: $new_name" "$template_file"
        echo "    ✅ Added new name field: $new_name"
    fi
    
    return 0
}

# Process each renamed template
successful_updates=0
failed_updates=0

echo "🔄 Processing Phase 2 internal name updates:"
echo ""

for new_name in "${!phase2_name_mapping[@]}"; do
    if update_internal_name "$new_name"; then
        ((successful_updates++))
    else
        ((failed_updates++))
    fi
    echo ""
done

echo "🎯 Phase 2 Internal Name Update Summary:"
echo "   ✅ Successful updates: $successful_updates"
echo "   ❌ Failed updates: $failed_updates"
echo "   💾 Backup files stored in: $backup_dir"
echo ""

if [ $successful_updates -eq 10 ] && [ $failed_updates -eq 0 ]; then
    echo "🎉 SUCCESS: All Phase 2 internal name references updated!"
    echo ""
    echo "📋 Updated templates with correct internal names:"
    echo "   📁 Planning:"
    echo "     - planning-prd.md.template (name: planning-prd)"
    echo "     - planning-project-brief.md.template (name: planning-project-brief)"
    echo "     - planning-review.md.template (name: planning-review)"
    echo "   📁 Implementation:"
    echo "     - implementation-library-indexing.md.template (name: implementation-library-indexing)"
    echo "   📁 Documentation:"
    echo "     - documentation-organize.md.template (name: documentation-organize)"
    echo "     - documentation-compliance.md.template (name: documentation-compliance)"
    echo "     - documentation-shard.md.template (name: documentation-shard)"
    echo "   📁 Distribution:"
    echo "     - distribution-release.md.template (name: distribution-release)"
    echo "     - distribution-build.md.template (name: distribution-build)"
    echo "     - distribution-commit.md.template (name: distribution-commit)"
else
    echo "⚠️  WARNING: Some internal name updates failed. Review the output above."
fi

echo ""
echo "✅ Phase 2 internal name reference updates completed!"