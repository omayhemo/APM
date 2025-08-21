#!/bin/bash

# Phase 2: Update supporting scripts and configuration files
# Target persona generation scripts, install scripts, and configuration files

echo "⚙️ Phase 2: Updating supporting scripts and configuration files..."

# Create backup directory
backup_dir="/mnt/c/Code/agentic-persona-mapping/.backup-phase2-support-files-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$backup_dir"

# Define Phase 2 command mapping for supporting files
declare -A phase2_support_mapping=(
    # Command references for scripts and configs
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
    
    # With slashes for command invocations
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
    
    # Specific text patterns for descriptive references
    ["library indexing"]="implementation library indexing"
    ["organize docs"]="documentation organize"
    ["project brief"]="planning project brief"
    ["doc compliance enhanced"]="documentation compliance"
    ["doc sharding"]="documentation shard"
    ["git commit all"]="distribution commit"
)

# Function to update supporting files
update_support_file() {
    local file="$1"
    echo "  📝 Processing support file: $file"
    
    # Create backup
    local backup_name="$(basename "$file").support-backup"
    cp "$file" "$backup_dir/$backup_name"
    
    # Apply all Phase 2 mappings
    local updates_made=0
    for old_ref in "${!phase2_support_mapping[@]}"; do
        new_ref="${phase2_support_mapping[$old_ref]}"
        
        # Count occurrences before replacement
        local count_before=$(grep -c "$old_ref" "$file" 2>/dev/null || echo "0")
        
        if [ "$count_before" -gt 0 ]; then
            # Use different strategies for different file types
            if [[ "$file" == *.sh ]]; then
                # Shell scripts - be careful with word boundaries
                sed -i "s|\\b${old_ref}\\b|${new_ref}|g" "$file"
            elif [[ "$file" == *.json ]]; then
                # JSON files - direct replacement
                sed -i "s|${old_ref}|${new_ref}|g" "$file"
            elif [[ "$file" == *.yaml || "$file" == *.yml ]]; then
                # YAML files - direct replacement
                sed -i "s|${old_ref}|${new_ref}|g" "$file"
            else
                # Other files - use word boundaries where appropriate
                if [[ "$old_ref" == /* ]]; then
                    # Command references - exact match
                    sed -i "s|${old_ref}\\b|${new_ref}|g" "$file"
                else
                    # Text references - word boundaries
                    sed -i "s|\\b${old_ref}\\b|${new_ref}|g" "$file"
                fi
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

# Find key supporting files that might reference Phase 2 commands
echo "🔍 Searching for supporting scripts and configuration files..."

# Define key supporting files to check
supporting_files=(
    # Install and setup scripts
    "/mnt/c/Code/agentic-persona-mapping/payload/install.sh"
    "/mnt/c/Code/agentic-persona-mapping/payload/enhanced-persona-generator.sh"
    "/mnt/c/Code/agentic-persona-mapping/payload/persona-generator.sh"
    "/mnt/c/Code/agentic-persona-mapping/payload/populate-all-personas.sh"
    "/mnt/c/Code/agentic-persona-mapping/payload/production-persona-generator.sh"
    
    # Persona definition files
    "/mnt/c/Code/agentic-persona-mapping/payload/personas/_master/analyst.persona.json"
    "/mnt/c/Code/agentic-persona-mapping/payload/personas/_master/architect.persona.json"
    "/mnt/c/Code/agentic-persona-mapping/payload/personas/_master/pm.persona.json"
    "/mnt/c/Code/agentic-persona-mapping/payload/personas/_master/po.persona.json"
    "/mnt/c/Code/agentic-persona-mapping/payload/personas/_master/qa.persona.json"
    "/mnt/c/Code/agentic-persona-mapping/payload/personas/_master/sm.persona.json"
    "/mnt/c/Code/agentic-persona-mapping/payload/personas/_master/design-architect.persona.json"
    
    # Template files that might contain command references
    "/mnt/c/Code/agentic-persona-mapping/payload/personas/_templates/apm.persona.template"
    
    # Configuration files
    "/mnt/c/Code/agentic-persona-mapping/payload/templates/config/organize-docs.yaml.template"
    
    # Build and generation scripts
    "/mnt/c/Code/agentic-persona-mapping/payload/personas/_build/generate-personas.sh"
    "/mnt/c/Code/agentic-persona-mapping/payload/personas/_tools/demo-generate.sh"
)

# Filter to only existing files
existing_files=()
for file in "${supporting_files[@]}"; do
    if [ -f "$file" ]; then
        existing_files+=("$file")
    fi
done

echo "📄 Found ${#existing_files[@]} supporting files to process"

if [ ${#existing_files[@]} -eq 0 ]; then
    echo "ℹ️  No supporting files found to update"
    echo "✅ Phase 2 supporting file updates completed (no files to process)"
    exit 0
fi

echo ""

# Process each supporting file
successful_updates=0
failed_updates=0

echo "🔄 Processing supporting files:"
echo ""

for file in "${existing_files[@]}"; do
    if update_support_file "$file"; then
        ((successful_updates++))
    else
        ((failed_updates++))
        echo "    ❌ Failed to process: $file"
    fi
    echo ""
done

echo "🎯 Phase 2 Supporting Files Update Summary:"
echo "   📄 Files processed: $successful_updates"
echo "   ❌ Files failed: $failed_updates"
echo "   🔄 Total command mappings applied: ${#phase2_support_mapping[@]}"
echo "   💾 Backup files stored in: $backup_dir"
echo ""

if [ $failed_updates -eq 0 ]; then
    echo "🎉 SUCCESS: All Phase 2 supporting files updated successfully!"
    echo ""
    echo "📋 Updated supporting files for Phase 2 commands:"
    echo "   📁 Planning: prd → planning-prd, project-brief → planning-project-brief, review → planning-review"
    echo "   📁 Implementation: library-indexing → implementation-library-indexing"
    echo "   📁 Documentation: organize-docs → documentation-organize, doc-compliance-enhanced → documentation-compliance, doc-sharding → documentation-shard"
    echo "   📁 Distribution: release → distribution-release, buildit → distribution-build, git-commit-all → distribution-commit"
else
    echo "⚠️  WARNING: Some supporting file updates failed. Review the output above."
fi

echo ""
echo "✅ Phase 2 supporting file updates completed!"