#!/bin/bash
git config --global url.git@github.schneider-electric.com:.pushinsteadof=https://github.schneider-electric.com/

# Run install.sh first or this will fail due to missing dependencies

# xinitrc
cd
head -n -5 /etc/X11/xinit/xinitrc > ~/.xinitrc
echo 'exec VBoxClient --clipboard -d &' >> ~/.xinitrc
echo 'exec VBoxClient --display -d &' >> ~/.xinitrc
echo 'exec i3 &' >> ~/.xinitrc
echo 'exec nitrogen --restore &' >> ~/.xinitrc

# lightdm config
sudo systemctl enable lightdm.service
sudo rm -rf /etc/lightdm/lightdm.conf
sudo rm -rf /etc/lightdm/slick-greeter.conf
sudo ln -s /home/$(whoami)/Documents/arch_config/lightdm/lightdm.conf /etc/lightdm/lightdm.conf
sudo ln -s /home/$(whoami)/Documents/arch_config/lightdm/slick-greeter.conf /etc/lightdm/slick-greeter.conf
sudo mkdir /usr/share/backgrounds
sudo ln -s /home/$(whoami)/Documents/arch_config/background/back.png /usr/share/backgrounds/lighdm_screen.jpg

# yay
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
rm -rf yay

# Add nerd-fonts
yay -S nerd-fonts-complete i3-scrot nm-applet autojump > /dev/null
echo 'Installing plugins ... '
yay -S zsh-syntax-highlighting zsh-autosuggestions > /dev/null

# Emacs doom install
git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d
/home/$(whoami).emacs.d/bin/doom install

# git first time setup
git config --global user.name $(whoami)
git config --global user.email $(whoami)@$(hostname)
git config --global url.ssh://github.com/.pushinsteadof=https://github.com/
git config --global url.git@github.schneider-electric.com:.pushinsteadof=https://github.schneider-electric.com/

echo -n 'Creating all symlinks ...'
rm /home/$(whoami)/.zshrc
ln -s /home/$(whoami)/Documents/arch_config/zsh/.zshrc /home/$(whoami)/.zshrc
rm /home/$(whoami)/.Xressources
ln -s /home/$(whoami)/Documents/arch_config/urxvt/.Xressources /home/$(whoami)/.Xressources
rm /home/$(whoami)/.config/i3/config
ln -s /home/$(whoami)/Documents/arch_config/i3/config /home/$(whoami)/.config/i3/config
ln -s /home/$(whoami)/Documents/arch_config/i3blocks /home/$(whoami)/.config/i3blocks
echo 'done'

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

find /home/$(whoami)/Documents -type f -print0 | xargs -0 dos2unix --
