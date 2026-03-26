# Script 02: Cord Preprocessing

Source script:
- `src/scripts/02_cord_preprocessing.ipynb`

## Purpose

This script performs initial preprocessing for the cord blood metabolomics dataset using the `Normalized data` sheet from the raw workbook.

## What This Script Does

1. Loads cord normalized metabolomics data.
2. Splits the table into:
   - annotation columns (A-K)
   - metabolite intensity columns (L onward)
3. Transposes metabolite data so:
   - rows become samples
   - columns become metabolite `COMP ID`s
4. Saves all intermediate/final processed CSV files.

## Input

- Raw Excel file: `src/raw/MetaPro_cord_blood_Jan2022.xlsx`
- Sheet: `Normalized data`

## Outputs Generated

The script writes the following CSV files:

| Output CSV | Shape (rows x cols) | Description |
| --- | --- | --- |
| `src/processed_data/cord/Met_ana_cord.csv` | `981 x 11` | Annotation table extracted from columns A-K. |
| `src/processed_data/cord/Met_data_cord.csv` | `981 x 38` | Metabolite intensity matrix before transpose (metabolites x samples). |
| `src/processed_data/cord/Met_data_cord_T.csv` | `38 x 982` | Transposed matrix with `Sample` as first column and metabolite `COMP ID`s as features. |

These are the exact output files currently present under `src/processed_data/cord/`.

## Documentation Copies (XLSX)

To make outputs easy to open from the Jupyter Book site, CSV outputs were converted to XLSX and saved only in the documentation area:

- [Met_ana_cord.xlsx](outputs/02_cord_preprocessing/Met_ana_cord.xlsx)
- [Met_data_cord.xlsx](outputs/02_cord_preprocessing/Met_data_cord.xlsx)
- [Met_data_cord_T.xlsx](outputs/02_cord_preprocessing/Met_data_cord_T.xlsx)

These files are documentation copies and do not modify anything in `src/`.

## CSV Preview Tables

The tables below show a small preview of each CSV output.

### Met_ana_cord.csv (first 3 rows, selected columns)

| COMP ID | COMPOUND Name | SUPER META PATHWAY | SUB META PATHWAY | ACQUISITION METHOD |
| ---: | :--- | :--- | :--- | :--- |
| 107004 | beta-citrylglutamate | Amino Acid | Glutamate Metabolism | NEGa |
| 108005 | 5-oxoproline | Amino Acid | Glutathione Metabolism | NEGa |
| 109011 | N-acetylthreonine | Amino Acid | Glycine, Serine and Threonine Metabolism | NEGa |

### Met_data_cord.csv (first 3 rows, first 6 sample columns)

| sample-1 | sample-2 | sample-3 | sample-4 | sample-5 | sample-6 |
| ---: | ---: | ---: | ---: | ---: | ---: |
| 0.98292 | 0.991572 | 0.962144 | 1.00591 | 0.888982 | 0.936415 |
| 0.997001 | 1.02414 | 0.972625 | 1.01597 | 0.989501 | 0.966933 |
| 1.00122 | 1.01459 | 0.999607 | 1.00067 | 0.995799 | 1.00151 |

### Met_data_cord_T.csv (first 3 rows, first 6 columns)

| Sample | 107004 | 108005 | 109011 | 1101001 | 1101006 |
| :--- | ---: | ---: | ---: | ---: | ---: |
| sample-1 | 0.98292 | 0.997001 | 1.00122 | 1.0012 | 1.04041 |
| sample-2 | 0.991572 | 1.02414 | 1.01459 | 1.0193 | 0.853199 |
| sample-3 | 0.962144 | 0.972625 | 0.999607 | 0.891771 | 0.953293 |

## Quick Notes

- Utility functions are imported from `src/utils/io_utils.py`.
- Output paths are configured in `src/utils/config.py` using `CORD_ANNO`, `CORD_DATA`, and `CORD_DATA_T`.
- This script sets up the cord data format used in downstream analysis notebooks.
