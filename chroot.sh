#!/bin/bash
LOG="install.log"
SUCCESS=0
FAIL=0
FAILED_LIST=()

run_task() {
    local desc="$1"
    local cmd="$2"
    echo -e "\033[1;34m[任务描述]\033[0m"
    echo -e "\033[1;36m$desc\033[0m"
    echo -e "\033[1;30m[执行命令] $cmd\033[0m"
    
    if eval "$cmd" >> "$LOG" 2>&1; then
        echo -e "\033[1;32m✅ 成功\033[0m"
        ((SUCCESS++))
    else
        echo -e "\033[1;31m❌ 失败\033[0m"
        ((FAIL++))
        FAILED_LIST+=("$desc")
    fi
    echo "-----------------------------------"
}

echo "开始执行安装流程..."
echo "==================================="
run_task "本文件是 [arch-chroot /mnt 之后的环境] 的安装脚本" "echo \"By Heng_Xin: https://github.com/HengXin666/HX-Arch-Linux-Install\""
run_task "设置主机名字为 loli\n\nset host name is 'loli'" "echo \"loli\" > /etc/hostname"
run_task "将系统时间同步到硬件时间" "hwclock --systohc"
run_task "配置系统语言区域 (Locale)\n取消 en_US 和 zh_CN 的注释，并生成本地化文件" "sed -i '/^#en_US.UTF-8 UTF-8/s/^#//' /etc/locale.gen && sed -i '/^#zh_CN.UTF-8 UTF-8/s/^#//' /etc/locale.gen && locale-gen && echo 'LANG=en_US.UTF-8'  > /etc/locale.conf"
run_task "设置 root 账户密码\n将 root 密码自动设置为 llh282" "echo \"root:llh282\" | chpasswd"
run_task "自动识别 CPU 架构并安装对应的微代码 (Microcode)\n这一步对系统稳定性和安全至关重要" "grep -q \"GenuineIntel\" /proc/cpuinfo && pacman -S --noconfirm intel-ucode || true && grep -q \"AuthenticAMD\" /proc/cpuinfo && pacman -S --noconfirm amd-ucode || true"
run_task "安装引导程序" "pacman -S grub efibootmgr os-prober"
run_task "安装 GRUB 到 EFI 分区" "grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=ARCH"
run_task "优化 GRUB 配置\n调整日志级别、禁用看门狗（加快开关机）、允许检测 Win10" "sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT=\"loglevel=5 nowatchdog\"/' /etc/default/grub && grep -q \"GRUB_DISABLE_OS_PROBER\" /etc/default/grub && sed -i 's/^.*GRUB_DISABLE_OS_PROBER=.*/GRUB_DISABLE_OS_PROBER=false/' /etc/default/grub || echo \"GRUB_DISABLE_OS_PROBER=false\" >> /etc/default/grub"
run_task "重新生成 GRUB 引导配置文件" "grub-mkconfig -o /boot/grub/grub.cfg"
run_task "ok, now: exit -> umount -R /mnt -> reboot" "sleep 5"
echo -e "\n==================================="
echo -e "安装完成! 成功: $SUCCESS, 失败: $FAIL"
if [ $FAIL -ne 0 ]; then echo -e "\033[1;31m失败项:\033[0m"; for item in "${FAILED_LIST[@]}"; do echo " - $item"; done; fi
