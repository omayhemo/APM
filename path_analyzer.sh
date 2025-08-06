#!/bin/bash

# APM Framework Path Reference Catalog Generator
# This script analyzes all files in the APM framework for path references

echo "# APM Framework - Complete Path Reference Catalog"
echo "Generated on: $(date)"
echo "Analysis of all files containing ANY path reference"
echo ""

# Initialize counters
total_files=0
files_with_paths=0

# Function to analyze a single file
analyze_file() {
    local file="$1"
    local classification="$2"
    
    # Count different types of path references
    local template_vars=$(grep -c '{{[^}]*}}' "$file" 2>/dev/null || echo 0)
    local shell_vars=$(grep -c '\$[A-Z_][A-Z0-9_]*' "$file" 2>/dev/null || echo 0)
    local hardcoded_paths=$(grep -c '"/[^"]*"' "$file" 2>/dev/null || echo 0)
    local relative_paths=$(grep -c '\./\|~/' "$file" 2>/dev/null || echo 0)
    local unix_paths=$(grep -c '/[a-zA-Z0-9]' "$file" 2>/dev/null || echo 0)
    
    local total_refs=$((template_vars + shell_vars + hardcoded_paths + relative_paths))
    
    # Update counters
    if [ "$total_files" = "" ]; then total_files=0; fi
    total_files=$((total_files + 1))
    
    if [ $total_refs -gt 0 ] || [ $unix_paths -gt 0 ]; then
        files_with_paths=$((files_with_paths + 1))
        
        echo "## File: $file"
        echo "- **Classification**: $classification"
        echo "- **Total path references**: $total_refs"
        echo "- **Template variables ({{VAR}})**: $template_vars"
        echo "- **Shell variables (\$VAR)**: $shell_vars" 
        echo "- **Hardcoded paths**: $hardcoded_paths"
        echo "- **Relative paths**: $relative_paths"
        echo "- **Unix path patterns**: $unix_paths"
        
        # Show specific template variables if any
        if [ $template_vars -gt 0 ]; then
            echo "- **Template variables found**:"
            grep -o '{{[^}]*}}' "$file" 2>/dev/null | sort | uniq -c | sed 's/^/  - /'
        fi
        
        # Show specific shell variables if any
        if [ $shell_vars -gt 0 ]; then
            echo "- **Shell variables found**:"
            grep -o '\$[A-Z_][A-Z0-9_]*' "$file" 2>/dev/null | sort | uniq -c | head -10 | sed 's/^/  - /'
        fi
        
        echo ""
    fi
}

echo "## 1. INSTALLER SCRIPT"
echo ""
analyze_file "installer/install.sh" "Main installer script"

echo "## 2. TEMPLATE FILES"
echo ""

# Analyze different categories of template files
echo "### 2.1 Main Configuration Templates"
find installer/templates -maxdepth 1 -name "*.template" -type f | sort | while read file; do
    analyze_file "$file" "Main configuration template"
done

echo "### 2.2 Claude Command Templates" 
find installer/templates/claude/commands -name "*.template" -type f | sort | head -20 | while read file; do
    analyze_file "$file" "Claude command template"
done

echo "### 2.3 Agent Persona Templates"
find installer/templates/agents/personas -name "*.template" -type f | sort | head -10 | while read file; do
    analyze_file "$file" "Agent persona template"
done

echo "### 2.4 Voice Script Templates"
find installer/templates -name "*.sh" -path "*/voice/*" -type f | sort | while read file; do
    analyze_file "$file" "Voice script"
done

echo "### 2.5 Other Script Templates"
find installer/templates -name "*.sh" -not -path "*/voice/*" -type f | sort | head -10 | while read file; do
    analyze_file "$file" "Utility script"
done

echo "### 2.6 Hook Templates"
find installer/templates -name "*.py" -type f | sort | while read file; do
    analyze_file "$file" "Python hook"
done

echo "### 2.7 Configuration File Templates"
find installer/templates -name "*.json" -o -name "*.yaml" -o -name "*.yml" | sort | while read file; do
    analyze_file "$file" "Configuration file"
done

echo "## SUMMARY"
echo "- Total files analyzed: $total_files" 
echo "- Files with path references: $files_with_paths"
echo "- Analysis complete: $(date)"