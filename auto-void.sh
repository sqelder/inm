#!/bin/sh
# Void Linux Post-Installation Script for Wayland
# Author: Speyll
# Date: 25-09-2023

# IMPORTANT: Change this variable to your username.
username=sm

# Enable multilib and nonfree repositories and update
echo "Adding multilib and nonfree support, syncing repos, and updating packages"
xbps-install -y void-repo-nonfree
# Uncomment the following lines if needed:
# xbps-install -y void-repo-multilib
# xbps-install -y void-repo-multilib-nonfree
xbps-install -Sy

# Install GPU drivers based on your hardware
echo "Installing GPU drivers"
# Intel
# xbps-install -y mesa-dri intel-video-accel
# Uncomment and modify the following lines for AMD and NVIDIA:
# AMD
xbps-install -y mesa-dri mesa-vaapi mesa-vdpau
# NVIDIA
# xbps-install -y mesa-dri nvidia nvidia-libs-32bit

# Install microcode updates for Intel CPUs
#echo "Installing intel-ucode"
#xbps-install -y intel-ucode
xbps-reconfigure -f linux-$(uname -r)

# Setting up seatd (Skip if using a systemd-based distro)
echo "Installing seatd & configuring dumb_runtime_dir"
usermod -aG input,video,audio $username
ln -s /etc/sv/seatd /var/service
sv start seatd
xbps-install -y dumb_runtime_dir
# Uncomment and configure the PAM session if needed
#echo "-session    optional     pam_dumb_runtime_dir.so" >> /etc/pam.d/system-login

# Install essential packages
echo "Installing core packages"
xbps-install -y wayland dbus git curl rsync

# Set up audio system with PipeWire
echo "Setting up audio with PipeWire"
xbps-install -y pipewire
ln -s /usr/share/applications/pipewire.desktop /etc/xdg/autostart/pipewire.desktop
# for Bluetooth audio support
xbps-install -y bluez libspa-bluetooth

# Install Fonts
echo "Installing Fonts"
xbps-install -y noto-fonts-emoji noto-fonts-ttf font-hack-ttf font-awesome

# Install Text editor (Choose one)
xbps-install -y nano #neovim mle

# Install Window Manager (Choose one)
echo "Installing Window Manager"
xbps-install -y sway #sway

# Install Terminal Emulator (Choose one)
echo "Installing Terminal Emulator"
xbps-install -y foot #alacritty

# Install Status Bar (Choose one)
echo "Installing Status Bar"
xbps-install -y yambar #waybar

# Install Night Filter
echo "Installing Night Filter"
xbps-install -y wlsunset

# Install Application Launcher (Choose one)
echo "Installing Application Launcher"
xbps-install -y tofi #fuzzel bemenu

# Install Brightness Controller
echo "Installing Brightness Controller"
xbps-install -y brightnessctl

# Install Clipboard & Screenshot Utilities
echo "Installing clipboard and screenshot tools"
xbps-install -y grim slurp wl-clipboard cliphist

# Install Image Viewer
echo "Installing Image Viewer"
xbps-install -y imv swaybg

# Set up xdg-utils
echo "Setting up xdg-utils"
xbps-install -y xdg-utils

# Install Notification System
echo "Installing Notification System"
xbps-install -y mako libnotify

# Install Notification System
echo "Installing File manager"
xbps-install -y unzip p7zip unrar
xbps-install -y nnn
xbps-install -y pcmanfm-qt ffmpegthumbnailer lxqt-archiver

# Install dependencies for Librewolf AppImage (if needed)
xbps-install -y qt5-wayland dbus-glib

# Install Theme and Cursor Themes
echo "Installing Theme and Cursor Themes"
xbps-install -y breeze-gtk breeze-icons breeze-snow-cursor-theme qt5ct

# Install Flatpak (Optional)
xbps-install -y flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Set up NFS (Optional)
# echo "Setting up NFS"
xbps-install -y nfs-utils

# IMPORTANT: Modify these export options if necessary for your setup.
#echo "/home/$username 192.168.100.15/255.255.255.0(rw,async,no_subtree_check,anonuid=1000,anongid=1000) 192.168.100.11/255.255.255.0(rw,async,no_subtree_check,anonuid=1000,anongid=1000)" >> /etc/exports
#echo "/media/ST500 192.168.100.15/255.255.255.0(rw,async,no_subtree_check,anonuid=1000,anongid=1000) 192.168.100.11/255.255.255.0(rw,async,no_subtree_check,anonuid=1000,anongid=1000)" >> /etc/exports

# Set up VPN (Optional)
#echo "Setting up VPN"
#xbps-install -y wireguard

ln -s /etc/sv/rpcbind /var/service/
ln -s /etc/sv/statd /var/service/
ln -s /etc/sv/nfs-server /var/service/
sv start nfs-server

# Remove Unused Services (TTYs)
echo "Removing Unused Services (TTYs)"
rm -rf /var/service/agetty-tty3
rm -rf /var/service/agetty-tty4
rm -rf /var/service/agetty-tty5
rm -rf /var/service/agetty-tty6

# Set up ACPI
echo "Setting up ACPI"
ln -s /etc/sv/acpid/ /var/service/
sv enable acpid
sv start acpid

# Set up bluetooth
echo "Setting up bluetooth"
ln -s /etc/sv/bluetoothd /var/service/
sv enable bluetoothd
sv start bluetoothd

# Improve font rendering
echo "Improving font rendering"
ln -s /etc/fonts/conf.avail/11-lcdfilter-default.conf /etc/fonts/conf.d
ln -s /etc/fonts/conf.avail/10-sub-pixel-rgb.conf /etc/fonts/conf.d
ln -s /etc/fonts/conf.avail/10-hinting-slight.conf /etc/fonts/conf.d

# Set up NetworkManager and disable previous network services
echo "Setting up NetworkManager"
xbps-install -y NetworkManager dbus
sv stop wpa_supplicant
sv stop dhcpcd
rm -rf /var/services/wpa_supplicant
rm -rf /var/services/dhcpcd
ln -s /etc/sv/dbus /var/service

# Uncomment and configure sudo if needed
# su
echo "%wheel ALL=(ALL:ALL) NOPASSWD: /usr/bin/halt, /usr/bin/poweroff, /usr/bin/reboot, /usr/bin/shutdown, /usr/bin/zzz, /usr/bin/ZZZ" >> /etc/sudoers.d/wheel

echo "Post-installation script completed."
