#!/bin/bash

# Terminal colors and formatting

# ANSI color codes
COLOR_RESET="\e[0m"
COLOR_BOLD="\e[1m"
COLOR_DIM="\e[2m"

# Foreground colors
COLOR_BLACK="\e[30m"
COLOR_RED="\e[31m"
COLOR_GREEN="\e[32m"
COLOR_YELLOW="\e[33m"
COLOR_BLUE="\e[34m"
COLOR_MAGENTA="\e[35m"
COLOR_CYAN="\e[36m"
COLOR_WHITE="\e[37m"

# Background colors
BG_BLACK="\e[40m"
BG_RED="\e[41m"
BG_GREEN="\e[42m"
BG_YELLOW="\e[43m"
BG_BLUE="\e[44m"
BG_MAGENTA="\e[45m"
BG_CYAN="\e[46m"
BG_WHITE="\e[47m"

# Utility functions
print_success() {
    echo -e "${COLOR_GREEN}${COLOR_BOLD}✓${COLOR_RESET} $1"
}

print_error() {
    echo -e "${COLOR_RED}${COLOR_BOLD}✗${COLOR_RESET} $1"
}

print_warning() {
    echo -e "${COLOR_YELLOW}${COLOR_BOLD}⚠${COLOR_RESET} $1"
}

print_info() {
    echo -e "${COLOR_CYAN}${COLOR_BOLD}ℹ${COLOR_RESET} $1"
}

print_header() {
    echo -e "\n${COLOR_BOLD}${COLOR_CYAN}$1${COLOR_RESET}"
    echo -e "${COLOR_DIM}$(printf '─%.0s' {1..60})${COLOR_RESET}\n"
}
