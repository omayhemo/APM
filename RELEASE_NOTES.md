# Release Notes

## AP Mapping v2.1.0

Released: 2025-01-22

### 🎯 Enhanced Claude Code Hook Support

This release brings comprehensive Claude Code hook enhancements for improved session management and user feedback.

#### New Features

**🎯 New Claude Code Hooks**
- **UserPromptSubmit Hook**: Captures when users submit prompts with automatic logging and AP command detection
- **PreCompact Hook**: Archives session state before context compaction to preserve work history

**🔊 Enhanced Audio Notifications**
- Expanded from 5 to 7 hooks with new sounds
- `user_prompt_submit.mp3` for prompt submissions
- `compact.mp3` for pre-compaction notifications
- New hooks enabled by default with `--defaults` flag

**🛠️ Technical Improvements**
- Centralized logging to `~/.claude/logs/` with full JSON payloads
- Automatic session note archiving before compaction
- Better error handling to prevent blocking Claude Code
- Complete hook templates in distribution

#### Configuration
- Added `HOOK_USER_PROMPT_SUBMIT_ENABLED` environment variable
- Added `HOOK_PRE_COMPACT_ENABLED` environment variable
- Updated settings.json template with all 7 hook configurations

#### Installation
```bash
# macOS
curl -L https://github.com/omayhemo/APM/releases/download/v2.1.0/apm-v2.1.0.tar.gz | tar -xz && ./installer/install.sh

# Linux/WSL  
wget https://github.com/omayhemo/APM/releases/download/v2.1.0/apm-v2.1.0.tar.gz && tar -xzf apm-v2.1.0.tar.gz && cd apm-v2.1.0 && ./installer/install.sh
```

---

## AP Mapping v2.0.1

Released: 2025-01-21

### 🔧 Patch Release

This patch release fixes the storage location for agent handoff notes to ensure proper separation between session artifacts and project deliverables.

### What's Fixed

- **Handoff Notes Path**: Fixed storage location from `project_docs/planning/` to `.apm/session_notes/handoffs/`
- **Template Updates**: Updated all persona and command templates with explicit handoff note guidance
- **Directory Structure**: Created proper handoffs directory with documentation
- **Migration**: Moved existing handoff notes to correct location

### Impact

- Clear separation between session artifacts and project deliverables
- Consistent handoff note storage across all agents
- Better project organization

### Installation

**Linux/WSL:**
```bash
wget https://github.com/omayhemo/APM/releases/download/v2.0.1/apm-v2.0.1.tar.gz && tar -xzf apm-v2.0.1.tar.gz && cd apm-v2.0.1 && ./installer/install.sh
```

**macOS:**
```bash
curl -L https://github.com/omayhemo/APM/releases/download/v2.0.1/apm-v2.0.1.tar.gz | tar -xz && ./installer/install.sh
```

---

## AP Mapping v2.0.0

Released: 2025-01-20

## 🎉 Highlights

<!-- Brief summary of major changes in this release -->

## ✨ New Features

<!-- List new features with descriptions -->
- **Feature Name**: Description

## 🐛 Bug Fixes

<!-- List bug fixes -->
- Fixed issue where...

## 🔧 Improvements

<!-- List improvements -->
- Enhanced performance of...

## 📚 Documentation

<!-- Documentation updates -->
- Updated guide for...

## 💔 Breaking Changes

_None in this release_

<!-- OR list breaking changes with migration paths -->

## 📦 Installation

### New Installation

```bash
curl -L https://github.com/omayhemo/APM/releases/download/v2.0.0/apm-v2.0.0.tar.gz | tar -xz
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
