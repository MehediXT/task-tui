#!/bin/bash

# dmenu integration

# Show main menu
show_main_menu() {
    local options=(
        "📊 Today's Dashboard"
        "➕ Add Task"
        "✏️  Edit Task"
        "✅ Complete Task"
        "🗑️  Delete Task"
        "📋 View All Tasks"
        "⏱️  Timer"
        "⏰ Alarms"
        "📈 Weekly Report"
        "❌ Exit"
    )

    printf "%s\n" "${options[@]}" | dmenu -i -l 10 -p "Task TUI:"
}

# Show timer submenu
show_timer_menu() {
    local options=(
        "▶️  Start Timer"
        "⏸️  Pause Timer"
        "⏯️  Resume Timer"
        "⏹️  Stop Timer"
        "📊 Timer Status"
        "🔙 Back"
    )

    printf "%s\n" "${options[@]}" | dmenu -i -l 6 -p "Timer:"
}

# Show alarm submenu
show_alarm_menu() {
    local options=(
        "➕ Add Alarm"
        "📋 List Alarms"
        "🗑️  Delete Alarm"
        "🔙 Back"
    )

    printf "%s\n" "${options[@]}" | dmenu -i -l 4 -p "Alarms:"
}

# Show edit submenu
show_edit_menu() {
    local options=(
        "✏️  Edit Title"
        "📝 Edit Description"
        "🎯 Edit Priority"
        "📅 Edit Due Date"
        "🔙 Back"
    )

    printf "%s\n" "${options[@]}" | dmenu -i -l 5 -p "Edit Task:"
}
