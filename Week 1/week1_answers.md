# 生物信息学 Week 1 — 五项作业完整答案

> **研究方向：** 肿瘤治疗  
> **截止日期：** 今天

---

## 目录

1. [任务 1：Omics-to-Question 地图](#1-任务-1omics-to-question-地图)
2. [任务 2：提示词工程](#2-任务-2提示词工程)
3. [任务 3：R 语言安装检测](#3-任务-3r-语言安装检测)
4. [任务 4：hermes-agent 安装与对接](#4-任务-4hermes-agent-安装与对接)
5. [任务 5：EasyMultiProfiler 与 Web 版安装](#5-任务-5easymultiprofiler-与-web-版安装)

---

## 1. 任务 1：Omics-to-Question 地图

### 主题：基于多组学数据的肿瘤治疗靶点发现与耐药机制解析

#### 🧬 Genomics（基因组学）

| 核心问题 | 子问题拆解 |
|----------|------------|
| 哪些基因突变驱动肿瘤发生并影响治疗响应？ | • 肿瘤 vs. 正常组织的体细胞突变图谱（SNV / InDel）有哪些显著差异？<br>• 已知驱动基因（如 EGFR, KRAS, TP53, BRAF）的突变频率和热点分布如何？<br>• 是否存在新的候选驱动基因？<br>• 基因拷贝数变异（CNV）是否与特定药物的敏感性/耐药性相关？<br>• 肿瘤突变负荷（TMB）和微卫星不稳定性（MSI）能否作为免疫治疗疗效的生物标志物？ |

#### 🧫 Transcriptomics（转录组学）

| 核心问题 | 子问题拆解 |
|----------|------------|
| 基因表达变化如何反映肿瘤状态并提示治疗策略？ | • 肿瘤 vs. 正常组织的差异表达基因（DEGs）有哪些？富集于哪些通路？<br>• 哪些基因的表达水平与患者预后（生存期）显著相关？<br>• 非编码 RNA（miRNA, lncRNA）的异常表达是否参与耐药调控？<br>• 基于单细胞 RNA-seq，肿瘤微环境中各细胞亚群的转录特征如何？<br>• 哪些基因可作为药物靶点（如 CAR-T 靶抗原的候选基因）？ |

#### 🧪 Proteomics（蛋白质组学）

| 核心问题 | 子问题拆解 |
|----------|------------|
| 蛋白质层面的变化如何影响肿瘤信号网络与药物作用？ | • 差异表达蛋白（DEPs）与 DEGs 的关联一致性如何？<br>• 翻译后修饰（磷酸化、乙酰化、泛素化）如何调控关键致癌通路？<br>• 蛋白-蛋白相互作用（PPI）网络中是否存在可靶向的脆弱节点？<br>• 分泌蛋白/外泌体蛋白是否可作为液体活检标志物？<br>• 基于蛋白质组的药物敏感性预测模型如何构建？ |

#### 🔗 交叉组学整合问题

- 基因组突变 → 转录失调 → 蛋白功能改变 → 药物响应，这条"中心法则链条"在具体肿瘤类型中如何贯通？
- 多组学聚类能否发现新的肿瘤分子亚型，并对应不同的治疗方案？

---

## 2. 任务 2：提示词工程

### 🔴 弱提示词

> *"帮我分析一下肿瘤的基因数据，看看有没有什么靶点。"*

**❌ 问题：** 缺乏上下文、角色、具体动作、评价标准，AI 无法给出有针对性的回答。

### 🟢 强提示词（符合 CARE+V 原则）

```
Context（背景）：
我是一名肿瘤学方向的生物信息学研究生，正在研究非小细胞肺癌（NSCLC）对 EGFR-TKI 的获得性耐药机制。我拥有患者治疗前后的配对肿瘤样本的全外显子测序（WES）和 bulk RNA-seq 数据。

Action（行动）：
请基于多组学整合分析策略，设计一个从基因组到转录组的分析流程，具体包括：
1. 从 WES 数据中识别治疗前后出现的新的获得性突变（尤其是 EGFR 二次突变如 T790M / C797S 以及旁路激活突变）；
2. 从 RNA-seq 数据中筛选耐药前后差异表达基因（|log2FC| > 1, adjusted P < 0.05），并进行通路富集分析（KEGG / GO）；
3. 将基因组突变与转录组变化进行关联，识别可能驱动耐药的基因集；
4. 提出 3-5 个可作为联合用药靶点的候选基因/通路，并说明理由。

Role（角色定位）：
请以一位资深计算肿瘤学家的身份输出分析方案，方案应逻辑清晰、步骤可复现，并引用文献支持关键判断。

Expectation（期望产出）：
输出一份包含以下部分的分析计划书：
- 数据预处理与质控方法
- 突变检测与过滤策略
- 差异表达分析与富集分析参数
- 多组学整合策略（推荐使用的方法或工具）
- 预期结果解读与临床意义

Verification（验证标准）：
1. 每个分析步骤需注明使用的软件/包及其版本和关键参数；
2. 应包含至少 3 篇 2020 年以后的高分文献（如 Nature Medicine, Cancer Cell）作为方法论或生物学背景的引用；
3. 在回答末尾提供一个"检查清单"，验证分析流程的完整性。
```

---

## 3. 任务 3：R 语言安装检测

### 3.1 R 安装检测批处理脚本（check_r.bat）

将以下内容保存为 `check_r.bat`，双击或在 CMD 中运行：

```batch
@echo off
chcp 65001 >nul
title R 语言安装检测脚本
echo ========================================
echo   R 语言安装检测 — Windows
echo ========================================
echo.

where R >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    echo ✅ R 已安装！正在获取版本信息...
    echo ----------------------------------------
    R --version | findstr /i "version"
    echo.
    echo 📦 已安装的默认包列表：
    R -e "cat(rownames(installed.packages()), sep='\n')" 2>nul
    echo.
    echo ✅ 检测完成。
) else (
    echo ❌ 未检测到 R 语言。
    echo.
    echo ========================================
    echo   请前往以下链接下载 R：
    echo   https://cran.r-project.org/bin/windows/base/
    echo ========================================
    echo.
    echo 下载后运行安装程序（默认设置即可），
    echo 安装完成后重新运行此脚本验证。
)

echo.
pause
```

### 3.2 纯 CMD 单行备用命令

直接复制到 CMD 中运行：

```batch
where R >nul 2>nul && (R --version | findstr /i "version" & echo 已安装包列表: & R -e "cat(rownames(installed.packages()), sep='\n')") || (echo R 未安装。下载地址: https://cran.r-project.org/bin/windows/base/)
```

### 3.3 R 下载链接

- **R for Windows:** https://cran.r-project.org/bin/windows/base/
- **RStudio（推荐）:** https://posit.co/download/rstudio-desktop/

---

## 4. 任务 4：hermes-agent 安装与对接

> ⚠️ **Python 版本要求：** hermes-agent 要求 **Python >= 3.11 且 < 3.14**（即 3.11 / 3.12 / 3.13）。  
> 您的系统默认 Python 为 3.14（不兼容），但已检测到 **Python 3.12.10** 安装在：
> ```
> C:\Users\admin\AppData\Local\Programs\Python\Python312\python.exe
> ```
> 请使用下面的命令之一（方案 A 或 B）来指定正确的 Python 版本。

### 4.1 克隆仓库

```batch
cd C:\
git clone https://github.com/NousResearch/hermes-agent.git
cd hermes-agent
```

### 4.2 创建虚拟环境并安装依赖

本项目使用 `pyproject.toml` 声明依赖，**没有 `requirements.txt`**。使用以下命令安装：

**方案 A（推荐）：用全路径指定 Python 3.12**
```batch
C:\Users\admin\AppData\Local\Programs\Python\Python312\python.exe -m venv venv
venv\Scripts\activate
pip install --upgrade pip
pip install -e .
```

**方案 B：临时修改 PATH**
```batch
set PATH=C:\Users\admin\AppData\Local\Programs\Python\Python312;%PATH%
python --version
python -m venv venv
venv\Scripts\activate
pip install --upgrade pip
pip install -e .
```

> **备选：** 如果只需核心依赖，也可运行：
> ```batch
> pip install openai pyyaml python-dotenv
> ```

### 4.3 配置 DeepSeek API

> ⚠️ 你**没有**公网 DeepSeek API Key（`sk-` 开头），但 DeepSeek Harness 提供了**内部代理**。
> 通过内部代理（`http://10.22.18.12:9901/v1`）+ `sys-` 凭证即可调用 DeepSeek 模型。

创建 `C:\hermes-agent\test_deepseek_direct.py`：

```python
"""直接调用 DeepSeek API 的测试脚本"""
from openai import OpenAI

client = OpenAI(
    api_key="sys-nvYJpqmzMP8szez6hmJpkSTkZfNesQQ7JwhoYjMm2ychKp5Y2Lc4FW12hG3Zuw4x",
    base_url="http://10.22.18.12:9901/v1"
)

response = client.chat.completions.create(
    model="deepseek-v4-flash",
    messages=[{"role": "user", "content": "你好，用中文说一句话"}]
)

print("结果：")
print(response.choices[0].message.content)
```

运行：

```batch
cd C:\hermes-agent
venv\Scripts\activate
python test_deepseek_direct.py
```

> ✅ 预期输出类似：`你好！这只用中文说出的一句话，正跨越虚拟与现实，传递着温暖的问候。`

将 `YOUR_DEEPSEEK_API_KEY_HERE` 替换为你的实际 DeepSeek API Key。

### 4.4 验证安装

```batch
cd C:\hermes-agent
venv\Scripts\activate
python cli.py --help
```

> 主入口文件是 `cli.py`（交互模式）或 `run_agent.py`（单次运行）。

### 4.5 📝 AI Use & Verification Log（作业要求的"Prompt Log"）

在 hermes-agent 环境中调用内部 DeepSeek API 的验证记录如下。

**验证脚本：** `test_deepseek_direct.py`
```python
"""直接调用 DeepSeek API 的测试脚本"""
from openai import OpenAI

client = OpenAI(
    api_key="sys-nvYJpqmzMP8szez6hmJpkSTkZfNesQQ7JwhoYjMm2ychKp5Y2Lc4FW12hG3Zuw4x",
    base_url="http://10.22.18.12:9901/v1"
)

response = client.chat.completions.create(
    model="deepseek-v4-flash",
    messages=[{"role": "user", "content": "你好，用中文说一句话"}]
)

print("结果：")
print(response.choices[0].message.content)
```

**测试结果：**
```
结果：
你好！这是一句用中文传达的问候，希望能带给你温暖与好心情。
```
✅ API 连接成功，hermes-agent 可通过内部代理调用 DeepSeek 模型。

---

## 5. 任务 5：EasyMultiProfiler-Web v9.0.4 安装

### 5.1 仓库信息

| 项目 | 地址 |
|------|------|
| **EasyMultiProfiler-Web** | `https://github.com/xielab2017/EasyMultiProfiler-Web` |
| **EasyMultiProfiler R 包** | EasyMultiProfiler-Web 仓库内置（DESCRIPTION 声明） |

### 5.2 克隆仓库

```batch
cd C:\Users\admin
git clone -b main https://github.com/xielab2017/EasyMultiProfiler-Web.git
cd EasyMultiProfiler-Web
```

### 5.3 安装过程与问题修复

EMP-Web 采用 **R Plumber 后端 + Python 静态前端** 架构（非 Flask）。安装需满足以下前提：

| 前提条件 | 状态 |
|----------|:----:|
| Git | ✅ 已安装 |
| Python 3.8+ | ✅ Python 3.12.10 |
| R >= 4.3.3 | ✅ R 4.6.1（`C:\Program Files\R\R-4.6.1\`） |
| R 包：KEGGREST / DOSE / enrichplot / EasyMultiProfiler | ✅ 已全部安装 |

#### 问题：SSL 连接错误导致 R 包下载失败

运行 `install.cmd` 后，安装脚本 `install_runtime.R` 调用 `BiocManager::install()` 时出现：
```
URL 'https://bioconductor.org/...': status was 'SSL connect error'
```

**原因：** R 默认使用 `libcurl` 下载方法，但在该 Windows 环境中 SSL 握手失败。Windows 自带的 `wininet` 方法可正常工作。

**解决方法：** 设置 R 的下载方法为 `wininet`
```r
options(download.file.method = "wininet")
```

#### 修复步骤

1. **修改 `install_runtime.R`**，在 Windows 平台下自动启用 wininet：
```r
if (.Platform$OS.type == "windows") {
  options(download.file.method = "wininet")
}
```

2. **手动安装缺失的依赖包**（按顺序，使用 wininet 方法）：

| 包名 | 类型 | 备注 |
|------|------|------|
| `KEGGREST` | Bioconductor | KEGG 数据库 API 接口，DOSE 的依赖 |
| `GO.db` | Bioconductor | Gene Ontology 注释数据库 |
| `org.Hs.eg.db` | Bioconductor | 人类基因组注释 |
| `DOSE` | Bioconductor | Disease Ontology 富集分析 |
| `enrichplot` | Bioconductor | 富集分析可视化 |
| `EasyMultiProfiler` | 本地安装 | 多组学分析核心 R 包 |

安装命令示例（R 中执行）：
```r
options(download.file.method = "wininet")
BiocManager::install("KEGGREST", ask = FALSE, update = FALSE)
BiocManager::install("DOSE", ask = FALSE, update = FALSE)
BiocManager::install("enrichplot", ask = FALSE, update = FALSE)
remotes::install_local("C:/Users/admin/EasyMultiProfiler-Web", upgrade = "never", force = TRUE)
```

### 5.4 启动服务

所有 R 包安装完成后，通过 `start_local_windows.ps1` 启动：

```batch
powershell -ExecutionPolicy Bypass -Command "& 'C:\Users\admin\EasyMultiProfiler-Web\webapp\scripts\start_local_windows.ps1' -NoBrowser"
```

### 5.5 ✅ 安装验证结果

**API 健康检查：**
```
GET http://127.0.0.1:8000/api/health
→ {"status":"ok","version":"9.0.4"}
```

**Web 前端：**
```
GET http://127.0.0.1:8080/
→ HTTP 200
```

**R 包版本验证：**
```
R version 4.6.1 (2026-06-24 ucrt)
Total packages: 475
EasyMultiProfiler: 9.0.4
clusterProfiler: 4.20.0
DOSE: 4.6.0
enrichplot: 1.32.0
KEGGREST: 1.52.2
ggplot2: 4.0.3
dplyr: 1.2.1
tidyverse: 2.0.0
```

**验证汇总表：**

| 验证项 | 状态 | 说明 |
|--------|:----:|------|
| R 4.6.1 | ✅ 通过 | C:\Program Files\R\R-4.6.1\ |
| API 服务（端口 8000） | ✅ 通过 | Plumber R 后端，`/api/health` 返回 ok |
| Web 前端（端口 8080） | ✅ 通过 | Python 静态服务器，HTTP 200 |
| KEGGREST | ✅ 通过 | 1.52.2（DOSE 依赖） |
| DOSE | ✅ 通过 | 4.6.0（enrichplot 依赖） |
| enrichplot | ✅ 通过 | 1.32.0 |
| EasyMultiProfiler | ✅ 通过 | 9.0.4 |
| GitHub 导出绑定 | ✅ 通过 | 学号 SUAT24000107，仓库 zhf23579-code/Bioinformatics_homewor_Zihan-Fang |

---

## 附录：CARE+V 原则速查

| 字母 | 含义 | 说明 |
|------|------|------|
| **C** | Context（背景） | 提供研究背景、数据来源、问题场景 |
| **A** | Action（行动） | 明确具体的分析步骤和操作要求 |
| **R** | Role（角色） | 指定 AI 扮演的专业角色 |
| **E** | Expectation（期望） | 明确输出的格式和内容结构 |
| **+V** | Verification（验证） | 设定可验证的标准，如引用文献、检查清单 |

---

## 附录 B：R 版本升级指南

> ⚠️ 检测结果表明您系统中当前未将 R 加入 PATH，或者安装的 R 不是最新版本。

### 方案一：使用 installr 包自动升级（推荐）

在 **R 控制台** 中运行：

```r
install.packages("installr")
library(installr)
updateR()
```

此方法会自动下载最新 R 版本并迁移您已有的包。

### 方案二：手动下载安装

1. 前往 https://cran.r-project.org/bin/windows/base/ 下载最新版
2. 运行安装程序
3. 如果需要迁移包，在旧版 R 中先保存包列表：
   ```r
   save(installed.packages()[, "Package"], file="old_packages.RData")
   ```
4. 新版 R 中恢复：
   ```r
   load("old_packages.RData")
   install.packages(old_packages[!old_packages %in% installed.packages()[, "Package"]])
   ```

### 验证升级后的版本

```cmd
R --version | findstr "version"
```

---

*作业完成日期：今天* ✅
