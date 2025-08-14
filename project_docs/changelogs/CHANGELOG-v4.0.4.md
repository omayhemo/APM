# Changelog v4.0.4

## Release Date: 2025-08-14

## Type: Patch Release - Critical Installation Fixes

## Summary
This patch release fixes critical issues with the APM Framework installer that were preventing proper installation via curl and with the --defaults flag.

## Fixed Issues

### Installation Process
- **Fixed tar extraction structure**: Distribution now extracts directly to current directory without creating version-named subfolder
- **Fixed APM/install.sh**: Updated to handle new tar structure without looking for apm-* subdirectory
- **Fixed "cho: command not found" error**: Removed malformed empty echo statement that was causing errors during curl | bash installation
- **Fixed --defaults flag**: Improved argument parsing to properly detect and handle --defaults flag anywhere in argument list
- **Fixed TTY detection**: Enhanced TTY detection for better handling of piped installations

### Code Quality
- **Added proper newlines**: Ensured all script files end with proper newline characters
- **Cleaned up echo statements**: Removed empty echo statements with only color codes

## Technical Details

### Modified Files
- `APM/install.sh` - Updated tar extraction logic (lines 61-65)
- `build-distribution.sh` - Fixed tar creation to not include version directory wrapper (lines 118-120)
- `installer/install.sh` - Multiple fixes:
  - Improved --defaults argument parsing (lines 18-34)
  - Fixed empty echo statement (line 2576)
  - Added proper file termination

### Installation Methods
All installation methods now work correctly:
- `curl -fsSL https://raw.githubusercontent.com/omayhemo/APM/master/install.sh | bash`
- `curl -fsSL https://raw.githubusercontent.com/omayhemo/APM/master/install.sh | bash -s -- --defaults`
- Direct execution: `./installer/install.sh --defaults`

## Upgrade Instructions
For existing installations, simply run the installer with the new version. The installer will handle the upgrade process automatically.

## Testing
- Tested curl | bash installation
- Tested direct installation with --defaults flag
- Verified tar extraction structure
- Confirmed no "cho: command not found" errors

## Contributors
- Installation fixes and testing

## Notes
This is a critical patch release that addresses installation issues reported by users. All users experiencing installation problems should upgrade to this version.