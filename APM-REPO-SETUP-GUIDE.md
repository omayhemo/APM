# 📦 APM Repository Setup Guide

## Setting Up a Clean Releases-Only Repository

This guide explains how to set up the APM repository as a clean, releases-only distribution channel.

### 🎯 Repository Structure

The APM repository should contain ONLY these files:
```
APM/
├── README.md       # User-facing documentation
├── LICENSE         # MIT License
├── CHANGELOG.md    # Version history
├── install.sh      # Universal installer
└── .gitignore      # Ignore local files
```

**NO source code, NO templates, NO installer directories** - just the essentials!

### 📋 Step-by-Step Setup

#### 1. Clean the Repository (if needed)

If the APM repo currently has source files:

```bash
# Clone the repository
git clone https://github.com/omayhemo/APM.git
cd APM

# Remove everything except .git
find . -maxdepth 1 ! -name '.git' ! -name '.' -exec rm -rf {} +

# Verify it's clean
ls -la
```

#### 2. Add the New Files

```bash
# Copy the prepared files
cp /mnt/c/Code/agentic-persona-mapping/APM-REPO-FILES/* .
cp /mnt/c/Code/agentic-persona-mapping/APM-REPO-FILES/.gitignore .

# Verify the structure
ls -la
```

#### 3. Commit the Clean Repository

```bash
git add -A
git commit -m "refactor: Convert to releases-only distribution repository

- Remove all source code (moved to development repo)
- Add universal installer script
- Update README for v4.0.0
- Add proper changelog
- Releases now distributed via GitHub Releases only"

git push origin main
```

#### 4. Upload the Release

The v4.0.0 release is already created. Future releases:

```bash
# In your development repo
./build-distribution.sh
gh release create v4.1.0 dist/apm-v4.1.0.tar.gz \
  --title "APM v4.1.0" \
  --notes "Release notes here"
```

### 🚀 How Users Install

With this setup, users have multiple clean options:

**Option 1: Universal Installer (Recommended)**
```bash
curl -fsSL https://raw.githubusercontent.com/omayhemo/APM/main/install.sh | bash
```

**Option 2: Download Specific Version**
```bash
curl -L https://github.com/omayhemo/APM/releases/download/v4.0.0/apm-v4.0.0.tar.gz | tar -xz
cd apm-v4.0.0
./installer/install.sh
```

**Option 3: Clone and Install**
```bash
git clone https://github.com/omayhemo/APM.git
cd APM
./install.sh
```

### 📊 Benefits of This Approach

1. **Clean Repository** - Only 5 files, ~10KB total
2. **Clear Purpose** - Obviously a distribution repo
3. **Easy Maintenance** - Just update README and push releases
4. **Professional** - Similar to Homebrew, Docker, etc.
5. **Fast Cloning** - No large files in git history

### 🔄 Release Workflow

For future releases from your development repo:

```bash
# 1. In development repo (agentic-persona-mapping)
/version 4.1.0
/release 4.1.0

# 2. This creates the GitHub release automatically

# 3. Update the APM repo's CHANGELOG.md if needed
cd APM
# Edit CHANGELOG.md
git add CHANGELOG.md
git commit -m "docs: Update changelog for v4.1.0"
git push
```

### 📝 Notes

- All actual releases are stored as GitHub Releases (not in git)
- The repository stays tiny and clean
- Users always get the latest with the universal installer
- Development happens in the main repo (agentic-persona-mapping)
- APM repo is purely for distribution

### ✅ File Summary

I've created all the files you need in:
`/mnt/c/Code/agentic-persona-mapping/APM-REPO-FILES/`

- `README.md` - Clean, simple, focused on benefits
- `LICENSE` - Standard MIT license
- `CHANGELOG.md` - Version history
- `install.sh` - Universal installer that fetches latest
- `.gitignore` - Keeps the repo clean

Just copy these to the APM repository and you'll have a professional, releases-only distribution channel!