#!/bin/bash

# exit when any command fails
set -e
# keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# echo an error message before exiting
trap 'echo "\"${last_command}\" command filed with exit code $?."' EXIT

REPO="/home/mb/builds/arch_install"
BUILDS="/home/mb/builds"
USERNAME="mb"

### partitioning and initial packages
partition () {
    cfdisk
    mkfs.ext2 /dev/sda1
    mkfs.ext4 /dev/sda2
    mount /dev/sda2 /mnt
    pacstrap /mnt base linux linux-firmware base-devel sudo git iwd dhcpcd
    genfstab -U /mnt >> /mnt/etc/fstab
}

### stuff within arch_chroot
chroot () {
    arch-chroot /mnt sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
    arch-chroot /mnt locale-gen
    arch-chroot /mnt echo "LANG=en_US.UTF-8" > /etc/locale.conf
    arch-chroot /mnt ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
    arch-chroot /mnt echo "mb_arch" > /etc/hostname
    arch-chroot /mnt hwclock --systohc
    arch-chroot /mnt passwd
    arch-chroot /mnt useradd -m -G wheel $USERNAME
    arch-chroot /mnt passwd $USERNAME
    #printf "#$USERPW\N$USERPW" | arch-chroot /mnt passwd $USERNAME
    arch-chroot /mnt sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers
    arch-chroot /mnt pacman -S grub
    arch-chroot /mnt grub-install /dev/sda
    arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg
    arch-chroot /mnt systemctl enable dhcpcd
    chmod 777 install.sh
    mv install.sh /mnt/home/$USERNAME
}

install_initial_packages () {
    sudo pacman -S --noconfirm \
        pulseaudio pulseaudio-alsa xorg xorg-xinit xorg-server xterm \
        lightdm wget ufw unzip nemo zsh

    mkdir $BUILDS && cd $BUILDS
    sudo git clone https://aur.archlinux.org/yay-git.git
    sudo chown -R $USERNAME:$USERNAME ./yay-git
    cd yay-git
    makepkg -si
    
    yay -S --noconfirm \
        lightdm-slick-greeter lightdm-settings

    sudo systemctl enable lightdm -f
    sudo sed -i 's/#greeter-session=example-gtk-gnome/greeter-session=lightdm-slick-greeter/' /etc/lightdm/lightdm.conf
}

install_bspwm () {
    sudo pacman -S --noconfirm \
        bspwm sxhkd feh xclip picom rofi ttf-font-awesome
        
    yay -S --noconfirm \
        polybar
}

configure_bspwm () {
    cd $BUILDS
    sudo git clone https://github.com/michaelcbrown/arch_install
    sudo chmod +x $REPO/bspwm/bspwmrc
    ln -sf $REPO/bspwm ~/.config/bspwm
    ln -sf $REPO/sxhkd ~/.config/sxhkd
    ln -sf $REPO/picom ~/.config/picom
    ln -sf $REPO/polybar ~/.config/polybar
    ln -sf $REPO/rofi ~/.config/rofi
	ln -sf $REPO/.xinitrc ~/.xinitrc
    ln -sf $REPO/.Xresources ~/.Xresources

    mkdir -p ~/.local/share/fonts
    ln -sf $REPO/fonts ~/.local/share/fonts
    fc-cache -fv
    chsh -s /usr/bin/zsh
}

other_basics () {
    mkdir -p ~/Pictures/desktop\ backgrounds
    cp $REPO/botw.png ~/Pictures/desktop\ backgrounds

    # oh-my-zsh
    cd /home/$USERNAME/builds
    wget --no-check-certificate http://install.ohmyz.sh -O - | sh
    sudo git clone https://github.com/robbyrussell/oh-my-zsh.git
    ln -sf $REPO/zshrc/.zshrc ~/.zshrc

    # firewall
    sudo ufw enable
    sudo ufw status verbose
    sudo systemctl enable ufw.service

    sudo pacman -S alacritty xed mcfly zoxide
}

options="

Functions:
    partition                       partitioning + pacstrap
    chroot                          everything after arch-chroot /mnt
    install_initial_packages        X, themes, utilities
    install_bspwm                   just installing bspwm et al.
    configure_bspwm                 clone repo, make symbolic links, handle fonts, etc.
    other_basics                    set up background for feh, oh-my-zsh, firewall...

"

main () {
    if ! declare -f "$@" > /dev/null
    then
        echo "Some function entered wrong."
        echo "$options"
        exit 1
    else
        for arg in "$@"
        do
            "$arg"
        done
    fi
}

main "$@"

# Other programs to add in as extras
# Firefox, xed, Obsidian, vlc, libreoffice-fresh, code (I'm think that's the version I have installed)
# Didn't parse carefully, but - I don't think I ever put .xinitrc somewhere?
