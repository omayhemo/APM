# Transition Notes: UserPromptSubmit Hook Implementation

## Overview
This document provides critical context for implementing a configurable UserPromptSubmit hook that appends text to all user prompts in the APM (Agentic Persona Mapping) framework.

## Current Hook Architecture

### Hook Location
- **Primary Hook**: `/installer/templates/hooks/user_prompt_submit.py`
- **Hook Utilities**: `/installer/templates/hooks/hook_utils.py`
- **Configuration**: `/installer/templates/claude/settings.json.template`

### Hook Execution Flow
1. Claude CLI calls the hook when a user submits a prompt
2. Hook receives JSON input via stdin containing:
   - `session_id`: Current session UUID
   - `transcript_path`: Path to transcript file
   - `prompt`: User's submitted prompt text
3. Hook can modify the prompt and return modified JSON
4. Exit code 0 allows processing to continue, exit code 1 blocks

### Current Hook Implementation
The existing `user_prompt_submit.py` hook:
- Logs all prompts to `.claude/hooks/logs/user_prompt_submit.log`
- Detects AP persona activation commands (e.g., `/ap`, `/dev`, `/qa`)
- Triggers notifications for persona activations
- Has commented-out example code for blocking certain prompts
- Does NOT currently modify prompts

## Configuration System

### Settings.json Structure
The APM framework uses a templated settings.json that gets populated during installation:
- Located at `{{PROJECT_ROOT}}/.claude/settings.json` after installation
- Contains environment variables and hook configurations
- Hook enabled/disabled via flags like `HOOK_USER_PROMPT_SUBMIT_ENABLED`

### Environment Variable Access
The hook can access environment variables in two ways:
1. Through `os.environ` - populated from settings.json env section
2. Through the APM_ROOT detection in `hook_utils.py`

## Implementation Requirements

### 1. Configurable Text Storage
The appended text needs to be stored in a configurable location. Options:

**Option A: Environment Variable in settings.json**
```json
{
  "env": {
    "PROMPT_APPEND_TEXT": "Your configurable text here",
    ...
  }
}
```
- Pros: Easy to configure during installation, integrated with existing system
- Cons: Requires hook to be enabled in settings.json

**Option B: Separate Configuration File**
```
{{PROJECT_ROOT}}/.claude/hooks/config/prompt_append.txt
```
- Pros: Can be modified without editing JSON, simple text file
- Cons: Additional file to manage

**Option C: Hook-specific JSON Config**
```
{{PROJECT_ROOT}}/.claude/hooks/config/user_prompt_submit.json
```
- Pros: Structured configuration, can add more options later
- Cons: More complex parsing required

### 2. Prompt Modification Logic
The hook needs to:
1. Read the original prompt from input JSON
2. Load the configured append text
3. Combine them with proper formatting
4. Return modified JSON to stdout

### 3. Format Requirements
- Format: `[USER PROMPT] [APPENDED TEXT]`
- Space separator between original and appended text
- Handle edge cases:
  - Empty prompts
  - Prompts already ending with space
  - Multi-line prompts

## Critical Implementation Considerations

### 1. Hook Return Format
The hook must return properly formatted JSON to modify the prompt:
```python
output = {
    "prompt": f"{original_prompt} {append_text}"
}
print(json.dumps(output))
```

### 2. Error Handling
- If configuration is missing, should the hook:
  - Fail silently and not append anything?
  - Use a default value?
  - Log a warning?
- Must always exit with code 0 on errors to avoid blocking Claude

### 3. Logging
- Use the existing logging setup from `hook_utils.py`
- Log when text is appended for debugging
- Log configuration loading failures

### 4. Performance
- Configuration should be loaded once, not for every prompt
- Consider caching if reading from file

### 5. Special Command Handling
- Current hook detects AP commands like `/ap`, `/dev`
- Should append text be added to these commands?
- Consider skipping append for slash commands

## Example Implementation Structure

```python
def load_append_config():
    """Load the text to append from configuration"""
    # Option A: From environment
    append_text = os.environ.get('PROMPT_APPEND_TEXT', '')
    
    # Option B: From file
    # config_path = os.path.join(project_root, '.claude', 'hooks', 'config', 'prompt_append.txt')
    # if os.path.exists(config_path):
    #     with open(config_path, 'r') as f:
    #         append_text = f.read().strip()
    
    return append_text

def modify_prompt(original_prompt, append_text):
    """Append configured text to the prompt"""
    if not append_text:
        return original_prompt
    
    # Handle edge cases
    if not original_prompt:
        return append_text
    
    # Ensure single space separator
    if original_prompt.endswith(' '):
        return f"{original_prompt}{append_text}"
    else:
        return f"{original_prompt} {append_text}"
```

## Testing Considerations

### Test Scenarios
1. Normal prompt: "Write a function" → "Write a function [APPENDED TEXT]"
2. Empty prompt: "" → "[APPENDED TEXT]"
3. Prompt with trailing space: "Hello " → "Hello [APPENDED TEXT]"
4. Multi-line prompt: Should append to the end
5. Slash commands: Consider whether to append to `/ap` commands
6. Missing configuration: Should handle gracefully

### Debug Locations
- Hook logs: `{{PROJECT_ROOT}}/.claude/hooks/logs/user_prompt_submit.log`
- Debug file: `/tmp/user_prompt_submit_started.log` (fallback location)

## Installation Integration

The installer script (`install.sh`) will need to:
1. Set the `PROMPT_APPEND_TEXT` environment variable in settings.json
2. Ensure `HOOK_USER_PROMPT_SUBMIT_ENABLED` is set to "true"
3. Copy the modified hook file to the correct location

## Recommended Implementation Path

1. **Use Option A** (environment variable) for configuration:
   - Integrates well with existing APM configuration system
   - Easy to modify during installation
   - No additional files to manage

2. **Modify the existing hook** rather than creating new one:
   - Preserves existing persona detection functionality
   - Maintains compatibility with notification system
   - Single point of modification

3. **Add configuration to settings.json template**:
   - Add `PROMPT_APPEND_TEXT` to the env section
   - Can be populated during installation with user's desired text

4. **Implement with proper error handling**:
   - Always allow prompts to proceed even if append fails
   - Log all operations for debugging
   - Handle edge cases gracefully

## File Locations Summary

- Hook to modify: `/mnt/c/Code/agentic-persona-mapping/installer/templates/hooks/user_prompt_submit.py`
- Settings template: `/mnt/c/Code/agentic-persona-mapping/installer/templates/claude/settings.json.template`
- Installation script: `/mnt/c/Code/agentic-persona-mapping/installer/install.sh`
- Hook utilities: `/mnt/c/Code/agentic-persona-mapping/installer/templates/hooks/hook_utils.py`

## Next Steps

1. Decide on configuration method (recommend Option A)
2. Modify `user_prompt_submit.py` to implement append logic
3. Update `settings.json.template` to include configuration
4. Test with various prompt types
5. Update installer to populate configuration during setup