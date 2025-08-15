# Installer Cleanup Documentation

## Overview

The APM installer now includes automatic cleanup functionality to remove the installer folder after successful installation. This prevents leftover installer files from cluttering the project directory.

## How It Works

### 1. During Installation

The installer performs cleanup in multiple stages:

1. **Preservation Phase**: The installer copies itself to `.apm/.installer/` for future management and updates
2. **Primary Cleanup**: Attempts to remove the installer directory immediately after preservation
3. **Deferred Cleanup**: If the installer is still running from the installer directory, schedules cleanup for after script completion

### 2. Manual Cleanup

If the installer folder is left behind for any reason, you can manually clean it up:

```bash
# Option 1: Use the standalone cleanup script
./installer-cleanup.sh

# Option 2: Manual removal (after verifying APM is installed)
rm -rf installer/
```

### 3. Cleanup Safety Checks

The cleanup process includes several safety checks:

- ✅ Verifies APM is properly installed (`.apm/` directory exists)
- ✅ Confirms installer is preserved in `.apm/.installer/`
- ✅ Checks VERSION file exists in `.apm/`
- ❌ Will NOT remove installer if any checks fail

## Common Scenarios

### Scenario 1: Normal Installation
```bash
./payload/install.sh
# Installer directory is automatically removed
```

### Scenario 2: Installation with --defaults
```bash
./payload/install.sh --defaults
# Installer directory is automatically removed
```

### Scenario 3: In-place Installation
```bash
cd apm-distribution/
./payload/install.sh
# Installer directory is removed via deferred cleanup
```

### Scenario 4: Manual Cleanup Required
```bash
# If installer folder remains after installation
./installer-cleanup.sh
```

## Troubleshooting

### Installer folder not removed automatically

1. Check if APM installation completed successfully:
   ```bash
   ls -la .apm/VERSION
   ```

2. Verify installer was preserved:
   ```bash
   ls -la .apm/.installer/
   ```

3. Run manual cleanup:
   ```bash
   ./installer-cleanup.sh
   ```

### Permission Issues

If you encounter permission issues during cleanup:
```bash
sudo rm -rf installer/
```

### Cleanup script not found

If `installer-cleanup.sh` is missing, you can safely remove the installer manually:
```bash
# Only if .apm/ exists and installation is complete
rm -rf installer/
```

## Technical Details

### Cleanup Implementation

The installer uses multiple cleanup strategies:

1. **Direct Removal**: When installer is run from outside the project
2. **Deferred Removal**: When installer is run from within the project (uses `nohup` and background process)
3. **Script Self-Deletion**: Cleanup scripts remove themselves after completion

### File Locations

- Installer preserved at: `.apm/.installer/`
- Deferred cleanup script: `.apm/.installer/deferred-cleanup.sh`
- Installer cleanup script: `.apm/.installer/cleanup-installer.sh`

### Safety Features

- Never removes installer without verification
- Preserves installer for future updates
- Logs all cleanup actions
- Non-destructive (only removes installer directory)

## Best Practices

1. Always let the installer complete its cleanup process
2. Check for leftover files after installation
3. Use `installer-cleanup.sh` if manual cleanup is needed
4. Report issues if automatic cleanup fails consistently

## Updates

The preserved installer in `.apm/.installer/` can be used for:
- Future APM updates
- Reinstallation if needed
- Reference for configuration options
- Troubleshooting installation issues