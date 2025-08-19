# Release APM Framework

Create a new release of the APM Framework using the automated release script.

## 🚨 CRITICAL: USE THE AUTOMATED SCRIPT ONLY 🚨

**All releases MUST use the automated script `release-to-apm.sh`**

## Usage
```
/release <version>
```

## Examples
```
/release 4.1.5
/release 4.2.0
/release 5.0.0
```

## 🔴 CLAUDE INSTRUCTIONS - FOLLOW EXACTLY

### Step 1: Validate Version Format
- Ensure the version follows semantic versioning (MAJOR.MINOR.PATCH)
- Reject any version that doesn't match this format
- Examples: `4.1.5` ✅, `v4.1.5` ❌, `4.1` ❌

### Step 2: Execute the Automated Script
**Execute this EXACT command:**
```bash
./release-to-apm.sh <version>
```

**NEVER:**
- ❌ Manually copy files between repositories
- ❌ Run individual git commands for releases  
- ❌ Create releases manually with `gh` commands
- ❌ Modify files in APM/ directory manually
- ❌ Use any process other than the script

### Step 3: Report Results
After the script completes:
- ✅ Confirm the version was released successfully
- ✅ Provide the GitHub release URL
- ✅ Provide the installation command for users
- ✅ Note any errors that occurred

## 🛡️ What the Script Does (Automatically)

The `release-to-apm.sh` script handles ALL release operations safely:

1. **Updates APM/ staging area** (if version files need updates)
2. **Creates dynamic release notes** from changelog and git commits
3. **Builds distribution package** using `build-distribution.sh`
4. **Commits APM/ contents to APM repository root** using git subtree
5. **Creates GitHub release** with distribution package
6. **Includes comprehensive safety checks** to prevent repository confusion

## 🔒 Safety Guarantees

The automated script includes these built-in protections:
- ✅ **NEVER touches agentic-persona-mapping repository files**
- ✅ **ONLY commits to APM repository (https://github.com/omayhemo/APM)**
- ✅ **NEVER deletes any files from development repository**
- ✅ **Verifies repository URLs before any operations**
- ✅ **Uses APM/ directory as staging area (preserves it)**
- ✅ **Fails safely if any check doesn't pass**

## 📋 Prerequisites

Before running the release command:
- Clean git working directory (no uncommitted changes)
- APM remote configured: `git remote add apm https://github.com/omayhemo/APM.git`
- GitHub CLI installed and authenticated (`gh auth status`)

## 🚨 CLAUDE: NEVER DO THESE THINGS

**PROHIBITED ACTIONS:**
- ❌ Manual file copying between directories
- ❌ Direct git operations on APM repository
- ❌ Manual GitHub release creation
- ❌ Bypassing the automated script
- ❌ Modifying the script during release process
- ❌ Creating releases in agentic-persona-mapping repository

**IF THE SCRIPT FAILS:**
- ✅ Report the exact error message
- ✅ Ask user to investigate and fix the issue
- ✅ DO NOT attempt manual workarounds
- ✅ DO NOT modify files to "fix" the problem

## 📤 Expected Output

Successful release will show:
```
APM Release v4.1.5 Complete!
✅ APM/ folder contents committed to APM repository root
✅ Target repository: https://github.com/omayhemo/APM
✅ GitHub release created

Distribution Package: coherence-v4.1.5-installer.tar.gz
GitHub Release: https://github.com/omayhemo/APM/releases/tag/v4.1.5
Installation: curl -fsSL https://raw.githubusercontent.com/omayhemo/APM/master/install.sh | bash -s -- --defaults
```

## 🎯 Claude's Role Summary

1. **Validate** the version format provided by user
2. **Execute** the automated script with the version parameter
3. **Report** the results (success/failure) to the user
4. **Provide** installation instructions if successful
5. **DO NOT** perform any manual release operations

**Remember: The script does ALL the work. Claude just validates input and executes it.**