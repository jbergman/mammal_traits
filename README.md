# mammal_traits

Code repository for:

Bergman J, Pedersen RØ, Lundgren EJ, Trepel J, Pearce EA, Czyżewski S, Tietje M, Lemoine RT, Coll Macià M, Schierup MH, Svenning J-C.Trade-offs beget trade-offs: Causal analysis of mammalian population dynamics. https://www.biorxiv.org/content/10.1101/2024.08.16.608243v1.

---

## Overview

This repository contains the analysis pipeline for a study comparing how mammalian phenotypic traits influence two complementary metrics of population dynamics: **contemporary population density** and **long-term effective population size (*N*e)**. Using **phylogenetic path analysis (PPA)** applied to 380 terrestrial mammal species, we assessed the effects of eleven traits spanning allometry, diet, and reproduction across multiple species classifications (phylogenetic orders, trophic levels, and biomes).

---

## Repository Structure

```
mammal_traits/
├── mapping_and_PSMC/     # Bioinformatic pipeline for Ne estimation
├── path_analysis/        # Phylogenetic path analysis (main statistical analysis)
└── plot_figures/         # Figure generation scripts
```

### `mapping_and_PSMC/`

Python scripts for estimating *N*e trajectories using the **Pairwise Sequentially Markovian Coalescent (PSMC)** method. This includes:

- Short-read data acquisition and quality control
- Read mapping to reference genomes
- Variant discovery using the **Genome Analysis Toolkit (GATK)**
- PSMC inference of *N*e trajectories over time

Long-term *N*e for each species was summarized as the harmonic mean of the PSMC trajectory over the **100–800 kya** window.

### `path_analysis/`

R scripts implementing the **phylogenetic path analysis** pipeline, which is the core of the paper. Key steps include:

- Construction of **directed acyclic graphs (DAGs)** representing causal relationships among allometric traits (adult mass, brain mass, metabolic rate), dietary traits (animal diet %, fruit/seed diet %), and six reproductive traits (time to female maturity, gestation length, weaning age, interbirth interval, offspring per year, generation length)
- Evaluation of **54 predictor–response networks** per data subset, across 1,000 phylogenetic tree iterations and 3 trait evolution models (Pagel's λ, κ, δ), totalling 162,000 evaluated models per subset
- Model selection using Fisher's C statistic and the **CICc** (C statistic Information Criterion)
- Estimation of total trait effects on population density and *N*e for the full dataset and subsets stratified by **phylogenetic order** (Cetartiodactyla, Primates, Carnivora), **trophic level** (herbivore, omnivore, carnivore), and **biome** (cold, arid, tropical)
- Uses the `phylopath`, `phylolm`, and `daggity` R packages

### `plot_figures/`

R scripts for generating all main text and supplementary figures.

---

## Citation

If you use this code, please cite:

> Bergman J, Pedersen RØ, Lundgren EJ, Trepel J, Pearce EA, Czyżewski S, Tietje M, Lemoine RT, Coll Macià M, Schierup MH, Svenning J-C.Trade-offs beget trade-offs: Causal analysis of mammalian population dynamics. https://www.biorxiv.org/content/10.1101/2024.08.16.608243v1.

---

## Contact

Juraj Bergman — Center for Ecological Dynamics in a Novel Biosphere (ECONOVO), Department of Biology, Aarhus University & Bioinformatics Research Centre, Aarhus University.

