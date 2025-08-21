# Release Commands Documentation

**Created:** August 7, 2025  
**Version:** APM v3.5.0+  
**Type:** Native Claude Commands

## 🚀 Overview

APM provides two complementary commands for release management:
- **`/version`** - Comprehensive documentation and version updates (4-8x faster with parallel execution)
- **`/release`** - Complete release process including GitHub push and distribution

## 📋 Quick Start

### Two-Command Workflow
```bash
# Step 1: Update all documentation and versions
/version 4.0.0

# Step 2: Build, tag, and push release
/release 4.0.0
```

### Version Command Usage
```
/version 4.0.0              # Update docs for major version
/version 3.6.1              # Update docs for patch
/version v3.7.0             # With 'v' prefix (auto-stripped)
```

### Release Command Usage
```
/release 4.0.0              # Complete release to GitHub
/release 3.6.1              # Patch release with distribution
/release 3.7.0-beta --beta  # Beta pre-release
```

## 🎯 Command Comparison

| Feature | `/version` | `/release` |
|---------|-----------|------------|
| **Purpose** | Documentation updates | Complete release process |
| **Updates VERSION files** | ✅ | ✅ |
| **Updates documentation** | ✅ Comprehensive | ✅ Basic |
| **Parallel execution** | ✅ 4-8x faster | ❌ Sequential |
| **Generates release notes** | ✅ From git history | ✅ Template |
| **Builds distribution** | ❌ | ✅ |
| **Git tag & commit** | ❌ | ✅ |
| **Push to GitHub** | ❌ | ✅ |
| **Creates GitHub release** | ❌ | ✅ |

## 📖 /version Command Details

### Key Features

### 1. **Parallel Execution Architecture**
- **4 Parallel Sub-Agents** per phase
- **4-8x Performance Improvement** over sequential processing
- **Native Claude Integration** for rock-solid stability
- **Real-time Progress Monitoring** with voice notifications

### 2. **Comprehensive Version Management**
- Automatic semantic version validation
- Smart version increment detection
- Pre-release tag support (alpha, beta, rc)
- Version synchronization across entire codebase

### 3. **Intelligent Documentation Updates**
- Automatic release notes generation from git history
- Changelog updates following Keep a Changelog standard
- Migration guide generation for major versions
- Link validation and integrity checking

### 4. **Quality Assurance**
- Version consistency verification
- Link and reference validation
- Content placeholder detection
- Deprecation notice verification

## 📊 What Gets Updated

### Version Files
- `VERSION` (root)
- `installer/VERSION`
- All template VERSION files
- Configuration files

### Documentation
- `README.md` - Version badges, installation commands
- `CLAUDE.md` - Framework instructions
- `CHANGELOG.md` - Version history
- `RELEASE_NOTES_v{VERSION}.md` - Created new
- All installer templates
- Project documentation

### Installation References
- wget/curl commands
- GitHub release URLs
- Docker/container versions
- CI/CD configurations

## 🔄 Execution Phases

### Phase 1: Validation & Analysis
- Version format validation
- Repository status check
- Breaking change detection
- Documentation audit

### Phase 2: Version Updates
- Core version file updates
- Documentation header updates
- Installation command updates
- Configuration synchronization

### Phase 3: Documentation Generation
- Release notes creation
- Changelog updates
- API documentation
- User guide updates

### Phase 4: Quality Assurance
- Version consistency checks
- Link validation
- Content validation
- Completeness verification

### Phase 5: Release Preparation
- Generate release checklist
- Create build commands
- Prepare git commands
- Generate GitHub release draft

## ✅ Success Criteria

The command completes successfully when:
- All version references are consistent
- Release notes are comprehensive
- Documentation is fully updated
- Links are validated and working
- Migration guide exists (for major versions)
- Distribution builds successfully
- Repository is ready for tagging

## 🚀 /release Command Details

### Key Features
- **GitHub Integration**: Direct push to APM repository
- **Distribution Building**: Automatic `build-distribution.sh` execution
- **Git Management**: Tag creation and commit handling
- **Release Creation**: Automated GitHub release with artifacts
- **Verification**: Post-release validation and testing

### Process Flow
1. Validate version format & git status
2. Update version references
3. Update documentation (basic)
4. Build distribution package
5. Commit & tag release
6. Push to APM repository
7. Create GitHub release
8. Post-release verification

## 🛠️ Integration with APM Workflow

### Complete Release Workflow
```bash
# 1. Quality checks
/qa                    # Run quality checks
/parallel-qa-framework # Execute comprehensive tests

# 2. Documentation preparation
/version 4.0.0         # Update all documentation (parallel)

# 3. Review changes
# Review generated release notes
# Check documentation updates

# 4. Execute release
/release 4.0.0         # Build, tag, and push to GitHub

# 5. Archive session
/wrap                  # Archive release session
```

### After Release
```bash
# Verify installation:
wget https://github.com/omayhemo/APM/releases/download/v4.0.0/apm-v4.0.0.tar.gz
tar -xzf apm-v4.0.0.tar.gz
./installer/install.sh
```

## 🔍 Example Sessions

### Using /version for Documentation
```
User: /version 4.0.0
Assistant: Updating documentation for version 4.0.0...

[Launches 4 parallel sub-agents for validation]
[Launches 4 parallel sub-agents for version updates]
[Launches 4 parallel sub-agents for documentation]
[Launches 3 parallel sub-agents for quality checks]

✅ Documentation update complete!
- Updated 47 files
- Created RELEASE_NOTES_v4.0.0.md
- Updated CHANGELOG.md
- All version references synchronized
- Links validated and working
```

### Using /release for GitHub Release
```
User: /release 4.0.0
Assistant: Creating release 4.0.0...

[Updates version files]
[Builds distribution with build-distribution.sh]
[Creates git tag v4.0.0]
[Pushes to GitHub]
[Creates GitHub release]

✅ Release v4.0.0 published!
- GitHub release: https://github.com/omayhemo/APM/releases/tag/v4.0.0
- Distribution: apm-v4.0.0.tar.gz uploaded
- Installation verified
```

## 🎪 Best Practices

### For Documentation Updates
Use `/version` when:
- Preparing comprehensive release notes
- Updating all documentation before release
- Validating version consistency
- Generating migration guides

### For Release Publishing
Use `/release` when:
- Ready to push to GitHub
- Distribution package needs building
- Creating official GitHub release
- Tagging version in git

### Recommended Workflow
1. **Always run `/version` first** for comprehensive documentation
2. **Review all changes** before proceeding
3. **Run `/release`** to publish to GitHub
4. **Verify installation** after release