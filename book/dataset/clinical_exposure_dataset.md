# Dataset 3: mata2022_caco_mar242022.xlsx

`mata2022_caco_mar242022.xlsx` is the clinical and environmental master dataset. It links subject-level maternal/fetal variables with metabolomics profiles.

## What is in this dataset?

This workbook includes data for 40 mother-baby pairs:

- Maternal health: age, education, BMI, GDM, PIH
- Birth outcomes: birth weight, sex, gestational age, preterm indicators
- Environmental exposure: weekly PM2.5 variables across pregnancy
- Lifestyle and diet: smoking, alcohol, activity, intake variables

## Key variables

- `IDCode` or `matchid`: linkage identifiers
- `GDM`: gestational diabetes status
- `Ma_age`: maternal age
- `birthweight`: infant birth weight
- `wkly_PM25_*`: weekly exposure variables
- `pre_BMI_new`: pre-pregnancy BMI

## Rows and columns

- Rows: one mother-baby pair per row
- Columns: one clinical, demographic, exposure, or lifestyle variable per column

## How it links to metabolomics files

- Metabolomics workbooks store measurements in `sample-*` columns
- Their `Sample Info` sheets map sample labels to subject identifiers
- Clinical workbook identifiers (`IDCode`/`matchid`) connect those records to maternal/fetal outcomes

This linkage enables analyses such as:

- metabolite differences between GDM and non-GDM groups
- PM2.5 window associations with metabolite patterns
- associations of BMI/diet with metabolite and outcome profiles

Together, the clinical workbook plus placenta and cord metabolomics files form the complete analysis-ready data foundation.
