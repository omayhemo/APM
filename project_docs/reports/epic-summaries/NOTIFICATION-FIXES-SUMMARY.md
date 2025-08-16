# APM v3.1.0 Notification System Fixes

## Overview
This document summarizes the fixes applied to resolve notification and TTS issues when using the installer with the `-d` (defaults) flag.

## Issues Fixed

### 1. ✅ Hook Notifications Not Being Enabled with Defaults
**Problem**: When using `install.sh -d`, the installer claimed to enable default hooks (stop, subagent_stop, user_prompt_submit, pre_compact) but they remained disabled.

**Root Cause**: The `configure_hook` function was still being called even with defaults, and it was setting all hooks to false by default.

**Solution Applied**:
```bash
# Added explicit default hook settings when USE_DEFAULTS=true
if [ "$USE_DEFAULTS" = true ]; then
    HOOK_NOTIFICATION_ENABLED=false
    HOOK_PRE_TOOL_ENABLED=false
    HOOK_POST_TOOL_ENABLED=false
    HOOK_STOP_ENABLED=true
    HOOK_SUBAGENT_STOP_ENABLED=true
    HOOK_USER_PROMPT_SUBMIT_ENABLED=true
    HOOK_PRE_COMPACT_ENABLED=true
fi

# Skip interactive configuration when using defaults
if [ "$USE_DEFAULTS" != true ]; then
    # Interactive hook configuration
else
    echo "Applied default notification settings:"
    echo "- Stop: Enabled"
    echo "- Subagent Stop: Enabled"
    echo "- User Prompt Submit: Enabled"
    echo "- Pre-Compact: Enabled"
fi
```

### 2. ✅ TTS_ENABLED Not Set Correctly
**Problem**: Despite selecting Piper as TTS provider, TTS_ENABLED was not being set to "true" in settings.json.

**Root Cause**: The installer only set TTS_ENABLED for Piper during the Piper installation success path, missing other cases.

**Solution Applied**:
```bash
# Fixed TTS_ENABLED logic based on provider
TTS_ENABLED_VAL=$([[ "$TTS_PROVIDER" != "none" ]] && echo "true" || echo "false")
jq ".env.TTS_PROVIDER = \"$TTS_PROVIDER\" | .env.TTS_ENABLED = \"$TTS_ENABLED_VAL\"" ...
```

### 3. ✅ Hook Variables Not Initialized for All Paths
**Problem**: When notifications were disabled, hook variables were undefined, causing settings.json to have missing values.

**Root Cause**: Hook variables were only set inside the notification configuration block.

**Solution Applied**:
```bash
# Initialize all hook variables even when notifications disabled
else
    HOOK_NOTIFICATION_ENABLED=false
    HOOK_PRE_TOOL_ENABLED=false
    HOOK_POST_TOOL_ENABLED=false
    HOOK_STOP_ENABLED=false
    HOOK_SUBAGENT_STOP_ENABLED=false
    HOOK_USER_PROMPT_SUBMIT_ENABLED=false
    HOOK_PRE_COMPACT_ENABLED=false
```

## Expected Behavior After Fixes

### With `-d` Flag (Defaults)
```json
{
  "env": {
    "TTS_PROVIDER": "piper",
    "TTS_ENABLED": "true",
    "HOOK_NOTIFICATION_ENABLED": "false",
    "HOOK_PRE_TOOL_ENABLED": "false",
    "HOOK_POST_TOOL_ENABLED": "false",
    "HOOK_STOP_ENABLED": "true",
    "HOOK_SUBAGENT_STOP_ENABLED": "true",
    "HOOK_USER_PROMPT_SUBMIT_ENABLED": "true",
    "HOOK_PRE_COMPACT_ENABLED": "true"
  }
}
```

### Installation Flow with Defaults
1. TTS provider automatically set to "piper" (Linux) or "system" (macOS)
2. Piper installation proceeds automatically
3. Default hooks enabled: stop, subagent_stop, user_prompt_submit, pre_compact
4. No interactive prompts for notification configuration
5. All settings properly saved to settings.json

## Files Modified

### `/templates/install.sh`
1. **Lines 1305-1315**: Added default hook initialization
2. **Lines 1345-1361**: Added conditional hook configuration
3. **Lines 1177-1178**: Fixed TTS_ENABLED calculation
4. **Lines 1389-1396**: Added hook initialization for disabled notifications
5. **Lines 1406-1417**: Added hook variables to settings.json save
6. **Lines 1706-1707**: Added TTS_ENABLED to NEEDS_FIX section

## Testing

### Test Script Created
`test-installer-notifications.sh` - Validates all notification fixes by:
- Running installer with `-d` flag
- Checking resulting settings.json values
- Verifying Piper installation
- Confirming notification sounds copied
- Validating all hook settings

### Expected Test Results
- TTS_PROVIDER: piper ✓
- TTS_ENABLED: true ✓
- Default hooks enabled ✓
- Other hooks disabled ✓
- Audio players detected ✓
- Piper installed ✓
- Notification sounds copied ✓

## User Impact

### Before Fixes
- Users running `install.sh -d` would get no working notifications
- TTS would appear disabled despite Piper installation
- Hook notifications wouldn't trigger
- Manual configuration required post-installation

### After Fixes
- Users running `install.sh -d` get fully functional defaults
- Voice notifications work immediately (Piper)
- Sound notifications trigger for important events
- Zero post-installation configuration needed

## Deployment

These fixes are included in APM v3.1.0 distribution:
- Updated installer in `templates/install.sh`
- Ready for packaging with `build-distribution.sh`
- Test with: `tar -xzf apm-v3.1.0.tar.gz && installer/install.sh -d`

## Success Criteria

- ✅ Default installation enables expected hooks
- ✅ TTS_ENABLED properly reflects TTS_PROVIDER state
- ✅ All hook variables initialized in all code paths
- ✅ Settings.json contains complete configuration
- ✅ No manual intervention required for default setup