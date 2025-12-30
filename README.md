# iStoreOS 自动构建固件

![OpenWrt](https://img.shields.io/badge/基于-OpenWrt-00B5E2?logo=openwrt) ![iStoreOS](https://img.shields.io/badge/集成-iStoreOS界面-FF6A00) ![GitHub Actions](https://img.shields.io/badge/构建-GitHub_Actions-2088FF?logo=githubactions)

一个通过 GitHub Actions 自动构建的 iStoreOS 固件项目，支持 **R4SE** 和 **x86_64** 架构，集成了丰富的实用插件，并支持便捷的在线更新功能。

## ✨ 主要特性

*   **双架构支持**：为 R4SE (Rockchip) 和 x86_64 平台提供稳定构建。
*   **开箱即用**：预集成 iStoreOS 原版精美界面及管理功能。
*   **丰富插件**：内置多个增强网络管理和安全的流行插件。
*   **在线更新**：支持通过系统内的 OTA 功能进行固件无缝升级。
*   **自动化构建**：利用 GitHub Actions，保证固件来源的持续性和可追溯性。

## 📦 预集成插件列表

| 插件 | 功能简介 |
| :--- | :--- |
| **Mosnds** | 智能 DNS 服务，提升域名解析体验。 |
| **Openlist** | 提供灵活的自定义域名/IP列表管理功能。 |
| **AdGuard Home** | 全网广告拦截与隐私保护 DNS 服务器。 |
| **HomeProxy** | 轻量级的本地代理和网络工具。 |
| **OpenClash** | 强大的 Clash 客户端，支持多种代理协议。 |
| **OTA 更新** | **系统内置**的在线升级功能，方便后续更新。 |

## 🚀 快速开始

### 1. 获取固件
前往本仓库的 [Actions](https://github.com/Xiaokailnol/istoreos-actions-builder/actions) 页面，选择最新的成功工作流，在“Artifacts”部分下载对应您设备架构的固件文件（`.img.gz` 或 `.img` 格式）。

### 2. 安装固件
将下载的固件刷入您的设备（R4SE 或 x86_64 软路由）。常见的刷机方法包括：
*   **物理机**：使用 `balenaEtcher`、`Rufus` 等工具将镜像写入 U 盘或 SSD。
*   **虚拟机**：在 Proxmox VE、ESXi 或 Hyper-V 中创建虚拟机并直接载入镜像。

### 3. 初始访问
1.  将设备接入网络并启动。
2.  将您的电脑连接到同一网络。
3.  在浏览器中访问默认管理地址：**`http://10.0.0.1`**。
4.  根据网页引导完成初始设置（首次登录通常无密码或密码为 `password`，请及时修改）。

## 🔄 在线更新 (OTA)
本固件已集成 OTA（Over-the-Air）在线更新功能。
1.  登录到 iStoreOS 管理后台。
2.  导航至 **“系统” -> “固件更新”**。
3.  页面会检查并提示可用的新版本。
4.  按照界面指引即可安全、便捷地完成固件升级，无需重新刷机。

## ⚙️ 构建与定制
如果你想基于此仓库自行修改或触发构建：
1.  **Fork 本仓库**到你的 GitHub 账户。
2.  如需修改配置或插件，可以编辑 `configs` 目录下的相应文件。
3.  推送更改后，GitHub Actions 工作流会自动开始构建。
4.  你可以在自己仓库的 Actions 页面下载构建产物。

> **提示**：构建过程完全自动化，一般无需手动干预。请确保在 `.github/workflows` 中的配置文件正确无误。

## 📄 许可证与致谢
*   本项目基于 [OpenWrt](https://openwrt.org/) 和 [iStoreOS](https://www.istoreos.com/) 源码构建。
*   各插件的版权与许可证归其原作者所有。
*   此构建项目遵循 [GPL](https://www.gnu.org/licenses/gpl-3.0.html) 等相关开源协议。

---

**如有问题或建议**，欢迎在仓库中提交 [Issue](https://github.com/Xiaokailnol/istoreos-actions-builder/issues)。

**祝您使用愉快！**
