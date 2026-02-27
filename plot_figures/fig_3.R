library(ggplot2)
library(patchwork)
library(dplyr)

#### determine which trait evolution model is most often the most supported model across phylo trees, then plot coefficients from that model
#### Cetartiodactyla population density as response
all_models <- read.table("~/supp_table_4.txt", sep = "\t", header = T)
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

data <- read.table(paste0("~/supp_table_24.txt"), sep = "\t", header = T)
data <- subset(data, TRAIT_EVO_MODEL == most_common_evo_model)
data$RESPONSE <- "Population density"
data$ORDER <- "Cetartiodactyla"

#### Cetartiodactyla Ne as response
all_models <- read.table("~/supp_table_5.txt", sep = "\t", header = T)
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

temp <- read.table(paste0("~/supp_table_25.txt"), sep = "\t", header = T)
temp <- subset(temp, TRAIT_EVO_MODEL == most_common_evo_model)
temp$RESPONSE <- "Effective population size"
temp$ORDER <- "Cetartiodactyla"
data <- rbind(data, temp)

#### Primates population density as response
all_models <- read.table("~/supp_table_6.txt", sep = "\t", header = T)
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

temp <- read.table(paste0("~/supp_table_26.txt"), sep = "\t", header = T)
temp <- subset(temp, TRAIT_EVO_MODEL == most_common_evo_model)
temp$RESPONSE <- "Population density"
temp$ORDER <- "Primates"
data <- rbind(data, temp)

#### Primates Ne as response
all_models <- read.table("~/supp_table_7.txt", sep = "\t", header = T)
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

temp <- read.table(paste0("~/supp_table_27.txt"), sep = "\t", header = T)
temp <- subset(temp, TRAIT_EVO_MODEL == most_common_evo_model)
temp$RESPONSE <- "Effective population size"
temp$ORDER <- "Primates"
data <- rbind(data, temp)

#### Carnivora population density as response
all_models <- read.table("~/supp_table_8.txt", sep = "\t", header = T)
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

temp <- read.table(paste0("~/supp_table_28.txt"), sep = "\t", header = T)
temp <- subset(temp, TRAIT_EVO_MODEL == most_common_evo_model)
temp$RESPONSE <- "Population density"
temp$ORDER <- "Carnivora"
data <- rbind(data, temp)

#### Carnivora Ne as response
all_models <- read.table("~/supp_table_9.txt", sep = "\t", header = T)
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

temp <- read.table(paste0("~/supp_table_29.txt"), sep = "\t", header = T)
temp <- subset(temp, TRAIT_EVO_MODEL == most_common_evo_model)
temp$RESPONSE <- "Effective population size"
temp$ORDER <- "Carnivora"
data <- rbind(data, temp)

data$PVAL_CATEGORY <- "> 0.1"
data$PVAL_CATEGORY[which(data$PVAL < 0.1)] <- "< 0.1"
data$PVAL_CATEGORY[which(data$PVAL < 0.05)] <- "< 0.05"
data$COLOUR <- "gray"

#### plot fig_3a
s1 <- subset(data, PREDICTOR == "B" & RESPONSE == "Effective population size")
s1$ORDER <- factor(s1$ORDER, levels = c("Carnivora", "Primates", "Cetartiodactyla"))

s1$COLOUR[which(s1$ORDER == "Carnivora")] <- "#f7b8b8"
s1$COLOUR[which(s1$ORDER == "Carnivora" & s1$PVAL < 0.1)] <- "#ef7172"
s1$COLOUR[which(s1$ORDER == "Carnivora" & s1$PVAL < 0.05)] <- "#e41a1c"

s1$COLOUR[which(s1$ORDER == "Primates")] <- "#ffd8b1"
s1$COLOUR[which(s1$ORDER == "Primates" & s1$PVAL < 0.1)] <- "#ffb062"
s1$COLOUR[which(s1$ORDER == "Primates" & s1$PVAL < 0.05)] <- "#ff7f00"

s1$COLOUR[which(s1$ORDER == "Cetartiodactyla")] <- "#d2ecd1"
s1$COLOUR[which(s1$ORDER == "Cetartiodactyla" & s1$PVAL < 0.1)] <- "#9cd49a"
s1$COLOUR[which(s1$ORDER == "Cetartiodactyla" & s1$PVAL < 0.05)] <- "#4daf4a"

s1$RESPONSE2 <- "Effective size ~ B"

s1$PVAL_CATEGORY <- "> 0.1"
s1$PVAL_CATEGORY[which(s1$PVAL < 0.1)] <- "< 0.1"
s1$PVAL_CATEGORY[which(s1$PVAL < 0.05)] <- "< 0.05"

fig_3a <- ggplot(s1, aes(x = ORDER, y = ESTIMATE)) + 
  geom_jitter(data = subset(s1, PVAL_CATEGORY == "> 0.1"), aes(color = COLOUR), size = 0.2) +
  geom_jitter(data = subset(s1, PVAL_CATEGORY == "< 0.1"), aes(color = COLOUR), size = 0.2) +
  geom_jitter(data = subset(s1, PVAL_CATEGORY == "< 0.05"), aes(color = COLOUR), size = 0.2) +
  geom_hline(yintercept = 0, col = "red", lty = 2) + 
  facet_wrap(RESPONSE2 ~ ., ncol = 2, strip.position = "top") + 
  scale_color_identity() +
  scale_x_discrete(limits = c("Carnivora", "Primates", "Cetartiodactyla")) +
  coord_flip() +
  theme_bw() +
  theme( legend.position = "none", strip.background = element_rect(fill = "skyblue"), axis.title.x = element_text(size = 9), axis.title.y = element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank()) +
  xlab("Phenotypic trait") +
  ylab("Regression coefficient")

fig_3a

ggsave(paste0("~/fig_3a.pdf"), fig_3a, height = 5, width = 5, unit = "cm")

#### plot fig_3b
s2 <- subset(data, PREDICTOR == "FS" & RESPONSE == "Population density")
s2$ORDER <- factor(s2$ORDER, levels = c("Carnivora", "Primates", "Cetartiodactyla"))

s2$COLOUR[which(s2$ORDER == "Carnivora")] <- "#f7b8b8"
s2$COLOUR[which(s2$ORDER == "Carnivora" & s2$PVAL < 0.1)] <- "#ef7172"
s2$COLOUR[which(s2$ORDER == "Carnivora" & s2$PVAL < 0.05)] <- "#e41a1c"

s2$COLOUR[which(s2$ORDER == "Primates")] <- "#ffd8b1"
s2$COLOUR[which(s2$ORDER == "Primates" & s2$PVAL < 0.1)] <- "#ffb062"
s2$COLOUR[which(s2$ORDER == "Primates" & s2$PVAL < 0.05)] <- "#ff7f00"

s2$COLOUR[which(s2$ORDER == "Cetartiodactyla")] <- "#d2ecd1"
s2$COLOUR[which(s2$ORDER == "Cetartiodactyla" & s2$PVAL < 0.1)] <- "#9cd49a"
s2$COLOUR[which(s2$ORDER == "Cetartiodactyla" & s2$PVAL < 0.05)] <- "#4daf4a"

s2$RESPONSE2 <- "Population density ~ FS"

s2$PVAL_CATEGORY <- "> 0.1"
s2$PVAL_CATEGORY[which(s2$PVAL < 0.1)] <- "< 0.1"
s2$PVAL_CATEGORY[which(s2$PVAL < 0.05)] <- "< 0.05"

fig_3b <- ggplot(s2, aes(x = ORDER, y = ESTIMATE)) + 
  geom_jitter(data = subset(s2, PVAL_CATEGORY == "> 0.1"), aes(color = COLOUR), size = 0.2) +
  geom_jitter(data = subset(s2, PVAL_CATEGORY == "< 0.1"), aes(color = COLOUR), size = 0.2) +
  geom_jitter(data = subset(s2, PVAL_CATEGORY == "< 0.05"), aes(color = COLOUR), size = 0.2) +
  geom_hline(yintercept = 0, col = "red", lty = 2) + 
  facet_wrap(RESPONSE2 ~ ., ncol = 2, strip.position = "top") + 
  scale_color_identity() +
  scale_x_discrete(limits = c("Carnivora", "Primates", "Cetartiodactyla")) +
  coord_flip() +
  theme_bw() +
  theme( legend.position = "none", strip.background = element_rect(fill = "skyblue"), axis.title.x = element_text(size = 9), axis.title.y = element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank()) +
  xlab("Phenotypic trait") +
  ylab("Regression coefficient")

fig_3b

ggsave(paste0("~/fig_3b.pdf"), fig_3b, height = 5, width = 5, unit = "cm")

#### plot fig_3c
s3 <- subset(data, PREDICTOR == "FM" & RESPONSE == "Effective population size")
s3$ORDER <- factor(s3$ORDER, levels = c("Carnivora", "Primates", "Cetartiodactyla"))

s3$COLOUR[which(s3$ORDER == "Carnivora")] <- "#f7b8b8"
s3$COLOUR[which(s3$ORDER == "Carnivora" & s3$PVAL < 0.1)] <- "#ef7172"
s3$COLOUR[which(s3$ORDER == "Carnivora" & s3$PVAL < 0.05)] <- "#e41a1c"

s3$COLOUR[which(s3$ORDER == "Primates")] <- "#ffd8b1"
s3$COLOUR[which(s3$ORDER == "Primates" & s3$PVAL < 0.1)] <- "#ffb062"
s3$COLOUR[which(s3$ORDER == "Primates" & s3$PVAL < 0.05)] <- "#ff7f00"

s3$COLOUR[which(s3$ORDER == "Cetartiodactyla")] <- "#d2ecd1"
s3$COLOUR[which(s3$ORDER == "Cetartiodactyla" & s3$PVAL < 0.1)] <- "#9cd49a"
s3$COLOUR[which(s3$ORDER == "Cetartiodactyla" & s3$PVAL < 0.05)] <- "#4daf4a"

s3$RESPONSE2 <- "Effective size ~ FM"

s3$PVAL_CATEGORY <- "> 0.1"
s3$PVAL_CATEGORY[which(s3$PVAL < 0.1)] <- "< 0.1"
s3$PVAL_CATEGORY[which(s3$PVAL < 0.05)] <- "< 0.05"

fig_3c <- ggplot(s3, aes(x = ORDER, y = ESTIMATE)) + 
  geom_jitter(data = subset(s3, PVAL_CATEGORY == "> 0.1"), aes(color = COLOUR), size = 0.2) +
  geom_jitter(data = subset(s3, PVAL_CATEGORY == "< 0.1"), aes(color = COLOUR), size = 0.2) +
  geom_jitter(data = subset(s3, PVAL_CATEGORY == "< 0.05"), aes(color = COLOUR), size = 0.2) +
  geom_hline(yintercept = 0, col = "red", lty = 2) + 
  facet_wrap(RESPONSE2 ~ ., ncol = 2, strip.position = "top") + 
  scale_color_identity() +
  scale_x_discrete(limits = c("Carnivora", "Primates", "Cetartiodactyla")) +
  coord_flip() +
  theme_bw() +
  theme( legend.position = "none", strip.background = element_rect(fill = "skyblue"), axis.title.x = element_text(size = 9), axis.title.y = element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank()) +
  xlab("Phenotypic trait") +
  ylab("Regression coefficient")

fig_3c

ggsave(paste0("~/fig_3c.pdf"), fig_3c, height = 5, width = 5, unit = "cm")

#### plot fig_3d
s4 <- subset(data, PREDICTOR == "WA" & RESPONSE == "Effective population size")
s4$ORDER <- factor(s4$ORDER, levels = c("Carnivora", "Primates", "Cetartiodactyla"))

s4$COLOUR[which(s4$ORDER == "Carnivora")] <- "#f7b8b8"
s4$COLOUR[which(s4$ORDER == "Carnivora" & s4$PVAL < 0.1)] <- "#ef7172"
s4$COLOUR[which(s4$ORDER == "Carnivora" & s4$PVAL < 0.05)] <- "#e41a1c"

s4$COLOUR[which(s4$ORDER == "Primates")] <- "#ffd8b1"
s4$COLOUR[which(s4$ORDER == "Primates" & s4$PVAL < 0.1)] <- "#ffb062"
s4$COLOUR[which(s4$ORDER == "Primates" & s4$PVAL < 0.05)] <- "#ff7f00"

s4$COLOUR[which(s4$ORDER == "Cetartiodactyla")] <- "#d2ecd1"
s4$COLOUR[which(s4$ORDER == "Cetartiodactyla" & s4$PVAL < 0.1)] <- "#9cd49a"
s4$COLOUR[which(s4$ORDER == "Cetartiodactyla" & s4$PVAL < 0.05)] <- "#4daf4a"

s4$RESPONSE2 <- "Effective size ~ WA"

s4$PVAL_CATEGORY <- "> 0.1"
s4$PVAL_CATEGORY[which(s4$PVAL < 0.1)] <- "< 0.1"
s4$PVAL_CATEGORY[which(s4$PVAL < 0.05)] <- "< 0.05"

fig_3d <- ggplot(s4, aes(x = ORDER, y = ESTIMATE)) + 
  geom_jitter(data = subset(s4, PVAL_CATEGORY == "> 0.1"), aes(color = COLOUR), size = 0.2) +
  geom_jitter(data = subset(s4, PVAL_CATEGORY == "< 0.1"), aes(color = COLOUR), size = 0.2) +
  geom_jitter(data = subset(s4, PVAL_CATEGORY == "< 0.05"), aes(color = COLOUR), size = 0.2) +
  geom_hline(yintercept = 0, col = "red", lty = 2) + 
  facet_wrap(RESPONSE2 ~ ., ncol = 2, strip.position = "top") + 
  scale_color_identity() +
  scale_x_discrete(limits = c("Carnivora", "Primates", "Cetartiodactyla")) +
  coord_flip() +
  theme_bw() +
  theme( legend.position = "none", strip.background = element_rect(fill = "skyblue"), axis.title.x = element_text(size = 9), axis.title.y = element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank()) +
  xlab("Phenotypic trait") +
  ylab("Regression coefficient")

fig_3d

ggsave(paste0("~/fig_3d.pdf"), fig_3d, height = 5, width = 5, unit = "cm")

#### plot fig_3e
s5 <- subset(data, PREDICTOR == "GL" & RESPONSE == "Effective population size")
s5$ORDER <- factor(s5$ORDER, levels = c("Carnivora", "Primates", "Cetartiodactyla"))

s5$COLOUR[which(s5$ORDER == "Carnivora")] <- "#f7b8b8"
s5$COLOUR[which(s5$ORDER == "Carnivora" & s5$PVAL < 0.1)] <- "#ef7172"
s5$COLOUR[which(s5$ORDER == "Carnivora" & s5$PVAL < 0.05)] <- "#e41a1c"

s5$COLOUR[which(s5$ORDER == "Primates")] <- "#ffd8b1"
s5$COLOUR[which(s5$ORDER == "Primates" & s5$PVAL < 0.1)] <- "#ffb062"
s5$COLOUR[which(s5$ORDER == "Primates" & s5$PVAL < 0.05)] <- "#ff7f00"

s5$COLOUR[which(s5$ORDER == "Cetartiodactyla")] <- "#d2ecd1"
s5$COLOUR[which(s5$ORDER == "Cetartiodactyla" & s5$PVAL < 0.1)] <- "#9cd49a"
s5$COLOUR[which(s5$ORDER == "Cetartiodactyla" & s5$PVAL < 0.05)] <- "#4daf4a"

s5$RESPONSE2 <- "Effective size ~ GL"

s5$PVAL_CATEGORY <- "> 0.1"
s5$PVAL_CATEGORY[which(s5$PVAL < 0.1)] <- "< 0.1"
s5$PVAL_CATEGORY[which(s5$PVAL < 0.05)] <- "< 0.05"

fig_3e <- ggplot(s5, aes(x = ORDER, y = ESTIMATE)) + 
  geom_jitter(data = subset(s5, PVAL_CATEGORY == "> 0.1"), aes(color = COLOUR), size = 0.2) +
  geom_jitter(data = subset(s5, PVAL_CATEGORY == "< 0.1"), aes(color = COLOUR), size = 0.2) +
  geom_jitter(data = subset(s5, PVAL_CATEGORY == "< 0.05"), aes(color = COLOUR), size = 0.2) +
  geom_hline(yintercept = 0, col = "red", lty = 2) + 
  facet_wrap(RESPONSE2 ~ ., ncol = 2, strip.position = "top") + 
  scale_color_identity() +
  scale_x_discrete(limits = c("Carnivora", "Primates", "Cetartiodactyla")) +
  coord_flip() +
  theme_bw() +
  theme( legend.position = "none", strip.background = element_rect(fill = "skyblue"), axis.title.x = element_text(size = 9), axis.title.y = element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank()) +
  xlab("Phenotypic trait") +
  ylab("Regression coefficient")

fig_3e
ggsave(paste0("~/fig_3e.pdf"), fig_3e, height = 5, width = 5, unit = "cm")




