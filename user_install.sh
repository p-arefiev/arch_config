#!/bin/bash

# Run install.sh first or this will fail due to missing dependencies

# xinitrc
cd
head -n -5 /etc/X11/xinit/xinitrc > ~/.xinitrc
echo 'exec VBoxClient --clipboard -d &' >> ~/.xinitrc
echo 'exec VBoxClient --display -d &' >> ~/.xinitrc
echo 'exec i3 &' >> ~/.xinitrc
echo 'exec nitrogen --restore &' >> ~/.xinitrc

# lightdm config
rm -rf /etc/lightdm/
ln -s $(HOME)/Documents/arch_config/lightdm /etc/lightdm

# oh-my-zsh
cd
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
rm -f .zshrc
cd
ln -s $(HOME)/Documents/arch_config/zsh/.zshrc .zshrc

# yay
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
rm -rf yay

# environment variable
echo 'export EDITOR=nano' >> ~/.zshrc

# git first time setup
git config --global user.name $(whoami)
git config --global user.email $(whoami)@$(hostname)
git config --global code.editor nano

# wallpaper setup
cd ~/.config/
mkdir nitrogen
cd nitrogen
echo '[xin_-1]' > bg-saved.cfg
echo "file=/home/$(whoami)/Documents/arch_config/background/back.jpg" >> bg-saved.cfg
echo 'mode=0' >> bg-saved.cfg
echo 'bgcolor=#000000' >> bg-saved.cfg

echo 'Done'