library(ggplot2)
library(patchwork)
library(dplyr)

#### determine which trait evolution model is most often the most supported model across phylo trees, then plot coefficients from that model
#### Population density and metabolic rate as response to adult mass for all species
all_models <- read.table("/Users/au612643/Desktop/megaFauna/data/rev/supp_tables_renamed_final/supp_table_2.txt", sep = "\t", header = T)
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

data <- read.table(paste0("/Users/au612643/Desktop/megaFauna/data/rev/supp_tables_renamed_final/supp_table_42.txt"), sep = "\t", header = T)
data <- subset(data, TRAIT_EVO_MODEL == most_common_evo_model)
data$RESPONSE <- "Population density"
data$ORDER <- "All"

temp <- read.table(paste0("/Users/au612643/Desktop/megaFauna/data/rev/supp_tables_renamed_final/supp_table_43.txt"), sep = "\t", header = T)
temp <- subset(temp, TRAIT_EVO_MODEL == most_common_evo_model)
temp$RESPONSE <- "MR"
temp$ORDER <- "All"
data <- rbind(data, temp)

#### Population density and metabolic rate as response to adult mass for Cetartiodactyla
all_models <- read.table("/Users/au612643/Desktop/megaFauna/data/rev/supp_tables_renamed_final/supp_table_4.txt", sep = "\t", header = T)
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

temp <- read.table(paste0("/Users/au612643/Desktop/megaFauna/data/rev/supp_tables_renamed_final/supp_table_44.txt"), sep = "\t", header = T)
temp <- subset(temp, TRAIT_EVO_MODEL == most_common_evo_model)
temp$RESPONSE <- "Population density"
temp$ORDER <- "Cetartiodactyla"
data <- rbind(data, temp)

temp <- read.table(paste0("/Users/au612643/Desktop/megaFauna/data/rev/supp_tables_renamed_final/supp_table_45.txt"), sep = "\t", header = T)
temp <- subset(temp, TRAIT_EVO_MODEL == most_common_evo_model)
temp$RESPONSE <- "MR"
temp$ORDER <- "Cetartiodactyla"
data <- rbind(data, temp)

#### Population density and metabolic rate as response to adult mass for Primates
all_models <- read.table("/Users/au612643/Desktop/megaFauna/data/rev/supp_tables_renamed_final/supp_table_6.txt", sep = "\t", header = T)
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

temp <- read.table(paste0("/Users/au612643/Desktop/megaFauna/data/rev/supp_tables_renamed_final/supp_table_46.txt"), sep = "\t", header = T)
temp <- subset(temp, TRAIT_EVO_MODEL == most_common_evo_model)
temp$RESPONSE <- "Population density"
temp$ORDER <- "Primates"
data <- rbind(data, temp)

temp <- read.table(paste0("/Users/au612643/Desktop/megaFauna/data/rev/supp_tables_renamed_final/supp_table_47.txt"), sep = "\t", header = T)
temp <- subset(temp, TRAIT_EVO_MODEL == most_common_evo_model)
temp$RESPONSE <- "MR"
temp$ORDER <- "Primates"
data <- rbind(data, temp)

#### Population density and metabolic rate as response to adult mass for Carnivora
all_models <- read.table("/Users/au612643/Desktop/megaFauna/data/rev/supp_tables_renamed_final/supp_table_8.txt", sep = "\t", header = T)
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

temp <- read.table(paste0("/Users/au612643/Desktop/megaFauna/data/rev/supp_tables_renamed_final/supp_table_48.txt"), sep = "\t", header = T)
temp <- subset(temp, TRAIT_EVO_MODEL == most_common_evo_model)
temp$RESPONSE <- "Population density"
temp$ORDER <- "Carnivora"
data <- rbind(data, temp)

temp <- read.table(paste0("/Users/au612643/Desktop/megaFauna/data/rev/supp_tables_renamed_final/supp_table_49.txt"), sep = "\t", header = T)
temp <- subset(temp, TRAIT_EVO_MODEL == most_common_evo_model)
temp$RESPONSE <- "MR"
temp$ORDER <- "Carnivora"
data <- rbind(data, temp)

data$PVAL_CATEGORY <- "> 0.1"
data$PVAL_CATEGORY[which(data$PVAL < 0.1)] <- "< 0.1"
data$PVAL_CATEGORY[which(data$PVAL < 0.05)] <- "< 0.05"
data$COLOUR <- "gray"

#### plot fig_6a
s1 <- subset(data, RESPONSE == "Population density")
s1$ORDER <- factor(s1$ORDER, levels = c("Carnivora", "Primates", "Cetartiodactyla", "All"))
s1$COLOUR[which(s1$ORDER == "All")] <- "#c5dcee"
s1$COLOUR[which(s1$ORDER == "All" & s1$PVAL < 0.1)] <- "#89b7dc"
s1$COLOUR[which(s1$ORDER == "All" & s1$PVAL < 0.05)] <- "#377eb8"

s1$COLOUR[which(s1$ORDER == "Carnivora")] <- "#f7a8b8"
s1$COLOUR[which(s1$ORDER == "Carnivora" & s1$PVAL < 0.1)] <- "#ef7172"
s1$COLOUR[which(s1$ORDER == "Carnivora" & s1$PVAL < 0.05)] <- "#e41a1c"

s1$COLOUR[which(s1$ORDER == "Primates")] <- "#ffd8b1"
s1$COLOUR[which(s1$ORDER == "Primates" & s1$PVAL < 0.1)] <- "#ffb062"
s1$COLOUR[which(s1$ORDER == "Primates" & s1$PVAL < 0.05)] <- "#ff7f00"

s1$COLOUR[which(s1$ORDER == "Cetartiodactyla")] <- "#d2ecd1"
s1$COLOUR[which(s1$ORDER == "Cetartiodactyla" & s1$PVAL < 0.1)] <- "#9cd49a"
s1$COLOUR[which(s1$ORDER == "Cetartiodactyla" & s1$PVAL < 0.05)] <- "#4daf4a"

s1$RESPONSE2 <- "Population density ~ M"

s1$PVAL_CATEGORY <- "> 0.1"
s1$PVAL_CATEGORY[which(s1$PVAL < 0.1)] <- "< 0.1"
s1$PVAL_CATEGORY[which(s1$PVAL < 0.05)] <- "< 0.05"

fig_6a <- ggplot(s1, aes(x = ORDER, y = ESTIMATE)) + 
  geom_jitter(data = subset(s1, PVAL_CATEGORY == "> 0.1"), aes(color = COLOUR), size = 0.2) +
  geom_jitter(data = subset(s1, PVAL_CATEGORY == "< 0.1"), aes(color = COLOUR), size = 0.2) +
  geom_jitter(data = subset(s1, PVAL_CATEGORY == "< 0.05"), aes(color = COLOUR), size = 0.2) +
  geom_hline(yintercept = 0, col = "red", lty = 2) + 
  geom_hline(yintercept =- 0.75, col = "red", lty = 3) +
  facet_wrap(RESPONSE2 ~ ., ncol = 2, strip.position = "top") + 
  scale_color_identity() +
  scale_x_discrete(limits = c("Carnivora", "Primates", "Cetartiodactyla", "All")) +
  coord_flip() +
  theme_bw() +
  theme( legend.position = "none", strip.background = element_rect(fill = "skyblue"), axis.title.x = element_text(size = 9), axis.title.y = element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank()) +
  xlab("Phenotypic trait") +
  ylab("Regression coefficient")

fig_6a

ggsave(paste0("~/fig_6a.pdf"), fig_7a, height = 5, width = 5, unit = "cm")

#### plot fig_6b
s1 <- subset(data, RESPONSE == "MR")
s1$ORDER <- factor(s1$ORDER, levels = c("Carnivora", "Primates", "Cetartiodactyla", "All"))
s1$COLOUR[which(s1$ORDER == "All")] <- "#c5dcee"
s1$COLOUR[which(s1$ORDER == "All" & s1$PVAL < 0.1)] <- "#89b7dc"
s1$COLOUR[which(s1$ORDER == "All" & s1$PVAL < 0.05)] <- "#377eb8"

s1$COLOUR[which(s1$ORDER == "Carnivora")] <- "#f7b8b8"
s1$COLOUR[which(s1$ORDER == "Carnivora" & s1$PVAL < 0.1)] <- "#ef7172"
s1$COLOUR[which(s1$ORDER == "Carnivora" & s1$PVAL < 0.05)] <- "#e41a1c"

s1$COLOUR[which(s1$ORDER == "Primates")] <- "#ffd8b1"
s1$COLOUR[which(s1$ORDER == "Primates" & s1$PVAL < 0.1)] <- "#ffb062"
s1$COLOUR[which(s1$ORDER == "Primates" & s1$PVAL < 0.05)] <- "#ff7f00"

s1$COLOUR[which(s1$ORDER == "Cetartiodactyla")] <- "#d2ecd1"
s1$COLOUR[which(s1$ORDER == "Cetartiodactyla" & s1$PVAL < 0.1)] <- "#9cd49a"
s1$COLOUR[which(s1$ORDER == "Cetartiodactyla" & s1$PVAL < 0.05)] <- "#4daf4a"

s1$RESPONSE2 <- "MR ~ M"

s1$PVAL_CATEGORY <- "> 0.1"
s1$PVAL_CATEGORY[which(s1$PVAL < 0.1)] <- "< 0.1"
s1$PVAL_CATEGORY[which(s1$PVAL < 0.05)] <- "< 0.05"

fig_6b <- ggplot(s1, aes(x = ORDER, y = ESTIMATE)) + 
  geom_jitter(data = subset(s1, PVAL_CATEGORY == "> 0.1"), aes(color = COLOUR), size = 0.2) +
  geom_jitter(data = subset(s1, PVAL_CATEGORY == "< 0.1"), aes(color = COLOUR), size = 0.2) +
  geom_jitter(data = subset(s1, PVAL_CATEGORY == "< 0.05"), aes(color = COLOUR), size = 0.2) +
  geom_hline(yintercept = 0, col = "red", lty = 2) + 
  geom_hline(yintercept = 0.75, col = "red", lty = 3) +
  facet_wrap(RESPONSE2 ~ ., ncol = 2, strip.position = "top") + 
  scale_color_identity() +
  scale_x_discrete(limits = c("Carnivora", "Primates", "Cetartiodactyla", "All")) +
  coord_flip() +
  theme_bw() +
  theme( legend.position = "none", strip.background = element_rect(fill = "skyblue"), axis.title.x = element_text(size = 9), axis.title.y = element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank()) +
  xlab("Phenotypic trait") +
  ylab("Regression coefficient")

fig_6b

ggsave(paste0("~/fig_6b.pdf"), fig_7b, height = 5, width = 5, unit = "cm")
