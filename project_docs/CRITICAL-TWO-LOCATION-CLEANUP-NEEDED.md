# 🚨 CRITICAL: Two-Location Cleanup Required

**Date:** 2025-01-21  
**Status:** 🔴 URGENT CLARIFICATION  

---

## 📍 Two Separate Locations Need Cleanup

### 1. INSTALLED APM Framework Files
**Location:** `.apm/agents/tasks/`
- These are the ACTIVE files currently in use
- Created when APM was installed in this project
- The scripts I created (`deduplicate-commands.sh`) clean THESE files

### 2. INSTALLER TEMPLATE Files  
**Location:** `installer/templates/agents/tasks/`
- These are the SOURCE templates for NEW installations
- Have `.template` extension
- Get copied to new projects during installation
- **ALSO CONTAIN THE DUPLICATE FILES!**

---

## 🔴 The Problem

We have duplicates in BOTH locations:

```
CURRENT SCRIPTS CLEAN:
.apm/agents/tasks/
├── brainstorming-parallel.md         ← Current scripts archive these
├── create-epic-parallel.md
└── ... (13 duplicate files)

BUT WE ALSO NEED TO CLEAN:
installer/templates/agents/tasks/
├── brainstorming-parallel.md.template    ← Still has duplicates!
├── create-epic-parallel.md.template  
└── ... (23+ duplicate template files)
```

---

## 🎯 Complete Solution Needed

### Current Scripts (Already Created)
1. `deduplicate-commands.sh` - Cleans `.apm/agents/tasks/`
2. `verify-no-duplications.sh` - Verifies `.apm/agents/tasks/`

### Additional Scripts Needed
3. `deduplicate-installer-templates.sh` - Clean `installer/templates/agents/tasks/`
4. `verify-installer-templates.sh` - Verify installer templates are clean

---

## 📊 Impact Analysis

### If We Only Clean `.apm/`
- ✅ Current project is deduplicated
- ❌ New installations get duplicates again
- ❌ Templates still contain outdated patterns

### If We Clean BOTH Locations
- ✅ Current project is deduplicated
- ✅ New installations are clean
- ✅ Single source of truth maintained
- ✅ Framework is properly modernized

---

## 🚀 Recommended Action Plan

### Phase 1: Clean Installed Files
```bash
./scripts/deduplicate-commands.sh
./scripts/verify-no-duplications.sh
```

### Phase 2: Clean Installer Templates
```bash
./scripts/deduplicate-installer-templates.sh  # Need to create
./scripts/verify-installer-templates.sh       # Need to create
```

### Phase 3: Update Installer
- Ensure installer doesn't expect the removed files
- Update installation documentation
- Test fresh installation

---

## ⚠️ Critical Files to Clean in Templates

### Duplicate Parallel Task Templates
```
installer/templates/agents/tasks/
├── brainstorming-parallel.md.template
├── checklist-run-parallel.md.template
├── conduct-stakeholder-review-parallel.md.template
├── correct-course-parallel.md.template
├── create-ai-frontend-prompt-parallel.md.template
├── create-architecture-parallel.md.template
├── create-automation-plan-parallel.md.template
├── create-deep-research-prompt-parallel.md.template
├── create-epic-parallel.md.template
├── create-frontend-architecture-parallel.md.template
├── create-next-story-parallel.md.template
├── create-prd-parallel.md.template
├── create-requirements-parallel.md.template
├── create-test-plan-parallel.md.template
├── create-test-strategy-parallel.md.template
├── create-user-stories-parallel.md.template
├── define-acceptance-criteria-parallel.md.template
├── doc-sharding-parallel.md.template
├── execute-quality-review-parallel.md.template
├── library-indexing-parallel.md.template
├── prioritize-backlog-parallel.md.template
├── validate-requirements-parallel.md.template
└── groom-backlog-task.md.template
```

---

## 🔍 Key Question

**Do you want to:**

A. **Clean ONLY the installed files** (`.apm/`)
   - Quick fix for current project
   - But new installations still get duplicates

B. **Clean BOTH installed AND template files**
   - Complete solution
   - Ensures clean new installations
   - Properly modernizes the framework

**Recommendation: Option B - Clean both locations for complete solution**

---

*This is a critical architectural decision for the APM Framework*