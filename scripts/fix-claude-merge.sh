#!/bin/bash
# Fix for CLAUDE.md merge duplication issue

# Function to properly merge APM section into user's root CLAUDE.md file
merge_apm_section_fixed() {
    local root_claude_md="$1"
    local template_file="$2"
    
    # If file doesn't exist or template doesn't exist, handle error
    if [ ! -f "$template_file" ]; then
        echo "Error: Template file not found: $template_file"
        return 1
    fi
    
    # If CLAUDE.md doesn't exist, create it with the template
    if [ ! -f "$root_claude_md" ]; then
        echo "Creating new CLAUDE.md file..."
        cp "$template_file" "$root_claude_md"
        echo "✓ Created CLAUDE.md with APM section"
        return 0
    fi
    
    # File exists, check for APM section and merge
    if grep -q "<BEGIN-APM-CLAUDE-MERGE>" "$root_claude_md"; then
        echo "Existing APM section(s) found, cleaning and replacing with latest version..."
        
        # Create temporary files
        local temp_clean=$(mktemp)
        local temp_new=$(mktemp)
        
        # First, remove ALL APM sections (in case of duplicates)
        # This awk script removes everything between BEGIN and END tags, inclusive
        awk '
            /<BEGIN-APM-CLAUDE-MERGE>/ { in_apm = 1; next }
            /<END-APM-CLAUDE-MERGE>/ { in_apm = 0; next }
            !in_apm { print }
        ' "$root_claude_md" > "$temp_clean"
        
        # Remove any trailing blank lines from the cleaned content
        sed -i -e :a -e '/^\s*$/d;N;ba' "$temp_clean"
        
        # Now build the new file
        if [ -s "$temp_clean" ]; then
            # If there's content before APM section
            cat "$temp_clean" > "$temp_new"
            echo "" >> "$temp_new"  # Add separator
        fi
        
        # Add the new APM section
        cat "$template_file" >> "$temp_new"
        
        # Replace original file
        mv "$temp_new" "$root_claude_md"
        
        # Cleanup
        rm -f "$temp_clean"
        
        echo "✓ Cleaned duplicates and updated APM section in CLAUDE.md"
    else
        echo "No existing APM section found, appending to end of file..."
        
        # Add a newline if file doesn't end with one
        if [ -s "$root_claude_md" ] && [ "$(tail -c1 "$root_claude_md" | wc -l)" -eq 0 ]; then
            echo "" >> "$root_claude_md"
        fi
        
        # Append APM section
        cat "$template_file" >> "$root_claude_md"
        
        echo "✓ Added APM section to CLAUDE.md"
    fi
}

# Test the function if called directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "CLAUDE.md Merge Fix Utility"
    echo "=========================="
    
    if [ $# -lt 2 ]; then
        echo "Usage: $0 <path-to-CLAUDE.md> <path-to-template.claude.md>"
        echo "Example: $0 ~/CLAUDE.md ~/.apm/installer/template.claude.md"
        exit 1
    fi
    
    merge_apm_section_fixed "$1" "$2"
fi