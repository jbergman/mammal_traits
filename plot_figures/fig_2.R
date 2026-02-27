library(ggplot2)
library(patchwork)
library(dplyr)

################################################################################################################################################
################################################################--- FIGURE 2 ---################################################################
################################################################################################################################################

#### determine which trait evolution model is most often the most supported model across phylo trees, then plot coefficients from that model
#### population density as response
all_models <- read.table("~/supp_table_2.txt", sep = "\t", header = T)
print(dim(all_models))

all_models <- subset(all_models, p > 0.05 & WARNING == "no" & !(is.na(CICc)))
all_models <- all_models[order(all_models$CICc),]
best_evo_models <- c()
for(i in 1:1000){
  temp <- subset(all_models, PHYLO_TREE_IDX == i)
  best_evo_models <- c(best_evo_models, temp$TRAIT_EVO_MODEL[1])
}
table(best_evo_models)
most_common_evo_model = names(which(table(best_evo_models)==max(table(best_evo_models))))

data <- read.table(paste0("~/supp_table_22.txt"), sep = "\t", header = T)
data <- subset(data, TRAIT_EVO_MODEL == most_common_evo_model)
data$RESPONSE <- "Population density"

#### Ne as response
all_models <- read.table("~/supp_table_3.txt", sep = "\t", header = T)
print(dim(all_models))
all_models <- subset(all_models, p > 0.05 & WARNING == "no" & !(is.na(CICc)))
all_models <- all_models[order(all_models$CICc),]
best_evo_models <- c()
for(i in 1:1000){
  temp <- subset(all_models, PHYLO_TREE_IDX == i)
  best_evo_models <- c(best_evo_models, temp$TRAIT_EVO_MODEL[1])
}
table(best_evo_models)
most_common_evo_model = names(which(table(best_evo_models)==max(table(best_evo_models))))

temp <- read.table(paste0("~/supp_table_23.txt"), sep = "\t", header = T)
temp <- subset(temp, TRAIT_EVO_MODEL == most_common_evo_model)
temp$RESPONSE <- "Effective population size"

#### combine datasets for plotting
data <- rbind(data, temp)
data$PREDICTOR <- factor(data$PREDICTOR, levels = c("M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"))
data$RESPONSE <- factor(data$RESPONSE, levels = c("Population density", "Effective population size"))
data$COLOUR <- "gray" ## as placeholder

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

#### plot and save
p1_mean_all <- ggplot(data, aes(x = PREDICTOR, y = ESTIMATE)) + 
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
p1_mean_all

ggsave(paste0("~/fig_2.pdf"), p1_mean_all, height = 10, width = 15, unit = "cm")

