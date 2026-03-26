# Script 01: Placenta Preprocessing

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

The script writes the following files:

- `src/processed_data/placenta/Met_ana_placenta.csv`
  - annotation table extracted from columns A-K
- `src/processed_data/placenta/Met_data_placenta.csv`
  - metabolite intensity matrix before transpose
- `src/processed_data/placenta/Met_data_placenta_T.csv`
  - transposed matrix with `Sample` as first column and metabolite `COMP ID`s as feature columns

## Quick Notes

- Utility functions are imported from `src/utils/io_utils.py`.
- Output paths are configured in `src/utils/config.py` using `PLACENTA_ANNO`, `PLACENTA_DATA`, and `PLACENTA_DATA_T`.
- This script sets up the placenta data format used in downstream analysis notebooks.
