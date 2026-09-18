# Week 4 Homework Report — Question 2

**题目：** 从FASTQ到可信分析工作流程设计（以WGS为例）

---

## 1. 使用AI前的推理

### 我的初始工作流设计

我以WGS（全基因组测序）为例设计了以下8步工作流：

| 步骤 | 目的 | 输出/检查点 |
|---|---|---|
| **1. FASTQ QC** | 用FastQC检查原始数据质量；用MultiQC汇总所有样本 | QC报告（合格/需处理） |
| **2. 参考基因组** | 选择GRCh38/hg38，下载Ensembl/RefSeq注释GTF | 参考序列索引（BWA、samtools） |
| **3. 比对** | BWA-MEM进行PE读段比对到参考基因组 | SAM → 排序后BAM |
| **4. 比对后处理** | samtools fixmate/sort/markdup去PCR重复；GATK BQSR碱基质量校正 | 处理后的BAM + .bai索引 |
| **5. 下游分析** | GATK HaplotypeCaller进行变异检测；硬过滤/VQSR | VCF文件 |
| **6. 注释** | ANNOVAR/SnpEff注释变异功能、频率、ClinVar | 注释后的变异表 |
| **7. 可视化** | IGV查看候选位点；R/Python绘制基因组图 | 检查用图表 |
| **8. 解读** | 结合数据库（ClinVar, gnomAD, PubMed）科学解释 | 最终生物学结论 |

### 我设定的分析场景

假设我们在做WGS分析（案例/对照设计，S01为对照、S02为病例），8个样本的manifest已在数据中提供。

**每个步骤的目的：**
- QC确保只有高质量数据进入后续分析，避免"garbage in, garbage out"
- 比对后处理去除PCR重复和测序偏好，提高变异检测准确性
- 下游分析因检测类型而异，WGS和RNA-seq流程完全不同
- 注释将基因组坐标转化为生物学意义

---

## 2. AI辅助的工作流

### 使用的提示词

**提示词1（计划优先）：**
> "请设计一个从FASTQ到可解释结果的完整WGS分析流程。包含FASTQ QC、参考基因组选择、比对、比对后处理、变异检测、注释和解读。说明每个步骤的关键参数和理由。我已有我的设计，请补充我可能遗漏的细节。"

**提示词2（软件参数验证）：**
> "对于BWA-MEM比对WGS PE数据，关键参数是什么？'-M'标记和read group信息的重要性是什么？如果使用GATK流程，BaseRecalibrator和ApplyBQSR的作用是什么？"

**提示词3（QC决策）：**
> "FastQC中Per base sequence quality出现WARN、Adapter content出现FAIL、Overrepresented sequences出现FAIL时应采取什么措施？处理后需要重新运行FastQC吗？"

### AI的关键建议与我修订的内容

AI提出了几个我忽略的重要细节：
1. **Read Group（@RG）标签必须在BWA比对时添加** — 这是GATK流程的必要条件，对下游变异检测至关重要
2. **比对后应使用samtools fixmate** — 修正PE配对信息，使下游markdup更准确
3. **GATK BQSR建议使用已知变异位点数据库** — 如dbSNP、1000 Genomes、Mills indels
4. **对于肿瘤-正常配对设计，需要专门的体细胞变异检测流程而非标准Germline流程**
5. **推荐使用MultiQC汇总所有样本FastQC报告** — 便于跨样本比较

---

## 3. 验证

### FastQC指标解读（≥4个）

我根据 `fastqc_snapshot.tsv` 提供的数据（合成S01 WGS样本）解读以下指标：

| Metric | 我关注的内容 | 解读 |
|---|---|---|
| **Per base sequence quality** | 3′末端Phred分数中位数在cycle 50后降至~12（WARN） | 约15%读段3′端质量明显下降。对于WGS分析，应进行3′端质量修剪（Trimmomatic SLIDINGWINDOW:4:15或Cutadapt -q 15），去除低质量尾部。80bp读段修剪后仍有足够长度 |
| **Per sequence GC content** | 主峰~41% GC + 高GC肩峰~78%（WARN） | 主峰41%符合人类基因组GC含量特征。~10%读段为高GC污染来源，可能是接头二聚体或其他外源污染。应通过BLAST比对确认污染源，必要时过滤掉高GC读段 |
| **Adapter content** | Illumina接头AGATCGGAAGAGC在约15%读段对3′端出现（FAIL） | 接头污染严重，必须用Cutadapt去除接头。注意这是合成数据中的陷阱，真实数据可能需要更复杂的接头识别。去除后应重新运行FastQC确认 |
| **Overrepresented sequences** | AGATCGGAAGAGC出现在过表达序列中（FAIL） | 与Adapter content一致，说明接头污染是问题的主要来源。处理方式和Adapter content相同，建议使用Cutadapt后重新QC |
| **Sequence duplication levels** | 约15%的R1读段为一模板序列重复（WARN） | 对于WGS，15%重复率尚可接受但需关注。samtools markdup或Picard MarkDuplicates可以标记/去除PCR重复。注意RNA-seq的重复率通常更高，评估时需考虑检测类型 |

### AI审计表

| AI建议 | 我的验证（来源） | 最终决定 |
|---|---|---|
| BWA比对时添加Read Group标签 | GATK Best Practices文档要求比对时使用-R参数添加@RG，后续HaplotypeCaller依赖该信息 | 采纳。@RG包含样本ID、文库名、测序平台等信息，是GATK变异检测的必要输入 |
| GATK BQSR使用已知变异库 | GATK文档建议使用至少dbSNP + 1000 Genomes + Mills indels为已知位点，BQSR通过建立协变量模型校正基质量值 | 采纳。但真实环境下需确认已知变异库版本与参考基因组匹配 |
| 使用samtools fixmate后markdup | samtools手册：fixmate修正PE配对标志位和插入片段信息，提高markdup准确性 | 采纳。'samtools fixmate -m'后再sort+markdup，这是标准WGS流程 |
| MultiQC替代逐样本检查 | MultiQC官网文档：支持FastQC、samtools、GATK等多种工具汇总，适合8样本规模 | 采纳。MultiQC生成的交互式HTML报告便于跨样本比较QC指标 |
| 参考基因组推荐GRCh38/hg38 | NCBI/GENCODE/Ensembl均已将GRCh38作为主要参考基因组，GRCh37已停止更新 | 采纳。使用GRCh38.p14最新补丁版本 + Ensembl v110注释GTF |

---

## 4. 最终结论

### 8步工作流总结

**Figure:** `figures/Q2_workflow.svg`

本工作流以WGS为蓝本，适用其他检测类型时的关键差异：
- **RNA-seq**：比对器换为STAR或HISAT2（剪接敏感），不需要markdup（或谨慎使用），下游为featureCounts差异表达而非变异检测
- **ATAC-seq**：比对器为bowtie2（允许跨染色体的线粒体读段），需要去除线粒体读段，下游为MACS2峰值检测
- **ChIP-seq**：比对器为bowtie2或BWA，需要input对照，下游为MACS2富集区域检测

该工作流设计的基本原则是：**每个步骤都要明确"为什么做"和"做什么"**，而不是盲目运行默认参数。QC不是一次性检查，而是需要在每个关键步骤后重新确认。

> **分析师，而非AI，应对最终分析结论的准确性、可重复性和生物学可信度负责**。AI可以建议工具和参数，但分析师必须理解每个步骤的原理，验证建议是否符合自己的数据特点，并最终用自己的科学判断解释结果。质量控制和参数选择背后是深刻的实验设计考量——分析师必须为每一条决策链负责。
