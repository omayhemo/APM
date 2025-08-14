# Script Placement Rules - Document Registry Update

## Overview
Added strict enforcement rules to the document registry to ensure all scripts are properly organized in the designated scripts folder.

## New Rules Added

### 1. Script Document Type
A new "script" document type has been added with the following specifications:

**Location**: `{{PROJECT_DOCS}}/scripts/`
**Type**: Collection
**Mandatory**: Yes
**Enforcement Level**: Strict

**Supported Extensions**:
- Shell: `.sh`, `.bash`
- Python: `.py`
- JavaScript: `.js`, `.mjs`, `.cjs`
- TypeScript: `.ts`
- Ruby: `.rb`
- Perl: `.pl`, `.pm`
- PowerShell: `.ps1`, `.psm1`, `.psd1`

### 2. File Placement Rules

#### Scripts Rule
- **Rule**: All script files MUST be placed in `{{PROJECT_DOCS}}/scripts/` or its subdirectories
- **Enforcement**: Strict
- **Violations Action**: Block
- **Message**: "Scripts must be placed in {{PROJECT_DOCS}}/scripts/ or subdirectories"

#### Allowed Exceptions
Configuration files that are technically scripts but serve as configuration:
- `package.json`, `tsconfig.json`
- Build configs: `webpack.config.js`, `rollup.config.js`
- Test configs: `jest.config.js`, `mocha.opts`
- Linting configs: `.eslintrc.js`, `.prettierrc.js`

### 3. Documentation Rules
- **Rule**: All markdown documentation must be in appropriate subdirectories
- **Enforcement**: Warn
- **Allowed in Root**: `README.md`, `index.md`, `LICENSE.md`, `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`

### 4. Configuration Files
- **Rule**: Configuration files should remain in conventional locations
- **Enforcement**: Allow
- **Examples**: `.gitignore`, `.env`, `docker-compose.yml`, `Dockerfile`, `Makefile`

## Enforcement Mechanism

When the document location enforcer detects a script file:

1. **Detection**: Identifies files by extension and content markers
2. **Validation**: Checks if file is in allowed location
3. **Action**: 
   - If in wrong location: Blocks placement and shows error message
   - If exception: Allows placement
   - Logs all violations for audit

## Impact

### For Developers
- Must place all scripts in `/scripts/` directory
- Subdirectories are allowed for organization
- Configuration files remain in standard locations

### For Automation
- Document orchestrator will automatically enforce these rules
- Violations will be blocked and logged
- Clear error messages guide proper placement

## Compliance

All agents and users must:
1. Place new scripts in the scripts folder
2. Move existing scripts during cleanup operations
3. Use subdirectories for organization (e.g., `/scripts/test/`, `/scripts/deploy/`)
4. Keep configuration files in root or conventional locations

## Audit Trail

The system will maintain logs of:
- Script placement attempts
- Violations and corrections
- Override usage (if permitted)
- Agent compliance rates

This ensures consistent organization and makes scripts easy to find and manage.