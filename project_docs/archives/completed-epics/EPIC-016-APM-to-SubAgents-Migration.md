# EPIC-016: APM to Claude Code Sub-Agents Migration

**Epic Owner**: Product Owner  
**Status**: Approved  
**Priority**: High  
**Target Sprint**: 14-17  
**Total Story Points**: 89  

## Business Objective

Transform the APM framework from command-based personas to native Claude Code sub-agents while preserving all existing functionality, improving performance, and addressing user experience issues (particularly TTS configuration).

## Business Value

- **Native Integration**: Leverage Claude Code's built-in sub-agent system for better performance
- **Improved Context**: Each agent gets dedicated context window (no shared memory limits)
- **Automatic Routing**: Context-aware agent selection reduces user cognitive load
- **Simplified Maintenance**: Standard `.claude/agents/` structure aligns with Claude Code conventions
- **Enhanced Reliability**: Native implementation reduces command parsing errors
- **TTS Fix**: More robust configuration prevents accidental disabling

## Success Criteria

- ✅ All 8 core personas migrated with identical capabilities
- ✅ No behavioral changes in any persona 
- ✅ All parallel features functional
- ✅ Voice notifications working reliably
- ✅ Session management preserved
- ✅ Backward compatibility maintained (dual-mode operation)
- ✅ Zero feature regression
- ✅ TTS configuration more robust and user-friendly

## Technical Approach

1. **Phased Migration**: 4-week implementation across 4 phases
2. **Preservation Strategy**: Direct content migration preserving all behaviors
3. **Dual-Mode Operation**: Both `/ap` commands and sub-agent mentions work
4. **Incremental Rollout**: Core agents first, then specialized agents
5. **Continuous Validation**: Test each phase before proceeding

## Dependencies

- Claude Code v1.0+ with sub-agent support
- Existing APM framework (v3.1.0.rc.1)
- Voice notification scripts
- Session management system

## Risks & Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| User adoption resistance | Medium | Dual-mode operation allows gradual transition |
| Feature regression | High | Comprehensive testing at each phase |
| Context window limitations | Medium | Dedicated windows per agent improve capacity |
| Voice script compatibility | Low | Preserve existing scripts unchanged |

## User Stories

### Phase 1: Foundation (21 points)
- **Story 15.1**: Create `.claude/agents/` directory structure and base configuration (3 points)
- **Story 15.2**: Migrate Developer agent with full capabilities preservation (5 points)
- **Story 15.3**: Migrate Architect agent with decision patterns intact (5 points)
- **Story 15.4**: Migrate QA agent with AI/ML framework (5 points)
- **Story 15.5**: Implement Orchestrator as primary coordinator (3 points)

### Phase 2: Enhancement (34 points)
- **Story 15.6**: Migrate PM agent with investigative capabilities (5 points)
- **Story 15.7**: Migrate PO agent as backlog guardian (5 points)
- **Story 15.8**: Migrate SM agent with parallel sprint features (5 points)
- **Story 15.9**: Migrate Analyst agent with brainstorming focus (5 points)
- **Story 15.10**: Migrate Design Architect with UI/UX expertise (5 points)
- **Story 15.11**: Port parallel execution capabilities (5 points)
- **Story 15.12**: Integrate voice notification system (4 points)

### Phase 3: Advanced Features (21 points)
- **Story 15.13**: Preserve AI/ML QA capabilities (8 points)
- **Story 15.14**: Implement parallel sprint coordination (8 points)
- **Story 15.15**: Create agent chaining workflows (5 points)

### Phase 4: Transition (13 points)
- **Story 15.16**: Implement dual-mode operation (5 points)
- **Story 15.17**: Create user migration guide (3 points)
- **Story 15.18**: Update all documentation (5 points)

## Definition of Done

- [ ] All sub-agents created in `.claude/agents/`
- [ ] All personas preserve exact behaviors
- [ ] Parallel capabilities functional
- [ ] Voice notifications reliable
- [ ] Session management working
- [ ] Backward compatibility verified
- [ ] Documentation updated
- [ ] User guide created
- [ ] TTS configuration robust
- [ ] All tests passing

## Stakeholder Communication

- Daily updates during migration
- Phase completion demos
- User training sessions for new invocation methods
- Feedback collection after each phase

## Post-Epic Considerations

- Monitor adoption metrics
- Collect user feedback on dual-mode usage
- Plan sunset date for legacy commands
- Consider additional sub-agent enhancements