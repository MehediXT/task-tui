#!/bin/bash

# Stopwatch and time tracking

source "$(dirname "${BASH_SOURCE[0]}")/../config.sh"
source "$(dirname "${BASH_SOURCE[0]}")/../ui/colors.sh"

# Start stopwatch
start_timer() {
    local task_id="$1"

    if [[ -f "$TIMER_FILE" ]]; then
        print_warning "Timer already running. Stop it first."
        return 1
    fi

    local start_time=$(date +%s)
    echo "$start_time:$task_id:running" > "$TIMER_FILE"

    print_success "Timer started!"
    return 0
}

# Stop stopwatch
stop_timer() {
    if [[ ! -f "$TIMER_FILE" ]]; then
        print_warning "No timer running"
        return 1
    fi

    IFS=':' read -r start_time task_id state < "$TIMER_FILE"
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))

    # Add time to task if task_id is set
    if [[ -n "$task_id" && "$task_id" != "0" ]]; then
        source "$(dirname "${BASH_SOURCE[0]}")/tasks.sh"
        add_time_to_task "$task_id" "$duration"
    fi

    rm "$TIMER_FILE"

    # Format duration
    local hours=$((duration / 3600))
    local minutes=$(((duration % 3600) / 60))
    local seconds=$((duration % 60))

    print_success "Timer stopped! Duration: ${hours}h ${minutes}m ${seconds}s"
    return 0
}

# Pause stopwatch
pause_timer() {
    if [[ ! -f "$TIMER_FILE" ]]; then
        print_warning "No timer running"
        return 1
    fi

    IFS=':' read -r start_time task_id state < "$TIMER_FILE"

    if [[ "$state" == "paused" ]]; then
        print_warning "Timer already paused"
        return 1
    fi

    local pause_time=$(date +%s)
    local elapsed=$((pause_time - start_time))

    echo "$elapsed:$task_id:paused" > "$TIMER_FILE"
    print_success "Timer paused!"
    return 0
}

# Resume stopwatch
resume_timer() {
    if [[ ! -f "$TIMER_FILE" ]]; then
        print_warning "No timer running"
        return 1
    fi

    IFS=':' read -r elapsed task_id state < "$TIMER_FILE"

    if [[ "$state" != "paused" ]]; then
        print_warning "Timer is not paused"
        return 1
    fi

    local resume_time=$(date +%s)
    local new_start=$((resume_time - elapsed))

    echo "$new_start:$task_id:running" > "$TIMER_FILE"
    print_success "Timer resumed!"
    return 0
}

# Get timer status
get_timer_status() {
    if [[ ! -f "$TIMER_FILE" ]]; then
        echo "No timer running"
        return 1
    fi

    IFS=':' read -r start_time task_id state < "$TIMER_FILE"

    if [[ "$state" == "paused" ]]; then
        local elapsed=$start_time
    else
        local current_time=$(date +%s)
        local elapsed=$((current_time - start_time))
    fi

    local hours=$((elapsed / 3600))
    local minutes=$(((elapsed % 3600) / 60))
    local seconds=$((elapsed % 60))

    echo "Timer: ${hours}h ${minutes}m ${seconds}s [$state]"

    if [[ -n "$task_id" && "$task_id" != "0" ]]; then
        echo "Task ID: $task_id"
    fi

    return 0
}
