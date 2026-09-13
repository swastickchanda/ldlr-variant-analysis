library(tidyverse)

ldlr_data <- read_tsv("master_multigene_variants.tsv")

high_cadd_vus <- ldlr_data %>%
  filter(ACMG_Tier == "VUS", CADD_PHRED >= 25) %>%
  arrange(desc(CADD_PHRED))

write_tsv(high_cadd_vus, "high_priority_vus_candidates.tsv")

head(high_cadd_vus, 5)
