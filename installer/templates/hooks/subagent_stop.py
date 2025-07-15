#!/usr/bin/env python3
"""
SubagentStop Hook - Executes when a subagent stops

This hook is triggered when a subagent (launched via Task tool) completes.
Useful for processing subagent results, cleanup, or triggering follow-up actions.

Input format (via stdin):
{
    "agent_id": "unique_agent_id",
    "task_description": "what the agent was doing",
    "result": {...},
    "success": true/false,
    "duration": 12345,
    "context": {...}
}

Return:
- Exit code 0: Success
- Exit code 1: Error (logged but doesn't affect subagent result)
- JSON output (stdout): Optional processing results
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
    handlers=[logging.FileHandler('/tmp/subagent_stop.log')]
)
logger = logging.getLogger(__name__)


def parse_transcript(transcript_path):
    """Parse transcript to extract subagent task info"""
    try:
        if not os.path.exists(transcript_path):
            return None
            
        tools_used = set()
        user_requests = []
        task_descriptions = []
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
                        clean_content = re.sub(r'\s+', ' ', content.strip())[:100]
                        user_requests.append(clean_content)
                
                # Extract task descriptions from assistant messages
                if entry.get('role') == 'assistant':
                    content = entry.get('content', '')
                    if isinstance(content, list):
                        for item in content:
                            if isinstance(item, dict) and item.get('type') == 'tool_use':
                                tool_name = item.get('name')
                                if tool_name:
                                    tools_used.add(tool_name)
                                    # Extract task description from Task tool
                                    if tool_name == 'Task':
                                        params = item.get('parameters', {})
                                        description = params.get('description', '')
                                        if description:
                                            task_descriptions.append(description)
        
        # Calculate duration
        duration = 0
        if start_time and end_time:
            try:
                start_dt = datetime.fromisoformat(start_time.replace('Z', '+00:00'))
                end_dt = datetime.fromisoformat(end_time.replace('Z', '+00:00'))
                duration = int((end_dt - start_dt).total_seconds())
            except Exception:
                duration = 0
        
        return {
            'tools_used': list(tools_used),
            'user_requests': user_requests,
            'task_descriptions': task_descriptions,
            'duration': duration,
            'start_time': start_time,
            'end_time': end_time
        }
    except Exception as e:
        logger.error(f"Failed to parse transcript: {e}")
        return None


def main():
    """Main hook entry point"""
    try:
        # Read JSON input from stdin
        input_data = json.load(sys.stdin)
        logger.info(f"SubagentStop hook triggered: {input_data}")
        
        # Extract transcript path and parse it
        transcript_path = input_data.get('transcript_path')
        session_data = parse_transcript(transcript_path) if transcript_path else None
        
        if session_data:
            # Use parsed data
            agent_id = input_data.get('agent_id', 'unknown')
            success = input_data.get('success', True)
            duration = session_data['duration']
            tools_used = session_data['tools_used']
            user_requests = session_data['user_requests']
            task_descriptions = session_data['task_descriptions']
            
            # Determine primary task description
            if task_descriptions:
                task_description = task_descriptions[-1]  # Most recent task
            elif user_requests:
                task_description = user_requests[-1]  # Fallback to user request
            else:
                task_description = 'No description available'
            
            # Log meaningful subagent completion
            timestamp = datetime.now().isoformat()
            status = "succeeded" if success else "failed"
            logger.info(f"[{timestamp}] Subagent {agent_id} {status}")
            logger.info(f"Task: {task_description}")
            logger.info(f"Duration: {duration} seconds")
            logger.info(f"Tools used: {', '.join(tools_used) if tools_used else 'None'}")
            
            # Log user context
            if user_requests:
                logger.info(f"User requests: {len(user_requests)} total")
                for i, request in enumerate(user_requests[-2:], 1):  # Last 2 requests
                    logger.info(f"  Request {i}: {request}")
        else:
            # Fallback to original behavior
            agent_id = input_data.get('agent_id', 'unknown')
            task_description = input_data.get('task_description', 'No description')
            success = input_data.get('success', True)
            duration = input_data.get('duration', 0)
            
            timestamp = datetime.now().isoformat()
            status = "succeeded" if success else "failed"
            logger.info(f"[{timestamp}] Subagent {agent_id} {status}")
            logger.info(f"Task: {task_description}")
            logger.info(f"Duration: {duration} seconds")
        
        # Example: You could aggregate results from multiple subagents
        # results_file = f"/tmp/subagent_results.json"
        # existing_results = []
        # if os.path.exists(results_file):
        #     with open(results_file, 'r') as f:
        #         existing_results = json.load(f)
        # existing_results.append({
        #     'timestamp': timestamp,
        #     'agent_id': agent_id,
        #     'task': task_description,
        #     'success': success,
        #     'duration': duration
        # })
        # with open(results_file, 'w') as f:
        #     json.dump(existing_results, f, indent=2)
        
        # Call notification manager for audio/TTS notifications
        import subprocess
        import os
        
        # Get notification manager path
        project_root = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))  # Up from .claude/hooks/
        notification_manager = os.path.join(project_root, '.apm', 'agents', 'scripts', 'notification-manager.sh')
        
        if os.path.exists(notification_manager):
            # Call notification manager
            status_text = "completed successfully" if success else "failed"
            subprocess.run([
                notification_manager, 'notify', 'subagent_stop',
                context.get('persona', 'orchestrator'),
                f"Subagent {status_text}: {task_description}"
            ], capture_output=True)
        
        # Return success
        sys.exit(0)
        
    except Exception as e:
        logger.error(f"Error in SubagentStop hook: {e}")
        # On error, exit gracefully
        sys.exit(1)


if __name__ == "__main__":
    main()