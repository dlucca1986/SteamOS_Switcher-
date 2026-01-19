#!/bin/bash
# =============================================================================
# Session Switcher Uninstaller
# Description: Completely removes the SteamOS-like environment and restores
#              standard system configurations.
# Repository: https://github.com/dlucca1986/SteamOS_Switcher-
# =============================================================================

set -e

# --- Environment & Colors ---
export LANG=C
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# --- Configuration ---
HELPERS_SOURCE="/usr/local/bin/steamos-helpers"
HELPERS_LINKS="/usr/bin/steamos-helpers"
SDDM_CONF_DIR="/etc/sddm.conf.d"
SDDM_WAYLAND_CONF="$SDDM_CONF_DIR/10-wayland.conf"
SUDOERS_FILE="/etc/sudoers.d/steamos-switcher"
AUTOLOGIN_CONF="$SDDM_CONF_DIR/zz-steamos-autologin.conf"

# --- UI Functions ---
info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $1"; }
error()   { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# --- Logic Functions ---

remove_scripts() {
    info "Removing core binaries and helper scripts..."
    
    # Core Binaries
    local core_bins=(os-session-select set-sddm-session steamos-session-launch steamos-session-select)
    for bin in "${core_bins[@]}"; do
        if [ -f "/usr/local/bin/$bin" ]; then
            sudo rm -f "/usr/local/bin/$bin"
            info "Removed /usr/local/bin/$bin"
        fi
    done

    # Helpers and Symlinks
    if [ -d "$HELPERS_LINKS" ]; then
        sudo rm -rf "$HELPERS_LINKS"
        info "Removed compatibility symlinks directory: $HELPERS_LINKS"
    fi

    if [ -d "$HELPERS_SOURCE" ]; then
        sudo rm -rf "$HELPERS_SOURCE"
        info "Removed helper source directory: $HELPERS_SOURCE"
    fi
}

remove_security_configs() {
    info "Reverting security policies..."
    if [ -f "$SUDOERS_FILE" ]; then
        sudo rm -f "$SUDOERS_FILE"
        success "Sudoers policy removed."
    fi
}

remove_sddm_configs() {
    info "Reverting SDDM configurations..."
    
    if [ -f "$SDDM_WAYLAND_CONF" ]; then
        sudo rm -f "$SDDM_WAYLAND_CONF"
        success "SDDM Wayland tweaks removed."
    fi

    if [ -f "$AUTOLOGIN_CONF" ]; then
        sudo rm -f "$AUTOLOGIN_CONF"
        success "Stale autologin overrides removed."
    fi
}

revert_performance_tweaks() {
    info "Reverting Gamescope performance capabilities..."
    local gpath
    gpath=$(command -v gamescope)
    if [ -x "$gpath" ]; then
        # Check if capabilities are set before trying to remove
        if getcap "$gpath" | grep -q 'cap_'; then
            sudo setcap -r "$gpath"
            success "Capabilities removed from $gpath"
        fi
    fi
}

# --- Main Execution ---
clear
echo -e "${BLUE}==========================================${NC}"
echo -e "${RED}    SteamMachine DIY - Uninstaller${NC}"
echo -e "${BLUE}==========================================${NC}"
echo
warn "This will remove all SteamOS-like session components."
read -p "Are you sure you want to proceed? [y/N] " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    info "Uninstallation aborted by user."
    exit 0
fi

remove_scripts
remove_security_configs
remove_sddm_configs
revert_performance_tweaks

echo
success "Uninstallation completed successfully!"
info "Note: A system reboot is recommended to fully restore default SDDM behavior."
