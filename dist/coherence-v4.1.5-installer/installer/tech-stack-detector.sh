#!/bin/bash

detect_project_tech_stack() {
    local project_dir="$1"
    local tech_stack=""
    
    # Node.js detection
    if [ -f "$project_dir/package.json" ]; then
        tech_stack="nodejs"
        
        # Detect specific frameworks
        if grep -q '"next"' "$project_dir/package.json"; then
            tech_stack="nodejs-nextjs"
        elif grep -q '"react"' "$project_dir/package.json"; then
            tech_stack="nodejs-react"
        elif grep -q '"@angular/core"' "$project_dir/package.json"; then
            tech_stack="nodejs-angular"
        elif grep -q '"vue"' "$project_dir/package.json"; then
            tech_stack="nodejs-vue"
        fi
        
    # Python detection
    elif [ -f "$project_dir/requirements.txt" ] || [ -f "$project_dir/setup.py" ] || [ -f "$project_dir/pyproject.toml" ]; then
        tech_stack="python"
        
        # Django detection
        if [ -f "$project_dir/manage.py" ]; then
            tech_stack="python-django"
        # Flask detection
        elif grep -q "flask" "$project_dir/requirements.txt" 2>/dev/null; then
            tech_stack="python-flask"
        # FastAPI detection
        elif grep -q "fastapi" "$project_dir/requirements.txt" 2>/dev/null; then
            tech_stack="python-fastapi"
        fi
        
    # PHP detection
    elif [ -f "$project_dir/composer.json" ]; then
        tech_stack="php"
        
        # Laravel detection
        if [ -f "$project_dir/artisan" ]; then
            tech_stack="php-laravel"
        fi
        
    # Ruby detection
    elif [ -f "$project_dir/Gemfile" ]; then
        tech_stack="ruby"
        
        # Rails detection
        if grep -q "rails" "$project_dir/Gemfile"; then
            tech_stack="ruby-rails"
        fi
        
    # Go detection
    elif [ -f "$project_dir/go.mod" ]; then
        tech_stack="go"
        
    # Rust detection
    elif [ -f "$project_dir/Cargo.toml" ]; then
        tech_stack="rust"
        
    else
        tech_stack="unknown"
    fi
    
    echo "$tech_stack"
}

# Validate MCP can run the detected tech stack
validate_mcp_compatibility() {
    local tech_stack="$1"
    
    case "$tech_stack" in
        nodejs*|python*|php*|ruby*|go|rust)
            return 0  # Compatible
            ;;
        unknown)
            echo "Warning: Unable to detect project tech stack"
            echo "MCP Debug Host will attempt auto-detection at runtime"
            return 0  # Allow with warning
            ;;
        *)
            echo "Error: Unsupported tech stack for MCP Debug Host"
            return 1
            ;;
    esac
}