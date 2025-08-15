#!/usr/bin/env python3
"""
Enhanced UserPromptSubmit Hook - Detects output style usage and injects voice commands
"""

import sys
import json
import os
import re
from datetime import datetime

# Setup logging
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

try:
    from hook_utils import setup_logging
    logger = setup_logging('user_prompt_submit_enhanced')
except:
    import logging
    logging.basicConfig(level=logging.INFO)
    logger = logging.getLogger('user_prompt_submit_enhanced')

# Map output styles to voice scripts
STYLE_TO_VOICE = {
    'apm-orchestrator': '/mnt/c/Code/agentic-persona-mapping/.apm/agents/voice/speakOrchestrator.sh',
    'apm-orchestrator-enhanced': '/mnt/c/Code/agentic-persona-mapping/.apm/agents/voice/speakOrchestrator.sh',
    'analyst': '/mnt/c/Code/agentic-persona-mapping/.apm/agents/voice/speakAnalyst.sh',
    'developer': '/mnt/c/Code/agentic-persona-mapping/.apm/agents/voice/speakDeveloper.sh',
    'qa': '/mnt/c/Code/agentic-persona-mapping/.apm/agents/voice/speakQa.sh',
    'architect': '/mnt/c/Code/agentic-persona-mapping/.apm/agents/voice/speakArchitect.sh',
}

def detect_output_style_command(prompt):
    """
    Detect if prompt contains /output-style command
    Returns style name if found, None otherwise
    """
    # Look for /output-style patterns
    patterns = [
        r'/output-style\s+(\S+)',  # Direct command
        r'/output-style:\s*(\S+)',  # With colon
        r'Set output style to.*\[1m(.*?)\[22m',  # Terminal output format
    ]
    
    for pattern in patterns:
        match = re.search(pattern, prompt, re.IGNORECASE)
        if match:
            style_name = match.group(1).strip()
            # Clean up ANSI codes if present
            style_name = re.sub(r'\[.*?m', '', style_name)
            return style_name.lower()
    
    return None

def main():
    try:
        # Read input
        input_data = json.load(sys.stdin)
        prompt = input_data.get('prompt', '')
        session_id = input_data.get('session_id', 'unknown')
        
        logger.info(f"Processing prompt for session {session_id}")
        
        # Check for output style command
        style = detect_output_style_command(prompt)
        
        if style:
            logger.info(f"Detected output style change to: {style}")
            
            # Get corresponding voice script
            voice_script = STYLE_TO_VOICE.get(style)
            
            if voice_script:
                # Inject voice announcement instruction
                announcement = f"\n\nIMPORTANT: Output style changed to '{style}'. Use this command to announce:\nbash {voice_script} \"Output style {style} activated.\""
                
                output = {
                    "hookSpecificOutput": {
                        "hookEventName": "UserPromptSubmit",
                        "additionalContext": announcement
                    }
                }
                
                logger.info(f"Injecting voice command for style: {style}")
                print(json.dumps(output))
                sys.exit(0)
        
        # Check if this is the FIRST prompt after output style change
        # This is a workaround since we can't detect the actual change
        if prompt and not prompt.startswith('/'):
            # Check for style markers in recent session
            # This would require maintaining state between hook calls
            # For now, we can inject a reminder about voice
            
            # Read last known style from a state file (if implemented)
            state_file = f'/tmp/claude_style_{session_id}.txt'
            if os.path.exists(state_file):
                with open(state_file, 'r') as f:
                    last_style = f.read().strip()
                    voice_script = STYLE_TO_VOICE.get(last_style)
                    if voice_script:
                        reminder = f"\n\nREMINDER: You are in {last_style} mode. Use voice: bash {voice_script} \"message\""
                        output = {
                            "hookSpecificOutput": {
                                "hookEventName": "UserPromptSubmit", 
                                "additionalContext": reminder
                            }
                        }
                        print(json.dumps(output))
        
        sys.exit(0)
        
    except Exception as e:
        logger.error(f"Error in hook: {e}")
        sys.exit(0)

if __name__ == "__main__":
    main()