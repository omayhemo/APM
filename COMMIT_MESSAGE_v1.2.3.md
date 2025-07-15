Emergency release v1.2.3 - fix critical v1.2.2 packaging issues

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
- Real session analytics instead of "unknown, 0 seconds, None"
- Transcript parsing for meaningful hook logs

This emergency release fixes the packaging failures that made v1.2.2 
completely non-functional and ensures users get the enhanced logging 
features that were developed but never delivered.

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>