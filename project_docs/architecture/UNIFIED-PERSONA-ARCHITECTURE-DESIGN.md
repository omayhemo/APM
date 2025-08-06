# Unified Persona/Subagent Architecture Design

## Executive Summary

This document presents a unified architecture for maintaining personas/subagents that eliminates duplication, serves both APM and Claude Code deployment targets, and simplifies maintenance to a single edit point while preserving all advanced features.

## Current State Analysis

### Duplication Patterns Identified

1. **Three Persona Storage Locations**:
   - `/installer/templates/agents/personas/` - APM installer templates
   - `/installer/templates/claude/agents/personas/` - Claude installer templates  
   - Deployed instances: `/.apm/agents/personas/` and `/.claude/agents/personas/`

2. **Template Variable Systems**:
   - APM uses: `{{PROJECT_ROOT}}`, `{{AP_ROOT}}`, `{{SESSION_NOTES_PATH}}`, etc.
   - Claude uses: Same variables but different deployment contexts
   - 30+ template variables requiring substitution

3. **Build-time Processing**:
   - `install.sh` contains `replace_variables()` function with 50+ sed commands
   - Template processing happens at installation time
   - Each persona template processed separately

### Key Requirements Differences

**APM Requirements**:
- Full voice notification system integration
- Session note management with APM paths
- Workspace boundary enforcement
- APM-specific initialization sequences
- Communication standards integration

**Claude Code Requirements**:
- Native sub-agent coordination patterns
- Template metadata for versioning
- Enterprise feature documentation
- Migration pathway compatibility
- Progressive enhancement support

## Unified Architecture Design

### 1. Single Source of Truth: Master Personas

```
/installer/personas/
├── _master/                     # Master persona definitions
│   ├── analyst.persona.yaml     # Structured persona definition
│   ├── architect.persona.yaml
│   ├── developer.persona.yaml
│   ├── pm.persona.yaml
│   ├── qa.persona.yaml
│   └── ...
├── _shared/                     # Shared components
│   ├── communication-standards.md
│   ├── workspace-boundaries.md
│   ├── initialization-patterns.md
│   └── voice-integration.md
└── _templates/                  # Output templates
    ├── apm.persona.template     # APM deployment template
    └── claude.persona.template  # Claude deployment template
```

### 2. Structured Persona Definition (YAML)

```yaml
# analyst.persona.yaml
persona:
  name: "Analyst"
  role: "Business Analysis & Requirements Discovery Expert"
  version: "3.3.0"
  
metadata:
  agent_type: "Business Analyst & Requirements Discovery Expert"
  apm_compatibility: "2.4+"
  enterprise_features:
    - "Parallel Requirements Analysis"
    - "Stakeholder Management"
    - "Business Process Mapping"
  backward_compatibility: "Full /analyst command support"
  
voice:
  script_var: "SPEAK_ANALYST"
  activation_message: "Analyst agent activated"
  
workspace:
  primary_dirs:
    - "{{PROJECT_ROOT}}/project_docs/requirements/"
    - "{{PROJECT_ROOT}}/project_docs/research/"
  forbidden_paths:
    - ".apm/"
    - "agents/"
    - ".claude/"
  
initialization:
  apm_sequence:
    - list_session_notes
    - read_latest_session
    - list_rules
    - create_session_note
    - voice_activation
  claude_sequence:
    - load_context
    - initialize_subagent_coordination
    - setup_progress_tracking
    
content:
  sections:
    - research_protocols
    - workspace_boundaries
    - initialization_sequence
    - core_responsibilities
    - parallel_commands
    - communication_standards
```

### 3. Template Processing Engine

```bash
# generate-personas.sh
#!/bin/bash

PERSONA_GENERATOR_VERSION="1.0.0"
MASTER_DIR="installer/personas/_master"
TEMPLATES_DIR="installer/personas/_templates"
OUTPUT_APM="installer/templates/agents/personas"
OUTPUT_CLAUDE="installer/templates/claude/agents/personas"

generate_persona() {
    local persona_file="$1"
    local target="$2"  # "apm" or "claude"
    local output_dir="$3"
    
    local persona_name=$(basename "$persona_file" .persona.yaml)
    local template_file="$TEMPLATES_DIR/${target}.persona.template"
    local output_file="$output_dir/${persona_name}.md.template"
    
    # Use yq to extract YAML data and envsubst for template processing
    yq eval '.' "$persona_file" | \
    envsubst < "$template_file" > "$output_file"
    
    echo "Generated: $output_file"
}

# Generate all personas for both targets
for persona_file in "$MASTER_DIR"/*.persona.yaml; do
    generate_persona "$persona_file" "apm" "$OUTPUT_APM"
    generate_persona "$persona_file" "claude" "$OUTPUT_CLAUDE"
done
```

### 4. Enhanced Variable Substitution System

```bash
# Enhanced replace_variables function
replace_variables_v2() {
    local input_file="$1"
    local output_file="$2"
    local target_env="${3:-apm}"  # "apm" or "claude"
    
    # Load environment-specific variables
    source "installer/config/${target_env}-variables.env"
    
    # Use envsubst for more robust template processing
    envsubst < "$input_file" > "$output_file"
    
    # Apply target-specific post-processing
    case "$target_env" in
        "apm")
            apply_apm_specific_processing "$output_file"
            ;;
        "claude")
            apply_claude_specific_processing "$output_file"
            ;;
    esac
}
```

### 5. Configuration System

```bash
# installer/config/apm-variables.env
export PROJECT_ROOT="{{PROJECT_ROOT}}"
export AP_ROOT="{{AP_ROOT}}"
export SESSION_NOTES_PATH="{{SESSION_NOTES_PATH}}"
export SPEAK_ANALYST="{{SPEAK_ANALYST}}"
export DEPLOYMENT_TARGET="apm"
export VOICE_INTEGRATION="enabled"
export SESSION_MANAGEMENT="apm"

# installer/config/claude-variables.env  
export PROJECT_ROOT="{{PROJECT_ROOT}}"
export CLAUDE_DIR="{{CLAUDE_DIR}}"
export SESSION_NOTES_PATH="{{SESSION_NOTES_PATH}}"
export SPEAK_ANALYST="{{SPEAK_ANALYST}}"
export DEPLOYMENT_TARGET="claude"
export VOICE_INTEGRATION="optional"
export SESSION_MANAGEMENT="claude"
```

## Implementation Plan

### Phase 1: Foundation (Week 1)
- [x] Create unified persona architecture design
- [ ] Set up master persona directory structure
- [ ] Create YAML schema for persona definitions
- [ ] Build template processing engine prototype

### Phase 2: Migration (Week 2)
- [ ] Convert existing personas to YAML format
- [ ] Create APM and Claude deployment templates
- [ ] Build enhanced variable substitution system
- [ ] Test template generation pipeline

### Phase 3: Integration (Week 3)
- [ ] Update installer scripts to use new system
- [ ] Integrate with build-distribution.sh
- [ ] Add validation and testing framework
- [ ] Create migration documentation

### Phase 4: Cleanup (Week 4)
- [ ] Remove duplicate persona files
- [ ] Update all references to new system
- [ ] Comprehensive testing across both targets
- [ ] Documentation and training materials

## Benefits

### For Developers
- **Single Edit Point**: Modify one YAML file, deploy to both targets
- **Structured Data**: YAML format enables programmatic manipulation
- **Version Control**: Clear tracking of persona evolution
- **Validation**: Schema validation prevents deployment errors

### For Operations
- **Consistent Deployment**: Standardized build process
- **Reduced Errors**: Elimination of manual copy/paste mistakes
- **Easier Updates**: Bulk updates across all personas
- **Testing Integration**: Automated validation pipeline

### For Users
- **Feature Parity**: Consistent experience across APM and Claude
- **Faster Releases**: Streamlined deployment process
- **Better Quality**: Reduced bugs from duplication errors
- **Enhanced Features**: Easier to add cross-cutting capabilities

## Technical Specifications

### Directory Structure
```
installer/
├── personas/
│   ├── _master/           # Single source of truth
│   ├── _shared/           # Shared components
│   ├── _templates/        # Output templates
│   ├── _schemas/          # YAML validation schemas
│   └── _tools/            # Generation scripts
├── config/
│   ├── apm-variables.env  # APM-specific variables
│   ├── claude-variables.env # Claude-specific variables
│   └── common-variables.env # Shared variables
└── templates/             # Generated outputs (read-only)
    ├── agents/personas/   # APM deployment
    └── claude/agents/personas/ # Claude deployment
```

### Build Integration
```bash
# Updated build-distribution.sh
echo "Generating persona templates..."
./installer/personas/_tools/generate-personas.sh

# Validate generated templates
./installer/personas/_tools/validate-templates.sh

# Continue with existing build process...
```

### Backwards Compatibility
- Existing deployed personas continue to work
- Gradual migration path with parallel systems
- Rollback capability to current system
- No breaking changes to user experience

## Risk Mitigation

### Technical Risks
- **Template Generation Failures**: Comprehensive testing and validation
- **Variable Substitution Errors**: Schema validation and automated testing
- **Build Process Issues**: Parallel development with fallback options

### Operational Risks
- **Deployment Conflicts**: Staged rollout with feature flags
- **User Impact**: Transparent migration with no user-visible changes
- **Rollback Requirements**: Maintain current system until full validation

## Success Metrics

### Quantitative
- **Duplication Elimination**: 100% reduction in duplicate persona files
- **Maintenance Efficiency**: 75% reduction in persona update time
- **Error Reduction**: 90% fewer deployment-related persona bugs
- **Build Performance**: <30s persona template generation time

### Qualitative
- **Developer Experience**: Single edit point achieved
- **Deployment Confidence**: Automated validation passes
- **Feature Consistency**: APM/Claude feature parity maintained
- **Maintainability**: New persona addition process streamlined

## Conclusion

The unified persona architecture eliminates the current three-location duplication problem while preserving all advanced features required by both APM and Claude Code deployments. The YAML-based master definitions with template generation provide a maintainable, scalable solution that reduces errors and improves developer productivity.

The phased implementation approach ensures minimal risk while delivering immediate benefits. The architecture supports future enhancements like cross-persona feature sharing, automated testing, and advanced deployment strategies.

---

*Architecture Design v1.0 - Created August 6, 2025*
*Next Review: After Phase 1 Completion*