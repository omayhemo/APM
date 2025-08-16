#!/usr/bin/env python3
"""
Pre-tool use hook for Plopdock MCP Server enforcement
Intercepts development server commands and modifies them to show instructions
"""

import json
import sys
import re
import os
import logging

# Setup logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger('plopdock_hook')

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
    if 'BYPASS_PLOPDOCK=1' in command or 'bypass_plopdock=1' in command_lower:
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
            with open("package.json", "r") as f:
                pkg = json.load(f)
                deps = {**pkg.get("dependencies", {}), **pkg.get("devDependencies", {})}
                
                if "next" in deps:
                    framework = "node"
                    port = "3000"  # Next.js default
                elif "react-scripts" in deps:
                    framework = "node"
                    port = "3000"  # React default
                elif "vue" in deps or "@vue/cli-service" in deps:
                    framework = "node"
                    port = "8080"  # Vue default
                elif "express" in deps:
                    framework = "node"
                    port = "3000"  # Express default
                else:
                    framework = "node"
                    port = "3000"
        except:
            framework = "node"
            port = "3000"
    elif os.path.exists("requirements.txt") or os.path.exists("Pipfile"):
        framework = "python"
        port = "8000"  # Django/Flask default
    elif os.path.exists("composer.json"):
        framework = "php"
        port = "8000"  # Laravel default
    elif os.path.exists("Gemfile"):
        framework = "ruby"
        port = "3000"  # Rails default
    elif os.path.exists("go.mod"):
        framework = "go"
        port = "8080"  # Go default
    else:
        framework = "static"
        port = "8080"
    
    return {
        "name": project_name,
        "path": cwd,
        "type": framework,
        "port": port
    }

def main():
    """Main hook entry point"""
    try:
        # Read JSON input from stdin
        input_data = json.load(sys.stdin)
        
        # Extract tool information
        tool_name = input_data.get('tool_name') or input_data.get('tool', 'Unknown')
        parameters = input_data.get('tool_input') or input_data.get('parameters', {})
        
        # Only process Bash commands
        if tool_name != 'Bash':
            # Not a bash command, pass through
            sys.exit(0)
        
        # Get the command
        command = parameters.get('command', '')
        
        # Check if it's a dev server command
        if not is_dev_server_command(command):
            # Not a dev server command, pass through
            sys.exit(0)
        
        # It's a dev server command - intercept it!
        project_info = get_project_info()
        
        # Create the instruction message
        instruction_message = f"""
╔════════════════════════════════════════════════════════════════════╗
║              🚫 Development Server Command Blocked                 ║
╠════════════════════════════════════════════════════════════════════╣
║                                                                    ║
║  Original Command: {command:<48}║
║  Project: {project_info['name']:<57}║
║  Framework: {project_info['type']:<55}║
║  Directory: {project_info['path']:<55}║
║                                                                    ║
║  ⚠️  INSTEAD, use the Plopdock MCP tools:                         ║
║                                                                    ║
║  Step 1: Register the project (if not already done)               ║
║  ────────────────────────────────────────────────────────         ║
║  Use tool: mcp__plopdock__register_project                        ║
║  Parameters:                                                       ║
║    name: "{project_info['name']}"                                                         ║
║    path: "{project_info['path']}"                                               ║
║    type: "{project_info['type']}"                                                         ║
║    port: {project_info['port']}                                                           ║
║                                                                    ║
║  Step 2: Start the server                                         ║
║  ────────────────────────────────────────────────────────         ║
║  Use tool: mcp__plopdock__host_start                              ║
║  Parameters:                                                       ║
║    projectId: "{project_info['name']}"                                                    ║
║    command: "{command}"                                            ║
║                                                                    ║
║  ✅ Benefits of using Plopdock:                                   ║
║  • Server persists across Claude sessions                         ║
║  • Real-time monitoring at http://localhost:2601                  ║
║  • Centralized log management                                     ║
║  • Process lifecycle control                                      ║
║                                                                    ║
║  To bypass this hook (not recommended):                           ║
║  Run: BYPASS_PLOPDOCK=1 {command:<41}║
║                                                                    ║
╚════════════════════════════════════════════════════════════════════╝
"""
        
        # Modify the command to echo the instructions
        modified_params = parameters.copy()
        modified_params['command'] = f'echo "{instruction_message}"'
        
        # Output the modified parameters
        print(json.dumps({
            'modified': True,
            'tool_input': modified_params,
            'message': f'🚫 Dev server command intercepted. Use Plopdock MCP tools instead.'
        }))
        
        # Exit successfully (allow the modified command to run)
        sys.exit(0)
        
    except Exception as e:
        logger.error(f"Error in Plopdock hook: {e}")
        # On error, allow tool execution to prevent blocking Claude
        sys.exit(0)

if __name__ == "__main__":
    main()