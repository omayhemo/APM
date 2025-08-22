# APM Framework v4.3.0 - Installation Options

## Enhanced Installation with Quality Control

v4.3.0 features an enhanced installer with improved validation, quality control, and automatic cleanup of deprecated components.

## Installation Methods

### 1. v4.3.0 Interactive Installation (Recommended)
```bash
curl -fsSL https://raw.githubusercontent.com/omayhemo/APM/master/install.sh | bash
```

**v4.3.0 Enhancements:**
- Automatic cleanup of deprecated SM persona files
- Validation of design-architect to designer migration
- Enhanced quality control during installation
- Improved error handling and recovery

This will prompt you for:
- Project name
- Plopdock MCP Server setup
- TTS provider selection
- Notification preferences
- Python support

### 2. v4.3.0 Silent Installation (Quick Setup)
```bash
curl -fsSL https://raw.githubusercontent.com/omayhemo/APM/master/install.sh | bash -s -- --version 4.3.0 --defaults
```

This will:
- Install APM Framework v4.3.0 specifically
- Use current directory name as project name
- Skip Plopdock MCP setup
- Use Piper TTS (offline)
- Disable all notifications
- Skip Python virtual environment setup
- **NEW**: Automatically clean up deprecated SM commands
- **NEW**: Update design-architect references to designer

### 3. Download First, Then Run (Alternative Method)
If you still have issues with interactive mode:

```bash
# Download installer
curl -fsSL https://raw.githubusercontent.com/omayhemo/APM/master/install.sh -o install-apm.sh

# Make executable
chmod +x install-apm.sh

# Run interactively
./install-apm.sh

# Or run with defaults
./install-apm.sh --defaults
```

## What Was Fixed

The installer was failing to accept user input when piped through curl because stdin was already being used by the pipe. The fix redirects stdin to `/dev/tty` to allow interactive prompts to work properly.

## v4.3.0 Troubleshooting

### Installation Issues

1. **Check if you have a TTY**:
   ```bash
   tty
   ```
   Should output something like `/dev/pts/0`

2. **Try the download-first method** shown above

3. **Use the --defaults flag** for a quick installation

### v4.3.0 Specific Issues

**Issue: SM commands still present after installation**
```bash
# Solution: Re-run installer with cleanup
curl -fsSL https://raw.githubusercontent.com/omayhemo/APM/master/install.sh | bash -s -- --version 4.3.0 --force-cleanup
```

**Issue: design-architect references not updated**
```bash
# Solution: Verify installation completed
ls .claude/commands/ | grep designer  # Should show designer.md
ls .claude/commands/ | grep design-architect  # Should be empty
```

**Issue: /planning-business-case command not available**
```bash
# Solution: Verify v4.3.0 installation
cat .apm/VERSION  # Should show 4.3.0
ls .claude/commands/planning-business-case.md  # Should exist
```

## v4.3.0 Installation Verification

### Post-Installation Validation

After installing v4.3.0, verify your installation:

```bash
# Check version
cat .apm/VERSION  # Should show 4.3.0

# Verify persona count (8 total)
ls .claude/commands/ | grep -E "(analyst|pm|architect|designer|po|dev|qa|subtask)" | wc -l

# Check for new planning-business-case command
ls .claude/commands/planning-business-case.md

# Verify SM cleanup (should return nothing)
ls .claude/commands/ | grep sm

# Test activation
/coherence  # Should mention v4.3.0 and native sub-agents
```

### Successful Installation Indicators

✅ **Version shows 4.3.0**  
✅ **8 personas available (no SM)**  
✅ **Designer persona present (no design-architect)**  
✅ **planning-business-case command available**  
✅ **Enhanced installer messages during setup**