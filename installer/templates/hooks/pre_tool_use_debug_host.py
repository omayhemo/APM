#!/usr/bin/env python3
"""
Pre-tool use hook for Debug Host MCP Server integration
Intercepts development server commands and redirects to MCP server
"""

import json
import sys
import re
import subprocess
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
                if "next" in pkg.get("dependencies", {}):
                    framework = "Next.js"
                elif "react-scripts" in pkg.get("dependencies", {}):
                    framework = "React"
                elif "vue" in pkg.get("dependencies", {}):
                    framework = "Vue"
                elif "angular" in pkg.get("devDependencies", {}):
                    framework = "Angular"
                else:
                    framework = "Node.js"
        except:
            pass
    elif os.path.exists("requirements.txt") or os.path.exists("Pipfile"):
        framework = "Python"
    elif os.path.exists("composer.json"):
        framework = "PHP"
    elif os.path.exists("Gemfile"):
        framework = "Ruby"
    elif os.path.exists("pom.xml"):
        framework = "Java/Maven"
    elif os.path.exists("build.gradle"):
        framework = "Java/Gradle"
    elif os.path.exists("go.mod"):
        framework = "Go"
    elif os.path.exists("Cargo.toml"):
        framework = "Rust"
    elif os.path.exists("*.csproj") or os.path.exists("*.sln"):
        framework = "DotNet"
    
    return {
        "cwd": cwd,
        "project_name": project_name,
        "framework": framework
    }

def send_voice_notification(message):
    """Send voice notification if TTS is configured"""
    voice_scripts = [
        "/mnt/c/Code/agentic-persona-mapping/.apm/agents/voice/speakOrchestrator.sh",
        "~/.apm/agents/voice/speakOrchestrator.sh",
        ".apm/agents/voice/speakOrchestrator.sh"
    ]
    
    for script in voice_scripts:
        script_path = os.path.expanduser(script)
        if os.path.exists(script_path):
            try:
                subprocess.run([script_path, message], 
                             capture_output=True, 
                             text=True, 
                             timeout=5)
                break
            except:
                pass

def main():
    # Read the tool use request from stdin
    try:
        request = json.load(sys.stdin)
    except json.JSONDecodeError:
        # Not JSON, pass through
        sys.exit(0)
    
    # Check if this is a Bash tool call
    tool_name = request.get("tool", {}).get("name", "")
    if tool_name != "Bash":
        # Not a bash command, pass through
        json.dump(request, sys.stdout)
        sys.exit(0)
    
    # Get the command
    parameters = request.get("tool", {}).get("parameters", {})
    command = parameters.get("command", "")
    
    # Check if it's a dev server command
    if not is_dev_server_command(command):
        # Not a dev server command, pass through
        json.dump(request, sys.stdout)
        sys.exit(0)
    
    # It's a dev server command - intercept it!
    project_info = get_project_info()
    
    # Send voice notification
    send_voice_notification(f"Intercepting {project_info['framework']} development server command. Redirecting to Debug Host MCP server.")
    
    # Create the MCP server start command instead
    mcp_command = {
        "tool": {
            "name": "server:start",
            "parameters": {
                "command": command,
                "cwd": project_info["cwd"],
                "sessionName": f"{project_info['project_name']}-{project_info['framework']}"
            }
        },
        "metadata": {
            "intercepted": True,
            "original_command": command,
            "reason": "Development server commands should use Debug Host MCP for persistent management",
            "project": project_info
        }
    }
    
    # Return a response that explains what happened
    response = {
        "type": "response",
        "status": "intercepted",
        "message": f"""
🚫 Direct server launch prevented - Using Debug Host MCP instead

Original command: {command}
Framework detected: {project_info['framework']}
Project: {project_info['project_name']}

The Debug Host MCP server will manage this development server for you.
Benefits:
- Server persists across Claude Code sessions
- Real-time monitoring at http://localhost:8080
- Centralized log management
- Process lifecycle control

To start the server, I'll use the MCP server:start tool instead.
To bypass this interception, prefix your command with BYPASS_MCP=1
""",
        "mcp_command": mcp_command
    }
    
    # Output the response
    json.dump(response, sys.stdout)
    
    # Exit with special code to indicate interception
    sys.exit(100)

if __name__ == "__main__":
    main()