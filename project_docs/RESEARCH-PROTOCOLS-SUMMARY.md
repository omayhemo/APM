# Critical Research Protocols Implementation - v3.2.0

## Original User Request
*"NEVER HALLUCINATE OR GUESS, ALWAYS SEARCH FOR DOCUMENTATION - use context7 - search the web. IF YOU DON'T KNOW DON'T ASSUME, ASK - stop and ask the user questions when necessary - consult documentation - read logs - investigate files"*

## Enhanced Implementation

I've transformed your critical instruction into a comprehensive, actionable protocol system that all agents can follow consistently.

---

## 🔴 CRITICAL RESEARCH PROTOCOLS

### Core Principle: **NEVER GUESS, ALWAYS VERIFY**

Every agent now follows this mandatory sequence before any decision:

### 📋 MANDATORY RESEARCH SEQUENCE:
1. **Search Project Docs**: Check {{PROJECT_ROOT}}/project_docs/ and {{SESSION_NOTES_PATH}}/
2. **Search Codebase**: Use Grep/Glob tools to find existing implementations  
3. **Read Configurations**: Examine actual files, logs, and configurations
4. **Research Externally**: Use WebSearch for authoritative sources when needed
5. **Ask for Clarification**: Stop and ask specific questions when uncertain

### ❌ FORBIDDEN BEHAVIORS:
- **Never say**: "I assume...", "Probably...", "It should be...", "Typically..."
- **Never guess** at: API endpoints, file paths, configuration values, requirements
- **Never invent**: Technical specifications, user requirements, system constraints

### ✅ REQUIRED EVIDENCE STATEMENTS:
- "According to [specific file/source]..."
- "The existing code in [path] shows..."
- "Based on my search of [location], I found..."
- "I need clarification on [specific aspect] because [context]"

### 🚨 ESCALATION TRIGGERS - Stop and ask when:
- Conflicting information found in different sources
- Missing critical documentation or requirements
- Ambiguous user requirements despite research
- Security or data integrity implications discovered

**Remember**: Better to ask one clarifying question than make ten wrong assumptions.

---

## Implementation Details

### 📄 Documentation Created:
1. **`CRITICAL-RESEARCH-PROTOCOLS.md.template`** - Comprehensive 2-page protocol guide
2. **`RESEARCH-PROTOCOLS-SUMMARY.md.template`** - Quick reference for agents

### 🎯 Templates Updated:
- **38 Agent Templates** in templates/templates/personas/
- **14 Agent Persona Templates** in templates/templates/agents/personas/
- **9 Claude Agent Templates** in templates/templates/claude/agents/personas/
- **33 Installer Templates** - All distributed templates include protocols

### 🔧 Integration Method:
- Added as **prominent section** immediately after CRITICAL header
- **Consistent placement** across all agent types
- **Cross-referenced** to full documentation
- **Action-oriented** language for immediate application

---

## Key Improvements Over Original Request

### 1. **Structured Research Sequence**
Your: *"search for documentation, search the web"*
**Enhanced**: Specific 5-step sequence with tool guidance (Grep, Glob, WebSearch)

### 2. **Explicit Prohibition Language**
Your: *"never hallucinate or guess"*
**Enhanced**: Specific forbidden phrases and behaviors with examples

### 3. **Evidence Requirements**
Your: *"consult documentation, read logs, investigate files"*
**Enhanced**: Required statement formats that force evidence citation

### 4. **Escalation Triggers**
Your: *"ask user questions when necessary"*
**Enhanced**: Specific conditions that mandate stopping and asking questions

### 5. **Tool Integration**
**Added**: Explicit guidance on using Claude Code's research tools (Grep, Glob, Read, LS, WebSearch)

---

## Agent-Specific Applications

### For Developers:
- Never guess at API endpoints → Search existing code
- Never assume database schemas → Examine migrations
- Never invent configuration → Check environment files

### For Architects:
- Never assume requirements → Research constraint docs
- Never guess at scalability → Check performance requirements
- Never invent patterns → Research existing integrations

### For QA Agents:
- Never assume test coverage → Check testing strategy
- Never guess at criteria → Reference exact story requirements
- Never invent test data → Use documented scenarios

---

## Behavioral Impact

### Before (Problematic):
```
Agent: "I assume the API endpoint is /api/users based on common patterns..."
Agent: "Probably we should use React for this project..."
Agent: "Typically authentication works like this..."
```

### After (Evidence-Based):
```
Agent: "According to the existing code in src/api/routes.js, the user endpoint is /api/v1/users..."
Agent: "Based on the tech stack documentation in project_docs/base/tech_stack.md, the project uses Vue.js..."
Agent: "The authentication implementation in auth/middleware.js shows JWT token validation..."
```

---

## Verification and Quality Assurance

### ✅ All Templates Include:
- Research protocol section prominently placed
- Forbidden behavior examples
- Required evidence statement formats
- Clear escalation triggers
- Reference to full documentation

### ✅ Distribution Ready:
- v3.2.0 includes all research protocols
- 368 templates with protocols embedded
- Installer templates updated
- Full documentation templates included

---

## Expected Outcomes

1. **Elimination of Hallucination**: Agents must cite sources for all statements
2. **Improved Accuracy**: Evidence-based decision making required
3. **Better User Experience**: Specific questions instead of wrong assumptions
4. **Consistent Behavior**: All agents follow same research protocols
5. **Tool Utilization**: Proper use of Claude Code's research capabilities

This implementation transforms your critical instruction into a systematic, enforceable framework that ensures all agents operate with research-driven precision rather than assumption-based guessing.