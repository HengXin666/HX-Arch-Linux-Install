# HX-Arch-Linux-Install

Heng_Xin个人自用Arch Linux一键安装脚本(仅安装个人常用程序)

## 🚀 Arch Linux 一键安装仓库模板 (Arch-OneKey-Template)

这是一个基于 **GitHub Actions** 自动化驱动的 Arch Linux 重装系统全自动化配置仓库。

### 🌟 核心亮点

- **零依赖运行**: 生成的脚本是纯粹的 `Bash`, 在 Arch Live 环境中无需安装 `jq`、`python` 等任何额外工具。
- **人类友好配置**: 使用简单的 `.hx.config.sh` 文件管理配置, 支持多行注释和多行命令, 告别繁琐的 JSON。
- **云端自动编译**: 每次推送代码, GitHub 会自动将你的配置"编译"成具备错误追踪、颜色高亮、日志记录功能的 `.sh` 安装包。
- **多阶段解耦**: 预设 4 个阶段, 完美覆盖从 U 盘启动到进入系统的全流程。
- **CI/CD 护航**: 自带 Arch Linux 官方镜像模拟测试, 只有语法正确的配置才会被部署。

---

### 📂 仓库结构

| 文件 | 描述 |
|---|---|
| `1_pre.hx.config.sh` | **阶段 1**: U 盘启动后的 Live 环境(分区、格式化等) |
| `2_chroot.hx.config.sh` | **阶段 2**: `arch-chroot /mnt` 之后的基础环境配置 |
| `3_post.hx.config.sh` | **阶段 3**: 重启拔掉 U 盘, 首次进入系统的环境美化 |
| `4_hx_cpp.sh` | **阶段 4**: 可选的特定开发环境(如 C++/Qt 等)配置 |
| `.github/workflows/` | 自动化构建与测试流水线 |
| `dist` 分支 | **产物库**: 存放编译好的、可直接被 curl 执行的 `.sh` 脚本 |

---

### 🛠️ 如何配置?

你只需要修改根目录下的 `.hx.config.sh` 文件。格式极其简单:

```bash
# 这里是任务描述, 支持多行
# 可以写下该步骤的注意事项
命令1
命令2 (如果有多行命令, 会自动用 && 连接)

# 下一个任务块, 中间用空行隔开
pacman -S --noconfirm git vim
```

---

### 🚀 快速开始 (安装指南)

请根据你所在的安装阶段, 直接复制以下命令执行:

#### 1. 基础环境 (Live USB 阶段)
```bash
curl -sL https://raw.githubusercontent.com/你的用户名/你的仓库名/dist/pre.sh | bash
```

#### 2. 系统核心配置 (chroot 阶段)
```bash
curl -sL https://raw.githubusercontent.com/你的用户名/你的仓库名/dist/chroot.sh | bash
```

#### 3. 首次进系统 (Post-Install 阶段)
```bash
curl -sL https://raw.githubusercontent.com/你的用户名/你的仓库名/dist/post.sh | bash
```

---

### 📊 运行反馈与调试

安装过程中, 脚本会实时显示当前任务的描述和正在执行的命令。

- **执行日志**: 所有详细输出都会保存至 `install.log`。
- **错误统计**: 安装结束后, 脚本会列出所有失败的任务, 方便你快速定位问题。

---

### 🛡️ 工作流原理

1.  **Push 代码**: 你提交修改到 `main` 分支。
2.  **编译**: GitHub Actions 启动 Python 引擎解析你的文本配置。
3.  **测试**: 在最新的 `archlinux` 容器中运行脚本, 检查语法逻辑。
4.  **部署**: 测试通过后, 生成的纯净脚本会被推送到 `dist` 分支。
5.  **交付**: 你通过 `curl | bash` 享受到最新、最稳的配置。
