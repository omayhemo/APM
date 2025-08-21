# distribution-wiki

## Purpose
Coordinate parallel updates to the comprehensive APM wiki repository at `/mnt/c/Code/APMWiki/APM.wiki` with current, accurate information about the Coherence APM Framework installer project.

## Context
The APM wiki contains 7 major sections, command reference documentation, examples, and quick reference materials that need to be updated with accurate information about:
- Coherence APM Framework v4.2.0 (current version)
- 66+ actual commands (not 85+ claimed)
- 9 specialized personas (actual count)
- Real installation structure and capabilities
- Current TTS/voice integration features
- Actual workflow patterns and benefits

## Critical Requirements
- **Use actual project data**: Read VERSION file, command count, real capabilities
- **No aspirational content**: Replace projected metrics with actual features
- **Maintain structure**: Preserve existing wiki organization while updating content
- **Coordinate parallel updates**: Use Task tool to coordinate multiple agents across sections
- **Verify accuracy**: Cross-reference all information with actual codebase

## Implementation

### Phase 1: Project Analysis & Planning
Launch 5 parallel analysis tasks to gather current project state:

1. **Project State Agent**: Analyze current version, installation structure, actual capabilities
2. **Command Analysis Agent**: Catalog actual commands in `.claude/commands/` directory (should be 66+)
3. **Persona Analysis Agent**: Document real persona capabilities from `.apm/agents/personas/`
4. **Feature Analysis Agent**: Document actual TTS, voice integration, session management features
5. **Structure Analysis Agent**: Analyze current wiki structure and identify update requirements

### Phase 2: Parallel Wiki Updates
Launch 7 parallel update agents for major wiki sections:

1. **Getting Started Agent**: Update `/mnt/c/Code/APMWiki/APM.wiki/01-getting-started/` section
   - Fix version information (4.2.0)
   - Correct persona count (9, not 10+)
   - Update installation verification steps
   - Remove aspirational performance claims
   - Update quick start guide with actual workflow

2. **Personas Agent**: Update `/mnt/c/Code/APMWiki/APM.wiki/02-personas/` section
   - Document 9 actual personas with real capabilities
   - Update voice integration details
   - Correct command syntax requirements
   - Add actual persona-specific commands

3. **Workflows Agent**: Update `/mnt/c/Code/APMWiki/APM.wiki/03-workflows/` section
   - Document actual workflow patterns
   - Update handoff procedures
   - Correct session management details
   - Remove hypothetical performance metrics

4. **Configuration Agent**: Update `/mnt/c/Code/APMWiki/APM.wiki/04-configuration/` section
   - Update installation structure (.apm/, .claude/)
   - Document actual TTS providers and setup
   - Correct environment variables
   - Update path configurations

5. **Command Reference Agent**: Update `/mnt/c/Code/APMWiki/APM.wiki/command-reference/` section
   - Correct command count to 66+ (not 85+)
   - Update version to 4.2.0 (not 4.0.0)
   - Document actual command categories
   - Remove aspirational AI/ML features
   - Update quick reference with real commands

6. **Advanced Features Agent**: Update `/mnt/c/Code/APMWiki/APM.wiki/05-advanced/` section
   - Document actual advanced features available
   - Remove non-existent features
   - Update performance optimization with real techniques
   - Correct enterprise deployment information

7. **Troubleshooting Agent**: Update `/mnt/c/Code/APMWiki/APM.wiki/06-troubleshooting/` section
   - Update for v4.2.0 troubleshooting
   - Correct installation issue solutions
   - Update command troubleshooting
   - Fix performance issue guidance

### Phase 3: Reference & Examples Update
Launch 3 parallel agents for supporting content:

1. **Reference Agent**: Update `/mnt/c/Code/APMWiki/APM.wiki/07-reference/` section
   - Update version history to include 4.2.0
   - Correct file structure documentation
   - Update architecture diagrams if needed
   - Verify glossary accuracy

2. **Examples Agent**: Update `/mnt/c/Code/APMWiki/APM.wiki/examples/` section
   - Update examples to use actual commands and syntax
   - Ensure examples work with current version
   - Remove examples that reference non-existent features

3. **Quick Reference Agent**: Update `/mnt/c/Code/APMWiki/APM.wiki/quick-reference/` section
   - Update command cheatsheet with actual 66+ commands
   - Correct persona cheatsheet with 9 real personas
   - Update workflow cheatsheet with actual patterns

### Phase 4: Validation & Home Page
1. **Validation Agent**: Cross-check all updates for consistency and accuracy
2. **Home Page Agent**: Update main Home.md with corrected overview and navigation

## Expected Outcomes
- **Accurate Documentation**: All wiki content reflects actual v4.2.0 capabilities
- **Corrected Metrics**: Real command count (66+), persona count (9), version (4.2.0)
- **Updated Installation**: Current installation paths and structure
- **Realistic Expectations**: Actual features without aspirational claims
- **Consistent Navigation**: All internal links and references work correctly

## Success Criteria
✅ Version information updated to 4.2.0 throughout  
✅ Command count corrected to 66+ (not 85+)  
✅ Persona count corrected to 9 (not 10+)  
✅ Installation paths match actual structure  
✅ TTS/voice integration documented accurately  
✅ Workflow patterns reflect actual capabilities  
✅ No aspirational or hypothetical features listed  
✅ All template variables filled with actual values  
✅ Internal navigation links work correctly  
✅ Examples use actual command syntax  

## Voice Notification
After completion, announce: "Distribution wiki update completed. All sections now reflect accurate Coherence APM Framework v4.2.0 information."

## Usage
```bash
/distribution-wiki
```

This command will coordinate a comprehensive, parallel update of the entire APM wiki with accurate, current information about the Coherence APM Framework installer project.