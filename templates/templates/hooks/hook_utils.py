#!/usr/bin/env python3
"""
Common utilities for APM hooks
"""

import os
import logging

def get_apm_root():
    """
    Find the APM root directory by looking for .apm marker
    
    Search order:
    1. Check if APM_ROOT environment variable is set
    2. Look for .apm directory in current project
    3. Look for .apm directory in parent directories (up to 5 levels)
    4. Check common installation locations
    
    Returns:
        str: Path to APM root directory or None if not found
    """
    # Check environment variable first
    apm_root = os.environ.get('APM_ROOT')
    if apm_root and os.path.exists(os.path.join(apm_root, '.apm')):
        return apm_root
    
    # Start from hook's location (should be in .claude/hooks/)
    current_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    
    # Look up to 5 levels for .apm directory
    for _ in range(5):
        if os.path.exists(os.path.join(current_dir, '.apm')):
            return current_dir
        parent = os.path.dirname(current_dir)
        if parent == current_dir:  # Reached root
            break
        current_dir = parent
    
    # Check common installation locations
    common_locations = [
        os.path.expanduser('~/.apm'),
        '/opt/apm',
        '/usr/local/apm',
        os.path.join(os.path.expanduser('~'), 'apm')
    ]
    
    for location in common_locations:
        if os.path.exists(os.path.join(location, '.apm')):
            return location
    
    return None


def get_notification_manager():
    """
    Get the path to the notification manager script
    
    Returns:
        str: Path to notification-manager.sh or None if not found
    """
    apm_root = get_apm_root()
    if not apm_root:
        return None
    
    notification_manager = os.path.join(apm_root, '.apm', 'agents', 'scripts', 'notification-manager.sh')
    if os.path.exists(notification_manager):
        return notification_manager
    
    return None


def setup_logging(hook_name):
    """
    Setup logging for a hook with consistent configuration
    
    Args:
        hook_name (str): Name of the hook (e.g., 'user_prompt_submit')
    
    Returns:
        logging.Logger: Configured logger instance
    """
    # Configure logging
    log_dir = os.path.expanduser('~/.claude/logs')
    os.makedirs(log_dir, exist_ok=True)
    
    # Create logger
    logger = logging.getLogger(hook_name)
    logger.setLevel(logging.INFO)
    
    # Clear any existing handlers
    logger.handlers = []
    
    # Add file handler
    file_handler = logging.FileHandler(os.path.join(log_dir, f'{hook_name}.log'))
    file_handler.setLevel(logging.INFO)
    
    # Create formatter
    formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
    file_handler.setFormatter(formatter)
    
    # Add handler to logger
    logger.addHandler(file_handler)
    
    # Also add /tmp handler for backwards compatibility
    try:
        tmp_handler = logging.FileHandler(f'/tmp/{hook_name}.log')
        tmp_handler.setLevel(logging.INFO)
        tmp_handler.setFormatter(formatter)
        logger.addHandler(tmp_handler)
    except:
        pass  # Ignore if /tmp is not writable
    
    return logger