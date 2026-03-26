# Page 6: PC Scores Mapping

Source script:
- `src/scripts/06_pc_scores.ipynb`

## Purpose

Maps PCA PC1/PC2 scores to sample metadata and creates mapped tables for placenta, cord, and combined samples.

## What This Script Does

1. Loads PCA score outputs and study mapping metadata.
2. Extracts PC1 and PC2 score tables for placenta, cord, and combined sets.
3. Merges PCA scores with sample identifiers and subject-level metadata.
4. Saves mapped tables for placenta, cord, and common combined samples.
5. Exports both CSV and XLSX versions for reporting and downstream use.

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
