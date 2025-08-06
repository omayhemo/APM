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
   - Update VERSION files throughout the system
   - Update download URLs in README.md files
   - Update installer documentation

3. **Update All the Documentation**
   - Update CHANGELOG.md with new version
   - Update RELEASE_NOTES.md with release notes template
   - Ensure all documentation reflects the new version
   - Update releavant readme files with new version information
    
4. **Build Distribution Package**
   - Run `build-distribution.sh` with new version
   - Verify distribution package creation
   - Update archive filename with new version

5. **Commit & Tag Release**
   - Commit all version changes
   - Create annotated git tag
   - Generate release notes template

6. **Push to APM Repository**
   - Push commits and tags to APM repo (https://github.com/omayhemo/APM)
   - Create GitHub release with distribution package
   - Verify release deployment

7. **Post-Release Verification**
   - Confirm release is accessible
   - Validate download links
   - Test update path if applicable

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

## Implementation

When this command is executed, I will:

1. **Parse Arguments**: Extract version and release type from command arguments
2. **Execute Release Script**: Run `.claude/scripts/release.sh` with the specified version and options
3. **Monitor Progress**: Track each step of the automated release process
4. **Report Results**: Provide final status and verification links

The release script will handle:
- Version validation and updates throughout the system
- Distribution building with `build-distribution.sh`
- Git tagging and commits with detailed release notes
- Automated push to APM repository (https://github.com/omayhemo/APM)
- GitHub release creation with distribution package
- Post-release verification steps and testing guidance

## Notes

- Automatically pushes to APM repository for distribution
- Creates GitHub release with distribution package
- Handles both stable and pre-release versions
- Always test the update path before releasing
- Breaking changes require migration guide in RELEASE_NOTES.md