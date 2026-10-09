#!/bin/bash


menu_options=(

	"1. Today's Dashboard"
	"2. Add Task"
	"3. Edit Task"
	"4. Delete Task"
	"5. Exit"
)

show_dmenu() {
	printf "%s\n" "${menu_options[@]}" | dmenu -i -p "Select an option:"
}

choice=$(show_dmenu)

case $choice in
	"1. Today's Dashboard")
		echo "Today's Dashboard"
		;;
	"2. Add Task")
		echo "Add Task"
		;;
	"3. Edit Task")
		echo "Edit Task"
		;;
	"4. Delete Task")
		echo "Delete Task"
		;;
	"5. Exit")
		echo "Exiting..."
		;;
	*)
		echo "Invalid option"
		;;
esac
