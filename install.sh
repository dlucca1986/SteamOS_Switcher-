#!/bin/bash

# --- SteamOS Switcher Installer ---
set -e

echo "------------------------------------------------"
echo "  Starting Installation of SteamOS Switcher     "
echo "------------------------------------------------"

# 1. Preparazione Directory
echo "[1/4] Preparing system directories..."
sudo mkdir -p /usr/bin/steamos-polkit-helpers
sudo mkdir -p /usr/local/bin
sudo mkdir -p /usr/share/wayland-sessions
sudo mkdir -p /usr/share/steamos-switcher

# 2. Installazione Bulk (Copia tutto il contenuto di usr/)
echo "[2/4] Installing all files to /usr/..."
# Questo comando copia ricorsivamente mantenendo la struttura
sudo cp -r usr/* /usr/

# 3. Creazione Link Simbolici
echo "[3/4] Creating system symbolic links..."
sudo ln -sf /usr/local/bin/os-session-select /usr/bin/os-session-select
sudo ln -sf /usr/local/bin/steamos-update /usr/bin/steamos-update
sudo ln -sf /usr/local/bin/jupiter-biosupdate /usr/bin/jupiter-biosupdate
sudo ln -sf /usr/local/bin/steamos-select-branch /usr/bin/steamos-select-branch

# 4. Scorciatoia Desktop e Permessi
echo "[4/4] Setting shortcuts and permissions..."

# Gestione Desktop (Inglese/Italiano)
USER_DESKTOP=""
[ -d "$HOME/Desktop" ] && USER_DESKTOP="$HOME/Desktop"
[ -d "$HOME/Scrivania" ] && USER_DESKTOP="$HOME/Scrivania"

if [ -n "$USER_DESKTOP" ]; then
    # Prendiamo il file dalla sorgente nel repo
    cp usr/share/steamos-switcher/GameMode.desktop "$USER_DESKTOP/"
    chmod +x "$USER_DESKTOP/GameMode.desktop"
    echo "Done: Shortcut added to $USER_DESKTOP"
fi

# Set permissions
sudo chmod +x /usr/local/bin/*
sudo chmod +x /usr/bin/steamos-polkit-helpers/*

echo "------------------------------------------------"
echo "      Installation completed successfully!      "
echo "------------------------------------------------"
