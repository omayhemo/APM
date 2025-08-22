#!/usr/bin/env python3
"""
UserPromptSubmit Hook - Executes when the user submits a prompt

This hook fires when the user submits a prompt, before Claude processes it.
Can be used to log prompts, modify them, or trigger actions.

Input format (via stdin):
{
    "session_id": "session-uuid",
    "transcript_path": "/path/to/transcript.jsonl",
    "prompt": "user's submitted prompt text"
}

Return:
- Exit code 0: Success, continue processing
- Exit code 1: Block prompt processing
- JSON output (stdout): Optional modifications or messages
"""

import sys
import json
import os
from datetime import datetime

# Add current directory to Python path for hook_utils import
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

try:
    from hook_utils import setup_logging, get_notification_manager
    logger = setup_logging('user_prompt_submit')
except Exception as e:
    # Fallback logging if hook_utils fails
    import logging
    
    # Try to find project root for fallback logging
    current_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    project_root = None
    for _ in range(10):
        if os.path.exists(os.path.join(current_dir, '.claude')):
            project_root = current_dir
            break
        parent = os.path.dirname(current_dir)
        if parent == current_dir:
            break
        current_dir = parent
    
    if project_root:
        log_dir = os.path.join(project_root, '.claude', 'hooks', 'logs')
    else:
        log_dir = os.path.join(os.getcwd(), '.claude', 'hooks', 'logs')
    
    os.makedirs(log_dir, exist_ok=True)
    
    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
        handlers=[
            logging.FileHandler(os.path.join(log_dir, 'user_prompt_submit.log')),
            logging.FileHandler('/tmp/user_prompt_submit_fallback.log')
        ]
    )
    logger = logging.getLogger('user_prompt_submit')
    logger.error(f"Failed to import hook_utils: {e}")
    
    # Define fallback function
    def get_notification_manager():
        return None


def main():
    """Main hook entry point"""
    # Debug: Try to write to project-local location to verify hook is running
    debug_locations = []
    
    # Try to find project root
    current_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    for _ in range(10):
        if os.path.exists(os.path.join(current_dir, '.claude')):
            debug_locations.append(os.path.join(current_dir, '.claude', 'hooks', 'logs', 'user_prompt_submit_started.log'))
            break
        parent = os.path.dirname(current_dir)
        if parent == current_dir:
            break
        current_dir = parent
    
    # Fallback to /tmp if project root not found
    if not debug_locations:
        debug_locations.append('/tmp/user_prompt_submit_started.log')
    
    for debug_log in debug_locations:
        try:
            os.makedirs(os.path.dirname(debug_log), exist_ok=True)
            with open(debug_log, 'a') as f:
                f.write(f"Hook started at {datetime.now().isoformat()}\n")
        except:
            pass
    
    try:
        # Read JSON input from stdin
        input_data = json.load(sys.stdin)
        
        # Log full payload
        logger.info(f"UserPromptSubmit hook triggered with payload: {json.dumps(input_data, indent=2)}")
        
        # Extract input fields
        session_id = input_data.get('session_id', 'unknown')
        transcript_path = input_data.get('transcript_path', '')
        prompt = input_data.get('prompt', '')
        
        # Log prompt submission
        timestamp = datetime.now().isoformat()
        logger.info(f"[{timestamp}] Session {session_id}: User submitted prompt")
        logger.info(f"Prompt: {prompt[:200]}{'...' if len(prompt) > 200 else ''}")
        
        # Check for AP commands
        if prompt.strip().lower() in ['ap', '/ap', 'ap_orchestrator', '/ap_orchestrator']:
            logger.info("AP Orchestrator activation detected")
            
            # Call notification manager for AP activation
            notification_manager = get_notification_manager()
            
            if notification_manager:
                import subprocess
                result = subprocess.run([
                    notification_manager, 'notify', 'user_prompt_submit',
                    'orchestrator',
                    'AP Orchestrator activation request received'
                ], capture_output=True, text=True)
                
                if result.returncode != 0:
                    logger.warning(f"Notification manager failed: {result.stderr}")
        
        # Check for other persona activations
        persona_commands = {
            '/dev': 'developer',
            '/qa': 'qa',
            '/pm': 'pm',
            '/po': 'po',
            '/architect': 'architect',
            '/analyst': 'analyst',
            '/sm': 'sm',
            '/designer': 'designer'
        }
        
        for cmd, persona in persona_commands.items():
            if prompt.strip().lower() == cmd:
                logger.info(f"{persona.capitalize()} persona activation detected")
                break
        
        # Example: Block certain prompts (disabled by default)
        # blocked_patterns = ['delete all', 'rm -rf', 'drop database']
        # for pattern in blocked_patterns:
        #     if pattern in prompt.lower():
        #         logger.warning(f"Blocked prompt containing: {pattern}")
        #         print(json.dumps({"blocked": True, "reason": f"Prompt contains blocked pattern: {pattern}"}))
        #         sys.exit(1)
        
        # Check for append text configuration
        append_text = os.environ.get('PROMPT_APPEND_TEXT', '').strip()
        
        if append_text:
            # Append configured text to the prompt with a space separator
            modified_prompt = f"{prompt} {append_text}"
            logger.info(f"Appending text to prompt: '{append_text}'")
            logger.info(f"Modified prompt length: {len(modified_prompt)} chars")
            
            # Return the modified prompt to Claude
            output = {
                "hookSpecificOutput": {
                    "hookEventName": "UserPromptSubmit",
                    "additionalContext": f" {append_text}"
                }
            }
            
            # Print the output as JSON
            print(json.dumps(output))
            logger.info(f"Successfully appended text to prompt")
        else:
            logger.info("No append text configured (PROMPT_APPEND_TEXT is empty or not set)")
        
        # Return success (allow prompt processing)
        sys.exit(0)
        
    except Exception as e:
        logger.error(f"Error in UserPromptSubmit hook: {e}", exc_info=True)
        # On error, allow prompt processing to prevent blocking Claude
        sys.exit(0)


if __name__ == "__main__":
    main()