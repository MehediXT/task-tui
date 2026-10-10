# DWM Integration Guide

This guide explains how to integrate Task TUI with DWM (Dynamic Window Manager).

## Keyboard Shortcut

Add a keyboard shortcut to launch Task TUI from anywhere in DWM.

### Edit your DWM config.h

1. Open your DWM configuration file (usually `~/.config/dwm/config.h` or `~/dwm/config.h`)

2. Add this line to your `keys[]` array:

```c
{ MODKEY|ShiftMask, XK_t, spawn, SHCMD("task-tui") },
```

This binds `Mod+Shift+T` to launch Task TUI. You can change the key combination:
- `XK_t` → the key (try `XK_a`, `XK_p`, etc.)
- `MODKEY` → your mod key (usually Alt or Super)
- `ShiftMask` → modifier (can use `ControlMask`, or remove for just `MODKEY`)

3. Recompile and restart DWM:

```bash
cd ~/dwm  # or wherever your DWM source is
sudo make clean install
```

4. Restart DWM (Mod+Shift+Q or your quit keybinding)

## Status Bar Integration

Show task statistics in your DWM status bar.

### Method 1: Using the provided script

The `scripts/dwm-status.sh` script outputs formatted task information:

```bash
./scripts/dwm-status.sh
```

Output format: `⏱️ 1h23m 📋 5 ⏰ 2`
- ⏱️ = Active timer duration
- 📋 = Pending tasks count
- ⏰ = Upcoming alarms count

### Method 2: Custom status bar script

If you have an existing status bar script, add Task TUI information:

```bash
#!/bin/bash

# Your existing status bar code...

# Add Task TUI status
task_status=$(~/.local/src/task-tui/scripts/dwm-status.sh)

# Combine with other status info
xsetroot -name "$task_status | Volume: $vol | $(date '+%Y-%m-%d %H:%M')"
```

### Method 3: Using a status bar like slstatus or dwmblocks

#### For dwmblocks

Add this block to your `blocks.h`:

```c
static const Block blocks[] = {
    /* ... your other blocks ... */
    {"", "~/.local/src/task-tui/scripts/dwm-status.sh", 60, 0},
    /* ... */
};
```

Recompile dwmblocks:

```bash
cd ~/dwmblocks
sudo make clean install
pkill -RTMIN dwmblocks  # Reload
```

#### For slstatus

Edit your `config.h` and add:

```c
static const struct arg args[] = {
    /* ... */
    { run_command, "~/.local/src/task-tui/scripts/dwm-status.sh" },
    /* ... */
};
```

### Auto-start status updates

If you want the status to update automatically, add this to your `.xinitrc` or DWM startup script:

```bash
# Update status bar every minute
while true; do
    xsetroot -name "$(~/.local/src/task-tui/scripts/dwm-status.sh) | $(date '+%Y-%m-%d %H:%M')"
    sleep 60
done &
```

## Desktop Notifications

Task TUI uses `notify-send` for alarm notifications. These work automatically if you have a notification daemon running.

### Install a notification daemon

If notifications aren't working, install one:

**dunst** (recommended for DWM):
```bash
sudo pacman -S dunst
```

Add to your `.xinitrc`:
```bash
dunst &
```

**Other options:**
- `notification-daemon`
- `mate-notification-daemon`
- `xfce4-notifyd`

## Auto-start Task TUI Services

### Start alarm worker on login

Add to your `.xinitrc` or DWM autostart script:

```bash
# Task TUI alarm worker
nohup ~/.local/src/task-tui/scripts/alarm-worker.sh >/dev/null 2>&1 &
```

## Example Complete Integration

Here's a complete example of DWM integration:

### ~/.xinitrc

```bash
#!/bin/sh

# Start notification daemon
dunst &

# Start Task TUI alarm worker
nohup ~/.local/src/task-tui/scripts/alarm-worker.sh >/dev/null 2>&1 &

# Update status bar
while true; do
    task_info=$(~/.local/src/task-tui/scripts/dwm-status.sh)
    date_info=$(date '+%Y-%m-%d %H:%M')
    xsetroot -name "$task_info | $date_info"
    sleep 60
done &

# Start DWM
exec dwm
```

### DWM config.h (relevant section)

```c
static const char *termcmd[]  = { "st", NULL };
static const char *taskcmd[]  = { "task-tui", NULL };

static Key keys[] = {
    /* ... other keys ... */
    { MODKEY,           XK_Return, spawn,          {.v = termcmd } },
    { MODKEY|ShiftMask, XK_t,      spawn,          SHCMD("task-tui") },
    /* ... */
};
```

## Tips

1. **Quick Add**: Create a separate shortcut for quick task adding:
   ```c
   { MODKEY|ShiftMask, XK_a, spawn, SHCMD("st -e bash -c 'source ~/.local/src/task-tui/lib/tasks.sh && add_task'") },
   ```

2. **Dashboard View**: Quick dashboard view:
   ```c
   { MODKEY|ShiftMask, XK_d, spawn, SHCMD("st -e bash -c 'source ~/.local/src/task-tui/ui/dashboard.sh && show_dashboard'") },
   ```

3. **Status Bar Clicking**: If using dwmblocks with clickable blocks, you can make the task status clickable to open Task TUI.

## Troubleshooting

**Problem**: Keyboard shortcut doesn't work
- Solution: Make sure you recompiled DWM after editing config.h
- Check the keybinding doesn't conflict with existing shortcuts

**Problem**: Status bar shows nothing
- Solution: Make sure the database is initialized (run `task-tui` once)
- Check script permissions: `chmod +x scripts/dwm-status.sh`

**Problem**: Notifications don't appear
- Solution: Check if a notification daemon is running: `ps aux | grep -E 'dunst|notify'`
- Test notifications: `notify-send "Test" "Testing notifications"`

**Problem**: Alarm worker not running
- Solution: Check if it's running: `ps aux | grep alarm-worker`
- Check PID file: `cat ~/.local/share/task-tui/alarm_worker.pid`
- Restart it: `nohup ~/.local/src/task-tui/scripts/alarm-worker.sh >/dev/null 2>&1 &`
