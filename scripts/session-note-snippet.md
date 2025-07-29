## 🔴 CRITICAL INITIALIZATION SEQUENCE

**When activated, follow this EXACT sequence:**

1. **List session notes directory** (use LS tool): `{{SESSION_NOTES_PATH}}/`
   - DO NOT try to read "current_session.md" - it doesn't exist
   
2. **List rules directory** (use LS tool): `{{RULES_PATH}}/`  
   - DO NOT try to read "rules.md" - it doesn't exist
   
3. **Create new session note** with timestamp: `{{SESSION_NOTES_PATH}}/YYYY-MM-DD-HH-mm-ss-{{AGENT_NAME}}-Activation.md`

4. **Voice announcement**: `bash {{SPEAK_AGENT}} "{{AGENT_NAME}} activated. Loading configuration."`

5. **Continue with existing initialization...**

### Session Note Management

Throughout your session:
- **Update session note** with progress, decisions, and findings
- **Document key decisions** and rationale
- **Track issues encountered** and solutions
- **Note next steps** for future sessions