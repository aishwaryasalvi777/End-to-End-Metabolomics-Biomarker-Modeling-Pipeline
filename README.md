# Metabolomics Project

A step-by-step metabolomics analysis pipeline for placenta and cord blood samples collected in January 2022. The pipeline covers data preprocessing, metabolite comparison, PCA, outlier detection, and loading-based driver identification.

---

## Table of Contents

- [Background](#background)
- [Project Overview](#project-overview)
- [Dataset Explanation: MetaPro_placenta_Jan2022](#dataset-explanation-metapro_placenta_jan2022)
- [Dataset Explanation: MetaPro_cord_blood_Jan2022](#dataset-explanation-metapro_cord_blood_jan2022)
- [Dataset Explanation: mata2022_caco_mar242022.xlsx](#dataset-explanation-mata2022_caco_mar242022xlsx)
- [Repository Structure](#repository-structure)
- [Pipeline Steps](#pipeline-steps)
- [Outputs](#outputs)
- [Requirements](#requirements)
- [Getting Started](#getting-started)

---

## Background

Air pollution remains a major global health issue and is associated with millions of deaths annually. Its burden is especially high in heavily polluted regions, including parts of China, where fine particulate matter such as PM2.5 has been linked to substantial mortality. Maternal exposure to pollutants including PM2.5, PM10, NO2, and NOx has also been associated with adverse pregnancy outcomes such as preterm birth, low birth weight, neurodevelopmental disorders, and gestational diabetes mellitus (GDM).

GDM affects a substantial proportion of pregnancies worldwide and is associated with both short-term and long-term health risks for mothers and children. These include pregnancy complications, later risk of type 2 diabetes, cardiovascular disease, and broader impacts on maternal and child health.

Prior studies examining the relationship between PM2.5 exposure and GDM have reported inconsistent findings. Studies conducted in China have generally shown stronger positive associations, while findings from the United States have been more mixed, suggesting possible differences across populations, environments, or study designs.

Metabolomics offers a useful way to investigate the biological mechanisms that may link air pollution exposure with GDM. By analyzing metabolites and metabolic pathways, researchers can study molecular changes related to oxidative stress, inflammation, and other processes that may underlie disease risk. This project supports that goal by analyzing metabolomic differences in placental tissue and umbilical cord blood from 40 pregnant women in Beijing, comparing control and GDM pregnancies in the context of air pollution exposure.

---

## Project Overview

This project analyzes untargeted metabolomics data from two biological matrices:

- **Placenta** — `MetaPro_placenta_Jan2022.xlsx`
- **Cord Blood** — `MetaPro_cord_blood_Jan2022.xlsx`

Both datasets use normalized intensity values from the `Normalized data` sheet. The pipeline identifies metabolites unique to each tissue, runs dimensionality reduction via PCA, detects sample outliers, and determines which metabolites are the primary drivers of variation and outlier behavior.

---

## Dataset Explanation: MetaPro_placenta_Jan2022

`MetaPro_placenta_Jan2022.xlsx` contains metabolomics measurements from human placenta samples. Metabolomics is the study of small molecules, called metabolites, that are produced or modified by biological processes. In this project, the dataset is used to understand the metabolic profile of placenta tissue and compare patterns across sample groups.

### 1. What are metabolites?

Metabolites are the individual chemical compounds detected in the placenta samples. These can include amino acids, lipids, sugars, and other small molecules. Each metabolite has a `COMPOUND Name` and is classified into:

- **SUPER META PATHWAY**: a broad biological category such as Lipids or Amino Acids
- **SUB META PATHWAY**: a more specific subgroup such as Sterols or Fatty Acids

These metabolites act as chemical signatures that reflect the health, nutrition, and metabolic activity of the placenta at the time the sample was collected.

### 2. What are the samples?

The samples are individual placenta tissue specimens collected for the study.

- Total samples: 40
- Sample labels: `sample-1` through `sample-40`
- Group A: 20 samples
- Group B: 20 samples

These groups are typically compared to determine whether certain metabolites are higher or lower in one group than the other.

### 3. What do the rows and columns represent?

#### Rows

Each row represents one unique metabolite. For example, a row may correspond to a compound such as `gentisic acid-5-glucoside`, and the values across that row show the measured abundance of that metabolite in each sample.

#### Columns

The columns are divided into two main sections:

- **Metadata columns**: the first 11 columns describe the metabolite itself
- **Sample columns**: the remaining columns, such as `sample-1` through `sample-40`, contain the measured values for each individual sample

Important metadata fields include:

- `COMP ID`: internal compound identifier
- `COMPOUND Name`: metabolite name
- `HMDB ID`, `PUBCHEM ID`, `CAS ID`, `KEGG ID`, and related fields: identifiers that map the metabolite to public chemical databases

### 4. Peak Area vs. Normalized Data

The dataset includes two versions of the metabolite measurements:

- **Peak Area data**: raw signal intensity values generated by the mass spectrometry platform
- **Normalized data**: processed values that have been log-transformed and adjusted to reduce technical variation and improve comparability across samples

The normalized data is the version typically used for downstream statistical analysis, PCA, and plotting in this repository.

### 5. Summary of the file contents

The Excel workbook includes multiple sheets that serve different purposes:

- **Data Key & Explanation**: defines the meaning of the column headers
- **Sample Info**: maps each sample to its study group, such as Group A or Group B
- **Peak Area / Normalized Data**: main measurement tables used for preprocessing and analysis

---

## Dataset Explanation: MetaPro_cord_blood_Jan2022

`MetaPro_cord_blood_Jan2022.xlsx` contains metabolomics measurements from human umbilical cord blood. Cord blood reflects the metabolic state of the baby at the time of birth and provides a snapshot of nutrients, waste products, and other small molecules associated with maternal-fetal exchange.

### 1. What is the context?

This is a metabolomics dataset of human cord blood. It helps characterize the biochemical state of the newborn at delivery and can be compared with placenta metabolomics to understand how metabolic processes differ across tissues under similar study conditions.

### 2. What are the samples?

- Total samples: 38
- Sample labels: `sample-1` through `sample-38`
- Experimental groups: Group A and Group B

Comparing the cord blood dataset with the placenta dataset makes it possible to study how fetal metabolic profiles differ from placental profiles within the same study framework.

### 3. What are the metabolites?

Each row represents a specific metabolite measured in cord blood. These include molecules from different biochemical classes, such as:

- **Amino acids**: for example `beta-citrylglutamate`, which are building blocks of proteins
- **Lipids**: for example `4-cholesten-3-one`, which are involved in membranes, signaling, and energy storage
- **Vitamins and cofactors**: molecules required for essential biochemical reactions

### 4. What do the columns indicate?

The columns provide both metabolite identifiers and sample-specific measurement values.

- **Identifiers**: `HMDB ID`, `PUBCHEM ID`, `KEGG ID`, and related fields connect each metabolite to external databases for biological interpretation
- **Acquisition Method**: values such as `NEGa` or `POSb` indicate the mass spectrometry ionization mode used for detection
- **Sample values**: columns `sample-1` through `sample-38` contain the measured abundance or intensity of each metabolite in each cord blood sample

### 5. Summary of the file contents

The workbook includes several types of information:

- **Sample Info**: maps each sample ID to Group A or Group B
- **Peak Area Data**: raw metabolite signal intensities from the instrument
- **Normalized Data**: cleaned values that have been adjusted, including log transformation and centering, for fair comparison across samples
- **Data Key**: definitions of spreadsheet terms and column names

In short, this file provides the chemical profile of 38 cord blood samples grouped into two study categories so researchers can evaluate which metabolites and pathways differ between those groups.

---

## Dataset Explanation: mata2022_caco_mar242022.xlsx

`mata2022_caco_mar242022.xlsx` is the broader clinical and environmental dataset for the study. Unlike the placenta and cord blood files, which focus on metabolite measurements, this workbook contains the subject-level maternal, fetal, and exposure variables that give biological and epidemiologic meaning to the metabolomics results.

This workbook functions as a master linkage file connecting the health status of the mother and baby with the metabolic profiles measured in placenta and cord blood.

### 1. What is in this dataset?

This dataset contains information for 40 mother-baby pairs, including:

- **Maternal health**: age, education, BMI, and conditions such as GDM and PIH
- **Birth outcomes**: birth weight, infant sex, gestational age, preterm status, and low birth weight indicators
- **Environmental exposure**: weekly PM2.5 exposure estimates across pregnancy, such as `wkly_PM25_hmwk_0` through later gestational weeks
- **Lifestyle and diet**: variables such as household income, smoking, alcohol use, physical activity, and dietary intake

### 2. Key columns and what they mean

Important variables for analysis include:

- `IDCode` / `matchid`: identifiers used to connect the clinical workbook with sample metadata from the metabolomics files
- `GDM`: gestational diabetes status, which is likely one of the main case-control grouping variables in the study
- `Ma_age`: maternal age
- `birthweight`: infant birth weight in grams
- `wkly_PM25_...`: weekly air pollution exposure variables across pregnancy
- `pre_BMI_new`: maternal pre-pregnancy BMI

### 3. What do the rows and columns represent?

- **Rows**: each row corresponds to one mother-baby pair
- **Columns**: each column corresponds to one clinical, demographic, environmental, or lifestyle variable collected for that pregnancy

### 4. How it connects to the other files

The key link across datasets is the subject identifier.

- In the master clinical workbook, identifiers such as `IDCode` or `matchid` represent individual mother-baby pairs
- In the metabolite workbooks, measurements are stored under generic sample columns such as `sample-1`, `sample-2`, and so on
- The `Sample Info` sheet provides the bridge that maps those sample labels to the subject identifiers used in the clinical workbook

This linkage allows researchers to connect exposures and outcomes with metabolite profiles. For example, they can ask:

- Are cord blood metabolites different between GDM and non-GDM pregnancies?
- Does higher PM2.5 exposure during a specific pregnancy window correspond to shifts in placental lipid metabolism?
- Are maternal BMI or diet variables associated with metabolite patterns or birth outcomes?

The linkage also makes it possible to compare tissues within the same pregnancy:

- **Placenta data**: reflects metabolic processes at the maternal-fetal interface
- **Cord blood data**: reflects the metabolic profile reaching the baby

Together, these datasets support analyses of whether observed metabolic patterns are associated with maternal health, environmental exposures, and infant outcomes.

### 5. Summary

Without the clinical workbook, the metabolite tables are mostly anonymous measurements. Without the metabolite tables, the clinical workbook is only demographic and health information. Together, they form the complete study dataset needed to relate pregnancy health and air pollution exposure to metabolomic variation in placenta and cord blood.

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
   - `mata2022_caco_mar242022.xlsx` for the sample metadata and clinical/environmental mapping used in notebook 06

2. Activate the virtual environment (if applicable):
   ```bash
   source .venv/bin/activate
   ```

3. Run the notebooks in order from `src/scripts/`, starting with `01_placenta_preprocessing.ipynb`.

> **Note:** All file paths are managed centrally in [`src/utils/config.py`](src/utils/config.py). Update `ROOT_DIR` or individual paths there if the project is moved.
