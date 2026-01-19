#!/bin/bash
set -e

# Percorsi come da tua specifica
HELPERS_SOURCE="/usr/local/bin/steamos-helpers"
HELPERS_LINKS="/usr/bin/steamos-helpers"
SDDM_CONF_DIR="/etc/sddm.conf.d"

echo "🚀 Installazione SteamMachine DIY..."

# 1. Creazione cartelle
sudo mkdir -p "$HELPERS_SOURCE"
sudo mkdir -p "$HELPERS_LINKS"
sudo mkdir -p "$SDDM_CONF_DIR"

# 2. Copia dei binari principali in /usr/local/bin/
sudo cp os-session-select set-sddm-session steamos-session-launch \
        steamos-session-select /usr/local/bin/

# 3. Copia degli helper in /usr/local/bin/steamos-helpers/
sudo cp jupiter-biosupdate steamos-select-branch steamos-set-timezone \
        steamos-update steamos-select-session "$HELPERS_SOURCE/"

sudo chmod +x /usr/local/bin/os-session-select
sudo chmod +x /usr/local/bin/set-sddm-session
sudo chmod +x /usr/local/bin/steamos-session-launch
sudo chmod +x /usr/local/bin/steamos-session-select
sudo chmod +x "$HELPERS_SOURCE"/*

# 4. Creazione Symlinks in /usr/bin/steamos-helpers/
echo "🔗 Creazione symlinks di compatibilità in $HELPERS_LINKS..."
for file in jupiter-biosupdate steamos-select-branch steamos-set-timezone steamos-update steamos-select-session; do
    sudo ln -sf "$HELPERS_SOURCE/$file" "$HELPERS_LINKS/$file"
done

# 5. Sudoers (Punta ai percorsi corretti in /usr/local/bin)
SUDOERS_FILE="/etc/sudoers.d/steamos-switcher"
SUDOERS_TEMP=$(mktemp)
cat <<EOF > "$SUDOERS_TEMP"
ALL ALL=(ALL) NOPASSWD: /usr/local/bin/set-sddm-session
ALL ALL=(ALL) NOPASSWD: /usr/local/bin/steamos-session-select
EOF
if visudo -cf "$SUDOERS_TEMP"; then
    sudo cp "$SUDOERS_TEMP" "$SUDOERS_FILE"
    sudo chmod 440 "$SUDOERS_FILE"
else
    echo "Errore Sudoers"
    exit 1
fi
rm "$SUDOERS_TEMP"

echo "✅ Sistema allineato e folder creati."
