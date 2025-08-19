# User Prompt Append Configuration Guide

## Overview
The APM framework now supports automatically appending custom text to all user prompts submitted to Claude. This feature allows you to add consistent context, reminders, or instructions that Claude will process with every prompt.

## How It Works
- The `user_prompt_submit.py` hook reads the `PROMPT_APPEND_TEXT` environment variable
- If configured, the text is appended to every user prompt with a space separator
- The appended text is invisible to the user but processed by Claude
- Format: `[USER PROMPT] [APPENDED TEXT]`

## Configuration Steps

### 1. Enable the Hook
In your `.claude/settings.json` file, ensure the hook is enabled:
```json
{
  "env": {
    "HOOK_USER_PROMPT_SUBMIT_ENABLED": "true",
    "PROMPT_APPEND_TEXT": "Your custom text here"
  }
}
```

### 2. Set Your Custom Text
Add your desired append text to the `PROMPT_APPEND_TEXT` variable:

#### Example: APM Framework Context
```json
"PROMPT_APPEND_TEXT": "[Remember: Always update backlog.md after story work]"
```

#### Example: Project Standards
```json
"PROMPT_APPEND_TEXT": "[Follow coding standards in .apm/rules/]"
```

#### Example: Multiple Instructions
```json
"PROMPT_APPEND_TEXT": "[APM Active] [Use voice notifications] [Update backlog.md]"
```

### 3. Apply Configuration
After updating `settings.json`, the configuration is immediately active for all new prompts.

## Usage Examples

### Basic Example
**User types:** "Create a new function"
**Claude receives:** "Create a new function [Follow coding standards in .apm/rules/]"

### With AP Commands
**User types:** "/dev"
**Claude receives:** "/dev [APM Active] [Use voice notifications]"

### Empty Prompts
**User types:** (empty prompt)
**Claude receives:** " [Your append text]"

## Important Notes

1. **Spacing**: A single space is automatically added between the user's prompt and your appended text
2. **Whitespace**: Leading and trailing whitespace in `PROMPT_APPEND_TEXT` is trimmed
3. **Special Characters**: All characters are supported, including quotes and newlines
4. **Performance**: The hook adds minimal latency (<1ms) to prompt processing
5. **Logging**: All append operations are logged to `.claude/hooks/logs/user_prompt_submit.log`

## Testing Your Configuration

Run the included test script to verify your configuration:
```bash
python3 .claude/hooks/test_user_prompt_append.py
```

## Troubleshooting

### Text Not Appending
1. Verify `HOOK_USER_PROMPT_SUBMIT_ENABLED` is set to `"true"`
2. Check that `PROMPT_APPEND_TEXT` is not empty
3. Review logs in `.claude/hooks/logs/user_prompt_submit.log`

### Hook Not Running
1. Ensure the hook file exists at `.claude/hooks/user_prompt_submit.py`
2. Verify the file is executable: `chmod +x .claude/hooks/user_prompt_submit.py`
3. Check Claude Code logs for any hook execution errors

## Advanced Usage

### Dynamic Configuration
You can modify `PROMPT_APPEND_TEXT` at any time by editing `settings.json`. Changes take effect immediately for new prompts.

### Conditional Appending
To disable appending temporarily, set `PROMPT_APPEND_TEXT` to an empty string:
```json
"PROMPT_APPEND_TEXT": ""
```

### Project-Specific Context
Different projects can have different append text by using separate `.claude/settings.json` files in each project directory.

## Security Considerations
- The appended text is processed by Claude as part of the prompt
- Avoid including sensitive information in the append text
- The text is logged in the hook logs for debugging purposes

---

For more information about APM hooks, see the main hooks documentation.