#!/bin/bash
# =============================================================================
# SteamMachine-DIY - Master Installer
# Version: 3.0.0
# Description: Professional deployment for SteamOS-like experience on Arch
# Repository: https://github.com/dlucca1986/SteamMachine-DIY
# License:MIT
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

SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# --- Destination Paths ---
BIN_DEST="/usr/local/bin"
HELPERS_DEST="/usr/local/bin/steamos-helpers"
POLKIT_LINKS_DIR="/usr/bin/steamos-polkit-helpers"
SDDM_CONF_DIR="/etc/sddm.conf.d"
SUDOERS_FILE="/etc/sudoers.d/steamos-switcher"
WAYLAND_SESSIONS="/usr/share/wayland-sessions"
APP_ENTRIES="/usr/share/applications"

USER_CONFIG_DIR="$HOME/.config/steamos-diy"
USER_CONFIG_FILE="$USER_CONFIG_DIR/config"

# --- UI Functions ---
info()    { echo -e "${CYAN}[SYSTEM]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $1"; }
error()   { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# --- Logic Functions ---

check_privileges() {
    if [[ $EUID -ne 0 ]]; then
        error "This script must be run with sudo (e.g., sudo ./install.sh)"
    fi
}

install_dependencies() {
    info "Verifying hardware and installing dependencies..."
    
    # Enable Multilib if not present
    if ! grep -q "^\[multilib\]" /etc/pacman.conf; then
        info "Enabling [multilib] repository..."
        sed -i '/^#\[multilib\]/,+1 s/^#//' /etc/pacman.conf
        pacman -Sy
    fi

    local pkgs=(steam gamescope xorg-xwayland mangohud lib32-mangohud gamemode vulkan-icd-loader lib32-vulkan-icd-loader mesa-utils)
    
    # GPU Specific drivers
    if lspci | grep -iq "AMD"; then
        pkgs+=(vulkan-radeon lib32-vulkan-radeon)
    elif lspci | grep -iq "Intel"; then
        pkgs+=(vulkan-intel lib32-vulkan-intel)
    fi

    pacman -S --needed --noconfirm "${pkgs[@]}" || error "Failed to install packages."
    success "Hardware dependencies ready."
}

deploy_binaries() {
    info "Deploying binaries to $BIN_DEST..."
    
    mkdir -p "$HELPERS_DEST"
    
    # Copy core binaries
    cp "$SOURCE_DIR/bin/os-session-select" "$BIN_DEST/"
    cp "$SOURCE_DIR/bin/set-sddm-session" "$BIN_DEST/"
    cp "$SOURCE_DIR/bin/steamos-session-launch" "$BIN_DEST/"
    
    # Copy helpers
    cp "$SOURCE_DIR/bin/steamos-helpers/"* "$HELPERS_DEST/"
    
    # Permissions
    chmod +x "$BIN_DEST/os-session-select" \
             "$BIN_DEST/set-sddm-session" \
             "$BIN_DEST/steamos-session-launch"
    chmod +x "$HELPERS_DEST/"*
    
    success "Binaries deployed."
}

setup_integration() {
    info "Integrating with system (Desktop & SDDM)..."
    
    # Wayland Session
    mkdir -p "$WAYLAND_SESSIONS"
    cp "$SOURCE_DIR/desktop-entries/steamos-switcher.desktop" "$WAYLAND_SESSIONS/"
    
    # App Menu Entry
    mkdir -p "$APP_ENTRIES"
    cp "$SOURCE_DIR/desktop-entries/GameMode.desktop" "$APP_ENTRIES/"
    
    # SDDM Config
    mkdir -p "$SDDM_CONF_DIR"
    cp "$SOURCE_DIR/sddm-config/10-wayland.conf" "$SDDM_CONF_DIR/"
    
    success "Integration entries created."
}

create_symlinks() {
    info "Creating compatibility symlinks in $POLKIT_LINKS_DIR..."
    
    mkdir -p "$POLKIT_LINKS_DIR"
    
    # Main switcher link (referenced by /bin link in user stats)
    ln -sf "$BIN_DEST/os-session-select" "$POLKIT_LINKS_DIR/steamos-session-select"
    ln -sf "$POLKIT_LINKS_DIR/steamos-session-select" "/bin/steamos-session-select"
    
    # Helper links
    for helper in "$HELPERS_DEST"/*; do
        name=$(basename "$helper")
        ln -sf "$helper" "$POLKIT_LINKS_DIR/$name"
    done
    
    success "Symlinks established."
}

setup_security() {
    info "Configuring NOPASSWD for session switching..."
    
    cat <<EOF > "$SUDOERS_FILE"
# SteamMachine DIY - Session Switching Policies
ALL ALL=(ALL) NOPASSWD: /usr/local/bin/set-sddm-session
ALL ALL=(ALL) NOPASSWD: /usr/local/bin/os-session-select
EOF
    chmod 440 "$SUDOERS_FILE"
    success "Sudoers rules updated."
}

setup_user_config() {
    info "Deploying User Configuration Template..."
    
    # Note: This runs as sudo, so we must find the real user
    local REAL_USER=${SUDO_USER:-$USER}
    local USER_HOME=$(getent passwd "$REAL_USER" | cut -d: -f6)
    local TARGET_DIR="$USER_HOME/.config/steamos-diy"
    
    mkdir -p "$TARGET_DIR"
    if [[ ! -f "$TARGET_DIR/config" ]]; then
        cp "$SOURCE_DIR/config/steamos-diy.config.example" "$TARGET_DIR/config"
        chown -R "$REAL_USER":"$REAL_USER" "$TARGET_DIR"
        success "Default config deployed to $TARGET_DIR/config"
    else
        warn "User config already exists. Skipping deployment."
    fi
}

# --- Execution ---
clear
echo -e "${CYAN}${BOLD}==================================================${NC}"
echo -e "${CYAN}${BOLD}           STEAM MACHINE DIY - INSTALLER          ${NC}"
echo -e "${CYAN}${BOLD}==================================================${NC}"

check_privileges
install_dependencies
deploy_binaries
setup_integration
create_symlinks
setup_security
setup_user_config

# Performance optimization
if [[ -x /usr/bin/gamescope ]]; then
    setcap 'cap_sys_admin,cap_sys_nice,cap_ipc_lock+ep' /usr/bin/gamescope 2>/dev/null || warn "Failed to set gamescope capabilities."
fi

echo -e "\n${GREEN}${BOLD}Installation Successful!${NC}"
echo -e "${CYAN}Next Steps:${NC}"
echo -e "1. ${BOLD}Logout${NC} from your current session."
echo -e "2. Select ${BOLD}'SteamOS Switcher'${NC} from the SDDM session menu."
echo -e "3. Enjoy your Steam Machine experience!\n"
