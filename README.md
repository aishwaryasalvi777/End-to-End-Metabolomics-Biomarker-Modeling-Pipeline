# Metabolomics Project

A step-by-step metabolomics analysis pipeline for placenta and cord blood samples collected in January 2022. The pipeline covers data preprocessing, metabolite comparison, PCA, outlier detection, and loading-based driver identification.

---

## Table of Contents

- [Project Overview](#project-overview)
- [Repository Structure](#repository-structure)
- [Pipeline Steps](#pipeline-steps)
- [Outputs](#outputs)
- [Requirements](#requirements)
- [Getting Started](#getting-started)

---

## Project Overview

This project analyzes untargeted metabolomics data from two biological matrices:

- **Placenta** — `MetaPro_placenta_Jan2022.xlsx`
- **Cord Blood** — `MetaPro_cord_blood_Jan2022.xlsx`

Both datasets use normalized intensity values from the `Normalized data` sheet. The pipeline identifies metabolites unique to each tissue, runs dimensionality reduction via PCA, detects sample outliers, and determines which metabolites are the primary drivers of variation and outlier behavior.

---

## Repository Structure

```
Metabolomics_Project/
├── src/
│   ├── raw/                        # Raw Excel input files (not tracked)
│   ├── processed_data/
│   │   ├── placenta/               # Met_ana_placenta.csv, Met_data_placenta.csv, Met_data_placenta_T.csv
│   │   └── cord/                   # Met_ana_cord.csv, Met_data_cord.csv, Met_data_cord_T.csv
│   ├── scripts/                    # Numbered Jupyter notebooks (pipeline steps)
│   └── utils/
│       ├── config.py               # Centralized file path configuration
│       └── io_utils.py             # Data loading and saving helpers
├── outputs/
│   ├── pca/
│   │   ├── output_csv/             # All CSV outputs organized by step
│   │   │   ├── 04_pca/
│   │   │   ├── 05_outliers/
│   │   │   ├── 06_pc_scores/
│   │   │   └── 07_outlier_loadings/
│   │   └── output_images/          # PCA scatter plots and outlier visualizations
│   └── summary_tables/
├── other/                          # Supplementary R/Python exploratory scripts
└── README.md
```

---

## Pipeline Steps

Each step is implemented as a numbered Jupyter notebook in `src/scripts/`.

### 01 — Placenta Preprocessing ([`01_placenta_preprocessing.ipynb`](src/scripts/01_placenta_preprocessing.ipynb))
Loads the normalized placenta data from the raw Excel file and splits it into:
- **Annotation file** (`Met_ana_placenta.csv`) — compound metadata columns (COMP ID, name, pathway, database IDs, etc.)
- **Data file** (`Met_data_placenta.csv`) — metabolite intensity columns
- **Transposed data** (`Met_data_placenta_T.csv`) — samples as rows, metabolites as columns (model-ready format)

### 02 — Cord Blood Preprocessing ([`02_cord_preprocessing.ipynb`](src/scripts/02_cord_preprocessing.ipynb))
Mirrors the placenta preprocessing workflow for cord blood data, producing `Met_ana_cord.csv`, `Met_data_cord.csv`, and `Met_data_cord_T.csv`.

### 03 — Metabolite Summary ([`03_metabolite_summary.ipynb`](src/scripts/03_metabolite_summary.ipynb))
Compares COMP IDs across the placenta and cord annotation files to report:
- Metabolites **common** to both tissues
- Metabolites **exclusive** to placenta
- Metabolites **exclusive** to cord blood

### 04 — PCA Analysis ([`04_pca_analysis.ipynb`](src/scripts/04_pca_analysis.ipynb))
Runs PCA (up to 10 components, `StandardScaler` normalization) on three datasets:
- Placenta only
- Cord blood only
- Combined placenta + cord

Saves PC score CSVs and scatter plot visualizations to `04_pca/`.

### 05 — Outlier Detection ([`05_outlier_detection.ipynb`](src/scripts/05_outlier_detection.ipynb))
Flags samples as outliers when their PC1 or PC2 scores exceed ±20. Each sample receives a label of `high`, `low`, or `normal`. Saves:
- Full flag tables for all samples
- Outlier-only subsets
- Annotated PCA scatter plots highlighting outlier samples

### 06 — PC Scores with Sample Metadata ([`06_pc_scores.ipynb`](src/scripts/06_pc_scores.ipynb))
Enriches PC score tables by merging PCA results with sample metadata (Sample ID, Tube Label) from the `Sample Info` sheet of the raw Excel files. Outputs mapped CSVs for placenta, cord, and combined datasets.

### 07 — Outlier Loadings ([`07_outlier_loadings.ipynb`](src/scripts/07_outlier_loadings.ipynb))
Re-fits PCA and identifies metabolite drivers of variation and outlier behavior:
- **Top loadings** — top 20 metabolites per PC by absolute loading value
- **Outlier contributions** — per-sample z-score × loading contributions for PC1 and PC2
- **Recurrent driver summary** — metabolites that appear as drivers across multiple outlier samples

Outputs CSV and Excel files for placenta, cord, and combined datasets.

---

## Outputs

| Step | CSV Location | Description |
|------|-------------|-------------|
| 04 | `outputs/pca/output_csv/04_pca/` | PC scores (placenta, cord, combined) |
| 05 | `outputs/pca/output_csv/05_outliers/` | Outlier flags and outlier-only subsets |
| 06 | `outputs/pca/output_csv/06_pc_scores/` | PC scores merged with sample metadata |
| 07 | `outputs/pca/output_csv/07_outlier_loadings/` | Top loadings, outlier contributions, driver summaries |

PCA scatter plots and outlier visualizations are saved to `outputs/pca/output_images/`.

---

## Requirements

- Python 3.x
- `pandas`
- `numpy`
- `scikit-learn`
- `matplotlib`
- `openpyxl` (for reading `.xlsx` files)

Install dependencies:

```bash
pip install pandas numpy scikit-learn matplotlib openpyxl
```

---

## Getting Started

1. Place the raw Excel files in `src/raw/`:
   - `MetaPro_placenta_Jan2022.xlsx`
   - `MetaPro_cord_blood_Jan2022.xlsx`

2. Activate the virtual environment (if applicable):
   ```bash
   source .venv/bin/activate
   ```

3. Run the notebooks in order from `src/scripts/`, starting with `01_placenta_preprocessing.ipynb`.

> **Note:** All file paths are managed centrally in [`src/utils/config.py`](src/utils/config.py). Update `ROOT_DIR` or individual paths there if the project is moved.
