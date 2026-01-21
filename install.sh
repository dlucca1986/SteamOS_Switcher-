#!/bin/bash
# =============================================================================
# SteamMachine-DIY Installer
# Description: Configures Arch Linux to behave like SteamOS
# Repository: https://github.com/dlucca1986/SteamMachine-DIY
# =============================================================================

# set -e interrompe lo script al primo errore
set -e

# --- Environment & Colors ---
export LANG=C
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Directory sorgente dello script
SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# --- Configuration Paths ---
HELPERS_DEST="/usr/local/bin/steamos-helpers"
HELPERS_LINKS_DIR="/usr/bin/steamos-polkit-helpers"
SDDM_CONF_DIR="/etc/sddm.conf.d"
SDDM_WAYLAND_CONF="$SDDM_CONF_DIR/10-wayland.conf"
SUDOERS_FILE="/etc/sudoers.d/steamos-switcher"

# --- User Config Path ---
USER_CONFIG_DIR="$HOME/.config/steamos-diy"
USER_CONFIG_FILE="$USER_CONFIG_DIR/config"

# --- UI Functions ---
info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $1"; }
error()   { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# Funzione per copia sicura: se fallisce, ferma tutto.
safe_cp() {
    if [ -f "$1" ]; then
        sudo cp "$1" "$2" || error "Failed to copy $1 to $2"
    elif [ -d "$1" ]; then
        sudo cp -r "$1/." "$2/" || error "Failed to copy directory $1 to $2"
    else
        error "Source missing: $1"
    fi
}

# --- Logic Functions ---

check_multilib() {
    info "Checking multilib repository..."
    if ! grep -q "^\[multilib\]" /etc/pacman.conf; then
        info "Enabling multilib..."
        sudo sed -i '/^#\[multilib\]/,+1 s/^#//' /etc/pacman.conf
        sudo pacman -Sy
    fi
    success "Multilib is enabled."
}

install_dependencies() {
    info "Detecting GPU Hardware and verifying dependencies..."
    local pkgs=(steam gamescope mangohud lib32-mangohud gamemode vulkan-icd-loader lib32-vulkan-icd-loader mesa-utils)
    
    if lspci | grep -iq "AMD"; then
        pkgs+=(vulkan-radeon lib32-vulkan-radeon)
    elif lspci | grep -iq "Intel"; then
        pkgs+=(vulkan-intel lib32-vulkan-intel)
    fi

    sudo pacman -S --needed --noconfirm "${pkgs[@]}" || error "Failed to install dependencies."
    success "Dependencies installed."
}

deploy_overlay() {
    info "Deploying system files from repository overlay..."
    
    # Crea le directory di base
    sudo mkdir -p "$HELPERS_DEST" "$HELPERS_LINKS_DIR" "$SDDM_CONF_DIR" "/usr/share/wayland-sessions" "/usr/share/steamos-switcher"

    # Copia l'intera struttura 'usr' dal repo al sistema
    if [ -d "$SOURCE_DIR/usr" ]; then
        safe_cp "$SOURCE_DIR/usr" "/usr"
    else
        error "Directory 'usr' not found in $SOURCE_DIR. Check repository structure."
    fi

    # Rendi i binari eseguibili
    sudo chmod +x /usr/local/bin/os-session-select
    sudo chmod +x /usr/local/bin/set-sddm-session
    sudo chmod +x /usr/local/bin/steamos-session-launch
    sudo chmod +x /usr/local/bin/steamos-session-select
    sudo chmod +x "$HELPERS_DEST"/*

    # Creazione dei Simlink per i Polkit Helpers
    info "Creating compatibility symlinks..."
    for helper in "$HELPERS_DEST"/*; do
        name=$(basename "$helper")
        sudo ln -sf "$helper" "$HELPERS_LINKS_DIR/$name" || error "Failed to link $name"
    done

    # Shortcut sul Desktop dell'utente
    if [ -f "/usr/share/steamos-switcher/GameMode.desktop" ]; then
        cp "/usr/share/steamos-switcher/GameMode.desktop" "$HOME/Desktop/" 2>/dev/null || true
        chmod +x "$HOME/Desktop/GameMode.desktop" 2>/dev/null || true
    fi
    success "System overlay deployed successfully."
}

setup_user_config() {
    info "Setting up user configuration..."
    mkdir -p "$USER_CONFIG_DIR"
    if [ ! -f "$USER_CONFIG_FILE" ]; then
        cat << EOF > "$USER_CONFIG_FILE"
TARGET_WIDTH=1920
TARGET_HEIGHT=1080
REFRESH_RATE=60
ENABLE_HDR=0
ENABLE_VRR=0
ENABLE_MANGOAPP=1
CUSTOM_ARGS=""
EOF
    fi
    success "User configuration ready."
}

configure_security() {
    info "Configuring Sudoers policies..."
    local temp_sudo=$(mktemp)
    cat <<EOF > "$temp_sudo"
# SteamMachine DIY - Session Switcher Permissions
ALL ALL=(ALL) NOPASSWD: /usr/local/bin/set-sddm-session
ALL ALL=(ALL) NOPASSWD: /usr/local/bin/steamos-session-select
EOF
    if visudo -cf "$temp_sudo"; then
        sudo cp "$temp_sudo" "$SUDOERS_FILE"
        sudo chmod 440 "$SUDOERS_FILE"
    else
        error "Sudoers validation failed."
    fi
    rm -f "$temp_sudo"
    success "Sudoers configured."
}

configure_sddm() {
    info "Applying SDDM configuration..."
    # Copia la configurazione SDDM se presente nell'overlay etc o creala se manca
    if [ -f "$SOURCE_DIR/etc/sddm.conf.d/10-wayland.conf" ]; then
        sudo mkdir -p "/etc/sddm.conf.d"
        safe_cp "$SOURCE_DIR/etc/sddm.conf.d/10-wayland.conf" "$SDDM_WAYLAND_CONF"
    else
        sudo tee "$SDDM_WAYLAND_CONF" > /dev/null <<EOF
[General]
DisplayServer=wayland
GreeterEnvironment=QT_WAYLAND_SHELL_INTEGRATION=layer-shell

[Wayland]
CompositorCommand=kwin_wayland --drm --no-lockscreen --no-global-shortcuts --locale POSIX --inputmethod maliit
EOF
    fi
    success "SDDM tweaked for Wayland."
}

optimize_performance() {
    info "Setting Gamescope capabilities..."
    local gpath="/usr/bin/gamescope"
    if [ -x "$gpath" ]; then
        sudo setcap 'cap_sys_admin,cap_sys_nice,cap_ipc_lock+ep' "$gpath" || warn "Could not set capabilities."
    fi
}

# --- Main Execution ---
clear
echo -e "${BLUE}==========================================${NC}"
echo -e "${GREEN}    SteamMachine DIY - Installer${NC}"
echo -e "${BLUE}==========================================${NC}"

check_multilib
install_dependencies
deploy_overlay
setup_user_config
configure_security
configure_sddm
optimize_performance

echo
success "Installation completed successfully!"
info "Please Logout and select 'SteamMachine' from SDDM."
