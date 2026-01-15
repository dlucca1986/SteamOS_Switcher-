#!/bin/bash

# --- SteamOS Switcher Installer ---
# This script installs the necessary scripts to enable 
# Steam Deck-like session switching and system compatibility.

set -e

echo "------------------------------------------"
echo "Starting Installation of SteamOS Switcher"
echo "------------------------------------------"

# 1. Create necessary directories
echo "Creating system directories..."
sudo mkdir -p /usr/local/bin
sudo mkdir -p /usr/bin/steamos-polkit-helpers
sudo mkdir -p /usr/share/wayland-sessions

# 2. Install main scripts to /usr/local/bin
echo "Installing scripts to /usr/local/bin..."
sudo cp os-session-select steamos-session-select set-sddm-session gamescope-session steamos-select-branch /usr/local/bin/

# 3. Install polkit helpers to /usr/bin/steamos-polkit-helpers/
echo "Installing polkit helpers..."
sudo cp steamos-polkit-helpers/jupiter-biosupdate /usr/bin/steamos-polkit-helpers/
sudo cp steamos-polkit-helpers/steamos-set-timezone /usr/bin/steamos-polkit-helpers/
sudo cp steamos-polkit-helpers/steamos-update /usr/bin/steamos-polkit-helpers/

# 4. Create symbolic links in /usr/bin (where Steam expects them)
echo "Creating symbolic links in /usr/bin..."
sudo ln -sf /usr/local/bin/os-session-select /usr/bin/os-session-select
sudo ln -sf /usr/local/bin/steamos-select-branch /usr/bin/steamos-select-branch

# 5. Install Desktop session files
echo "Installing session files..."
sudo cp steam.desktop /usr/share/wayland-sessions/

# 6. Set correct permissions
echo "Setting executable permissions..."
sudo chmod +x /usr/local/bin/os-session-select
sudo chmod +x /usr/local/bin/steamos-session-select
sudo chmod +x /usr/local/bin/set-sddm-session
sudo chmod +x /usr/local/bin/gamescope-session
sudo chmod +x /usr/local/bin/steamos-select-branch
sudo chmod +x /usr/bin/steamos-polkit-helpers/*

echo "------------------------------------------"
echo "Installation completed successfully!"
echo "Next step: Add the sudoers rule for passwordless switching."
echo "------------------------------------------"
