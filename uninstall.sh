#!/bin/bash
# ==============================================================================
# SteamOS Switcher - Uninstaller
# ==============================================================================
set -e

echo "------------------------------------------------"
echo "   Removing SteamOS Switcher Components... 🗑️    "
echo "------------------------------------------------"

# 1. Sudoers Removal (Crucial for security)
echo "[1/5] Removing Sudoers rules..."
SUDOERS_FILE="/etc/sudoers.d/steamos-switcher"
if [ -f "$SUDOERS_FILE" ]; then
    sudo rm -f "$SUDOERS_FILE"
    echo "   ✅ Sudoers rule removed."
fi

# 2. Symbolic Links Removal
echo "[2/5] Cleaning system symbolic links..."
SYMLINKS=(
    "/usr/bin/os-session-select"
    "/usr/bin/steamos-update"
    "/usr/bin/jupiter-biosupdate"
    "/usr/bin/steamos-select-branch"
)
for link in "${SYMLINKS[@]}"; do
    if [ -L "$link" ]; then
        sudo rm -f "$link"
        echo "   ✅ Removed link: $link"
    fi
done

# 3. System Files Removal
echo "[3/5] Removing system files..."
sudo rm -rf /usr/bin/steamos-polkit-helpers
sudo rm -rf /usr/share/steamos-switcher
# Ensure this filename matches your .desktop session file
sudo rm -f /usr/share/wayland-sessions/steam.desktop 

# 4. Desktop Shortcut Removal
echo "[4/5] Cleaning desktop shortcuts..."
DESKTOP_DIRS=("$HOME/Desktop" "$HOME/Scrivania" "$HOME/desktop")
for dir in "${DESKTOP_DIRS[@]}"; do
    if [ -f "$dir/GameMode.desktop" ]; then
        rm -f "$dir/GameMode.desktop"
        echo "   ✅ Shortcut removed from: $dir"
    fi
done

# 5. Final Cleanup in /usr/local/bin
echo "[5/5] Final cleanup in /usr/local/bin..."
# Removing only project-specific files for safety
sudo rm -f /usr/local/bin/os-session-select
sudo rm -f /usr/local/bin/steamos-update
sudo rm -f /usr/local/bin/jupiter-biosupdate
sudo rm -f /usr/local/bin/steamos-select-branch

echo "------------------------------------------------"
echo "   ✨ System successfully cleaned!              "
echo "   The SteamOS Switcher has been removed.       "
echo "------------------------------------------------"
