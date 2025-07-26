#!/usr/bin/env python3
"""
Test hook to debug logging issues
"""

import sys
import os
import json
from datetime import datetime

# Try multiple logging approaches
debug_info = []

# 1. Check if script is running at all
debug_info.append(f"Script started at {datetime.now().isoformat()}")
debug_info.append(f"Python version: {sys.version}")
debug_info.append(f"Script path: {os.path.abspath(__file__)}")
debug_info.append(f"Working dir: {os.getcwd()}")

# 2. Check environment
debug_info.append(f"HOME: {os.environ.get('HOME', 'NOT SET')}")
debug_info.append(f"USER: {os.environ.get('USER', 'NOT SET')}")
debug_info.append(f"PATH: {os.environ.get('PATH', 'NOT SET')}")

# 3. Try to write to different locations
test_locations = [
    os.path.expanduser("~/.claude/logs/test_hook_debug.log"),
    "/tmp/test_hook_debug.log",
    os.path.join(os.path.dirname(__file__), "test_hook_debug.log")
]

for location in test_locations:
    try:
        dir_path = os.path.dirname(location)
        if dir_path and not os.path.exists(dir_path):
            os.makedirs(dir_path, exist_ok=True)
        
        with open(location, 'a') as f:
            f.write(f"\n{'='*50}\n")
            f.write(f"Test hook run at {datetime.now().isoformat()}\n")
            f.write(f"Python: {sys.version}\n")
            f.write(f"Script: {__file__}\n")
            f.write(f"CWD: {os.getcwd()}\n")
            f.write(f"Successfully wrote to: {location}\n")
            for info in debug_info:
                f.write(f"{info}\n")
        debug_info.append(f"SUCCESS: Wrote to {location}")
    except Exception as e:
        debug_info.append(f"FAILED: {location} - {str(e)}")

# 4. Try importing hook_utils
try:
    sys.path.insert(0, os.path.dirname(__file__))
    import hook_utils
    debug_info.append("SUCCESS: Imported hook_utils")
    
    # Try to get APM root
    apm_root = hook_utils.get_apm_root()
    debug_info.append(f"APM root: {apm_root}")
    
    # Try to setup logging
    logger = hook_utils.setup_logging('test_hook')
    logger.info("Test log message from hook_utils logger")
    debug_info.append("SUCCESS: Used hook_utils logger")
except Exception as e:
    debug_info.append(f"FAILED: hook_utils - {str(e)}")

# 5. Output debug info to stderr (should be visible in Claude logs)
print(json.dumps({
    "test_hook_debug": debug_info,
    "timestamp": datetime.now().isoformat()
}, indent=2), file=sys.stderr)

# Normal exit
sys.exit(0)