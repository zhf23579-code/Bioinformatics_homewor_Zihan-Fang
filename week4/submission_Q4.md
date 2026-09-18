# Week 4 Homework Report — Question 4

**题目：** AI辅助变异优先排序

---

## 1. 使用AI前的推理

### 我的过滤逻辑

**分析目标：** 从12个合成变异中优先选出1-2个最有生物学和临床意义的变异进行深入研究。

**我的过滤策略（按顺序）：**

| 标准 | 规则/阈值 | 理由 |
|---|---|---|
| **FILTER** | 保留 PASS | 过滤失败的变异技术可靠性较低 |
| **测序深度 DP** | ≥ 30 | 确保变异检测有足够的读段支持 |
| **基因型质量 GQ** | ≥ 50 | 确保基因型判定的置信度 |
| **人群频率 AF** | ≤ 0.001（0.1%） | 罕见病/功能变异通常为低频；常见变异不太可能是致病性的 |
| **功能后果** | 保留 missense, stop_gained, frameshift, splice | 这些后果最可能影响蛋白质功能 |
| **ClinVar** | 参考但不作为硬过滤 | ClinVar Pathogenic/Uncertain需要关注，Benign可降级 |
| **基因生物学相关性** | 优先已知疾病相关基因 | TP53, BRCA2, KRAS, MSH2, LDLR等是已知疾病基因 |

**硬排除：**
- FILTER != PASS（技术问题，不可靠）
- AF > 0.001（常见变异，不太可能是致病性的）
- 同义/基因间/内含子变异（功能影响小或无）

**软排序：**
- ClinVar Pathogenic > Conflicting > Uncertain > Likely\_benign > Benign
- 功能后果严重程度：stop_gained/frameshift > splice > missense
- 基因的生物学/临床重要性

---

## 2. AI辅助的工作流

### 使用的提示词

**提示词1（计划优先）：**
> "我有12个合成变异（VCF格式数据），包含CHROM, POS, REF, ALT, FILTER, DP, GQ, AF, GENE, CONSEQUENCE, CLINVAR_SIG等列。我的过滤策略是：1) 只保留PASS，2) DP≥30, GQ≥50, 3) AF≤0.001, 4) 保留missense/splice/stop_gained/frameshift, 5) 按ClinVar和基因重要性排序。请求你帮我检查这个过滤逻辑是否有问题，并建议改进。"

**提示词2（R代码生成）：**
> "请使用R（tidyverse）写一段代码，使用上述过滤逻辑过滤variants_q4.tsv，并生成按优先级排序的结果。我已有一个starter代码在q4_filter_starter.R，请补充完整。"

**提示词3（假阳性批判）：**
> "假设我的最高优先级变异是TP53 splice_acceptor（ClinVar Pathogenic, AF=0.00001, DP=80, GQ=99），请给出TP53变异可能是假阳性的最少3个理由。然后告诉我哪些理由在科学上值得认真考虑。"

### AI的反馈

**关于过滤逻辑：**
- AI建议我**不要把ClinVar作为硬过滤**（因为Uncertain_significance的变异可能比已知Pathogenic的变异更需要研究）
- AI建议在排序中**加权基因的生物学重要性**：TP53是公认的抑癌基因，其功能缺失与多种癌症相关
- AI提醒：**chrX的MECP2变异虽然DP和GQ低，但如果是在X连锁遗传病背景下，DP=5可能仍有生物学意义**——但鉴于技术质量过低，我决定仍然排除
- AI建议在注释中加入**CONSEQUENCE的优先级**：splice_acceptor > stop_gained ≈ frameshift > missense

**关于假阳性批判，AI提出的理由：**

1. **合成数据的人为性** — 这些数据由教学目的合成，变异是"植入"的，不代表真实世界的变异
2. **单样本无法确认剪接效应** — 虽然CONSEQUENCE标注为splice_acceptor_variant，但没有RNA-seq数据验证该变异是否真正导致剪接异常
3. **ClinVar ID是占位符** — VCV000012345是教学用的占位符ID，不代表真实的ClinVar条目
4. **连锁不平衡** — 该变异附近可能还有真正的致病变异，它只是一个LD标记物
5. **纯合 vs 杂合状态** — 没有基因型信息（GT），无法判断是否为纯合突变

其中理由1-3是合成数据的固有特性（不影响作业评分），但**理由4和5在真实场景中非常重要**。

---

## 3. 验证

### 验证过程

**步骤1：硬过滤结果**

| 变异 | 原因 | 保留/排除 |
|---|---|---|
| chr17 TP53 splice_acceptor PASS, DP=80, GQ=99, AF=0.00001 | 全部通过 | ✅ **保留** |
| chr13 BRCA2 missense PASS, DP=60, GQ=90, AF=0.0001 | 全部通过 | ✅ **保留** |
| chr12 KRAS missense PASS, DP=58, GQ=91, AF=0.00015 | 全部通过 | ✅ **保留** |
| chr1 F5 missense PASS, AF=0.42 | AF > 0.001 | ❌ 排除 |
| chr7 CFTR synonymous PASS, AF=0.00005 | 同义变异 | ❌ 排除 |
| chr2 MSH2 stop_gained LowQual, DP=8, GQ=12 | FILTER≠PASS | ❌ 排除 |
| chr6 HLA-A missense FAIL, GQ=40 | FILTER≠PASS | ❌ 排除 |
| chr8 intergenic PASS | 基因间变异 | ❌ 排除 |
| chr11 ATM missense PASS, AF=0.18 | AF > 0.001 | ❌ 排除 |
| chr19 LDLR missense PASS, AF=0.0002 | AF ≤ 0.001, 但ClinVar Likely_benign | ❌ 排除（Likely_benign，低优先级） |
| chrX MECP2 frameshift PASS, DP=5, GQ=20 | DP<30, GQ<50 | ❌ 排除 |
| chr4 intron PASS, AF=0.35 | 内含子变异, AF>0.001 | ❌ 排除 |

**步骤2：优先排序**

| 排名 | 变异 | 理由 |
|---|---|---|
| **1** | **chr17:7673803 TP53 splice_acceptor** | ClinVar Pathogenic · AF极低(0.00001) · 功能后果严重（剪接供体位点） · TP53是核心抑癌基因 |
| **2** | **chr12:25398284 KRAS missense** | ClinVar Conflicting · AF低(0.00015) · KRAS是重要癌症驱动基因 · 需要进一步验证 |
| 3 | chr13:32316461 BRCA2 missense | ClinVar Uncertain_significance · 有意义但证据不足 |

### 验证依据（≥2个权威资源）

1. **ClinVar数据库**：TP53的致病性变异与Li-Fraumeni综合征和多种癌症相关。splice_acceptor_variant是高可信度致病性变异类型。
2. **Ensembl / NCBI RefSeq**：TP53（chr17:7,661,779-7,699,886）是位于17p13.1区域的抑癌基因。splice_acceptor变异通常导致外显子跳跃、隐式剪接位点激活或内含子保留，预测会导致蛋白质功能丧失。
3. **PubMed / 文献**：TP53功能缺失性变异是癌症中最常见的体细胞突变之一。剪接位点突变约占TP53突变的5-10%。

---

## 4. 最终结论

### 优先排序工作流

**Figure:** `figures/Q4_prioritization.svg`

### ~200字最终解释

**已知证据 → 计算推断 → 科学假说 → 所需实验**

**已知证据：** 变异chr17:7673803 G>A位于TP53基因的剪接供体位点附近，ClinVar标注为Pathogenic（VCV000012345），人群频率极低（AF=0.00001），测序质量优秀（DP=80, GQ=99）。BRCA2的罕见错义变异（ClinVar Uncertain_significance）和KRAS的错义变异（ClinVar冲突解读）也通过了所有技术过滤。

**计算推断：** 通过硬过滤（技术质量、频率、功能后果）和三阶段软排序（ClinVar置信度 + 基因重要性 + 后果严重性），TP53 splice_acceptor变异被定为最高优先级。该变异预测会破坏TP53前体mRNA的剪接，导致蛋白截短或功能丧失。

**科学假说：** TP53 splice_acceptor变异可能导致TP53单倍剂量不足或显性负效应，增加癌症易感性。在全基因组测序背景下，这一胚系变异可能解释病例的诊断表型。

**所需实验：** 1) Sanger测序验证该变异真实性；2) 从患者血液/组织提取RNA进行RT-PCR，观察TP53转录本是否出现异常剪接（外显子跳跃/内含子保留）；3) 如果可能，对患者肿瘤组织进行p53免疫组化染色确认蛋白表达缺失；4) 家族共分离分析（如果家系样本可用）。

### 假阳性批判中的关键考量

AI提出的"连锁不平衡"和"纯合/杂合状态未知"是在真实场景中最重要的假阳性来源。在临床报告中，必须确认该变异是否与表型共分离，并排除它只是LD标签变异的可能性。同时，由于这是合成教学数据，不应用于真实临床决策。

> **变异chr17:7673803 G>A (TP53 splice_acceptor) 可能通过破坏TP53 mRNA的正常剪接导致功能性p53蛋白缺失来增加癌症易感性；这可以通过RT-PCR检测患者样本中TP53的异常剪接产物和Sanger测序验证来测试。**
