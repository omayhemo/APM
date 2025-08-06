# MCP Debug Host Agent Integration Strategy

## Executive Summary

This document outlines the implementation strategy for automatically intercepting development server commands and redirecting agents to use the MCP Debug Host system.

## Implementation Overview

### 1. Pre-Tool Hook Integration

Create an enhanced `pre_tool_use.py` hook that intercepts Bash commands:

```python
#!/usr/bin/env python3

import sys
import json
import re
import logging
from datetime import datetime

# Configure logging
logging.basicConfig(
    filename='/home/user/.claude/hooks/logs/mcp_intercept.log',
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

# Development server command patterns
DEV_SERVER_PATTERNS = [
    # Node.js patterns
    r'npm\s+(run\s+)?(dev|start|serve)',
    r'yarn\s+(run\s+)?(dev|start|serve)',
    r'pnpm\s+(run\s+)?(dev|start|serve)',
    r'node\s+server\.js',
    r'nodemon',
    
    # Python patterns
    r'python\s+manage\.py\s+runserver',
    r'flask\s+run',
    r'uvicorn\s+\w+:app',
    r'python\s+-m\s+http\.server',
    
    # PHP patterns
    r'php\s+artisan\s+serve',
    r'php\s+-S\s+localhost',
    
    # Other patterns
    r'rails\s+server',
    r'bundle\s+exec\s+rails',
    r'cargo\s+run',
    r'go\s+run'
]

def is_dev_server_command(command):
    """Check if command is attempting to start a development server"""
    for pattern in DEV_SERVER_PATTERNS:
        if re.search(pattern, command, re.IGNORECASE):
            return True
    return False

def generate_mcp_suggestion(command):
    """Generate MCP Debug Host alternative suggestion"""
    return {
        "blocked": True,
        "reason": "Development server commands should use MCP Debug Host",
        "suggestion": {
            "message": "🚨 STOP! Use MCP Debug Host instead of direct server commands.",
            "instructions": [
                "The MCP Debug Host provides persistent server management that survives Claude sessions.",
                "",
                "Instead of running:",
                f"  {command}",
                "",
                "Use the MCP tool:",
                "  server:start with parameters:",
                "  - cwd: (project directory)",
                "  - sessionName: 'Development Server'",
                "",
                "Benefits:",
                "✅ Server persists across Claude sessions",
                "✅ Real-time log monitoring at http://localhost:8080",
                "✅ Automatic tech stack detection",
                "✅ Professional dashboard interface",
                "",
                "Dashboard: http://localhost:8080"
            ],
            "mcp_tool": "server:start",
            "parameters": {
                "cwd": "{{PROJECT_ROOT}}",
                "sessionName": "Development Server"
            }
        }
    }

def main():
    try:
        # Read input from stdin
        input_data = json.load(sys.stdin)
        
        tool_name = input_data.get('tool', 'Unknown')
        parameters = input_data.get('parameters', {})
        context = input_data.get('context', {})
        
        # Only process Bash tool calls
        if tool_name == 'Bash':
            command = parameters.get('command', '')
            
            # Check if this is a development server command
            if is_dev_server_command(command):
                logger.info(f"Intercepted dev server command: {command}")
                
                # Generate MCP suggestion
                response = generate_mcp_suggestion(command)
                
                # Output the response to stdout
                print(json.dumps(response, indent=2))
                
                # Return exit code 1 to block the command
                sys.exit(1)
        
        # Allow all other commands
        sys.exit(0)
        
    except Exception as e:
        logger.error(f"Hook error: {e}")
        # On error, allow command to proceed
        sys.exit(0)

if __name__ == "__main__":
    main()
```

### 2. Configuration Updates

Update `.claude/settings.json`:

```json
{
  "env": {
    "HOOK_PRE_TOOL_ENABLED": "true",
    "MCP_DEBUG_HOST_INTERCEPT": "true",
    "MCP_DEBUG_HOST_URL": "http://localhost:8080"
  },
  "hooks": {
    "PreToolUse": [{
      "matcher": "*",
      "hooks": [{
        "type": "command",
        "command": "python3 {{PROJECT_ROOT}}/.claude/hooks/pre_tool_use.py"
      }]
    }]
  }
}
```

### 3. Agent Awareness Update

Create a new knowledge base entry:

```markdown
## 🚨 CRITICAL: Development Server Management

**NEVER use direct bash commands to start development servers!**

### ❌ FORBIDDEN Commands:
- `npm run dev`
- `npm start`
- `python manage.py runserver`
- `php artisan serve`
- Any direct server start command

### ✅ REQUIRED: Use MCP Debug Host

**Always use the MCP Debug Host tools:**

```
Tool: server:start
Parameters:
- cwd: /path/to/project
- sessionName: "Descriptive Name"
```

**Benefits:**
- Servers persist across Claude sessions
- Real-time monitoring at http://localhost:8080
- Automatic tech stack detection
- Professional dashboard interface
- Integrated logging and debugging

**Dashboard Access:** http://localhost:8080
```

### 4. Voice Notification Integration

Enhance the hook to include voice notifications:

```python
# Add to the hook when blocking a command
import subprocess

def notify_mcp_redirect(command):
    """Send voice notification about MCP redirect"""
    message = f"Blocking direct server command. Please use MCP Debug Host instead for persistent server management."
    
    # Determine which agent is active and use appropriate voice
    voice_script = "/mnt/c/Code/agentic-persona-mapping/.apm/agents/voice/speakOrchestrator.sh"
    
    try:
        subprocess.run([
            "bash", voice_script, message
        ], capture_output=True, text=True)
    except:
        pass  # Silent fail for voice
```

## Implementation Benefits

### 1. **Automatic Enforcement**
- No need to update all agent personas immediately
- Hook intercepts ALL server start attempts
- Provides clear guidance on using MCP Debug Host

### 2. **Education Through Interruption**
- Agents learn to use MCP tools through repeated guidance
- Clear benefits shown in interception message
- Dashboard URL provided for verification

### 3. **Graceful Migration**
- Existing workflows continue with redirection
- No breaking changes to agent behavior
- Progressive adoption through usage

### 4. **Comprehensive Coverage**
- Detects all major framework patterns
- Language-agnostic implementation
- Extensible pattern matching

## Rollout Strategy

### Phase 1: Development Testing
1. Implement hook in test environment
2. Validate pattern matching
3. Test with various frameworks

### Phase 2: Soft Launch
1. Enable for specific projects
2. Monitor agent adaptation
3. Collect feedback

### Phase 3: Full Deployment
1. Enable globally
2. Update agent documentation
3. Remove legacy server start instructions

## Success Metrics

- **Interception Rate**: % of server commands redirected
- **Adoption Rate**: % of sessions using MCP Debug Host
- **Error Reduction**: Decrease in "server not found" issues
- **Session Persistence**: Increase in cross-session server availability

## Conclusion

This implementation provides a seamless transition to MCP Debug Host usage without requiring immediate updates to all agent personas. The pre-execution hook acts as an intelligent middleware, educating agents and users about the superior MCP Debug Host alternative while preventing the problematic direct server execution pattern.

---

**Next Steps:**
1. Review and approve implementation strategy
2. Create test environment for validation
3. Develop comprehensive test suite
4. Plan phased rollout schedule