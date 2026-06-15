# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Context

Untargeted metabolomics research pipeline analyzing placenta tissue and umbilical cord blood from 40 pregnant women in Beijing. The study examines GDM (gestational diabetes mellitus) vs. non-GDM differences and the effects of PM2.5 air pollution exposure on metabolomic signatures. Two raw biological matrices: placenta (989 metabolites, n=40) and cord blood (982 metabolites, n=38).

## Running Notebooks

Notebooks must be run in sequential order from `src/scripts/`:

```bash
# Activate virtual environment first
source .venv/bin/activate

# Run a single notebook non-interactively
jupyter nbconvert --to notebook --execute src/scripts/01_placenta_preprocessing.ipynb

# Or open Jupyter Lab for interactive work
jupyter lab
```

R scripts are run directly in RStudio or via `Rscript`:
```bash
Rscript src/scripts/08_steps_6_13_main_loop.R
Rscript src/scripts/09_Placenta_R_Loop.R
```

## Pipeline Architecture

Numbered notebooks in `src/scripts/` define sequential phases — each builds on outputs of the prior step:

| Notebook | Purpose |
|----------|---------|
| `01` | Placenta preprocessing → splits raw Excel into annotation + data CSVs |
| `02` | Cord blood preprocessing → mirrors `01` for cord data |
| `03` | Metabolite overlap comparison (common / placenta-only / cord-only) |
| `04` | PCA on placenta, cord, and combined datasets (10 components) |
| `05` | Outlier detection: samples with \|PC1\| or \|PC2\| > 20 flagged as high/low/normal |
| `06` | Enriches PC scores with Sample ID and Tube Label from `Sample Info` sheet |
| `07` | Top metabolite loadings + per-outlier contributions + recurrent driver summary |
| `08` | Univariate OLS regression: each metabolite ~ GDM + covariates (cord, n=34) |
| `09` | Placenta-specific ML modeling (mirrors `08` for placenta) |
| `10` | Cord glucose-specific analysis |

R scripts (`08_steps_6_13_main_loop.R`, `09_Placenta_R_Loop.R`) replicate the OLS loop from notebooks 08/09 and read Python-exported cleaned CSVs from `outputs/ml_modeling/Python_outputs/CSV_files/`.

## Path Configuration

All file paths are centralized in [src/utils/config.py](src/utils/config.py). `ROOT_DIR` resolves to `src/` at runtime (two `dirname` calls up from `src/utils/config.py`). If the project is moved or paths need adjustment, update constants there — notebooks import from `src.utils.config` rather than hardcoding paths.

Key path constants:
- `PLACENTA_FILE` / `CORD_FILE` → raw Excel inputs in `src/raw/` (not git-tracked)
- `PLACENTA_ANNO`, `PLACENTA_DATA`, `PLACENTA_DATA_T` → processed CSVs in `src/processed_data/placenta/`
- `PCA_CSV_DIR`, `PCA_IMAGE_DIR` → output locations under `outputs/pca/`

Data loading helpers are in [src/utils/io_utils.py](src/utils/io_utils.py): `load_placenta_normalized()`, `load_cord_normalized()`, `save_csv()`.

## Data Conventions

- **Processed data shape**: annotation files are `[metabolites × 11 metadata columns]`; data files are `[metabolites × samples]`; transposed (`_T`) files are `[samples × metabolites]` — the analysis-ready format.
- **Normalized data sheet** is used for all downstream analysis (not raw Peak Area).
- **Sample linkage**: raw Excel `Sample Info` sheet maps generic `sample-N` labels to subject IDs / Tube Labels / GDM group; notebook 06 performs this merge.
- **Covariate file**: `src/raw/mata2022_caco_mar242022.xlsx` contains maternal clinical data (GDM status, age, BMI, diet, PM2.5 exposure); merged in notebooks 08/09 via subject ID.

## Output Structure

```
outputs/
├── pca/
│   ├── output_csv/
│   │   ├── 04_pca/          # PC scores (placenta, cord, combined)
│   │   ├── 05_outliers/     # Outlier flags and clean combined dataset
│   │   ├── 06_pc_scores/    # PC scores merged with sample metadata
│   │   └── 07_outlier_loadings/  # Top loadings, contributions, driver summaries
│   └── output_images/       # PCA scatter plots
├── ml_modeling/
│   ├── output_csv/08_cord_gdm/  # OLS regression results (981 metabolites)
│   ├── Python_outputs/      # Python-exported CSVs consumed by R scripts
│   └── R_outputs/           # R modeling outputs
└── summary_tables/          # metabolites_common_cord_placenta.xlsx
```

## Phase Status

- **Phases 1–6** (notebooks 01–09): Complete
- **Phase 7** (next): Chi-square tests for categorical covariates, paired placenta-vs-cord t-tests, PM2.5 correlation analysis, mediation analysis, ML classification models (logistic regression, random forest, SVM), sensitivity analyses

Key Phase 7 deliverables expected in `outputs/ml_modeling/` and `outputs/summary_tables/`.

## Dependencies

```bash
pip install pandas numpy scikit-learn matplotlib openpyxl statsmodels
```

For the Jupyter Book documentation under `book/`:
```bash
pip install "jupyter-book>=1.0.0,<2.0.0"
jupyter-book build book/
```

R packages needed: `stats` (base), plus any packages imported in the R loop scripts (check script headers).
