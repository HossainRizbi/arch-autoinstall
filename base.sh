reflector --latest 20 --sort rate --save /etc/pacman.d/mirrorlist --protocol https --download-timeout 5

pacman --noconfirm -Sy archlinux-keyring


timedatectl set-ntp true




# Setting up the keyboard layout 
loadkeys us


# Creating a new partition scheme.









# Setting up the kernel.
kernel_selector

# Checking the microcode to install.
microcode_detector

# Virtualization check.
virt_check

# Setting up the network.
network_selector

# Pacstrap (setting up a base sytem onto the new root).
print "Installing the base system (it may take a while)."
pacstrap /mnt base $kernel $microcode linux-firmware $kernel-headers btrfs-progs grub grub-btrfs rsync efibootmgr snapper reflector base-devel snap-pac zram-generator

# Setting up the hostname.
hostname_selector

# Generating /etc/fstab.
print "Generating a new fstab."
genfstab -U /mnt >> /mnt/etc/fstab

# Setting username.
read -r -p "Please enter name for a user account (enter empty to not create one): " username

# Setting up the locale.
locale_selector

# Setting up keyboard layout.
keyboard_selector

# Setting hosts file.
print "Setting hosts file."
cat > /mnt/etc/hosts <<EOF
127.0.0.1   localhost
::1         localhost
127.0.1.1   $hostname.localdomain   $hostname
EOF

#############################################################################

# Configuring the system.    
arch-chroot /mnt /bin/bash -e <<EOF
    # Setting up timezone.
    echo "Setting up the timezone."
    ln -sf /usr/share/zoneinfo/$(curl -s http://ip-api.com/line?fields=timezone) /etc/localtime &>/dev/null
    
    # Setting up clock.
    echo "Setting up the system clock."
    hwclock --systohc
    
    # Generating locales.
    echo "Generating locales."
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
    echo "LANG=en_US.UTF-8" > /etc/locale.conf
    locale-gen &>/dev/null
    
    # Setting up the keyboard layout
    echo "KEYMAP=us" > /etc/vconsole.conf
    
    # Generating a new initramfs.
    echo "Creating a new initramfs."
    mkinitcpio -P &>/dev/null
    
    # Installing GRUB.
    echo "Installing GRUB on /boot."
    grub-install --target=x86_64-efi --efi-directory=/boot/ --bootloader-id=GRUB &>/dev/null
    # Creating grub config file.
    echo "Creating GRUB config file."
    grub-mkconfig -o /boot/grub/grub.cfg &>/dev/null
EOF
######################################################################
# Setting root password.
print "Setting root password."
arch-chroot /mnt /bin/passwd

# Setting user password.
if [ -n "$username" ]; then
    print "Adding the user $username to the system with root privilege."
    arch-chroot /mnt useradd -m -G wheel -s /bin/bash "$username"
    sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /mnt/etc/sudoers
    print "Setting user password for $username." 
    arch-chroot /mnt /bin/passwd "$username"
fi



# Pacman eye-candy features.
print "Enabling colours and animations in pacman."
sed -i 's/#Color/Color\nILoveCandy/' /mnt/etc/pacman.conf

# Enabling various services.
print "Enabling NetworkManager."
for service in NetworkManager.service 
do
    systemctl enable "$service" --root=/mnt &>/dev/null
done

# Finishing up.
print "Done, you may now wish to reboot (further changes can be done by chrooting into /mnt)."
exit
