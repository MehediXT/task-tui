#!/bin/bash

# Installation script for Task TUI

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Task TUI Installation"
echo "====================="
echo ""

# Check dependencies
echo "Checking dependencies..."

MISSING_DEPS=()

command -v bash >/dev/null 2>&1 || MISSING_DEPS+=("bash")
command -v sqlite3 >/dev/null 2>&1 || MISSING_DEPS+=("sqlite3")
command -v dmenu >/dev/null 2>&1 || MISSING_DEPS+=("dmenu")
command -v notify-send >/dev/null 2>&1 || MISSING_DEPS+=("libnotify")

if [[ ${#MISSING_DEPS[@]} -gt 0 ]]; then
    echo "Error: Missing required dependencies:"
    printf '  - %s\n' "${MISSING_DEPS[@]}"
    echo ""
    echo "On Arch Linux, install with:"
    echo "  sudo pacman -S bash sqlite libnotify dmenu"
    exit 1
fi

echo "✓ All dependencies found"
echo ""

# Create data directory
echo "Setting up data directory..."
DATA_DIR="${HOME}/.local/share/task-tui"
mkdir -p "$DATA_DIR"
echo "✓ Data directory: $DATA_DIR"
echo ""

# Initialize database
echo "Initializing database..."
source "${SCRIPT_DIR}/config.sh"
source "${SCRIPT_DIR}/lib/db.sh"
init_db
echo "✓ Database initialized"
echo ""

# Create symlink in PATH
echo "Creating launcher..."
BIN_DIR="${HOME}/.local/bin"
mkdir -p "$BIN_DIR"

LAUNCHER="${BIN_DIR}/task-tui"
ln -sf "${SCRIPT_DIR}/task-tui.sh" "$LAUNCHER"

echo "✓ Launcher created: $LAUNCHER"
echo ""

# Check if ~/.local/bin is in PATH
if [[ ":$PATH:" != *":${HOME}/.local/bin:"* ]]; then
    echo "Warning: ${HOME}/.local/bin is not in your PATH"
    echo "Add this to your shell config (~/.bashrc or ~/.zshrc):"
    echo ""
    echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
    echo ""
fi

# Offer to start alarm worker
echo "Do you want to start the alarm worker in the background? (y/N)"
read -r response

if [[ "$response" =~ ^[Yy]$ ]]; then
    nohup "${SCRIPT_DIR}/scripts/alarm-worker.sh" >/dev/null 2>&1 &
    echo $! > "${DATA_DIR}/alarm_worker.pid"
    echo "✓ Alarm worker started (PID: $!)"
else
    echo "You can start it manually later with:"
    echo "  nohup ${SCRIPT_DIR}/scripts/alarm-worker.sh >/dev/null 2>&1 &"
fi

echo ""
echo "========================="
echo "Installation complete!"
echo ""
echo "Run 'task-tui' to start the application"
echo "Or run './task-tui.sh' from the project directory"
echo ""
echo "For DWM integration, see the DWM configuration section in the README"
echo ""
