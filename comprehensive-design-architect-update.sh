#!/bin/bash

# Comprehensive script to update all remaining designer references to designer
echo "🔄 Starting comprehensive designer to designer migration..."

# Find all files with designer references (excluding backups and git)
FILES=($(find . -type f \( -name "*.md" -o -name "*.template" -o -name "*.sh" -o -name "*.json" -o -name "*.py" \) -not -path "./.claude/hooks/compact_backups/*" -not -path "./.git/*" -exec grep -l "designer" {} \;))

echo "📊 Found ${#FILES[@]} files with designer references"

# Comprehensive replacement patterns
declare -A REPLACEMENTS=(
    ["speakDesigner"]="speakDesigner"
    ["SPEAK_DESIGNER"]="SPEAK_DESIGNER"
    ["designer"]="designer"
    ["Designer"]="Designer"
    ["designer"]="designer"
    ["/designer"]="/designer"
    ["designer.md"]="designer.md"
    ["designer.persona.json"]="designer.persona.json"
    ["\"designer\""]="\"designer\""
    ["'designer'"]="'designer'"
    ["\`designer\`"]="\`designer\`"
)

updated_count=0

# Process each file
for file in "${FILES[@]}"; do
    if [[ -f "$file" ]]; then
        echo "📝 Processing: $file"
        
        # Create backup
        temp_file=$(mktemp)
        cp "$file" "$temp_file"
        
        # Apply all replacements
        for search in "${!REPLACEMENTS[@]}"; do
            replacement="${REPLACEMENTS[$search]}"
            sed -i "s|$search|$replacement|g" "$temp_file"
        done
        
        # Check if file changed
        if ! cmp -s "$file" "$temp_file"; then
            cp "$temp_file" "$file"
            echo "✅ Updated: $file"
            ((updated_count++))
        else
            echo "⏭️  No changes needed: $file"
        fi
        
        rm "$temp_file"
    else
        echo "⚠️  File not found: $file"
    fi
done

echo ""
echo "🎯 Comprehensive Migration Summary:"
echo "   📊 Files processed: ${#FILES[@]}"
echo "   ✅ Files updated: $updated_count"
echo "   📂 Files unchanged: $((${#FILES[@]} - updated_count))"

# Verify remaining references
remaining=$(find . -type f \( -name "*.md" -o -name "*.template" -o -name "*.sh" -o -name "*.json" -o -name "*.py" \) -not -path "./.claude/hooks/compact_backups/*" -not -path "./.git/*" -exec grep -l "designer" {} \; | wc -l)

echo "   🔍 Remaining files with references: $remaining"

if [ "$remaining" -eq 0 ]; then
    echo "✨ SUCCESS: All designer references updated to designer!"
else
    echo "⚠️  WARNING: $remaining files still contain designer references"
    echo "🔍 Remaining files:"
    find . -type f \( -name "*.md" -o -name "*.template" -o -name "*.sh" -o -name "*.json" -o -name "*.py" \) -not -path "./.claude/hooks/compact_backups/*" -not -path "./.git/*" -exec grep -l "designer" {} \;
fi