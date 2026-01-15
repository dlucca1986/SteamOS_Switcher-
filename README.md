# SteamOS-Like-Session-Switcher-for-Linux-Desktop
This project provides a set of scripts to replicate the seamless session switching experience of the Steam Deck on a standard PC. It allows you to toggle between KDE Plasma (Desktop Mode) and Steam Big Picture/Gamescope (Game Mode) using SDDM.

What's inside ?

. set-sddm-session: 
  The core logic. It writes a temporary configuration to /etc/sddm.conf.d/ to set the autologin session for the next boot and triggers a delayed restart of the Display     Manager.

. gamescope-session: 
  The Game Mode launcher. It starts Steam with -steamdeck parameters inside a Gamescope standalone session.

. steamos-session-select:
  A quick wrapper to call the system session selector and return to Plasma.

Prerequisites :

Before installing, ensure your system meets these requirements:

Operating System: Arch Linux (or any Arch-based distro).

Desktop Environment: KDE Plasma (Required for the plasma session target).

Display Manager: SDDM (Required for the autologin switching logic).

Check if your GPU supports Vulkan.

Essential Packages:

gamescope: The micro-compositor for the Game Mode.

steam: Ensure it's the official version.

Additional Software :

mangohud: (Optional) For performance monitoring.

GameMode: (Optional) is a daemon that automatically optimizes your system while playing games. 

ProtonUp-Qt: (Optional) is a GUI tool to manage different versions of GE Proton.
