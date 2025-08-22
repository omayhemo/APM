#!/bin/bash

# Final comprehensive cleanup of all old command references
# Created to ensure 100% completion of command renaming project

echo "🧹 Performing final comprehensive cleanup of command references..."

# Create master backup directory
backup_dir="/mnt/c/Code/agentic-persona-mapping/.backup-final-cleanup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$backup_dir"

# Define the command mapping for all renamed commands
declare -A command_map=(
    # Command references with slashes
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
    
    # Parallel command references
    ["/parallel-epic"]="/parallel-planning-epic"
    ["/parallel-stories"]="/parallel-planning-stories"
    ["/parallel-groom"]="/parallel-planning-groom"
    ["/parallel-checklist"]="/parallel-planning-checklist"
    ["/parallel-requirements"]="/parallel-planning-requirements"
    ["/parallel-stakeholder-review"]="/parallel-planning-stakeholder-review"
    ["/parallel-brainstorming"]="/parallel-planning-brainstorming"
    ["/parallel-architecture"]="/parallel-planning-architecture"
    ["/parallel-acceptance-criteria"]="/parallel-qa-acceptance-criteria"
    ["/parallel-quality-review"]="/parallel-qa-quality-review"
    ["/parallel-automation-plan"]="/parallel-qa-automation-plan"
    ["/parallel-sprint"]="/parallel-implementation-sprint"
    ["/parallel-validation"]="/parallel-planning-validation"
    ["/parallel-ux-spec"]="/parallel-planning-ux-spec"
)

# Function to update a single file with safe backups
update_file_comprehensive() {
    local file="$1"
    local file_backup="$backup_dir/$(basename "$file").backup"
    
    # Create backup
    cp "$file" "$file_backup"
    
    # Apply all command mappings with word boundaries where appropriate
    for old_cmd in "${!command_map[@]}"; do
        new_cmd="${command_map[$old_cmd]}"
        # Use different approaches based on file type
        if [[ "$file" == *.md || "$file" == *.template ]]; then
            # Markdown and templates - use word boundaries
            sed -i "s|${old_cmd}\\b|${new_cmd}|g" "$file"
        else
            # Scripts, JSON, etc. - use direct replacement
            sed -i "s|${old_cmd}|${new_cmd}|g" "$file"
        fi
    done
    
    return 0
}

# Find ALL files that still contain old command references
echo "🔍 Identifying all remaining files with old command references..."

all_files=($(find /mnt/c/Code/agentic-persona-mapping/payload -type f \( -name "*.md" -o -name "*.template" -o -name "*.sh" -o -name "*.py" -o -name "*.json" -o -name "*.yaml" -o -name "*.txt" \) -exec grep -l "/epic\|/stories\|/groom\|/checklist\|/requirements\|/stakeholder-review\|/brainstorming\|/architecture\|/acceptance-criteria\|/quality-review\|/automation-plan\|/sprint\|/validation\|/ux-spec" {} \; 2>/dev/null))

echo "📄 Found ${#all_files[@]} files requiring final cleanup"

# Process each file
processed=0
failed=0

for file in "${all_files[@]}"; do
    if [ -f "$file" ]; then
        if update_file_comprehensive "$file"; then
            echo "  ✅ Updated: $file"
            ((processed++))
        else
            echo "  ❌ Failed: $file"
            ((failed++))
        fi
    else
        echo "  ⚠️  File not found: $file"
        ((failed++))
    fi
done

# Verification check
echo ""
echo "🔍 Performing verification check..."

remaining_files=($(find /mnt/c/Code/agentic-persona-mapping/payload -type f \( -name "*.md" -o -name "*.template" -o -name "*.sh" -o -name "*.py" -o -name "*.json" -o -name "*.yaml" \) -exec grep -l "/epic\|/stories\|/groom\|/checklist\|/requirements\|/stakeholder-review\|/brainstorming\|/architecture\|/acceptance-criteria\|/quality-review\|/automation-plan\|/sprint\|/validation\|/ux-spec" {} \; 2>/dev/null))

echo ""
echo "🎯 Final Cleanup Summary:"
echo "   📄 Files processed: $processed"
echo "   ❌ Files failed: $failed"  
echo "   🔍 Files still with old references: ${#remaining_files[@]}"
echo "   💾 Backup files stored in: $backup_dir"
echo ""

if [ ${#remaining_files[@]} -eq 0 ]; then
    echo "✅ SUCCESS: All command references have been successfully updated!"
    echo "🚀 Command renaming project completed successfully!"
else
    echo "⚠️  WARNING: ${#remaining_files[@]} files still contain old command references:"
    for remaining_file in "${remaining_files[@]}"; do
        echo "     - $remaining_file"
    done
    echo ""
    echo "🔧 These may be backup files or require manual review."
fi

echo ""
echo "🎉 Final comprehensive cleanup completed!"