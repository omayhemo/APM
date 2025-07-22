# Release Notes

## AP Mapping v2.1.3

Released: 2025-01-22

### 🔧 Important Fixes for AP Commands and Hooks

This release fixes critical issues with AP command activation and improves hook logging.

#### What's Fixed

**AP Command Activation**
- Fixed "File does not exist" errors when running `/ap` or `/ap_orchestrator`
- Commands now properly list directories instead of trying to read non-existent files
- Added clear warnings about files that don't exist (current_session.md, rules.md)
- Simplified `/ap` to be an alias for `/ap_orchestrator`

**Hook Logging**
- Changed hook logs to write to project-local `.claude/hooks/logs/` directory
- No more logging to global `~/.claude/logs/` directory
- Keeps all project data within the project structure
- Backup transcripts now go to `.claude/hooks/compact_backups/`

**AP Orchestrator Improvements**
- Clear activation sequence with proper directory checks
- Voice announcements throughout initialization
- Better parallel task loading for APM components

#### Installation

**macOS:**
```bash
curl -L https://github.com/omayhemo/APM/releases/download/v2.1.3/apm-v2.1.3.tar.gz | tar -xz && ./installer/install.sh
```

**Linux/WSL:**
```bash
wget https://github.com/omayhemo/APM/releases/download/v2.1.3/apm-v2.1.3.tar.gz && tar -xzf apm-v2.1.3.tar.gz && cd apm-v2.1.3 && ./installer/install.sh
```

#### Upgrade Note

This release fixes the AP command activation errors and improves hook logging. All users should upgrade to ensure proper AP command functionality.

---

## AP Mapping v2.1.1

Released: 2025-01-22

### 🔧 Critical Hook Fixes

This patch release fixes critical issues with the new hooks introduced in v2.1.0.

#### What's Fixed

**Hook Path Resolution**
- Fixed hardcoded paths that prevented hooks from working in target installations
- Added dynamic APM root discovery through new `hook_utils.py` module
- Hooks now properly locate APM installation regardless of installation path

**Audio Notifications**
- Fixed notification manager to recognize `user_prompt_submit` and `pre_compact` hooks
- Corrected environment variable lookup for proper hook enablement detection
- Audio notifications now play correctly when hooks are enabled

**Configuration**
- Added missing UserPromptSubmit and PreCompact configurations to settings template
- New installations now have complete hook support out of the box

#### Installation

**macOS:**
```bash
curl -L https://github.com/omayhemo/APM/releases/download/v2.1.1/apm-v2.1.1.tar.gz | tar -xz && ./installer/install.sh
```

**Linux/WSL:**
```bash
wget https://github.com/omayhemo/APM/releases/download/v2.1.1/apm-v2.1.1.tar.gz && tar -xzf apm-v2.1.1.tar.gz && cd apm-v2.1.1 && ./installer/install.sh
```

#### Upgrade Note

If you installed v2.1.0, please upgrade to v2.1.1 to ensure hooks work correctly. The installer will preserve your existing configuration while fixing the hook issues.

---

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
