# Task TUI

A lightweight terminal-based productivity and task management application built with **Bash, SQLite, and dmenu** for Linux.

Task TUI aims to provide a keyboard-driven workflow for managing daily tasks, tracking time, setting reminders, and reviewing weekly productivity — without leaving the Linux desktop environment.

The project is being developed as a hands-on Bash scripting learning project, with an emphasis on Linux internals, shell automation, and Suckless tools.

## Features

### Implemented Features

* [x] Interactive menu using `dmenu`
* [x] Basic Bash menu and action handling
* [x] Add, view, edit, and delete tasks
* [x] Mark tasks as completed
* [x] Set task priorities and due dates
* [x] SQLite database for persistent storage
* [x] Today's productivity dashboard
* [x] Overdue task tracking
* [x] Stopwatch with pause and resume
* [x] Task-based time tracking
* [x] Scheduled alarms and desktop notifications
* [x] Weekly productivity reports
* [x] DWM keyboard shortcut integration
* [x] Optional DWM status bar integration

### Future Enhancements

* [ ] Task categories/tags
* [ ] Export/import tasks (JSON, CSV)
* [ ] Task search and filtering
* [ ] Recurring tasks
* [ ] Task dependencies
* [ ] Multiple task lists/projects
* [ ] Data backup and restore
* [ ] Configuration file for customization

*The checklist reflects development progress and should be updated as features are implemented and tested.*

## Tech Stack

| Technology    | Purpose                                 |
| ------------- | --------------------------------------- |
| Bash          | Application logic and automation        |
| dmenu         | Keyboard-driven menus and quick actions |
| st            | Terminal interface                      |
| SQLite        | Persistent data storage                 |
| `notify-send` | Desktop notifications                   |
| DWM           | Window manager integration              |
| Git           | Version control                         |

## Project Structure

```text
task-tui/
├── task-tui.sh          # Main application entry point
├── config.sh            # Application configuration
├── lib/
│   ├── db.sh             # Database operations
│   ├── tasks.sh          # Task management
│   ├── timer.sh          # Stopwatch and time tracking
│   ├── alarms.sh         # Alarm management
│   └── reports.sh        # Weekly reports
├── ui/
│   ├── menu.sh           # dmenu integration
│   ├── dashboard.sh      # Terminal dashboard
│   └── colors.sh         # Terminal colors and formatting
├── scripts/
│   └── alarm-worker.sh   # Background alarm worker
├── tests/                # Tests
├── data/                 # Local development database
├── .gitignore
└── README.md
```

*This is the intended structure. Files and directories will be added as development progresses.*

## Requirements

* Linux
* Bash
* dmenu
* A compatible terminal emulator, such as st
* SQLite CLI (`sqlite3`)
* `libnotify` for desktop notifications
* DWM for the planned window manager integration
* Git (optional, but recommended)

On Arch Linux, install the main dependencies with:

```bash
sudo pacman -S bash dmenu st sqlite libnotify git
```

If you already built `dmenu`, `st`, or DWM from source, use your existing Suckless setup rather than reinstalling them unnecessarily.

## Installation

### Quick Install

Run the installation script:

```bash
./install.sh
```

This will:
- Check for required dependencies
- Create the data directory
- Initialize the database
- Create a launcher in `~/.local/bin/task-tui`
- Optionally start the alarm worker

### Manual Installation

1. **Clone the repository** (or navigate to your existing directory)

```bash
git clone <YOUR_REPOSITORY_URL>
cd task-tui
```

2. **Install dependencies** (if not already installed)

```bash
sudo pacman -S bash sqlite libnotify dmenu st
```

3. **Make scripts executable**

```bash
chmod +x task-tui.sh install.sh scripts/*.sh
```

4. **Run Task TUI**

```bash
./task-tui.sh
```

Or create a symlink for system-wide access:

```bash
mkdir -p ~/.local/bin
ln -sf "$(pwd)/task-tui.sh" ~/.local/bin/task-tui
```

### DWM Integration

For DWM keyboard shortcuts and status bar integration, see [DWM_INTEGRATION.md](DWM_INTEGRATION.md)

## Usage

### Launching

Run from the project directory:
```bash
./task-tui.sh
```

Or if installed system-wide:
```bash
task-tui
```

Or with a DWM keyboard shortcut (see [DWM_INTEGRATION.md](DWM_INTEGRATION.md))

### Features

**Task Management**
- Add new tasks with title, description, priority, and due date
- Edit existing tasks
- Mark tasks as completed
- Delete tasks
- View all tasks sorted by priority

**Dashboard**
- See today's tasks at a glance
- View timer status
- Check overdue tasks
- Daily productivity summary

**Time Tracking**
- Start/stop/pause/resume timer
- Track time per task or standalone
- View time spent on completed tasks

**Alarms**
- Set alarms with date and time
- Desktop notifications when alarms trigger
- Background worker monitors alarms continuously

**Reports**
- Weekly productivity reports
- Task completion statistics
- Time tracking summaries
- Priority breakdown

## Development

### Running Tests

Run the test suite:

```bash
./tests/run_tests.sh
```

This checks:
- Dependencies
- File structure
- Bash syntax
- Database operations
- Task operations

### Syntax Checking

Check scripts for syntax errors:

```bash
bash -n task-tui.sh
bash -n lib/*.sh
bash -n ui/*.sh
```

### Debugging

Run with execution tracing:

```bash
bash -x task-tui.sh
```

### Contributing

1. Test your changes with `./tests/run_tests.sh`
2. Check syntax with `bash -n <file>`
3. Update documentation if needed
4. Commit with descriptive messages:

```bash
git add .
git commit -m "Add feature: brief description"
```

## Data and Privacy

Task TUI is designed to store task and productivity data locally.

* Task data will be stored in SQLite.
* Database files should not be committed to Git.
* Personal task information should remain on the local machine unless you explicitly add an export or synchronization feature.

The database location and backup strategy will be finalized as the project develops.

## Design Principles

* **Keyboard-first:** minimize mouse interaction.
* **Lightweight:** prefer Bash and existing Linux utilities.
* **Modular:** separate database, task logic, and user interface code.
* **Local-first:** store personal data locally.
* **Understandable:** keep the implementation readable and maintainable.
* **Suckless-inspired:** favor simple tools that do one job well.

## Learning Goals

This project is also a practical way to learn:

* Bash variables, arrays, functions, loops, and conditionals
* Pipes, command substitution, quoting, and exit statuses
* Input validation and error handling
* SQLite and SQL queries
* Linux processes, signals, and background jobs
* ANSI terminal formatting
* Desktop notifications and DWM integration
* Git workflows and automated testing

## Project Status

**Beta - Feature Complete**

All core features are implemented and tested:
- ✅ Task management (CRUD operations)
- ✅ Priority levels and due dates
- ✅ SQLite database persistence
- ✅ Interactive dashboard
- ✅ Timer with pause/resume
- ✅ Time tracking per task
- ✅ Alarm system with notifications
- ✅ Weekly productivity reports
- ✅ DWM integration ready

The application is functional and ready for daily use. Testing and refinement ongoing.

## License

No license has been selected yet. Add a `LICENSE` file when you decide how others may use, modify, and distribute the project.
