# Version - Comprehensive Documentation Update for Release Preparation

Update all documentation and version references throughout the APM framework for a new release.

## Usage
```
/version <version> [--beta|--rc|--alpha] [--dry-run]
```

## Examples
```
/version 4.1.0                   # Major version update
/version 3.6.1                   # Patch version update  
/version 3.7.0-beta.1 --beta     # Beta pre-release
/version 4.1.0-rc.1 --rc         # Release candidate
/version v4.1.0                  # With 'v' prefix (auto-stripped)
```

## 🚀 Automated Parallel Execution

When you run this command, I will leverage **native sub-agents** for 4-8x faster documentation updates:

### Phase 1: Validation & Analysis (4 Parallel Sub-Agents)

```parallel
SubAgent1: Version Validation
- Parse and validate semantic version format
- Strip 'v' prefix if present
- Compare with current version for proper increment
- Validate pre-release tags (beta, rc, alpha)

SubAgent2: Repository Status
- Check git working directory status
- Identify uncommitted changes
- Verify branch is up to date
- Check for merge conflicts

SubAgent3: Dependency Analysis  
- Scan for breaking changes since last release
- Identify deprecated features
- Check API compatibility
- Document migration requirements

SubAgent4: Documentation Audit
- List all documentation files requiring updates
- Check for outdated version references
- Identify missing documentation
- Verify link integrity
```

### Phase 2: Version Updates (4 Parallel Sub-Agents)

```parallel
SubAgent1: Core Version Files
- Update /mnt/c/Code/agentic-persona-mapping/.apm/VERSION
- Update /mnt/c/Code/agentic-persona-mapping/VERSION  
- Update configuration version references
- Synchronize all version references

SubAgent2: Documentation Headers
- Update README.md version badges
- Update CLAUDE.md version headers
- Update all template documentation versions
- Update project_docs version references

SubAgent3: Installation Commands
- Update wget/curl commands in README.md
- Update GitHub release URLs
- Update installation scripts
- Update docker/container versions

SubAgent4: Configuration Files
- Update package.json versions
- Update build configuration
- Update CI/CD pipelines
- Update deployment scripts
```

### Phase 3: Documentation Generation (4 Parallel Sub-Agents)

```parallel
SubAgent1: Release Notes Creation
- Generate RELEASE_NOTES_v${VERSION}.md
- Analyze git log for changes
- Categorize features, fixes, and breaking changes
- Generate migration guide if major version

SubAgent2: Changelog Update
- Update CHANGELOG.md with new version section
- Aggregate all changes since last release
- Format according to Keep a Changelog standard
- Include contributor acknowledgments

SubAgent3: API Documentation
- Update API version references
- Document new endpoints/commands
- Mark deprecated features
- Generate compatibility matrix

SubAgent4: User Documentation
- Update user guides with new features
- Create feature comparison table
- Update FAQ with version-specific info
- Generate quick migration guide
```

### Phase 4: Quality Assurance (3 Parallel Sub-Agents)

```parallel
SubAgent1: Version Consistency Check
- Verify all VERSION files match
- Check all documentation references
- Validate download URLs will resolve
- Ensure template versions aligned

SubAgent2: Link Validation  
- Test all GitHub URLs
- Verify documentation cross-references
- Check external resource links
- Validate image/asset references

SubAgent3: Content Validation
- Check for placeholder text ([TODO], [VERSION])
- Verify code examples are updated
- Validate command syntax
- Ensure deprecation notices present
```

### Phase 5: Documentation Preparation

Sequential final steps with progress notifications:

1. **Generate Comprehensive Update Report**
2. **Create Version Consistency Checklist**
3. **Prepare Migration Guide (if major version)**
4. **Generate Documentation Summary**
5. **Create Pre-Release Verification Script**

## Process Details

When you run this command, I will:

1. **Validate Version Format**
   - Ensure semantic versioning (MAJOR.MINOR.PATCH)
   - Handle pre-release suffixes if specified
   - Auto-strip 'v' prefix if provided
   - Verify version increment is logical

2. **Update Version References** (Parallel Execution)
   - Update VERSION files throughout the system
   - Update download URLs in all documentation
   - Update installer documentation
   - Synchronize template versions

3. **Update All Documentation** (Parallel Execution)
   - Create RELEASE_NOTES_v${VERSION}.md with comprehensive changes
   - Update CHANGELOG.md with new version section
   - Update README.md with new version and features
   - Update CLAUDE.md with version-specific instructions
   - Update all template documentation
   - Generate migration guide for major versions
   
4. **Quality Verification**
   - Verify all version references are consistent
   - Validate all links and URLs
   - Check for placeholder text
   - Ensure documentation completeness

5. **Generate Reports**
   - Summary of all files updated
   - List of documentation changes
   - Version consistency report
   - Pre-release checklist

## Options

- `--beta`: Mark as beta pre-release in documentation
- `--rc`: Mark as release candidate in documentation
- `--alpha`: Mark as alpha pre-release in documentation
- `--dry-run`: Show what would be done without making changes
- `--no-release-notes`: Skip release notes generation
- `--minimal`: Only update version numbers (skip documentation)

## Requirements

- Git repository with history for changelog generation
- Write access to all documentation files
- Previous version tagged for comparison

## Implementation

When this command is executed, I will:

1. **Parse Arguments**: Extract version and options from command
2. **Execute Parallel Updates**: Launch native sub-agents for efficient processing
3. **Monitor Progress**: Track each step with voice notifications
4. **Generate Reports**: Provide comprehensive summary of all changes
5. **Create Artifacts**: Generate all updated documentation

The version update process will handle:
- Version validation and format checking
- Parallel documentation updates for efficiency
- Comprehensive changelog generation
- Release notes creation from git history
- Migration guide generation for major versions
- Link and reference validation
- Quality assurance checks

## Files Updated

### Core Version Files
- `/mnt/c/Code/agentic-persona-mapping/.apm/VERSION`
- `/mnt/c/Code/agentic-persona-mapping/VERSION`
- All configuration version references

### Documentation Files
- `${APM_PATH}/README.md`
- `${APM_PATH}/CLAUDE.md`
- `${APM_PATH}/CHANGELOG.md`
- `${APM_PATH}/RELEASE_NOTES_v${VERSION}.md` (created)
- All installer templates
- All project documentation

### Configuration Files
- Build scripts (version references)
- Installation scripts
- Package manifests
- CI/CD configurations

## Voice Notifications

```bash
# Initial notification
bash ${APM_PATH}/agents/voice/speakBase.sh "Updating documentation for version ${VERSION}"

# Progress notifications
bash ${APM_PATH}/agents/voice/speakBase.sh "Validating version format and repository status"
bash ${APM_PATH}/agents/voice/speakBase.sh "Updating documentation with 4 parallel agents"
bash ${APM_PATH}/agents/voice/speakBase.sh "Generating release documentation"
bash ${APM_PATH}/agents/voice/speakBase.sh "Running quality assurance checks"

# Completion notification
bash ${APM_PATH}/agents/voice/speakBase.sh "Documentation update complete for version ${VERSION}"
```

## Success Criteria

Documentation update is successful when:
- ✅ All version references updated consistently
- ✅ Release notes generated with all changes
- ✅ Documentation reflects new version throughout
- ✅ Installation commands updated with new URLs
- ✅ Migration guide created (for major versions)
- ✅ All links validated and working
- ✅ No placeholder text remaining
- ✅ Quality checks pass

## Error Recovery

If any step fails:
1. Automatic rollback of changes
2. Detailed error report generated
3. Recovery suggestions provided
4. Manual intervention points identified

## Example Output

```
User: /version 4.1.0