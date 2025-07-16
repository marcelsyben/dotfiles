#!/bin/bash

set -x
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
    yadm
    

# Create user if it doesn't exist
if ! id "marcel" &>/dev/null; then
    useradd -m -G wheel "marcel"
    echo "User marcel created and added to wheel group"
fi

# Configure passwordless sudo for wheel group
echo "marcel ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/marcel
echo "Passwordless sudo configured for marcel"

# Switch to user marcel for the rest of the script
sudo -u marcel bash << 'EOF'
cd ~

git clone https://aur.archlinux.org/yay.git /tmp/yay
(cd /tmp/yay && makepkg -si --noconfirm)
rm -rf /tmp/yay

yadm clone https://github.com/marcelsyben/dotfiles

# Copy SSH keys from WSL host
mkdir -p ~/.ssh
cp /mnt/c/Users/Administrator/.ssh/id_* ~/.ssh/ 2>/dev/null || true
# Set proper permissions for SSH keys
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_* 2>/dev/null || true
chmod 644 ~/.ssh/id_*.pub 2>/dev/null || true

# Setup basic git config
git config --global user.name "Marcel Syben"
git config --global user.email "marcel@syben.net"
# Configure git to sign commits with SSH key
git config --global gpg.format ssh
git config --global user.signingkey ~/.ssh/id_rsa.pub
git config --global commit.gpgsign true