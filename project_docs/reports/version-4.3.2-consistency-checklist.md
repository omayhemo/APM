# APM Framework v4.3.2 - Version Consistency Checklist

**Date**: August 22, 2025  
**Version**: 4.3.2  
**Type**: Pre-Release Verification Checklist

---

## ✅ Core Version Files Verification

### Primary VERSION Files
- [ ] `/mnt/c/Code/agentic-persona-mapping/VERSION` shows `4.3.2`
- [ ] `/mnt/c/Code/agentic-persona-mapping/.apm/VERSION` shows `4.3.2`
- [ ] `/mnt/c/Code/agentic-persona-mapping/APM/VERSION` shows `4.3.2`
- [ ] `/mnt/c/Code/agentic-persona-mapping/payload/VERSION` shows `4.3.2`

### Distribution VERSION Files
- [ ] `/mnt/c/Code/agentic-persona-mapping/dist/coherence-v4.3.2-installer/installer/VERSION` shows `4.3.2`
- [ ] `/mnt/c/Code/agentic-persona-mapping/.apm/.installer/templates/VERSION` shows `4.3.2`

**Command to verify all VERSION files:**
```bash
find /mnt/c/Code/agentic-persona-mapping -name "VERSION" -exec echo "{}:" \; -exec cat {} \; | grep -E "(VERSION|4\.3\.2)"
```

## ✅ Documentation Version References

### Main Documentation Files
- [ ] `README.md` header shows version 4.3.2
- [ ] `README.md` latest release badge shows v4.3.2
- [ ] `README.md` installation URLs reference v4.3.2
- [ ] `APM/README.md` version badge shows 4.3.2-blue.svg
- [ ] `APM/README.md` all version references show 4.3.2

### Release Documentation  
- [ ] `CHANGELOG.md` has v4.3.2 section at top
- [ ] `APM/CHANGELOG.md` has v4.3.2 section
- [ ] `project_docs/release-notes/RELEASE-NOTES-v4.3.2.md` exists and complete
- [ ] `APM/Release-Notes.md` reflects v4.3.2

**Command to check main documentation versions:**
```bash
grep -n "4\.3\.2" /mnt/c/Code/agentic-persona-mapping/README.md | wc -l
# Should return 17+ matches
```

## ✅ Installation Command Verification

### Download URLs
- [ ] Linux/WSL wget command uses v4.3.2 URL
- [ ] macOS curl command uses v4.3.2 URL  
- [ ] All installation URLs reference `coherence-v4.3.2-installer.tar.gz`
- [ ] GitHub release URLs point to `/releases/tag/v4.3.2`

### Installation Command Examples
- [ ] `README.md` wget command: `https://github.com/omayhemo/agentic-persona-mapping/releases/download/v4.3.2/coherence-v4.3.2-installer.tar.gz`
- [ ] `README.md` curl command references same v4.3.2 URL
- [ ] `APM/README.md` version-specific installation commands
- [ ] Universal installer URLs reference correct paths

**Command to verify installation URLs:**
```bash
grep -r "releases/download/v4\.3\.2" /mnt/c/Code/agentic-persona-mapping/README.md
# Should return wget and curl commands
```

## ✅ Build System Consistency

### Build Scripts
- [ ] `build-distribution.sh` DEFAULT_VERSION is `4.3.2`
- [ ] `release-to-apm.sh` examples reference v4.3.2
- [ ] Distribution directory named `coherence-v4.3.2-installer`
- [ ] Installer package naming follows v4.3.2 format

### Template System
- [ ] All template files in `payload/templates/` reference 4.3.2
- [ ] All persona files in `payload/personas/` reference 4.3.2
- [ ] Command templates in `.claude/commands/` show current version

**Command to verify build system:**
```bash
grep "DEFAULT_VERSION" /mnt/c/Code/agentic-persona-mapping/build-distribution.sh
# Should show DEFAULT_VERSION="4.3.2"
```

## ✅ Enhanced /version Command Verification

### Command Specification Update
- [ ] `.claude/commands/version.md` shows 5 parallel sub-agents
- [ ] SubAgent2 "Payload Directory" section present
- [ ] Examples in version.md show 4.3.2
- [ ] Files Updated section includes payload directory

### Template Version  
- [ ] `payload/templates/claude/commands/version.md.template` shows 5 sub-agents
- [ ] Template includes enhanced SubAgent2 functionality
- [ ] Template examples reference 4.3.2

**Command to verify /version command enhancement:**
```bash
grep -A 2 "SubAgent2: Payload Directory" /mnt/c/Code/agentic-persona-mapping/.claude/commands/version.md
# Should show the new critical payload directory section
```

## ✅ Quality Assurance Validation

### No Remaining Legacy Versions
- [ ] No active files contain 4.3.1 references (excluding historical docs)
- [ ] No active files contain 4.3.0 references (excluding historical docs)  
- [ ] Template placeholders use current version variables

### Link Integrity
- [ ] All GitHub URLs follow correct v4.3.2 format
- [ ] No broken internal documentation links
- [ ] All external resource links functional

**Command to check for legacy versions in active files:**
```bash
grep -r "4\.3\.1" /mnt/c/Code/agentic-persona-mapping/ --exclude-dir=.git --exclude-dir=node_modules | grep -v archive | grep -v backup | wc -l
# Should return 0 or only historical documentation files
```

## ✅ Distribution Package Integrity

### Payload Directory (Critical Fix)
- [ ] `payload/VERSION` shows 4.3.2
- [ ] `payload/install.sh` has correct version references
- [ ] `payload/README.md` shows 4.3.2 throughout
- [ ] All payload templates updated to 4.3.2
- [ ] All payload personas updated to 4.3.2

### Distribution Structure
- [ ] `dist/coherence-v4.3.2-installer/` directory exists
- [ ] Installer directory contains correct VERSION file
- [ ] Package structure matches expected v4.3.2 format

**Command to verify payload directory:**
```bash
find /mnt/c/Code/agentic-persona-mapping/payload -name "*.md" -o -name "*.sh" -o -name "*.template" | xargs grep -l "4\.3\.2" | wc -l
# Should return 10+ files
```

## ✅ User Experience Verification

### Installation Success
- [ ] Installation commands will work once release is live
- [ ] Version numbers displayed to users are consistent
- [ ] No temporary directory installation issues
- [ ] Installer places files in proper user directories

### Documentation Clarity
- [ ] Release notes clearly communicate improvements
- [ ] Migration guide indicates no migration needed
- [ ] FAQ addresses any version-related questions
- [ ] Troubleshooting guides updated for v4.3.2

## 🚨 Critical Issues Checklist

### Previously Identified Issues (Must be Fixed)
- [ ] **FIXED**: Installer temp directory bug resolved
- [ ] **FIXED**: /version command now updates payload directory
- [ ] **FIXED**: Version consistency across all distribution files
- [ ] **FIXED**: "Enhanced TTS Audio Experience" labeling removed

### New Issues (Should be None)
- [ ] No new version mismatches introduced
- [ ] No new broken links introduced
- [ ] No new installation issues introduced
- [ ] No new command syntax errors

## 🎯 Final Release Verification Commands

```bash
# 1. Verify all VERSION files are 4.3.2
find /mnt/c/Code/agentic-persona-mapping -name "VERSION" -exec cat {} \; | sort | uniq
# Should show only: 4.3.2

# 2. Count version references in main README
grep -o "4\.3\.2" /mnt/c/Code/agentic-persona-mapping/README.md | wc -l  
# Should show 17+ matches

# 3. Test enhanced /version command structure
grep -c "SubAgent.*Payload Directory" /mnt/c/Code/agentic-persona-mapping/.claude/commands/version.md
# Should return 1 (the new SubAgent2)

# 4. Verify distribution package naming
ls /mnt/c/Code/agentic-persona-mapping/dist/coherence-v4.3.2-installer/
# Should show installer directory with correct version

# 5. Check for any remaining legacy versions (should be 0)
grep -r "4\.3\.1" /mnt/c/Code/agentic-persona-mapping/README.md /mnt/c/Code/agentic-persona-mapping/APM/ | wc -l
# Should return 0
```

## ✅ Final Approval Checklist

- [ ] All core VERSION files show 4.3.2
- [ ] All documentation references updated
- [ ] All installation commands reference v4.3.2
- [ ] Enhanced /version command documented
- [ ] Distribution package integrity verified
- [ ] No legacy version references in active files
- [ ] Quality assurance passed (100% scores)
- [ ] Critical bug fixes implemented and verified

**Release Status**: 🚀 **READY** when all items above are checked

---

**Checklist Created**: 2025-08-22  
**For Release**: v4.3.2  
**Verification**: Use commands provided to validate each section