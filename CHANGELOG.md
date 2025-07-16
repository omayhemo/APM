# Changelog

All notable changes to the AP Mapping will be documented in this file.

## [1.2.10] - 2025-07-16

### Fixed
- **TTS System**: Fixed critical bugs causing fallback to bell sounds instead of voice output
  - Corrected PROJECT_ROOT path calculation in tts-manager.sh
  - Fixed PIPER_BIN path to include correct piper/piper binary location
  - Resolved variable expansion issues in piper.sh configuration
  - Verified complete TTS functionality across all personas in WSL2 environment

- **Installer**: Fixed installer overwriting user README.md files
  - Modified build-distribution.sh to place README.md in .apm/ directory instead of root
  - Updated installer cleanup logic for new README location
  - Added user file protection during installation process

### Technical Details
- **TTS System**: Fixed tts-manager.sh PROJECT_ROOT path, piper.sh binary path, and variable expansion
- **Installer**: Moved distribution README.md to .apm/README.md to prevent user file overwrites
- **Verification**: Complete testing of both TTS audio pipeline and installer file protection

## [1.2.0-rc.2] - 2025-07-12

### Enhanced
- **APM Repository Integration**: Complete automation of release deployment
  - Automatic pushing to APM repository (https://github.com/omayhemo/APM)
  - GitHub release creation with distribution packages
  - Pre-release flagging for RC/beta/alpha versions
  - Error handling and fallback options

### Fixed
- Release script compatibility with missing README files
- Filename consistency (ap-mapping vs ap-method) throughout system
- Version update automation across all components
- Distribution build verification and error handling

### Improved
- **Release Workflow**: End-to-end automation from dev to production
  - Single command deployment to APM repository
  - Comprehensive error recovery and manual fallbacks
  - Release notes generation with installation instructions

## [1.2.0-rc.1] - 2025-07-12

### Added
- **Release Candidate Process**: Comprehensive release automation workflow
  - Automated version management across all system files
  - Distribution building and testing capabilities
  - GitHub release preparation with CLI integration
  - Quality assurance checkpoints for RC validation

### Enhanced
- **Command Structure**: Improved command organization and processing
  - Moved command definitions to `.claude/commands/` for better structure
  - Enhanced release workflow with automated validation steps
  - Improved git workflow integration for releases

### Fixed
- Command file organization and accessibility
- Version consistency across distribution components

### Quality Assurance
- Pre-release testing framework for distribution validation
- Automated integrity checking for release packages
- Enhanced documentation for release process

## [1.1.0-alpha.2] - 2025-01-10

### Added
- **Automatic Audio Player Installation**: Installer now checks for and installs required audio players
  - Automatically installs `mpg123` for ElevenLabs (MP3 support)
  - Automatically installs `alsa-utils` for Piper (WAV support)
  - Prevents audio static issues from the start

### Fixed
- **Audio Static Issue**: Fixed static/noise when using ElevenLabs on Linux/WSL
  - Prioritized MP3-capable players (mpg123, ffplay) over aplay
  - Added MP3-to-WAV conversion fallback when only aplay is available
  - Reordered audio player detection for better compatibility

### Changed
- **Voice Variety**: Added multiple ElevenLabs voices with automatic fallback
  - Each persona has a unique voice assignment
  - Automatically falls back to George voice if others aren't available
  - Works with both free and paid ElevenLabs plans

## [1.1.0-alpha] - 2025-01-10

### Added
- **Modular TTS System**: Complete overhaul of the text-to-speech system
  - New TTS Manager (`tts-manager.sh`) as central hub for all TTS operations
  - Support for multiple TTS providers:
    - Piper (local, offline) - Original provider
    - ElevenLabs (cloud, premium quality)
    - System TTS (OS built-in)
    - Discord (webhook notifications)
    - None (silent mode)
  - Provider interface pattern for easy extensibility
  - Smart caching system for cloud providers
  - Cross-platform audio playback support

### Changed
- **Installer Improvements**:
  - Interactive TTS provider selection during installation
  - Yellow-colored prompts for better user experience
  - Fixed installer hanging issues with proper stderr redirection
  - Automatic configuration of selected TTS provider
  
- **Voice Scripts Refactoring**:
  - All voice scripts now use the TTS manager
  - Removed hard dependency on Piper
  - Graceful fallback when TTS is unavailable
  
- **Settings Enhancement**:
  - New TTS configuration structure in settings.json
  - Support for per-persona voice customization
  - Multiple API key storage methods for security

### Fixed
- Installer hanging at project configuration step
- Voice scripts failing when Piper not installed
- Command substitution capturing prompts instead of displaying them

### Security
- API keys can be stored in environment variables, obfuscated, or system keychains
- No hardcoded credentials in any configuration files

## [1.0.0] - 2025-01-09

### Added
- Initial release of AP Mapping
- Agent Persona orchestration system
- Specialized agent roles (Orchestrator, Developer, Architect, etc.)
- Project-agnostic methodology framework
- Interactive installer with template system
- Voice notification support with Piper TTS
- Session notes management (Obsidian MCP and Markdown)
- Claude Code integration with custom commands
- Python hooks for automation
- Update management system (`ap-manager.sh`)

### Features
- `/ap` command to launch AP Orchestrator
- `/handoff` and `/switch` for agent transitions
- `/wrap` for session management
- Project documentation structure
- Configurable environment settings
- Git-aware installation process