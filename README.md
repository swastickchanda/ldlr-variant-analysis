# LDLR Variant of Uncertain Significance (VUS) Bioinformatics Pipeline

An automated R-based bioinformatics pipeline designed to extract, filter, and reclassify *LDLR* gene variants associated with Familial Hypercholesterolemia. This project prioritizes missense Variants of Uncertain Significance (VUS) within the ligand-binding domain using computational pathogenicity scores and ACMG/AMP criteria.

## Project Overview

* **Target Gene:** *LDLR* (Low-Density Lipoprotein Receptor)
* **Genomic Focus:** Ligand-binding domain (Amino acid residues 22–292)
* **Primary Objective:** Isolate VUS from ClinVar, integrate CADD PHRED pathogenicity scores, and apply automated classification rules to prioritize variants for downstream functional analysis or clinical research.

## Repository Contents

* `LDLR WORKFLOW.R`: The complete, commented R script handling data loading, filtering, ACMG tier assignment, and `ggplot2` visualization.
* `ldlr_ligand_domain_59.tsv`: The curated dataset containing 59 filtered missense variants within the *LDLR* ligand-binding domain along with their annotations.
* `ldlr_variant_distribution.png`: A high-resolution scatter plot visualizing CADD PHRED scores plotted against amino acid positions, color-coded by assigned ACMG classification tier.

## Methodology & Workflow

1. **Data Ingestion:** Extracted missense variants and conflicting interpretations mapped to the *LDLR* gene from ClinVar.
2. **Domain Filtering:** Parsed amino acid position changes to isolate variants specific to the ligand-binding domain (residues 22–292).
3. **Scoring & Annotation:** Integrated CADD PHRED scores to quantify variant deleteriousness.
4. **Automated Tier Assignment:** Categorized variants into preliminary ACMG/AMP evidence tiers (`Likely Pathogenic / VUS`, `Likely Benign / VUS`, and intermediate `VUS`) utilizing R conditional statements.
5. **Data Visualization:** Generated publication-ready scatter plots using `ggplot2` to map variant distribution and severity across protein structural domains.

## Tech Stack & Libraries

* **Language:** R (Version 4.6+)
* **Core Libraries:** `dplyr` (data wrangling), `ggplot2` (visualization), `readr` (file I/O)
* **Data Sources:** ClinVar, CADD (Combined Annotation Dependent Depletion)

## Interactive Shiny Dashboard

An interactive Shiny web application designed to empower real-time exploration, filtering, and visualization of reclassified *LDLR* missense variants.

### Key Features
* **Reactive Data Filtering**: Dynamically explore variants powered by the underlying `cadd_ready_ldlr.tsv` dataset.
* **Domain Visualizations**: Integrated `ggplot2` visualizations mapping variant distributions across protein functional domains.
* **Summary Metrics**: Real-time tracking of variant counts and functional impact tiers.

## Interactive Shiny Dashboard

An interactive Shiny web application designed to empower real-time exploration, filtering, and visualization of reclassified *LDLR* missense variants.

🌐 **[Access the Live Web Application](https://swastick.shinyapps.io/disease/)**

### Running the App Locally
If you prefer to clone or open this repository in RStudio and run the dashboard locally, execute the following commands in your R console:

```r
install.packages(c("shiny", "tidyverse", "ggplot2"))
shiny::runApp()

