#!/bin/bash

# User & passwd
user=$1
password=$2

# set time
timedatectl set-ntp true

#partiton disk
parted --script /dev/sda mklabel msdos mkpart primary ext4 0% 87% mkpart primary linux-swap 87% 100%
mkfs.ext4 /dev/sda1
mkswap /dev/sda2
swapon /dev/sda2
mount /dev/sda1 /mnt

# pacstrap
pacstrap /mnt base linux linux-firmware base-devel

# fstab
genfstab -U /mnt >> /mnt/etc/fstab

# chroot
arch-chroot /mnt /bin/bash ./chroot_install.sh $user $password

# reboot
umount /mnt
reboot