#!/usr/bin/env python3
"""
PreToolUse Hook - Executes before a tool is used
Now with integrated Document Location Enforcement

This hook receives JSON input with context about the tool about to be executed.
It can block or modify tool calls based on return values.

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
from pathlib import Path

# Try to import hook utilities
try:
    from hook_utils import setup_logging, get_notification_manager
    logger = setup_logging('pre_tool_use')
except ImportError:
    # Fallback if hook_utils not available
    import logging
    logging.basicConfig(level=logging.INFO)
    logger = logging.getLogger('pre_tool_use')
    get_notification_manager = lambda: None

# Import the location enforcer
try:
    # Add hooks directory to path
    hooks_dir = os.path.dirname(os.path.abspath(__file__))
    sys.path.insert(0, hooks_dir)
    from pre_tool_use_location_enforcer import DocumentLocationEnforcer
    ENFORCER_AVAILABLE = True
except ImportError as e:
    logger.warning(f"Document Location Enforcer not available: {e}")
    ENFORCER_AVAILABLE = False


def main():
    """Main hook entry point with integrated location enforcement"""
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
        # DOCUMENT LOCATION ENFORCEMENT
        # ============================================
        if ENFORCER_AVAILABLE and tool_name in ['Write', 'Edit', 'MultiEdit']:
            try:
                logger.info("Running Document Location Enforcement...")
                
                # Initialize enforcer
                enforcer = DocumentLocationEnforcer()
                
                # Process the hook
                modified_params = enforcer.process_hook(tool_name, parameters, context)
                
                # If parameters were modified, update the input data
                if modified_params != parameters:
                    # Update in the correct field name that Claude Code expects
                    if 'tool_input' in input_data:
                        input_data['tool_input'] = modified_params
                    else:
                        input_data['parameters'] = modified_params
                    logger.info(f"Document location corrected: {modified_params.get('file_path')}")
                    
                    # Output the modified parameters in the format Claude Code expects
                    print(json.dumps({
                        'modified': True,
                        'tool_input': modified_params,  # Claude Code expects 'tool_input' not 'parameters'
                        'message': f"✅ Document location corrected to: {modified_params.get('file_path')}"
                    }))
                    
            except Exception as e:
                logger.error(f"Error in Document Location Enforcement: {e}")
                # Continue without enforcement on error
        
        # ============================================
        # MCP DEBUG HOST ENFORCEMENT
        # ============================================
        if tool_name == 'Bash':
            # Check for development server commands
            command = parameters.get('command', '')
            dev_commands = ['npm run dev', 'npm start', 'python manage.py runserver', 
                          'flask run', 'php artisan serve', 'yarn dev', 'yarn start']
            
            for dev_cmd in dev_commands:
                if dev_cmd in command:
                    logger.warning(f"Detected development server command: {dev_cmd}")
                    
                    # Block and provide guidance
                    print(json.dumps({
                        'blocked': True,
                        'reason': 'Development server commands must use MCP Debug Host',
                        'suggestion': 'Use mcp__apm-debug-host__server_start instead',
                        'message': f"❌ Please use MCP Debug Host for '{dev_cmd}'\n" +
                                  "✅ Use: mcp__apm-debug-host__server_start"
                    }))
                    
                    # Block the tool execution
                    sys.exit(1)
        
        # ============================================
        # NOTIFICATIONS (Original functionality)
        # ============================================
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