#!/bin/bash

# --- SteamOS Switcher Uninstaller ---

set -e

echo "------------------------------------------------"
echo "   Starting Removal of SteamOS Switcher         "
echo "------------------------------------------------"

# 1. Remove Symbolic Links
echo "[1/6] Removing symbolic links from /usr/bin..."
sudo rm -f /usr/bin/os-session-select
sudo rm -f /usr/bin/steamos-update
sudo rm -f /usr/bin/jupiter-biosupdate
sudo rm -f /usr/bin/steamos-select-branch

# 2. Remove Master Scripts
echo "[2/6] Removing master scripts from /usr/local/bin..."
sudo rm -f /usr/local/bin/os-session-select
sudo rm -f /usr/local/bin/set-sddm-session
sudo rm -f /usr/local/bin/gamescope-session
sudo rm -f /usr/local/bin/steamos-update
sudo rm -f /usr/local/bin/jupiter-biosupdate
sudo rm -f /usr/local/bin/steamos-select-branch

# 3. Remove Polkit Helpers and Support Folders
echo "[3/6] Cleaning up system directories..."
sudo rm -rf /usr/bin/steamos-polkit-helpers
sudo rm -rf /usr/share/steamos-switcher

# 4. Remove Session and Configuration files
echo "[4/6] Removing session entries and SDDM overrides..."
sudo rm -f /usr/share/wayland-sessions/steam.desktop
sudo rm -f /etc/sddm.conf.d/steamos-switcher.conf

# 5. Remove Sudoers Rule
echo "[5/6] Removing sudoers permission rule..."
sudo rm -f /etc/sudoers.d/steamos-switcher

# 6. Remove Desktop Shortcut
echo "[6/6] Removing desktop shortcut..."
if [ -d "$HOME/Desktop" ]; then
    rm -f "$HOME/Desktop/GameMode.desktop"
elif [ -d "$HOME/Scrivania" ]; then
    rm -f "$HOME/Scrivania/GameMode.desktop"
fi

echo "------------------------------------------------"
echo "      Uninstallation completed successfully!     "
echo "------------------------------------------------"
echo "Your system has been restored to its original state."
echo "------------------------------------------------"
