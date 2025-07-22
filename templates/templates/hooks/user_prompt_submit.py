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
import logging
import os
from datetime import datetime

# Configure logging
log_dir = os.path.expanduser('~/.claude/logs')
os.makedirs(log_dir, exist_ok=True)

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler(os.path.join(log_dir, 'user_prompt_submit.log')),
        logging.FileHandler('/tmp/user_prompt_submit.log')  # Backwards compatibility
    ]
)
logger = logging.getLogger(__name__)


def main():
    """Main hook entry point"""
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
            project_root = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
            notification_manager = os.path.join(project_root, '.apm', 'agents', 'scripts', 'notification-manager.sh')
            
            if os.path.exists(notification_manager):
                import subprocess
                subprocess.run([
                    notification_manager, 'notify', 'user_prompt_submit',
                    'orchestrator',
                    'AP Orchestrator activation request received'
                ], capture_output=True)
        
        # Check for other persona activations
        persona_commands = {
            '/dev': 'developer',
            '/qa': 'qa',
            '/pm': 'pm',
            '/po': 'po',
            '/architect': 'architect',
            '/analyst': 'analyst',
            '/sm': 'sm',
            '/design-architect': 'design-architect'
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
        
        # Return success (allow prompt processing)
        sys.exit(0)
        
    except Exception as e:
        logger.error(f"Error in UserPromptSubmit hook: {e}", exc_info=True)
        # On error, allow prompt processing to prevent blocking Claude
        sys.exit(0)


if __name__ == "__main__":
    main()