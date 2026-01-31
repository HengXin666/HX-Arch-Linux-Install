# 本文件是 [拔掉 U 盘, 第一次进入新系统后] 的安装脚本
echo "By Heng_Xin: https://github.com/HengXin666/HX-Arch-Linux-Install"

# !特别注意!: 你应该 使用 sudo 运行
#
# !Warning!: sudo call me!
sleep 10

# 升级系统中全部包
pacman -Syu

# 配置 root 账户默认编辑器为 vim
# 确保在 TTY 登录或执行 visudo 等命令时调用 vim
echo "export EDITOR='vim'" >> /root/.bash_profile

# 全局默认编辑器设置 (对所有用户生效)
echo "EDITOR=vim" >> /etc/environment

# 新增加的用户叫 loli
useradd -m -G wheel -s /bin/bash loli

# 将 loli 密码自动设置为 llh282
echo "loli:llh282" | chpasswd

# 取消 sudoers 文件中 wheel 组的注释(允许 wheel 组执行 sudo)
sed -i '/^# %wheel ALL=(ALL:ALL) ALL/s/^# //' /etc/sudoers

# 开启 32 位支持库 (multilib)
# 允许安装 32 位软件(如 Steam, 部分驱动等)
sed -i '/\[multilib\]/,/Include/s/^#//' /etc/pacman.conf

# 添加 archlinuxcn 中文社区仓库
# 使用中科大镜像源, 并在最后更新数据库
printf "\n[archlinuxcn]\nServer = https://mirrors.ustc.edu.cn/archlinuxcn/\$arch\n" >> /etc/pacman.conf
pacman -Sy --noconfirm

# 安装 archlinuxcn 签名密钥
# 这一步非常重要, 否则无法从中文社区源安装软件
pacman -S --noconfirm archlinuxcn-keyring

# 安装 KDE Plasma 桌面环境
# plasma-meta 元软件包、konsole 终端模拟器和 dolphin 文件管理器
pacman -S plasma-meta konsole dolphin

# 使用wayland!!!
pacman -S  plasma-workspace xdg-desktop-portal

# 配置并启动 greeter sddm
systemctl enable sddm

# 安装一些基础功能包:
# 声音固件
# 使系统可以识别 NTFS 格式的硬盘
# 安装几个开源中文字体。一般装上文泉驿就能解决大多 wine 应用中文方块的问题
# 安装谷歌开源字体及表情
# 安装常用的火狐、chromium 浏览器
# 压缩软件。在 dolphin 中可用右键解压压缩包
# 确保 Discover(软件中心)可用, 需重启
# 图片查看器
# 游戏商店。稍后看完显卡驱动章节再使用
sudo pacman -S sof-firmware alsa-firmware alsa-ucm-conf
sudo pacman -S ntfs-3
sudo pacman -S adobe-source-han-serif-cn-fonts wqy-zenhei
sudo pacman -S noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra
sudo pacman -S firefox chromium
sudo pacman -S ark
sudo pacman -S packagekit-qt6 packagekit appstream-qt appstream
sudo pacman -S gwenview
sudo pacman -S steam
sudo pacman -S yay

# 安装输入法:
# 输入法基础包组
# 官方中文输入引擎
# 日文输入引擎
# 萌娘百科词库。二刺猿必备(archlinuxcn)
# 输入法主题
sudo pacman -S fcitx5-im
sudo pacman -S fcitx5-chinese-addons
sudo pacman -S fcitx5-anthy
sudo pacman -S fcitx5-pinyin-moegirl
sudo pacman -S fcitx5-material-color

# 配置 Fcitx5 输入法环境变量
# 解决 GTK/QT 程序的输入法支持问题, 并设置用户权限
mkdir -p /home/llh/.config/environment.d
printf "GTK_IM_MODULE=fcitx\nQT_IM_MODULE=fcitx\nXMODIFIERS=@im=fcitx\nSDL_IM_MODULE=fcitx\nGLFW_IM_MODULE=ibus\n" > /home/llh/.config/environment.d/im.conf
chown -R llh:llh /home/llh/.config

# 开启蓝牙相关服务并设置开机自动启动
sudo systemctl enable --now bluetooth

# 设置系统全局语言为中文
# 影响 TTY 和基础系统环境
echo "LANG=zh_CN.UTF-8" > /etc/locale.conf

# 设置 KDE Plasma 桌面环境语言为中文
# 模拟在设置界面中将"简体中文"拖拽到第一位的操作
sudo -u llh kwriteconfig6 --file kdeglobals --group Translations --key Language "zh_CN:en_US"

# 设置格式(数字、时间、货币等)为中国标准
sudo -u llh kwriteconfig6 --file kdeglobals --group Formats --key LANG "zh_CN.UTF-8"

# 集成显卡: Intel 核芯显卡
sudo pacman -S mesa lib32-mesa vulkan-intel lib32-vulkan-intel

# 安装代理
yay -S clash-verge-rev-bin