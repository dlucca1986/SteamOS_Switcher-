#!/bin/bash
# =============================================================================
# SteamMachine-DIY - Master Uninstaller
# Version: 3.0.0
# Description: Safely removes all SteamMachine-DIY components, hooks and symlinks
# Repository: https://github.com/dlucca1986/SteamMachine-DIY
# License: MIT
# =============================================================================

set -eou pipefail

# --- Environment & Colors ---
export LANG=C
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# --- Paths to Clean ---
BIN_FILES=(
    "/usr/local/bin/os-session-select"
    "/usr/local/bin/set-sddm-session"
    "/usr/local/bin/steamos-session-launch"
    "/usr/bin/steamos-session-select"
)
HELPERS_DIR="/usr/local/bin/steamos-helpers"
POLKIT_DIR="/usr/bin/steamos-polkit-helpers"
SDDM_CONF="/etc/sddm.conf.d/10-wayland.conf"
SDDM_AUTOLOGIN="/etc/sddm.conf.d/zz-steamos-autologin.conf"
SUDOERS_FILE="/etc/sudoers.d/steamos-switcher"
SESSION_FILE="/usr/share/wayland-sessions/steamos-switcher.desktop"
APP_FILE="/usr/share/applications/GameMode.desktop"
PACMAN_HOOK="/etc/pacman.d/hooks/gamescope-capabilities.hook"

# --- UI Functions ---
info()    { echo -e "${CYAN}[SYSTEM]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $1"; }
error()   { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# --- Logic Functions ---

check_privileges() {
    if [[ $EUID -ne 0 ]]; then
        error "This script must be run with sudo (e.g., sudo ./uninstall.sh)"
    fi
}

remove_files() {
    info "Removing binaries and scripts..."
    for f in "${BIN_FILES[@]}"; do
        if [[ -f "$f" || -L "$f" ]]; then 
            rm -f "$f" && success "Removed $f"
        fi
    done
    
    if [[ -d "$HELPERS_DIR" ]]; then
        rm -rf "$HELPERS_DIR" && success "Removed $HELPERS_DIR"
    fi

    info "Cleaning system integration (SDDM & Sessions)..."
    [[ -f "$SDDM_CONF" ]] && rm -f "$SDDM_CONF" && success "Removed SDDM config"
    [[ -f "$SDDM_AUTOLOGIN" ]] && rm -f "$SDDM_AUTOLOGIN" && success "Removed SDDM autologin override"
    [[ -f "$SESSION_FILE" ]] && rm -f "$SESSION_FILE" && success "Removed Wayland session"
    [[ -f "$APP_FILE" ]] && rm -f "$APP_FILE" && success "Removed Application menu entry"
    [[ -f "$SUDOERS_FILE" ]] && rm -f "$SUDOERS_FILE" && success "Removed Sudoers policy"
    
    info "Removing persistence hooks..."
    [[ -f "$PACMAN_HOOK" ]] && rm -f "$PACMAN_HOOK" && success "Removed Pacman capability hook"
}

remove_links() {
    info "Removing compatibility symlinks..."
    
    # Clean legacy link if exists
    [[ -L "/bin/steamos-session-select" ]] && rm -f "/bin/steamos-session-select"
    
    if [[ -d "$POLKIT_DIR" ]]; then
        rm -rf "$POLKIT_DIR" && success "Removed $POLKIT_DIR"
    fi
}

clean_user_data() {
    local REAL_USER=${SUDO_USER:-$USER}
    local USER_HOME=$(getent passwd "$REAL_USER" | cut -d: -f6)
    local TARGET_DIR="$USER_HOME/.config/steamos-diy"

    # --- Desktop Shortcut Removal ---
    # Detect Desktop directory via xdg-user-dir
    local DESKTOP_DIR=$(sudo -u "$REAL_USER" xdg-user-dir DESKTOP 2>/dev/null || echo "$USER_HOME/Desktop")
    if [[ -f "$DESKTOP_DIR/GameMode.desktop" ]]; then
        rm -f "$DESKTOP_DIR/GameMode.desktop"
        success "Removed Desktop shortcut from $DESKTOP_DIR"
    fi

    # --- Configuration and Logs Removal ---
    if [[ -d "$TARGET_DIR" ]]; then
        echo -e "${YELLOW}"
        read -p "[QUESTION] Do you want to remove user config files and logs in $TARGET_DIR? (y/N): " -n 1 -r
        echo -e ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm -rf "$TARGET_DIR"
            success "User configuration and logs deleted."
        else
            info "User configuration preserved in $TARGET_DIR."
        fi
    fi
}

# --- Execution ---
clear
echo -e "${RED}${BOLD}==================================================${NC}"
echo -e "${RED}${BOLD}            STEAM MACHINE DIY - UNINSTALLER       ${NC}"
echo -e "${RED}${BOLD}==================================================${NC}"

check_privileges
remove_files
remove_links
clean_user_data

# Performance restoration (Optional)
if [[ -x /usr/bin/gamescope ]]; then
    setcap -r /usr/bin/gamescope 2>/dev/null && info "Reset Gamescope capabilities."
fi

echo -e "\n${GREEN}${BOLD}Uninstallation Complete!${NC}"
info "The system has been restored to its original state."
