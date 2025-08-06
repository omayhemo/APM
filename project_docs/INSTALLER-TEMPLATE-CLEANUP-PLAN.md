# APM Installer Template Cleanup Plan

**Date:** 2025-01-21  
**Status:** 🟡 READY TO EXECUTE  
**Focus:** TEMPLATES ONLY (not installed files)

---

## 🎯 Objective

Clean **ONLY** the installer templates to ensure future APM installations are free of duplicate task files that conflict with native slash commands.

---

## 📊 Current State

### Verification Results
```
✗ DUPLICATE TEMPLATES DETECTED
  - Found 36 duplicate template files in installer/templates/agents/tasks/
  - Template directory has 114 total template files
  - Slash command templates exist (61 files) ✓
  - Essential non-duplicate templates remain ✓
```

### Key Duplicates Found
- `brainstorming-parallel.md.template` → conflicts with `/parallel-brainstorming`
- `create-epic-parallel.md.template` → conflicts with `/parallel-epic`
- `create-requirements-parallel.md.template` → conflicts with `/parallel-requirements`
- `groom-backlog-task.md.template` → conflicts with `/groom`
- And 32 more...

---

## 🚀 Execution Plan

### Step 1: Execute Template Cleanup ⏱️ 2 minutes
```bash
cd /mnt/c/Code/agentic-persona-mapping
./scripts/deduplicate-installer-templates.sh
```

**What it does:**
- Archives 23+ duplicate template files to timestamped backup
- Creates recovery documentation in archive
- Preserves essential non-duplicate templates

### Step 2: Verify Cleanup Success ⏱️ 1 minute  
```bash
./scripts/verify-installer-templates.sh
```

**Expected Output:**
```
✓ NO DUPLICATE TEMPLATES FOUND
  - All duplicate task templates have been archived
  - Template directory structure is intact  
  - Slash command templates are present
  - Essential non-duplicate templates remain
```

### Step 3: Test Fresh Installation ⏱️ 5 minutes
```bash
# Create test directory and run installer
mkdir /tmp/test-apm-install
cd /tmp/test-apm-install
/mnt/c/Code/agentic-persona-mapping/installer/install.sh
```

**Verify:**
- Installation completes successfully
- No duplicate task files in `.apm/agents/tasks/`
- Slash commands work correctly
- Essential templates were installed

---

## 💡 Why Templates Only?

### Strategic Decision
- **Current installation works** - No need to risk breaking it
- **Templates are source of truth** - Future installations matter most
- **Lower risk approach** - Only touch installer, not active system
- **Clean slate for users** - New installations are optimized from day one

### Impact
- **Current project**: Unaffected, continues working
- **Future installs**: Clean, optimized, no duplicates
- **Framework evolution**: Properly modernized going forward

---

## 📂 What Gets Archived

### Parallel Task Templates (22 files)
```
installer/templates/agents/tasks/
├── brainstorming-parallel.md.template
├── create-epic-parallel.md.template
├── create-requirements-parallel.md.template
├── create-test-plan-parallel.md.template
└── ... (18 more parallel templates)
```

### Duplicate Base Templates (1 file)
```
├── groom-backlog-task.md.template
```

### Backup Files
```
├── *.template.backup files (if they exist)
```

---

## 🛡️ Safety Measures

### Backup Strategy
- Templates archived to `installer/archive/templates-duplicated-by-slash-commands-[timestamp]/`
- Recovery documentation included
- Original templates preserved for rollback

### What Remains Untouched
- **Current installation**: `.apm/` directory unchanged
- **Essential templates**: Non-duplicate templates preserved
- **Slash command templates**: All 61 files remain
- **Persona templates**: All 40 files remain
- **Core functionality**: Installer still works

### Rollback Plan
If problems occur:
1. Copy templates from archive back to `installer/templates/agents/tasks/`
2. Test installation again
3. Document what failed

---

## ✅ Success Criteria

- [ ] 0 duplicate template files remain
- [ ] Verification script passes
- [ ] Fresh installation works correctly
- [ ] Essential templates preserved
- [ ] Slash commands function in new install

---

## 🚀 Ready to Execute

**All preparation complete:**
- ✅ Scripts created and tested
- ✅ Verification confirms 36 duplicates
- ✅ Backup strategy documented
- ✅ Recovery plan established
- ✅ Focus clarified (templates only)

**Execute when ready:**
```bash
./scripts/deduplicate-installer-templates.sh
./scripts/verify-installer-templates.sh
```

---

## 📈 Expected Benefits

### For New Users
- Clean installations with no confusing duplicates
- Optimal performance from day one
- Clear slash command interface
- No maintenance burden from legacy files

### For Framework
- Modernized installer
- Single source of truth enforced
- Reduced template maintenance
- Consistent user experience

---

*Ready to clean the templates and modernize the APM Framework installer!*