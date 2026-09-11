LDLR Variant of Uncertain Significance (VUS) Bioinformatics Pipeline
An automated R-based bioinformatics pipeline designed to extract, filter, and reclassify LDLR gene variants associated with Familial Hypercholesterolemia. This project prioritizes missense Variants of Uncertain Significance (VUS) within the ligand-binding domain using computational pathogenicity scores and ACMG/AMP criteria.

Project Overview
Target Gene: LDLR (Low-Density Lipoprotein Receptor)

Genomic Focus: Ligand-binding domain (Amino acid residues 22–292)

Primary Objective: Isolate VUS from ClinVar, integrate CADD PHRED pathogenicity scores, and apply automated classification rules to prioritize variants for downstream functional analysis or clinical research.

Repository Contents
LDLR WORKFLOW.R: The complete, commented R script handling data loading, filtering, ACMG tier assignment, and ggplot2 visualization.

ldlr_ligand_domain_59.tsv: The curated dataset containing 59 filtered missense variants within the LDLR ligand-binding domain along with their annotations.

ldlr_variant_distribution.png: A high-resolution scatter plot visualizing CADD PHRED scores plotted against amino acid positions, color-coded by assigned ACMG classification tier.

Methodology & Workflow
Data Ingestion: Extracted missense variants and conflicting interpretations mapped to the LDLR gene from ClinVar.

Domain Filtering: Parsed amino acid position changes to isolate variants specific to the ligand-binding domain (residues 22–292).

Scoring & Annotation: Integrated CADD PHRED scores to quantify variant deleteriousness.

Automated Tier Assignment: Categorized variants into preliminary ACMG/AMP evidence tiers (Likely Pathogenic / VUS, Likely Benign / VUS, and intermediate VUS) utilizing R conditional statements.

Data Visualization: Generated publication-ready scatter plots using ggplot2 to map variant distribution and severity across protein structural domains.

Tech Stack & Libraries
Language: R (Version 4.6+)

Core Libraries: dplyr (data wrangling), ggplot2 (visualization), readr (file I/O)

Data Sources: ClinVar, CADD (Combined Annotation Dependent Depletion)
