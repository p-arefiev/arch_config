#!/bin/bash

# xinitrc
head -n -7 /etc/X11/xinit/xinitrc > /home/$(whoami)/.xinitrc
#echo 'exec VBoxClient --display -d &' >> /home/$(whoami)/.xinitrc
echo 'exec VBoxClient --clipboard -d &' >> /home/$(whoami)/.xinitrc
echo 'exec VBoxClient --draganddrop -d &' >> /home/$(whoami)/.xinitrc
echo 'exec VBoxClient --seamless -d &' >> /home/$(whoami)/.xinitrc
echo 'exec VBoxClient --checkhostversion -d &' >> /home/$(whoami)/.xinitrc
echo 'exec VBoxClient --vmsvga -d &' >> /home/$(whoami)/.xinitrc
echo 'exec i3 &' >> /home/$(whoami)/.xinitrc
echo 'exec nitrogen --restore &' >> /home/$(whoami)/.xinitrc

# yay
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
rm -rf yay

# User pacman installs
sudo pacman -S network-manager-applet

# Yay installs
yay -S nerd-fonts-git i3-scrot autojump 
echo 'Installing oh my zsh plugins ... '
yay -S zsh-syntax-highlighting zsh-autosuggestions 

# Emacs doom install
echo 'Installing DOOM (emacs) ... '
git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d
exec /home/$(whoami).emacs.d/bin/doom install

# git first time setup
git config --global user.name $(whoami)
git config --global user.email $(whoami)@$(hostname)

# Install oh my zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# lightdm config
echo -n 'Creating light symlinks ...'
sudo systemctl enable lightdm.service
sudo rm -rf /etc/lightdm/lightdm.conf
sudo rm -rf /etc/lightdm/slick-greeter.conf
sudo ln -s /home/$(whoami)/Documents/arch_config/lightdm/lightdm.conf /etc/lightdm/lightdm.conf
sudo ln -s /home/$(whoami)/Documents/arch_config/lightdm/slick-greeter.conf /etc/lightdm/slick-greeter.conf
sudo mkdir /usr/share/backgrounds
sudo ln -s /home/$(whoami)/Documents/arch_config/background/back.png /usr/share/backgrounds/lighdm_screen.jpg
echo 'done'

echo -n 'Creating all symlinks ...'
rm -f /home/$(whoami)/.zshrc
ln -s /home/$(whoami)/Documents/arch_config/zsh/.zshrc /home/$(whoami)/.zshrc
rm -f /home/$(whoami)/.Xressources
ln -s /home/$(whoami)/Documents/arch_config/urxvt/.Xressources /home/$(whoami)/.Xressources
rm -f /home/$(whoami)/.config/i3/config
ln -s /home/$(whoami)/Documents/arch_config/i3/config /home/$(whoami)/.config/i3/config
ln -s /home/$(whoami)/Documents/arch_config/i3blocks /home/$(whoami)/.config/i3blocks
echo 'done'

# xinitrc
echo "Creating xinitrc config ..."
head -n -7 /etc/X11/xinit/xinitrc > /home/$(whoami)/.xinitrc
#echo 'exec VBoxClient --display -d &' >> /home/$(whoami)/.xinitrc
echo 'exec VBoxClient --clipboard -d &' >> /home/$(whoami)/.xinitrc
echo 'exec VBoxClient --draganddrop -d &' >> /home/$(whoami)/.xinitrc
echo 'exec VBoxClient --seamless -d &' >> /home/$(whoami)/.xinitrc
echo 'exec VBoxClient --checkhostversion -d &' >> /home/$(whoami)/.xinitrc
echo 'exec VBoxClient --vmsvga -d &' >> /home/$(whoami)/.xinitrc
echo 'exec i3 &' >> /home/$(whoami)/.xinitrc
echo 'exec nitrogen --restore &' >> /home/$(whoami)/.xinitrc
