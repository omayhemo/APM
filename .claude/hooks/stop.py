#!/usr/bin/env python3
"""
Stop Hook - Executes when Claude Code stops

This hook is triggered when Claude Code is about to stop or exit.
Useful for cleanup tasks, final logging, or saving state.

Input format (via stdin):
{
    "reason": "user_requested/error/completion",
    "session_duration": 12345,
    "tools_used": [...],
    "context": {...}
}

Return:
- Exit code 0: Success
- Exit code 1: Error (logged but doesn't prevent Claude from stopping)
- JSON output (stdout): Optional final messages
"""

import sys
import json
import logging
import os
from datetime import datetime, timezone
import re

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[logging.FileHandler('/tmp/stop.log')]
)
logger = logging.getLogger(__name__)


def parse_transcript(transcript_path):
    """Parse transcript to extract meaningful session data"""
    try:
        if not os.path.exists(transcript_path):
            return None
            
        tools_used = set()
        user_requests = []
        start_time = None
        end_time = None
        
        with open(transcript_path, 'r') as f:
            for line in f:
                if not line.strip():
                    continue
                    
                try:
                    entry = json.loads(line.strip())
                except json.JSONDecodeError:
                    continue
                
                # Track timestamps
                if 'timestamp' in entry:
                    timestamp = entry['timestamp']
                    if start_time is None:
                        start_time = timestamp
                    end_time = timestamp
                
                # Extract user messages
                if entry.get('role') == 'user':
                    content = entry.get('content', '')
                    if content and len(content.strip()) > 0:
                        # Clean up content and take first 100 chars
                        clean_content = re.sub(r'\s+', ' ', content.strip())[:100]
                        user_requests.append(clean_content)
                
                # Extract tool usage from assistant messages
                if entry.get('role') == 'assistant':
                    content = entry.get('content', '')
                    if isinstance(content, list):
                        for item in content:
                            if isinstance(item, dict) and item.get('type') == 'tool_use':
                                tool_name = item.get('name')
                                if tool_name:
                                    tools_used.add(tool_name)
        
        # Calculate duration
        duration = 0
        if start_time and end_time:
            try:
                # Parse ISO timestamps
                start_dt = datetime.fromisoformat(start_time.replace('Z', '+00:00'))
                end_dt = datetime.fromisoformat(end_time.replace('Z', '+00:00'))
                duration = int((end_dt - start_dt).total_seconds())
            except Exception:
                duration = 0
        
        # Determine reason based on content
        reason = 'completion'
        if user_requests:
            last_request = user_requests[-1].lower()
            if any(word in last_request for word in ['exit', 'quit', 'stop', 'bye']):
                reason = 'user_requested'
            elif any(word in last_request for word in ['error', 'problem', 'issue']):
                reason = 'error'
            
        return {
            'tools_used': list(tools_used),
            'user_requests': user_requests,
            'duration': duration,
            'start_time': start_time,
            'end_time': end_time,
            'reason': reason
        }
    except Exception as e:
        logger.error(f"Failed to parse transcript: {e}")
        return None


def main():
    """Main hook entry point"""
    try:
        # Read JSON input from stdin
        input_data = json.load(sys.stdin)
        logger.info(f"Stop hook triggered: {input_data}")
        
        # Extract transcript path and parse it
        transcript_path = input_data.get('transcript_path')
        session_data = parse_transcript(transcript_path) if transcript_path else None
        
        if session_data:
            # Use parsed data
            reason = session_data['reason']
            session_duration = session_data['duration']
            tools_used = session_data['tools_used']
            user_requests = session_data['user_requests']
            
            # Log meaningful session summary
            timestamp = datetime.now().isoformat()
            logger.info(f"Session ended at {timestamp}")
            logger.info(f"Reason: {reason}")
            logger.info(f"Duration: {session_duration} seconds")
            logger.info(f"Tools used: {', '.join(tools_used) if tools_used else 'None'}")
            
            # Log user requests
            if user_requests:
                logger.info(f"User requests: {len(user_requests)} total")
                for i, request in enumerate(user_requests[-3:], 1):  # Last 3 requests
                    logger.info(f"  Request {i}: {request}")
            else:
                logger.info("User requests: None")
        else:
            # Fallback to original behavior
            reason = input_data.get('reason', 'unknown')
            session_duration = input_data.get('session_duration', 0)
            tools_used = input_data.get('tools_used', [])
            
            timestamp = datetime.now().isoformat()
            logger.info(f"Session ended at {timestamp}")
            logger.info(f"Reason: {reason}")
            logger.info(f"Duration: {session_duration} seconds")
            logger.info(f"Tools used: {', '.join(tools_used) if tools_used else 'None'}")
        
        # Example: You could save session state
        # session_file = f"/tmp/claude_session_{timestamp}.json"
        # with open(session_file, 'w') as f:
        #     json.dump(input_data, f, indent=2)
        
        # Call notification manager for audio/TTS notifications
        import subprocess
        
        # Get notification manager path
        project_root = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))  # Up from .claude/hooks/
        notification_manager = os.path.join(project_root, '.apm', 'agents', 'scripts', 'notification-manager.sh')
        
        if os.path.exists(notification_manager):
            # Call notification manager
            subprocess.run([
                notification_manager, 'notify', 'stop',
                input_data.get('context', {}).get('persona', 'orchestrator'),
                f"Session ended: {reason}"
            ], capture_output=True)
        
        # Return success
        sys.exit(0)
        
    except Exception as e:
        logger.error(f"Error in Stop hook: {e}")
        # On error, exit gracefully
        sys.exit(1)


if __name__ == "__main__":
    main()