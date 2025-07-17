# AP Mapping v1.3.0

Released: 2025-07-17

## 🎉 Highlights

Fixed critical installer issues that were creating duplicate session paths and potentially overwriting user commands during installation.

## ✨ New Features

_None in this release_

## 🐛 Bug Fixes

- **Installer Session Paths**: Fixed installer creating duplicate session_notes folders in both `project_docs/` and `.apm/`
  - Session notes and rules now correctly use only `.apm/session_notes` and `.apm/rules`
  - Removed conflicting path logic that created folders in wrong locations
  - Updated .gitignore generation to only reference correct `.apm/` paths

- **Command Preservation**: Fixed installer command replacement logic
  - Installer now correctly replaces APM commands while preserving user commands
  - Prevents accidental deletion of user's custom Claude commands
  - Only updates files that are part of the APM installer payload

## 🔧 Improvements

- **Cleaner Installation**: Simplified path logic eliminates confusion between `project_docs/` and `.apm/` structures
- **Better User Protection**: Enhanced installer safety to protect existing user files and commands
- **Improved .gitignore**: Updated gitignore template to reflect correct APM infrastructure structure

## 📚 Documentation

- Updated gitignore template to remove legacy session_notes references
- Clarified installer behavior for session notes and rules path management

## 💔 Breaking Changes

_None in this release_

## 📦 Installation

### New Installation

```bash
curl -L https://github.com/omayhemo/APM/releases/download/v1.3.0/apm-v1.3.0.tar.gz | tar -xz
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
