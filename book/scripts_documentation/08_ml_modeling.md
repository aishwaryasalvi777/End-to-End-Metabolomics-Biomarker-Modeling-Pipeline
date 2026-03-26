# Script 08: ML Modeling (Cord GDM)

Source script:
- `src/scripts/08_ML_modeling.ipynb`

## Purpose

Runs metabolite-level statistical modeling for cord data against GDM outcome and exports ranked results.

## Outputs Generated

| Output CSV | Shape (rows x cols) |
| --- | --- |
| `outputs/ml_modeling/output_csv/08_cord_gdm/cord_metabolite_gdm_ols_results.csv` | `981 x 18` |

## Documentation Copy (XLSX)

- [cord_metabolite_gdm_ols_results.xlsx](outputs/08_ml_modeling/cord_metabolite_gdm_ols_results.xlsx)

## CSV Preview Table

| Metabolite | p_value_raw | p_value_corrected | q_value | Mean_GDM | Mean_Non_GDM |
| ---: | ---: | ---: | ---: | ---: | ---: |
| 612027 | 0.000383977 | 0.376681 | 0.376681 | 1.01048 | 0.994387 |
| 624012 | 0.00245231 | 0.724689 | 0.724689 | 1.0244 | 0.990702 |
| 620002 | 0.00279988 | 0.724689 | 0.724689 | 0.997401 | 1.01521 |
