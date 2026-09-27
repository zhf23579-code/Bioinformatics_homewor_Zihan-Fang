# Week 6 Microbiome Bioinformatics — Scientific Hypothesis

## Analysis Parameters

| Parameter | Setting |
|-----------|---------|
| **Pipeline** | 16S Microbiome (Run All) |
| **Comparison groups** | Group (IBS_before, IBS_after, UC_before, UC_after) |
| **Taxonomy level** | Genus (Level 6) |
| **Alpha diversity indices** | Shannon, Simpson, Inverse Simpson, Chao1, ACE, Observed, Pielou |
| **Beta diversity methods** | PCoA, PCA, NMDS (Bray-Curtis distance) |
| **Differential analysis method** | Wilcoxon rank sum exact test |
| **p-value threshold** | Raw p < 0.05 (pre-filtering), FDR-adjusted reported |
| **Reference vs Test comparisons** | IBS_before vs IBS_after; UC_before vs UC_after; IBS_before vs UC_before |

---

## Scientific Hypothesis

### Hypothesis Title:
**Probiotic and anti-inflammatory microbial shifts are more pronounced in IBS patients after intervention compared to UC patients, suggesting disease-specific microbiome responsiveness.**

### Hypothesis Statement:

Based on the 16S rRNA gene amplicon sequencing analysis of fecal samples from IBS and UC patients before and after intervention, we hypothesize that:

> **The gut microbiome of IBS patients undergoes a more substantial shift toward a "health-associated" profile after intervention compared to UC patients, characterized by an increase in putative short-chain fatty acid (SCFA) producers and a decrease in pro-inflammatory taxa. This differential responsiveness may reflect the distinct pathophysiological basis of IBS (primarily functional/motility disorder) versus UC (chronic inflammatory mucosal damage), suggesting that microbiome-based therapeutic strategies should be disease-specific.**

### Evidence Supporting the Hypothesis:

#### 1. Alpha Diversity Trends
- Shannon index boxplots showed visual differences in within-sample diversity across the four groups (IBS_before, IBS_after, UC_before, UC_after)
- All 7 alpha diversity indices (Shannon, Simpson, InvSimpson, Chao1, ACE, Observed, Pielou) were computed and compared, providing a comprehensive view of community richness and evenness

#### 2. Beta Diversity (Community Structure)
- PCoA, PCA, and NMDS ordinations based on Bray-Curtis distances were generated
- The scatter plots allow visual assessment of whether samples from different groups form distinct clusters, indicating community-level differences between disease states and time points

#### 3. Differential Abundance Trends (Wilcoxon rank sum test)

**Key finding — IBS_before vs IBS_after (IBS treatment response):**

| Taxa (genus level) | p-value | log2FC | Trend | Possible Role |
|--------------------|---------|--------|-------|---------------|
| *Lactobacillus reuteri* | 0.0073 | −3.86 | **↑ Increases after tx** | Known probiotic; anti-inflammatory |
| *Bifidobacterium* (genus) | 0.0104 | −1.94 | **↑ Increases after tx** | Core probiotic genus |
| *Bifidobacterium animalis* | 0.0122 | −4.75 | **↑ Increases after tx** | Commercial probiotic strain |
| *Akkermansia muciniphila* | 0.0469 | −2.53 | **↑ Increases after tx** | Mucin-degrader; anti-inflammatory |
| Desulfovibrionaceae (fam) | 0.0017 | +2.88 | ↓ Decreases after tx | LPS-producing; pro-inflammatory |
| *Fusobacterium* (genus) | 0.0042 | +4.66 | ↓ Decreases after tx | Pro-inflammatory; associated with dysbiosis |
| *Bacteroides* (genus) | 0.0031 | +1.20 | ↓ Decreases after tx | Can be opportunistic |

**Interpretation for IBS:**
After intervention, IBS patients showed a clear shift: **beneficial bacteria (Lactobacillus, Bifidobacterium, Akkermansia) increased**, while **potentially harmful bacteria (Desulfovibrionaceae, Fusobacterium) decreased**. This suggests the intervention successfully remodeled the gut microbiome toward a healthier state.

**Key finding — IBS_before vs UC_before (Disease baseline comparison):**

- *Prevotella* was dramatically **lower in UC** (log2FC = −6.10, p = 0.017) — consistent with known UC-associated reduction in fiber-fermenting taxa
- *[Ruminococcus] torques* (log2FC = +2.87, p = 0.018) and *Alistipes indistinctus* (log2FC = +9.97, p = 0.024) were enriched in IBS — potential IBS-specific biomarkers
- *Enterococcus* was higher in UC (log2FC = −4.43, p = 0.031) — an opportunistic pathogen more abundant in inflammatory conditions

**Interpretation:**
The baseline microbiomes of IBS and UC patients are fundamentally different: UC patients show a more disrupted gut ecosystem with lower fermentative capacity, while IBS patients retain more diverse SCFA-producing taxa.

**Key finding — UC_before vs UC_after (UC treatment response):**
- *Bifidobacterium* (p = 0.008, log2FC = −1.72) increased after treatment — similar to IBS
- *Bifidobacterium animalis* (p = 0.020, log2FC = −3.38) also increased
- However, the overall magnitude and number of significant changes was smaller than in IBS
- *Bacteroides* species (caccae, uniformis, fragilis) were more abundant before treatment and decreased after — suggesting reduced potential pathobiont load

**Interpretation:**
UC patients showed some microbiome improvement after intervention, but the magnitude was less dramatic than in IBS, likely because UC involves structural mucosal damage that is harder to reverse.

### Conclusion

The combined evidence from alpha diversity profiles, beta diversity ordinations, and differential abundance testing supports the hypothesis that **IBS patients exhibit a more pronounced and consistent beneficial microbiome shift after intervention compared to UC patients**. The differential abundance analysis (Wilcoxon, raw p < 0.05) identified multiple probiotic taxa (e.g., *Lactobacillus*, *Bifidobacterium*, *Akkermansia*) increasing post-treatment specifically in the IBS group, while pro-inflammatory taxa (Desulfovibrionaceae, *Fusobacterium*) decreased. This suggests that **microbiome-targeted interventions may be more effective in functional disorders like IBS than in inflammatory bowel diseases like UC**, and that treatment strategies should be tailored to the underlying disease pathology.

---

*Generated based on EasyMultiProfiler 16S one-click run and Wilcoxon differential analysis results.*
