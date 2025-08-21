#!/usr/bin/env python3
"""
Test hook to understand stdin/stdout behavior in Claude Code hooks
"""

import sys
import json
import os

# Log to a file to see what we receive
debug_file = "/tmp/hook_debug.log"

def main():
    with open(debug_file, "a") as f:
        f.write("\n=== HOOK INVOKED ===\n")
        f.write(f"sys.argv: {sys.argv}\n")
        f.write(f"Environment: CLAUDE_HOOK_NAME={os.environ.get('CLAUDE_HOOK_NAME', 'not set')}\n")
        
        # Try to read from stdin
        try:
            # Check if stdin has data
            if not sys.stdin.isatty():
                input_data = json.load(sys.stdin)
                f.write(f"Received JSON from stdin: {json.dumps(input_data, indent=2)}\n")
                
                # Process the data
                tool_name = input_data.get('tool_name') or input_data.get('tool')
                parameters = input_data.get('tool_input') or input_data.get('parameters', {})
                
                f.write(f"Tool: {tool_name}\n")
                f.write(f"Parameters: {json.dumps(parameters, indent=2)}\n")
                
                # Modify parameters if it's a Bash command
                if tool_name == "Bash":
                    command = parameters.get('command', '')
                    if 'npm run dev' in command or 'npm start' in command:
                        f.write("INTERCEPTING DEV SERVER COMMAND!\n")
                        
                        # Return modified parameters
                        response = {
                            'modified': True,
                            'tool_input': {
                                **parameters,
                                'command': 'echo "🚫 Dev server command blocked. Use Plopdock MCP tools instead!"'
                            },
                            'message': 'Development server commands should use Plopdock MCP'
                        }
                        
                        f.write(f"Returning: {json.dumps(response, indent=2)}\n")
                        print(json.dumps(response))
                        sys.exit(0)
                
                # No modification needed
                f.write("No modification needed\n")
                sys.exit(0)
            else:
                f.write("No stdin data (terminal attached)\n")
                
        except Exception as e:
            f.write(f"Error reading stdin: {e}\n")
    
    # Allow execution by default
    sys.exit(0)

if __name__ == "__main__":
    main()