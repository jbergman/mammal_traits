# Causal analysis of mammalian population dynamics

This repository contains scripts associated with the analyses presented in:

**Trade-offs beget trade-offs: Causal analysis of mammalian population dynamics**  
https://www.biorxiv.org/content/10.1101/2024.08.16.608243v1


## Repository Structure

### `mapping_and_calling/`

Contains a [`gwf`](https://gwf.app/) workflow and associated files used for:

- Downloading reference genome assemblies  
- Downloading short-read sequencing data  
- Read mapping  
- Variant calling  
- Genotyping  
- Running PSMC analyses  


### `path_analysis/`

Contains R scripts used to:

- Test conditional independencies of phylogenetic path models  
- Evaluate the fit of phylogenetic path models  
- Estimate regression coefficients for all models in which conditional independencies hold 

