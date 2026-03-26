# Script 05: Outlier Detection

Source script:
- `src/scripts/05_outlier_detection.ipynb`

## Purpose

Detects outliers in PCA space for placenta, cord, and combined datasets and saves outlier flags and cleaned combined PCA data.

## Outputs Generated

| Output CSV | Shape (rows x cols) |
| --- | --- |
| `outputs/pca/output_csv/05_outliers/placenta_outlier_flags_all_samples.csv` | `40 x 16` |
| `outputs/pca/output_csv/05_outliers/cord_outlier_flags_all_samples.csv` | `38 x 16` |
| `outputs/pca/output_csv/05_outliers/pca_combined_placenta_cord_no_outliers.csv` | `69 x 17` |

## Documentation Copies (XLSX)

- [placenta_outlier_flags_all_samples.xlsx](outputs/05_outlier_detection/placenta_outlier_flags_all_samples.xlsx)
- [cord_outlier_flags_all_samples.xlsx](outputs/05_outlier_detection/cord_outlier_flags_all_samples.xlsx)
- [pca_combined_placenta_cord_no_outliers.xlsx](outputs/05_outlier_detection/pca_combined_placenta_cord_no_outliers.xlsx)

## CSV Preview Tables

### placenta_outlier_flags_all_samples.csv

| Sample | PC1 | PC2 | PC3 | PC4 | PC5 |
| :--- | ---: | ---: | ---: | ---: | ---: |
| sample-1 | -1.83688 | 9.6748 | -11.4935 | 9.48406 | 0.0991553 |
| sample-2 | 5.11914 | -5.97702 | -4.48825 | -9.7092 | 5.96511 |
| sample-3 | 5.09358 | 14.2129 | -3.2788 | -0.170095 | -3.59809 |

### cord_outlier_flags_all_samples.csv

| Sample | PC1 | PC2 | PC3 | PC4 | PC5 |
| :--- | ---: | ---: | ---: | ---: | ---: |
| sample-1 | -3.12121 | 2.04994 | 1.7546 | 1.39859 | -11.4952 |
| sample-2 | -4.44316 | 2.92728 | 0.969894 | 2.65261 | -10.921 |
| sample-3 | -5.23315 | -2.2648 | 3.26936 | 5.29812 | -9.30695 |

### pca_combined_placenta_cord_no_outliers.csv

| Sample | PC1 | PC2 | PC3 | PC4 | PC5 |
| :--- | ---: | ---: | ---: | ---: | ---: |
| sample-1 | -2.75642 | 2.23543 | -4.35399 | -1.81598 | -3.66275 |
| sample-2 | 1.88677 | -1.92013 | 2.73178 | 2.40539 | -2.2973 |
| sample-3 | 4.60622 | 7.81648 | -8.66404 | -7.88419 | -2.40459 |
