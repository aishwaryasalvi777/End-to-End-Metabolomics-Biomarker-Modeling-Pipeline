# Script 07: Outlier Loadings

Source script:
- `src/scripts/07_outlier_loadings.ipynb`

## Purpose

Quantifies metabolite loadings and contributions for outlier samples and summarizes recurrent outlier drivers.

## Outputs Generated

| Output CSV | Shape (rows x cols) |
| --- | --- |
| `outputs/pca/output_csv/07_outlier_loadings/combined_top_loadings_pc1_pc2.csv` | `80 x 8` |
| `outputs/pca/output_csv/07_outlier_loadings/combined_outlier_contributions.csv` | `280 x 15` |
| `outputs/pca/output_csv/07_outlier_loadings/outlier_findings_summary_with_explanations.csv` | `14 x 8` |

## Documentation Copies (XLSX)

- [combined_top_loadings_pc1_pc2.xlsx](outputs/07_outlier_loadings/combined_top_loadings_pc1_pc2.xlsx)
- [combined_outlier_contributions.xlsx](outputs/07_outlier_loadings/combined_outlier_contributions.xlsx)
- [outlier_findings_summary_with_explanations.xlsx](outputs/07_outlier_loadings/outlier_findings_summary_with_explanations.xlsx)

## CSV Preview Tables

### combined_top_loadings_pc1_pc2.csv

| Dataset | PC | Rank | Metabolite | Metabolite_Name | Loading |
| :--- | :--- | ---: | ---: | :--- | ---: |
| Placenta | PC1 | 1 | 309001 | flavin adenine dinucleotide (FAD) | 0.0650177 |
| Placenta | PC1 | 2 | 657002 | 1-(1-enyl-palmitoyl)-2-arachidonoyl-GPE (P-16:0/20:4)* | 0.0647539 |
| Placenta | PC1 | 3 | 677011 | cholesterol | 0.0642181 |

### combined_outlier_contributions.csv

| Dataset | Sample | PC | PC_Score | PC_Flag | Rank |
| :--- | :--- | :--- | ---: | :--- | ---: |
| Placenta | sample-12 | PC1 | -36.6913 | low | 1 |
| Placenta | sample-12 | PC1 | -36.6913 | low | 2 |
| Placenta | sample-12 | PC1 | -36.6913 | low | 3 |

### outlier_findings_summary_with_explanations.csv

| Dataset | Sample | PC | PC_Score | PC_Flag | Top_Abs_Contribution |
| :--- | :--- | :--- | ---: | :--- | ---: |
| Cord | sample-20 | PC1 | 45.2363 | high | 0.227925 |
| Cord | sample-22 | PC1 | 30.627 | high | 0.268638 |
| Cord | sample-23 | PC1 | 31.2931 | high | 0.194647 |
