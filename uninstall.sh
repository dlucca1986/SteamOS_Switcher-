#!/bin/bash
# ==============================================================================
# SteamOS Switcher - Uninstaller (Full Cleanup)
# ==============================================================================
set -e

echo "------------------------------------------------"
echo "    Removing SteamOS Switcher Components... 🗑️    "
echo "------------------------------------------------"

# 1. Sudoers Removal
echo "[1/7] Removing Sudoers rules..."
SUDOERS_FILE="/etc/sudoers.d/steamos-switcher"
if [ -f "$SUDOERS_FILE" ]; then
    sudo rm -f "$SUDOERS_FILE"
    echo "    ✅ Sudoers rule removed."
fi

# 2. SDDM Wayland Config Removal
echo "[2/7] Restoring SDDM default configuration..."
SDDM_WAYLAND_CONF="/etc/sddm.conf.d/10-wayland.conf"
if [ -f "$SDDM_WAYLAND_CONF" ]; then
    sudo rm -f "$SDDM_WAYLAND_CONF"
    echo "    ✅ SDDM Wayland config removed."
fi

# 3. Symbolic Links Removal
echo "[3/7] Cleaning system symbolic links..."
SYMLINKS=(
    "/usr/bin/os-session-select"
    "/usr/bin/steamos-update"
    "/usr/bin/jupiter-biosupdate"
    "/usr/bin/steamos-select-branch"
)
for link in "${SYMLINKS[@]}"; do
    if [ -L "$link" ]; then
        sudo rm -f "$link"
        echo "    ✅ Removed link: $link"
    fi
done

# 4. System Files Removal
echo "[4/7] Removing system files and folders..."
sudo rm -rf /usr/bin/steamos-polkit-helpers
sudo rm -rf /usr/share/steamos-switcher
sudo rm -f /usr/share/wayland-sessions/steam.desktop 

# 5. Desktop Shortcut Removal
echo "[5/7] Cleaning desktop shortcuts..."
DESKTOP_DIRS=("$HOME/Desktop" "$HOME/Scrivania" "$HOME/desktop")
for dir in "${DESKTOP_DIRS[@]}"; do
    if [ -f "$dir/GameMode.desktop" ]; then
        rm -f "$dir/GameMode.desktop"
        echo "    ✅ Shortcut removed from: $dir"
    fi
done

# 6. Local Binaries Cleanup
echo "[6/7] Final cleanup in /usr/local/bin..."
PROJECT_BINS=(
    "os-session-select"
    "set-sddm-session"
    "steamos-session-launch"
    "steamos-update"
    "jupiter-biosupdate"
    "steamos-select-branch"
)
for bin in "${PROJECT_BINS[@]}"; do
    if [ -f "/usr/local/bin/$bin" ]; then
        sudo rm -f "/usr/local/bin/$bin"
        echo "    ✅ Removed binary: $bin"
    fi
done

# 7. Reset Gamescope Capabilities
echo "[7/7] Resetting Gamescope permissions..."
if command -v gamescope &> /dev/null; then
    sudo setcap -r $(which gamescope) 2>/dev/null || true
    echo "    ✅ Gamescope capabilities reset."
fi

echo "------------------------------------------------"
echo "    ✨ System successfully cleaned!              "
echo "    The SteamOS Switcher has been removed.       "
echo "------------------------------------------------"
