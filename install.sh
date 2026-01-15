#!/bin/bash

# --- SteamOS Switcher Installer ---
# Updated for the new directory-based repository structure.

set -e

echo "------------------------------------------------"
echo "  Starting Installation of SteamOS Switcher     "
echo "------------------------------------------------"

# 1. Create necessary system directories
echo "[1/5] Preparing system directories..."
sudo mkdir -p /usr/local/bin
sudo mkdir -p /usr/bin/steamos-polkit-helpers
sudo mkdir -p /usr/share/wayland-sessions

# 2. Install Master scripts from usr/local/bin
echo "[2/5] Installing core scripts..."
sudo cp usr/local/bin/* /usr/local/bin/

# 3. Install Polkit Helpers from the dedicated folder
echo "[3/5] Installing polkit helpers..."
sudo cp steamos-polkit-helpers/steamos-update /usr/bin/steamos-polkit-helpers/
sudo cp steamos-polkit-helpers/jupiter-biosupdate /usr/bin/steamos-polkit-helpers/
sudo cp steamos-polkit-helpers/steamos-set-timezone /usr/bin/steamos-polkit-helpers/

# 4. Create symbolic links in /usr/bin (for Steam Client compatibility)
echo "[4/5] Creating symbolic links in /usr/bin..."
sudo ln -sf /usr/local/bin/os-session-select /usr/bin/os-session-select
sudo ln -sf /usr/local/bin/steamos-update /usr/bin/steamos-update
sudo ln -sf /usr/local/bin/jupiter-biosupdate /usr/bin/jupiter-biosupdate
sudo ln -sf /usr/local/bin/steamos-select-branch /usr/bin/steamos-select-branch

# 5. Install Desktop files and Set Permissions
echo "[5/5] Installing desktop sessions and setting permissions..."
sudo cp usr/share/wayland-sessions/*.desktop /usr/share/wayland-sessions/
sudo chmod +x /usr/local/bin/*
sudo chmod +x /usr/bin/steamos-polkit-helpers/*

echo "------------------------------------------------"
echo "      Installation completed successfully!      "
echo "------------------------------------------------"
