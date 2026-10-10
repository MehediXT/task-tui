#!/bin/bash

# Terminal dashboard

source "$(dirname "${BASH_SOURCE[0]}")/../lib/tasks.sh"
source "$(dirname "${BASH_SOURCE[0]}")/../lib/timer.sh"
source "$(dirname "${BASH_SOURCE[0]}")/../lib/reports.sh"
source "$(dirname "${BASH_SOURCE[0]}")/colors.sh"

# Display today's dashboard
show_dashboard() {
    clear

    print_header "TODAY'S DASHBOARD"

    # Show date
    echo -e "${COLOR_BOLD}$(date '+%A, %B %d, %Y')${COLOR_RESET}\n"

    # Timer status
    echo -e "${COLOR_CYAN}⏱️  Timer Status:${COLOR_RESET}"
    get_timer_status 2>/dev/null || echo "  No timer running"
    echo ""

    # Today's tasks
    echo -e "${COLOR_CYAN}📋 Today's Tasks:${COLOR_RESET}"
    local today_tasks=$(get_today_tasks)

    if [[ -z "$today_tasks" ]]; then
        echo -e "  ${COLOR_DIM}No tasks for today${COLOR_RESET}"
    else
        while IFS=$'\t' read -r id title priority status time_spent; do
            local priority_icon=""
            case "$priority" in
                high) priority_icon="${COLOR_RED}🔴${COLOR_RESET}" ;;
                medium) priority_icon="${COLOR_YELLOW}🟡${COLOR_RESET}" ;;
                low) priority_icon="${COLOR_GREEN}🟢${COLOR_RESET}" ;;
            esac

            local status_icon=""
            if [[ "$status" == "completed" ]]; then
                status_icon="${COLOR_GREEN}✅${COLOR_RESET}"
            else
                status_icon="⬜"
            fi

            local time_display=""
            if [[ $time_spent -gt 0 ]]; then
                local hours=$((time_spent / 3600))
                local minutes=$(((time_spent % 3600) / 60))
                time_display=" ${COLOR_DIM}[${hours}h ${minutes}m]${COLOR_RESET}"
            fi

            echo -e "  $status_icon $priority_icon ${title}${time_display}"
        done <<< "$today_tasks"
    fi

    echo ""

    # Overdue tasks
    local overdue=$(get_overdue_tasks)
    if [[ -n "$overdue" ]]; then
        echo -e "${COLOR_RED}${COLOR_BOLD}⚠️  Overdue Tasks:${COLOR_RESET}"
        while IFS=$'\t' read -r id title priority due_date; do
            echo -e "  ${COLOR_RED}🔴${COLOR_RESET} ${title} ${COLOR_DIM}(due: ${due_date})${COLOR_RESET}"
        done <<< "$overdue"
        echo ""
    fi

    # Daily summary
    generate_daily_summary

    echo -e "\n${COLOR_DIM}Press Enter to continue...${COLOR_RESET}"
    read -r
}
