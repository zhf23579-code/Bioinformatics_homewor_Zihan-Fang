# Homework for Week 3 — 作业完成版

**姓名：** [你的名字]  
**提交截止时间：** 周日晚 23:59

---

## 任务一：基于 Nature Microbiology 论文与 GSE87487 数据集

> **说明：** 使用上周的 Nature Microbiology 论文（Priya et al., 2022）与第二周确定的 GSE 数据集 GSE87487，完成以下五项内容。

### Step 1：陈述第二周的数据驱动问题（1 句话）

> 在人类肝移植（orthotopic liver transplantation, OLT）受体中，利用批量 RNA-seq 检测移植肝活检组织在再灌注前（pre-reperfusion）与再灌注后（post-reperfusion）的受体细胞因子受体基因表达谱，以鉴定哪些已知与缺血再灌注损伤（IRI）相关的细胞因子在供肝中具有对应的同源受体，从而揭示供肝-受体之间完整的细胞因子信号通路在移植后 IRI 中的潜在作用。

### Step 2：确认研究基础信息

| 项目 | 内容 |
|------|------|
| **GSE 编号** | GSE87487 |
| **文章标题** | Genes encoding cognate receptors for IRI-related recipient cytokines are expressed in donor livers |
| **研究物种** | *Homo sapiens*（人类） |
| **发表来源** | PubMed ID: 27942590（发表于 2016 年） |
| **检测平台** | Illumina HiSeq 2000（GPL 平台编号未直接给出，但仪器为 Illumina HiSeq 2000） |

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
| **样本数量 n** | 共 20 份活检样本 |
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
> **理由：** 原始 FASTQ 文件可通过 SRA Toolkit 从 SRP090633 下载（20 个样本，估算总数据量约 5–10 GB）。完整重新处理包括：质量过滤（fastp/Trimmomatic）、比对至参考基因组 hg38（STAR/HISAT2）、基因水平的定量（featureCounts/htseq-count）等标准步骤。虽然这些步骤在技术上完全可行，但下载（受网络速度影响）+ 比对 + 定量通常需要 30 分钟至数小时，远超一小时作业的时间预算。因此建议直接使用 GEO 上已提供的补充计数矩阵作为分析起点。

---

*作业完毕。*
