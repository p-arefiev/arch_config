#!/bin/bash

# This will be ran from the chrooted env.
# User & passwd
user=$1
password=$2
admin_passwd=$3

if [[ $# -eq 0 ]] ; then
    echo 'Missing args'
    exit 0
fi

# setup timezone
echo -n 'Setting up timezone ... '
timedatectl set-ntp true 
ln -s /usr/share/zoneinfo/Europe/Paris /etc/localtime 
timedatectl set-timezone Europe/Paris 
hwclock --systohc
echo 'done'

read -p "Press enter to continue"

# setup locale
echo -n 'Setting up locale ... '
echo 'fr_FR.UTF-8' > /etc/locale.gen 
locale-gen > /dev/null
echo 'LANG=fr_FR.UTF-8' > /etc/locale.conf
echo KEYMAP=fr > /etc/vconsole.conf
echo 'done'

read -p "Press enter to continue"

# setup hostname
echo -n 'Setting up hostname ... '
echo 'arch-i3' > /etc/hostname
echo 'done'

read -p "Press enter to continue"

# build
echo 'Starting mkinitcpio ...'
mkinitcpio -p linux > /dev/null
echo 'done'

read -p "Press enter to continue"

# install bootloader
echo 'Installing bootloader ... '
pacman -S grub --noconfirm > /dev/null
grub-install --target=i386-pc /dev/sda > /dev/null
grub-mkconfig -o /boot/grub/grub.cfg > /dev/null
echo 'done'

read -p "Press enter to continue"

# install Xorg
echo 'Installing i3 (xorg, i3gaps, lightdm) ... '
pacman -S --noconfirm xorg xorg-xinit xorg-apps i3-gaps i3blocks lightdm lightdm-slick-greeter 
echo 'done'

read -p "Press enter to continue"

# install virtualbox guest modules
echo -n 'Installing virtualbox modules ... '
pacman -S --noconfirm virtualbox-host-modules-arch virtualbox-guest-utils
# Vbox services start
sudo systemctl enable vboxservice.service
sudo systemctl start vboxservice.service
echo 'done'

read -p "Press enter to continue"

# install dev envt.
echo -n 'Installing dev env ... '
pacman -S --noconfirm git npm go go-tools > /dev/null
echo 'done'

read -p "Press enter to continue"

echo -n 'Installing text editors ... '
pacman -S --noconfirm emacs nano vi > /dev/null
echo 'done'

echo -n 'Installing sys tools ... '
pacman -S --noconfirm rxvt-unicode zsh wget openssh numlockx nitrogen dhclient dmenu xautolock lsd bat dhcpcd
echo 'done'

read -p "Press enter to continue"

# Initialisation dhcpcd
systemctl enable dhcpcd

echo -n 'Installing fonts ... '
pacman -S --noconfirm ttf-hack 
echo 'done'

# user creation
echo 'Setting up user ... '
read -t 1 -n 1000000 discard      # discard previous input
echo 'root:'$admin_passwd | chpasswd
useradd -m -G wheel,vboxsf $user
echo $user:$password | chpasswd
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers
echo 'Setting up user ... done' 

echo 'Chroot ... Done'
