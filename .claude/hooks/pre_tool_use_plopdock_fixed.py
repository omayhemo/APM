#!/usr/bin/env python3
"""
Pre-tool use hook for Plopdock MCP Server integration
Intercepts development server commands and blocks them with instructions to use MCP tools
"""

import re
import os

# Development server command patterns
DEV_SERVER_PATTERNS = [
    # Node.js/npm
    r'npm\s+(run\s+)?(start|dev|serve|develop)',
    r'yarn\s+(run\s+)?(start|dev|serve|develop)',
    r'pnpm\s+(run\s+)?(start|dev|serve|develop)',
    r'node\s+.*\.(js|mjs|ts)',
    r'nodemon\s+',
    r'next\s+(dev|start)',
    r'nuxt\s+(dev|start)',
    r'vite(\s+dev)?',
    r'webpack-dev-server',
    r'react-scripts\s+start',
    r'vue-cli-service\s+serve',
    r'ng\s+serve',
    r'gatsby\s+develop',
    
    # Python
    r'python\s+.*manage\.py\s+runserver',
    r'django-admin\s+runserver',
    r'flask\s+run',
    r'uvicorn\s+',
    r'gunicorn\s+',
    r'streamlit\s+run',
    r'python\s+-m\s+http\.server',
    r'python\s+.*app\.py',
    r'python\s+.*server\.py',
    
    # PHP
    r'php\s+artisan\s+serve',
    r'php\s+-S\s+',
    r'symfony\s+server:start',
    r'wp\s+server',
    
    # Ruby
    r'rails\s+server',
    r'rails\s+s\b',
    r'rackup',
    r'jekyll\s+serve',
    r'middleman\s+server',
    
    # Java
    r'mvn\s+spring-boot:run',
    r'gradle\s+bootRun',
    r'java\s+-jar\s+.*\.jar',
    
    # .NET
    r'dotnet\s+run',
    r'dotnet\s+watch',
    
    # Go
    r'go\s+run\s+',
    r'air\s+',  # Go live reload
    
    # Rust
    r'cargo\s+run',
    r'cargo\s+watch',
    
    # Docker
    r'docker-compose\s+up',
    r'docker\s+compose\s+up',
    
    # Generic patterns
    r'.*\s+serve(r)?\s*$',
    r'.*\s+dev(server)?\s*$',
    r'make\s+(run|serve|dev|start)',
]

def is_dev_server_command(command):
    """Check if command is a development server command"""
    if not command:
        return False
    
    command_lower = command.lower().strip()
    
    # Check for bypass flag
    if 'BYPASS_MCP=1' in command or 'bypass_mcp=1' in command_lower:
        return False
    
    # Check against patterns
    for pattern in DEV_SERVER_PATTERNS:
        if re.search(pattern, command_lower):
            return True
    
    return False

def get_project_info():
    """Get current project information"""
    cwd = os.getcwd()
    project_name = os.path.basename(cwd)
    
    # Try to detect framework
    framework = "unknown"
    if os.path.exists("package.json"):
        try:
            import json
            with open("package.json", "r") as f:
                pkg = json.load(f)
                if "next" in pkg.get("dependencies", {}):
                    framework = "next"
                elif "react-scripts" in pkg.get("dependencies", {}):
                    framework = "react"
                elif "vue" in pkg.get("dependencies", {}):
                    framework = "vue"
                elif "angular" in pkg.get("devDependencies", {}):
                    framework = "angular"
                else:
                    framework = "node"
        except:
            framework = "node"
    elif os.path.exists("requirements.txt") or os.path.exists("Pipfile"):
        framework = "python"
    elif os.path.exists("composer.json"):
        framework = "php"
    elif os.path.exists("Gemfile"):
        framework = "ruby"
    elif os.path.exists("pom.xml"):
        framework = "java"
    elif os.path.exists("build.gradle"):
        framework = "gradle"
    elif os.path.exists("go.mod"):
        framework = "go"
    elif os.path.exists("Cargo.toml"):
        framework = "rust"
    elif os.path.exists("*.csproj") or os.path.exists("*.sln"):
        framework = "dotnet"
    
    return {
        "cwd": cwd,
        "project_name": project_name,
        "framework": framework
    }

def pre_tool_use_hook(tool_name, params, context=None):
    """
    Hook function called before tool execution
    
    Args:
        tool_name: Name of the tool being called (e.g., "Bash")
        params: Dictionary of tool parameters
        context: Optional context dictionary
    
    Returns:
        Modified params dictionary or original params
    """
    
    # Only intercept Bash commands
    if tool_name != "Bash":
        return params
    
    # Get the command
    command = params.get("command", "")
    
    # Check if it's a dev server command
    if not is_dev_server_command(command):
        return params
    
    # Get project info
    project_info = get_project_info()
    
    # Block the command and provide instructions
    error_message = f"""
🚫 Development server command blocked by Plopdock hook

Original command: {command}
Project: {project_info['project_name']}
Framework: {project_info['framework']}
Directory: {project_info['cwd']}

INSTEAD, use the Plopdock MCP tools:

1. First register the project (if not already done):
   Use tool: mcp__plopdock__register_project
   Parameters:
   - name: "{project_info['project_name']}"
   - path: "{project_info['cwd']}"
   - type: "{project_info['framework']}"

2. Then start the server:
   Use tool: mcp__plopdock__host_start
   Parameters:
   - projectId: "{project_info['project_name']}"
   - command: "{command}"

Benefits of using Plopdock:
- Server persists across Claude sessions
- Real-time monitoring at http://localhost:2601
- Centralized log management
- Process lifecycle control

To bypass this hook (not recommended):
Run: BYPASS_MCP=1 {command}
"""
    
    # Modify the command to echo the error message instead
    params["command"] = f'echo "{error_message}"'
    
    return params

# Test when run directly
if __name__ == "__main__":
    test_params = {
        "command": "npm run dev"
    }
    
    result = pre_tool_use_hook("Bash", test_params)
    print("Original command:", test_params["command"])
    print("Modified command:", result["command"])