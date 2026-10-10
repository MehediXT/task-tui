#!/bin/bash

# Weekly productivity reports

source "$(dirname "${BASH_SOURCE[0]}")/db.sh"
source "$(dirname "${BASH_SOURCE[0]}")/../ui/colors.sh"

# Generate weekly report
generate_weekly_report() {
    local week_start=$(date -d 'last monday' '+%Y-%m-%d')
    local week_end=$(date -d 'next sunday' '+%Y-%m-%d')

    print_header "WEEKLY PRODUCTIVITY REPORT"
    echo -e "${COLOR_BOLD}Week: $week_start to $week_end${COLOR_RESET}\n"

    # Tasks completed this week
    local completed_query="SELECT COUNT(*) FROM tasks WHERE status = 'completed' AND completed_at >= '$week_start' AND completed_at <= '$week_end';"
    local completed_count=$(db_query "$completed_query")

    # Tasks created this week
    local created_query="SELECT COUNT(*) FROM tasks WHERE created_at >= '$week_start' AND created_at <= '$week_end';"
    local created_count=$(db_query "$created_query")

    # Total time spent this week
    local time_query="SELECT COALESCE(SUM(time_spent), 0) FROM tasks WHERE completed_at >= '$week_start' AND completed_at <= '$week_end';"
    local total_time=$(db_query "$time_query")

    # Format time
    local hours=$((total_time / 3600))
    local minutes=$(((total_time % 3600) / 60))

    echo -e "${COLOR_CYAN}📊 Statistics:${COLOR_RESET}"
    echo -e "  Tasks created:   ${COLOR_BOLD}$created_count${COLOR_RESET}"
    echo -e "  Tasks completed: ${COLOR_BOLD}${COLOR_GREEN}$completed_count${COLOR_RESET}"
    echo -e "  Time tracked:    ${COLOR_BOLD}${hours}h ${minutes}m${COLOR_RESET}"

    # Calculate completion rate
    if [[ $created_count -gt 0 ]]; then
        local completion_rate=$((completed_count * 100 / created_count))
        echo -e "  Completion rate: ${COLOR_BOLD}${completion_rate}%${COLOR_RESET}"
    fi

    echo ""

    # Tasks by priority
    echo -e "${COLOR_CYAN}📈 Completed by Priority:${COLOR_RESET}"
    local priority_query="SELECT priority, COUNT(*) FROM tasks WHERE status = 'completed' AND completed_at >= '$week_start' AND completed_at <= '$week_end' GROUP BY priority;"

    while IFS='|' read -r priority count; do
        case "$priority" in
            high) echo -e "  🔴 High:   $count" ;;
            medium) echo -e "  🟡 Medium: $count" ;;
            low) echo -e "  🟢 Low:    $count" ;;
        esac
    done < <(db_query "$priority_query")

    echo ""

    # Top 5 tasks by time spent
    echo -e "${COLOR_CYAN}⏱️  Top Tasks by Time:${COLOR_RESET}"
    local top_tasks_query="SELECT title, time_spent FROM tasks WHERE completed_at >= '$week_start' AND completed_at <= '$week_end' AND time_spent > 0 ORDER BY time_spent DESC LIMIT 5;"

    local counter=1
    while IFS='|' read -r title time_spent; do
        local task_hours=$((time_spent / 3600))
        local task_minutes=$(((time_spent % 3600) / 60))
        echo -e "  ${counter}. ${title} (${task_hours}h ${task_minutes}m)"
        ((counter++))
    done < <(db_query "$top_tasks_query")

    echo ""
}

# Generate daily summary
generate_daily_summary() {
    local today=$(date '+%Y-%m-%d')

    print_header "TODAY'S SUMMARY"
    echo -e "${COLOR_BOLD}Date: $today${COLOR_RESET}\n"

    # Tasks completed today
    local completed_query="SELECT COUNT(*) FROM tasks WHERE status = 'completed' AND DATE(completed_at) = '$today';"
    local completed_count=$(db_query "$completed_query")

    # Pending tasks
    local pending_query="SELECT COUNT(*) FROM tasks WHERE status = 'pending';"
    local pending_count=$(db_query "$pending_query")

    # Time spent today
    local time_query="SELECT COALESCE(SUM(time_spent), 0) FROM tasks WHERE DATE(completed_at) = '$today';"
    local total_time=$(db_query "$time_query")

    local hours=$((total_time / 3600))
    local minutes=$(((total_time % 3600) / 60))

    echo -e "${COLOR_CYAN}📊 Statistics:${COLOR_RESET}"
    echo -e "  Completed today: ${COLOR_BOLD}${COLOR_GREEN}$completed_count${COLOR_RESET}"
    echo -e "  Pending tasks:   ${COLOR_BOLD}${COLOR_YELLOW}$pending_count${COLOR_RESET}"
    echo -e "  Time tracked:    ${COLOR_BOLD}${hours}h ${minutes}m${COLOR_RESET}"

    echo ""
}
