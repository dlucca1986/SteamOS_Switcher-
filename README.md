# 🎮 SteamOS Switcher for Handhelds

### "Bringing the Seamless SteamOS Experience to Any Linux Distribution"

## 🌟 About the Project
Hi! I'm [Your Name/Username]. I developed this project to bridge the gap between standard Linux installations and the specialized Steam Deck UI (Gamescope).

When running Steam on handheld devices like the ROG Ally, Legion Go, or even standard PCs, users often face broken "Switch to Desktop" buttons or infinite update loops. This project provides a clean, professional-grade set of scripts that emulate the original SteamOS behavior, making the "Game Mode" experience fluid and reliable for everyone.

## ✨ Key Features
* **Seamless Session Switching:** Enables the "Switch to Desktop" button directly from the Steam Deck UI.
* **Update System Emulation:** Correctly handles system update signals (Exit Code 7) to prevent UI errors.
* **Professional Architecture:** Uses a "Master/Helper" structure in `/usr/local/bin` to ensure system integrity and avoid overwriting critical OS files.
* **Handheld Ready:** Designed with handheld users in mind, ensuring compatibility with the Steam "Jupiter" ecosystem.

## 🚀 Quick Start
Open your terminal and run the following commands:
```bash
git clone [https://github.com/your-username/steamos-switcher.git](https://github.com/your-username/steamos-switcher.git)
cd steamos-switcher
chmod +x install.sh
sudo ./install.sh
