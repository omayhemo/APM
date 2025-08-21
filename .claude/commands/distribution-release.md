# Release AP Mapping
name: distribution-release

Create a new release of the AP Mapping using the automated release-to-apm.sh script.

## 🚨 CRITICAL REPOSITORY RULES 🚨

### 🔴 APM REPOSITORY UPDATES
**ONLY THESE FILES MAY BE UPDATED IN APM REPOSITORY:**
- ✅ `APM/install.sh` - Universal installer script ONLY
- ✅ `APM/README.md` - Installation instructions ONLY  
- ❌ **NOTHING ELSE** - NO project files, NO documentation, NO source code

### 🔴 GITHUB RELEASES DESTINATION
**ALL RELEASES MUST GO TO APM REPOSITORY:**
- ✅ `gh release create --repo omayhemo/APM` - **ALWAYS USE THIS**
- ❌ `omayhemo/agentic-persona-mapping` - **NEVER RELEASE HERE**

**VIOLATION OF THESE RULES BREAKS INSTALLATION FOR ALL USERS**

## Usage
```
/distribution-release <version>
```

## Examples
```
/distribution-release 4.2.0
/distribution-release 4.3.0
```

## Automated Process

When you run this command, I will execute the `release-to-apm.sh` script which automatically:

1. **Updates APM/ staging files** (VERSION, README.md version badges)
2. **Generates dynamic release notes** from changelog and recent commits
3. **Builds distribution package** using build-distribution.sh
4. **Commits APM/ contents to APM repository** using git subtree (SAFE - never touches your dev repo)
5. **Creates GitHub release** with distribution package (--repo omayhemo/APM)

## Implementation

When executed, this command runs:

```bash
bash release-to-apm.sh <version>
```

The script includes:
- **Safety guarantees**: Never touches agentic-persona-mapping repository
- **Automatic validation**: Checks git status, version format, and repository URLs
- **Dynamic release notes**: Generated from changelog and git history
- **Complete automation**: One command does everything safely

## Example Execution

```bash
# Command
/distribution-release 4.2.0

# Equivalent to
bash /mnt/c/Code/agentic-persona-mapping/release-to-apm.sh 4.2.0
```

## Output

The script provides:
- ✅ Colored progress indicators
- ⚠️ Safety verification steps  
- 📦 Distribution package details
- 🌐 GitHub release URL
- 🔗 Installation command for users

## Safety Guarantees

The release script:
- **✅ NEVER** touches your development repository
- **✅ ONLY** releases to APM repository (`--repo omayhemo/APM`)
- **✅ NEVER** deletes any files from development repo
- **✅ Uses** git subtree for safe repository isolation
- **✅ Validates** all operations before execution

## Requirements

- GitHub CLI (gh) installed
- APM repository remote configured
- Semantic version format (e.g., 4.2.0)

## Post-Release

After successful execution:
- New GitHub release at: `https://github.com/omayhemo/APM/releases/tag/v{version}`
- Distribution package: `coherence-v{version}-installer.tar.gz`
- Installation ready for users