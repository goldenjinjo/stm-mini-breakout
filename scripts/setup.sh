#!/bin/bash

# Making helper scripts executable
chmod +x launch_project.sh
chmod +x watch_project.sh
chmod +x watch_project_pcb.sh

# Ensure ~/.local/bin exists
mkdir -p ~/.local/bin

# Get absolute path to launch_hx1.sh
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET="$SCRIPT_DIR/launch_project.sh"
LINK_NAME="$HOME/.local/bin/hx1"

# Create or update the symlink
ln -sf "$TARGET" "$LINK_NAME"

# Ensure ~/.local/bin is on PATH
if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    echo "Added ~/.local/bin to your PATH in .bashrc"
    source ~/.bashrc
fi

echo "Shortcut 'hx1' is ready. You can now run it from any terminal."
