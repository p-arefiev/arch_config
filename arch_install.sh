#!/bin/bash

# User & passwd
user=$1

if [[ $# -eq 0 ]] ; then
    echo 'Missing arg'
    exit 0
fi

# set time
echo -n 'Set time ... '
timedatectl set-ntp true
echo 'done'

#partiton disk
echo -n 'Disk partitioning ... '
parted --script /dev/sda mklabel msdos mkpart primary ext4 0% 40% mkpart primary linux-swap 40% 46% mkpart primary ext4 46% 100% > /dev/null
mkfs.ext4 /dev/sda1 > /dev/null
mkfs.ext4 /dev/sda3 > /dev/null
mkswap /dev/sda2 > /dev/null
swapon /dev/sda2 > /dev/null
echo 'done'

echo -n 'Mounting partitions ... '
mount /dev/sda1 /mnt
mkdir /mnt/home && mount /dev/sda3 /mnt/home
echo 'done'

# echo -n 'Looking for best pacman mirrors ... '
# reflector --country Germany --country France --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
# echo 'done'

# pacstrap
echo 'Pacstrap installing base base-devel linux linux-firmware ... '
pacstrap /mnt base linux linux-firmware base-devel
echo 'done'

# fstab
echo -n 'Fstab generation ... '
genfstab -U /mnt >> /mnt/etc/fstab
echo 'done'

# chroot
echo 'Chroot part ... '
cp chroot_install.sh /mnt
arch-chroot /mnt /bin/bash 
rm -f /mnt/chroot_install.sh


# reboot
umount /mnt
echo 'Ready to reboot'