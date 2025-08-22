#!/bin/bash

# Phase 2: Batch rename command templates with new prefixes
# Processing 10 additional commands for comprehensive organization

echo "🚀 Phase 2: Renaming 10 command templates with new prefixes..."

# Create backup directory
backup_dir="/mnt/c/Code/agentic-persona-mapping/.backup-phase2-rename-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$backup_dir"

# Define the command mapping for Phase 2 commands
declare -A phase2_commands=(
    # Planning Commands (3)
    ["library-indexing"]="implementation-library-indexing"
    ["organize-docs"]="documentation-organize"
    ["prd"]="planning-prd"
    ["project-brief"]="planning-project-brief"
    ["release"]="distribution-release"
    ["review"]="planning-review"
    ["buildit"]="distribution-build"
    ["doc-compliance-enhanced"]="documentation-compliance"
    ["doc-sharding"]="documentation-shard"
    ["git-commit-all"]="distribution-commit"
)

# Base directory for command templates
commands_dir="/mnt/c/Code/agentic-persona-mapping/payload/templates/claude/commands"

echo "📁 Command templates directory: $commands_dir"
echo "💾 Backup directory: $backup_dir"
echo ""

# Function to rename a single command template
rename_command_template() {
    local old_name="$1"
    local new_name="$2"
    local old_file="$commands_dir/${old_name}.md.template"
    local new_file="$commands_dir/${new_name}.md.template"
    
    echo "  📝 Renaming: ${old_name}.md.template → ${new_name}.md.template"
    
    # Check if source file exists
    if [ ! -f "$old_file" ]; then
        echo "    ❌ Source file not found: $old_file"
        return 1
    fi
    
    # Check if target file already exists
    if [ -f "$new_file" ]; then
        echo "    ⚠️  Target file already exists: $new_file"
        return 1
    fi
    
    # Create backup
    cp "$old_file" "$backup_dir/${old_name}.md.template.backup"
    
    # Rename the file
    mv "$old_file" "$new_file"
    
    if [ $? -eq 0 ]; then
        echo "    ✅ Successfully renamed to: ${new_name}.md.template"
        return 0
    else
        echo "    ❌ Failed to rename: $old_file"
        return 1
    fi
}

# Process each command template
successful_renames=0
failed_renames=0

echo "🔄 Processing Phase 2 command template renames:"
echo ""

for old_cmd in "${!phase2_commands[@]}"; do
    new_cmd="${phase2_commands[$old_cmd]}"
    
    if rename_command_template "$old_cmd" "$new_cmd"; then
        ((successful_renames++))
    else
        ((failed_renames++))
    fi
    echo ""
done

echo "🎯 Phase 2 Rename Summary:"
echo "   ✅ Successful renames: $successful_renames"
echo "   ❌ Failed renames: $failed_renames"
echo "   💾 Backup files stored in: $backup_dir"
echo ""

if [ $successful_renames -eq 10 ] && [ $failed_renames -eq 0 ]; then
    echo "🎉 SUCCESS: All Phase 2 command templates successfully renamed!"
    echo "📋 New command structure:"
    echo "   📁 Planning: planning-prd, planning-project-brief, planning-review"
    echo "   📁 Implementation: implementation-library-indexing"  
    echo "   📁 Documentation: documentation-organize, documentation-compliance, documentation-shard"
    echo "   📁 Distribution: distribution-release, distribution-build, distribution-commit"
else
    echo "⚠️  WARNING: Some renames failed. Review the output above."
fi

echo ""
echo "✅ Phase 2 command template renaming completed!"