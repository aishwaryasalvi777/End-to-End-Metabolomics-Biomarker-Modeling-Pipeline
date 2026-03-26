# Dataset 1: MetaPro_placenta_Jan2022.xlsx

`MetaPro_placenta_Jan2022.xlsx` contains metabolomics measurements from human placenta samples. This file is used to understand the metabolic profile of placenta tissue and compare patterns across sample groups.

## What are metabolites?

Metabolites are small chemical compounds detected in placenta samples, including amino acids, lipids, sugars, and related molecules.

Each metabolite has a `COMPOUND Name` and pathway labels:

- `SUPER META PATHWAY`: broad class (for example Lipids or Amino Acids)
- `SUB META PATHWAY`: detailed subgroup (for example Sterols or Fatty Acids)

## What are the samples?

- Total samples: 40
- Sample labels: `sample-1` to `sample-40`
- Group A: 20
- Group B: 20

## Rows and columns

- Rows: one row per metabolite
- Columns:
  - Metadata columns (first 11): compound identifiers and annotations
  - Sample columns: measured values per sample

Important metadata fields include `COMP ID`, `COMPOUND Name`, `HMDB ID`, `PUBCHEM ID`, `CAS ID`, and `KEGG ID`.

## Peak Area vs Normalized Data

- Peak Area data: raw instrument intensity
- Normalized data: processed values (log-transformed/adjusted) for downstream analyses

Normalized data is usually the preferred input for statistical analysis and PCA.

## Workbook sheets

- Data Key and Explanation
- Sample Info
- Peak Area Data
- Normalized Data
