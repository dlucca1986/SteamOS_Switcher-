#!/bin/bash

# --- SteamOS Switcher Installer ---

set -e

echo "------------------------------------------------"
echo "  Starting Installation of SteamOS Switcher     "
echo "------------------------------------------------"

# 1. Ensure system directories exist
echo "[1/5] Preparing system directories..."
sudo mkdir -p /usr/bin/steamos-polkit-helpers
sudo mkdir -p /usr/local/bin
sudo mkdir -p /usr/share/wayland-sessions
sudo mkdir -p /usr/share/steamos-switcher

# 2. Install Master Scripts to /usr/local/bin
echo "[2/5] Installing master scripts to /usr/local/bin..."
sudo cp usr/local/bin/* /usr/local/bin/

# 3. Install Polkit Helpers to /usr/bin/steamos-polkit-helpers/
echo "[3/5] Installing polkit wrappers..."
sudo cp steamos-polkit-helpers/* /usr/bin/steamos-polkit-helpers/

# 4. Create Symbolic Links in /usr/bin
echo "[4/5] Creating system symbolic links..."
sudo ln -sf /usr/local/bin/os-session-select /usr/bin/os-session-select
sudo ln -sf /usr/local/bin/steamos-update /usr/bin/steamos-update
sudo ln -sf /usr/local/bin/jupiter-biosupdate /usr/bin/jupiter-biosupdate
sudo ln -sf /usr/local/bin/steamos-select-branch /usr/bin/steamos-select-branch

# 5. Install Session files, Shortcuts and Set Permissions
echo "[5/5] Installing session entries and setting permissions..."

# Install Wayland session for login manager
sudo cp usr/share/wayland-sessions/steam.desktop /usr/share/wayland-sessions/

# Backup GameMode.desktop to system folder
sudo cp GameMode.desktop /usr/share/steamos-switcher/

# Try to copy GameMode.desktop to the user's Desktop folder
# (Supports both English 'Desktop' and Italian 'Scrivania')
USER_DESKTOP=""
if [ -d "$HOME/Desktop" ]; then
    USER_DESKTOP="$HOME/Desktop"
elif [ -d "$HOME/Scrivania" ]; then
    USER_DESKTOP="$HOME/Scrivania"
fi

if [ -n "$USER_DESKTOP" ]; then
    cp GameMode.desktop "$USER_DESKTOP/"
    chmod +x "$USER_DESKTOP/GameMode.desktop"
    echo "Done: Shortcut 'GameMode.desktop' added to $USER_DESKTOP"
else
    echo "Warning: Desktop folder not found. Shortcut not created."
fi

# Set all binaries to executable
sudo chmod +x /usr/local/bin/*
sudo chmod +x /usr/bin/steamos-polkit-helpers/*

echo "------------------------------------------------"
echo "      Installation completed successfully!      "
echo "------------------------------------------------"
echo "Check README.md to configure sudoers for "
echo "passwordless session switching."
echo "------------------------------------------------"
