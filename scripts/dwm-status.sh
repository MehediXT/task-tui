#!/bin/bash

# DWM status bar integration
# This script outputs task statistics for the DWM status bar

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/config.sh"

# Check if database exists
if [[ ! -f "$DB_FILE" ]]; then
    echo ""
    exit 0
fi

# Get pending tasks count
PENDING_TASKS=$(sqlite3 "$DB_FILE" "SELECT COUNT(*) FROM tasks WHERE status = 'pending';")

# Get timer status
TIMER_STATUS=""
if [[ -f "$TIMER_FILE" ]]; then
    IFS=':' read -r start_time task_id state < "$TIMER_FILE"

    if [[ "$state" == "paused" ]]; then
        elapsed=$start_time
    else
        current_time=$(date +%s)
        elapsed=$((current_time - start_time))
    fi

    hours=$((elapsed / 3600))
    minutes=$(((elapsed % 3600) / 60))
    TIMER_STATUS="⏱️ ${hours}h${minutes}m "
fi

# Get upcoming alarms count
UPCOMING_ALARMS=$(sqlite3 "$DB_FILE" "SELECT COUNT(*) FROM alarms WHERE status = 'pending';")

# Output status
OUTPUT=""
[[ -n "$TIMER_STATUS" ]] && OUTPUT+="$TIMER_STATUS"
[[ $PENDING_TASKS -gt 0 ]] && OUTPUT+="📋 $PENDING_TASKS "
[[ $UPCOMING_ALARMS -gt 0 ]] && OUTPUT+="⏰ $UPCOMING_ALARMS "

echo "$OUTPUT"
