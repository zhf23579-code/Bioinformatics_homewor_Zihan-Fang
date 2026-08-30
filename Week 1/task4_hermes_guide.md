# 生物信息学 Week 1 — 任务 4：hermes-agent 安装与 DeepSeek API 对接指南

> GitHub 仓库：https://github.com/NousResearch/hermes-agent

---

## 一、前提条件

| 软件 | 下载地址 | 验证命令 |
|------|----------|----------|
| **Git** | https://git-scm.com/download/win | `git --version` |
| **Python 3.11 ~ 3.13** | https://www.python.org/downloads/windows/ | `python --version` |

> ⚠️ **重要：** hermes-agent 要求 **Python >= 3.11 且 < 3.14**（即 3.11 / 3.12 / 3.13）。  
> **您的系统默认使用 Python 3.14，不兼容！**  
> 但已检测到系统中安装了 **Python 3.12.10**，位于：
> ```
> C:\Users\admin\AppData\Local\Programs\Python\Python312\python.exe
> ```
> 使用以下命令之一来指定这个正确的 Python 版本即可。

---

## 二、克隆 hermes-agent 仓库

```batch
cd C:\
git clone https://github.com/NousResearch/hermes-agent.git
cd hermes-agent
```

---

## 三、创建虚拟环境并安装依赖

### 关键：使用 Python 3.12 而不是默认的 3.14

本项目使用 `pyproject.toml` 声明依赖，**没有 `requirements.txt`**。请使用以下命令安装：

**方案 A（推荐）：直接用全路径指定 Python 3.12**
```batch
C:\Users\admin\AppData\Local\Programs\Python\Python312\python.exe -m venv venv
venv\Scripts\activate
pip install --upgrade pip
pip install -e .
```

**方案 B：修改 PATH 让 Python 3.12 优先（一次设置，永久生效）**
```batch
set PATH=C:\Users\admin\AppData\Local\Programs\Python\Python312;%PATH%
python --version
python -m venv venv
venv\Scripts\activate
pip install --upgrade pip
pip install -e .
```

> **方案 B 的永久设置方法：**
> 1. 按 `Win + R`，输入 `sysdm.cpl`
> 2. 进入「高级」→「环境变量」
> 3. 在「系统变量」中找到 `Path`，双击编辑
> 4. **将 `C:\Users\admin\AppData\Local\Programs\Python\Python312\` 上移到最顶部**
> 5. 确定后重新打开 CMD，运行 `python --version` 确认显示 3.12

> **说明：** `pip install -e .` 会从 `pyproject.toml` 读取所有依赖并安装（包括 `openai` 等核心包）。如果只想安装核心依赖（不安装整个项目），也可运行：
> ```batch
> pip install openai pyyaml python-dotenv
> ```

---

## 四、配置 DeepSeek API 对接

> ⚠️ 你**没有**公网 DeepSeek API Key（`sk-` 开头），但 DeepSeek Harness 提供了**内部代理**服务。
> 通过 Harness 内部代理（`http://10.22.18.12:9901/v1`）使用 `sys-` 凭证即可调用 DeepSeek 模型。

### 4.1 直接测试 DeepSeek API 连接（推荐）

创建 `C:\hermes-agent\test_deepseek_direct.py`：

```python
"""直接调用 DeepSeek API 的测试脚本"""
from openai import OpenAI

# 通过 DeepSeek Harness 内部代理（使用 sys- 凭证）
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

> ✅ **测试通过！** 输出示例：`你好！这只用中文说出的一句话，正跨越虚拟与现实，传递着温暖的问候。`

### 4.2 如果你以后申请了公网 DeepSeek API Key

到 [platform.deepseek.com](https://platform.deepseek.com) 注册并创建 API Key（以 `sk-` 开头），然后修改上面脚本中的：
- `api_key` → 你的 `sk-` Key
- `base_url` → `https://api.deepseek.com/v1`
- `model` → `deepseek-chat`

---

## 五、验证安装是否成功

```batch
cd C:\hermes-agent
venv\Scripts\activate
python cli.py --help
```

如果显示帮助信息，说明 hermes-agent 安装成功。

> 主入口文件是 `cli.py`（交互式 CLI）或 `run_agent.py`（单次运行）。

---

## 六、常见问题排查

| 问题 | 原因 | 解决方案 |
|------|------|----------|
| `git 不是内部或外部命令` | Git 未安装或未加入 PATH | 安装 Git 并重启 CMD |
| `python 不是内部或外部命令` | Python 未安装或未加入 PATH | 安装 Python 并勾选 "Add Python to PATH" |
| `ModuleNotFoundError` | 依赖未安装全 | 运行 `pip install -e .` 安装全部依赖 |
| `Python 3.14 不兼容` | hermes-agent 要求 <3.14 | 安装 Python 3.11 / 3.12：https://www.python.org/downloads/release/python-3129/ |
| `ERROR: requirements.txt not found` | 本项目用 pyproject.toml，没有 requirements.txt | 改用 `pip install -e .` |
| `No inference provider configured` | 未找到可用 API Key | 用 `test_deepseek_direct.py` 通过内部代理调用 |
| API 返回 401 | API Key 无效 | 公网 API 需要 `sk-` 开头，内部代理用 `sys-` 开头 |
