# Release Notes

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
