# Story 16.12: Integrate Voice Notification System

**Epic**: EPIC-016 (APM to Sub-Agents Migration)  
**Status**: Approved  
**Priority**: Medium  
**Story Points**: 4  
**Sprint**: 15  

## Story Statement

As a user,  
I want voice notifications to work seamlessly with sub-agents,  
so that I maintain the audio feedback experience with improved reliability.

## Acceptance Criteria

1. [ ] All sub-agents properly configured with voice scripts
2. [ ] Voice notification reliability improved over APM system
3. [ ] TTS configuration more robust and user-friendly
4. [ ] Voice script paths correctly configured for each agent
5. [ ] Error handling for missing/broken voice scripts implemented
6. [ ] Voice notification preferences configurable per agent
7. [ ] Backward compatibility with existing voice scripts maintained

## Tasks/Subtasks

- [ ] Audit current voice notification system
  - [ ] Document all existing voice scripts and their usage
  - [ ] Identify reliability issues in current APM system
  - [ ] Map voice script paths for each agent
  
- [ ] Configure sub-agents with voice capabilities
  - [ ] Link each sub-agent to appropriate voice script
  - [ ] Implement error handling for missing scripts
  - [ ] Create fallback mechanisms for voice failures
  
- [ ] Improve TTS configuration management
  - [ ] Make TTS setup more user-friendly
  - [ ] Add configuration validation
  - [ ] Improve error messages and troubleshooting
  
- [ ] Test and validate voice integration
  - [ ] Verify voice notifications work for all sub-agents
  - [ ] Test error handling and fallback mechanisms
  - [ ] Validate improved reliability over APM system
  - [ ] Confirm user configuration options functional

## Dev Technical Guidance

```yaml
# Voice Script Configuration:
# Each sub-agent should reference appropriate voice script
voice_script: "/mnt/c/Code/agentic-persona-mapping/.apm/agents/voice/speak{Agent}.sh"

# Existing voice scripts to preserve:
- speakOrchestrator.sh
- speakDeveloper.sh
- speakArchitect.sh
- speakAnalyst.sh
- speakQa.sh
- speakPm.sh
- speakPo.sh
- speakSm.sh
- speakDesignArchitect.sh

# Error handling patterns:
- Check script existence before execution
- Provide meaningful error messages
- Fallback to text-only output if voice fails
```

## Story Progress Notes

**Agent Model Used**: Claude  
**Start Date**: TBD  
**Completion Date**: TBD  

### Completion Notes List:
- Voice notifications integrated with all sub-agents
- Reliability improvements implemented
- User configuration enhanced
- Error handling robust

### Change Log

| Change | Date-Time | Version | Description | Author |
|--------|-----------|---------|-------------|---------|
| Created | 2025-07-25 | 1.0 | Initial story creation | PO |