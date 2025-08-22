# Changelog

## [4.3.2] - 2025-08-22

### Fixed
- **Critical installer bug**: Fixed installer bug that caused installations in temporary directories instead of proper installation paths
- **Version command payload coverage**: Enhanced /version command to properly update payload directory files for complete version consistency
- **Marketing language cleanup**: Removed misleading "Enhanced TTS Audio Experience" labeling from release distributions

### Changed
- **Enhanced /version command**: Added 5th sub-agent for comprehensive payload directory coverage ensuring version consistency across all distribution files
- **Improved version consistency**: Enhanced version synchronization across all distribution package files and installer components

### Technical
- **Installer logic improvements**: Updated installer validation to prevent temporary directory installations
- **Payload directory integration**: Added payload directory updates to version command scope for complete coverage

## [4.3.0] - 2025-08-22

### Added
- **Planning-business-case command template**: Comprehensive backlog grooming with 18 parallel sub-agents for business case analysis and strategic planning
- **Enhanced persona voice integration**: Improved TTS system with better voice persona coordination

### Changed
- **Design Architect persona renamed to Designer**: Updated all references throughout the framework for clearer role definition
  - Updated persona templates, voice scripts, and command mappings
  - Maintained backward compatibility while modernizing persona nomenclature
- **Enhanced persona voice integration**: Improved coordination between voice personas and agent roles

### Removed
- **SM (Scrum Master) persona completely removed**: Eliminated deprecated Scrum Master role throughout the framework
  - Removed persona templates, voice scripts, and command mappings
  - Cleaned up installer templates and persona generation scripts
  - Updated documentation to reflect streamlined persona architecture

### Fixed
- **Installer quality control improvements**: Enhanced archive cleanup and validation processes
- **VERSION file consistency**: Resolved version synchronization issues across installer components
- **Document organization**: Cleaned up misplaced files and directory structures

### Security
- **Archive cleanup**: Removed redundant and deprecated template files to reduce maintenance overhead
- **Installation validation**: Enhanced installer integrity checking and error handling

---

All notable changes to the Agentic Persona Mapping Framework will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [4.2.0] - 2025-08-21

### Added
- **Complete v4.2.0 release preparation**: Enhanced installer infrastructure and persona management
- **Enhanced staging for v4.2.0 release**: Improved distribution building and quality assurance

### Changed
- **Installation script improvements**: Enhanced flags for non-interactive mode and legacy command management
- **Command reference updates**: Refactored command references in output styles and coherence templates for consistency

### Removed
- **Deprecated commands cleanup**: Deleted `ux-spec`, `validation`, and `wrap` command files
- **Legacy command management**: Updated installer to clean up deprecated commands and manage legacy command installation

### Fixed
- **Installation consistency**: Enhanced installation script with better error handling and validation
- **Template organization**: Improved coherence templates and command structure

[4.3.2]: https://github.com/omayhemo/agentic-persona-mapping/compare/v4.3.0...v4.3.2
[4.3.0]: https://github.com/omayhemo/agentic-persona-mapping/compare/v4.2.0...v4.3.0
[4.2.0]: https://github.com/omayhemo/agentic-persona-mapping/compare/v4.1.4...v4.2.0