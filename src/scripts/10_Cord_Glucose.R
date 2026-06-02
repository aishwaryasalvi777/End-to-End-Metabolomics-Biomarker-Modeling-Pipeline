# 10_Cord_Glucose.R
# Model: lm(Glucose ~ metabolite[i] + covariates)
# Metabolites: 89 significant from GDM analysis (R output raw p < 0.1)
# Run from project root: Rscript src/scripts/10_Cord_Glucose.R

# ---- Paths ----------------------------------------------------------------
python_dir <- file.path("outputs", "ml_modeling", "Python_outputs", "CSV_files")
r_sig_path <- file.path("outputs", "ml_modeling", "R_outputs", "CSV_files",
                        "metabolites_raw_p_lt_0_1.csv")
output_dir <- file.path("outputs", "10_Cord_Glucose_Analysis Outputs", "Cord", "R_Outputs")
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

# ---- Load data ------------------------------------------------------------
cord_clean <- utils::read.csv(
  file.path(python_dir, "cord_clean_from_python.csv"),
  row.names = 1, check.names = FALSE
)

cov_clean <- utils::read.csv(
  file.path(python_dir, "cov_clean_glucose_from_python.csv"),
  row.names = 1, check.names = FALSE
)

cov_clean$GDM               <- factor(as.character(cov_clean$GDM),               levels = c("0", "1"))
cov_clean$physical_activity <- factor(as.character(cov_clean$physical_activity), levels = c("0", "1"))

# ---- Filter to significant metabolites (R output raw p < 0.1) ------------
r_sig     <- utils::read.csv(r_sig_path, check.names = TRUE)
sig_ids   <- as.character(r_sig$Metabolite)
available <- intersect(sig_ids, colnames(cord_clean))

cord_clean_sig <- cord_clean[, available, drop = FALSE]

cat(sprintf("Significant metabolites (R output p < 0.1) : %d\n", length(sig_ids)))
cat(sprintf("Found in cord_clean                        : %d\n", length(available)))

# ---- Align samples --------------------------------------------------------
common_samples <- intersect(rownames(cord_clean_sig), rownames(cov_clean))
cord_clean_sig <- cord_clean_sig[common_samples, , drop = FALSE]
cov_clean      <- cov_clean[common_samples,      , drop = FALSE]

cat(sprintf("Samples used                               : %d\n\n", length(common_samples)))

# ---- Main loop ------------------------------------------------------------
metabolite_names <- colnames(cord_clean_sig)
covariate_cols   <- setdiff(colnames(cov_clean), "Glucose")

p_store    <- numeric(length(metabolite_names))
beta_store <- numeric(length(metabolite_names))

cat(sprintf("Starting loop over %d metabolites...\n", length(metabolite_names)))

for (i in seq_along(metabolite_names)) {
  met_name <- metabolite_names[i]

  model_data <- data.frame(
    Glucose    = cov_clean$Glucose,
    metabolite = cord_clean_sig[[met_name]],
    cov_clean[, covariate_cols, drop = FALSE],
    check.names = FALSE
  )
  model_data <- model_data[stats::complete.cases(model_data), , drop = FALSE]

  if (nrow(model_data) < 5 || stats::sd(model_data$metabolite) == 0) {
    p_store[i]    <- NA_real_
    beta_store[i] <- NA_real_
    next
  }

  formula_str <- paste("Glucose ~ metabolite +", paste(covariate_cols, collapse = " + "))
  fit         <- stats::lm(stats::as.formula(formula_str), data = model_data)
  coef_table  <- summary(fit)$coefficients

  if ("metabolite" %in% rownames(coef_table)) {
    p_store[i]    <- coef_table["metabolite", "Pr(>|t|)"]
    beta_store[i] <- coef_table["metabolite", "Estimate"]
  } else {
    p_store[i]    <- NA_real_
    beta_store[i] <- NA_real_
  }
}

cat(sprintf("Loop complete. Tested: %d metabolites.\n\n", length(p_store)))

# ---- BH correction --------------------------------------------------------
valid           <- !is.na(p_store)
p_adj_bh        <- rep(NA_real_, length(p_store))
p_adj_bh[valid] <- stats::p.adjust(p_store[valid], method = "BH")

cat("BH correction results:\n")
cat(sprintf("  Significant (FDR < 0.05) : %d\n", sum(p_adj_bh < 0.05, na.rm = TRUE)))
cat(sprintf("  Raw p < 0.05             : %d\n", sum(p_store  < 0.05, na.rm = TRUE)))
cat(sprintf("  Raw p < 0.1              : %d\n", sum(p_store  < 0.1,  na.rm = TRUE)))
cat(sprintf("  Min raw p                : %.4e\n\n", min(p_store, na.rm = TRUE)))

# ---- Results table --------------------------------------------------------
results_df <- data.frame(
  Metabolite  = metabolite_names,
  Beta        = beta_store,
  p_value_raw = p_store,
  p_value_BH  = p_adj_bh,
  stringsAsFactors = FALSE
)

anno_cols  <- intersect(c("Metabolite", "COMPOUND.Name", "SUPER.META.PATHWAY", "SUB.META.PATHWAY"),
                        colnames(r_sig))
results_df <- merge(results_df, r_sig[, anno_cols, drop = FALSE],
                    by = "Metabolite", all.x = TRUE)
results_df <- results_df[order(results_df$p_value_raw), ]

# ---- Save -----------------------------------------------------------------
save_path <- file.path(output_dir, "cord_glucose_ols_results_R.csv")
utils::write.csv(results_df, save_path, row.names = FALSE)

cat(sprintf("Results saved to : %s\n", save_path))
cat(sprintf("Shape            : %d rows x %d columns\n\n", nrow(results_df), ncol(results_df)))
cat("Top 10 metabolites by p-value:\n")
print(head(results_df[, intersect(c("Metabolite", "COMPOUND.Name", "Beta",
                                    "p_value_raw", "p_value_BH"), colnames(results_df))], 10))
