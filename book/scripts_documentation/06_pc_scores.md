# Script 06: PC Scores Mapping

Source script:
- `src/scripts/06_pc_scores.ipynb`

## Purpose

Maps PCA PC1/PC2 scores to sample metadata and creates mapped tables for placenta, cord, and combined samples.

# 1. What this file Does: Analysis of Mapping IDs
- Up until Step 05, samples are just called sample-1, sample-2. This notebook opens the original Excel files and maps those generic names back to the real Tube Labels (like A20150) and IDCodes.
  
# Why we need it:
- We cannot calculate p-values for GDM in Step 08 if you don't know which "sample-#" belongs to which woman in the clinical dataset. This file creates the "Master Key" that links your PC Scores to the clinical metadata.

# Outputs
- The outputs from Step 06 are the most critical "Master Files" of our entire project. This is the stage where our Math (PC Scores) finally meets our Medicine (GDM Status).

# 1. What are these outputs?
- We have two main types of files for each group (Placenta, Cord, and Common):
- The "SampleID" Files (e.g., placenta_sampleid_pc1_pc2.csv):
These are "clean" lookup tables. They simply map your sample-1 name to the real lab Tube Label and the coordinates on the PCA plot.
- The "Mapped" Files (e.g., placenta_mapped_with_pc1_pc2.csv):
- These are your Master Datasets. They contain everything in one row:
   - The PC Scores (the "Patterns").
   - The GDM Label (0 or 1).
   - Clinical covariates (Mother's Age, BMI, Ethnicity, etc.).

# 2. What do these results mean?
Looking at your files, we can see that Step 06 has solved the "Who is who?" problem.

For example, in your Placenta data:

Sample-1 has a PC1 score of -1.83 and is a GDM case (GDM=1).

Sample-38 has a PC1 score of -1.35 and is a Control case (GDM=0).

The Biological Question: Now that you have these scores and labels side-by-side, you can ask: "Do GDM women generally have higher or lower PC1 scores than Control women?" If the answer is yes, then your PCA has successfully captured the biological signature of the disease.

## Outputs Generated

| Output CSV | Shape (rows x cols) |
| --- | --- |
| `outputs/pca/output_csv/06_pc_scores/placenta_mapped_with_pc1_pc2.csv` | `40 x 160` |
| `outputs/pca/output_csv/06_pc_scores/cord_mapped_with_pc1_pc2.csv` | `40 x 160` |
| `outputs/pca/output_csv/06_pc_scores/common_mapped_with_pc1_pc2.csv` | `78 x 161` |

## Documentation Copies (XLSX)

- [placenta_mapped_with_pc1_pc2.xlsx](outputs/06_pc_scores/placenta_mapped_with_pc1_pc2.xlsx)
- [cord_mapped_with_pc1_pc2.xlsx](outputs/06_pc_scores/cord_mapped_with_pc1_pc2.xlsx)
- [common_mapped_with_pc1_pc2.xlsx](outputs/06_pc_scores/common_mapped_with_pc1_pc2.xlsx)

## CSV Preview Tables

### placenta_mapped_with_pc1_pc2.csv

| Sample | PC1 Score | PC2 Score | TubeCode_key | IDCode | matchid |
| :--- | ---: | ---: | ---: | ---: | ---: |
| sample-1 | -1.83688 | 9.6748 | 20150 | 20150 | 1 |
| sample-3 | 5.09358 | 14.2129 | 20159 | 20159 | 2 |
| sample-38 | -1.35218 | 13.134 | 20184 | 20184 | 19 |

### cord_mapped_with_pc1_pc2.csv

| Sample | PC1 Score | PC2 Score | TubeCode_key | IDCode | matchid |
| :--- | ---: | ---: | ---: | ---: | ---: |
|  |  |  | 20150 | 20150 | 1 |
| sample-2 | -4.44316 | 2.92728 | 20159 | 20159 | 2 |
| sample-36 | -9.99573 | -7.53269 | 20184 | 20184 | 19 |

### common_mapped_with_pc1_pc2.csv

| Sample | Group | PC1 Score | PC2 Score | TubeCode_key | IDCode |
| :--- | :--- | ---: | ---: | ---: | ---: |
| sample-1 | Placenta | -2.75642 | 2.23543 | 20150 | 20150 |
| sample-3 | Placenta | 4.60622 | 7.81648 | 20159 | 20159 |
| sample-2 | Cord | -0.674444 | 4.06109 | 20159 | 20159 |
