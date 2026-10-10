# Task TUI Quick Start Guide

Get started with Task TUI in 5 minutes.

## Installation

```bash
# From the project directory
./install.sh

# Or manually
chmod +x task-tui.sh
./task-tui.sh
```

## Basic Usage

### Launch Task TUI
```bash
./task-tui.sh
# or if installed: task-tui
```

### Navigate the Menu

Task TUI uses **dmenu** for keyboard-driven navigation:
- Type to filter options
- Arrow keys or `Ctrl+n`/`Ctrl+p` to navigate
- `Enter` to select
- `Esc` to cancel

## Common Tasks

### Add Your First Task

1. Select `➕ Add Task`
2. Enter task title (e.g., "Write documentation")
3. Choose priority: `low`, `medium`, or `high`
4. Set due date: `YYYY-MM-DD` format (or leave empty)
5. Add description (optional)

### View Today's Dashboard

Select `📊 Today's Dashboard` to see:
- Timer status
- Today's tasks
- Overdue tasks
- Daily summary

### Complete a Task

1. Select `✅ Complete Task`
2. Pick the task from the list
3. Task is marked as completed with timestamp

### Track Time on a Task

1. Select `⏱️  Timer`
2. Choose `▶️  Start Timer`
3. Select a task (or press Esc for standalone timer)
4. Work on your task
5. Return to timer menu and choose `⏹️  Stop Timer`

Time is automatically recorded with the task!

### Set an Alarm

1. Select `⏰ Alarms`
2. Choose `➕ Add Alarm`
3. Enter alarm title (e.g., "Team meeting")
4. Set time: `YYYY-MM-DD HH:MM` format
5. Get desktop notification when it triggers

### View Weekly Report

Select `📈 Weekly Report` to see:
- Tasks completed this week
- Time tracked
- Completion rate
- Priority breakdown
- Top tasks by time spent

## Keyboard Shortcuts

When viewing dashboards or reports in the terminal:
- `Enter` - Close and return to menu
- `Ctrl+C` - Exit immediately

In dmenu:
- `Ctrl+n` or `Down` - Next item
- `Ctrl+p` or `Up` - Previous item
- `Ctrl+u` - Clear input
- `Esc` - Cancel

## Tips and Tricks

### Priorities
- **High** 🔴: Urgent, important tasks
- **Medium** 🟡: Regular tasks (default)
- **Low** 🟢: Nice-to-have tasks

### Due Dates
- Set realistic due dates
- Check dashboard daily for overdue tasks
- Leave empty for flexible tasks

### Time Tracking
- Start timer when beginning work
- Pause (`⏸️`) when taking breaks
- Resume (`⏯️`) to continue
- Stop (`⏹️`) when done
- View total time in task list

### Editing Tasks
1. Select `✏️  Edit Task`
2. Choose the task
3. Pick what to edit:
   - Title
   - Description
   - Priority
   - Due Date

### Background Alarm Worker

For alarms to trigger automatically, start the alarm worker:

```bash
nohup ./scripts/alarm-worker.sh >/dev/null 2>&1 &
```

Or let the install script do it for you!

## Workflow Example

Here's a sample daily workflow:

**Morning:**
1. Launch Task TUI
2. View `📊 Today's Dashboard`
3. Add new tasks for the day
4. Set priorities

**During Work:**
1. Open Task TUI
2. Start `⏱️  Timer` on first task
3. Work focused
4. Stop timer when task complete
5. Mark task as `✅ Complete`
6. Repeat for next task

**End of Day:**
1. Review completed tasks
2. Check overdue items
3. Plan tomorrow's tasks

**Weekly:**
1. Review `📈 Weekly Report`
2. Analyze productivity
3. Adjust priorities and habits

## Troubleshooting

**Task TUI won't launch**
- Check dependencies: `bash`, `sqlite3`, `dmenu`, `notify-send`
- Install on Arch: `sudo pacman -S bash sqlite libnotify dmenu`

**dmenu doesn't appear**
- Make sure you're in a graphical environment (X11)
- Test dmenu: `echo "test" | dmenu`

**Notifications don't work**
- Install a notification daemon (e.g., `dunst`)
- Test: `notify-send "Test" "Hello"`

**Database errors**
- Check data directory: `~/.local/share/task-tui/`
- Reinitialize: delete `tasks.db` and run Task TUI again

## Data Location

All data is stored locally:
- **Database**: `~/.local/share/task-tui/tasks.db`
- **Timer state**: `~/.local/share/task-tui/timer_state`
- **Worker PID**: `~/.local/share/task-tui/alarm_worker.pid`

## Next Steps

- Read [README.md](README.md) for full documentation
- See [DWM_INTEGRATION.md](DWM_INTEGRATION.md) for DWM setup
- Run tests: `./tests/run_tests.sh`
- Check project structure for customization

**Happy task tracking! 🚀**
