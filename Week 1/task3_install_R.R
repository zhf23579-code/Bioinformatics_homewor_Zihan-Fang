# =============================================
# 生物信息学 Week 1 — 任务 3：R 语言安装检测脚本
# 文件名：task3_install_R.R
# 用途：检测 Windows 系统上 R 是否安装，输出版本和默认包列表
# =============================================

# ─────────────────────────────────────────────
# 方法一：在 R 控制台中运行（如果已安装 R）
# ─────────────────────────────────────────────

cat("\n========================================\n")
cat("  生物信息学 Week 1 — R 环境检测\n")
cat("========================================\n\n")

cat("R 版本信息：\n")
cat(R.version.string, "\n\n")

cat("已安装的默认包数量：", length(installed.packages()[, "Package"]), "\n")
cat("已安装的默认包列表：\n")
cat(paste(rownames(installed.packages()), collapse = "\n"), "\n\n")

cat("========================================\n")
cat("检测完成。\n")
cat("========================================\n")

# ─────────────────────────────────────────────
# 方法二：Windows CMD 批处理脚本（check_r.bat）
# 保存以下内容为 check_r.bat，双击运行
# ─────────────────────────────────────────────
#
# @echo off
# chcp 65001 >nul
# title R 语言安装检测脚本
# echo ========================================
# echo   R 语言安装检测 — Windows
# echo ========================================
# echo.
#
# where R >nul 2>nul
# if %ERRORLEVEL% EQU 0 (
#     echo ✅ R 已安装！正在获取版本信息...
#     echo ----------------------------------------
#     R --version | findstr /i "version"
#     echo.
#     echo 📦 已安装的默认包列表：
#     R -e "cat(rownames(installed.packages()), sep='\n')" 2>nul
#     echo.
#     echo ✅ 检测完成。
# ) else (
#     echo ❌ 未检测到 R 语言。
#     echo.
#     echo ========================================
#     echo   请前往以下链接下载 R：
#     echo   https://cran.r-project.org/bin/windows/base/
#     echo ========================================
#     echo.
#     echo 下载后运行安装程序（默认设置即可），
#     echo 安装完成后重新运行此脚本验证。
# )
#
# echo.
# pause

# ─────────────────────────────────────────────
# 方法三：纯 CMD 单行命令（直接在 CMD 粘贴运行）
# ─────────────────────────────────────────────
#
# where R >nul 2>nul && (R --version | findstr /i "version" & echo 已安装包列表: & R -e "cat(rownames(installed.packages()), sep='\n')") || (echo R 未安装。下载地址: https://cran.r-project.org/bin/windows/base/)

# ═════════════════════════════════════════════
# 附录：R 语言官方下载链接与说明
# ═════════════════════════════════════════════
#
# 官方下载地址：
#   https://cran.r-project.org/bin/windows/base/
#
# 安装说明：
#   1. 打开上述链接，下载最新版本的 R-x.x.x-win.exe
#   2. 双击运行安装程序，默认设置即可
#   3. 安装完成后，重新打开 CMD，输入 R 验证
#   4. 推荐安装 RStudio（可选但强烈推荐）：
#      https://posit.co/download/rstudio-desktop/
#
# 验证安装是否成功：
#   CMD 中输入: R --version
#   如果显示 R 版本信息，说明安装成功。

# ═════════════════════════════════════════════
# 附录 B：升级 R 到最新版本（非最新版本专用）
# ═════════════════════════════════════════════
#
# 场景一：已安装旧版 R，想升级到最新版
#
# 方法 1：安装 installr 包（推荐，最方便）
#   在 R 控制台中运行：
#     install.packages("installr")
#     library(installr)
#     updateR()
#   这会自动下载最新版本并迁移你的包。
#
# 方法 2：手动升级
#   1. 前往 https://cran.r-project.org/bin/windows/base/ 下载最新版
#   2. 运行安装程序（会覆盖旧版本，包需要重新安装）
#   3. 重新安装旧版本的包：
#     在旧版 R 中运行:
#       installed_pkgs <- installed.packages()[, "Package"]
#       save(installed_pkgs, file="old_packages.RData")
#     在新版 R 中运行:
#       load("old_packages.RData")
#       installed_pkgs <- installed_pkgs[!installed_pkgs %in% installed.packages()[, "Package"]]
#       if(length(installed_pkgs)) install.packages(installed_pkgs)
#
# 方法 3：直接卸载旧版，安装新版
#   1. 控制面板 → 程序和功能 → 卸载旧版 R
#   2. 手动备份需要的包列表（上面方法 2 中的保存步骤）
#   3. 下载安装最新版
#   4. 重新安装包
#
# 确认升级后版本的 CMD 命令：
#   R --version | findstr "version"
#
# 检查当前 R 安装路径的 CMD 命令：
#   where R
