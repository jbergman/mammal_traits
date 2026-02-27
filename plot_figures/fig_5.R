library(ggplot2)
library(patchwork)
library(dplyr)

#### determine which trait evolution model is most often the most supported model across phylo trees, then plot coefficients from that model
#### Cold population density as response
all_models <- read.table("/Users/au612643/Desktop/megaFauna/data/rev/supp_tables_renamed_final/supp_table_16.txt", sep = "\t", header = T)
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

data <- read.table(paste0("/Users/au612643/Desktop/megaFauna/data/rev/supp_tables_renamed_final/supp_table_36.txt"), sep = "\t", header = T)
data <- subset(data, TRAIT_EVO_MODEL == most_common_evo_model)
data$RESPONSE <- "Population density"
data$ORDER <- "Cold"

#### Cold Ne as response
all_models <- read.table("/Users/au612643/Desktop/megaFauna/data/rev/supp_tables_renamed_final/supp_table_17.txt", sep = "\t", header = T)
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

temp <- read.table(paste0("/Users/au612643/Desktop/megaFauna/data/rev/supp_tables_renamed_final/supp_table_37.txt"), sep = "\t", header = T)
temp <- subset(temp, TRAIT_EVO_MODEL == most_common_evo_model)
temp$RESPONSE <- "Effective population size"
temp$ORDER <- "Cold"
data <- rbind(data, temp)

#### Arid population density as response
all_models <- read.table("/Users/au612643/Desktop/megaFauna/data/rev/supp_tables_renamed_final/supp_table_18.txt", sep = "\t", header = T)
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

temp <- read.table(paste0("/Users/au612643/Desktop/megaFauna/data/rev/supp_tables_renamed_final/supp_table_38.txt"), sep = "\t", header = T)
temp <- subset(temp, TRAIT_EVO_MODEL == most_common_evo_model)
temp$RESPONSE <- "Population density"
temp$ORDER <- "Arid"
data <- rbind(data, temp)

#### Arid Ne as response
all_models <- read.table("/Users/au612643/Desktop/megaFauna/data/rev/supp_tables_renamed_final/supp_table_19.txt", sep = "\t", header = T)
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

temp <- read.table(paste0("/Users/au612643/Desktop/megaFauna/data/rev/supp_tables_renamed_final/supp_table_39.txt"), sep = "\t", header = T)
temp <- subset(temp, TRAIT_EVO_MODEL == most_common_evo_model)
temp$RESPONSE <- "Effective population size"
temp$ORDER <- "Arid"
data <- rbind(data, temp)

#### Tropical population density as response
all_models <- read.table("/Users/au612643/Desktop/megaFauna/data/rev/supp_tables_renamed_final/supp_table_20.txt", sep = "\t", header = T)
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

temp <- read.table(paste0("/Users/au612643/Desktop/megaFauna/data/rev/supp_tables_renamed_final/supp_table_40.txt"), sep = "\t", header = T)
temp <- subset(temp, TRAIT_EVO_MODEL == most_common_evo_model)
temp$RESPONSE <- "Population density"
temp$ORDER <- "Tropical"
data <- rbind(data, temp)

#### Tropical Ne as response
all_models <- read.table("/Users/au612643/Desktop/megaFauna/data/rev/supp_tables_renamed_final/supp_table_21.txt", sep = "\t", header = T)
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

temp <- read.table(paste0("/Users/au612643/Desktop/megaFauna/data/rev/supp_tables_renamed_final/supp_table_41.txt"), sep = "\t", header = T)
temp <- subset(temp, TRAIT_EVO_MODEL == most_common_evo_model)
temp$RESPONSE <- "Effective population size"
temp$ORDER <- "Tropical"
data <- rbind(data, temp)

data$PVAL_CATEGORY <- "> 0.1"
data$PVAL_CATEGORY[which(data$PVAL < 0.1)] <- "< 0.1"
data$PVAL_CATEGORY[which(data$PVAL < 0.05)] <- "< 0.05"
data$COLOUR <- "gray"

#### plot fig_5a
s1 <- subset(data, PREDICTOR == "M" & RESPONSE == "Effective population size")
s1$ORDER <- factor(s1$ORDER, levels = c("Tropical", "Arid", "Cold"))

s1$COLOUR[which(s1$ORDER == "Tropical")] <- "#f7b8b8"
s1$COLOUR[which(s1$ORDER == "Tropical" & s1$PVAL < 0.1)] <- "#ef7172"
s1$COLOUR[which(s1$ORDER == "Tropical" & s1$PVAL < 0.05)] <- "#e41a1c"

s1$COLOUR[which(s1$ORDER == "Arid")] <- "#ffd8b1"
s1$COLOUR[which(s1$ORDER == "Arid" & s1$PVAL < 0.1)] <- "#ffb062"
s1$COLOUR[which(s1$ORDER == "Arid" & s1$PVAL < 0.05)] <- "#ff7f00"

s1$COLOUR[which(s1$ORDER == "Cold")] <- "#d2ecd1"
s1$COLOUR[which(s1$ORDER == "Cold" & s1$PVAL < 0.1)] <- "#9cd49a"
s1$COLOUR[which(s1$ORDER == "Cold" & s1$PVAL < 0.05)] <- "#4daf5a"

s1$RESPONSE2 <- "Effective size ~ M"

s1$PVAL_CATEGORY <- "> 0.1"
s1$PVAL_CATEGORY[which(s1$PVAL < 0.1)] <- "< 0.1"
s1$PVAL_CATEGORY[which(s1$PVAL < 0.05)] <- "< 0.05"

fig_5a <- ggplot(s1, aes(x = ORDER, y = ESTIMATE)) + 
  geom_jitter(data = subset(s1, PVAL_CATEGORY == "> 0.1"), aes(color = COLOUR), size = 0.2) +
  geom_jitter(data = subset(s1, PVAL_CATEGORY == "< 0.1"), aes(color = COLOUR), size = 0.2) +
  geom_jitter(data = subset(s1, PVAL_CATEGORY == "< 0.05"), aes(color = COLOUR), size = 0.2) +
  geom_hline(yintercept = 0, col = "red", lty = 2) + 
  facet_wrap(RESPONSE2 ~ ., ncol = 2, strip.position = "top") + 
  scale_color_identity() +
  scale_x_discrete(limits = c("Tropical",  "Arid", "Cold")) +
  coord_flip() +
  theme_bw() +
  theme( legend.position = "none", strip.background = element_rect(fill = "skyblue"), axis.title.x = element_text(size = 9), axis.title.y = element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank()) +
  xlab("Phenotypic trait") +
  ylab("Regression coefficient")

fig_5a

ggsave(paste0("~/fig_5a.pdf"), fig_5a, height = 5, width = 5, unit = "cm")

#### plot fig_5b
s2 <- subset(data, PREDICTOR == "FS" & RESPONSE == "Population density")
s2$ORDER <- factor(s2$ORDER, levels = c("Tropical", "Arid", "Cold"))

s2$COLOUR[which(s2$ORDER == "Tropical")] <- "#f7b8b8"
s2$COLOUR[which(s2$ORDER == "Tropical" & s2$PVAL < 0.1)] <- "#ef7172"
s2$COLOUR[which(s2$ORDER == "Tropical" & s2$PVAL < 0.05)] <- "#e41a1c"

s2$COLOUR[which(s2$ORDER == "Arid")] <- "#ffd8b1"
s2$COLOUR[which(s2$ORDER == "Arid" & s2$PVAL < 0.1)] <- "#ffb062"
s2$COLOUR[which(s2$ORDER == "Arid" & s2$PVAL < 0.05)] <- "#ff7f00"

s2$COLOUR[which(s2$ORDER == "Cold")] <- "#d2ecd1"
s2$COLOUR[which(s2$ORDER == "Cold" & s2$PVAL < 0.1)] <- "#9cd49a"
s2$COLOUR[which(s2$ORDER == "Cold" & s2$PVAL < 0.05)] <- "#4daf5b"

s2$RESPONSE2 <- "Population density ~ FS"

s2$PVAL_CATEGORY <- "> 0.1"
s2$PVAL_CATEGORY[which(s2$PVAL < 0.1)] <- "< 0.1"
s2$PVAL_CATEGORY[which(s2$PVAL < 0.05)] <- "< 0.05"

fig_5b <- ggplot(s2, aes(x = ORDER, y = ESTIMATE)) + 
  geom_jitter(data = subset(s2, PVAL_CATEGORY == "> 0.1"), aes(color = COLOUR), size = 0.2) +
  geom_jitter(data = subset(s2, PVAL_CATEGORY == "< 0.1"), aes(color = COLOUR), size = 0.2) +
  geom_jitter(data = subset(s2, PVAL_CATEGORY == "< 0.05"), aes(color = COLOUR), size = 0.2) +
  geom_hline(yintercept = 0, col = "red", lty = 2) + 
  facet_wrap(RESPONSE2 ~ ., ncol = 2, strip.position = "top") + 
  scale_color_identity() +
  scale_x_discrete(limits = c("Tropical",  "Arid", "Cold")) +
  coord_flip() +
  theme_bw() +
  theme( legend.position = "none", strip.background = element_rect(fill = "skyblue"), axis.title.x = element_text(size = 9), axis.title.y = element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank()) +
  xlab("Phenotypic trait") +
  ylab("Regression coefficient")

fig_5b

ggsave(paste0("~/fig_5b.pdf"), fig_5b, height = 5, width = 5, unit = "cm")

#### plot fig_5c
s3 <- subset(data, PREDICTOR == "AD" & RESPONSE == "Effective population size")
s3$ORDER <- factor(s3$ORDER, levels = c("Tropical", "Arid", "Cold"))

s3$COLOUR[which(s3$ORDER == "Tropical")] <- "#f7b8b8"
s3$COLOUR[which(s3$ORDER == "Tropical" & s3$PVAL < 0.1)] <- "#ef7172"
s3$COLOUR[which(s3$ORDER == "Tropical" & s3$PVAL < 0.05)] <- "#e41a1c"

s3$COLOUR[which(s3$ORDER == "Arid")] <- "#ffd8b1"
s3$COLOUR[which(s3$ORDER == "Arid" & s3$PVAL < 0.1)] <- "#ffb062"
s3$COLOUR[which(s3$ORDER == "Arid" & s3$PVAL < 0.05)] <- "#ff7f00"

s3$COLOUR[which(s3$ORDER == "Cold")] <- "#d2ecd1"
s3$COLOUR[which(s3$ORDER == "Cold" & s3$PVAL < 0.1)] <- "#9cd49a"
s3$COLOUR[which(s3$ORDER == "Cold" & s3$PVAL < 0.05)] <- "#4daf5c"

s3$RESPONSE2 <- "Effective size ~ AD"

s3$PVAL_CATEGORY <- "> 0.1"
s3$PVAL_CATEGORY[which(s3$PVAL < 0.1)] <- "< 0.1"
s3$PVAL_CATEGORY[which(s3$PVAL < 0.05)] <- "< 0.05"

fig_5c <- ggplot(s3, aes(x = ORDER, y = ESTIMATE)) + 
  geom_jitter(data = subset(s3, PVAL_CATEGORY == "> 0.1"), aes(color = COLOUR), size = 0.2) +
  geom_jitter(data = subset(s3, PVAL_CATEGORY == "< 0.1"), aes(color = COLOUR), size = 0.2) +
  geom_jitter(data = subset(s3, PVAL_CATEGORY == "< 0.05"), aes(color = COLOUR), size = 0.2) +
  geom_hline(yintercept = 0, col = "red", lty = 2) + 
  facet_wrap(RESPONSE2 ~ ., ncol = 2, strip.position = "top") + 
  scale_color_identity() +
  scale_x_discrete(limits = c("Tropical",  "Arid", "Cold")) +
  coord_flip() +
  theme_bw() +
  theme( legend.position = "none", strip.background = element_rect(fill = "skyblue"), axis.title.x = element_text(size = 9), axis.title.y = element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank()) +
  xlab("Phenotypic trait") +
  ylab("Regression coefficient")

fig_5c

ggsave(paste0("~/fig_5c.pdf"), fig_5c, height = 5, width = 5, unit = "cm")

#### plot fig_5d
s4 <- subset(data, PREDICTOR == "WA" & RESPONSE == "Effective population size")
s4$ORDER <- factor(s4$ORDER, levels = c("Tropical", "Arid", "Cold"))

s4$COLOUR[which(s4$ORDER == "Tropical")] <- "#f7b8b8"
s4$COLOUR[which(s4$ORDER == "Tropical" & s4$PVAL < 0.1)] <- "#ef7172"
s4$COLOUR[which(s4$ORDER == "Tropical" & s4$PVAL < 0.05)] <- "#e41a1c"

s4$COLOUR[which(s4$ORDER == "Arid")] <- "#ffd8b1"
s4$COLOUR[which(s4$ORDER == "Arid" & s4$PVAL < 0.1)] <- "#ffb062"
s4$COLOUR[which(s4$ORDER == "Arid" & s4$PVAL < 0.05)] <- "#ff7f00"

s4$COLOUR[which(s4$ORDER == "Cold")] <- "#d2ecd1"
s4$COLOUR[which(s4$ORDER == "Cold" & s4$PVAL < 0.1)] <- "#9cd49a"
s4$COLOUR[which(s4$ORDER == "Cold" & s4$PVAL < 0.05)] <- "#4daf5d"

s4$RESPONSE2 <- "Effective size ~ WA"

s4$PVAL_CATEGORY <- "> 0.1"
s4$PVAL_CATEGORY[which(s4$PVAL < 0.1)] <- "< 0.1"
s4$PVAL_CATEGORY[which(s4$PVAL < 0.05)] <- "< 0.05"

fig_5d <- ggplot(s4, aes(x = ORDER, y = ESTIMATE)) + 
  geom_jitter(data = subset(s4, PVAL_CATEGORY == "> 0.1"), aes(color = COLOUR), size = 0.2) +
  geom_jitter(data = subset(s4, PVAL_CATEGORY == "< 0.1"), aes(color = COLOUR), size = 0.2) +
  geom_jitter(data = subset(s4, PVAL_CATEGORY == "< 0.05"), aes(color = COLOUR), size = 0.2) +
  geom_hline(yintercept = 0, col = "red", lty = 2) + 
  facet_wrap(RESPONSE2 ~ ., ncol = 2, strip.position = "top") + 
  scale_color_identity() +
  scale_x_discrete(limits = c("Tropical",  "Arid", "Cold")) +
  coord_flip() +
  theme_bw() +
  theme( legend.position = "none", strip.background = element_rect(fill = "skyblue"), axis.title.x = element_text(size = 9), axis.title.y = element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank()) +
  xlab("Phenotypic trait") +
  ylab("Regression coefficient")

fig_5d

ggsave(paste0("~/fig_5d.pdf"), fig_5d, height = 5, width = 5, unit = "cm")

#### plot fig_5e
s5 <- subset(data, PREDICTOR == "II" & RESPONSE == "Effective population size")
s5$ORDER <- factor(s5$ORDER, levels = c("Tropical", "Arid", "Cold"))

s5$COLOUR[which(s5$ORDER == "Tropical")] <- "#f7b8b8"
s5$COLOUR[which(s5$ORDER == "Tropical" & s5$PVAL < 0.1)] <- "#ef7172"
s5$COLOUR[which(s5$ORDER == "Tropical" & s5$PVAL < 0.05)] <- "#e41a1c"

s5$COLOUR[which(s5$ORDER == "Arid")] <- "#ffd8b1"
s5$COLOUR[which(s5$ORDER == "Arid" & s5$PVAL < 0.1)] <- "#ffb062"
s5$COLOUR[which(s5$ORDER == "Arid" & s5$PVAL < 0.05)] <- "#ff7f00"

s5$COLOUR[which(s5$ORDER == "Cold")] <- "#d2ecd1"
s5$COLOUR[which(s5$ORDER == "Cold" & s5$PVAL < 0.1)] <- "#9cd49a"
s5$COLOUR[which(s5$ORDER == "Cold" & s5$PVAL < 0.05)] <- "#4daf5e"

s5$RESPONSE2 <- "Effective size ~ II"

s5$PVAL_CATEGORY <- "> 0.1"
s5$PVAL_CATEGORY[which(s5$PVAL < 0.1)] <- "< 0.1"
s5$PVAL_CATEGORY[which(s5$PVAL < 0.05)] <- "< 0.05"

fig_5e <- ggplot(s5, aes(x = ORDER, y = ESTIMATE)) + 
  geom_jitter(data = subset(s5, PVAL_CATEGORY == "> 0.1"), aes(color = COLOUR), size = 0.2) +
  geom_jitter(data = subset(s5, PVAL_CATEGORY == "< 0.1"), aes(color = COLOUR), size = 0.2) +
  geom_jitter(data = subset(s5, PVAL_CATEGORY == "< 0.05"), aes(color = COLOUR), size = 0.2) +
  geom_hline(yintercept = 0, col = "red", lty = 2) + 
  facet_wrap(RESPONSE2 ~ ., ncol = 2, strip.position = "top") + 
  scale_color_identity() +
  scale_x_discrete(limits = c("Tropical",  "Arid", "Cold")) +
  coord_flip() +
  theme_bw() +
  theme( legend.position = "none", strip.background = element_rect(fill = "skyblue"), axis.title.x = element_text(size = 9), axis.title.y = element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank()) +
  xlab("Phenotypic trait") +
  ylab("Regression coefficient")

fig_5e

ggsave(paste0("~/fig_5e.pdf"), fig_5e, height = 5, width = 5, unit = "cm")
