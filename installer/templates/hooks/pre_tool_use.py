#!/usr/bin/env python3
"""
PreToolUse Hook - Executes before a tool is used

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
from hook_utils import setup_logging, get_notification_manager

# Configure logging
logger = setup_logging('pre_tool_use')


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