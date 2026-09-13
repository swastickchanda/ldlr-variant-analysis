library(dplyr)
library(purrr)

fetch_multigene_variants <- function(gene_symbols, base_clinvar_df) {
  # Ensure Gene_Symbol column exists
  if (!"Gene_Symbol" %in% names(base_clinvar_df)) {
    base_clinvar_df <- base_clinvar_df %>% mutate(Gene_Symbol = "LDLR")
  }

  # Return empty data frame with same columns if no genes selected
  if (is.null(gene_symbols) || length(gene_symbols) == 0) {
    return(base_clinvar_df[0, ])
  }

  # Filter the dataset for the specified vector of gene symbols
  filtered_data <- base_clinvar_df %>%
    filter(Gene_Symbol %in% gene_symbols)

  # Standardize schema and compute auxiliary metrics
  processed_data <- filtered_data %>%
    mutate(
      ACMG_Tier = factor(ACMG_Tier, levels = c("Pathogenic", "Likely Pathogenic", "VUS", "Likely Benign", "Benign")),
      CADD_PHRED = as.numeric(CADD_PHRED)
    ) %>%
    arrange(Gene_Symbol, desc(CADD_PHRED))

  return(processed_data)
}

