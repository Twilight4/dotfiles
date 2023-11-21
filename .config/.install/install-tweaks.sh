#!bin/bash

#####################################################################
# Pacman Configuration
#####################################################################

# Warning: This script is supposed to be run on top of fresh arch linux installation upon reboot as ROOT. The sequence order is substantial.
#pacman-key --init
#pacman-key --populate
#pacman -Syy

# Import pacman config (commented out bcs CachyOS repos are already added upon CachyOS installation)
#mv /etc/pacman.conf /etc/pacman.conf.bak
#curl https://raw.githubusercontent.com/Twilight4/arch-install/main/config-files/pacman.conf > /etc/pacman.conf
#pacman -Syy

# Enabling CachyOS Repositories for Enhanced Arch Linux Performance
#pacman -S --noconfirm --needed wget
#wget https://mirror.cachyos.org/cachyos-repo.tar.xz
#tar xvf cachyos-repo.tar.xz && cd cachyos-repo
#./cachyos-repo.sh && cd -

# Enabling Black Arch repo
curl -O https://blackarch.org/strap.sh
echo 5ea40d49ecd14c2e024deecf90605426db97ea0c strap.sh | sha1sum -c
chmod +x strap.sh
./strap.sh
rm strap.sh

# Enabling Athena repo
echo '
[athena-repository]
SigLevel = Optional TrustedOnly
Server = https://athena-os.github.io/$repo/$arch' | tee --append /etc/pacman.conf

# Get the mirrorlist file
curl https://raw.githubusercontent.com/Athena-OS/package-source/main/packages/athena-mirrorlist/athena-mirrorlist -o /etc/pacman.d/athena-mirrorlist
pacman-key --recv-keys A3F78B994C2171D5 --keyserver keys.openpgp.org   # Import a key
pacman-key --lsign A3F78B994C2171D5                                    # Trust the imported key
pacman -Syy

# Enabling Chaotic-AUR repo (CachyOS repos are certainly sufficient)
#pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
#pacman-key --lsign-key 3056513887B78AEB
#pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
#echo '
#[chaotic-aur]
#Include = /etc/pacman.d/chaotic-mirrorlist' | tee --append /etc/pacman.conf
#pacman -Syy


#####################################################################
# Security Enhancments
#####################################################################

##### Comment out if you are using systemd-boot instead of grub #######
# Enabling CPU Mitigations
#curl https://raw.githubusercontent.com/Kicksecure/security-misc/master/etc/default/grub.d/40_cpu_mitigations.cfg >> /etc/grub.d/40_cpu_mitigations.cfg
# Distrusting the CPU
#curl https://raw.githubusercontent.com/Kicksecure/security-misc/master/etc/default/grub.d/40_distrust_cpu.cfg >> /etc/grub.d/40_distrust_cpu.cfg
# Enabling IOMMU
#curl https://raw.githubusercontent.com/Kicksecure/security-misc/master/etc/default/grub.d/40_enable_iommu.cfg >> /etc/grub.d/40_enable_iommu.cfg
# Enabling NTS
curl https://raw.githubusercontent.com/GrapheneOS/infrastructure/main/chrony.conf >> /etc/chrony.conf
# Setting GRUB configuration file permissions
#chmod 755 /etc/grub.d/*

# Blacklisting kernel modules
curl https://raw.githubusercontent.com/Kicksecure/security-misc/master/etc/modprobe.d/30_security-misc.conf >> /etc/modprobe.d/30_security-misc.conf
sed -i '14,15 s/^/#/' /etc/modprobe.d/30_security-misc.conf       # don't disable bluetooth
chmod 600 /etc/modprobe.d/*

# Security kernel settings
curl https://raw.githubusercontent.com/Kicksecure/security-misc/master/etc/sysctl.d/30_security-misc.conf >> /etc/sysctl.d/30_security-misc.conf
sed -i 's/kernel.yama.ptrace_scope=2/kernel.yama.ptrace_scope=3/g' /etc/sysctl.d/30_security-misc.conf
curl https://raw.githubusercontent.com/Kicksecure/security-misc/master/etc/sysctl.d/30_silent-kernel-printk.conf >> /etc/sysctl.d/30_silent-kernel-printk.conf
chmod 600 /etc/sysctl.d/*

# Remove nullok from system-auth
sed -i 's/nullok//g' /etc/pam.d/system-auth

# Disable coredump
echo "* hard core 0" >> /etc/security/limits.conf

# Disable su for non-wheel users
bash -c 'cat > /etc/pam.d/su' <<-'EOF'
#%PAM-1.0
auth		sufficient	pam_rootok.so
# Uncomment the following line to implicitly trust users in the "wheel" group.
#auth		sufficient	pam_wheel.so trust use_uid
# Uncomment the following line to require a user to be in the "wheel" group.
auth		required	pam_wheel.so use_uid
auth		required	pam_unix.so
account		required	pam_unix.so
session		required	pam_unix.so
EOF

# Randomize Mac Address
bash -c 'cat > /etc/NetworkManager/conf.d/00-macrandomize.conf' <<-'EOF'
[device]
wifi.scan-rand-mac-address=yes
[connection]
wifi.cloned-mac-address=random
ethernet.cloned-mac-address=random
connection.stable-id=${CONNECTION}/${BOOT}
EOF

chmod 600 /etc/NetworkManager/conf.d/00-macrandomize.conf

# Disable Connectivity Check
bash -c 'cat > /etc/NetworkManager/conf.d/20-connectivity.conf' <<-'EOF'
[connectivity]
uri=http://www.archlinux.org/check_network_status.txt
interval=0
EOF

chmod 600 /etc/NetworkManager/conf.d/20-connectivity.conf

# Enable IPv6 privacy extensions
bash -c 'cat > /etc/NetworkManager/conf.d/ip6-privacy.conf' <<-'EOF'
[connection]
ipv6.ip6-privacy=2
EOF

chmod 600 /etc/NetworkManager/conf.d/ip6-privacy.conf

#####################################################################
# System Performance Tweaks
#####################################################################

# ZRAM configuration
bash -c 'cat > /etc/systemd/zram-generator.conf' <<-'EOF'
[zram0]
zram-fraction = 1
max-zram-size = 8192
EOF

# General system tweaks - https://wiki.cachyos.org/general_info/general_system_tweaks/
# Reduce Swappiness and vfs_cache_pressure
sed -i -E 's/^(#)?(vm\.vfs_cache_pressure)/\2/' /etc/sysctl.d/99-cachyos-settings.conf
sed -i -E 's/^vm\.swappiness\s*=\s*[0-9]+/vm.swappiness = 10/' /etc/sysctl.d/99-cachyos-settings.conf
echo -e "\n# Additional settings" | tee -a /etc/sysctl.d/99-cachyos-settings.conf
echo "vm.dirty_background_ratio=15" | tee -a /etc/sysctl.d/99-cachyos-settings.conf
echo "vm.dirty_ratio=40" | tee -a /etc/sysctl.d/99-cachyos-settings.conf
echo "vm.oom_dump_tasks=0" | tee -a /etc/sysctl.d/99-cachyos-settings.conf
echo "vm.oom_kill_allocating_task=1" | tee -a /etc/sysctl.d/99-cachyos-settings.conf
echo "vm.overcommit_memory=1" | tee -a /etc/sysctl.d/99-cachyos-settings.conf

# Zswap tweaking
sh -c 'echo zstd > /sys/module/zswap/parameters/compressor'
sh -c 'echo 10 > /sys/module/zswap/parameters/max_pool_percent'
# Disabling mitigations
sed -i 's/\(LINUX_OPTIONS="zswap.enabled=0 nowatchdog\)/\1 mitigations=off/' /etc/sdboot-manage.conf
# AMD P-State EPP Driver
echo active | tee /sys/devices/system/cpu/amd_pstate/status
# AMD P-State Preferred Core Handling
sed -i 's/\(LINUX_OPTIONS="zswap.enabled=0 nowatchdog\)/\1 mitigations=off amd_prefcore=enable/' /etc/sdboot-manage.conf
#cat /sys/devices/system/cpu/amd_pstate/prefcore        # You can check if it is enabled with following command
# Disabling Split Lock Mitigate
echo "kernel.split_lock_mitigate=0" | tee /etc/sysctl.d/99-splitlock.conf

######################################################################
# Configuring the System
######################################################################

# Warning: These configs are correct ONLY for ext4 and GRUB bootloader.
#curl https://raw.githubusercontent.com/Twilight4/arch-install-old/main/grub > /etc/default/grub
#grub-mkconfig -o /boot/grub/grub.cfg
# lz4 for fast compression - improved boot time performance
#curl https://raw.githubusercontent.com/Twilight4/arch-install-old/master/mkinitcpio.conf > /etc/mkinitcpio.conf
#mkinitcpio -P                                                             

# Parallel compilation and building from files in memory tweak
curl https://raw.githubusercontent.com/Twilight4/arch-install/main/config-files/makepkg.conf > /etc/makepkg.conf

# Giving wheel user sudo access
curl https://raw.githubusercontent.com/Twilight4/arch-install/main/config-files/sudoers > /etc/sudoers

# Blacklist beep
rmmod pcspkr
echo "blacklist pcspkr" > /etc/modprobe.d/nobeep.conf

# Change audit logging group
echo "log_group = audit" >> /etc/audit/auditd.conf

# Finishing up
echo "Done, you may now run system-setup/ scripts in correct order - check README."
