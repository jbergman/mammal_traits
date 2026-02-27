library(ggplot2)
library(patchwork)
library(dplyr)

#### determine which trait evolution model is most often the most supported model across phylo trees, then plot coefficients from that model
#### Herbivore population density as response
all_models <- read.table("~/supp_table_10.txt", sep = "\t", header = T)
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

data <- read.table(paste0("~/supp_table_30.txt"), sep = "\t", header = T)
data <- subset(data, TRAIT_EVO_MODEL == most_common_evo_model)
data$RESPONSE <- "Population density"
data$ORDER <- "Herbivore"

#### Herbivore Ne as response
all_models <- read.table("~/supp_table_11.txt", sep = "\t", header = T)
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

temp <- read.table(paste0("~/supp_table_31.txt"), sep = "\t", header = T)
temp <- subset(temp, TRAIT_EVO_MODEL == most_common_evo_model)
temp$RESPONSE <- "Effective population size"
temp$ORDER <- "Herbivore"
data <- rbind(data, temp)

#### Omnivore population density as response
all_models <- read.table("~/supp_table_12.txt", sep = "\t", header = T)
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

temp <- read.table(paste0("~/supp_table_32.txt"), sep = "\t", header = T)
temp <- subset(temp, TRAIT_EVO_MODEL == most_common_evo_model)
temp$RESPONSE <- "Population density"
temp$ORDER <- "Omnivore"
data <- rbind(data, temp)

#### Omnivore Ne as response
all_models <- read.table("~/supp_table_13.txt", sep = "\t", header = T)
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

temp <- read.table(paste0("~/supp_table_33.txt"), sep = "\t", header = T)
temp <- subset(data, TRAIT_EVO_MODEL == most_common_evo_model)
temp$RESPONSE <- "Effective population size"
temp$ORDER <- "Omnivore"
data <- rbind(data, temp)

#### Carnivore population density as response
all_models <- read.table("~/supp_table_14.txt", sep = "\t", header = T)
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

temp <- read.table(paste0("~/supp_table_34.txt"), sep = "\t", header = T)
temp <- subset(temp, TRAIT_EVO_MODEL == most_common_evo_model)
temp$RESPONSE <- "Population density"
temp$ORDER <- "Carnivore"
data <- rbind(data, temp)

#### Carnivore Ne as response
all_models <- read.table("~/supp_table_15.txt", sep = "\t", header = T)
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

temp <- read.table(paste0("~/supp_table_35.txt"), sep = "\t", header = T)
temp <- subset(temp, TRAIT_EVO_MODEL == most_common_evo_model)
temp$RESPONSE <- "Effective population size"
temp$ORDER <- "Carnivore"
data <- rbind(data, temp)

data$PREDICTOR <- factor(data$PREDICTOR, levels = c("M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"))
data$RESPONSE <- factor(data$RESPONSE, levels = c("Population density", "Effective population size"))
data$COLOUR <- "gray"

#### plot fig_4a
s1 <- subset(data, PREDICTOR == "AD" & RESPONSE == "Population density")
s1$ORDER <- factor(s1$ORDER, levels = c("Carnivore", "Omnivore", "Herbivore"))
s1$COLOUR[which(s1$ORDER == "Carnivore")] <- "#f7b8b8"
s1$COLOUR[which(s1$ORDER == "Carnivore" & s1$PVAL < 0.1)] <- "#ef7172"
s1$COLOUR[which(s1$ORDER == "Carnivore" & s1$PVAL < 0.05)] <- "#e41a1c"

s1$COLOUR[which(s1$ORDER == "Omnivore")] <- "#ffd8b1"
s1$COLOUR[which(s1$ORDER == "Omnivore" & s1$PVAL < 0.1)] <- "#ffb062"
s1$COLOUR[which(s1$ORDER == "Omnivore" & s1$PVAL < 0.05)] <- "#ff7f00"

s1$COLOUR[which(s1$ORDER == "Herbivore")] <- "#d2ecd1"
s1$COLOUR[which(s1$ORDER == "Herbivore" & s1$PVAL < 0.1)] <- "#9cd49a"
s1$COLOUR[which(s1$ORDER == "Herbivore" & s1$PVAL < 0.05)] <- "#4daf4a"

s1$RESPONSE2 <- "Population density ~ AD"

s1$PVAL_CATEGORY <- "> 0.1"
s1$PVAL_CATEGORY[which(s1$PVAL < 0.1)] <- "< 0.1"
s1$PVAL_CATEGORY[which(s1$PVAL < 0.05)] <- "< 0.05"

fig_4a <- ggplot(s1, aes(x = ORDER, y = ESTIMATE)) + 
  geom_jitter(data = filter(s1, PVAL_CATEGORY == "> 0.1"), aes(col = COLOUR), size = 0.2) +
  geom_jitter(data = filter(s1, PVAL_CATEGORY == "< 0.1"), aes(col = COLOUR), size = 0.2) +
  geom_jitter(data = filter(s1, PVAL_CATEGORY == "< 0.05"), aes(col = COLOUR), size = 0.2) +
  geom_hline(yintercept = 0, col = "red", lty = 2) + 
  theme_bw() +
  theme(legend.position = "none", strip.background = element_rect(fill="skyblue"), axis.text.y = element_blank(), axis.title.y = element_blank(), axis.ticks = element_blank()) +
  xlab("Phenotypic trait") +
  ylab("Regression coefficient") +
  facet_wrap(RESPONSE2~., ncol = 2, strip.position = "top") + 
  scale_color_identity() +
  coord_flip()
fig_4a

ggsave(paste0("~/fig_4a.pdf"), fig_4a, height = 5, width = 10, unit = "cm")

#### plot fig_4b
s2 <- subset(data, PREDICTOR == "FS" & RESPONSE == "Population density")
s2$ORDER <- factor(s2$ORDER, levels = c("Carnivore", "Omnivore", "Herbivore"))
s2$COLOUR[which(s2$ORDER == "Carnivore")] <- "#f7b8b8"
s2$COLOUR[which(s2$ORDER == "Carnivore" & s2$PVAL < 0.1)] <- "#ef7172"
s2$COLOUR[which(s2$ORDER == "Carnivore" & s2$PVAL < 0.05)] <- "#e41a1c"

s2$COLOUR[which(s2$ORDER == "Omnivore")] <- "#ffd8b1"
s2$COLOUR[which(s2$ORDER == "Omnivore" & s2$PVAL < 0.1)] <- "#ffb062"
s2$COLOUR[which(s2$ORDER == "Omnivore" & s2$PVAL < 0.05)] <- "#ff7f00"

s2$COLOUR[which(s2$ORDER == "Herbivore")] <- "#d2ecd1"
s2$COLOUR[which(s2$ORDER == "Herbivore" & s2$PVAL < 0.1)] <- "#9cd49a"
s2$COLOUR[which(s2$ORDER == "Herbivore" & s2$PVAL < 0.05)] <- "#4daf4a"

s2$PVAL_CATEGORY <- "> 0.1"
s2$PVAL_CATEGORY[which(s2$PVAL < 0.1)] <- "< 0.1"
s2$PVAL_CATEGORY[which(s2$PVAL < 0.05)] <- "< 0.05"

s2$RESPONSE2 <- "Population density ~ FS"

fig_4b <- ggplot(s2, aes(x = ORDER, y = ESTIMATE)) + 
  geom_jitter(data = filter(s2, PVAL_CATEGORY == "> 0.1"), aes(col = COLOUR), size = 0.2) +
  geom_jitter(data = filter(s2, PVAL_CATEGORY == "< 0.1"), aes(col = COLOUR), size = 0.2) +
  geom_jitter(data = filter(s2, PVAL_CATEGORY == "< 0.05"), aes(col = COLOUR), size = 0.2) +
  geom_hline(yintercept = 0, col = "red", lty = 2) + 
  theme_bw() +
  theme(legend.position = "none", strip.background = element_rect(fill="skyblue"), axis.text.y = element_blank(), axis.title.y = element_blank(), axis.ticks = element_blank()) +
  xlab("Phenotypic trait") +
  ylab("Regression coefficient") +
  facet_wrap(RESPONSE2~., ncol = 2, strip.position = "top") + 
  scale_color_identity() +
  coord_flip()
fig_4b

ggsave(paste0("~/fig_4b.pdf"), fig_4b, height = 5, width = 10, unit = "cm")

