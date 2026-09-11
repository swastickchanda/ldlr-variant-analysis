# =====================================================================
# Project: LDLR Ligand-Binding Domain Pathogenicity Reclassification
# Description: End-to-end ACMG/AMP classification and visualization workflow
# =====================================================================

# 1. Load Required Libraries
library(httr)
library(jsonlite)
library(ggplot2)

# 2. Load and Inspect Annotated Dataset
# Ensure "ldlr_ligand_domain_annotated.tsv" is in your working directory
annotated_df <- read.delim("ldlr_ligand_domain_annotated.tsv", header = TRUE)

# 3. Assign Final ACMG Tiers Based on Computational Evidence
ldlr_final <- annotated_df

ldlr_final$Final_ACMG_Tier <- ifelse(
  ldlr_final$ACMG_Computational == "Supports PP3 (Deleterious)", "Likely Pathogenic / VUS (PP3)",
  ifelse(ldlr_final$ACMG_Computational == "Supports BP4 (Benign)", "Likely Benign / VUS (BP4)", "VUS (Intermediate)")
)

# Print summary of final classification counts to console
print(table(ldlr_final$Final_ACMG_Tier))

# Save the final classified dataset to project folder
write.table(ldlr_final, file = "ldlr_final_acmg_classification.tsv", sep = "\t", row.names = FALSE, quote = FALSE)

# 4. Generate Variant Distribution Plot
# Extract numerical amino acid position from the Protein.change column
ldlr_final$AA_Position <- as.numeric(gsub("[^0-9]", "", ldlr_final$Protein.change))

# Create publication-ready scatter plot
p <- ggplot(ldlr_final, aes(x = AA_Position, y = CADD_PHRED, color = Final_ACMG_Tier)) +
  geom_point(size = 3, alpha = 0.8) +
  scale_color_manual(values = c(
    "Likely Pathogenic / VUS (PP3)" = "#E41A1C",
    "Likely Benign / VUS (BP4)" = "#377EB8",
    "VUS (Intermediate)" = "#4DAF4A"
  )) +
  labs(
    title = "LDLR Ligand-Binding Domain Variant Distribution",
    subtitle = "Amino acid residues 22–292 evaluated via CADD and ACMG criteria",
    x = "Amino Acid Position (LDLR Protein)",
    y = "CADD Phred Score",
    color = "ACMG Classification Tier"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    legend.position = "bottom",
    legend.title = element_text(face = "bold")
  )

# Display plot in RStudio
print(p)

# 5. Export High-Resolution Figure
ggsave("ldlr_variant_distribution.png", plot = p, width = 8, height = 5, dpi = 300)
