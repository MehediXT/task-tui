# Task TUI

A lightweight terminal-based productivity and task management application built with **Bash, SQLite, and dmenu** for Linux.

Task TUI aims to provide a keyboard-driven workflow for managing daily tasks, tracking time, setting reminders, and reviewing weekly productivity — without leaving the Linux desktop environment.

The project is being developed as a hands-on Bash scripting learning project, with an emphasis on Linux internals, shell automation, and Suckless tools.

## Features

### Planned Features

* [x] Interactive menu using `dmenu`
* [x] Basic Bash menu and action handling
* [ ] Add, view, edit, and delete tasks
* [ ] Mark tasks as completed
* [ ] Set task priorities and due dates
* [ ] SQLite database for persistent storage
* [ ] Today's productivity dashboard
* [ ] Overdue task tracking
* [ ] Stopwatch with pause and resume
* [ ] Task-based time tracking
* [ ] Scheduled alarms and desktop notifications
* [ ] Weekly productivity reports
* [ ] DWM keyboard shortcut integration
* [ ] Optional DWM status bar integration

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

### 1. Clone the repository

Replace the example URL with your actual Git repository URL.

```bash
git clone <YOUR_REPOSITORY_URL>
cd task-tui
```

If you are developing locally without a remote repository, simply navigate to your existing project directory.

### 2. Make the script executable

```bash
chmod +x task-tui.sh
```

### 3. Run Task TUI

```bash
./task-tui.sh
```

Alternatively, run it explicitly with Bash:

```bash
bash task-tui.sh
```

## Development

Task TUI is being developed incrementally.

The development roadmap is:

1. Build a reliable interactive menu.
2. Implement task creation and management.
3. Integrate SQLite for persistent storage.
4. Build the terminal dashboard.
5. Implement stopwatch and time tracking.
6. Add alarms and desktop notifications.
7. Create weekly productivity reports.
8. Integrate the application with DWM.
9. Add tests, error handling, and documentation.

### Syntax checking

Check the main script for Bash syntax errors without executing it:

```bash
bash -n task-tui.sh
```

### Debugging

Run the script with Bash execution tracing:

```bash
bash -x task-tui.sh
```

### Version control

Track changes with Git:

```bash
git add .
git commit -m "Describe your changes"
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

**Early development**

The initial interactive menu is working. Task persistence, the dashboard, stopwatch, alarms, reporting, and desktop integration are planned features that will be implemented incrementally.

## License

No license has been selected yet. Add a `LICENSE` file when you decide how others may use, modify, and distribute the project.
