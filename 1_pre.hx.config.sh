# 本文件是 [U盘启动后的原始环境 (Live USB)] 的安装脚本
echo "By Heng_Xin: https://github.com/HengXin666/HX-Arch-Linux-Install"

# !特别注意!: 你应该先 分区完成 后, 再使用本脚本
#
# !Warning!: fdisk -l
#            mkfs.btrfs -L myArch /dev/???
sleep 60

# 它会误删某些有用的源信息, 需禁用!
systemctl stop reflector.service

# 将系统时间与网络时间进行同步
timedatectl set-ntp true

# 将中科大镜像源设为第一优先级
sed -i '1i Server = https://mirrors.ustc.edu.cn/archlinux/$repo/os/$arch' /etc/pacman.d/mirrorlist

# 安装系统
pacstrap /mnt base base-devel linux linux-firmware btrfs-progs

# 生成 fstab 文件
genfstab -U /mnt > /mnt/etc/fstab