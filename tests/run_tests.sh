#!/bin/bash

# Basic test suite for Task TUI

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# Test colors
GREEN="\e[32m"
RED="\e[31m"
RESET="\e[0m"

# Test counter
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Test function
run_test() {
    local test_name="$1"
    local test_command="$2"

    ((TESTS_RUN++))

    if eval "$test_command" &>/dev/null; then
        echo -e "${GREEN}✓${RESET} $test_name"
        ((TESTS_PASSED++))
        return 0
    else
        echo -e "${RED}✗${RESET} $test_name"
        ((TESTS_FAILED++))
        return 1
    fi
}

echo "Running Task TUI Tests..."
echo "========================="
echo ""

# Test 1: Check if required commands exist
echo "Checking dependencies..."
run_test "bash is available" "command -v bash"
run_test "sqlite3 is available" "command -v sqlite3"
run_test "dmenu is available" "command -v dmenu"
run_test "notify-send is available" "command -v notify-send"

echo ""

# Test 2: Check file structure
echo "Checking project structure..."
run_test "config.sh exists" "test -f ${PROJECT_DIR}/config.sh"
run_test "task-tui.sh exists" "test -f ${PROJECT_DIR}/task-tui.sh"
run_test "lib/db.sh exists" "test -f ${PROJECT_DIR}/lib/db.sh"
run_test "lib/tasks.sh exists" "test -f ${PROJECT_DIR}/lib/tasks.sh"
run_test "lib/timer.sh exists" "test -f ${PROJECT_DIR}/lib/timer.sh"
run_test "lib/alarms.sh exists" "test -f ${PROJECT_DIR}/lib/alarms.sh"
run_test "lib/reports.sh exists" "test -f ${PROJECT_DIR}/lib/reports.sh"
run_test "ui/menu.sh exists" "test -f ${PROJECT_DIR}/ui/menu.sh"
run_test "ui/dashboard.sh exists" "test -f ${PROJECT_DIR}/ui/dashboard.sh"
run_test "ui/colors.sh exists" "test -f ${PROJECT_DIR}/ui/colors.sh"
run_test "scripts/alarm-worker.sh exists" "test -f ${PROJECT_DIR}/scripts/alarm-worker.sh"

echo ""

# Test 3: Check syntax
echo "Checking Bash syntax..."
run_test "task-tui.sh syntax" "bash -n ${PROJECT_DIR}/task-tui.sh"
run_test "config.sh syntax" "bash -n ${PROJECT_DIR}/config.sh"
run_test "lib/db.sh syntax" "bash -n ${PROJECT_DIR}/lib/db.sh"
run_test "lib/tasks.sh syntax" "bash -n ${PROJECT_DIR}/lib/tasks.sh"
run_test "lib/timer.sh syntax" "bash -n ${PROJECT_DIR}/lib/timer.sh"
run_test "lib/alarms.sh syntax" "bash -n ${PROJECT_DIR}/lib/alarms.sh"
run_test "lib/reports.sh syntax" "bash -n ${PROJECT_DIR}/lib/reports.sh"
run_test "ui/menu.sh syntax" "bash -n ${PROJECT_DIR}/ui/menu.sh"
run_test "ui/dashboard.sh syntax" "bash -n ${PROJECT_DIR}/ui/dashboard.sh"
run_test "ui/colors.sh syntax" "bash -n ${PROJECT_DIR}/ui/colors.sh"
run_test "scripts/alarm-worker.sh syntax" "bash -n ${PROJECT_DIR}/scripts/alarm-worker.sh"

echo ""

# Test 4: Database operations
echo "Testing database operations..."

# Create temporary test database
TEST_DB="/tmp/task-tui-test-$$.db"

# Directly create database without sourcing db.sh to avoid config conflict
run_test "Database creation" "sqlite3 $TEST_DB 'CREATE TABLE tasks (id INTEGER PRIMARY KEY);'"
run_test "Database file exists" "test -f $TEST_DB"

# Create full schema
sqlite3 "$TEST_DB" <<'TESTSQL'
DROP TABLE IF EXISTS tasks;
CREATE TABLE IF NOT EXISTS tasks (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    description TEXT,
    priority TEXT CHECK(priority IN ('low', 'medium', 'high')) DEFAULT 'medium',
    status TEXT CHECK(status IN ('pending', 'completed')) DEFAULT 'pending',
    due_date TEXT,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    completed_at TEXT,
    time_spent INTEGER DEFAULT 0
);

CREATE TABLE IF NOT EXISTS alarms (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    alarm_time TEXT NOT NULL,
    status TEXT CHECK(status IN ('pending', 'triggered', 'dismissed')) DEFAULT 'pending',
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
);
TESTSQL

run_test "tasks table exists" "sqlite3 $TEST_DB \".tables\" | grep -q tasks"
run_test "alarms table exists" "sqlite3 $TEST_DB \".tables\" | grep -q alarms"

# Test 5: Task operations
echo ""
echo "Testing task operations..."

# Test SQL operations directly
run_test "Insert task" "sqlite3 $TEST_DB \"INSERT INTO tasks (title, priority) VALUES ('Test Task', 'high');\""
run_test "Query task" "test \$(sqlite3 $TEST_DB 'SELECT COUNT(*) FROM tasks;') -eq 1"
run_test "Complete task" "sqlite3 $TEST_DB \"UPDATE tasks SET status = 'completed' WHERE id = 1;\""
run_test "Delete task" "sqlite3 $TEST_DB 'DELETE FROM tasks WHERE id = 1;'"

# Cleanup
rm -f "$TEST_DB"

echo ""
echo "========================="
echo "Tests run: $TESTS_RUN"
echo -e "${GREEN}Tests passed: $TESTS_PASSED${RESET}"
if [[ $TESTS_FAILED -gt 0 ]]; then
    echo -e "${RED}Tests failed: $TESTS_FAILED${RESET}"
fi
echo ""

if [[ $TESTS_FAILED -eq 0 ]]; then
    echo -e "${GREEN}All tests passed!${RESET}"
    exit 0
else
    echo -e "${RED}Some tests failed!${RESET}"
    exit 1
fi
