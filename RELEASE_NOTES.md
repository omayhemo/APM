# AP Mapping v1.2.7

Released: 2025-07-15

## 🎉 Highlights

Fixed critical backup creation failure that was preventing successful updates from installed locations.

## ✨ New Features

_None in this release_

## 🐛 Bug Fixes

- **ap-manager.sh Update Process**: Fixed backup creation failure during update process
  - Added robust error handling for tar backup creation
  - Implemented fallback backup method using direct copy
  - Added debug output for troubleshooting directory paths
  - Ensured AP_ROOT directory exists before backup attempts
  - Enhanced cleanup to handle both tar.gz and directory backups

## 🔧 Improvements

- Enhanced update reliability with better backup error handling
- Improved diagnostic output for troubleshooting update failures

## 📚 Documentation

_None in this release_

## 💔 Breaking Changes

_None in this release_

## 📦 Installation

### New Installation

```bash
curl -L https://github.com/omayhemo/APM/releases/download/v1.2.7/apm-v1.2.7.tar.gz | tar -xz
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
