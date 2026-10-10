#!/bin/bash

# Task management functions

source "$(dirname "${BASH_SOURCE[0]}")/db.sh"
source "$(dirname "${BASH_SOURCE[0]}")/../ui/colors.sh"

# Add a new task
add_task() {
    local title priority due_date description

    # Get task title
    title=$(echo "" | dmenu -p "Task title:")
    [[ -z "$title" ]] && return 1

    # Get priority
    priority=$(printf "low\nmedium\nhigh" | dmenu -p "Priority:")
    [[ -z "$priority" ]] && priority="medium"

    # Get due date (optional)
    due_date=$(echo "" | dmenu -p "Due date (YYYY-MM-DD, leave empty for none):")

    # Get description (optional)
    description=$(echo "" | dmenu -p "Description (optional):")

    # Validate due date format if provided
    if [[ -n "$due_date" ]]; then
        if ! date -d "$due_date" >/dev/null 2>&1; then
            print_error "Invalid date format"
            return 1
        fi
    fi

    # Insert into database
    local query="INSERT INTO tasks (title, description, priority, due_date) VALUES ('${title//\'/\'\'}', '${description//\'/\'\'}', '$priority', "

    if [[ -n "$due_date" ]]; then
        query+="'$due_date');"
    else
        query+="NULL);"
    fi

    if db_query "$query"; then
        print_success "Task added successfully!"
        return 0
    else
        print_error "Failed to add task"
        return 1
    fi
}

# List all tasks
list_tasks() {
    local status="$1"
    local query="SELECT id, title, priority, status, due_date, time_spent FROM tasks"

    if [[ "$status" == "pending" ]]; then
        query+=" WHERE status = 'pending'"
    elif [[ "$status" == "completed" ]]; then
        query+=" WHERE status = 'completed'"
    fi

    query+=" ORDER BY CASE priority WHEN 'high' THEN 1 WHEN 'medium' THEN 2 WHEN 'low' THEN 3 END, due_date;"

    db_query_rows "$query"
}

# Get task by ID
get_task() {
    local task_id="$1"
    local query="SELECT id, title, description, priority, status, due_date, created_at, completed_at, time_spent FROM tasks WHERE id = $task_id;"
    db_query_rows "$query"
}

# Mark task as completed
complete_task() {
    local task_id="$1"
    local query="UPDATE tasks SET status = 'completed', completed_at = datetime('now') WHERE id = $task_id;"

    if db_query "$query"; then
        print_success "Task marked as completed!"
        return 0
    else
        print_error "Failed to complete task"
        return 1
    fi
}

# Delete a task
delete_task() {
    local task_id="$1"
    local query="DELETE FROM tasks WHERE id = $task_id;"

    if db_query "$query"; then
        print_success "Task deleted successfully!"
        return 0
    else
        print_error "Failed to delete task"
        return 1
    fi
}

# Update task
update_task() {
    local task_id="$1"
    local field="$2"
    local value="$3"

    local query="UPDATE tasks SET $field = '${value//\'/\'\'}' WHERE id = $task_id;"

    if db_query "$query"; then
        print_success "Task updated successfully!"
        return 0
    else
        print_error "Failed to update task"
        return 1
    fi
}

# Get overdue tasks
get_overdue_tasks() {
    local today=$(date +${DATE_FORMAT})
    local query="SELECT id, title, priority, due_date FROM tasks WHERE status = 'pending' AND due_date IS NOT NULL AND due_date < '$today' ORDER BY due_date;"
    db_query_rows "$query"
}

# Get today's tasks
get_today_tasks() {
    local today=$(date +${DATE_FORMAT})
    local query="SELECT id, title, priority, status, time_spent FROM tasks WHERE due_date = '$today' OR (status = 'pending' AND due_date IS NULL) ORDER BY CASE priority WHEN 'high' THEN 1 WHEN 'medium' THEN 2 WHEN 'low' THEN 3 END;"
    db_query_rows "$query"
}

# Add time to task
add_time_to_task() {
    local task_id="$1"
    local seconds="$2"

    local query="UPDATE tasks SET time_spent = time_spent + $seconds WHERE id = $task_id;"
    db_query "$query"
}

# Select task interactively
select_task_interactive() {
    local status="$1"
    local task_list=$(list_tasks "$status")

    if [[ -z "$task_list" ]]; then
        print_warning "No tasks found"
        return 1
    fi

    # Format tasks for dmenu
    local formatted_tasks=""
    while IFS=$'\t' read -r id title priority status due_date time_spent; do
        local priority_icon=""
        case "$priority" in
            high) priority_icon="🔴" ;;
            medium) priority_icon="🟡" ;;
            low) priority_icon="🟢" ;;
        esac

        local time_display=""
        if [[ $time_spent -gt 0 ]]; then
            local hours=$((time_spent / 3600))
            local minutes=$(((time_spent % 3600) / 60))
            time_display=" [${hours}h ${minutes}m]"
        fi

        formatted_tasks+="${id}. ${priority_icon} ${title} ${due_date:+[${due_date}]}${time_display}\n"
    done <<< "$task_list"

    local selected=$(echo -e "$formatted_tasks" | dmenu -l 10 -p "Select task:")

    if [[ -n "$selected" ]]; then
        echo "$selected" | grep -oP '^\d+'
        return 0
    fi

    return 1
}
