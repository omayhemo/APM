# AP Mapping v1.2.10

Released: 2025-07-16

## 🎉 Highlights

Fixed critical TTS system failures and installer file overwrite issues that were impacting user experience.

### ✅ TTS System Fully Restored
- **Fixed critical TTS system failures** that were causing fallback to bell sounds
- **Restored complete voice functionality** across all 9 specialized personas
- **Verified audio pipeline** working correctly in WSL2 environments

### 🛡️ Installer User File Protection
- **Prevents overwriting user README.md files** during installation
- **Safer installation process** that respects existing project files
- **Improved user experience** with protected project directory

## 🔧 Technical Fixes

### TTS System Restoration
- **Fixed PROJECT_ROOT path calculation** in tts-manager.sh (was going up extra directory)
- **Corrected PIPER_BIN path** to include proper piper/piper binary location
- **Resolved variable expansion issues** in piper.sh configuration parsing
- **Complete testing verification** of audio pipeline functionality

### Installer Improvements
- **Modified build-distribution.sh** to place README.md in .apm/ directory instead of root
- **Updated installer cleanup logic** with backward compatibility
- **Added user file protection** during extraction and installation
- **Tested installer safety** with existing user projects

---

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
