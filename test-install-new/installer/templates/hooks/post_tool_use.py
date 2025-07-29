#!/usr/bin/env python3
"""
PostToolUse Hook - Executes after a tool is used

This hook receives JSON input with context about the tool that was executed
and its results. Useful for logging, formatting, or triggering follow-up actions.

Input format (via stdin):
{
    "tool": "ToolName",
    "parameters": {...},
    "result": {...},
    "success": true/false,
    "context": {...}
}

Return:
- Exit code 0: Success
- Exit code 1: Error (logged but doesn't affect tool result)
- JSON output (stdout): Optional messages or data
"""

import sys
import json
import subprocess
import os
from hook_utils import setup_logging, get_notification_manager

# Configure logging
logger = setup_logging('post_tool_use')


def main():
    """Main hook entry point"""
    try:
        # Read JSON input from stdin
        input_data = json.load(sys.stdin)
        logger.info(f"PostToolUse hook triggered: {input_data}")
        
        # Extract tool information
        tool_name = input_data.get('tool', 'Unknown')
        parameters = input_data.get('parameters', {})
        result = input_data.get('result', {})
        success = input_data.get('success', True)
        context = input_data.get('context', {})
        
        # Add your custom logic here
        # Example: Log results, trigger formatting, send notifications, etc.
        
        # For now, just log the execution
        if success:
            logger.info(f"Tool {tool_name} completed successfully")
        else:
            logger.warning(f"Tool {tool_name} failed")
        
        # Call notification manager for audio/TTS notifications
        notification_manager = get_notification_manager()
        
        if notification_manager:
            try:
                # Call notification manager
                status = "completed" if success else "failed"
                result = subprocess.run([
                    notification_manager, 'notify', 'post_tool',
                    context.get('persona', 'orchestrator'),
                    f"Tool {tool_name} {status}"
                ], capture_output=True, text=True)
                
                if result.returncode != 0:
                    logger.warning(f"Notification manager returned non-zero exit code: {result.returncode}")
                    if result.stderr:
                        logger.warning(f"Notification manager stderr: {result.stderr}")
            except Exception as e:
                logger.error(f"Failed to call notification manager: {e}")
        
        # Return success
        sys.exit(0)
        
    except Exception as e:
        logger.error(f"Error in PostToolUse hook: {e}")
        # On error, exit gracefully
        sys.exit(1)


if __name__ == "__main__":
    main()