# SteamOS-Like-Session-Switcher-for-Linux-Desktop -W.I.P
This project provides a set of scripts to replicate the seamless session switching experience of the Steam Deck on a standard PC. It allows you to toggle between KDE Plasma (Desktop Mode) and Steam Big Picture/Gamescope (Game Mode) using SDDM.




What's inside ?


set-sddm-session: 
  The core logic.
  It writes a temporary configuration to /etc/sddm.conf.d/ to set the autologin session for the next boot and triggers a delayed restart of the Display Manager.


gamescope-session: 
  The Game Mode launcher.
  It starts Steam with -steamdeck parameters inside a Gamescope standalone session.


steamos-session-select:
  A quick wrapper to call the system session selector and return to Plasma.

os-session-select: 
  A simple wrapper script used by the Steam Deck UI to trigger the return to the desktop session.

steamos-set-timezone:
  A compatibility placeholder that prevents errors when the Steam UI attempts to synchronize the system timezone.

steamos-update: 
  A wrapper script that directs system update requests from the Steam UI to the local update utility.

jupiter-biosupdate: 
  A wrapper for BIOS updates, ensuring the Steam UI can communicate with the hardware firmware tools.

steam.desktop: 
  The session entry file.
  It must be placed in /usr/share/wayland-sessions/ to allow SDDM to recognize and launch the Gamescope/Steam Deck UI session.


GameMode.desktop:
  A shortcut file that can be placed on your KDE Plasma desktop to switch to Gaming Mode with a single click.
  # Optional: Add a shortcut to your desktop to switch to Game Mode
  - cp GameMode.desktop ~/Desktop/
  - chmod +x ~/Desktop/GameMode.desktop




Prerequisites :

Before installing, ensure your system meets these requirements:

Operating System: Arch Linux (or any Arch-based distro).

Desktop Environment: KDE Plasma (Required for the plasma session target).

Display Manager: SDDM (Required for the autologin switching logic).

Essential Packages:

gamescope: The micro-compositor for the Game Mode.

steam: Ensure it's the official version.

Additional Software :

mangohud: (Optional) For performance monitoring.

GameMode: (Optional) is a daemon that automatically optimizes your system while playing games. 

ProtonUp-Qt: (Optional) is a GUI tool to manage different versions of GE Proton.




Installation :

Note: Before installing drivers, ensure the multilib repository is enabled. Edit your configuration file:

- sudo nano /etc/pacman.conf

Find and uncomment (remove the #) the following lines:

[multilib]
Include = /etc/pacman.d/mirrorlist

Save and exit (Ctrl+O, Enter, Ctrl+X), then update your system:

- sudo pacman -Syu

Install yay (AUR Helper) :

- sudo pacman -S --needed base-devel git
- git clone https://aur.archlinux.org/yay.git
- cd yay
- makepkg -si
- cd ..
- rm -rf yay

Install Core Vulkan & Dependencies (Check if your GPU supports Vulkan) :

- sudo pacman -S --needed vulkan-icd-loader lib32-vulkan-icd-loader gamescope steam

Install GPU-Specific Drivers :

NVIDIA

- sudo pacman -S --needed nvidia-utils lib32-nvidia-utils

AMD (RADV - Recommended)

- sudo pacman -S --needed vulkan-radeon lib32-vulkan-radeon

AMD (AMDVLK - Alternative)

- sudo pacman -S --needed amdvlk lib32-amdvlk

INTEL

- sudo pacman -S --needed vulkan-intel lib32-vulkan-intel

Additional Software (Optional) :

mangohud: 

- yay -S mangohud

GameMode:

- pacman -S gamemode

ProtonUp-Qt:

- yay -S protonup-qt

