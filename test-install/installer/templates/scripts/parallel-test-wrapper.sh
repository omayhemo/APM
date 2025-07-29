#!/bin/bash

# Parallel Test Wrapper
# Implements the /parallel-test command functionality

set -e

# Default values
DEFAULT_PLAN="tests/parallel-test-plan.md"
PLAN_PATH="$DEFAULT_PLAN"
DRY_RUN=false
FILTER=""
UPDATE_PLAN=true
MAX_PARALLEL=""
TIMEOUT=""

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --plan)
            PLAN_PATH="$2"
            shift 2
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --filter)
            FILTER="$2"
            shift 2
            ;;
        --update-plan)
            UPDATE_PLAN="$2"
            shift 2
            ;;
        --max-parallel)
            MAX_PARALLEL="$2"
            shift 2
            ;;
        --timeout)
            TIMEOUT="$2"
            shift 2
            ;;
        --help|-h)
            cat << EOF
Usage: $0 [options]

Options:
  --plan <path>         Alternative test plan file (default: $DEFAULT_PLAN)
  --dry-run            Show what would be executed without running tests
  --filter <regex>     Run only agents matching the pattern
  --update-plan        Update the test plan after execution (default: true)
  --max-parallel <n>   Override max parallel agents from plan
  --timeout <minutes>  Override global timeout from plan
  --help              Show this help message

Examples:
  # Run all tests from default plan
  $0

  # Use custom test plan
  $0 --plan tests/integration-test-plan.md

  # Run only unit tests
  $0 --filter "unit-.*"

  # Dry run to see what would execute
  $0 --dry-run
EOF
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Check if plan exists
if [ ! -f "$PLAN_PATH" ]; then
    echo -e "${RED}Error: Test plan not found: $PLAN_PATH${NC}"
    exit 1
fi

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check for required scripts
PARSER_SCRIPT="$SCRIPT_DIR/test-plan-parser.js"
ORCHESTRATOR_SCRIPT="$SCRIPT_DIR/parallel-test-orchestrator.sh"
UPDATER_SCRIPT="$SCRIPT_DIR/test-plan-updater.js"

if [ ! -f "$PARSER_SCRIPT" ]; then
    echo -e "${RED}Error: Parser script not found: $PARSER_SCRIPT${NC}"
    exit 1
fi

if [ ! -f "$ORCHESTRATOR_SCRIPT" ]; then
    echo -e "${RED}Error: Orchestrator script not found: $ORCHESTRATOR_SCRIPT${NC}"
    exit 1
fi

if [ ! -f "$UPDATER_SCRIPT" ]; then
    echo -e "${RED}Error: Updater script not found: $UPDATER_SCRIPT${NC}"
    exit 1
fi

echo -e "${BLUE}=========================================="
echo "Parallel Test Execution"
echo "=========================================="
echo "Plan: $PLAN_PATH"
echo "Dry Run: $DRY_RUN"
echo "Filter: ${FILTER:-none}"
echo "Update Plan: $UPDATE_PLAN"
echo -e "==========================================${NC}"
echo ""

# Parse test plan
echo -e "${YELLOW}Parsing test plan...${NC}"
ORCHESTRATOR_INPUT=$(node "$PARSER_SCRIPT" "$PLAN_PATH" --json)

if [ $? -ne 0 ]; then
    echo -e "${RED}Error: Failed to parse test plan${NC}"
    exit 1
fi

# Extract configuration
CONFIG=$(echo "$ORCHESTRATOR_INPUT" | jq -r '.config')
AGENTS=$(echo "$ORCHESTRATOR_INPUT" | jq -r '.agents')

# Apply overrides
if [ -n "$MAX_PARALLEL" ]; then
    CONFIG=$(echo "$CONFIG" | jq ".maxParallel = $MAX_PARALLEL")
fi

if [ -n "$TIMEOUT" ]; then
    TIMEOUT_SECONDS=$((TIMEOUT * 60))
    CONFIG=$(echo "$CONFIG" | jq ".timeout = $TIMEOUT_SECONDS")
fi

# Apply filter if specified
if [ -n "$FILTER" ]; then
    echo -e "${YELLOW}Applying filter: $FILTER${NC}"
    AGENTS=$(echo "$AGENTS" | jq "[.[] | select(.id | test(\"$FILTER\"))]")
    
    FILTERED_COUNT=$(echo "$AGENTS" | jq '. | length')
    echo -e "${GREEN}Filtered to $FILTERED_COUNT agents${NC}"
fi

# Show what would be executed
AGENT_COUNT=$(echo "$AGENTS" | jq '. | length')
MAX_PARALLEL_VAL=$(echo "$CONFIG" | jq -r '.maxParallel')
TIMEOUT_VAL=$(echo "$CONFIG" | jq -r '.timeout')

echo ""
echo "Execution Plan:"
echo "- Agents: $AGENT_COUNT"
echo "- Max Parallel: $MAX_PARALLEL_VAL"
echo "- Timeout: ${TIMEOUT_VAL}s"
echo ""

if [ "$DRY_RUN" = true ]; then
    echo -e "${YELLOW}Dry run mode - showing agents that would execute:${NC}"
    echo "$AGENTS" | jq -r '.[] | "  - \(.id): \(.command)"'
    echo ""
    echo -e "${GREEN}Dry run complete. No tests were executed.${NC}"
    exit 0
fi

# Execute tests
echo -e "${YELLOW}Executing tests...${NC}"
echo ""

# Create results file
RESULTS_FILE="/tmp/test-results-$$.json"

# Run orchestrator
bash "$ORCHESTRATOR_SCRIPT" \
    "$AGENTS" \
    "$MAX_PARALLEL_VAL" \
    "$TIMEOUT_VAL" \
    "$UPDATE_PLAN" \
    "$PLAN_PATH"

ORCHESTRATOR_EXIT_CODE=$?

# Update test plan if enabled and results exist
if [ "$UPDATE_PLAN" = "true" ] && [ -f "$RESULTS_FILE" ]; then
    echo ""
    echo -e "${YELLOW}Updating test plan...${NC}"
    node "$UPDATER_SCRIPT" "$PLAN_PATH" "$RESULTS_FILE"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Test plan updated successfully${NC}"
    else
        echo -e "${RED}Warning: Failed to update test plan${NC}"
    fi
    
    # Cleanup results file
    rm -f "$RESULTS_FILE"
fi

# Exit with orchestrator's exit code
exit $ORCHESTRATOR_EXIT_CODE