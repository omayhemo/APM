#!/bin/bash

# Phase 2: Update all command references throughout the entire template system
# Comprehensive search and replace for 10 renamed commands

echo "🔄 Phase 2: Searching and updating all command references throughout template system..."

# Create backup directory
backup_dir="/mnt/c/Code/agentic-persona-mapping/.backup-phase2-references-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$backup_dir"

# Define comprehensive command mapping for Phase 2
declare -A phase2_command_mapping=(
    # Command references with slashes
    ["/library-indexing"]="/implementation-library-indexing"
    ["/organize-docs"]="/documentation-organize"
    ["/prd"]="/planning-prd"
    ["/project-brief"]="/planning-project-brief"
    ["/release"]="/distribution-release"
    ["/review"]="/planning-review"
    ["/buildit"]="/distribution-build"
    ["/doc-compliance-enhanced"]="/documentation-compliance"
    ["/doc-sharding"]="/documentation-shard"
    ["/git-commit-all"]="/distribution-commit"
    
    # Text references (for documentation)
    ["library-indexing command"]="implementation-library-indexing command"
    ["organize-docs command"]="documentation-organize command"
    ["prd command"]="planning-prd command"
    ["project-brief command"]="planning-project-brief command"
    ["release command"]="distribution-release command"
    ["review command"]="planning-review command"
    ["buildit command"]="distribution-build command"
    ["doc-compliance-enhanced command"]="documentation-compliance command"
    ["doc-sharding command"]="documentation-shard command"
    ["git-commit-all command"]="distribution-commit command"
    
    # Parallel command references (if they exist)
    ["/parallel-library-indexing"]="/parallel-implementation-library-indexing"
    ["/parallel-organize-docs"]="/parallel-documentation-organize"
    ["/parallel-prd"]="/parallel-planning-prd"
    ["/parallel-project-brief"]="/parallel-planning-project-brief"
    ["/parallel-release"]="/parallel-distribution-release"
    ["/parallel-review"]="/parallel-planning-review"
    ["/parallel-buildit"]="/parallel-distribution-build"
    ["/parallel-doc-compliance-enhanced"]="/parallel-documentation-compliance"
    ["/parallel-doc-sharding"]="/parallel-documentation-shard"
    ["/parallel-git-commit-all"]="/parallel-distribution-commit"
    
    # Template and script references (without leading slash)
    ["library-indexing"]="implementation-library-indexing"
    ["organize-docs"]="documentation-organize"
    ["project-brief"]="planning-project-brief"
    ["doc-compliance-enhanced"]="documentation-compliance"
    ["doc-sharding"]="documentation-shard"
    ["git-commit-all"]="distribution-commit"
)

# Function to update a single file with all command mappings
update_file_references() {
    local file="$1"
    echo "  📝 Processing: $file"
    
    # Create backup
    local backup_name="$(basename "$file").backup"
    cp "$file" "$backup_dir/$backup_name"
    
    # Apply all command mappings
    local updates_made=0
    for old_ref in "${!phase2_command_mapping[@]}"; do
        new_ref="${phase2_command_mapping[$old_ref]}"
        
        # Count occurrences before replacement
        local count_before=$(grep -c "$old_ref" "$file" 2>/dev/null || echo "0")
        
        if [ "$count_before" -gt 0 ]; then
            # Use different replacement strategies based on reference type
            if [[ "$old_ref" == /* ]]; then
                # Command references with slashes - use word boundaries
                sed -i "s|${old_ref}\\b|${new_ref}|g" "$file"
            else
                # Text references - be more careful with replacements
                sed -i "s|\\b${old_ref}\\b|${new_ref}|g" "$file"
            fi
            
            local count_after=$(grep -c "$new_ref" "$file" 2>/dev/null || echo "0")
            if [ "$count_after" -gt 0 ]; then
                echo "    🔄 Updated $count_before occurrences: $old_ref → $new_ref"
                ((updates_made++))
            fi
        fi
    done
    
    if [ $updates_made -gt 0 ]; then
        echo "    ✅ Total updates made: $updates_made"
    else
        echo "    ℹ️  No Phase 2 command references found"
    fi
    
    return 0
}

# Find all files that might contain command references
echo "🔍 Searching for files containing Phase 2 command references..."

# Create comprehensive search pattern
search_pattern="/library-indexing\\b|/organize-docs\\b|/prd\\b|/project-brief\\b|/release\\b|/review\\b|/buildit\\b|/doc-compliance-enhanced\\b|/doc-sharding\\b|/git-commit-all\\b"

# Find files in templates directory (excluding backups)
files_to_update=($(find /mnt/c/Code/agentic-persona-mapping/payload/templates -type f \( -name "*.md" -o -name "*.template" -o -name "*.sh" -o -name "*.py" -o -name "*.json" -o -name "*.yaml" \) ! -path "*/.*backup*" -exec grep -l -E "$search_pattern" {} \; 2>/dev/null))

# Also check main payload directory files
payload_files=($(find /mnt/c/Code/agentic-persona-mapping/payload -maxdepth 2 -type f \( -name "*.md" -o -name "*.sh" -o -name "*.py" -o -name "*.json" \) ! -path "*/templates/*" ! -path "*/.*backup*" -exec grep -l -E "$search_pattern" {} \; 2>/dev/null))

# Combine all files
all_files=("${files_to_update[@]}" "${payload_files[@]}")

echo "📄 Found ${#all_files[@]} files containing Phase 2 command references"

if [ ${#all_files[@]} -eq 0 ]; then
    echo "ℹ️  No files found with Phase 2 command references to update"
    echo "✅ Phase 2 reference update completed (no changes needed)"
    exit 0
fi

echo ""

# Process each file
successful_updates=0
failed_updates=0

echo "🔄 Processing files with Phase 2 command references:"
echo ""

for file in "${all_files[@]}"; do
    if [ -f "$file" ]; then
        if update_file_references "$file"; then
            ((successful_updates++))
        else
            ((failed_updates++))
            echo "    ❌ Failed to process: $file"
        fi
        echo ""
    fi
done

echo "🎯 Phase 2 Reference Update Summary:"
echo "   📄 Files processed: $successful_updates"
echo "   ❌ Files failed: $failed_updates"
echo "   🔄 Total command mappings applied: ${#phase2_command_mapping[@]}"
echo "   💾 Backup files stored in: $backup_dir"
echo ""

if [ $failed_updates -eq 0 ]; then
    echo "🎉 SUCCESS: All Phase 2 command references updated successfully!"
    echo ""
    echo "📋 Updated command references across template system:"
    echo "   📁 Planning: /prd → /planning-prd, /project-brief → /planning-project-brief, /review → /planning-review"
    echo "   📁 Implementation: /library-indexing → /implementation-library-indexing"
    echo "   📁 Documentation: /organize-docs → /documentation-organize, /doc-compliance-enhanced → /documentation-compliance, /doc-sharding → /documentation-shard"
    echo "   📁 Distribution: /release → /distribution-release, /buildit → /distribution-build, /git-commit-all → /distribution-commit"
else
    echo "⚠️  WARNING: Some reference updates failed. Review the output above."
fi

echo ""
echo "✅ Phase 2 comprehensive reference update completed!"