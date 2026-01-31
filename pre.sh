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
run_task "本文件是 [U盘启动后的原始环境 (Live USB)] 的安装脚本" "echo \"By Heng_Xin: https://github.com/HengXin666/HX-Arch-Linux-Install\""
run_task "!特别注意!: 你应该先 分区完成 后, 再使用本脚本\n\n!Warning!: fdisk -l\nmkfs.btrfs -L myArch /dev/???" "sleep 60"
run_task "它会误删某些有用的源信息, 需禁用!" "systemctl stop reflector.service"
run_task "将系统时间与网络时间进行同步" "timedatectl set-ntp true"
run_task "将中科大镜像源设为第一优先级" "sed -i '1i Server = https://mirrors.ustc.edu.cn/archlinux/$repo/os/$arch' /etc/pacman.d/mirrorlist"
run_task "安装系统" "pacstrap /mnt base base-devel linux linux-firmware btrfs-progs"
run_task "生成 fstab 文件" "genfstab -U /mnt > /mnt/etc/fstab"
echo -e "\n==================================="
echo -e "安装完成! 成功: $SUCCESS, 失败: $FAIL"
if [ $FAIL -ne 0 ]; then echo -e "\033[1;31m失败项:\033[0m"; for item in "${FAILED_LIST[@]}"; do echo " - $item"; done; fi
