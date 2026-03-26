# Script 04: PCA Analysis

Source script:
- `src/scripts/04_pca_analysis.ipynb`

## Purpose

Runs PCA for placenta-only, cord-only, and combined datasets, and saves PCA scores used downstream.

## Outputs Generated

| Output CSV | Shape (rows x cols) |
| --- | --- |
| `outputs/pca/output_csv/04_pca/pca_placenta_only.csv` | `40 x 11` |
| `outputs/pca/output_csv/04_pca/pca_cord_only.csv` | `38 x 11` |
| `outputs/pca/output_csv/04_pca/pca_combined_placenta_cord.csv` | `78 x 12` |

## Documentation Copies (XLSX)

- [pca_placenta_only.xlsx](outputs/04_pca_analysis/pca_placenta_only.xlsx)
- [pca_cord_only.xlsx](outputs/04_pca_analysis/pca_cord_only.xlsx)
- [pca_combined_placenta_cord.xlsx](outputs/04_pca_analysis/pca_combined_placenta_cord.xlsx)

## CSV Preview Tables

### pca_placenta_only.csv

| Sample | PC1 | PC2 | PC3 | PC4 | PC5 |
| :--- | ---: | ---: | ---: | ---: | ---: |
| sample-1 | -1.83688 | 9.6748 | -11.4935 | 9.48406 | 0.0991553 |
| sample-2 | 5.11914 | -5.97702 | -4.48825 | -9.7092 | 5.96511 |
| sample-3 | 5.09358 | 14.2129 | -3.2788 | -0.170095 | -3.59809 |

### pca_cord_only.csv

| Sample | PC1 | PC2 | PC3 | PC4 | PC5 |
| :--- | ---: | ---: | ---: | ---: | ---: |
| sample-1 | -3.12121 | 2.04994 | 1.7546 | 1.39859 | -11.4952 |
| sample-2 | -4.44316 | 2.92728 | 0.969894 | 2.65261 | -10.921 |
| sample-3 | -5.23315 | -2.2648 | 3.26936 | 5.29812 | -9.30695 |

### pca_combined_placenta_cord.csv

| Sample | PC1 | PC2 | PC3 | PC4 | PC5 |
| :--- | ---: | ---: | ---: | ---: | ---: |
| sample-1 | -2.75642 | 2.23543 | -4.35399 | -1.81598 | -3.66275 |
| sample-2 | 1.88677 | -1.92013 | 2.73178 | 2.40539 | -2.2973 |
| sample-3 | 4.60622 | 7.81648 | -8.66404 | -7.88419 | -2.40459 |
