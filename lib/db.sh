#!/bin/bash

# Database operations

source "$(dirname "${BASH_SOURCE[0]}")/../config.sh"

# Initialize database
init_db() {
    if [[ ! -f "${DB_FILE}" ]]; then
        sqlite3 "${DB_FILE}" <<EOF
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

CREATE TABLE IF NOT EXISTS time_logs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    task_id INTEGER,
    start_time TEXT NOT NULL,
    end_time TEXT,
    duration INTEGER,
    FOREIGN KEY (task_id) REFERENCES tasks(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS alarms (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    alarm_time TEXT NOT NULL,
    status TEXT CHECK(status IN ('pending', 'triggered', 'dismissed')) DEFAULT 'pending',
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
);
EOF
        return $?
    fi
    return 0
}

# Execute SQL query
db_query() {
    local query="$1"
    sqlite3 "${DB_FILE}" "${query}"
}

# Execute SQL query and return results as rows
db_query_rows() {
    local query="$1"
    sqlite3 -separator $'\t' "${DB_FILE}" "${query}"
}

# Check if database is initialized
check_db() {
    if [[ ! -f "${DB_FILE}" ]]; then
        init_db
    fi
}
