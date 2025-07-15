#!/bin/bash

echo "=== Git Release Commands for v1.2.3 ==="
echo ""

echo "Step 1: Add all changes"
echo "git add ."
echo ""

echo "Step 2: Commit with release message"
echo "git commit -m \"$(cat <<'EOF'
Release v1.2.3 - Emergency fix for v1.2.2 packaging failures

🚨 CRITICAL FIXES:
- Fixed distribution missing .apm/agents directory (v1.2.2 was non-functional)
- Fixed undefined context variable in subagent_stop.py hook
- Added comprehensive build validation to prevent future packaging failures
- Enhanced build script with error handling and verification

🔧 IMPROVEMENTS:
- Build now validates all critical components are included
- Enhanced error reporting and build verification
- Added package validation checks for core files
- Better build output with agent file counts

🎯 DELIVERS:
- Enhanced logging features that were promised in v1.2.2
- Functional distribution package with complete AP system
- Real session analytics instead of \"unknown, 0 seconds, None\"
- Transcript parsing for meaningful hook logs

This emergency release fixes the packaging failures that made v1.2.2
completely non-functional and ensures users get the enhanced logging
features that were developed but never delivered.

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)\""

echo ""
echo "Step 3: Create annotated tag"
echo "git tag -a \"v1.2.3\" -m \"Release version 1.2.3 - Emergency fix for v1.2.2\""
echo ""

echo "Step 4: Push to APM repository"
echo "git push apm master:main"
echo "git push apm v1.2.3"
echo ""

echo "Step 5: Create GitHub release (if gh CLI available)"
echo "gh release create v1.2.3 dist/apm-v1.2.3.tar.gz --title \"AP Mapping v1.2.3\" --notes-file RELEASE_NOTES.md --repo omayhemo/APM"
echo ""

echo "=== Manual execution required due to shell environment issues ==="