# APM Framework v4.3.2 Release Notes

**Release Date**: August 22, 2025  
**Version**: 4.3.2  
**Distribution**: coherence-v4.3.2-installer.tar.gz

---

## 🎯 Release Summary

APM Framework v4.3.2 includes the following improvements and fixes:


### Fixed
- **Planning-groom template document-registry.json path**: Corrected document registry path references in planning-business-case command template

### Added

## 📝 Changes in this Release


### Fixed
- **Planning-groom template document-registry.json path**: Corrected document registry path references in planning-business-case command template

### Added
- **New persona templates**: Enhanced persona system with additional specialized templates for comprehensive agent coverage
- **Planning-business-case command**: New comprehensive backlog grooming command with 18 parallel sub-agents for strategic planning and business case analysis

### Changed
- **Design architect renamed to designer**: Updated persona nomenclature throughout the framework for clearer role definition
  - Updated all persona templates, voice scripts, and command mappings
  - Maintained backward compatibility while modernizing persona architecture

## 📦 Distribution Details

- **Package**: coherence-v4.3.2-installer.tar.gz
- **Size**: Optimized for fast download and deployment
- **Compatibility**: Full backward compatibility maintained
- **Installation**: Zero-configuration setup with professional audio experience

## 🚀 Installation Commands

### Quick Install
```bash
# Default installation (recommended)
curl -fsSL https://raw.githubusercontent.com/omayhemo/APM/master/install.sh | bash -s -- --defaults

# Interactive installation
curl -fsSL https://raw.githubusercontent.com/omayhemo/APM/master/install.sh | bash

# With TTS voice notifications
curl -fsSL https://raw.githubusercontent.com/omayhemo/APM/master/install.sh | bash -s -- --with-tts --defaults
```

### First Steps After Installation
```bash
coherence          # Launch the unified orchestrator
/ap                # Alternative orchestrator activation
/analyst           # Start with research and analysis
/architect         # Design system architecture
/dev               # Begin development work
```

## 🔄 Upgrade Process

### From Previous Versions
This release maintains full backward compatibility. Users upgrading will receive all improvements automatically.

### Verification
After installation:
- Run `coherence` to verify orchestrator activation
- Check audio system with any agent activation
- Verify all slash commands are available

---

## 📋 Additional Information

- **GitHub Release**: https://github.com/omayhemo/APM/releases/tag/v4.3.2
- **Installation Guide**: Available in .apm/README.md after installation
- **Documentation**: Complete guides in .apm/documentation/ directory

**Ready for Production**: Suitable for individual developers, teams, and enterprise deployments.
