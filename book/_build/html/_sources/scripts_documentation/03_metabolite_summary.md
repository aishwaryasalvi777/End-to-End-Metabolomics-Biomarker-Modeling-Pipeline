# Script 03: Metabolite Summary

Source script:
- `src/scripts/03_metabolite_summary.ipynb`

## Purpose

This script summarizes metabolite overlap between placenta and cord datasets and exports a multi-sheet summary workbook.

## Input

- `src/processed_data/placenta/Met_ana_placenta.csv`
- `src/processed_data/cord/Met_ana_cord.csv`

## Outputs Generated

| Output File | Type | Notes |
| --- | --- | --- |
| `outputs/summary_tables/metabolites_common_cord_placenta.xlsx` | XLSX | Contains three sheets: `Common`, `Cord_Only`, `Placenta_Only`. |

## Documentation Copy (XLSX)

- [metabolites_common_cord_placenta.xlsx](outputs/03_metabolite_summary/metabolites_common_cord_placenta.xlsx)

This is a documentation copy and does not modify anything in `src/`.

## Output Preview Tables

### Common (shape: `698 x 11`)

| COMP ID | COMPOUND Name | SUPER META PATHWAY | SUB META PATHWAY | ACQUISITION METHOD | HMDB ID |
| ---: | :--- | :--- | :--- | :--- | :--- |
| 107004 | beta-citrylglutamate | Amino Acid | Glutamate Metabolism | NEGa | HMDB0013220 |
| 108005 | 5-oxoproline | Amino Acid | Glutathione Metabolism | NEGa | HMDB0000267 |
| 109011 | N-acetylthreonine | Amino Acid | Glycine, Serine and Threonine Metabolism | NEGa | HMDB0062557 |

### Cord_Only (shape: `283 x 11`)

| COMP ID | COMPOUND Name | SUPER META PATHWAY | SUB META PATHWAY | ACQUISITION METHOD | HMDB ID |
| ---: | :--- | :--- | :--- | :--- | :--- |
| 1101001 | 1H-indole-7-acetic acid | Xenobiotics | Bacterial/Fungal | NEGa |  |
| 1102011 | 3-(3-hydroxyphenyl)propionate | Xenobiotics | Benzoate Metabolism | NEGa | HMDB0000375 |
| 1102012 | 3-(3-hydroxyphenyl)propionate sulfate | Xenobiotics | Benzoate Metabolism | NEGa | HMDB0094710 |

### Placenta_Only (shape: `199 x 11`)

| COMP ID | COMPOUND Name | SUPER META PATHWAY | SUB META PATHWAY | ACQUISITION METHOD | HMDB ID |
| ---: | :--- | :--- | :--- | :--- | :--- |
| 1002002 | gentisic acid-5-glucoside | Secondary metabolism | Benzenoids | NEGa |  |
| 1004006 | feruloylquinate (4) | Secondary metabolism | Phenylpropanoids | NEGa |  |
| 108004 | 4-hydroxy-nonenal-glutathione | Amino Acid | Glutathione Metabolism | NEGa |  |
