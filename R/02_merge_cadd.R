library(tidyverse)

# 1. Read ClinVar panel data
clinvar_df <- read_tsv("data_raw/clinvar_fh_panel.tsv", show_col_types = FALSE) %>%
  mutate(
    Chromosome = as.character(Chromosome),
    PositionVCF = as.numeric(PositionVCF)
  )

# 2. Read CADD output
cadd_df <- read_tsv(
  "data_raw/cadd_multigene_scores.tsv.gz",
  comment = "#",
  col_names = c("Chromosome", "PositionVCF", "Ref", "Alt", "RawScore", "CADD_PHRED"),
  col_types = cols(.default = col_character())
) %>%
  mutate(
    Chromosome = as.character(Chromosome),
    PositionVCF = as.numeric(PositionVCF),
    CADD_PHRED = as.numeric(CADD_PHRED)
  )

# 3. Join CADD scores back onto the ClinVar panel dataset
master_df <- clinvar_df %>%
  left_join(
    cadd_df %>% select(Chromosome, PositionVCF, Ref, Alt, CADD_PHRED),
    by = c("Chromosome" = "Chromosome",
           "PositionVCF" = "PositionVCF",
           "ReferenceAlleleVCF" = "Ref",
           "AlternateAlleleVCF" = "Alt")
  ) %>%
  mutate(CADD_PHRED = coalesce(CADD_PHRED, 15.0))

# 4. Save master multi-gene dataset
write_tsv(master_df, "master_multigene_variants.tsv")
message("Master dataset created successfully: master_multigene_variants.tsv")
