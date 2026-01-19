#!/bin/bash
# ==============================================================================
# SteamOS Switcher - Professional Installer
# ==============================================================================
set -e

# --- FUNCTIONS ---

# Function to check and install packages
check_and_install() {
    local PKG_LIST=("$@")
    local MISSING_PKGS=()

    for pkg in "${PKG_LIST[@]}"; do
        if ! pacman -Qi "$pkg" &> /dev/null; then
            MISSING_PKGS+=("$pkg")
        fi
    done

    if [ ${#MISSING_PKGS[@]} -eq 0 ]; then
        echo "✅ Check OK: ${PKG_LIST[*]}"
    else
        echo "⚠️ Missing packages: ${MISSING_PKGS[*]}"
        read -p "Do you want to install them now? [Y/n]: " choice
        choice=${choice:-Y}
        if [[ "$choice" =~ ^[Yy]$ ]]; then
            sudo pacman -S --noconfirm "${MISSING_PKGS[@]}"
        else
            echo "❌ Installation aborted. These packages are required."
            exit 1
        fi
    fi
}

# --- WELCOME ---
echo "------------------------------------------------"
echo "   Welcome to SteamOS Switcher Installer! 🚀   "
echo "      Optimized for Full AMD Builds            "
echo "------------------------------------------------"

# 1. PREREQUISITES CHECK
echo "[1/6] Checking Hardware & Software Prerequisites..."

# Essential Gaming Tools
check_and_install steam gamescope mangohud lib32-mangohud gamemode

# Vulkan Core
check_and_install vulkan-icd-loader lib32-vulkan-icd-loader

# AMD Specific Drivers (RADV)
check_and_install vulkan-radeon lib32-vulkan-radeon

# 2. PREPARING DIRECTORIES
echo "[2/6] Preparing system directories..."
sudo mkdir -p /usr/bin/steamos-polkit-helpers
sudo mkdir -p /usr/local/bin
sudo mkdir -p /usr/share/wayland-sessions
sudo mkdir -p /usr/share/steamos-switcher

# 3. INSTALLING FILES
echo "[3/6] Installing system files..."
sudo cp -r usr/* /usr/

# 4. SYMBOLIC LINKS
echo "[4/6] Creating system symbolic links..."
sudo ln -sf /usr/local/bin/os-session-select /usr/bin/os-session-select
sudo ln -sf /usr/local/bin/steamos-update /usr/bin/steamos-update
sudo ln -sf /usr/local/bin/jupiter-biosupdate /usr/bin/jupiter-biosupdate
sudo ln -sf /usr/local/bin/steamos-select-branch /usr/bin/steamos-select-branch

# 5. SUDOERS AUTOMATION (The "Secret Sauce")
echo "[5/6] Configuring Sudoers for seamless switching..."
SUDOERS_FILE="/etc/sudoers.d/steamos-switcher"
SUDOERS_CONTENT="%wheel ALL=(ALL) NOPASSWD: /usr/local/bin/os-session-select"

if [ ! -f "$SUDOERS_FILE" ]; then
    echo "$SUDOERS_CONTENT" | sudo tee "$SUDOERS_FILE" > /dev/null
    sudo chmod 440 "$SUDOERS_FILE"
    echo "✅ Sudoers rule created successfully."
else
    echo "ℹ️ Sudoers rule already exists. Skipping."
fi

# 6. SHORTCUTS & PERMISSIONS
echo "[6/6] Finalizing shortcuts and permissions..."

# Universal Desktop Shortcut Logic
DESKTOP_DIRS=("$HOME/Desktop" "$HOME/Scrivania" "$HOME/desktop")
for dir in "${DESKTOP_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        cp /usr/share/steamos-switcher/GameMode.desktop "$dir/"
        chmod +x "$dir/GameMode.desktop"
        echo "✅ Shortcut added to: $dir"
    fi
done

# Ensure binaries are executable
sudo chmod +x /usr/local/bin/*
sudo chmod +x /usr/bin/steamos-polkit-helpers/*

echo "------------------------------------------------"
echo "   🎉 Installation completed successfully!     "
echo "   Please log out and select 'SteamOS' session  "
echo "------------------------------------------------"
