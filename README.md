# 🎮 SteamOS Switcher for Desktop/Laptop ( Full Amd Build )


> ### "Bringing the Seamless SteamOS Experience to any Linux Distribution (Arch-based)" 🚀


---


## 🌟 About the Project

Hi, I'm **Daniele**, and I’m a hardcore gaming fanatic! 🕹️

If you love the Steam Deck gaming experience as much as I do, you’re in the right place. I developed this project to faithfully simulate the **SteamOS ecosystem** on standard desktops and laptops, bringing that seamless "console-like" feeling to your Linux machine.


---


## ✨ Key Features

* **🔄 Seamless Session Switching**:
  Native support for the **"Switch to Desktop"** button. Transition between Gamescope and KDE Plasma without ever seeing a login screen or typing a password.

* **🎮 Pure Console Experience**:
  Pre-configured for **1080p/120Hz** with **HDR** and **Adaptive Sync (VRR)** out of the box.

* **🛡️ Professional & Clean Architecture**:
  The project follows a **"Master/Helper" structure**. No system files are harmed; everything is handled via transparent Bash scripts in `/usr/local/bin`.

* **🔴 Performance Ready**:
  Integrated with **Feral GameMode** and **MangoHud** for real-time monitoring and maximum CPU priority.

---


## 📖 Documentation & Wiki:

* **For detailed guides and technical information, please visit our Project Wiki.**
* https://github.com/dlucca1986/SteamOS-Like-Session-Switcher-for-Linux-Desktop/wiki


---


## 🤝 Acknowledgments & Credits:

This project wouldn't have been possible without the amazing work and guides from the Linux gaming community. A special thanks to:

* **[shahnawazshahin](https://github.com/shahnawazshahin/steam-using-gamescope-guide):** For writing a wonderful guide that served as a primary inspiration for this project.
* **[berturion](https://www.reddit.com/r/archlinux/comments/1p2fmso/comment/nqjvr44/):** For the brilliant technical insights that helped finalize the desktop switching logic.
* **The SteamOS & Gamescope Teams:** For building the foundation of handheld gaming on Linux.
* **Community Guides:** Big thanks to the developers and enthusiasts on **Reddit** (r/SteamDeck, r/LinuxGaming) and the **Arch Wiki** contributors.
* **Open Source Contributors:** To everyone sharing scripts and ideas to make Linux a better place for gamers. 


---


## ❤️ Support the Project

Built with ❤️ by a gaming fan for the Linux Community.  
**If you like this project, please leave a ⭐ Star on GitHub!** It helps other gamers find it.


---


## 🛠️ Prerequisites:

* **GPU**: AMD Radeon (Required for full compatibility with these scripts).
* **Desktop Environment**: KDE Plasma (6.x recommended).
* **Display Manager**: SDDM (The logic is optimized for SDDM session switching).
* **Software**:

```bash
sudo pacman -S steam gamescope mangohud lib32-mangohud gamemode
```


---


## 🚀 Quick Installation

To get started, copy and paste these commands into your terminal:

```bash
git clone https://github.com/dlucca1986/SteamOS-Like-Session-Switcher-for-Linux-Desktop.git
cd SteamOS-Like-Session-Switcher-for-Linux-Desktop
chmod +x install.sh
sudo ./install.sh

```


---


## ⚠️ Mandatory Post-Installation Step

> "To achieve a seamless transition between Gaming Mode and Desktop, the session switcher requires permission to communicate with your Display Manager (SDDM) without a password prompt. Without this configuration, the 'Switch' command will fail. For security and stability, please follow the automated Sudoers setup."

* 👉 **Action Required**: [Follow the Sudoers Setup Guide here](https://github.com/dlucca1986/SteamOS-Like-Session-Switcher-for-Linux-Desktop/wiki/Sudoers-Setup)

---

## 🗑️ Uninstallation
To completely remove the switcher and all its configurations:
```bash
chmod +x uninstall.sh
sudo ./uninstall.sh
```

