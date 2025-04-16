#!/bin/bash

# Get the directory where this script *actually lives*, even if run via symlink
SCRIPT_PATH="$(readlink -f "$0")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"

# Start watcher in background
"$SCRIPT_DIR/watch_project.sh" &
WATCH_PID=$!

# Assume repo root is one level up from scripts/
REPO_ROOT="$(realpath "$SCRIPT_DIR/..")"
cd "$REPO_ROOT"

# Launch KiCad project
kicad HX-1/HX-1.kicad_pro

# Stop watcher when KiCad closes
kill $WATCH_PID

