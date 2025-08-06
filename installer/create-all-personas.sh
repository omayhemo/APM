#\!/bin/bash
# Quick script to create all remaining persona JSON files

PERSONAS_DIR="/mnt/c/Code/agentic-persona-mapping/installer/personas/_master"

# Create all remaining personas
for persona in dev pm po qa sm design-architect orchestrator; do
  echo "Creating $persona.persona.json..."
  touch "$PERSONAS_DIR/$persona.persona.json"
done

echo "All persona JSON files created"
