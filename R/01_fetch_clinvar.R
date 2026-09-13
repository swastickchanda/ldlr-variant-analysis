library(tidyverse)

destfile <- "data_raw/variant_summary.txt.gz"

# 1. Download fresh ClinVar data if not already present
if (!file.exists(destfile)) {
  dir.create("data_raw", showWarnings = FALSE)
  url <- "https://ftp.ncbi.nlm.nih.gov/pub/clinvar/tab_delimited/variant_summary.txt.gz"
  download.file(url, destfile, mode = "wb")
}

# 2. Memory-optimized parsing with strict missense and domain filters
target_genes <- c("LDLR", "APOB", "PCSK9", "LDLRAP1")

clinvar_raw <- read_tsv(
  destfile,
  col_select = c(GeneSymbol, Name, Assembly, Type, ClinicalSignificance, Chromosome, PositionVCF, ReferenceAlleleVCF, AlternateAlleleVCF, `RS# (dbSNP)`),
  col_types = cols(.default = col_character()),
  progress = FALSE
) %>%
  mutate(PositionVCF = as.numeric(PositionVCF)) %>%
  filter(
    GeneSymbol %in% target_genes,
    Assembly == "GRCh38",
    Type == "single nucleotide variant", # Exclude all indels, deletions, and insertions
    str_detect(Name, "p\\."),            # Require a protein-level annotation
    !str_detect(Name, "\\*|Ter|fs|=")    # Exclude nonsense, frameshift, and synonymous mutations
  ) %>%
  # STRICT DOMAIN FILTERING (GRCh38 Coordinates for FH Functional Hotspots)
  filter(
    (GeneSymbol == "LDLR" & between(PositionVCF, 11093311, 11107433)) |   # Ligand-binding domain (Exons 2-6)
      (GeneSymbol == "APOB" & between(PositionVCF, 21009000, 21014000)) |   # LDL-receptor binding domain (Exon 26)
      (GeneSymbol == "PCSK9" & between(PositionVCF, 55042000, 55055000)) |  # Catalytic domain
      (GeneSymbol == "LDLRAP1" & between(PositionVCF, 25568000, 25575000))  # PTB domain
  )

# 3. Format clinical significance categories
clinvar_panel <- clinvar_raw %>%
  select(
    Gene_Symbol = GeneSymbol,
    ClinicalSignificance,
    Chromosome,
    PositionVCF,
    ReferenceAlleleVCF,
    AlternateAlleleVCF,
    RS = `RS# (dbSNP)`
  ) %>%
  mutate(
    ACMG_Tier = case_when(
      str_detect(ClinicalSignificance, "(?i)pathogenic") & !str_detect(ClinicalSignificance, "(?i)conflict") ~ "Pathogenic",
      str_detect(ClinicalSignificance, "(?i)likely pathogenic") ~ "Likely Pathogenic",
      str_detect(ClinicalSignificance, "(?i)uncertain significance") ~ "VUS",
      str_detect(ClinicalSignificance, "(?i)likely benign") ~ "Likely Benign",
      str_detect(ClinicalSignificance, "(?i)benign") ~ "Benign",
      TRUE ~ "VUS"
    )
  )

write_tsv(clinvar_panel, "data_raw/clinvar_fh_panel.tsv")

# 4. Format input file for CADD web service
cadd_input <- clinvar_panel %>%
  filter(!is.na(PositionVCF), ReferenceAlleleVCF != "", AlternateAlleleVCF != "") %>%
  select(Chromosome, PositionVCF, RS, ReferenceAlleleVCF, AlternateAlleleVCF)

write_tsv(cadd_input, "data_raw/cadd_batch_input.vcf", col_names = FALSE)
message("Done! Output generated at data_raw/cadd_batch_input.vcf")
