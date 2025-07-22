#!/usr/bin/env python3
"""
PreCompact Hook - Executes before Claude Code runs a compact operation

This hook fires before Claude Code is about to compact the context window.
Can be used to save state, export session data, or prepare for compaction.

Input format (via stdin):
{
    "session_id": "session-uuid",
    "transcript_path": "/path/to/transcript.jsonl",
    "trigger": "manual|auto",
    "custom_instructions": "optional custom instructions for compaction"
}

Return:
- Exit code 0: Allow compaction to proceed
- Exit code 1: Block compaction
- JSON output (stdout): Optional modifications or messages
"""

import sys
import json
import os
from datetime import datetime
import shutil

# Add current directory to Python path for hook_utils import
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

try:
    from hook_utils import setup_logging, get_notification_manager, get_apm_root
    logger = setup_logging('pre_compact')
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
            logging.FileHandler(os.path.join(log_dir, 'pre_compact.log')),
            logging.FileHandler('/tmp/pre_compact_fallback.log')
        ]
    )
    logger = logging.getLogger('pre_compact')
    logger.error(f"Failed to import hook_utils: {e}")
    
    # Define fallback functions
    def get_notification_manager():
        return None
    
    def get_apm_root():
        return None


def save_pre_compact_state(session_id, transcript_path):
    """Save session state before compaction"""
    try:
        # Find project root for backups
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
        
        # Create backup directory in project
        if project_root:
            backup_dir = os.path.join(project_root, '.claude', 'hooks', 'compact_backups', session_id)
        else:
            backup_dir = os.path.join(os.getcwd(), '.claude', 'hooks', 'compact_backups', session_id)
        
        os.makedirs(backup_dir, exist_ok=True)
        
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        
        # Backup transcript if it exists
        if transcript_path and os.path.exists(transcript_path):
            backup_path = os.path.join(backup_dir, f'transcript_{timestamp}.jsonl')
            shutil.copy2(transcript_path, backup_path)
            logger.info(f"Backed up transcript to: {backup_path}")
            
            # Extract summary statistics
            line_count = 0
            tool_uses = {}
            with open(transcript_path, 'r') as f:
                for line in f:
                    line_count += 1
                    try:
                        entry = json.loads(line.strip())
                        if entry.get('role') == 'assistant':
                            content = entry.get('content', '')
                            if isinstance(content, list):
                                for item in content:
                                    if isinstance(item, dict) and item.get('type') == 'tool_use':
                                        tool_name = item.get('name', 'unknown')
                                        tool_uses[tool_name] = tool_uses.get(tool_name, 0) + 1
                    except:
                        continue
            
            # Save summary
            summary = {
                'session_id': session_id,
                'timestamp': timestamp,
                'line_count': line_count,
                'tool_uses': tool_uses,
                'backup_path': backup_path
            }
            
            summary_path = os.path.join(backup_dir, f'summary_{timestamp}.json')
            with open(summary_path, 'w') as f:
                json.dump(summary, f, indent=2)
            
            return summary
            
    except Exception as e:
        logger.error(f"Failed to save pre-compact state: {e}")
        return None


def main():
    """Main hook entry point"""
    try:
        # Read JSON input from stdin
        input_data = json.load(sys.stdin)
        
        # Log full payload
        logger.info(f"PreCompact hook triggered with payload: {json.dumps(input_data, indent=2)}")
        
        # Extract input fields
        session_id = input_data.get('session_id', 'unknown')
        transcript_path = input_data.get('transcript_path', '')
        trigger = input_data.get('trigger', 'unknown')
        custom_instructions = input_data.get('custom_instructions', '')
        
        # Log compaction trigger
        timestamp = datetime.now().isoformat()
        logger.info(f"[{timestamp}] Session {session_id}: Pre-compact triggered")
        logger.info(f"Trigger: {trigger}")
        logger.info(f"Custom instructions: {custom_instructions[:100]}{'...' if len(custom_instructions) > 100 else ''}")
        
        # Save session state
        summary = save_pre_compact_state(session_id, transcript_path)
        if summary:
            logger.info(f"Session state saved: {summary['line_count']} lines, {len(summary['tool_uses'])} unique tools")
        
        # Check if this is APM session
        apm_root = get_apm_root()
        if apm_root:
            apm_session_notes = os.path.join(apm_root, '.apm', 'session_notes')
            
            if os.path.exists(apm_session_notes):
                # Archive current session notes before compaction
                archive_dir = os.path.join(apm_session_notes, 'pre_compact_archive', timestamp.replace(':', '-'))
                os.makedirs(archive_dir, exist_ok=True)
                
                # Copy active session notes
                active_notes = [f for f in os.listdir(apm_session_notes) if f.endswith('.md') and not f.startswith('archive')]
                for note in active_notes:
                    src = os.path.join(apm_session_notes, note)
                    dst = os.path.join(archive_dir, note)
                    shutil.copy2(src, dst)
                    logger.info(f"Archived session note: {note}")
                
                # Call notification manager
                notification_manager = get_notification_manager()
                if notification_manager:
                    import subprocess
                    result = subprocess.run([
                        notification_manager, 'notify', 'pre_compact',
                        'orchestrator',
                        f"Preparing for context compaction: {trigger} trigger"
                    ], capture_output=True, text=True)
                    
                    if result.returncode != 0:
                        logger.warning(f"Notification manager failed: {result.stderr}")
        
        # Example: Block auto-compaction during critical operations (disabled by default)
        # if trigger == 'auto':
        #     # Check if critical operation in progress
        #     if os.path.exists('/tmp/critical_operation.lock'):
        #         logger.warning("Blocking auto-compaction during critical operation")
        #         print(json.dumps({"blocked": True, "reason": "Critical operation in progress"}))
        #         sys.exit(1)
        
        # Return success (allow compaction)
        sys.exit(0)
        
    except Exception as e:
        logger.error(f"Error in PreCompact hook: {e}", exc_info=True)
        # On error, allow compaction to prevent blocking Claude
        sys.exit(0)


if __name__ == "__main__":
    main()