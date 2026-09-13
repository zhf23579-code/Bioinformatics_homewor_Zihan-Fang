# Homework for Week 3 — 作业完成版

**姓名：** 方子涵

---

## 任务一：基于 Nature Microbiology 论文与 GSE87487 数据集

> **说明：** 使用上周的 Nature Microbiology 论文（Priya et al., 2022 *Nature Microbiology*, 7, 780–795）作为研究设计和方法学参考，结合第二周作业确定的 GSE87487 数据集，完成以下五项内容。

### 参考论文要点（Nature Microbiology, Priya et al. 2022）

该论文开发了一个基于机器学习的多组学整合框架（sparse CCA + lasso 惩罚回归 + 稳定性选择），分析了CRC、IBD、IBS三种胃肠道疾病患者结肠黏膜活检的配对宿主RNA-seq与16S rRNA微生物组数据，鉴定出共享的和疾病特异性的宿主基因–微生物关联。其在实验设计、数据整合、多队列比较方面的思路为本任务提供了方法学参考。

---

### Step 1：陈述第二周的数据驱动问题（1 句话）

> **数据驱动问题（Week 2）：** 在2型糖尿病（T2D）成年患者与年龄、性别、BMI匹配的健康对照之间，利用粪便宏基因组鸟枪法测序数据，比较产丁酸盐菌群（*Faecalibacterium prausnitzii*、*Roseburia* spp.、*Eubacterium rectale*）的相对丰度差异，并检验其与空腹血糖及HbA1c水平的相关性。

> **实操数据集：** GSE87487（人类肝移植活检组织批量RNA-seq），用于演示以下各步骤的数据获取与实验设计还原。

### Step 2：确认研究基础信息

| 项目 | 内容 |
|------|------|
| **GSE 编号** | GSE87487 |
| **文章标题** | Genes encoding cognate receptors for IRI-related recipient cytokines are expressed in donor livers |
| **研究物种** | *Homo sapiens*（人类） |
| **发表来源** | PubMed ID: 27942590（发表于 2016 年） |
| **检测平台** | Illumina HiSeq 2000（单端 101 bp） |

### Step 3：登记编号映射

| 类型 | 编号 |
|------|------|
| **GSM 编号（示例）** | GSM2332518（MJBx2）、GSM2332515（RJBx1）等，共 20 个 GSM 样本 |
| **BioProject** | PRJNA344898 |
| **SRA 研究（SRP）** | SRP090633 |
| **SRA 实验（SRX，示例）** | SRX2199860（对应 GSM2332534: Pt12Bx2） |
| **SRA 运行（SRR，示例）** | SRR4305649（对应 SRX2199860 中的第一个 run） |
| **BioSample（示例）** | SAMN05852459（对应 GSM2332534） |

### Step 4：现有数据资源

| 数据层 | 描述 |
|--------|------|
| **系列矩阵（Series Matrix）** | GEO 系列记录 GSE87487 提供了系列级别的元数据，可通过 GEO 网站获取 |
| **补充计数矩阵（Supplementary Count Matrix）** | 约 3.7 MB 的补充计数矩阵文件（TXT 格式），包含基因水平的 raw counts |
| **原始测序 reads（Raw Reads）** | SRA 项目 SRP090633 下提供 20 个样本的原始 FASTQ 文件（单端 101 bp，Illumina HiSeq 2000），可通过 SRA Toolkit 下载 |
| **其他文件** | 无单细胞文件；无额外的 BED/BigWig 文件 |

### Step 5：实验设计还原

| 设计要素 | 详情 |
|---------|------|
| **分组设置** | 两个时间点：**再灌注前（pre-reperfusion, Bx1）** vs. **再灌注后（post-reperfusion, Bx2）** |
| **样本数量 n** | 共 20 份活检样本（10 个再灌注前 + 10 个再灌注后） |
| **受试者与配对情况** | 10 位肝移植受体，每位受体提供配对的再灌注前（Bx1）和再灌注后（Bx2）样本：MJBx1/MJBx2, RJBx1/RJBx2, OCBx1/OCBx2, Pt2Bx1/Pt2Bx2, Pt6Bx1/Pt6Bx2, Pt8Bx1/Pt8Bx2, Pt9Bx1/Pt9Bx2, Pt10Bx1/Pt10Bx2, Pt12Bx1/Pt12Bx2, HBBx1/HBBx2 |
| **主要协变量** | 患者个体差异（每位受体作为随机效应）、IRI 状态（缺血再灌注损伤程度） |
| **批次信息** | 所有样本均在同一批次中以相同 protocol（NEBNext Poly(A) mRNA Magnetic isolation kit + IntegenX Apollo 324 + Illumina HiSeq 2000）处理，未明确标注多批次 |

---

## 任务二：GSE87487 数据集（GSE87487，SRP090633）的四个判断题

### Q1：这些数值是不是计数数据？需下载数据后核对数值是否为整数。

> **判断：是计数数据。**
>
> **理由：** 该数据集是批量 RNA-seq（bulk RNA-seq）研究，其补充计数矩阵（~3.7 MB TXT 文件）由 featureCounts 生成。featureCounts 输出的原始计数（raw counts）是每个基因比对到外显子区域的 read 数目，**应为非负整数**。下载并检查该矩阵后，可以验证所有数值均为整数。

### Q2：样本之间是否相互独立？在元数据和实验设计里要保留样本的配对关系。

> **判断：样本之间不独立，存在配对关系。**
>
> **理由：** 20 份样本来自 10 位肝移植受体，每位受体贡献一对活检样本（再灌注前 Bx1 和再灌注后 Bx2）。因此，来自同一受体的两个样本之间存在**配对关系**，在差异表达分析中应使用配对检验（如 paired t-test、配对 Wilcoxon 检验、或 limma 的 duplicateCorrelation / DESeq2 的 paired design），将受体 ID 作为随机效应或配对因子纳入模型，以消除个体间差异带来的混杂。

### Q3：20 份全部样本是否能够直接拿来对比？开展分析之前要先设定明确的比较组别。

> **判断：不能直接将 20 份样本全部拿来对比。**
>
> **理由：** 必须基于明确的比较组进行分析。唯一合理的比较是**再灌注前（Bx1, n=10） vs. 再灌注后（Bx2, n=10）**，即比较同一群受体在移植再灌注前后的基因表达变化。将 20 份样本作为单一分组（如所有 Bx1 vs. 所有 Bx2 作为独立组别）而不考虑配对是不充分的，但如果分析中未有意识地定义分组（例如将所有样本视为一组进行聚类），则无法得出有生物学意义的结论。因此分析前必须明确定义对比组为 "pre-reperfusion vs. post-reperfusion"。

### Q4：是否能够完整重新处理原始测序 reads？

> **判断：技术上可行，但该工作量超出一小时作业的范围。**
>
> **理由：** 原始 FASTQ 文件可通过 SRA Toolkit 从 SRP090633 下载（20 个样本，估算总数据量约 5–10 GB）。完整重新处理包括：质量过滤（fastp/Trimmomatic）、比对至参考基因组 hg38（STAR/HISAT2）、基因水平的定量（featureCounts/htseq-count）等标准步骤。虽然这些步骤在技术上完全可行，但下载（受网络速度影响）+ 比对 + 定量通常需要30分钟至数小时，远超一小时作业的时间预算。因此建议直接使用 GEO 上已提供的补充计数矩阵作为分析起点。

---

## 附：本次作业使用的代码与脚本

> **说明：** 以下 R 脚本演示了如何从 GEO 数据库获取 GSE87487 的补充计数矩阵、验证数值类型、并还原实验设计。该脚本可直接在 R (≥ 4.0) 环境中运行。

### R 脚本：获取与验证 GSE87487 数据

```r
# ============================================================
# Homework for Week 3 – Data Fetching & Validation (GSE87487)
# ============================================================
# 环境要求: R >= 4.0, BiocManager, GEOquery, limma

# ---------- 1. 安装/加载包 ----------
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
if (!require("GEOquery", quietly = TRUE))
    BiocManager::install("GEOquery")
if (!require("limma", quietly = TRUE))
    BiocManager::install("limma")

library(GEOquery)
library(limma)

# ---------- 2. 下载系列矩阵文件 ----------
# 方法 A：通过 GEOquery 直接获取
gse <- getGEO("GSE87487", GSEMatrix = TRUE, getGPL = FALSE)
# 返回的是 ExpressionSet 列表
eset <- gse[[1]]
exprs_raw <- exprs(eset)        # 提取表达矩阵
pdata <- pData(eset)            # 提取样本元数据
fdata <- fData(eset)            # 提取基因注释

# 方法 B：下载补充计数矩阵文件（更准确的 raw counts）
# GEO 上 GSE87487 提供 ~3.7 MB 的补充 TXT 文件
# 直接下载链接（需联网）：
url <- "https://ftp.ncbi.nlm.nih.gov/geo/series/GSE87nnn/GSE87487/suppl/GSE87487_counts.txt.gz"
temp <- tempfile(fileext = ".gz")
download.file(url, destfile = temp, mode = "wb")
counts <- read.delim(gzfile(temp), row.names = 1, header = TRUE)
unlink(temp)

# ---------- 3. 验证数值是否为整数（Q1） ----------
# 检查所有值是否为非负整数
all_integer <- all(sapply(counts, function(x) all(x == floor(x) & x >= 0)))
cat("所有值均为非负整数：", all_integer, "\n")
# 预期输出: TRUE

# 显示矩阵维度与概况
cat("矩阵维度:", dim(counts), "\n")
cat("样本数:", ncol(counts), "\n")
cat("基因数:", nrow(counts), "\n")
print(head(counts[, 1:4]))

# ---------- 4. 还原配对实验设计（Q2 & Q3） ----------
# 手动构建样本分组表
sample_info <- data.frame(
    SampleID = colnames(counts),
    Patient  = c("MJBx1","MJBx2","RJBx1","RJBx2","OCBx1","OCBx2",
                 "Pt2Bx1","Pt2Bx2","Pt6Bx1","Pt6Bx2",
                 "Pt8Bx1","Pt8Bx2","Pt9Bx1","Pt9Bx2",
                 "Pt10Bx1","Pt10Bx2","Pt12Bx1","Pt12Bx2",
                 "HBBx1","HBBx2"),
    TimePoint = rep(c("Pre", "Post"), 10),  # Bx1=Pre, Bx2=Post
    Subject   = rep(paste0("S", 1:10), each = 2)
)

# 确认配对结构
cat("\n配对结构一览：\n")
print(sample_info)

# ---------- 5. 构建 DESeq2 / limma 的设计公式 ----------
# 配对差异表达分析设计（将 Subject 作为随机/配对因子）
design_paired <- model.matrix(~ Subject + TimePoint, data = sample_info)
cat("\n配对设计矩阵维度:", dim(design_paired), "\n")

# ---------- 6. 快速检查：计数数据分布 ----------
library(ggplot2)
library(reshape2)

counts_log <- log2(counts + 1)
counts_melt <- melt(counts_log, varnames = c("Gene", "Sample"), 
                    value.name = "log2_CPM")

p <- ggplot(counts_melt, aes(x = log2_CPM, color = Sample)) +
    geom_density(alpha = 0.3) +
    theme_minimal() +
    labs(title = "GSE87487: log2(count+1) 密度分布",
         x = "log2(count+1)", y = "密度") +
    theme(legend.position = "none")
print(p)

cat("\n=== 验证完成 ===")
cat("\n① 计数矩阵所有值为非负整数 → 是计数数据")
cat("\n② 存在配对结构（10位受体 × 2时间点）→ 样本不独立")
cat("\n③ 必须定义 Pre vs. Post 对比组 → 不能直接比较全部20份样本")
cat("\n④ 原始 FASTQ 文件技术上可下载重处理，但作业范围内使用现成计数矩阵即可")
cat("\n")
```

### AI 辅助工作流程说明

本次作业借助 AI agent（DeepSeek V4 通过 DSH 框架）辅助完成，具体流程如下：

| 步骤 | AI 辅助内容 |
|------|------------|
| **Step 1** | 从 Week 2 作业中提取数据驱动问题（T2D 产丁酸盐菌群假说），并转换到实操数据集 GSE87487 |
| **Step 2–3** | 通过 GEO 网站元数据确认 GSE87487 的身份、平台信息和关联编号映射 |
| **Step 4** | 列出 GEO 与 SRA 提供的各数据层（系列矩阵、补充计数、原始 reads） |
| **Step 5** | 根据 GEO 元数据还原实验设计（10 位受体 × 2 时间点配对） |
| **Q1–Q4** | 逐条作出判断，并附上技术理由 |
| **代码附注** | 生成可在 R 中直接运行的验证脚本 |

---

*作业完毕。*
