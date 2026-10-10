#!/bin/bash

# Alarm management

source "$(dirname "${BASH_SOURCE[0]}")/db.sh"
source "$(dirname "${BASH_SOURCE[0]}")/../ui/colors.sh"

# Add an alarm
add_alarm() {
    local title alarm_time

    # Get alarm title
    title=$(echo "" | dmenu -p "Alarm title:")
    [[ -z "$title" ]] && return 1

    # Get alarm time
    alarm_time=$(echo "" | dmenu -p "Alarm time (YYYY-MM-DD HH:MM):")
    [[ -z "$alarm_time" ]] && return 1

    # Validate time format
    if ! date -d "$alarm_time" >/dev/null 2>&1; then
        print_error "Invalid date/time format"
        return 1
    fi

    # Convert to SQLite format
    local formatted_time=$(date -d "$alarm_time" '+%Y-%m-%d %H:%M:%S')

    # Insert into database
    local query="INSERT INTO alarms (title, alarm_time) VALUES ('${title//\'/\'\'}', '$formatted_time');"

    if db_query "$query"; then
        print_success "Alarm added successfully!"
        return 0
    else
        print_error "Failed to add alarm"
        return 1
    fi
}

# List pending alarms
list_alarms() {
    local query="SELECT id, title, alarm_time, status FROM alarms WHERE status = 'pending' ORDER BY alarm_time;"
    db_query_rows "$query"
}

# Delete an alarm
delete_alarm() {
    local alarm_id="$1"
    local query="DELETE FROM alarms WHERE id = $alarm_id;"

    if db_query "$query"; then
        print_success "Alarm deleted successfully!"
        return 0
    else
        print_error "Failed to delete alarm"
        return 1
    fi
}

# Get due alarms
get_due_alarms() {
    local current_time=$(date '+%Y-%m-%d %H:%M:%S')
    local query="SELECT id, title, alarm_time FROM alarms WHERE status = 'pending' AND alarm_time <= '$current_time';"
    db_query_rows "$query"
}

# Trigger alarm
trigger_alarm() {
    local alarm_id="$1"
    local query="UPDATE alarms SET status = 'triggered' WHERE id = $alarm_id;"
    db_query "$query"
}

# Select alarm interactively
select_alarm_interactive() {
    local alarm_list=$(list_alarms)

    if [[ -z "$alarm_list" ]]; then
        print_warning "No alarms found"
        return 1
    fi

    # Format alarms for dmenu
    local formatted_alarms=""
    while IFS=$'\t' read -r id title alarm_time status; do
        formatted_alarms+="${id}. ${title} [${alarm_time}]\n"
    done <<< "$alarm_list"

    local selected=$(echo -e "$formatted_alarms" | dmenu -l 10 -p "Select alarm:")

    if [[ -n "$selected" ]]; then
        echo "$selected" | grep -oP '^\d+'
        return 0
    fi

    return 1
}
