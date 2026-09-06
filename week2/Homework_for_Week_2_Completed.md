# Homework for Week 2 — 作业完成版

**姓名：** 方子涵
**所选主题：** Gut microbiota and metabolic disease（肠道微生物与代谢疾病）

---

## Part 1：科学问题构建

### 1. 宽泛大主题 → 1 个短语

> Gut microbiota and metabolic disease（肠道微生物与代谢疾病）

### 2. 缩小到具体科学现象 → 1 句话

> 在2型糖尿病（T2D）患者的肠道菌群中，产丁酸盐的细菌（如 *Faecalibacterium prausnitzii*、*Roseburia* spp.）相较于健康人群持续减少，提示这类短链脂肪酸产生菌的缺失可能破坏宿主葡萄糖稳态与胰岛素敏感性。

### 3. 提出可检验假设 → 1 个可证伪的陈述

> 在调整年龄、性别和BMI后，T2D患者的肠道宏基因组中产丁酸盐菌群（*F. prausnitzii*、*Roseburia*、*Eubacterium rectale*）的相对丰度显著低于血糖正常的健康对照组。

### 4. PICO/PECO 框架 → 4 个结构化要素

| 要素 | 描述 |
|------|------|
| **P（人群）** | 2型糖尿病（T2D）成年患者（≥18岁） |
| **E（暴露）** | 肠道产丁酸盐菌群丰度降低（vs. 健康对照） |
| **C（比较）** | 年龄、性别、BMI匹配的血糖正常健康成年人 |
| **O（结局）** | 产丁酸盐菌群相对丰度的差异；与空腹血糖及HbA1c的相关性 |
| **协变量** | 年龄、性别、BMI、饮食（膳食纤维摄入）、二甲双胍使用、测序深度 |

### 5. 确定数据集/数据类型 → 1 个数据库或数据集编号

> **数据集：** Human Microbiome Project 2（HMP2 / iHMP）中的T2D子队列，包含宏基因组鸟枪法测序数据及宿主临床元数据。数据获取地址：https://portal.hmpdacc.org/
>
> **备选：** MetaCardis欧洲队列（T2D、CVD、健康对照），宏基因组数据存储于EGA，编号 EGAS00001001739。

### 6. 最简分析方案

| 组成部分 | 内容 |
|---------|------|
| **Data（数据）** | 100例T2D患者 + 100例匹配健康对照的粪便宏基因组鸟枪法测序数据（来自HMP2或MetaCardis）。临床元数据包括年龄、性别、BMI、空腹血糖、HbA1c、用药信息。 |
| **Method（方法）** | ① fastp 质控过滤；② MetaPhlAn 4 进行物种水平的分类学谱分析；③ 基于已知产丁酸盐菌种列表（*F. prausnitzii*、*Roseburia intestinalis*、*E. rectale* 等）提取丰度；④ MaAsLin 2 做差异丰度检验（校正年龄、性别、BMI、二甲双胍使用）；⑤ DESeq2 对 CLR 转换后的计数数据进行分析；⑥ Spearman 相关分析（产丁酸盐菌丰度 vs. 空腹血糖 / HbA1c）。 |
| **Output（输出结果）** | ① 差异丰度火山图（T2D vs. 对照）；② 两组间产丁酸盐菌丰度的箱线图；③ 相关性散点图（菌丰度 vs. 血糖指标）；④ 效应量与校正后 p 值的汇总表。 |
| **Validation（验证）** | ① 数据集内折半交叉验证；② 独立验证队列复现分析（如 Qin et al., Nature 2012 的中国T2D队列）；③ 排除二甲双胍使用者的敏感性分析；④ 置换检验评估关联稳健性。 |

---

## Part 2：基于两篇论文回答问题

### 论文一：Microbial network signatures of early colonizers in infants with eczema

**引用：** Huang L, Pan G, Feng Y, et al. (2023). *iMeta*, 2, e90. https://doi.org/10.1002/imt2.90

#### Question 1: PICO/PECO

| 要素 | 描述 |
|------|------|
| **P（人群）** | 来自中国广州珠江医院招募的足月顺产、母乳喂养婴儿 — 34对母婴组合 |
| **E（暴露）** | 出生后6个月内发展为湿疹的婴儿（病例组，n = 12） |
| **C（比较）** | 出生后6个月内未发展为湿疹的健康婴儿（对照组，n = 22） |
| **O（结局）** | 四个时间点（胎粪、1月龄、2月龄、3月龄）的肠道微生物网络拓扑学差异（如聚类数、边数、顶点数、平均度、相对模块性等指标） |

#### Question 2: 数据集或数据类型

- **主要数据：** 16S rRNA基因扩增子测序（V3–V4区，Illumina NovaSeq平台），共140份婴儿粪便样本，来自34名顺产婴儿的4个时间点（胎粪、1月龄、2月龄、3月龄）。
- **验证数据：** 两个独立队列：
  - Roswall et al. (2021) — 瑞典健康婴儿队列
  - Christensen et al. (2021) — 丹麦健康婴儿队列
- **数据存储：** 国家微生物科学数据中心（NMDC, https://nmdc.cn/），项目编号 NMDC10018172。
- **代码：** GitHub 仓库 https://github.com/xielab2017/EasyMicroPlot

#### Question 3: 研究假设

> **主要假设：** 健康婴儿在生命前100天肠道微生物网络结构呈现出有节律的动态变化，而发展为湿疹的婴儿则丧失了这种节律性模式，其肠道微生物网络密度更低、复杂程度更小。
>
> **次要假设：** 妊娠晚期母体高甘油三酯（TG）水平可能是婴儿湿疹的风险因素。

---

### 论文二：Identification of shared and disease-specific host gene–microbiome associations across human diseases using multi-omic integration

**引用：** Priya S, Burns MB, Ward T, et al. (2022). *Nature Microbiology*, 7, 780–795. https://doi.org/10.1038/s41564-022-01121-z

#### Question 1: PICO/PECO

| 要素 | 描述 |
|------|------|
| **P（人群）** | 三种胃肠道疾病患者：结直肠癌（CRC, n=44）、炎症性肠病（IBD, n=56）、肠易激综合征（IBS, n=29），以及各疾病的健康/非疾病对照 |
| **E（暴露）** | 结肠黏膜活检样本的肠道微生物组组成（16S rRNA测序） |
| **C（比较）** | 各疾病队列内部的健康/非疾病对照组；以及跨疾病的宿主基因–微生物关联模式比较 |
| **O（结局）** | 鉴定共享的与疾病特异性的肠道菌群分类群丰度与宿主基因表达（RNA-seq）之间的关联 |

#### Question 2: 数据集或数据类型

- **CRC队列（Burns et al.）：** 44例患者的88对配对RNA-seq + 16S rRNA微生物数据（肿瘤+正常组织）。数据来自明尼苏达大学生物材料采购网络（Bionet）。宿主RNA-seq在Illumina HiSeq 2500完成；16S V3–V5在454/Roche FLX Titanium完成。
- **IBD队列（Lloyd-Price et al., HMP2/iHMP）：** 来自结肠活检的宿主RNA-seq + 16S rRNA（V4区，Illumina MiSeq）。数据来自 http://ibdmdb.org。56例IBD患者 + 22例非IBD对照。
- **IBS队列（Mars et al., Mayo Clinic）：** 29例IBS患者 + 13例对照。16S V4（Illumina MiSeq）+ 宿主RNA-seq（Illumina HiSeq 2000）。
- **分析方法：** 作者开发了结合稀疏典型相关分析（sparse CCA）与自适应Lasso惩罚回归（附稳定性选择）的机器学习框架。

#### Question 3: 研究假设

> **主要假设：** 肠道微生物与宿主基因调控之间存在协同互作，影响胃肠疾病的宿主病理生理学；这些宿主基因–微生物关联既存在共享模式（CRC、IBD、IBS三者共有），也存在疾病特异性模式（每种疾病特有）。
>
> **支持该假设的具体发现：**
> - 共享宿主通路（氧化磷酸化、RAC1通路、整合素β-1通路）与三种疾病各自特异性的肠道微生物相关联。
> - 同一微生物分类群（如 *Streptococcus*、*Peptostreptococcaceae*）在不同疾病中与不同的宿主基因关联，提示疾病特异性的交叉对话机制。
> - 鉴定出疾病特异性关联，如 CRC 中的 Bacteroidales–IL-10信号通路、IBD 中的 Peptostreptococcaceae–GPCR通路、IBS 中的 Prevotella–SUMO化通路。

---

## Part 3：PubMed文献检索（基于研究兴趣）

### PubMed检索式（肠道微生物与代谢疾病）

```
("Gastrointestinal Microbiome"[MeSH] OR "gut microbiota"[tiab] OR "gut microbiome"[tiab])
AND ("Diabetes Mellitus, Type 2"[MeSH] OR "type 2 diabetes"[tiab] OR T2D[tiab])
AND ("butyrates"[MeSH] OR "butyrate"[tiab] OR "short-chain fatty acids"[tiab] OR SCFA[tiab])
AND ("2020"[dp]:"2026"[dp])
AND (english[lang])
```

**结果数：** 约 80–120 条（截至2025年初）

### 查找到的最新重要研究（举例）

1. **Sanna et al. (2021)** — "Causal relationships among the gut microbiome, short-chain fatty acids and metabolic diseases." *Nature Genetics*. — 使用孟德尔随机化方法揭示了产丁酸盐与胰岛素反应之间的因果关系。

2. **Wu et al. (2020)** — "The gut microbiota in prediabetes and diabetes: A population-based cross-sectional study." *Cell Metabolism*. — 展示了从血糖正常到糖尿病前期再到糖尿病的全谱系中产丁酸盐菌群的持续减少。

---

*作业完毕。*
