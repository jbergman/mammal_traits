library(ggplot2)

supp_tables_pop_density_models = c("supp_table_2", "supp_table_4", "supp_table_6", "supp_table_8", "supp_table_10", 
                                   "supp_table_12", "supp_table_14", "supp_table_16", "supp_table_18", "supp_table_20")
supp_tables_ne_models = c("supp_table_3", "supp_table_5", "supp_table_7", "supp_table_9", "supp_table_11", 
                          "supp_table_13", "supp_table_15", "supp_table_17", "supp_table_19", "supp_table_21")

supp_tables_pop_density_coeffs = c("supp_table_22", "supp_table_24", "supp_table_26", "supp_table_28", "supp_table_30", 
                                   "supp_table_32", "supp_table_34", "supp_table_36", "supp_table_38", "supp_table_40")
supp_tables_ne_coeffs = c("supp_table_23", "supp_table_25", "supp_table_27", "supp_table_29", "supp_table_31", 
                          "supp_table_33", "supp_table_35", "supp_table_37", "supp_table_39", "supp_table_41")

fig_names = c("fig_9", "fig_10", "fig_11", "fig_12", "fig_13", "fig_14", "fig_15", "fig_16", "fig_17", 
              "fig_18", "fig_19", "fig_20", "fig_21", "fig_22", "fig_23", "fig_24", "fig_25")

ii = 1
jj = 1
kk = 1

#### plots
for(oo in c("All", "Cetartiodactyla", "Primates", "Carnivora", "Herbivore", "Omnivore", "Carnivore", "Cold", "Arid", "Tropical")){
  #### load model and coefficient data
  all_models <- read.table(paste0("~/", supp_tables_pop_density_models[ii] , ".txt"), sep = "\t", header = T)
  print(dim(all_models))
  all_models <- subset(all_models, p > 0.05 & WARNING == "no" & !(is.na(CICc)))
  all_models <- all_models[order(all_models$CICc),]
  best_evo_models_pd <- c()
  for(i in unique(all_models$PHYLO_TREE_IDX)){
    temp <- subset(all_models, PHYLO_TREE_IDX == i)
    best_evo_models_pd <- c(best_evo_models_pd, temp$TRAIT_EVO_MODEL[1])
  }
  print(table(best_evo_models_pd))
  most_common_evo_model_pd = names(which(table(best_evo_models_pd)==max(table(best_evo_models_pd))))
  alternative_evo_model_pd = names(which(table(best_evo_models_pd)==min(table(best_evo_models_pd))))
  
  all_models <- read.table(paste0("~/", supp_tables_ne_models[ii] , ".txt"), sep = "\t", header = T)
  print(dim(all_models))
  all_models <- subset(all_models, p > 0.05 & WARNING == "no" & !(is.na(CICc)))
  all_models <- all_models[order(all_models$CICc),]
  best_evo_models_ne <- c()
  for(i in unique(all_models$PHYLO_TREE_IDX)){
    temp <- subset(all_models, PHYLO_TREE_IDX == i)
    best_evo_models_ne <- c(best_evo_models_ne, temp$TRAIT_EVO_MODEL[1])
  }
  print(table(best_evo_models_ne))
  most_common_evo_model_ne = names(which(table(best_evo_models_ne)==max(table(best_evo_models_ne))))
  alternative_evo_model_ne = names(which(table(best_evo_models_ne)==min(table(best_evo_models_ne))))
  ii = ii + 1

  full_data <- read.table(paste0("~/", supp_tables_pop_density_coeffs[jj] , ".txt"), sep = "\t", header = T)
  full_data $RESPONSE <- "Population density"
  
  temp <- read.table(paste0("~/", supp_tables_ne_coeffs[jj] , ".txt"), sep = "\t", header = T)
  temp$RESPONSE <- "Effective population size"
  full_data <- rbind(full_data, temp)
  jj = jj +1
  
  #### plot for primary model
  data <- rbind(subset(full_data, RESPONSE == "Population density" & TRAIT_EVO_MODEL == most_common_evo_model_pd), subset(full_data, RESPONSE == "Effective population size" & TRAIT_EVO_MODEL == most_common_evo_model_ne))
  data$PREDICTOR <- factor(data$PREDICTOR, levels = c("M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"))
  data$RESPONSE <- factor(data$RESPONSE, levels = c("Population density", "Effective population size"))
  data$COLOUR <- "gray"
  
  data$COLOUR[which(data$PREDICTOR %in% c("M", "B", "MR"))] <- "#ffd8b1"
  data$COLOUR[which(data$PREDICTOR %in% c("M", "B", "MR") & data$PVAL < 0.1)] <- "#ffb062"
  data$COLOUR[which(data$PREDICTOR %in% c("M", "B", "MR") & data$PVAL < 0.05)] <- "#ff7f00"
  
  data$COLOUR[which(data$PREDICTOR %in% c("AD", "FS"))] <- "#d2ecd1"
  data$COLOUR[which(data$PREDICTOR %in% c("AD", "FS") & data$PVAL < 0.1)] <- "#9cd49a"
  data$COLOUR[which(data$PREDICTOR %in% c("AD", "FS") & data$PVAL < 0.05)] <- "#4daf4a"
  
  data$COLOUR[which(data$PREDICTOR %in% c("FM", "GS", "WA", "II", "NO", "GL"))] <- "#f7b8b8"
  data$COLOUR[which(data$PREDICTOR %in% c("FM", "GS", "WA", "II", "NO", "GL") & data$PVAL < 0.1)] <- "#ef7172"
  data$COLOUR[which(data$PREDICTOR %in% c("FM", "GS", "WA", "II", "NO", "GL") & data$PVAL < 0.05)] <- "#e41a1c"
  
  data$PVAL_CATEGORY <- "> 0.1"
  data$PVAL_CATEGORY[which(data$PVAL < 0.1)] <- "< 0.1"
  data$PVAL_CATEGORY[which(data$PVAL < 0.05)] <- "< 0.05"
  
  gg_fig <- ggplot(data, aes(x = PREDICTOR, y = ESTIMATE)) + 
    geom_jitter(data = filter(data, PVAL_CATEGORY == "> 0.1"), aes(col = COLOUR), size = 0.2) +
    geom_jitter(data = filter(data, PVAL_CATEGORY == "< 0.1"), aes(col = COLOUR), size = 0.2) +
    geom_jitter(data = filter(data, PVAL_CATEGORY == "< 0.05"), aes(col = COLOUR), size = 0.2) +
    
    geom_hline(yintercept = 0, col = "red", lty = 2) + 
    theme_bw() +
    theme(legend.position = "none", strip.background = element_rect(fill="skyblue"), axis.text.y = element_text(angle = 0, hjust=1), axis.title.y = element_blank()) +
    xlab("Phenotypic trait") +
    ylab("Regression coefficient") +
    facet_wrap(RESPONSE~., ncol = 2, strip.position = "top") + 
    scale_color_identity() +
    scale_x_discrete(labels=rev(c("Body mass", "Brain mass", "Metabolic rate", "% animal in diet", "% fruit, nectar and seeds in diet",
                                  "Female maturity", "Gestation length", "Weaning age", "Interbirth interval", "Number of offspring per year", "Generation length")),
                     limits = rev(levels(data$PREDICTOR))) +
    coord_flip()
  gg_fig
  
  if(oo != "All"){ #### to avoid saving the first plot as this the same as Fig. 2 in main text
    ggsave(paste0("~/", fig_names[kk], ".pdf"), gg_fig, height = 10, width = 15, unit = "cm")
    kk = kk + 1
  }
  
  #### plot for alternative model
  if((length(unique(best_evo_models_pd)) + length(unique(best_evo_models_ne))) > 2){ # there is always at most one alternative model so this should suffice if at least one of the model types has a supported alternative model
    data <- rbind(subset(full_data, RESPONSE == "Population density" & TRAIT_EVO_MODEL == alternative_evo_model_pd), subset(full_data, RESPONSE == "Effective population size" & TRAIT_EVO_MODEL == alternative_evo_model_ne))
    data$PREDICTOR <- factor(data$PREDICTOR, levels = c("M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"))
    data$RESPONSE <- factor(data$RESPONSE, levels = c("Population density", "Effective population size"))
    data$COLOUR <- "gray"
    
    data$COLOUR[which(data$PREDICTOR %in% c("M", "B", "MR"))] <- "#ffd8b1"
    data$COLOUR[which(data$PREDICTOR %in% c("M", "B", "MR") & data$PVAL < 0.1)] <- "#ffb062"
    data$COLOUR[which(data$PREDICTOR %in% c("M", "B", "MR") & data$PVAL < 0.05)] <- "#ff7f00"
    
    data$COLOUR[which(data$PREDICTOR %in% c("AD", "FS"))] <- "#d2ecd1"
    data$COLOUR[which(data$PREDICTOR %in% c("AD", "FS") & data$PVAL < 0.1)] <- "#9cd49a"
    data$COLOUR[which(data$PREDICTOR %in% c("AD", "FS") & data$PVAL < 0.05)] <- "#4daf4a"
    
    data$COLOUR[which(data$PREDICTOR %in% c("FM", "GS", "WA", "II", "NO", "GL"))] <- "#f7b8b8"
    data$COLOUR[which(data$PREDICTOR %in% c("FM", "GS", "WA", "II", "NO", "GL") & data$PVAL < 0.1)] <- "#ef7172"
    data$COLOUR[which(data$PREDICTOR %in% c("FM", "GS", "WA", "II", "NO", "GL") & data$PVAL < 0.05)] <- "#e41a1c"
    
    data$PVAL_CATEGORY <- "> 0.1"
    data$PVAL_CATEGORY[which(data$PVAL < 0.1)] <- "< 0.1"
    data$PVAL_CATEGORY[which(data$PVAL < 0.05)] <- "< 0.05"
    
    gg_fig <- ggplot(data, aes(x = PREDICTOR, y = ESTIMATE)) + 
      geom_jitter(data = filter(data, PVAL_CATEGORY == "> 0.1"), aes(col = COLOUR), size = 0.2) +
      geom_jitter(data = filter(data, PVAL_CATEGORY == "< 0.1"), aes(col = COLOUR), size = 0.2) +
      geom_jitter(data = filter(data, PVAL_CATEGORY == "< 0.05"), aes(col = COLOUR), size = 0.2) +
      
      geom_hline(yintercept = 0, col = "red", lty = 2) + 
      theme_bw() +
      theme(legend.position = "none", strip.background = element_rect(fill="skyblue"), axis.text.y = element_text(angle = 0, hjust=1), axis.title.y = element_blank()) +
      xlab("Phenotypic trait") +
      ylab("Regression coefficient") +
      facet_wrap(RESPONSE~., ncol = 2, strip.position = "top") + 
      scale_color_identity() +
      scale_x_discrete(labels=rev(c("Body mass", "Brain mass", "Metabolic rate", "% animal in diet", "% fruit, nectar and seeds in diet",
                                    "Female maturity", "Gestation length", "Weaning age", "Interbirth interval", "Number of offspring per year", "Generation length")),
                       limits = rev(levels(data$PREDICTOR))) +
      coord_flip()
    gg_fig
    
    ggsave(paste0("~/", fig_names[kk], ".pdf"), gg_fig, height = 10, width = 15, unit = "cm")
    kk = kk + 1
  }
}