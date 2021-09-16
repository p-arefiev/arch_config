#!/bin/bash

# This will be ran from the chrooted env.

user=$1
password=$2

# setup timezone
echo 'Setting up timezone'
timedatectl set-ntp true
ln -s /usr/share/zoneinfo/Europe/Paris /etc/localtime
timedatectl set-timezone Europe/Paris
hwclock --systohc

# setup locale
echo 'Setting up locale'
sed -i 's/^#fr_FR.UTF-8/fr_FR.UTF-8/' /etc/locale.gen
locale-gen
echo 'LANG=fr_FR.UTF-8' > /etc/locale.conf

# setup hostname
echo 'Setting up hostname'
echo 'arch-i3' > /etc/hostname

# build
echo 'Building'
mkinitcpio -p linux

# install bootloader
echo 'Installing bootloader'
pacman -S grub --noconfirm
grub-install --target=i386-pc /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

# install Xorg
echo 'Installing i3 (xorg, i3gaps, lightdm)'
pacman -S --noconfirm   xorg xorg-xinit xorg-apps i3-gaps i3blocks \
                        lightdm lightdm-slick-greeter
systemctl enable lightdm.service

# install virtualbox guest modules
echo 'Installing VB-guest-modules'
pacman -S --noconfirm virtualbox-guest-modules-arch virtualbox-guest-utils
systemctl enable vboxservice.service
systemctl start vboxservice.service

# install dev envt.
echo 'Installing environment :'
echo '- Installing dev env :'
pacman -S --noconfirm git nodejs npm perl go go-tools python3 python3-pip

echo '- Installing text editors :'
pacman -S --noconfirm emacs nano vi

echo '- Installing sys tools :'
pacman -S --noconfirm   rxvt-unicode zsh curl wget autojump openssh sudo i3-scrot \
                        nitrogen nm-applet dhclient keychain dmenu xautolock numlockx \
                        lsd bat
echo '- Installing fonts :'
pacman -S --noconfirm ttf-hack

# user mgmt
echo 'Setting up user'
read -t 1 -n 1000000 discard      # discard previous input
echo 'root:'$password | chpasswd
useradd -m -G wheel -s /bin/zsh $user
echo $user:$password | chpasswd
echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers

# enable services
systemctl enable ntpdate.service

# preparing post install
chown $user:$user /home/$user/user_install.sh

echo 'Done'