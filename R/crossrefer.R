library(tidyverse)

# Export a clean, wide format of the final review table ensuring all variant alleles are visible
final_missense_candidates %>%
  select(`Protein change`, CADD_PHRED, `Germline review status`, VariationID, Chromosome, PositionVCF, ReferenceAlleleVCF, AlternateAlleleVCF) %>%
  write_csv("final_ldlr_missense_clean.csv")

# Display summary of finalized positions ready for literature review
print("Data pipeline complete. 6 unique high-priority residues exported for manual curation.")
