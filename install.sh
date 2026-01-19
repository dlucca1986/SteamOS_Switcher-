#!/bin/bash
# =============================================================================
# Session Switcher Installer
# Description: Configures Arch Linux to behave like SteamOS (Gaming Mode/Desktop)
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

DEPENDENCIES=(
    steam gamescope mangohud lib32-mangohud gamemode 
    vulkan-icd-loader lib32-vulkan-icd-loader 
    vulkan-radeon lib32-vulkan-radeon
)

# --- UI Functions ---
info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $1"; }
error()   { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# --- Logic Functions ---

check_multilib() {
    info "Checking multilib repository..."
    if ! grep -q "^\[multilib\]" /etc/pacman.conf; then
        warn "Multilib repository is disabled. Enabling..."
        sudo sed -i '/^#\[multilib\]/,+1 s/^#//' /etc/pacman.conf
        sudo pacman -Sy
        success "Multilib enabled."
    else
        success "Multilib is already enabled."
    fi
}

install_dependencies() {
    info "Verifying system dependencies..."
    local missing_pkgs=()
    for pkg in "${DEPENDENCIES[@]}"; do
        if ! pacman -Qi "$pkg" &> /dev/null; then
            missing_pkgs+=("$pkg")
        fi
    done

    if [ ${#missing_pkgs[@]} -ne 0 ]; then
        warn "Missing packages: ${missing_pkgs[*]}"
        read -p "Do you want to install them now? [y/N] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            sudo pacman -S --needed "${missing_pkgs[@]}"
        else
            error "Dependencies not met. Installation aborted."
        fi
    fi
    success "All dependencies satisfied."
}

setup_directories() {
    info "Creating system directories..."
    sudo mkdir -p "$HELPERS_SOURCE" "$HELPERS_LINKS" "$SDDM_CONF_DIR"
}

deploy_scripts() {
    info "Deploying core binaries and helpers..."
    
    # Core Binaries
    local core_bins=(os-session-select set-sddm-session steamos-session-launch steamos-session-select)
    sudo cp "${core_bins[@]}" /usr/local/bin/
    
    # Helpers
    local helper_scripts=(jupiter-biosupdate steamos-select-branch steamos-set-timezone steamos-update steamos-select-session)
    sudo cp "${helper_scripts[@]}" "$HELPERS_SOURCE/"

    # Permissions
    sudo chmod +x /usr/local/bin/os-session-select /usr/local/bin/set-sddm-session \
                  /usr/local/bin/steamos-session-launch /usr/local/bin/steamos-session-select
    sudo chmod +x "$HELPERS_SOURCE"/*
    
    # Compatibility Symlinks
    info "Generating compatibility symlinks..."
    for file in "${helper_scripts[@]}"; do
        sudo ln -sf "$HELPERS_SOURCE/$file" "$HELPERS_LINKS/$file"
    done
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
    rm "$temp_sudo"
}

configure_sddm() {
    info "Applying SDDM Wayland tweaks..."
    sudo tee "$SDDM_WAYLAND_CONF" > /dev/null <<EOF
[General]
# Force SDDM to use Wayland to prevent conflicts with X11 sockets (e.g., :0)
DisplayServer=wayland
GreeterEnvironment=QT_WAYLAND_SHELL_INTEGRATION=layer-shell

[Wayland]
# Optimized for KDE Plasma 6
CompositorCommand=kwin_wayland --drm --no-lockscreen --no-global-shortcuts --locale POSIX --inputmethod maliit
EOF
}

optimize_performance() {
    info "Optimizing Gamescope performance capabilities..."
    local gpath
    gpath=$(command -v gamescope)
    if [ -x "$gpath" ]; then
        sudo setcap 'cap_sys_admin,cap_sys_nice,cap_ipc_lock+ep' "$gpath"
        success "Capabilities assigned to $gpath"
    else
        warn "Gamescope binary not found, skipping setcap."
    fi
}

setup_pacman_hook() {
    info "Setting up Pacman Hook for Gamescope capabilities..."
    
    sudo mkdir -p /etc/pacman.d/hooks
    
    sudo tee /etc/pacman.d/hooks/gamescope-capabilities.hook > /dev/null <<EOF
[Trigger]
Operation = Install
Operation = Upgrade
Type = Package
Target = gamescope

[Action]
Description = Restoring Gamescope capabilities after update...
When = PostTransaction
Exec = /usr/bin/setcap 'cap_sys_admin,cap_sys_nice,cap_ipc_lock+ep' /usr/bin/gamescope
EOF

    success "Pacman hook created: Gamescope will keep its permissions after updates."
}


# --- Main Execution ---
clear
echo -e "${BLUE}==========================================${NC}"
echo -e "${GREEN}    SteamMachine DIY - Installer${NC}"
echo -e "${BLUE}==========================================${NC}"
echo

check_multilib
install_dependencies
setup_directories
deploy_scripts
configure_security
configure_sddm
optimize_performance
setup_pacman_hook  # <--- DEVI AGGIUNGERE QUESTA RIGA

echo
success "Installation completed successfully!"
info "Note: You might need to restart SDDM or reboot to apply all changes."

