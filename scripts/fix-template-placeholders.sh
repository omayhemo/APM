#!/bin/bash

# Fix template placeholder issues
# Created to resolve missing persona names in templates

echo "🔧 Fixing template placeholder issues..."

# Function to fix placeholders in a single file
fix_template_placeholders() {
    local file="$1"
    echo "  📝 Processing: $file"
    
    # Create backup
    cp "$file" "$file.placeholder-backup"
    
    # Extract agent from YAML frontmatter or use default mapping
    local agent=""
    
    # Try to extract agent from YAML frontmatter
    if grep -q "agent:" "$file"; then
        agent=$(grep "^  agent:" "$file" | head -1 | sed 's/.*agent: //' | sed 's/^ *//' | sed 's/ *$//')
    fi
    
    # Map command names to personas if agent is empty
    if [[ -z "$agent" ]]; then
        local filename=$(basename "$file")
        case "$filename" in
            *brainstorming*|*requirements*|*stakeholder*|*research*) agent="Analyst" ;;
            *epic*|*stories*|*acceptance*|*validation*|*prioritization*|*groom*) agent="Product Owner" ;;
            *architecture*|*frontend*) agent="Architect" ;;
            *checklist*|*course-correction*|*next-story*|*sprint*) agent="Scrum Master" ;;
            *quality*|*automation*|*test*|*qa*) agent="QA" ;;
            *ux-spec*|*design*) agent="Design Architect" ;;
            *) agent="Product Owner" ;;  # Default fallback
        esac
    fi
    
    # Map agent names to persona context names and voice commands
    local persona_context=""
    local speak_command=""
    
    case "$agent" in
        "Analyst") 
            persona_context="Analyst"
            speak_command="{{SPEAK_ANALYST}}"
            ;;
        "Product Owner"|"PO") 
            persona_context="Product Owner"
            speak_command="{{SPEAK_PO}}"
            ;;
        "Architect") 
            persona_context="Architect"
            speak_command="{{SPEAK_ARCHITECT}}"
            ;;
        "Scrum Master"|"SM") 
            persona_context="Scrum Master"
            speak_command="{{SPEAK_SM}}"
            ;;
        "QA") 
            persona_context="QA"
            speak_command="{{SPEAK_QA}}"
            ;;
        "Design Architect") 
            persona_context="Design Architect"
            speak_command="{{SPEAK_DESIGN_ARCHITECT}}"
            ;;
        "Developer") 
            persona_context="Developer"
            speak_command="{{SPEAK_DEVELOPER}}"
            ;;
        *) 
            persona_context="Product Owner"
            speak_command="{{SPEAK_PO}}"
            ;;
    esac
    
    # Fix the placeholder issues
    sed -i "s/\*\*This command requires the  persona\.\*\*/\*\*This command requires the ${persona_context} persona.\*\*/" "$file"
    sed -i "s/\*Loading  context for/\*Loading ${persona_context} context for/" "$file"
    sed -i "s/- Loading  configuration and expertise/- Loading ${persona_context} configuration and expertise/" "$file"
    sed -i "s/bash {{SPEAK_}} \"/bash ${speak_command} \"/" "$file"
    
    # Fix agent field if it's empty
    if [[ -z "$(grep "agent:" "$file" | sed 's/.*agent: //' | sed 's/^ *//' | sed 's/ *$//')" ]]; then
        sed -i "s/agent: $/agent: ${agent}/" "$file"
        sed -i "s/agent:$/agent: ${agent}/" "$file"
    fi
    
    echo "    ✅ Fixed placeholders for $persona_context persona"
}

# Get all files with placeholder issues
files_with_issues=($(find /mnt/c/Code/agentic-persona-mapping/payload/templates -name "*.template" -exec grep -l "agent: $\|**This command requires the  persona\|*Loading  context" {} \; 2>/dev/null))

echo "Found ${#files_with_issues[@]} files with placeholder issues"

# Process each file
for file in "${files_with_issues[@]}"; do
    if [ -f "$file" ]; then
        fix_template_placeholders "$file"
    else
        echo "  ⚠️  File not found: $file"
    fi
done

echo ""
echo "🎯 Summary:"
echo "   📄 Files processed: ${#files_with_issues[@]}"
echo "   💾 Backup files created with .placeholder-backup extension"
echo ""
echo "✅ Template placeholder fixes completed successfully!"