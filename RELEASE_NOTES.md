# AP Mapping v4.0.0

Released: 2025-08-13

## 🎉 Highlights

APM v4.0.0 represents the most significant modernization in framework history, delivering **4-8x performance improvements** through native sub-agent architecture and complete Task tool modernization. This release eliminates 25,599 lines of deprecated code while introducing comprehensive documentation reorganization.

## ✨ New Features

- **Native Sub-Agent Architecture**: Complete modernization from Task-based to native Claude Code sub-agents
- **Documentation Reorganization**: All APM docs now properly located in `.apm/documentation/` 
- **Comprehensive README**: New `.apm/README.md` with full table of contents and navigation
- **Unified Persona System**: Single source of truth for persona definitions eliminating 3x duplication
- **Enhanced /version Command**: Real-time version checking and update capabilities
- **Test Monitoring Integration**: Complete test dashboard and metrics collection

## 🐛 Bug Fixes

- Fixed hardcoded path issues throughout installer templates
- Resolved persona template duplication across multiple directories  
- Fixed document compliance enforcement patterns
- Corrected installer documentation delivery locations

## 🔧 Improvements

- **Performance**: 4-8x faster parallel execution with native sub-agents
- **Stability**: Zero CLI crashes with rock-solid native integration
- **Code Quality**: Removed 25,599 lines of deprecated/redundant code
- **Documentation**: 74 comprehensive documentation files covering all aspects
- **Installer**: Streamlined installation with proper path handling
- **Maintenance**: 75% reduction in template maintenance overhead

## 📚 Documentation

- Created comprehensive APM README at `.apm/README.md`
- Added 11 command reference documents covering 85+ commands
- Reorganized documentation structure with 8 major categories
- Created quick reference guides and cheatsheets
- Added troubleshooting and advanced topics sections

## 💔 Breaking Changes

**Documentation Location Change**:
- APM documentation moved from `project_docs/` to `.apm/documentation/`
- Project-specific docs should remain in `project_docs/`
- Update any scripts referencing old documentation paths

## 📦 Installation

### New Installation

```bash
curl -L https://github.com/omayhemo/APM/releases/download/v4.0.0/apm-v4.0.0.tar.gz | tar -xz
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
