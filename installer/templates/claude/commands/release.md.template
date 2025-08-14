# Release AP Mapping

Create a new release of the AP Mapping following the documented release process.

## Usage
```
/release <version> [--beta|--rc|--alpha]
```

## Examples
```
/release 1.1.0
/release 1.2.0-beta.1 --beta
/release 2.0.0-rc.1 --rc
```

## Process

When you run this command, I will:

1. **Validate Version Format & Git Status**
   - Ensure semantic versioning (MAJOR.MINOR.PATCH)
   - Handle pre-release suffixes if specified
   - Check for clean working directory

2. **Update Version References**
   - Update VERSION files in:
     - `/mnt/c/Code/agentic-persona-mapping/VERSION`
     - `/mnt/c/Code/agentic-persona-mapping/installer/VERSION`
     - `/mnt/c/Code/agentic-persona-mapping/installer/templates/VERSION`
   - Update version references in README.md files
   - Update installer documentation with new version

3. **Update All Documentation**
   - Create new CHANGELOG entry in `/project_docs/changelogs/CHANGELOG-v{version}.md`
   - Create release notes in `/project_docs/release-notes/RELEASE-NOTES-v{version}.md`
   - Update main README.md with new version and release date
   - Update installer README files with version information
   - Update quick start guides with new version

4. **Update APM Repository Installer**
   - Update `/mnt/c/Code/agentic-persona-mapping/APM/install.sh` if needed:
     - Update download URL pattern if changed
     - Update version detection logic if modified
     - Ensure compatibility with new release structure

5. **Build Distribution Package**
   - Run `build-distribution.sh` with new version
   - Verify distribution package creation in `/dist/` folder
   - Create distribution README in `/dist/README.md`
   - Place tar.gz file in `/dist/apm-v{version}.tar.gz`

6. **Commit Changes to Main Repository**
   - Commit all version updates and documentation changes
   - Create annotated git tag `v{version}`
   - Include comprehensive release notes in tag message

7. **Push to APM Repository (TAG ONLY)**
   - Clone or update APM repository separately
   - **CRITICAL**: Do NOT copy project files to APM repo
   - Only update:
     - APM/install.sh (if modified)
     - APM/README.md with new version info
   - Create and push git tag to APM repository
   - Create GitHub release with distribution package from `/dist/`
   - **NEVER** push working project files to APM repository

8. **Post-Release Verification**
   - Confirm release is accessible on GitHub
   - Validate download links in APM repository
   - Test installer download and execution
   - Verify distribution package integrity

## Options

- `--beta`: Create beta pre-release
- `--rc`: Create release candidate
- `--alpha`: Create alpha pre-release
- `--dry-run`: Show what would be done without making changes

## Requirements

- Clean git working directory
- GitHub CLI installed (for automated APM repo release)
- APM repository access (https://github.com/omayhemo/APM)
- Previous version tagged properly (for update testing)

## Implementation Details

When this command is executed, I will perform the following steps:

### Step-by-Step Execution:

1. **Version Validation**
   - Validate semantic versioning format
   - Check git working directory is clean
   - Verify no uncommitted changes

2. **Version Updates** (in main project repository)
   - Update all VERSION files
   - Update README.md files with new version
   - Update installer documentation

3. **Documentation Updates** (in main project repository)
   - Create `/project_docs/changelogs/CHANGELOG-v{version}.md`
   - Create `/project_docs/release-notes/RELEASE-NOTES-v{version}.md`
   - Update main README with release information

4. **Build Distribution**
   - Execute `build-distribution.sh`
   - Verify `/dist/apm-v{version}.tar.gz` created
   - Create `/dist/README.md` with installation instructions

5. **APM Repository Updates** (SEPARATE from main project)
   ```bash
   # Work in APM repository directory
   cd /mnt/c/Code/agentic-persona-mapping/APM
   
   # Update ONLY these files:
   - install.sh (if installer logic changed)
   - README.md (version and release date)
   
   # NEVER copy project files here
   ```

6. **Git Operations**
   ```bash
   # In main project repository
   git add -A
   git commit -m "Release v{version}"
   git tag -a "v{version}" -m "Release notes..."
   
   # In APM repository (separate)
   cd /mnt/c/Code/agentic-persona-mapping/APM
   git add install.sh README.md
   git commit -m "Update installer for v{version}"
   git tag -a "v{version}" -m "APM Framework v{version}"
   git push origin main --tags
   ```

7. **GitHub Release Creation**
   ```bash
   # Create release in APM repository
   gh release create v{version} \
     ../dist/apm-v{version}.tar.gz \
     --title "APM Framework v{version}" \
     --notes-file ../project_docs/release-notes/RELEASE-NOTES-v{version}.md
   ```

## Critical Safety Rules

### 🚨 NEVER DO THIS:
- **NEVER** copy `/project_docs/` to APM repository
- **NEVER** copy `.apm/` directory to APM repository  
- **NEVER** push working project files to APM repository
- **NEVER** use `cp -r` to copy entire project to APM

### ✅ ONLY DO THIS:
- **ONLY** update `APM/install.sh` and `APM/README.md`
- **ONLY** upload the distribution tar.gz from `/dist/`
- **ONLY** push tags and minimal installer updates
- **ONLY** work with distribution packages, not source files

## Notes

- The APM repository contains ONLY:
  - `install.sh` - Universal installer script
  - `README.md` - Installation instructions
  - GitHub Releases - Distribution packages
- Main project repository remains separate and private
- Distribution packages are self-contained installers
- Breaking changes require migration guide in RELEASE_NOTES.md