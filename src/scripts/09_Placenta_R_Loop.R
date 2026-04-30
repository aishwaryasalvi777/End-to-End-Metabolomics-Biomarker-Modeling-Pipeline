# Steps 6-13: Main loop across all placenta metabolites (R)
#
# Expected inputs (exported by 09_Placenta_ML_Modeling.ipynb):
#   outputs/ml_modeling/Placenta/Python_outputs/CSV/placenta_clean_from_python.csv
#   outputs/ml_modeling/Placenta/Python_outputs/CSV/cov_clean_from_python.csv
#
# Outputs:
#   CSV  -> outputs/ml_modeling/Placenta/R_outputs/CSV/
#   Images -> outputs/ml_modeling/Placenta/R_outputs/Iimages/

# ---------------------------------------------------------------------------
# 0. I/O paths
# ---------------------------------------------------------------------------

export_base         <- file.path("outputs", "ml_modeling", "Placenta", "Python_outputs", "CSV")
placenta_export_path <- file.path(export_base, "placenta_clean_from_python.csv")
cov_export_path     <- file.path(export_base, "cov_clean_from_python.csv")

r_csv_dir <- file.path("outputs", "ml_modeling", "Placenta", "R_outputs", "CSV")
img_dir   <- file.path("outputs", "ml_modeling", "Placenta", "R_outputs", "Images")

dir.create(r_csv_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(img_dir,   recursive = TRUE, showWarnings = FALSE)

# ---------------------------------------------------------------------------
# 1. Load inputs
# ---------------------------------------------------------------------------

if (file.exists(placenta_export_path) && file.exists(cov_export_path)) {
  placenta_clean <- utils::read.csv(placenta_export_path, row.names = 1, check.names = FALSE)
  cov_clean      <- utils::read.csv(cov_export_path,      row.names = 1, check.names = FALSE)

  # Restore factor levels expected by the modeling formula.
  cov_clean$GDM               <- factor(as.character(cov_clean$GDM),               levels = c("0", "1"))
  cov_clean$physical_activity <- factor(as.character(cov_clean$physical_activity), levels = c("0", "1"))

  common_samples  <- intersect(rownames(placenta_clean), rownames(cov_clean))
  placenta_clean  <- placenta_clean[common_samples, , drop = FALSE]
  cov_clean       <- cov_clean[common_samples, , drop = FALSE]

  cat(sprintf("Loaded Python-cleaned inputs from: %s\n", export_base))
  cat(sprintf("  placenta_clean shape: %d x %d\n", nrow(placenta_clean), ncol(placenta_clean)))
  cat(sprintf("  cov_clean shape:      %d x %d\n", nrow(cov_clean),      ncol(cov_clean)))

} else if (!exists("placenta_clean") || !exists("cov_clean")) {
  stop(
    "Required inputs not found. Either export Python-cleaned files or create in-memory objects: ",
    "placenta_clean and cov_clean."
  )
}

# ---------------------------------------------------------------------------
# Steps 6-13: Main loop across all placenta metabolites
# ---------------------------------------------------------------------------

metabolite_annotations <- colnames(placenta_clean)

p_store         <- numeric(0)
m_GDM_store     <- numeric(0)
m_non_GDM_store <- numeric(0)
log_fc_store    <- numeric(0)
raw_fc_store    <- numeric(0)

cat(sprintf("Starting loop over %d placenta metabolites...\n", length(metabolite_annotations)))
cat("This will apply Steps 6-13 to each metabolite.\n\n")

for (i in seq_along(metabolite_annotations)) {
  metabolite_name <- metabolite_annotations[i]

  # 1) Extract metabolite i and combine with covariates
  model_data <- data.frame(
    metabolite = placenta_clean[[metabolite_name]],
    cov_clean,
    check.names = FALSE
  )
  model_data <- model_data[stats::complete.cases(model_data), , drop = FALSE]

  if (nrow(model_data) == 0 || length(unique(model_data$GDM)) < 2) {
    p_store         <- c(p_store,         NA_real_)
    m_GDM_store     <- c(m_GDM_store,     NA_real_)
    m_non_GDM_store <- c(m_non_GDM_store, NA_real_)
    log_fc_store    <- c(log_fc_store,    NA_real_)
    raw_fc_store    <- c(raw_fc_store,    NA_real_)
  } else {
    # 2) Fit lm(metabolite[i] ~ GDM + covariates)
    rhs_terms   <- setdiff(colnames(cov_clean), "GDM")
    formula_str <- if (length(rhs_terms) > 0) {
      paste("metabolite ~ GDM +", paste(rhs_terms, collapse = " + "))
    } else {
      "metabolite ~ GDM"
    }
    fit <- stats::lm(stats::as.formula(formula_str), data = model_data)

    # 3) Extract p-value for GDM
    coef_table <- summary(fit)$coefficients
    gdm_rows   <- grep("^GDM", rownames(coef_table))
    gdm_pval   <- if (length(gdm_rows) >= 1) coef_table[gdm_rows[1], "Pr(>|t|)"] else NA_real_

    # 4-5) Means by group
    gdm_char     <- as.character(model_data$GDM)
    gdm_vals     <- model_data$metabolite[gdm_char %in% c("1", "1.0")]
    non_gdm_vals <- model_data$metabolite[gdm_char %in% c("0", "0.0")]

    m_gdm     <- if (length(gdm_vals)     > 0) mean(gdm_vals,     na.rm = TRUE) else NA_real_
    m_non_gdm <- if (length(non_gdm_vals) > 0) mean(non_gdm_vals, na.rm = TRUE) else NA_real_

    # 6) Log fold change (difference on log scale)
    log_fc <- if (!is.na(m_gdm) && !is.na(m_non_gdm)) m_gdm - m_non_gdm else NA_real_

    # 7) Raw fold change (2^log_fc)
    raw_fc <- if (!is.na(log_fc)) 2^log_fc else NA_real_

    # 8) Store values
    p_store         <- c(p_store,         gdm_pval)
    m_GDM_store     <- c(m_GDM_store,     m_gdm)
    m_non_GDM_store <- c(m_non_GDM_store, m_non_gdm)
    log_fc_store    <- c(log_fc_store,    log_fc)
    raw_fc_store    <- c(raw_fc_store,    raw_fc)
  }

  if (i %% 100 == 0) {
    cat(sprintf("  Processed %d metabolites...\n", i))
  }
}

cat(sprintf("\nCompleted loop. Processed %d metabolites.\n", length(metabolite_annotations)))
cat(sprintf("  p-values stored:      %d\n", length(p_store)))
cat(sprintf("  GDM means stored:     %d\n", length(m_GDM_store)))
cat(sprintf("  Non-GDM means stored: %d\n", length(m_non_GDM_store)))
cat(sprintf("  Fold changes stored:  %d\n", length(raw_fc_store)))

# ---------------------------------------------------------------------------
# Step 14: Convert stored vectors to arrays
# ---------------------------------------------------------------------------

p_array         <- as.numeric(p_store)
m_gdm_array     <- as.numeric(m_GDM_store)
m_non_gdm_array <- as.numeric(m_non_GDM_store)
log_fc_array    <- as.numeric(log_fc_store)
raw_fc_array    <- as.numeric(raw_fc_store)

cat("\nResults vectors prepared:\n")
cat(sprintf("  p-values:        %d\n", length(p_array)))
cat(sprintf("  GDM means:       %d\n", length(m_gdm_array)))
cat(sprintf("  Non-GDM means:   %d\n", length(m_non_gdm_array)))
cat(sprintf("  Log fold changes:%d\n", length(log_fc_array)))
cat(sprintf("  Raw fold changes:%d\n", length(raw_fc_array)))

cat("\nP-value summary:\n")
if (all(is.na(p_array))) {
  cat("  Min:    NA\n")
  cat("  Max:    NA\n")
  cat("  Mean:   NA\n")
  cat("  Median: NA\n")
} else {
  cat(sprintf("  Min:    %s\n", min(p_array,              na.rm = TRUE)))
  cat(sprintf("  Max:    %s\n", max(p_array,              na.rm = TRUE)))
  cat(sprintf("  Mean:   %s\n", mean(p_array,             na.rm = TRUE)))
  cat(sprintf("  Median: %s\n", stats::median(p_array,   na.rm = TRUE)))
}

# ---------------------------------------------------------------------------
# Step 15: Benjamini-Hochberg FDR correction
# ---------------------------------------------------------------------------

valid_p_mask <- !is.na(p_array)
pvals_adj_bh <- rep(NA_real_, length(p_array))

if (any(valid_p_mask)) {
  pvals_adj_bh[valid_p_mask] <- stats::p.adjust(p_array[valid_p_mask], method = "BH")
}

reject_bh <- !is.na(pvals_adj_bh) & (pvals_adj_bh < 0.05)

cat("\nBenjamini-Hochberg Correction Results:\n")
cat(sprintf("  Significant metabolites (FDR < 0.05): %d\n", sum(reject_bh, na.rm = TRUE)))

if (all(is.na(pvals_adj_bh))) {
  cat("  Min adjusted p-value:    NA\n")
  cat("  Max adjusted p-value:    NA\n")
  cat("  Mean adjusted p-value:   NA\n")
  cat("  Median adjusted p-value: NA\n")
} else {
  cat(sprintf("  Min adjusted p-value:    %s\n", min(pvals_adj_bh,            na.rm = TRUE)))
  cat(sprintf("  Max adjusted p-value:    %s\n", max(pvals_adj_bh,            na.rm = TRUE)))
  cat(sprintf("  Mean adjusted p-value:   %s\n", mean(pvals_adj_bh,           na.rm = TRUE)))
  cat(sprintf("  Median adjusted p-value: %s\n", stats::median(pvals_adj_bh, na.rm = TRUE)))
}

# ---------------------------------------------------------------------------
# Step 16: Q-values (Storey's approach)
# ---------------------------------------------------------------------------

q_vals          <- rep(NA_real_, length(p_array))
qvalue_available <- requireNamespace("qvalue", quietly = TRUE)

if (qvalue_available && any(valid_p_mask)) {
  q_obj                  <- qvalue::qvalue(p = p_array[valid_p_mask])
  q_vals[valid_p_mask]   <- as.numeric(q_obj$qvalues)
  cat("\nQ-values calculated using qvalue package\n")
} else {
  cat("\nqvalue package not available; using BH adjusted p-values as approximation\n")
  q_vals <- pvals_adj_bh
}

cat("\nQ-value Summary:\n")
if (all(is.na(q_vals))) {
  cat("  Min:    NA\n")
  cat("  Max:    NA\n")
  cat("  Mean:   NA\n")
  cat("  Median: NA\n")
} else {
  cat(sprintf("  Min:    %s\n", min(q_vals,            na.rm = TRUE)))
  cat(sprintf("  Max:    %s\n", max(q_vals,            na.rm = TRUE)))
  cat(sprintf("  Mean:   %s\n", mean(q_vals,           na.rm = TRUE)))
  cat(sprintf("  Median: %s\n", stats::median(q_vals, na.rm = TRUE)))
}

# ---------------------------------------------------------------------------
# Step 17: Create comprehensive results table
# ---------------------------------------------------------------------------

# Use metabolite_names if defined externally; otherwise use loop variable
if (exists("metabolite_names")) {
  metabolite_names_local <- metabolite_names
} else {
  metabolite_names_local <- metabolite_annotations
}

# Annotation columns to attach
anno_expected_cols <- c(
  "COMPOUND Name",
  "SUPER META PATHWAY",
  "SUB META PATHWAY",
  "ACQUISITION METHOD",
  "HMDB ID",
  "HMDB_annotation",
  "PUBCHEM ID",
  "CAS ID",
  "KEGG ID",
  "CHEMSPIDER ID"
)

# Locate placenta annotation file
anno_df   <- NULL
anno_path <- NULL

if (exists("PLACENTA_ANNO") && !is.null(PLACENTA_ANNO) && length(PLACENTA_ANNO) == 1 &&
    nzchar(PLACENTA_ANNO) && file.exists(PLACENTA_ANNO)) {
  anno_path <- PLACENTA_ANNO
} else {
  default_anno_path <- file.path("src", "processed_data", "placenta", "Met_ana_placenta.csv")
  if (file.exists(default_anno_path)) {
    anno_path <- default_anno_path
  }
}

if (!is.null(anno_path)) {
  anno_df <- utils::read.csv(anno_path, row.names = 1, check.names = FALSE)
  cat(sprintf("\nLoaded placenta annotation from: %s\n", anno_path))
} else {
  cat("\nPlacenta annotation file not found; annotation columns will be NA.\n")
}

# Build results data frame
results_df <- data.frame(
  Metabolite        = metabolite_names_local,
  p_value_raw       = p_array,
  p_value_corrected = pvals_adj_bh,
  q_value           = q_vals,
  Mean_GDM          = m_gdm_array,
  Mean_Non_GDM      = m_non_gdm_array,
  Log_Fold_Change   = log_fc_array,
  Raw_Fold_Change   = raw_fc_array,
  check.names       = FALSE,
  stringsAsFactors  = FALSE
)

# Append annotation columns
if (!is.null(anno_df)) {
  missing_anno_cols <- setdiff(anno_expected_cols, colnames(anno_df))
  for (col_name in missing_anno_cols) {
    anno_df[[col_name]] <- NA_character_
  }
  anno_df       <- anno_df[, anno_expected_cols, drop = FALSE]
  anno_expanded <- anno_df[match(metabolite_names_local, rownames(anno_df)), , drop = FALSE]
  rownames(anno_expanded) <- NULL
  results_df <- cbind(results_df, anno_expanded)
} else {
  for (col_name in anno_expected_cols) {
    results_df[[col_name]] <- NA_character_
  }
}

# Sort by raw p-value (most significant first)
results_df <- results_df[order(results_df$p_value_raw, na.last = TRUE), , drop = FALSE]
rownames(results_df) <- NULL

cat("\nResults Table Summary:\n")
cat(sprintf("  Total metabolites: %d\n", nrow(results_df)))
cat("\nFirst 10 rows (sorted by p-value):\n")
print(utils::head(results_df, 10))

# Save main results table
r_output_path <- file.path(r_csv_dir, "R_Output.csv")
utils::write.csv(results_df, r_output_path, row.names = FALSE)
cat(sprintf("\nSaved results to: %s\n", r_output_path))
cat(sprintf("Rows: %d, Columns: %d\n", nrow(results_df), ncol(results_df)))

# ---------------------------------------------------------------------------
# Step 18: Histograms (4 figures)
# ---------------------------------------------------------------------------

save_histogram <- function(x, plot_title, x_label, out_file, color) {
  x_non_na <- x[!is.na(x)]
  if (length(x_non_na) == 0) {
    cat(sprintf("Skipping histogram (all NA): %s\n", out_file))
    return(invisible(NULL))
  }
  grDevices::png(filename = out_file, width = 900, height = 650, res = 120)
  hist(
    x_non_na,
    breaks = 30,
    col    = color,
    border = "white",
    main   = plot_title,
    xlab   = x_label
  )
  grDevices::dev.off()
  cat(sprintf("Saved histogram: %s\n", out_file))
}

save_histogram(
  x          = results_df$p_value_raw,
  plot_title = "Histogram: Raw p-values (Placenta)",
  x_label    = "p_value_raw",
  out_file   = file.path(img_dir, "hist_raw_p_values.png"),
  color      = "#4C78A8"
)

save_histogram(
  x          = results_df$p_value_corrected,
  plot_title = "Histogram: BH-adjusted p-values (Placenta)",
  x_label    = "p_value_corrected",
  out_file   = file.path(img_dir, "hist_bh_adjusted_p_values.png"),
  color      = "#F58518"
)

save_histogram(
  x          = results_df$Log_Fold_Change,
  plot_title = "Histogram: Log Fold Change (Placenta)",
  x_label    = "Log_Fold_Change",
  out_file   = file.path(img_dir, "hist_log_fold_change.png"),
  color      = "#54A24B"
)

save_histogram(
  x          = results_df$Raw_Fold_Change,
  plot_title = "Histogram: Raw Fold Change (Placenta)",
  x_label    = "Raw_Fold_Change",
  out_file   = file.path(img_dir, "hist_raw_fold_change.png"),
  color      = "#E45756"
)

# ---------------------------------------------------------------------------
# Step 19: Side-by-side significance comparison plots (alpha = 0.05 and 0.10)
# ---------------------------------------------------------------------------

save_significance_comparison <- function(results_tbl, alpha, out_file) {
  cmp_df <- results_tbl[, c("p_value_raw", "p_value_corrected")]
  cmp_df <- cmp_df[stats::complete.cases(cmp_df), , drop = FALSE]

  n_total_cmp <- nrow(cmp_df)
  raw_yes     <- sum(cmp_df$p_value_raw       < alpha)
  raw_no      <- n_total_cmp - raw_yes
  fdr_yes     <- sum(cmp_df$p_value_corrected < alpha)
  fdr_no      <- n_total_cmp - fdr_yes

  grDevices::png(filename = out_file, width = 1200, height = 560, res = 120)
  old_par <- graphics::par(no.readonly = TRUE)
  on.exit({
    graphics::par(old_par)
    grDevices::dev.off()
  }, add = TRUE)

  graphics::par(mfrow = c(1, 2), mar = c(5, 4.5, 4, 1) + 0.1)

  bars1 <- graphics::barplot(
    height    = c(raw_no, raw_yes),
    names.arg = c("NO", "YES"),
    col       = c("#de0848", "#04066c"),
    ylim      = c(0, max(c(raw_no, raw_yes, 1)) * 1.1),
    main      = sprintf("Raw p < %.2f", alpha),
    ylab      = "Number of metabolites"
  )
  graphics::abline(h = graphics::axTicks(2), col = grDevices::rgb(0, 0, 0, alpha = 0.12), lty = 1)
  graphics::text(bars1, c(raw_no, raw_yes), labels = c(raw_no, raw_yes), pos = 3, cex = 0.95)

  bars2 <- graphics::barplot(
    height    = c(fdr_no, fdr_yes),
    names.arg = c("NO", "YES"),
    col       = c("#de0848", "#a018d2"),
    ylim      = c(0, max(c(fdr_no, fdr_yes, 1)) * 1.1),
    main      = sprintf("FDR < %.2f", alpha),
    ylab      = ""
  )
  graphics::abline(h = graphics::axTicks(2), col = grDevices::rgb(0, 0, 0, alpha = 0.12), lty = 1)
  graphics::text(bars2, c(fdr_no, fdr_yes), labels = c(fdr_no, fdr_yes), pos = 3, cex = 0.95)

  graphics::mtext(
    sprintf(
      "Significance Comparison — Placenta (alpha = %.2f): Raw vs FDR-Corrected",
      alpha
    ),
    side  = 3,
    outer = TRUE,
    line  = -1.5,
    cex   = 1.05
  )

  cat(sprintf("Saved significance comparison: %s\n", out_file))
  cat(sprintf("  Raw p<%.2f: %d/%d\n", alpha, raw_yes, n_total_cmp))
  cat(sprintf("  FDR<%.2f:   %d/%d\n", alpha, fdr_yes, n_total_cmp))
}

save_significance_comparison(
  results_tbl = results_df,
  alpha       = 0.05,
  out_file    = file.path(img_dir, "significance_comparison_alpha_0_05.png")
)

save_significance_comparison(
  results_tbl = results_df,
  alpha       = 0.10,
  out_file    = file.path(img_dir, "significance_comparison_alpha_0_10.png")
)

# ---------------------------------------------------------------------------
# Step 20: Threshold summary table (alpha = 0.10)
# ---------------------------------------------------------------------------

alpha_summary <- 0.10
cmp_df_01     <- results_df[, c("p_value_raw", "p_value_corrected")]
cmp_df_01     <- cmp_df_01[stats::complete.cases(cmp_df_01), , drop = FALSE]

n_total_01  <- nrow(cmp_df_01)
raw_yes_01  <- sum(cmp_df_01$p_value_raw       < alpha_summary)
fdr_yes_01  <- sum(cmp_df_01$p_value_corrected < alpha_summary)

summary_table_01 <- data.frame(
  metric = c("Raw p<0.1", "FDR<0.1"),
  count  = c(raw_yes_01, fdr_yes_01),
  total  = c(n_total_01, n_total_01),
  ratio  = c(
    sprintf("%d/%d", raw_yes_01, n_total_01),
    sprintf("%d/%d", fdr_yes_01, n_total_01)
  ),
  stringsAsFactors = FALSE
)

for (col_name in anno_expected_cols) {
  summary_table_01[[col_name]] <- NA_character_
}

summary_csv_path <- file.path(r_csv_dir, "threshold_summary_alpha_0_1.csv")
utils::write.csv(summary_table_01, summary_csv_path, row.names = FALSE)
cat(sprintf("\nSaved threshold summary: %s\n", summary_csv_path))
print(summary_table_01)

# ---------------------------------------------------------------------------
# Step 21: Save filtered metabolite tables with annotations
# ---------------------------------------------------------------------------

raw_p_lt_01  <- !is.na(results_df$p_value_raw) & results_df$p_value_raw < 0.10
raw_p_lt_005 <- !is.na(results_df$p_value_raw) & results_df$p_value_raw < 0.05

# Detailed table: p < 0.10 with means
metabolites_raw_p_lt_0_1_detailed <- results_df[
  raw_p_lt_01,
  c(
    "Metabolite", "p_value_raw", "p_value_corrected", "Log_Fold_Change",
    "Mean_GDM", "Mean_Non_GDM", anno_expected_cols
  ),
  drop = FALSE
]

# Compact table: p < 0.10 without means, with sequential index
metabolites_raw_p_lt_0_1 <- results_df[
  raw_p_lt_01,
  c("Metabolite", "p_value_raw", "p_value_corrected", "Log_Fold_Change", anno_expected_cols),
  drop = FALSE
]
metabolites_raw_p_lt_0_1 <- cbind(
  Index = seq_len(nrow(metabolites_raw_p_lt_0_1)),
  metabolites_raw_p_lt_0_1
)

# Detailed table: p < 0.05 with means
metabolites_raw_p_lt_0_05 <- results_df[
  raw_p_lt_005,
  c(
    "Metabolite", "p_value_raw", "p_value_corrected", "Log_Fold_Change",
    "Mean_GDM", "Mean_Non_GDM", anno_expected_cols
  ),
  drop = FALSE
]

out_p01_detailed <- file.path(r_csv_dir, "metabolites_raw_p_lt_0_1_detailed.csv")
out_p01          <- file.path(r_csv_dir, "metabolites_raw_p_lt_0_1.csv")
out_p005         <- file.path(r_csv_dir, "metabolites_raw_p_lt_0_05.csv")

utils::write.csv(metabolites_raw_p_lt_0_1_detailed, out_p01_detailed, row.names = FALSE)
utils::write.csv(metabolites_raw_p_lt_0_1,          out_p01,          row.names = FALSE)
utils::write.csv(metabolites_raw_p_lt_0_05,         out_p005,         row.names = FALSE)

cat(sprintf("Saved table: %s  (rows=%d)\n", out_p01_detailed, nrow(metabolites_raw_p_lt_0_1_detailed)))
cat(sprintf("Saved table: %s  (rows=%d)\n", out_p01,          nrow(metabolites_raw_p_lt_0_1)))
cat(sprintf("Saved table: %s  (rows=%d)\n", out_p005,         nrow(metabolites_raw_p_lt_0_05)))

cat("\nAll placenta R outputs saved.\n")
