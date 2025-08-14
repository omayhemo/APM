# Project Docs Cleanup Summary - 2025-01-14

## Overview
Cleaned up the project_docs root directory by organizing files into appropriate subdirectories and removing duplicates.

## Changes Made

### 1. Moved Files to Appropriate Locations
- **backlog.md** → `planning/backlog.md`
- **CHANGELOG files** → `changelogs/` (new directory)
- **RELEASE_NOTES files** → `release-notes/` (new directory)
- **User guides** (QUICK-START-GUIDE, FAQ, HOW-TO-CREATE-NEW-AGENTS) → `docs/`
- **Path catalogs** → `reports/`

### 2. Archived Outdated Documents
Moved to `archives/`:
- APM planning and strategy documents
- Migration guides and version comparisons
- Implementation plans and proposals
- Debug host and MCP integration documents
- Various analysis and fix reports

### 3. Removed Duplicates
- **APM-COMMANDS files**: Removed from project_docs root as they already exist in `installer/templates/documentation/command-reference/`

### 4. Created New Directories
- `project_docs/changelogs/` - For version change logs
- `project_docs/release-notes/` - For release notes

### 5. Updated Configuration
- Modified `installer/templates/config/document-registry.json.template`:
  - Updated backlog location to `planning/backlog.md`
  - Added `changelog` document type for changelogs directory
  - Added `release_notes` document type for release-notes directory

## Final State
The project_docs root now contains only:
- `README.md` - Documentation pointer
- `index.md` - Documentation index
- Subdirectories for organized content

## Document Registry Updates
The document orchestrator will now properly govern:
- Changelogs in `{{PROJECT_DOCS}}/changelogs/`
- Release notes in `{{PROJECT_DOCS}}/release-notes/`
- Backlog in `{{PROJECT_DOCS}}/planning/backlog.md`

All document types are configured with appropriate naming patterns and detection rules.