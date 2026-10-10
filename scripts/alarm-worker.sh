#!/bin/bash

# Background alarm worker
# This script runs in the background and checks for due alarms every minute

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../config.sh"
source "${SCRIPT_DIR}/../lib/alarms.sh"

# Function to send notification
send_notification() {
    local title="$1"
    local message="$2"

    if command -v notify-send &>/dev/null; then
        notify-send -u critical "$title" "$message"
    fi
}

# Main loop
while true; do
    # Check for due alarms
    due_alarms=$(get_due_alarms)

    if [[ -n "$due_alarms" ]]; then
        while IFS=$'\t' read -r id title alarm_time; do
            # Send notification
            send_notification "⏰ Alarm" "$title"

            # Mark alarm as triggered
            trigger_alarm "$id"
        done <<< "$due_alarms"
    fi

    # Sleep for 60 seconds
    sleep 60
done
