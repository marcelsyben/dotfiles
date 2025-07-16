#!/bin/bash


# Update package database
pacman -Sy

# Install packages
pacman -S --needed --noconfirm \
    sudo \
    nano \
    git \
    wget \
    base-devel \
    zsh \
    

# Create user if it doesn't exist
if ! id "marcel" &>/dev/null; then
    useradd -m -G wheel "marcel"
    echo "User marcel created and added to wheel group"
fi

# Configure passwordless sudo for wheel group
echo "marcel ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/marcel
echo "Passwordless sudo configured for marcel"

# Switch to user marcel for the rest of the script
sudo -u marcel bash
cd ~

git clone https://aur.archlinux.org/yay.git /tmp/yay
(cd /tmp/yay && makepkg -si --noconfirm)
rm -rf /tmp/yay
