# 🎮 SteamOS Switcher for Desktop/Laptop

> ### "Bringing the Seamless SteamOS Experience to any Linux Distribution (Arch-based)" 🚀

---

## 🌟 About the Project

Hi, I'm **Daniele**, and I’m a hardcore gaming fanatic! 🕹️

If you love the Steam Deck gaming experience as much as I do, you’re in the right place. I developed this project to faithfully simulate the **SteamOS ecosystem** on standard desktops and laptops, bringing that seamless "console-like" feeling to your Linux machine.

---

## ✨ Key Features

* **🔄 Seamless Session Switching**
  No more clunky menus! This enables the **"Switch to Desktop"** button directly from a standalone gamescope-session, just like on a real Steam Deck. It takes you straight to your KDE Desktop without stopping at the login screen.
  
* **🛡️ Clean & Safe Architecture**
  I care about your OS! Instead of overwriting critical system files, I use a **"Master/Helper" structure** in `/usr/local/bin`. Everything is handled by transparent, easy-to-read **Bash scripts**, making it professional, safe, and keeping your system clutter-free.

* **🖱️ One-Click Return to Gaming Mode**
  I’ve included a handy desktop shortcut! You’ll find a **"Return to Gaming Mode"** icon right on your KDE desktop, so you can jump back into your library with just one click.

* **📦 Optimized for Arch-based Distros**
  Specifically tuned for the Arch ecosystem to ensure maximum compatibility and performance.

---

## 🚀 Quick Installation

To get started, simply copy and paste these commands into your terminal:

```bash
git clone [https://github.com/dlucca1986/SteamOS-Like-Session-Switcher-for-Linux-Desktop.git](https://github.com/dlucca1986/SteamOS-Like-Session-Switcher-for-Linux-Desktop.git)
cd SteamOS-Like-Session-Switcher-for-Linux-Desktop
chmod +x install.sh
sudo ./install.sh
