# Week 5 Interpretation: Differential Expression Analysis

## Comparison and Design
We performed a bulk RNA-seq differential expression analysis comparing **treated vs control** conditions (design: `~ batch + condition`), using 12 samples across 3 balanced batches (A, B, C).

## Strongest QC Observation
PCA shows PC1 (24% variance) separates samples by treatment condition, while PC2 (9% variance) shows no strong batch clustering, confirming that the treatment signal dominates and batch effects are modest.

## Significant Genes
At thresholds of `padj < 0.05` and `|log2FC| >= 1`, we identified **60 significant genes** out of 989 after pre-filtering: **36 upregulated** and **24 downregulated** in the treated condition.

## Biological Interpretation
The treated condition induces a broad transcriptional response with more genes upregulated than downregulated, consistent with activation of a coordinated biological program rather than global suppression.

## Limitation
With only 2 biological replicates per batch-condition combination, statistical power is limited and dispersion estimates rely heavily on DESeq2's shrinkage model.

## AI Use and Verification
AI (DeepSeek) generated the R analysis script and this interpretation. I independently verified sample identity matching, coefficient direction from `resultsNames(dds)`, count matrix integrity, and statistical thresholds. All code was run locally.
