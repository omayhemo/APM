# AP Mapping v1.2.2

Released: 2025-07-15

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
