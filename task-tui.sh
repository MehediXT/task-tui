#!/bin/bash

APP_NAME="TASK TUI"

show_menu() {
	printf '====== %s ======\n' "$APP_NAME"

	printf '%s\n' \
		"1. Today's Dashboard" \
		"2. All Tasks" \
		"3. View Task" \
		"4. Stopwatch" \
		"5.	Alarms" \
		"6. Weekly report" \
		"7. Exit"
}

show_menu
