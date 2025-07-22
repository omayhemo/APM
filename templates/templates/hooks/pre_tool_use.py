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
        tool_name = input_data.get('tool', 'Unknown')
        parameters = input_data.get('parameters', {})
        context = input_data.get('context', {})
        
        # Add your custom logic here
        # Example: Check if tool is allowed, validate parameters, etc.
        
        # For now, just log and allow all tools
        logger.info(f"Allowing tool: {tool_name}")
        
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