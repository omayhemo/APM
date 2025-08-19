# APM Framework - Path Reference Catalog
Generated on: Wed Aug  6 12:50:26 CDT 2025

## 1. INSTALLER SCRIPT
## installer/install.sh
- **Type**: Main installer script
- **Total references**: 680
- **Template variables**: 39
- **Shell variables**: 627
- **Hardcoded paths**: 7
- **Relative paths**: 7
- **Template variables found**:
        1 {{APM_ROOT}}
        1 {{AP_CHECKLISTS}}
        1 {{AP_CONFIG_FILE}}
        1 {{AP_DATA}}
        1 {{AP_DOCS}}
        1 {{AP_KB_FILE}}
        1 {{AP_MONITORING}}
        1 {{AP_PERSONAS}}
        1 {{AP_PYTHON}}
        1 {{AP_ROOT}}

## 2. MAIN TEMPLATES
## installer/templates/CLAUDE.md.markdown.template
- **Type**: Main configuration template
- **Total references**: 26
- **Template variables**: 26
- **Shell variables**: 0
- **Hardcoded paths**: 0
- **Relative paths**: 0
- **Template variables found**:
        2 {{APM_ROOT}}
       10 {{AP_ROOT}}
        1 {{ARCHIVE_PATH}}
        1 {{BACKLOG_PATH}}
        2 {{PROJECT_ROOT}}
        3 {{RULES_PATH}}
        4 {{SESSION_NOTES_PATH}}
        3 {{WORKSPACE_ROOT}}

## installer/templates/README.md.template
- **Type**: Main configuration template
- **Total references**: 13
- **Template variables**: 3
- **Shell variables**: 10
- **Hardcoded paths**: 0
- **Relative paths**: 0
- **Template variables found**:
        1 {{AP_VOICE}}
        2 {{PROJECT_ROOT}}

## installer/templates/ide-ap-orchestrator.cfg.md.template
- **Type**: Main configuration template
- **Total references**: 27
- **Template variables**: 27
- **Shell variables**: 0
- **Hardcoded paths**: 0
- **Relative paths**: 0
- **Template variables found**:
        1 {{AP_CHECKLISTS}}
        1 {{AP_DATA}}
        1 {{AP_PERSONAS}}
        1 {{AP_ROOT}}
       22 {{AP_TASKS}}
        1 {{AP_TEMPLATES}}

## installer/templates/ide-ap-orchestrator.md.template
- **Type**: Main configuration template
- **Total references**: 2
- **Template variables**: 2
- **Shell variables**: 0
- **Hardcoded paths**: 0
- **Relative paths**: 0
- **Template variables found**:
        1 {{AP_CONFIG_FILE}}
        1 {{AP_KB_FILE}}

## 3. CLAUDE COMMAND TEMPLATES
## installer/templates/claude/commands/analyst.md.template
- **Type**: Claude command template
- **Total references**: 16
- **Template variables**: 16
- **Shell variables**: 0
- **Hardcoded paths**: 0
- **Relative paths**: 0
- **Template variables found**:
        4 {{AP_ROOT}}
       11 {{PROJECT_ROOT}}
        1 {{SPEAK_ANALYST}}

## installer/templates/claude/commands/ap_orchestrator.md.template
- **Type**: Claude command template
- **Total references**: 23
- **Template variables**: 23
- **Shell variables**: 0
- **Hardcoded paths**: 0
- **Relative paths**: 0
- **Template variables found**:
        4 {{AP_ROOT}}
       12 {{PROJECT_ROOT}}
        1 {{RULES_PATH}}
        2 {{SESSION_NOTES_PATH}}
        4 {{SPEAK_ORCHESTRATOR}}

## installer/templates/claude/commands/architect.md.template
- **Type**: Claude command template
- **Total references**: 16
- **Template variables**: 16
- **Shell variables**: 0
- **Hardcoded paths**: 0
- **Relative paths**: 0
- **Template variables found**:
        3 {{AP_ROOT}}
       12 {{PROJECT_ROOT}}
        1 {{SPEAK_ARCHITECT}}

## installer/templates/claude/commands/design-architect.md.template
- **Type**: Claude command template
- **Total references**: 16
- **Template variables**: 16
- **Shell variables**: 0
- **Hardcoded paths**: 0
- **Relative paths**: 0
- **Template variables found**:
        3 {{AP_ROOT}}
       12 {{PROJECT_ROOT}}
        1 {{SPEAK_DESIGN_ARCHITECT}}

## installer/templates/claude/commands/dev.md.template
- **Type**: Claude command template
- **Total references**: 16
- **Template variables**: 16
- **Shell variables**: 0
- **Hardcoded paths**: 0
- **Relative paths**: 0
- **Template variables found**:
        2 {{AP_ROOT}}
       13 {{PROJECT_ROOT}}
        1 {{SPEAK_DEVELOPER}}

## installer/templates/claude/commands/developer.md.template
- **Type**: Claude command template
- **Total references**: 16
- **Template variables**: 16
- **Shell variables**: 0
- **Hardcoded paths**: 0
- **Relative paths**: 0
- **Template variables found**:
        2 {{AP_ROOT}}
       13 {{PROJECT_ROOT}}
        1 {{SPEAK_DEVELOPER}}

## 4. VOICE SCRIPTS
## installer/templates/voice/speakAnalyst.sh
- **Type**: Voice script
- **Total references**: 2
- **Template variables**: 0
- **Shell variables**: 2
- **Hardcoded paths**: 0
- **Relative paths**: 0

## installer/templates/voice/speakArchitect.sh
- **Type**: Voice script
- **Total references**: 2
- **Template variables**: 0
- **Shell variables**: 2
- **Hardcoded paths**: 0
- **Relative paths**: 0

## installer/templates/voice/speakBase.sh
- **Type**: Voice script
- **Total references**: 7
- **Template variables**: 0
- **Shell variables**: 7
- **Hardcoded paths**: 0
- **Relative paths**: 0

## installer/templates/voice/speakDesignArchitect.sh
- **Type**: Voice script
- **Total references**: 2
- **Template variables**: 0
- **Shell variables**: 2
- **Hardcoded paths**: 0
- **Relative paths**: 0

## installer/templates/voice/speakDeveloper.sh
- **Type**: Voice script
- **Total references**: 2
- **Template variables**: 0
- **Shell variables**: 2
- **Hardcoded paths**: 0
- **Relative paths**: 0

## installer/templates/voice/speakOrchestrator.sh
- **Type**: Voice script
- **Total references**: 2
- **Template variables**: 0
- **Shell variables**: 2
- **Hardcoded paths**: 0
- **Relative paths**: 0

## installer/templates/voice/speakPm.sh
- **Type**: Voice script
- **Total references**: 2
- **Template variables**: 0
- **Shell variables**: 2
- **Hardcoded paths**: 0
- **Relative paths**: 0

## installer/templates/voice/speakPo.sh
- **Type**: Voice script
- **Total references**: 2
- **Template variables**: 0
- **Shell variables**: 2
- **Hardcoded paths**: 0
- **Relative paths**: 0

## installer/templates/voice/speakQa.sh
- **Type**: Voice script
- **Total references**: 2
- **Template variables**: 0
- **Shell variables**: 2
- **Hardcoded paths**: 0
- **Relative paths**: 0

## installer/templates/voice/speakSm.sh
- **Type**: Voice script
- **Total references**: 2
- **Template variables**: 0
- **Shell variables**: 2
- **Hardcoded paths**: 0
- **Relative paths**: 0

## 5. UTILITY SCRIPTS
## installer/templates/scripts/ap-manager.sh
- **Type**: Utility script
- **Total references**: 98
- **Template variables**: 0
- **Shell variables**: 96
- **Hardcoded paths**: 0
- **Relative paths**: 2

## installer/templates/scripts/claude-ap.sh
- **Type**: Utility script
- **Total references**: 1
- **Template variables**: 0
- **Shell variables**: 0
- **Hardcoded paths**: 1
- **Relative paths**: 0

## installer/templates/scripts/configure-tts.sh
- **Type**: Utility script
- **Total references**: 31
- **Template variables**: 0
- **Shell variables**: 31
- **Hardcoded paths**: 0
- **Relative paths**: 0

## installer/templates/scripts/notification-manager.sh
- **Type**: Utility script
- **Total references**: 26
- **Template variables**: 0
- **Shell variables**: 25
- **Hardcoded paths**: 1
- **Relative paths**: 0

## installer/templates/scripts/parallel-test-orchestrator.sh
- **Type**: Utility script
- **Total references**: 23
- **Template variables**: 0
- **Shell variables**: 18
- **Hardcoded paths**: 5
- **Relative paths**: 0

## installer/templates/scripts/parallel-test-wrapper.sh
- **Type**: Utility script
- **Total references**: 53
- **Template variables**: 0
- **Shell variables**: 52
- **Hardcoded paths**: 1
- **Relative paths**: 0

## installer/templates/scripts/setup-claude-ap-alias.sh
- **Type**: Utility script
- **Total references**: 5
- **Template variables**: 0
- **Shell variables**: 0
- **Hardcoded paths**: 1
- **Relative paths**: 4

## installer/templates/scripts/test-tts-installation.sh
- **Type**: Utility script
- **Total references**: 53
- **Template variables**: 0
- **Shell variables**: 53
- **Hardcoded paths**: 0
- **Relative paths**: 0

## installer/templates/scripts/tts-manager-debug.sh
- **Type**: Utility script
- **Total references**: 61
- **Template variables**: 0
- **Shell variables**: 60
- **Hardcoded paths**: 1
- **Relative paths**: 0

## installer/templates/scripts/tts-manager.sh
- **Type**: Utility script
- **Total references**: 24
- **Template variables**: 0
- **Shell variables**: 24
- **Hardcoded paths**: 0
- **Relative paths**: 0

## 6. PERSONA TEMPLATES
## installer/templates/agents/personas/MIGRATION-PATTERNS-ANALYSIS.md.template
- **Type**: Agent persona template
- **Total references**: 6
- **Template variables**: 6
- **Shell variables**: 0
- **Hardcoded paths**: 0
- **Relative paths**: 0
- **Template variables found**:
        5 {{CONTEXT}}
        1 {{FILES}}

## installer/templates/agents/personas/PERSONA-UPDATE-TEMPLATE.md.template
- **Type**: Agent persona template
- **Total references**: 6
- **Template variables**: 4
- **Shell variables**: 2
- **Hardcoded paths**: 0
- **Relative paths**: 0
- **Template variables found**:
        1 {{AP_PERSONAS}}
        1 {{AP_ROOT}}
        1 {{PROJECT_ROOT}}
        1 {{SESSION_NOTES_PATH}}

## installer/templates/agents/personas/STORY-17.10-IMPLEMENTATION-GUIDE.md.template
- **Type**: Agent persona template
- **Total references**: 1
- **Template variables**: 1
- **Shell variables**: 0
- **Hardcoded paths**: 0
- **Relative paths**: 0
- **Template variables found**:
        1 {{CONTEXT}}

## installer/templates/agents/personas/analyst.md.template
- **Type**: Agent persona template
- **Total references**: 24
- **Template variables**: 20
- **Shell variables**: 3
- **Hardcoded paths**: 0
- **Relative paths**: 1
- **Template variables found**:
        1 {{AP_PERSONAS}}
        3 {{AP_ROOT}}
       11 {{PROJECT_ROOT}}
        1 {{RULES_PATH}}
        3 {{SESSION_NOTES_PATH}}
        1 {{SPEAK_ANALYST}}

## installer/templates/agents/personas/architect.md.template
- **Type**: Agent persona template
- **Total references**: 25
- **Template variables**: 21
- **Shell variables**: 3
- **Hardcoded paths**: 0
- **Relative paths**: 1
- **Template variables found**:
        1 {{AP_PERSONAS}}
        3 {{AP_ROOT}}
       12 {{PROJECT_ROOT}}
        1 {{RULES_PATH}}
        3 {{SESSION_NOTES_PATH}}
        1 {{SPEAK_ARCHITECT}}

## installer/templates/agents/personas/communication_standards.md.template
- **Type**: Agent persona template
- **Total references**: 2
- **Template variables**: 2
- **Shell variables**: 0
- **Hardcoded paths**: 0
- **Relative paths**: 0
- **Template variables found**:
        1 {{phase_number}}
        1 {{report_title}}

## installer/templates/agents/personas/design-architect.md.template
- **Type**: Agent persona template
- **Total references**: 25
- **Template variables**: 21
- **Shell variables**: 3
- **Hardcoded paths**: 0
- **Relative paths**: 1
- **Template variables found**:
        1 {{AP_PERSONAS}}
        4 {{AP_ROOT}}
       11 {{PROJECT_ROOT}}
        1 {{RULES_PATH}}
        3 {{SESSION_NOTES_PATH}}
        1 {{SPEAK_DESIGN_ARCHITECT}}

## installer/templates/agents/personas/dev.md.template
- **Type**: Agent persona template
- **Total references**: 34
- **Template variables**: 29
- **Shell variables**: 4
- **Hardcoded paths**: 0
- **Relative paths**: 1
- **Template variables found**:
        1 {{AP_CHECKLISTS}}
        1 {{AP_PERSONAS}}
        3 {{AP_ROOT}}
       17 {{PROJECT_ROOT}}
        1 {{RULES_PATH}}
        3 {{SESSION_NOTES_PATH}}
        1 {{SPEAK_DEVELOPER}}
        2 {{VERSION}}

## 7. OTHER FILES
## installer/debug-utilities.sh
- **Type**: Other installer file
- **Total references**: 37
- **Template variables**: 0
- **Shell variables**: 36
- **Hardcoded paths**: 0
- **Relative paths**: 1

## installer/documentation-generator.sh
- **Type**: Other installer file
- **Total references**: 94
- **Template variables**: 19
- **Shell variables**: 57
- **Hardcoded paths**: 0
- **Relative paths**: 18
- **Template variables found**:
        1 {{COMMANDS_SECTION}}
        1 {{COMMON_ISSUES}}
        1 {{CONFIGURATION_SECTION}}
        1 {{CONFIG_EXAMPLES}}
        1 {{DOC_VERSION}}
        1 {{ENV_VARS_SECTION}}
        1 {{ERROR_REFERENCE}}
        3 {{GENERATION_DATE}}
        1 {{INSTALLATION_DATE}}
        1 {{INSTALLER_VERSION}}

## installer/error-handler.sh
- **Type**: Other installer file
- **Total references**: 49
- **Template variables**: 0
- **Shell variables**: 47
- **Hardcoded paths**: 2
- **Relative paths**: 0

## installer/install.sh
- **Type**: Other installer file
- **Total references**: 680
- **Template variables**: 39
- **Shell variables**: 627
- **Hardcoded paths**: 7
- **Relative paths**: 7
- **Template variables found**:
        1 {{APM_ROOT}}
        1 {{AP_CHECKLISTS}}
        1 {{AP_CONFIG_FILE}}
        1 {{AP_DATA}}
        1 {{AP_DOCS}}
        1 {{AP_KB_FILE}}
        1 {{AP_MONITORING}}
        1 {{AP_PERSONAS}}
        1 {{AP_PYTHON}}
        1 {{AP_ROOT}}

## installer/integrity-checker.sh
- **Type**: Other installer file
- **Total references**: 88
- **Template variables**: 0
- **Shell variables**: 82
- **Hardcoded paths**: 0
- **Relative paths**: 6

## installer/logging-framework.sh
- **Type**: Other installer file
- **Total references**: 52
- **Template variables**: 0
- **Shell variables**: 51
- **Hardcoded paths**: 0
- **Relative paths**: 1

## installer/manifest-generator.sh
- **Type**: Other installer file
- **Total references**: 47
- **Template variables**: 0
- **Shell variables**: 46
- **Hardcoded paths**: 1
- **Relative paths**: 0

## installer/profile-manager.sh
- **Type**: Other installer file
- **Total references**: 52
- **Template variables**: 0
- **Shell variables**: 52
- **Hardcoded paths**: 0
- **Relative paths**: 0

## installer/recovery-system.sh
- **Type**: Other installer file
- **Total references**: 62
- **Template variables**: 0
- **Shell variables**: 61
- **Hardcoded paths**: 1
- **Relative paths**: 0

## installer/report-generator.sh
- **Type**: Other installer file
- **Total references**: 16
- **Template variables**: 0
- **Shell variables**: 15
- **Hardcoded paths**: 0
- **Relative paths**: 1

## installer/rollback.sh
- **Type**: Other installer file
- **Total references**: 65
- **Template variables**: 0
- **Shell variables**: 65
- **Hardcoded paths**: 0
- **Relative paths**: 0

## installer/template-processor-bash.sh
- **Type**: Other installer file
- **Total references**: 13
- **Template variables**: 4
- **Shell variables**: 9
- **Hardcoded paths**: 0
- **Relative paths**: 0
- **Template variables found**:
        1 {{$var}}
        1 {{${var}}
        2 {{VAR}}

## installer/test-installer-integration-complete.sh
- **Type**: Other installer file
- **Total references**: 47
- **Template variables**: 0
- **Shell variables**: 45
- **Hardcoded paths**: 2
- **Relative paths**: 0

## installer/test-merge-integration.sh
- **Type**: Other installer file
- **Total references**: 38
- **Template variables**: 0
- **Shell variables**: 36
- **Hardcoded paths**: 2
- **Relative paths**: 0

## installer/test-notification-execution.sh
- **Type**: Other installer file
- **Total references**: 17
- **Template variables**: 0
- **Shell variables**: 14
- **Hardcoded paths**: 2
- **Relative paths**: 1

## installer/test-notification-system.sh
- **Type**: Other installer file
- **Total references**: 13
- **Template variables**: 0
- **Shell variables**: 13
- **Hardcoded paths**: 0
- **Relative paths**: 0

## installer/test-tts-system.sh
- **Type**: Other installer file
- **Total references**: 26
- **Template variables**: 0
- **Shell variables**: 25
- **Hardcoded paths**: 1
- **Relative paths**: 0

## installer/ui-utilities.sh
- **Type**: Other installer file
- **Total references**: 52
- **Template variables**: 0
- **Shell variables**: 47
- **Hardcoded paths**: 4
- **Relative paths**: 1

## installer/variable-manager-v2.sh
- **Type**: Other installer file
- **Total references**: 44
- **Template variables**: 0
- **Shell variables**: 43
- **Hardcoded paths**: 1
- **Relative paths**: 0

