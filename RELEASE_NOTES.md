# AP Mapping v1.2.3

Released: 2025-07-15

## 🚨 EMERGENCY PATCH RELEASE

This is an emergency patch release to fix critical issues in v1.2.2 that prevented the enhanced logging features from working.

## 🐛 Critical Fixes

- **Fixed distribution packaging**: v1.2.2 was missing the entire `.apm/agents` directory, making it non-functional
- **Fixed runtime bug**: Corrected undefined `context` variable in `subagent_stop.py` hook
- **Enhanced build validation**: Added comprehensive validation to prevent packaging failures
- **Build script hardening**: Added error handling and verification to ensure complete distributions

## 🔧 Build System Improvements

- **Package validation**: Build now validates that all critical components are included
- **Error handling**: Build fails immediately if required directories are missing
- **Better reporting**: Build output now shows agent file counts for verification
- **Quality assurance**: Added checks for core persona files and enhanced hooks

## 📦 What This Release Delivers

The enhanced logging features that were promised in v1.2.2 but didn't work:

- **Intelligent Hook Logging**: Hooks now parse transcript files to extract real session data
- **Session Analytics**: Extract tools used, user requests, and task descriptions from sessions  
- **Duration Tracking**: Calculate actual session duration from transcript timestamps
- **Meaningful Logs**: No more "unknown, 0 seconds, None" - see actual session information

## 🔄 Migration from v1.2.2

If you installed v1.2.2, please update immediately:

```bash
.apm/agents/scripts/ap-manager.sh update
```

## 📋 Technical Details

- Fixed `build-distribution.sh` validation logic
- Corrected `installer/templates/hooks/subagent_stop.py` line 198
- Added pre-release validation to prevent future packaging failures
- Enhanced error reporting and build verification

---

# AP Mapping v1.2.2

Released: 2025-07-15

## ⚠️ KNOWN ISSUES - DO NOT USE

**This release contains critical packaging errors that make it non-functional. Please use v1.2.3 instead.**

## 🎉 Highlights

Enhanced hook logging system that provides meaningful session data instead of useless "unknown, 0 seconds, None" logs.

## ✨ New Features

- **Intelligent Hook Logging**: Hooks now parse transcript files to extract real session data
- **Session Analytics**: Extract tools used, user requests, and task descriptions from sessions
- **Duration Tracking**: Calculate actual session duration from transcript timestamps

## 🐛 Bug Fixes

- Fixed hook logging showing useless "unknown" reasons and 0-second durations
- Enhanced subagent logging to show actual task descriptions instead of "No description"
- Fixed hooks not extracting meaningful data from Claude sessions

## 🔧 Improvements

- **Enhanced stop.py hook**: Now parses transcripts to show real session data, tools used, and user requests
- **Enhanced subagent_stop.py hook**: Extracts actual task descriptions and shows meaningful completion info
- **Better debugging**: Logs now provide actionable information for session analysis

## 📚 Documentation

<!-- Documentation updates -->
- Updated guide for...

## 💔 Breaking Changes

_None in this release_

<!-- OR list breaking changes with migration paths -->

## 📦 Installation

### New Installation

```bash
curl -L https://github.com/omayhemo/APM/releases/download/v1.2.2/apm-v1.2.2.tar.gz | tar -xz
./installer/install.sh
```

### Updating from Previous Version

```bash
agents/scripts/ap-manager.sh update
```

## 🔄 Migration Guide

<!-- If applicable, provide migration steps -->

## 📋 Full Changelog

See [CHANGELOG.md](https://github.com/omayhemo/APM/blob/main/CHANGELOG.md) for complete history.
