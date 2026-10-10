#!/bin/bash

# Task TUI Configuration

# Database configuration
DB_DIR="${HOME}/.local/share/task-tui"
DB_FILE="${DB_DIR}/tasks.db"

# Ensure data directory exists
mkdir -p "${DB_DIR}"

# Date format
DATE_FORMAT="%Y-%m-%d"
DATETIME_FORMAT="%Y-%m-%d %H:%M:%S"

# Timer configuration
TIMER_FILE="${DB_DIR}/timer_state"

# Alarm configuration
ALARM_PID_FILE="${DB_DIR}/alarm_worker.pid"

# Application metadata
APP_NAME="Task TUI"
APP_VERSION="0.1.0"
