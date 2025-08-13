#!/usr/bin/env python3
"""
PreToolUse Hook - Executes before a tool is used

This hook receives JSON input with context about the tool about to be executed.
It can block or modify tool calls based on return values.

Features:
- Plopdock MCP Server integration for development server interception
- Document location enforcement
- Audio/TTS notifications

Input format (via stdin):
{
    "tool": "ToolName",
    "parameters": {...},
    "context": {...}
}

Return:
- Exit code 0: Allow tool execution
- Exit code 1: Block tool execution
- JSON output (stdout): Optional modifications or messages
"""

import sys
import json
import subprocess
import os
import re
from hook_utils import setup_logging, get_notification_manager

# Configure logging
logger = setup_logging('pre_tool_use')

# ============================================
# PLOPDOCK MCP INTEGRATION
# ============================================

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

def send_plopdock_voice_notification(message):
    """Send voice notification for Plopdock interception"""
    voice_scripts = [
        "{{AP_ROOT}}/voice/speakOrchestrator.sh",
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

def process_plopdock_interception(tool_name, parameters, context):
    """Process Plopdock MCP interception if enabled"""
    
    # Check if Plopdock MCP is enabled
    plopdock_enabled = os.environ.get('PLOPDOCK_MCP_ENABLED', 'false').lower() == 'true'
    if not plopdock_enabled:
        return None
    
    logger.info("Plopdock MCP integration is enabled")
    
    # Only intercept Bash tool calls
    if tool_name != "Bash":
        return None
    
    # Get the command
    command = parameters.get("command", "")
    
    # Check for bypass flag
    if command.strip().startswith("BYPASS_MCP=1"):
        logger.info("Plopdock interception bypassed by user request")
        return None
    
    # Check if it's a dev server command
    if not is_dev_server_command(command):
        return None
    
    # It's a dev server command - intercept it!
    logger.info(f"Intercepting development server command: {command}")
    
    project_info = get_project_info()
    
    # Send voice notification
    send_plopdock_voice_notification(f"Intercepting {project_info['framework']} development server command. Redirecting to Plopdock MCP server.")
    
    # Get dashboard URL from environment
    dashboard_url = os.environ.get('PLOPDOCK_MCP_URL', 'http://localhost:8080')
    
    # Create the response that explains what happened
    response = {
        "type": "response",
        "status": "intercepted",
        "message": f"""
🚫 Direct server launch prevented - Using Plopdock MCP instead

Original command: {command}
Framework detected: {project_info['framework']}
Project: {project_info['project_name']}

The Plopdock MCP server will manage this development server for you.
Benefits:
- Server persists across Claude Code sessions
- Real-time monitoring at {dashboard_url}
- Centralized log management
- Process lifecycle control

I'll use the MCP server:start tool instead to launch your server.
To bypass this interception, prefix your command with BYPASS_MCP=1
""",
        "mcp_command": {
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
                "reason": "Development server commands should use Plopdock MCP for persistent management",
                "project": project_info
            }
        }
    }
    
    return response


def main():
    """Main hook entry point"""
    try:
        # Read JSON input from stdin
        input_data = json.load(sys.stdin)
        logger.info(f"PreToolUse hook triggered: {input_data}")
        
        # Extract tool information
        # Claude Code sends 'tool_name' and 'tool_input', not 'tool' and 'parameters'
        tool_name = input_data.get('tool_name') or input_data.get('tool', 'Unknown')
        parameters = input_data.get('tool_input') or input_data.get('parameters', {})
        context = input_data.get('context', {})
        
        # ============================================
        # PLOPDOCK MCP INTERCEPTION (FIRST PRIORITY)
        # ============================================
        plopdock_response = process_plopdock_interception(tool_name, parameters, context)
        if plopdock_response:
            # Plopdock intercepted the command - return the interception response
            logger.info("Command intercepted by Plopdock MCP integration")
            print(json.dumps(plopdock_response))
            # Exit with special code to indicate interception
            sys.exit(100)
        
        # ============================================
        # DOCUMENT LOCATION ENFORCEMENT
        # ============================================
        if tool_name in ['Write', 'Edit', 'MultiEdit']:
            try:
                # Import location enforcer (if available)
                from pre_tool_use_location_enforcer import DocumentLocationEnforcer
                logger.info("Running Document Location Enforcement...")
                
                # Initialize enforcer
                enforcer = DocumentLocationEnforcer()
                
                # Process the hook
                modified_params = enforcer.process_hook(tool_name, parameters, context)
                
                # If parameters were modified, update them
                if modified_params != parameters:
                    parameters = modified_params
                    # Update in the correct field name that Claude Code expects
                    if 'tool_input' in input_data:
                        input_data['tool_input'] = modified_params
                    else:
                        input_data['parameters'] = modified_params
                    logger.info(f"Document location corrected: {modified_params.get('file_path')}")
                    
                    # Output the modified parameters in the format Claude Code expects
                    print(json.dumps({
                        'modified': True,
                        'tool_input': modified_params  # Claude Code expects 'tool_input' not 'parameters'
                    }))
                    
                    # Exit immediately so Claude Code gets the JSON
                    sys.exit(0)
                    
            except ImportError:
                logger.info("Document Location Enforcer not installed, skipping")
            except Exception as e:
                logger.error(f"Error in Document Location Enforcement: {e}")
        
        # Log the tool usage
        logger.info(f"Processing tool: {tool_name}")
        
        # Call notification manager for audio/TTS notifications
        notification_manager = get_notification_manager()
        
        if notification_manager:
            try:
                # Call notification manager
                result = subprocess.run([
                    notification_manager, 'notify', 'pre_tool',
                    context.get('persona', 'orchestrator'),
                    f"Using tool: {tool_name}"
                ], capture_output=True, text=True)
                
                if result.returncode != 0:
                    logger.warning(f"Notification manager returned non-zero exit code: {result.returncode}")
                    if result.stderr:
                        logger.warning(f"Notification manager stderr: {result.stderr}")
            except Exception as e:
                logger.error(f"Failed to call notification manager: {e}")
        
        # Return success (allow tool execution)
        sys.exit(0)
        
    except Exception as e:
        logger.error(f"Error in PreToolUse hook: {e}")
        # On error, allow tool execution to prevent blocking Claude
        sys.exit(0)


if __name__ == "__main__":
    main()