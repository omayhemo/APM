# AP Mapping v1.2.0-rc.2

Released: 2025-07-12

## 🎉 Highlights

This release candidate introduces **complete APM repository automation**, allowing seamless deployment from development to production with a single command.

## ✨ New Features

- **APM Repository Integration**: Automatic pushing to APM repository (https://github.com/omayhemo/APM)
- **GitHub Release Automation**: Creates releases with distribution packages automatically
- **Enhanced Release Script**: Complete end-to-end release workflow with error handling

## 🐛 Bug Fixes

- Fixed release script compatibility with missing README files
- Corrected filename consistency (ap-mapping vs ap-method) throughout system
- Fixed version update automation across all components
- Improved distribution build verification and error handling

## 🔧 Improvements

- **Single Command Deployment**: `/release` command now handles complete workflow
- **Pre-release Support**: Automatic flagging for RC/beta/alpha versions
- **Error Recovery**: Comprehensive fallback options and manual steps
- **Release Notes Generation**: Automated template creation with installation instructions

## 📚 Documentation

- Updated release command documentation with APM integration
- Enhanced release workflow instructions
- Added comprehensive error handling guidance

## 💔 Breaking Changes

_None in this release_

## 📦 Installation

### New Installation

```bash
curl -L https://github.com/omayhemo/APM/releases/download/v1.2.0-rc.2/ap-mapping-v1.2.0-rc.2.tar.gz | tar -xz
./installer/install.sh
```

### Updating from Previous Version

```bash
agents/scripts/ap-manager.sh update
```

## 🔄 Migration Guide

No migration steps required for this release candidate.

## 📋 Full Changelog

See [CHANGELOG.md](https://github.com/omayhemo/APM/blob/main/CHANGELOG.md) for complete history.