#!/bin/bash
# ==============================================================================
# SteamOS Switcher - Professional Installer (Full AMD Optimized)
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
        echo "   ✅ Check OK: ${PKG_LIST[*]}"
    else
        echo "   ⚠️ Missing packages: ${MISSING_PKGS[*]}"
        read -p "   Do you want to install them now? [Y/n]: " choice
        choice=${choice:-Y}
        if [[ "$choice" =~ ^[Yy]$ ]]; then
            sudo pacman -S --noconfirm "${MISSING_PKGS[@]}"
        else
            echo "   ❌ Installation aborted. These packages are required."
            exit 1
        fi
    fi
}

# --- WELCOME ---
clear
echo "------------------------------------------------"
echo "   Welcome to SteamOS Switcher Installer! 🚀   "
echo "      Optimized for Full AMD Builds            "
echo "------------------------------------------------"

# 1. HARDWARE COMPATIBILITY CHECK
echo "[1/7] Verifying Hardware Compatibility..."
GPU_INFO=$(lspci | grep -i 'vga\|display' | grep -i 'AMD\|Radeon' || true)

if [ -n "$GPU_INFO" ]; then
    echo "   ✅ AMD GPU detected: $GPU_INFO"
else
    echo "   ------------------------------------------------"
    echo "   ⚠️  WARNING: No AMD GPU detected!"
    echo "   This project is engineered for AMD (Mesa/RADV)."
    echo "   Running it on Nvidia or Intel hardware may lead to issues."
    echo "   ------------------------------------------------"
    read -p "   Do you want to proceed anyway? [y/N]: " gpu_choice
    gpu_choice=${gpu_choice:-N}
    if [[ ! "$gpu_choice" =~ ^[Yy]$ ]]; then
        echo "   ❌ Installation aborted by user."
        exit 1
    fi
fi

# 2. PREREQUISITES CHECK
echo "[2/7] Checking Software Prerequisites..."
# Essential Gaming Tools
check_and_install steam gamescope mangohud lib32-mangohud gamemode
# Vulkan Core
check_and_install vulkan-icd-loader lib32-vulkan-icd-loader
# AMD Specific Drivers (RADV)
check_and_install vulkan-radeon lib32-vulkan-radeon

# 3. PREPARING DIRECTORIES
echo "[3/7] Preparing system directories..."
sudo mkdir -p /usr/bin/steamos-polkit-helpers
sudo mkdir -p /usr/local/bin
sudo mkdir -p /usr/share/wayland-sessions
sudo mkdir -p /usr/share/steamos-switcher

# 4. INSTALLING FILES
echo "[4/7] Installing system files from usr/..."
if [ -d "usr" ]; then
    sudo cp -r usr/* /usr/
    echo "   ✅ Files copied to /usr/"
else
    echo "   ❌ Error: 'usr' directory not found in current folder!"
    exit 1
fi

# 5. SYMBOLIC LINKS
echo "[5/7] Creating system symbolic links..."
sudo ln -sf /usr/local/bin/os-session-select /usr/bin/os-session-select
sudo ln -sf /usr/local/bin/steamos-update /usr/bin/steamos-update
sudo ln -sf /usr/local/bin/jupiter-biosupdate /usr/bin/jupiter-biosupdate
sudo ln -sf /usr/local/bin/steamos-select-branch /usr/bin/steamos-select-branch

# 6. SUDOERS AUTOMATION
echo "[6/7] Configuring Sudoers for seamless switching..."
SUDOERS_FILE="/etc/sudoers.d/steamos-switcher"
SUDOERS_CONTENT="%wheel ALL=(ALL) NOPASSWD: /usr/local/bin/os-session-select"

if [ ! -f "$SUDOERS_FILE" ]; then
    echo "$SUDOERS_CONTENT" | sudo tee "$SUDOERS_FILE" > /dev/null
    sudo chmod 440 "$SUDOERS_FILE"
    echo "   ✅ Sudoers rule created in $SUDOERS_FILE"
else
    echo "   ℹ️  Sudoers rule already exists. Skipping."
fi

# 7. SHORTCUTS & PERMISSIONS
echo "[7/7] Finalizing shortcuts and permissions..."
DESKTOP_DIRS=("$HOME/Desktop" "$HOME/Scrivania" "$HOME/desktop")
for dir in "${DESKTOP_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        cp /usr/share/steamos-switcher/GameMode.desktop "$dir/"
        chmod +x "$dir/GameMode.desktop"
        echo "   ✅ Shortcut added to: $dir"
    fi
done

sudo chmod +x /usr/local/bin/*
sudo chmod +x /usr/bin/steamos-polkit-helpers/*

echo "------------------------------------------------"
echo "   🎉 Installation completed successfully!     "
echo "   Please log out and select 'SteamOS' session  "
echo "------------------------------------------------"
