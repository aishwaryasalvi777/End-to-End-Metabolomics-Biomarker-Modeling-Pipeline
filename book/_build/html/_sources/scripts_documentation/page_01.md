# Page 1: Placenta Preprocessing

Source script:
- `src/scripts/01_placenta_preprocessing.ipynb`

## Purpose

This script performs initial preprocessing for the placenta metabolomics dataset using the `Normalized data` sheet from the raw workbook.

## What This Script Does

1. Loads placenta normalized metabolomics data.
2. Splits the table into:
   - annotation columns (A-K)
   - metabolite intensity columns (L onward)
3. Transposes metabolite data so:
   - rows become samples
   - columns become metabolite `COMP ID`s
4. Saves all intermediate/final processed CSV files.

## Input

- Raw Excel file: `src/raw/MetaPro_placenta_Jan2022.xlsx`
- Sheet: `Normalized data`

## Outputs Generated

The script writes the following CSV files:

| Output CSV | Shape (rows x cols) | Description |
| --- | --- | --- |
| `src/processed_data/placenta/Met_ana_placenta.csv` | `897 x 11` | Annotation table extracted from columns A-K. |
| `src/processed_data/placenta/Met_data_placenta.csv` | `897 x 40` | Metabolite intensity matrix before transpose (metabolites x samples). |
| `src/processed_data/placenta/Met_data_placenta_T.csv` | `40 x 898` | Transposed matrix with `Sample` as first column and metabolite `COMP ID`s as features. |

These are the exact output files currently present under `src/processed_data/placenta/`.

## CSV Preview Tables

The tables below show a small preview of each CSV output.

### Met_ana_placenta.csv (first 3 rows, selected columns)

| COMP ID | COMPOUND Name | SUPER META PATHWAY | SUB META PATHWAY | ACQUISITION METHOD |
| ---: | :--- | :--- | :--- | :--- |
| 1002002 | gentisic acid-5-glucoside | Secondary metabolism | Benzenoids | NEGa |
| 1004006 | feruloylquinate (4) | Secondary metabolism | Phenylpropanoids | NEGa |
| 107004 | beta-citrylglutamate | Amino Acid | Glutamate Metabolism | NEGa |

### Met_data_placenta.csv (first 3 rows, first 6 sample columns)

| sample-1 | sample-2 | sample-3 | sample-4 | sample-5 | sample-6 |
| ---: | ---: | ---: | ---: | ---: | ---: |
| 1.06725 | 0.846538 | 0.928315 | 1.10147 | 1.14512 | 0.888192 |
| 1.14687 | 0.985189 | 0.991967 | 1.09625 | 1.17238 | 0.979079 |
| 1.0056 | 1.00393 | 0.970812 | 0.997856 | 1.0185 | 0.98753 |

### Met_data_placenta_T.csv (first 3 rows, first 6 columns)

| Sample | 1002002 | 1004006 | 107004 | 108004 | 108005 |
| :--- | ---: | ---: | ---: | ---: | ---: |
| sample-1 | 1.06725 | 1.14687 | 1.0056 | 0.787917 | 1.02855 |
| sample-2 | 0.846538 | 0.985189 | 1.00393 | 0.964908 | 0.992848 |
| sample-3 | 0.928315 | 0.991967 | 0.970812 | 0.787917 | 1.02849 |

## Quick Notes

- Utility functions are imported from `src/utils/io_utils.py`.
- Output paths are configured in `src/utils/config.py` using `PLACENTA_ANNO`, `PLACENTA_DATA`, and `PLACENTA_DATA_T`.
- This script sets up the placenta data format used in downstream analysis notebooks.
