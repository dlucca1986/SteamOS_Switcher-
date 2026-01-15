#!/bin/bash

# --- SteamOS Switcher Installer ---
# This script installs the necessary scripts to enable 
# Steam Deck-like session switching and system compatibility.

set -e

echo "------------------------------------------------"
echo "  Starting Installation of SteamOS Switcher  "
echo "------------------------------------------------"

# 1. Create necessary directories
echo "[1/6] Creating system directories..."
sudo mkdir -p /usr/local/bin
sudo mkdir -p /usr/bin/steamos-polkit-helpers
sudo mkdir -p /usr/share/wayland-sessions

# 2. Install main scripts to /usr/local/bin
echo "[2/6] Installing core scripts to /usr/local/bin..."
sudo cp os-session-select steamos-session-select set-sddm-session gamescope-session steamos-select-branch /usr/local/bin/

# 3. Install polkit helpers to /usr/bin/steamos-polkit-helpers/
echo "[3/6] Installing polkit dummy helpers..."
sudo cp steamos-polkit-helpers/jupiter-biosupdate /usr/bin/steamos-polkit-helpers/
sudo cp steamos-polkit-helpers/steamos-set-timezone /usr/bin/steamos-polkit-helpers/
sudo cp steamos-polkit-helpers/steamos-update /usr/bin/steamos-polkit-helpers/

# 4. Create symbolic links in /usr/bin (required by Steam Client)
echo "[4/6] Creating symbolic links in /usr/bin..."
sudo ln -sf /usr/local/bin/os-session-select /usr/bin/os-session-select
sudo ln -sf /usr/local/bin/steamos-select-branch /usr/bin/steamos-select-branch
# Links for updates and bios to ensure Steam finds them in the main path
sudo ln -sf /usr/bin/steamos-polkit-helpers/steamos-update /usr/bin/steamos-update
sudo ln -sf /usr/bin/steamos-polkit-helpers/jupiter-biosupdate /usr/bin/jupiter-biosupdate

# 5. Install Desktop session files
echo "[5/6] Installing Wayland session entries..."
sudo cp steam.desktop /usr/share/wayland-sessions/

# 6. Set correct permissions
echo "[6/6] Setting executable permissions..."
sudo chmod +x /usr/local/bin/os-session-select
sudo chmod +x /usr/local/bin/steamos-session
