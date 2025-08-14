#!/bin/bash

# Parallel Test Orchestrator
# Parameter-driven test execution based on test plan

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
DEFAULT_MAX_PARALLEL=5
DEFAULT_TIMEOUT=300
DEFAULT_UPDATE_PLAN=true

# Accept parameters
AGENTS_JSON="${1}"
MAX_PARALLEL="${2:-$DEFAULT_MAX_PARALLEL}"
TIMEOUT="${3:-$DEFAULT_TIMEOUT}"
UPDATE_PLAN="${4:-$DEFAULT_UPDATE_PLAN}"
PLAN_PATH="${5:-tests/parallel-test-plan.md}"

# Validate inputs
if [ -z "$AGENTS_JSON" ]; then
    echo -e "${RED}Error: No agents JSON provided${NC}"
    echo "Usage: $0 <agents_json> [max_parallel] [timeout] [update_plan] [plan_path]"
    exit 1
fi

# Parse JSON to get agent count
AGENT_COUNT=$(echo "$AGENTS_JSON" | jq -r '. | length')

echo "=========================================="
echo "Parallel Test Orchestrator"
echo "=========================================="
echo "Agents: $AGENT_COUNT"
echo "Max Parallel: $MAX_PARALLEL"
echo "Timeout: ${TIMEOUT}s"
echo "Update Plan: $UPDATE_PLAN"
echo "Plan Path: $PLAN_PATH"
echo "=========================================="
echo ""

# Initialize tracking variables
declare -A agent_pids
declare -A agent_status
declare -A agent_start_time
declare -A agent_end_time
declare -A agent_output_files
declare -A agent_dependencies

# Parse agents and their dependencies
parse_agents() {
    local i=0
    while [ $i -lt "$AGENT_COUNT" ]; do
        local agent=$(echo "$AGENTS_JSON" | jq -r ".[$i]")
        local id=$(echo "$agent" | jq -r '.id')
        local deps=$(echo "$agent" | jq -r '.dependencies[]?' 2>/dev/null)
        
        agent_dependencies[$id]="$deps"
        agent_status[$id]="pending"
        agent_output_files[$id]="/tmp/test-${id}-$$.log"
        
        ((i++))
    done
}

# Check if agent dependencies are satisfied
dependencies_satisfied() {
    local agent_id="$1"
    local deps="${agent_dependencies[$agent_id]}"
    
    if [ -z "$deps" ]; then
        return 0
    fi
    
    for dep in $deps; do
        if [ "${agent_status[$dep]}" != "pass" ]; then
            return 1
        fi
    done
    
    return 0
}

# Execute a single test agent
execute_agent() {
    local agent="$1"
    local id=$(echo "$agent" | jq -r '.id')
    local command=$(echo "$agent" | jq -r '.command')
    local timeout=$(echo "$agent" | jq -r '.timeout // "5m"')
    local env_vars=$(echo "$agent" | jq -r '.env // {}')
    
    echo -e "${BLUE}[$(date '+%H:%M:%S')] Starting: $id${NC}"
    agent_status[$id]="running"
    agent_start_time[$id]=$(date +%s)
    
    # Build environment export commands
    local env_exports=""
    if [ "$env_vars" != "{}" ]; then
        env_exports=$(echo "$env_vars" | jq -r 'to_entries | .[] | "export \(.key)=\"\(.value)\""')
    fi
    
    # Execute with timeout and capture output
    (
        # Set environment variables
        if [ -n "$env_exports" ]; then
            eval "$env_exports"
        fi
        
        # Execute command with timeout
        timeout "$timeout" bash -c "$command" > "${agent_output_files[$id]}" 2>&1
    ) &
    
    local pid=$!
    agent_pids[$id]=$pid
    
    return 0
}

# Wait for an agent to complete
wait_for_agent() {
    local id="$1"
    local pid="${agent_pids[$id]}"
    
    if wait "$pid"; then
        agent_status[$id]="pass"
        echo -e "${GREEN}[$(date '+%H:%M:%S')] Passed: $id${NC}"
    else
        agent_status[$id]="fail"
        echo -e "${RED}[$(date '+%H:%M:%S')] Failed: $id${NC}"
        
        # Show last 5 lines of output for failed tests
        echo -e "${YELLOW}Last output from $id:${NC}"
        tail -5 "${agent_output_files[$id]}" | sed 's/^/  /'
    fi
    
    agent_end_time[$id]=$(date +%s)
    unset agent_pids[$id]
}

# Main execution loop
execute_all_agents() {
    local running_count=0
    local completed_count=0
    local i=0
    
    parse_agents
    
    while [ $completed_count -lt $AGENT_COUNT ]; do
        # Start new agents if we have capacity
        while [ $running_count -lt $MAX_PARALLEL ] && [ $i -lt $AGENT_COUNT ]; do
            local agent=$(echo "$AGENTS_JSON" | jq -r ".[$i]")
            local id=$(echo "$agent" | jq -r '.id')
            
            # Check if this agent is pending and dependencies are satisfied
            if [ "${agent_status[$id]}" = "pending" ] && dependencies_satisfied "$id"; then
                execute_agent "$agent"
                ((running_count++))
            fi
            
            ((i++))
        done
        
        # Reset counter if we've checked all agents
        if [ $i -ge $AGENT_COUNT ]; then
            i=0
        fi
        
        # Wait for any agent to complete
        if [ $running_count -gt 0 ]; then
            for id in "${!agent_pids[@]}"; do
                local pid="${agent_pids[$id]}"
                if ! kill -0 "$pid" 2>/dev/null; then
                    wait_for_agent "$id"
                    ((running_count--))
                    ((completed_count++))
                    break
                fi
            done
            
            # Small sleep to prevent CPU spinning
            sleep 0.1
        else
            # No agents running, check if we're stuck
            local pending_with_deps=0
            for id in "${!agent_status[@]}"; do
                if [ "${agent_status[$id]}" = "pending" ]; then
                    if ! dependencies_satisfied "$id"; then
                        ((pending_with_deps++))
                    fi
                fi
            done
            
            if [ $pending_with_deps -gt 0 ] && [ $completed_count -lt $AGENT_COUNT ]; then
                echo -e "${RED}Error: Dependency deadlock detected!${NC}"
                echo "Pending agents with unsatisfied dependencies: $pending_with_deps"
                break
            fi
            
            sleep 0.1
        fi
    done
}

# Generate execution summary
generate_summary() {
    local total_pass=0
    local total_fail=0
    local total_skip=0
    local total_duration=0
    
    echo ""
    echo "=========================================="
    echo "Execution Summary"
    echo "=========================================="
    
    for id in "${!agent_status[@]}"; do
        local status="${agent_status[$id]}"
        local start="${agent_start_time[$id]:-0}"
        local end="${agent_end_time[$id]:-0}"
        local duration=$((end - start))
        
        case "$status" in
            pass)
                ((total_pass++))
                ;;
            fail)
                ((total_fail++))
                ;;
            pending)
                ((total_skip++))
                ;;
        esac
        
        if [ $duration -gt 0 ]; then
            total_duration=$((total_duration + duration))
        fi
        
        printf "%-30s %-10s %ds\n" "$id" "$status" "$duration"
    done
    
    echo "=========================================="
    echo "Total: Pass=$total_pass, Fail=$total_fail, Skip=$total_skip"
    echo "Total Duration: ${total_duration}s"
    echo "=========================================="
    
    # Return JSON result for plan updater
    if [ "$UPDATE_PLAN" = "true" ]; then
        local run_id="run-$(date +%Y%m%d-%H%M%S)"
        local start_time=$(date -Iseconds)
        local end_time=$(date -Iseconds)
        
        cat > "/tmp/test-results-$$.json" <<EOF
{
  "runId": "$run_id",
  "startTime": "$start_time",
  "endTime": "$end_time",
  "duration": $total_duration,
  "pass": $total_pass,
  "fail": $total_fail,
  "skip": $total_skip,
  "agents": [
EOF
        
        local first=true
        for id in "${!agent_status[@]}"; do
            local status="${agent_status[$id]}"
            local start="${agent_start_time[$id]:-0}"
            local end="${agent_end_time[$id]:-0}"
            local duration=$((end - start))
            
            if [ "$first" = true ]; then
                first=false
            else
                echo "," >> "/tmp/test-results-$$.json"
            fi
            
            cat >> "/tmp/test-results-$$.json" <<EOF
    {
      "id": "$id",
      "status": "$status",
      "duration": $duration,
      "startTime": $start,
      "endTime": $end
    }
EOF
        done
        
        cat >> "/tmp/test-results-$$.json" <<EOF
  ]
}
EOF
        
        echo ""
        echo "Results saved to: /tmp/test-results-$$.json"
    fi
    
    # Cleanup output files
    for file in "${agent_output_files[@]}"; do
        rm -f "$file"
    done
}

# Signal handler for cleanup
cleanup() {
    echo -e "\n${YELLOW}Interrupted! Cleaning up...${NC}"
    
    # Kill all running agents
    for pid in "${agent_pids[@]}"; do
        kill "$pid" 2>/dev/null || true
    done
    
    # Cleanup output files
    for file in "${agent_output_files[@]}"; do
        rm -f "$file"
    done
    
    exit 1
}

trap cleanup INT TERM

# Main execution
execute_all_agents
generate_summary

# Exit with failure if any tests failed
if [ $total_fail -gt 0 ]; then
    exit 1
fi

exit 0