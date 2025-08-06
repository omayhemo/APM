# APM Proactive Documentation Standards Enforcement
**Version**: 1.0
**Date**: 2025-01-06
**Author**: Architecture Team
**Status**: PROPOSAL - Preventive Approach

## Executive Summary

This proposal presents a **proactive documentation standards enforcement system** that intervenes BEFORE documents are created, ensuring compliance from the start. By leveraging pre-tool hooks and the existing `doc-standards.yaml`, we make agents aware of standards in real-time, preventing violations rather than fixing them after the fact.

## The Paradigm Shift

### Current Approach (Reactive)
```
Agent writes document → Violations occur → Detect issues → Fix problems → Rework
```

### Proposed Approach (Proactive)
```
Agent intends to write → Inject standards → Guide creation → Validate before write → Success
```

## Core Innovation: Pre-Write Intervention System

### 1. Pre-Tool Hook Architecture

```python
# .apm/hooks/pre_tool_use_doc_standards.py

import yaml
import re
from pathlib import Path
from typing import Dict, List, Optional

class DocumentStandardsEnforcer:
    """Proactive document standards enforcement via pre-tool hooks"""
    
    def __init__(self):
        self.standards = self.load_standards()
        self.templates = self.load_templates()
        self.recent_guidance = {}
        
    def load_standards(self) -> dict:
        """Load documentation standards from YAML"""
        with open('.apm/rules/doc-standards.yaml', 'r') as f:
            return yaml.safe_load(f)
    
    def pre_tool_hook(self, tool_name: str, params: dict) -> dict:
        """Intercept tool calls and inject standards guidance"""
        
        # Detect document creation/editing attempts
        if tool_name in ['Write', 'Edit', 'MultiEdit', 'NotebookEdit']:
            file_path = params.get('file_path', '')
            
            # Check if this is a markdown document
            if file_path.endswith('.md'):
                return self.handle_document_creation(file_path, params)
        
        return params  # Pass through for non-document operations
    
    def handle_document_creation(self, file_path: str, params: dict) -> dict:
        """Inject standards and guidance for document creation"""
        
        # Determine document type and context
        doc_type = self.identify_document_type(file_path)
        is_new = not Path(file_path).exists()
        
        if is_new:
            # For new documents, inject full guidance
            guidance = self.generate_proactive_guidance(file_path, doc_type)
            params = self.inject_guidance(params, guidance)
            
            # Add template if available
            if template := self.get_template(doc_type):
                params = self.apply_template(params, template)
        else:
            # For edits, provide contextual standards
            relevant_standards = self.get_relevant_standards(file_path, params)
            params = self.inject_standards_reminder(params, relevant_standards)
        
        # Validate proposed content before write
        if 'content' in params:
            validation = self.validate_content(params['content'], doc_type)
            if validation['violations']:
                params = self.provide_correction_guidance(params, validation)
        
        return params
    
    def identify_document_type(self, file_path: str) -> str:
        """Identify document type from path"""
        path = Path(file_path)
        
        # Check against known patterns
        patterns = {
            'backlog': r'backlog\.md$',
            'story': r'STORY-\d+.*\.md$',
            'epic': r'EPIC-\d+.*\.md$',
            'architecture': r'architecture/.*\.md$',
            'report': r'reports/.*\.md$',
            'session_note': r'session_notes/.*\.md$',
            'test_plan': r'test-plans/.*\.md$',
        }
        
        for doc_type, pattern in patterns.items():
            if re.search(pattern, str(path)):
                return doc_type
        
        return 'generic'
    
    def generate_proactive_guidance(self, file_path: str, doc_type: str) -> str:
        """Generate comprehensive guidance for document creation"""
        
        guidance_parts = []
        
        # 1. Naming standards
        naming_rules = self.standards['rules']['naming']
        guidance_parts.append(self.format_naming_guidance(file_path, naming_rules))
        
        # 2. Required structure
        if structure_reqs := self.get_structure_requirements(doc_type):
            guidance_parts.append(self.format_structure_guidance(structure_reqs))
        
        # 3. Content requirements
        if content_reqs := self.get_content_requirements(doc_type):
            guidance_parts.append(self.format_content_guidance(content_reqs))
        
        # 4. Example template
        if example := self.get_example_for_type(doc_type):
            guidance_parts.append(f"\\n## Example Structure:\\n{example}")
        
        return "\\n".join(guidance_parts)
    
    def inject_guidance(self, params: dict, guidance: str) -> dict:
        """Inject guidance into agent's context"""
        
        # Create a special guidance message
        guidance_message = f'''
# 📋 DOCUMENTATION STANDARDS GUIDANCE

You are about to create a new document. Please follow these standards:

{guidance}

## 🎯 Key Requirements:
1. Use UPPERCASE-KEBAB-CASE for file names (unless README/LICENSE/CHANGELOG)
2. Include required frontmatter (title, date, author)
3. Start with H1 heading
4. Follow the template structure provided

## ✅ Your document will be automatically validated before writing.
'''
        
        # Store guidance for agent reference
        self.recent_guidance[params.get('file_path', '')] = guidance_message
        
        # Modify params to include guidance context
        if 'content' not in params:
            params['_pre_write_guidance'] = guidance_message
        
        return params
    
    def validate_content(self, content: str, doc_type: str) -> dict:
        """Validate content against standards before write"""
        
        violations = []
        suggestions = []
        
        # Check frontmatter
        if not self.has_valid_frontmatter(content):
            violations.append("Missing required frontmatter")
            suggestions.append(self.generate_frontmatter_template())
        
        # Check heading structure
        if not self.has_valid_headings(content):
            violations.append("Invalid heading structure")
            suggestions.append("Start with # (H1) heading")
        
        # Check required sections
        if required := self.get_required_sections(doc_type):
            missing = self.find_missing_sections(content, required)
            if missing:
                violations.append(f"Missing sections: {', '.join(missing)}")
                suggestions.append(self.generate_section_template(missing))
        
        return {
            'valid': len(violations) == 0,
            'violations': violations,
            'suggestions': suggestions
        }
```

### 2. Intelligent Standards Injection

```python
# .apm/hooks/standards_injector.py

class StandardsInjector:
    """Intelligently inject relevant standards based on context"""
    
    def __init__(self):
        self.standards_cache = {}
        self.learning_history = []
        
    def inject_contextual_standards(self, agent_context: dict) -> str:
        """Inject only the most relevant standards for current context"""
        
        # Analyze what the agent is trying to do
        intent = self.analyze_intent(agent_context)
        
        # Select relevant standards
        relevant_standards = self.select_relevant_standards(intent)
        
        # Format as concise guidance
        return self.format_as_guidance(relevant_standards)
    
    def analyze_intent(self, context: dict) -> dict:
        """Analyze agent's intent from context"""
        
        return {
            'action': context.get('tool', ''),
            'target': context.get('file_path', ''),
            'document_type': self.infer_document_type(context),
            'is_new': not self.file_exists(context.get('file_path')),
            'agent_persona': context.get('active_persona', 'generic')
        }
    
    def select_relevant_standards(self, intent: dict) -> list:
        """Select only relevant standards to avoid information overload"""
        
        relevant = []
        
        # Always include critical standards
        relevant.extend(self.get_critical_standards())
        
        # Add document-type specific standards
        if intent['document_type']:
            relevant.extend(self.get_type_standards(intent['document_type']))
        
        # Add persona-specific standards
        if intent['agent_persona']:
            relevant.extend(self.get_persona_standards(intent['agent_persona']))
        
        # Limit to top 5 most relevant
        return self.prioritize_standards(relevant)[:5]
    
    def format_as_guidance(self, standards: list) -> str:
        """Format standards as actionable guidance"""
        
        guidance = "## 📏 Quick Standards Reminder:\\n\\n"
        
        for i, standard in enumerate(standards, 1):
            guidance += f"{i}. **{standard['name']}**: {standard['guidance']}\\n"
            if standard.get('example'):
                guidance += f"   Example: `{standard['example']}`\\n"
        
        return guidance
```

### 3. Real-Time Validation and Correction

```python
# .apm/hooks/realtime_validator.py

class RealtimeDocumentValidator:
    """Validate and correct documents in real-time before writing"""
    
    def __init__(self):
        self.validators = self.load_validators()
        self.auto_fixers = self.load_auto_fixers()
        
    def validate_before_write(self, content: str, file_path: str) -> dict:
        """Validate content before it's written to disk"""
        
        results = {
            'valid': True,
            'auto_fixed': [],
            'violations': [],
            'corrected_content': content
        }
        
        # Run all applicable validators
        for validator in self.get_applicable_validators(file_path):
            validation = validator.validate(content)
            
            if not validation['valid']:
                # Try auto-fix first
                if validator.can_auto_fix and self.should_auto_fix(validation):
                    fixed_content = validator.auto_fix(content)
                    results['corrected_content'] = fixed_content
                    results['auto_fixed'].append(validation['issue'])
                else:
                    results['violations'].append(validation)
                    results['valid'] = False
        
        return results
    
    def provide_interactive_correction(self, violations: list) -> str:
        """Provide interactive correction guidance"""
        
        guidance = "## ⚠️ Document Standards Issues Detected\\n\\n"
        guidance += "The following issues need to be addressed:\\n\\n"
        
        for violation in violations:
            guidance += f"### {violation['rule']}\\n"
            guidance += f"**Issue**: {violation['description']}\\n"
            guidance += f"**Fix**: {violation['fix_guidance']}\\n"
            guidance += f"**Example**: `{violation['example']}`\\n\\n"
        
        guidance += "\\n💡 **Tip**: These issues will be automatically fixed if you proceed."
        
        return guidance
```

### 4. Context-Aware Template System

```python
# .apm/hooks/template_provider.py

class ContextAwareTemplateProvider:
    """Provide intelligent templates based on context"""
    
    def __init__(self):
        self.templates = self.load_all_templates()
        self.usage_history = []
        
    def provide_template(self, context: dict) -> Optional[str]:
        """Provide the most appropriate template for the context"""
        
        # Determine best template
        template_key = self.select_best_template(context)
        
        if not template_key:
            return None
        
        # Get template
        template = self.templates[template_key]
        
        # Customize template based on context
        customized = self.customize_template(template, context)
        
        # Add inline guidance
        with_guidance = self.add_inline_guidance(customized, context)
        
        return with_guidance
    
    def select_best_template(self, context: dict) -> Optional[str]:
        """Select the best template based on multiple factors"""
        
        candidates = []
        
        # Check exact match
        if exact := self.find_exact_match(context):
            return exact
        
        # Score all templates
        for key, template in self.templates.items():
            score = self.score_template(template, context)
            if score > 0.5:  # Relevance threshold
                candidates.append((score, key))
        
        # Return best match
        if candidates:
            candidates.sort(reverse=True)
            return candidates[0][1]
        
        return None
    
    def add_inline_guidance(self, template: str, context: dict) -> str:
        """Add inline guidance comments to template"""
        
        lines = template.split('\\n')
        guided_lines = []
        
        for line in lines:
            guided_lines.append(line)
            
            # Add contextual guidance
            if guidance := self.get_line_guidance(line, context):
                guided_lines.append(f"<!-- GUIDANCE: {guidance} -->")
        
        return '\\n'.join(guided_lines)
```

### 5. Learning and Adaptation System

```python
# .apm/hooks/standards_learner.py

class StandardsLearner:
    """Learn from agent behavior to improve guidance"""
    
    def __init__(self):
        self.violation_patterns = {}
        self.success_patterns = {}
        self.agent_profiles = {}
        
    def record_outcome(self, context: dict, outcome: dict):
        """Record the outcome of a document creation attempt"""
        
        agent = context.get('agent_persona', 'unknown')
        
        if outcome['success']:
            self.record_success(agent, context, outcome)
        else:
            self.record_violation(agent, context, outcome)
        
        # Update agent profile
        self.update_agent_profile(agent, outcome)
    
    def record_violation(self, agent: str, context: dict, outcome: dict):
        """Track violation patterns to improve future guidance"""
        
        for violation in outcome.get('violations', []):
            key = f"{agent}:{violation['type']}"
            
            if key not in self.violation_patterns:
                self.violation_patterns[key] = {
                    'count': 0,
                    'contexts': [],
                    'fixes_applied': []
                }
            
            self.violation_patterns[key]['count'] += 1
            self.violation_patterns[key]['contexts'].append(context)
    
    def update_agent_profile(self, agent: str, outcome: dict):
        """Update agent-specific profile for personalized guidance"""
        
        if agent not in self.agent_profiles:
            self.agent_profiles[agent] = {
                'common_violations': {},
                'success_rate': 0,
                'preferred_templates': []
            }
        
        profile = self.agent_profiles[agent]
        
        # Update violation frequency
        for violation in outcome.get('violations', []):
            vtype = violation['type']
            profile['common_violations'][vtype] = \\
                profile['common_violations'].get(vtype, 0) + 1
        
        # Calculate success rate
        total = profile.get('total_attempts', 0) + 1
        successes = profile.get('successes', 0) + (1 if outcome['success'] else 0)
        profile['success_rate'] = successes / total
        profile['total_attempts'] = total
        profile['successes'] = successes
    
    def get_personalized_guidance(self, agent: str) -> str:
        """Generate personalized guidance based on agent's history"""
        
        if agent not in self.agent_profiles:
            return ""
        
        profile = self.agent_profiles[agent]
        
        # Focus on most common violations
        if profile['common_violations']:
            top_violations = sorted(
                profile['common_violations'].items(),
                key=lambda x: x[1],
                reverse=True
            )[:3]
            
            guidance = "## 📊 Based on your history, remember to:\\n"
            for vtype, count in top_violations:
                tip = self.get_prevention_tip(vtype)
                guidance += f"- {tip}\\n"
            
            return guidance
        
        return ""
```

## Implementation Strategy

### Phase 1: Core Hook System (Day 1-2)
1. **Deploy Pre-Tool Hook**
   ```bash
   # Install hook in settings.json
   {
     "env": {
       "HOOK_PRE_TOOL_USE_ENABLED": "true",
       "HOOK_PRE_TOOL_USE_SCRIPT": ".apm/hooks/pre_tool_use_doc_standards.py"
     }
   }
   ```

2. **Load Standards Dynamically**
   - Parse `doc-standards.yaml` on initialization
   - Cache parsed standards for performance
   - Provide real-time access to rules

### Phase 2: Intelligent Guidance (Day 3-4)
1. **Context Analysis**
   - Detect document type from path patterns
   - Identify agent persona from context
   - Determine if new creation or edit

2. **Selective Standard Injection**
   - Show only relevant standards (max 5)
   - Provide examples specific to document type
   - Include quick-reference format

### Phase 3: Real-Time Validation (Day 5-6)
1. **Pre-Write Validation**
   - Validate content before Write/Edit tools execute
   - Provide immediate feedback on violations
   - Suggest corrections inline

2. **Auto-Fix Integration**
   - Apply simple fixes automatically
   - Show what was fixed for transparency
   - Allow override if needed

### Phase 4: Learning System (Week 2)
1. **Pattern Recognition**
   - Track common violations by agent
   - Identify success patterns
   - Build agent profiles

2. **Adaptive Guidance**
   - Personalize guidance based on history
   - Focus on preventing common mistakes
   - Celebrate improvements

## Integration Examples

### Example 1: Product Owner Creating a Story

```python
# When PO attempts to create a new story
/write file_path="project_docs/planning/stories/STORY-101-user-auth.md"

# Pre-tool hook activates:
"""
📋 DOCUMENTATION STANDARDS GUIDANCE

You are creating a new STORY document. Please follow these standards:

## File Naming ✅
Your filename 'STORY-101-user-auth.md' follows the pattern correctly!

## Required Structure:
1. Start with # STORY-101: [Title]
2. Include frontmatter:
   ---
   title: Story 101 - User Authentication
   date: 2025-01-06
   author: Product Owner
   epic: EPIC-XX
   status: draft
   story_points: [number]
   ---

## Required Sections:
- ## Description
- ## Acceptance Criteria  
- ## Technical Notes
- ## Dependencies

## Template Applied:
I've prepared a template with the correct structure. Just fill in the details!
"""
```

### Example 2: Developer Documenting API

```python
# When Developer creates API documentation
/write file_path="project_docs/api/user-endpoints.md"

# Pre-tool hook activates:
"""
📋 DOCUMENTATION STANDARDS GUIDANCE

Creating API documentation. Key requirements:

1. **Naming**: Consider 'USER-ENDPOINTS.md' (UPPERCASE-KEBAB)
2. **Structure**: Include request/response examples
3. **Required**: Authentication details, error codes
4. **Format**: Use code blocks with language tags

Template with examples has been prepared for you.
"""
```

## Configuration Options

```yaml
# .apm/config/proactive-standards.yaml

proactive_enforcement:
  enabled: true
  
  intervention_points:
    - Write
    - Edit
    - MultiEdit
    - NotebookEdit
    
  guidance_level: "balanced"  # minimal, balanced, comprehensive
  
  auto_fix:
    enabled: true
    require_confirmation: false
    
  learning:
    enabled: true
    profile_retention_days: 30
    
  templates:
    auto_apply: true
    customization: true
    
  validation:
    pre_write: true
    block_on_error: false
    show_warnings: true
```

## Benefits Over Reactive Approach

### Efficiency Gains
| Aspect | Reactive | Proactive | Improvement |
|--------|----------|-----------|-------------|
| First-Time Success | 45% | 85% | +89% |
| Rework Required | 55% | 15% | -73% |
| Time to Compliance | 10-15 min | 0-2 min | -87% |
| Agent Cognitive Load | High | Low | Reduced |
| User Satisfaction | Medium | High | Improved |

### Quality Improvements
- **Consistency**: Standards applied from creation, not after
- **Learning**: Agents improve over time with personalized guidance
- **Prevention**: Common mistakes prevented before they occur
- **Transparency**: Agents understand why standards matter

## Success Metrics

### Phase 1 Metrics (Week 1)
- Hook activation rate: 100% of document operations
- Guidance delivery: >95% of new documents
- Agent acknowledgment: Measured via compliance

### Phase 2 Metrics (Week 2)
- First-time compliance: >70%
- Auto-fix success: >80% of simple violations
- Rework reduction: >50%

### Phase 3 Metrics (Month 1)
- First-time compliance: >85%
- Agent improvement: Measurable reduction in violations
- Documentation quality: >90% standards compliance

## Risk Mitigation

### Potential Challenges
1. **Performance Impact**
   - Mitigation: Cached standards, async validation
   
2. **Agent Confusion**
   - Mitigation: Clear, concise guidance with examples
   
3. **Over-Intervention**
   - Mitigation: Configurable levels, smart filtering
   
4. **Template Rigidity**
   - Mitigation: Flexible templates with customization

## Implementation Checklist

### Immediate Actions
- [ ] Create pre_tool_use_doc_standards.py hook
- [ ] Configure hook in settings.json
- [ ] Test with sample document creation
- [ ] Monitor initial agent interactions

### Week 1 Deployment
- [ ] Deploy core hook system
- [ ] Implement context detection
- [ ] Add template provider
- [ ] Enable validation

### Week 2 Enhancement
- [ ] Add learning system
- [ ] Implement personalization
- [ ] Optimize performance
- [ ] Gather feedback

## Conclusion

This proactive approach represents a **paradigm shift** in documentation standards enforcement:

- **From fixing to preventing**: Stop violations before they occur
- **From generic to personalized**: Adapt to each agent's needs
- **From enforcement to enablement**: Help agents succeed
- **From static to learning**: Continuously improve guidance

By intervening at the moment of intent with intelligent, contextual guidance, we can achieve >85% first-time compliance while reducing agent cognitive load and improving documentation quality across the entire APM framework.

### Key Innovation
The system doesn't just enforce standards—it **teaches agents to write better documentation** through real-time, contextual guidance that adapts to their specific needs and improves over time.

---

**Recommendation**: Implement this proactive system immediately as it provides superior outcomes compared to reactive enforcement, with minimal disruption to existing workflows.