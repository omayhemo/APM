# Unified Persona Architecture - Migration Strategy

## Overview

This document outlines the migration strategy for implementing the unified persona architecture that eliminates duplication and creates a single source of truth for persona definitions serving both APM and Claude Code deployments.

## Migration Goals

### Primary Objectives
1. **Eliminate Duplication**: Remove the three-location persona maintenance problem
2. **Single Source of Truth**: Establish master persona definitions in YAML format
3. **Automated Deployment**: Generate both APM and Claude targets from unified definitions
4. **Zero Downtime**: Ensure no disruption to existing users during migration
5. **Backward Compatibility**: Maintain full compatibility with existing commands and workflows

### Success Metrics
- **Duplication Reduction**: 100% elimination of duplicate persona files
- **Maintenance Efficiency**: 75% reduction in persona update time
- **Error Rate**: 90% reduction in deployment inconsistency bugs
- **Developer Experience**: Single edit point for persona changes

## Current State Assessment

### Duplication Analysis
```
Current Locations:
├── /installer/templates/agents/personas/ (APM installer templates)
├── /installer/templates/claude/agents/personas/ (Claude installer templates)
├── /.apm/agents/personas/ (APM deployed instances)
└── /.claude/agents/personas/ (Claude deployed instances)

Duplication Count: 9 personas × 2 template locations = 18 duplicate files
Maintenance Overhead: ~2-4 hours per persona update
Error Risk: High (manual synchronization required)
```

### Template Variable Analysis
```bash
# Current template variables in use (30+ variables):
{{PROJECT_ROOT}}, {{AP_ROOT}}, {{SESSION_NOTES_PATH}}, {{SPEAK_ANALYST}}, 
{{CLAUDE_DIR}}, {{MIGRATION_VERSION}}, {{AGENT_NAME}}, etc.

# Processing: sed-based replacement in install.sh (50+ commands)
# Issues: Platform-specific sed syntax, error-prone, hard to maintain
```

## Migration Strategy

### Phase 1: Foundation Setup (Week 1)

#### 1.1 Create Unified Structure
```bash
# New directory structure
installer/personas/
├── _master/                     # Single source of truth
│   ├── analyst.persona.yaml     
│   ├── architect.persona.yaml
│   ├── developer.persona.yaml
│   └── ...
├── _templates/                  # Deployment templates
│   ├── apm.persona.template
│   └── claude.persona.template
├── _tools/                      # Generation scripts
│   ├── generate-personas.sh
│   ├── validate-personas.sh
│   └── migrate-existing.sh
└── _schemas/                    # YAML validation
    └── persona.schema.json
```

**Status**: ✅ **COMPLETED** - Basic structure and proof-of-concept created

#### 1.2 YAML Schema Definition
```yaml
# persona.schema.json - Validation schema for persona definitions
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "required": ["persona", "metadata", "voice", "workspace"],
  "properties": {
    "persona": {
      "type": "object",
      "required": ["name", "role", "version", "id"],
      "properties": {
        "name": {"type": "string"},
        "role": {"type": "string"},
        "version": {"type": "string", "pattern": "^\\d+\\.\\d+\\.\\d+$"},
        "id": {"type": "string", "pattern": "^[a-z-]+$"}
      }
    }
    # ... additional validation rules
  }
}
```

**Deliverables**:
- [x] Directory structure created
- [x] Example persona YAML definition (analyst.persona.yaml)
- [x] Template files for both targets
- [x] Basic generation script
- [ ] JSON schema validation
- [ ] Migration scripts

### Phase 2: Template Generation Engine (Week 2)

#### 2.1 Enhanced Generation Script
```bash
# generate-personas.sh improvements needed:
1. Replace basic sed with proper template engine (Jinja2 or custom)
2. Add YAML validation against schema
3. Support conditional content generation
4. Add error handling and rollback
5. Generate both templates simultaneously
```

**Status**: 🔄 **IN PROGRESS** - Basic version created, needs enhancement

#### 2.2 Variable Substitution Overhaul
```bash
# Current: 50+ sed commands in install.sh
sed -i "s|{{PROJECT_ROOT}}|$PROJECT_ROOT|g" "$temp_file"
sed -i "s|{{AP_ROOT}}|$AP_ROOT|g" "$temp_file"
# ... 48 more lines

# New: Environment-based substitution
source installer/config/${target}-variables.env
envsubst < "$template" > "$output"
```

**Benefits**:
- Platform independence (no sed syntax issues)
- Easier maintenance (environment files vs. hardcoded commands)
- Better error handling
- Cleaner code

#### 2.3 Build Integration
```bash
# Updated build-distribution.sh
echo "Generating unified persona templates..."
./installer/personas/_tools/generate-personas.sh

# Validate generated templates
./installer/personas/_tools/validate-personas.sh

# Continue with existing build process...
```

**Deliverables**:
- [ ] Enhanced template engine with Jinja2-like capabilities
- [ ] Schema validation integration
- [ ] Environment variable configuration files
- [ ] Build script integration
- [ ] Comprehensive error handling

### Phase 3: Parallel Deployment (Week 3)

#### 3.1 Dual System Operation
During migration, both systems will operate in parallel:

```
Existing System (Legacy):
└── installer/templates/{agents,claude}/personas/*.md.template

New System (Active):  
└── installer/personas/_master/*.persona.yaml
    └── generates → installer/templates/{agents,claude}/personas/*.md.template

Validation: diff -r old_output new_output
```

#### 3.2 Validation Framework
```bash
#!/bin/bash
# validate-migration.sh

# 1. Generate personas with new system
./installer/personas/_tools/generate-personas.sh

# 2. Compare with existing templates
for persona in analyst architect developer pm qa po sm design-architect; do
    echo "Validating $persona..."
    
    # Compare APM outputs
    diff -u "installer/templates/agents/personas/$persona.md.template" \
            "installer/templates/agents/personas/$persona.md.template.new" || {
        echo "❌ APM $persona validation failed"
        exit 1
    }
    
    # Compare Claude outputs  
    diff -u "installer/templates/claude/agents/personas/$persona.md.template" \
            "installer/templates/claude/agents/personas/$persona.md.template.new" || {
        echo "❌ Claude $persona validation failed"
        exit 1
    }
    
    echo "✅ $persona validation passed"
done
```

#### 3.3 Installation Script Updates
```bash
# Updated install.sh integration
if [ -d "installer/personas/_master" ] && [ -f "installer/personas/_tools/generate-personas.sh" ]; then
    echo "Using unified persona generation system..."
    ./installer/personas/_tools/generate-personas.sh
else
    echo "Using legacy persona templates..."
    # Fallback to existing system
fi
```

**Deliverables**:
- [ ] Validation framework
- [ ] Parallel system operation
- [ ] Installer integration
- [ ] Rollback mechanisms
- [ ] Performance testing

### Phase 4: Migration Execution (Week 4)

#### 4.1 Convert Existing Personas

Priority order based on usage frequency:
1. **analyst.persona.yaml** ✅ - Completed (proof-of-concept)
2. **architect.persona.yaml** 
3. **developer.persona.yaml**
4. **pm.persona.yaml** 
5. **qa.persona.yaml**
6. **po.persona.yaml**
7. **sm.persona.yaml**
8. **design-architect.persona.yaml**

Migration script template:
```bash
#!/bin/bash
# migrate-persona.sh <persona_name>

PERSONA="$1"
APM_SOURCE="installer/templates/agents/personas/$PERSONA.md.template"
CLAUDE_SOURCE="installer/templates/claude/agents/personas/$PERSONA.md.template"
OUTPUT="installer/personas/_master/$PERSONA.persona.yaml"

# Extract common data from both templates
# Generate YAML definition
# Validate against schema
# Test generation
# Compare outputs
```

#### 4.2 Legacy Cleanup

**Safe Deletion Strategy**:
1. Move old templates to archive
2. Update all references to new system
3. Remove generation code from install.sh
4. Clean up build scripts

```bash
# Archive old templates
mkdir -p archive/personas-$(date +%Y%m%d)
mv installer/templates/agents/personas/ archive/personas-$(date +%Y%m%d)/apm/
mv installer/templates/claude/agents/personas/ archive/personas-$(date +%Y%m%d)/claude/

# Symlinks for compatibility during transition
ln -sf ../../../personas/generated/apm/ installer/templates/agents/personas
ln -sf ../../../personas/generated/claude/ installer/templates/claude/agents/personas
```

**Deliverables**:
- [ ] All 8 personas converted to YAML
- [ ] Validation passes for all personas
- [ ] Legacy template archive
- [ ] Updated documentation
- [ ] Migration completion verification

## Risk Assessment & Mitigation

### High-Risk Items

#### 1. Template Generation Failures
**Risk**: Generated templates don't match existing functionality
**Mitigation**: 
- Comprehensive diff-based validation
- Parallel system operation during transition
- Automated rollback mechanisms

#### 2. Variable Substitution Errors
**Risk**: Template variables not properly replaced
**Mitigation**:
- Schema validation for variable references
- Test installations on multiple platforms
- Environment variable validation

#### 3. User Workflow Disruption
**Risk**: Changed file paths break existing integrations
**Mitigation**:
- Maintain existing deployment paths
- Only change generation process, not outputs
- Extensive testing with real installations

### Medium-Risk Items

#### 1. Build Process Changes
**Risk**: Distribution generation failures
**Mitigation**:
- Parallel build validation
- Fallback to legacy system
- Staged deployment

#### 2. Schema Evolution
**Risk**: YAML schema changes break existing definitions
**Mitigation**:
- Version schema files
- Backward compatibility testing
- Migration scripts for schema updates

### Low-Risk Items

#### 1. Documentation Updates
**Risk**: Outdated documentation
**Mitigation**:
- Generate documentation from schema
- Include examples in templates
- Version documentation with releases

## Testing Strategy

### Unit Testing
```bash
# Test individual persona generation
./test-persona-generation.sh analyst
./test-persona-generation.sh architect

# Test variable substitution
./test-variable-substitution.sh

# Test schema validation  
./test-schema-validation.sh
```

### Integration Testing
```bash
# Test full installation process
./test-full-installation.sh --target apm
./test-full-installation.sh --target claude

# Test persona activation
./test-persona-activation.sh
```

### User Acceptance Testing
```bash
# Test existing commands still work
/ap_orchestrator
/analyst
/architect
/developer

# Test voice notifications
# Test session management
# Test workspace boundaries
```

## Success Criteria

### Phase 1 Success (Foundation)
- [x] Directory structure created
- [x] Example YAML persona definition
- [x] Basic template generation
- [x] Proof-of-concept validation
- [ ] JSON schema definition
- [ ] Migration tooling framework

### Phase 2 Success (Engine)  
- [ ] Robust template generation engine
- [ ] Environment-based variable substitution
- [ ] Build system integration
- [ ] Error handling and rollback
- [ ] Performance optimization

### Phase 3 Success (Deployment)
- [ ] Parallel system operation
- [ ] 100% output compatibility
- [ ] Installer integration
- [ ] Rollback capability tested
- [ ] Performance benchmarks met

### Phase 4 Success (Migration)
- [ ] All 8 personas converted
- [ ] Legacy cleanup completed  
- [ ] Documentation updated
- [ ] User acceptance testing passed
- [ ] Production deployment successful

## Post-Migration Benefits

### Developer Experience
- **Single Edit Point**: Modify one YAML file, both targets updated
- **Structured Data**: YAML enables programmatic analysis and manipulation
- **Validation**: Schema prevents common errors
- **Documentation**: Self-documenting persona definitions

### Operations
- **Consistency**: Impossible to have APM/Claude drift
- **Automation**: Fully automated deployment pipeline
- **Testing**: Comprehensive validation framework
- **Maintenance**: 75% reduction in update effort

### Users
- **Reliability**: Reduced bugs from synchronization errors
- **Features**: Easier to add cross-cutting capabilities
- **Performance**: Faster deployment and updates
- **Experience**: Consistent behavior across platforms

## Next Steps

### Immediate Actions (This Week)
- [ ] Create JSON schema for persona validation
- [ ] Enhance generation script with proper template engine
- [ ] Convert architect.persona.yaml as second example
- [ ] Create validation framework

### Short-term (Next 2 Weeks)
- [ ] Convert all remaining personas to YAML
- [ ] Implement comprehensive testing
- [ ] Update build and installation scripts
- [ ] Create migration documentation

### Medium-term (Next Month)
- [ ] Deploy to test environments
- [ ] User acceptance testing
- [ ] Performance optimization
- [ ] Production deployment

---

*Migration Strategy v1.0 - Created August 6, 2025*
*Status: Phase 1 Foundation - 70% Complete*
*Next Review: After Phase 1 Completion*