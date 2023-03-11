#!/bin/bash

sudo pacman -Syu
sudo pacman -S --needed git
mkdir ~/apps
cd ~/apps
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
yay -S cloudflare-warp-bin
sudo systemctl enable warp-svc
sudo systemctl start warp-svc
warp-cli register
echo "Please enter your Warp license:"
read warp_license
warp-cli set-license "$warp_license"
warp-cli set-mode warp
warp-cli connect
yay -S --needed - < ~/trees/dotfiles/packages.txt
ln -sf ~/trees/dotfiles/.zshrc ~/.zshrc
ln -sf ~/trees/dotfiles/.gitconfig ~/.gitconfig
read -p "Do you want to add amd_pstate=passive initcall_blacklist=acpi_cpufreq_init cpufreq.default_governor=schedutil in grub's GRUB_CMDLINE_LINUX_DEFAULT? (y/n): " edit_grub
if [ "$edit_grub" == "y" ]; then
    sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="\(.*\)"/GRUB_CMDLINE_LINUX_DEFAULT="\1 amd_pstate=passive initcall_blacklist=acpi_cpufreq_init cpufreq.default_governor=schedutil"/' /etc/default/grub
    sudo update-grub
fi
echo "Done!"

