# AP Mapping v1.2.1

Released: 2025-07-14

## 🎉 Highlights

Critical hotfix release resolving macOS installation failures. This release ensures cross-platform compatibility for all users.

## 🐛 Bug Fixes

- **Fixed macOS installer crash**: Resolved "sed: invalid command code f" error that prevented installation on macOS
- **Cross-platform sed compatibility**: Added automatic OS detection for proper BSD vs GNU sed syntax
- **Template processing reliability**: All variable replacements now work correctly across Linux/WSL and macOS

## 🔧 Improvements

- **Enhanced OS detection**: Installer now automatically detects macOS vs Linux and uses appropriate commands
- **Improved error handling**: Better fallback mechanisms for cross-platform operations
- **Consolidated sed patterns**: Unified approach to in-place file editing across platforms

## 📚 Documentation

- Updated all installation commands to reference v1.2.1
- Maintained comprehensive command reference and documentation

## 💔 Breaking Changes

_None in this release_

## 📦 Installation

### New Installation

```bash
# Linux/WSL
wget https://github.com/omayhemo/APM/releases/download/v1.2.1/apm-v1.2.1.tar.gz && tar -xzf apm-v1.2.1.tar.gz && cd apm-v1.2.1 && ./installer/install.sh

# macOS 
curl -L https://github.com/omayhemo/APM/releases/download/v1.2.1/apm-v1.2.1.tar.gz -o apm-v1.2.1.tar.gz && tar -xzf apm-v1.2.1.tar.gz && cd apm-v1.2.1 && ./installer/install.sh
```

### Updating from Previous Version

```bash
.apm/agents/scripts/ap-manager.sh update
```

## 🔄 Migration Guide

No migration required - this is a hotfix release. All existing installations will continue to work normally.

## 📋 Full Changelog

- Fixed macOS BSD sed compatibility in installer/install.sh replace_variables() function
- Updated installer/templates/scripts/ap-manager.sh with cross-platform sed logic  
- Updated agents/scripts/ap-manager.sh with same cross-platform improvements
- Updated all README files with v1.2.1 download URLs
- Incremented VERSION file to 1.2.1

## Technical Details

The issue occurred because macOS uses BSD sed which requires an empty backup extension (`sed -i ''`) while Linux uses GNU sed which works without it (`sed -i`). The fix adds runtime OS detection:

```bash
if [[ "$OSTYPE" == "darwin"* ]]; then
    sed_inplace="-i ''"  # macOS
else
    sed_inplace="-i"     # Linux
fi
```

This ensures proper template variable replacement during installation on all platforms.