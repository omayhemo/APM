# Manual Update Instructions for AP Mapping

If your `ap-manager.sh update` is failing with backup creation errors, use one of these fix methods:

## Quick Fix (Recommended - Just patches the backup function)

```bash
curl -L https://raw.githubusercontent.com/omayhemo/APM/master/quick-fix-backup.sh | bash
```

## Full Update to v1.2.7 (If quick fix doesn't work)

```bash
curl -L https://raw.githubusercontent.com/omayhemo/APM/master/manual-update-to-1.2.7.sh | bash
```

## Manual Steps

1. Download the manual update script:
```bash
curl -L -o manual-update.sh https://raw.githubusercontent.com/omayhemo/agentic-persona-mapping/master/manual-update-to-1.2.7.sh
chmod +x manual-update.sh
```

2. Run from your project directory (where you have `.apm/` or `agents/` folder):
```bash
./manual-update.sh
```

## What This Fixes

- Backup creation failure in `ap-manager.sh update`
- Provides fallback backup method when tar fails
- Updates to v1.2.7 which contains the permanent fix
- Future updates will work normally after this fix

## Verification

After running the manual update, test that updates work:
```bash
# This should now work without errors
.apm/agents/scripts/ap-manager.sh version
```

## Troubleshooting

If the script fails:
1. Ensure you're in your project root directory
2. Check you have curl or wget installed
3. Verify internet connection to GitHub
4. Make sure you have write permissions in the project directory

The script creates backups before making any changes, so it's safe to run.