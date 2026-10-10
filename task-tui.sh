#!/bin/bash

# Task TUI - Terminal-based task management application
# Main entry point

set -euo pipefail

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source required modules
source "${SCRIPT_DIR}/config.sh"
source "${SCRIPT_DIR}/lib/db.sh"
source "${SCRIPT_DIR}/lib/tasks.sh"
source "${SCRIPT_DIR}/lib/timer.sh"
source "${SCRIPT_DIR}/lib/alarms.sh"
source "${SCRIPT_DIR}/lib/reports.sh"
source "${SCRIPT_DIR}/ui/colors.sh"
source "${SCRIPT_DIR}/ui/menu.sh"
source "${SCRIPT_DIR}/ui/dashboard.sh"

# Initialize database
init_db

# Handle add task
handle_add_task() {
    add_task
}

# Handle edit task
handle_edit_task() {
    local task_id=$(select_task_interactive "pending")
    [[ -z "$task_id" ]] && return

    local edit_choice=$(show_edit_menu)

    case "$edit_choice" in
        "✏️  Edit Title")
            local new_title=$(echo "" | dmenu -p "New title:")
            [[ -n "$new_title" ]] && update_task "$task_id" "title" "$new_title"
            ;;
        "📝 Edit Description")
            local new_desc=$(echo "" | dmenu -p "New description:")
            [[ -n "$new_desc" ]] && update_task "$task_id" "description" "$new_desc"
            ;;
        "🎯 Edit Priority")
            local new_priority=$(printf "low\nmedium\nhigh" | dmenu -p "Priority:")
            [[ -n "$new_priority" ]] && update_task "$task_id" "priority" "$new_priority"
            ;;
        "📅 Edit Due Date")
            local new_date=$(echo "" | dmenu -p "Due date (YYYY-MM-DD):")
            if [[ -n "$new_date" ]]; then
                if date -d "$new_date" >/dev/null 2>&1; then
                    update_task "$task_id" "due_date" "$new_date"
                else
                    print_error "Invalid date format"
                fi
            fi
            ;;
    esac
}

# Handle complete task
handle_complete_task() {
    local task_id=$(select_task_interactive "pending")
    [[ -z "$task_id" ]] && complete_task "$task_id"
}

# Handle delete task
handle_delete_task() {
    local task_id=$(select_task_interactive)
    if [[ -n "$task_id" ]]; then
        local confirm=$(printf "Yes\nNo" | dmenu -p "Delete task #${task_id}?")
        [[ "$confirm" == "Yes" ]] && delete_task "$task_id"
    fi
}

# Handle view all tasks
handle_view_tasks() {
    st -e bash -c "
        source '${SCRIPT_DIR}/lib/db.sh'
        source '${SCRIPT_DIR}/lib/tasks.sh'
        source '${SCRIPT_DIR}/ui/colors.sh'

        print_header 'ALL TASKS'

        echo -e '${COLOR_CYAN}${COLOR_BOLD}Pending Tasks:${COLOR_RESET}\n'

        task_list=\$(list_tasks 'pending')
        if [[ -z \"\$task_list\" ]]; then
            echo -e '  ${COLOR_DIM}No pending tasks${COLOR_RESET}'
        else
            while IFS=\$'\t' read -r id title priority status due_date time_spent; do
                local priority_icon=\"\"
                case \"\$priority\" in
                    high) priority_icon=\"${COLOR_RED}🔴${COLOR_RESET}\" ;;
                    medium) priority_icon=\"${COLOR_YELLOW}🟡${COLOR_RESET}\" ;;
                    low) priority_icon=\"${COLOR_GREEN}🟢${COLOR_RESET}\" ;;
                esac

                local due_display=\"\"
                [[ -n \"\$due_date\" ]] && due_display=\" ${COLOR_DIM}(due: \${due_date})${COLOR_RESET}\"

                local time_display=\"\"
                if [[ \$time_spent -gt 0 ]]; then
                    local hours=\$((time_spent / 3600))
                    local minutes=\$(((time_spent % 3600) / 60))
                    time_display=\" ${COLOR_DIM}[\${hours}h \${minutes}m]${COLOR_RESET}\"
                fi

                echo -e \"  \${id}. \${priority_icon} \${title}\${due_display}\${time_display}\"
            done <<< \"\$task_list\"
        fi

        echo -e \"\n${COLOR_CYAN}${COLOR_BOLD}Completed Tasks:${COLOR_RESET}\n\"

        completed_list=\$(list_tasks 'completed')
        if [[ -z \"\$completed_list\" ]]; then
            echo -e '  ${COLOR_DIM}No completed tasks${COLOR_RESET}'
        else
            while IFS=\$'\t' read -r id title priority status due_date time_spent; do
                local time_display=\"\"
                if [[ \$time_spent -gt 0 ]]; then
                    local hours=\$((time_spent / 3600))
                    local minutes=\$(((time_spent % 3600) / 60))
                    time_display=\" ${COLOR_DIM}[\${hours}h \${minutes}m]${COLOR_RESET}\"
                fi

                echo -e \"  ${COLOR_GREEN}✅${COLOR_RESET} \${title}\${time_display}\"
            done <<< \"\$completed_list\"
        fi

        echo -e \"\n${COLOR_DIM}Press Enter to close...${COLOR_RESET}\"
        read -r
    "
}

# Handle timer submenu
handle_timer() {
    while true; do
        local timer_choice=$(show_timer_menu)

        case "$timer_choice" in
            "▶️  Start Timer")
                local task_id=$(select_task_interactive "pending")
                if [[ -z "$task_id" ]]; then
                    # Start timer without task
                    task_id=0
                fi
                start_timer "$task_id"
                ;;
            "⏸️  Pause Timer")
                pause_timer
                ;;
            "⏯️  Resume Timer")
                resume_timer
                ;;
            "⏹️  Stop Timer")
                stop_timer
                ;;
            "📊 Timer Status")
                st -e bash -c "
                    source '${SCRIPT_DIR}/config.sh'
                    source '${SCRIPT_DIR}/lib/timer.sh'
                    source '${SCRIPT_DIR}/ui/colors.sh'

                    print_header 'TIMER STATUS'
                    get_timer_status

                    echo -e \"\n${COLOR_DIM}Press Enter to close...${COLOR_RESET}\"
                    read -r
                "
                ;;
            "🔙 Back"|"")
                break
                ;;
        esac
    done
}

# Handle alarm submenu
handle_alarms() {
    while true; do
        local alarm_choice=$(show_alarm_menu)

        case "$alarm_choice" in
            "➕ Add Alarm")
                add_alarm
                ;;
            "📋 List Alarms")
                st -e bash -c "
                    source '${SCRIPT_DIR}/lib/db.sh'
                    source '${SCRIPT_DIR}/lib/alarms.sh'
                    source '${SCRIPT_DIR}/ui/colors.sh'

                    print_header 'PENDING ALARMS'

                    alarm_list=\$(list_alarms)
                    if [[ -z \"\$alarm_list\" ]]; then
                        echo -e '${COLOR_DIM}No pending alarms${COLOR_RESET}'
                    else
                        while IFS=\$'\t' read -r id title alarm_time status; do
                            echo -e \"  \${id}. ⏰ \${title} ${COLOR_DIM}[\${alarm_time}]${COLOR_RESET}\"
                        done <<< \"\$alarm_list\"
                    fi

                    echo -e \"\n${COLOR_DIM}Press Enter to close...${COLOR_RESET}\"
                    read -r
                "
                ;;
            "🗑️  Delete Alarm")
                local alarm_id=$(select_alarm_interactive)
                [[ -n "$alarm_id" ]] && delete_alarm "$alarm_id"
                ;;
            "🔙 Back"|"")
                break
                ;;
        esac
    done
}

# Handle weekly report
handle_weekly_report() {
    st -e bash -c "
        source '${SCRIPT_DIR}/config.sh'
        source '${SCRIPT_DIR}/lib/db.sh'
        source '${SCRIPT_DIR}/lib/reports.sh'
        source '${SCRIPT_DIR}/ui/colors.sh'

        generate_weekly_report

        echo -e \"${COLOR_DIM}Press Enter to close...${COLOR_RESET}\"
        read -r
    "
}

# Main loop
main() {
    while true; do
        choice=$(show_main_menu)

        case "$choice" in
            "📊 Today's Dashboard")
                show_dashboard
                ;;
            "➕ Add Task")
                handle_add_task
                ;;
            "✏️  Edit Task")
                handle_edit_task
                ;;
            "✅ Complete Task")
                handle_complete_task
                ;;
            "🗑️  Delete Task")
                handle_delete_task
                ;;
            "📋 View All Tasks")
                handle_view_tasks
                ;;
            "⏱️  Timer")
                handle_timer
                ;;
            "⏰ Alarms")
                handle_alarms
                ;;
            "📈 Weekly Report")
                handle_weekly_report
                ;;
            "❌ Exit"|"")
                print_info "Goodbye!"
                exit 0
                ;;
            *)
                print_error "Invalid option"
                ;;
        esac
    done
}

# Run main loop
main
