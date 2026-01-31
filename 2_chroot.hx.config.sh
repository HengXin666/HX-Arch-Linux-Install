# 本文件是 [arch-chroot /mnt 之后的环境] 的安装脚本
echo "By Heng_Xin: https://github.com/HengXin666/HX-Arch-Linux-Install"

# 设置主机名字为 loli
#
# set host name is 'loli'
echo "loli" > /etc/hostname

# 将系统时间同步到硬件时间
hwclock --systohc

# 配置系统语言区域 (Locale)
# 取消 en_US 和 zh_CN 的注释，并生成本地化文件
sed -i '/^#en_US.UTF-8 UTF-8/s/^#//' /etc/locale.gen
sed -i '/^#zh_CN.UTF-8 UTF-8/s/^#//' /etc/locale.gen
locale-gen
echo 'LANG=en_US.UTF-8'  > /etc/locale.conf

# 设置 root 账户密码
# 将 root 密码自动设置为 llh282
echo "root:llh282" | chpasswd

# 自动识别 CPU 架构并安装对应的微代码 (Microcode)
# 这一步对系统稳定性和安全至关重要
grep -q "GenuineIntel" /proc/cpuinfo && pacman -S --noconfirm intel-ucode || true
grep -q "AuthenticAMD" /proc/cpuinfo && pacman -S --noconfirm amd-ucode || true

# 安装引导程序
pacman -S grub efibootmgr os-prober

# 安装 GRUB 到 EFI 分区
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=ARCH

# 优化 GRUB 配置
# 调整日志级别、禁用看门狗（加快开关机）、允许检测 Win10
sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT="loglevel=5 nowatchdog"/' /etc/default/grub
grep -q "GRUB_DISABLE_OS_PROBER" /etc/default/grub && sed -i 's/^.*GRUB_DISABLE_OS_PROBER=.*/GRUB_DISABLE_OS_PROBER=false/' /etc/default/grub || echo "GRUB_DISABLE_OS_PROBER=false" >> /etc/default/grub

# 重新生成 GRUB 引导配置文件
grub-mkconfig -o /boot/grub/grub.cfg

# ok, now: exit -> umount -R /mnt -> reboot
sleep 5