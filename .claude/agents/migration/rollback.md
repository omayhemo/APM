# APM to Sub-Agents Migration Rollback Procedures

## Overview

This document provides comprehensive rollback procedures to revert from Claude Code sub-agents back to the original APM framework if issues arise during or after migration.

**Migration Epic**: 16 - APM to Claude Code Sub-Agents Migration  
**Rollback Plan Version**: {{ROLLBACK_VERSION}}  
**Last Updated**: {{LAST_UPDATE_DATE}}

## Rollback Triggers

Initiate rollback if any of the following occur:

### Critical Issues
- [ ] **Agent Functionality Lost**: Any persona loses core capabilities
- [ ] **Voice System Failure**: TTS notifications completely broken  
- [ ] **Session Management Broken**: Notes not creating/archiving properly
- [ ] **Performance Degradation**: >50% slower response times
- [ ] **Data Loss**: Session notes or configuration corrupted

### User Experience Issues  
- [ ] **User Adoption Failure**: <30% user adoption after 2 weeks
- [ ] **Workflow Disruption**: Critical workflows broken or unavailable
- [ ] **Training Issues**: Users unable to adapt to new system
- [ ] **Support Overload**: >5 critical issues per day

### Technical Issues
- [ ] **Integration Failures**: Claude Code sub-agent system unstable
- [ ] **Context Window Problems**: Memory/context issues affecting functionality  
- [ ] **Parallel Execution Broken**: native sub-agent integration failures
- [ ] **Backward Compatibility Lost**: Legacy commands not working

## Rollback Phases

### Phase 1: Immediate Revert (< 1 Hour)

#### Step 1: Disable Sub-Agent System
```bash
# Stop sub-agent operations
cd /mnt/c/Code/agentic-persona-mapping
mv .claude/agents .claude/agents.backup.{{TIMESTAMP}}

# Restore original configuration  
cp .claude/settings.json.backup .claude/settings.json
```

#### Step 2: Restore APM Commands
```bash
# Verify APM framework integrity
ls -la .apm/agents/personas/
ls -la .apm/agents/voice/

# Test core APM functions
./test-apm-core.sh
```

#### Step 3: User Communication
```bash
# Send immediate notification
bash /mnt/c/Code/agentic-persona-mapping/.apm/agents/agents/voice/speakOrchestrator.sh "Emergency rollback initiated - APM framework restored"

# Update status
echo "ROLLBACK ACTIVE: $(date)" > .apm/status/rollback-active.flag
```

### Phase 2: Data Recovery (< 4 Hours)

#### Step 1: Session Notes Recovery
```bash
# Backup sub-agent session notes
mkdir -p .apm/migration-backup/session-notes/
cp -r .claude/agents/session-notes/* .apm/migration-backup/session-notes/ 2>/dev/null || true

# Restore APM session notes structure
mkdir -p .apm/session_notes/
# Note: Manual review required for data migration
```

#### Step 2: Configuration Recovery  
```bash
# Restore APM configuration
cp .apm/config/settings.backup.json .apm/config/settings.json

# Restore voice configuration
cp .claude/settings.json.pre-migration .claude/settings.json
```

#### Step 3: Validate APM Functionality
```bash
# Test each persona
./test-personas.sh
./test-voice-system.sh  
./test-parallel-execution.sh
```

### Phase 3: Full System Restoration (< 8 Hours)

#### Step 1: Clean Rollback
```bash
# Remove all sub-agent artifacts
rm -rf .claude/agents/
rm -rf .claude/migration/

# Restore original .claude directory state
cp -r .claude.pre-migration/* .claude/
```

#### Step 2: Verification Testing
```bash
# Comprehensive APM testing
./test-full-apm-suite.sh

# User acceptance testing
./test-user-workflows.sh
```

#### Step 3: Documentation Update
```bash
# Update rollback status
echo "ROLLBACK COMPLETE: $(date)" >> .apm/logs/rollback.log

# Generate rollback report
./generate-rollback-report.sh
```

## Data Preservation

### Critical Data Locations

#### APM Framework (Preserve Always)
- `.apm/agents/personas/` - Original persona definitions
- `.apm/agents/voice/` - Voice scripts  
- `.apm/session_notes/` - Original session notes
- `.apm/config/` - APM configuration
- `.claude/settings.json` - Claude configuration

#### Sub-Agent Data (Backup Before Rollback)
- `.claude/agents/personas/` - Migrated personas
- `.claude/agents/session-notes/` - Sub-agent session notes
- `.claude/agents/config/` - Sub-agent configuration
- `.claude/agents/migration/` - Migration tracking data

### Backup Strategy

#### Pre-Migration Backup (Required)
```bash
# Create comprehensive backup
mkdir -p .apm/migration-backup/pre-migration/
cp -r .apm/ .apm/migration-backup/pre-migration/apm/
cp -r .claude/ .apm/migration-backup/pre-migration/claude/
cp project_docs/backlog.md .apm/migration-backup/pre-migration/backlog.md.backup
```

#### During-Migration Snapshots
```bash
# Create snapshots at each phase
mkdir -p .apm/migration-backup/phase-{{PHASE_NUMBER}}/
# Snapshot command varies by phase
```

#### Post-Migration Backup
```bash  
# Backup successful migration state
mkdir -p .apm/migration-backup/post-migration/
# Full system backup after successful migration
```

## Rollback Testing

### Pre-Migration Validation
- [ ] Rollback procedures tested in development environment
- [ ] All backup locations verified and accessible  
- [ ] Restoration scripts tested and validated
- [ ] User communication plan prepared
- [ ] Support team trained on rollback procedures

### Rollback Dry Run
```bash
# Execute rollback simulation
./simulate-rollback.sh --dry-run

# Validate rollback without actual changes
./validate-rollback-readiness.sh
```

## Communication Plan

### Internal Team
- **Immediate**: Slack/Teams notification of rollback initiation
- **1 Hour**: Email with rollback status and timeline
- **4 Hours**: Detailed status report with recovery progress
- **Complete**: Full incident report with lessons learned

### Users  
- **Immediate**: Voice notification through APM system
- **15 Minutes**: Status page update
- **1 Hour**: Email notification with timeline
- **Complete**: Success notification and next steps

### Stakeholders
- **Immediate**: Executive briefing on rollback decision
- **2 Hours**: Detailed impact assessment
- **Daily**: Progress reports until resolution
- **Complete**: Post-incident review and recommendations

## Success Criteria

### Rollback Complete When:
- [ ] All APM personas functioning identically to pre-migration state
- [ ] Voice notifications working correctly
- [ ] Session management operational  
- [ ] User workflows fully restored
- [ ] No data loss or corruption
- [ ] Performance back to baseline
- [ ] User adoption of restored system >95%
- [ ] No critical issues for 48 hours post-rollback

## Lessons Learned Process

### Immediate (< 24 Hours)
- Document rollback trigger event
- Capture technical issues encountered
- Record user feedback and impact
- Identify process improvements

### Short Term (1 Week)
- Conduct post-incident review
- Update migration procedures
- Revise rollback procedures based on experience
- Plan corrective actions for future attempts

### Long Term (1 Month)  
- Analyze migration approach
- Update risk assessment
- Revise success criteria
- Plan enhanced migration strategy

## Support Contacts

### Technical Issues
- **Primary**: {{TECH_LEAD_CONTACT}}
- **Secondary**: {{ARCHITECT_CONTACT}}  
- **Escalation**: {{CTO_CONTACT}}

### User Issues
- **Primary**: {{SUPPORT_LEAD_CONTACT}}
- **Training**: {{TRAINING_CONTACT}}
- **Communication**: {{COMMS_CONTACT}}

### Business Issues
- **Primary**: {{PO_CONTACT}}
- **Escalation**: {{PM_CONTACT}}
- **Executive**: {{EXEC_SPONSOR_CONTACT}}

---

**CRITICAL REMINDER**: Always preserve APM framework integrity during migration. The rollback depends on having a fully functional APM system to return to.

**Emergency Rollback Command**: `./emergency-rollback.sh --immediate --preserve-data`