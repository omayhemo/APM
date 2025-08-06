#!/bin/bash

# Simple APM Framework Path Reference Catalog
echo "# APM Framework - Path Reference Catalog"
echo "Generated on: $(date)"
echo ""

# Function to analyze a file and output results
analyze_file() {
    local file="$1"
    local classification="$2"
    
    # Count path references
    local template_vars=$(grep -o '{{[^}]*}}' "$file" 2>/dev/null | wc -l)
    local shell_vars=$(grep -o '\$[A-Z_][A-Z0-9_]*' "$file" 2>/dev/null | wc -l)
    local hardcoded_paths=$(grep -o '"/[^"]*"' "$file" 2>/dev/null | wc -l)
    local relative_paths=$(grep -c '\./\|~/' "$file" 2>/dev/null)
    
    # Calculate total
    local total=$((template_vars + shell_vars + hardcoded_paths + relative_paths))
    
    # Only show files with path references
    if [ $total -gt 0 ]; then
        echo "## $file"
        echo "- **Type**: $classification"
        echo "- **Total references**: $total"
        echo "- **Template variables**: $template_vars"
        echo "- **Shell variables**: $shell_vars"
        echo "- **Hardcoded paths**: $hardcoded_paths" 
        echo "- **Relative paths**: $relative_paths"
        
        # Show template variables if found
        if [ $template_vars -gt 0 ]; then
            echo "- **Template variables found**:"
            grep -o '{{[^}]*}}' "$file" 2>/dev/null | sort | uniq -c | head -10 | sed 's/^/  /'
        fi
        
        echo ""
    fi
}

echo "## 1. INSTALLER SCRIPT"
analyze_file "installer/install.sh" "Main installer script"

echo "## 2. MAIN TEMPLATES"
for file in installer/templates/*.template; do
    if [ -f "$file" ]; then
        analyze_file "$file" "Main configuration template"
    fi
done

echo "## 3. CLAUDE COMMAND TEMPLATES"
count=0
for file in installer/templates/claude/commands/*.template; do
    if [ -f "$file" ] && [ $count -lt 15 ]; then
        analyze_file "$file" "Claude command template"
        count=$((count + 1))
    fi
done

echo "## 4. VOICE SCRIPTS"  
for file in installer/templates/voice/*.sh; do
    if [ -f "$file" ]; then
        analyze_file "$file" "Voice script"
    fi
done

echo "## 5. UTILITY SCRIPTS"
count=0
for file in installer/templates/scripts/*.sh installer/templates/*/*.sh; do
    if [ -f "$file" ] && [[ "$file" != *voice* ]] && [ $count -lt 10 ]; then
        analyze_file "$file" "Utility script"
        count=$((count + 1))
    fi
done

echo "## 6. PERSONA TEMPLATES"
count=0
for file in installer/templates/agents/personas/*.template; do
    if [ -f "$file" ] && [ $count -lt 10 ]; then
        analyze_file "$file" "Agent persona template"
        count=$((count + 1))
    fi
done

echo "## 7. OTHER FILES"
for file in installer/*.sh installer/*.py; do
    if [ -f "$file" ]; then
        analyze_file "$file" "Other installer file"
    fi
done