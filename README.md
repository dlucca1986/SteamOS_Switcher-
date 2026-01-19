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

* **GPU**: AMD Radeon (Required for full compatibility and RADV features).
* **Desktop Environment**: KDE Plasma (6.x recommended).
* **Display Manager**: SDDM (Required for session switching logic).
* **Core Software**: `steam`, `gamescope`, `mangohud`, `gamemode`.


---


## 🚀 Quick Installation

To get started, copy and paste these commands into your terminal:

```bash
git clone https://github.com/dlucca1986/SteamOS-Like-Session-Switcher-for-Linux-Desktop.git
cd SteamOS-Like-Session-Switcher-for-Linux-Desktop
chmod +x install.sh
./install.sh
```

- 💡 Note: The installer is interactive and will automatically verify your AMD hardware, install missing dependencies, and configure the necessary system permissions.

## 🛡️ Clean Architecture & Safety :

I value your system's integrity. This project is designed to be as non-intrusive as possible:

- No Overwriting: This project does not modify core system files; it uses /usr/local/bin and dedicated config directories.

- Transparent Sudoers: A minimal rule is added to /etc/sudoers.d/ only for the session-switching logic.

- Full Reversibility: Every change made by the installer can be undone using the uninstaller.

---


## 🗑️ Uninstallation
If you wish to revert all changes, I’ve included a dedicated uninstaller. It will completely remove all scripts, symbolic links, desktop shortcuts, and the sudoers rule:
```bash
chmod +x uninstall.sh
sudo ./uninstall.sh
```

