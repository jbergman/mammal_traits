#### load data
data_full <- read.table("~/supp_table_1.txt", sep = "\t", header = T)

#### make All and order-specific datasets
for(oo in c("All", "Cetartiodactyla", "Carnivora", "Primates")){
  if(oo != "All"){
    data_pre <- subset(data_full, Population.density != "NA" & Order.1.2 == oo)
    species_data <- data_pre$Binomial.1.2
    data <- data.frame(N = (log10(as.numeric(data_pre$Population.density))), MR = (log10(data_pre$MR.kJ.day)),
                       B = (log10(data_pre$B.gram)), M = (log10(data_pre$M.gram)),
                       AD = (asin(sqrt(data_pre$AD.percentage/100))),
                       FS = (asin(sqrt(data_pre$FS.percentage/100))),
                       FM = (log10(data_pre$FM.days)), GS = (log10(data_pre$GS.days)),
                       II = (log10(data_pre$II.days)), WA = (log10(data_pre$WA.days)),
                       NO = (log10(data_pre$NO.count)), GL = (log10(data_pre$GL.days)))
    rownames(data) <- species_data
    data <- scale(data)
    data <- cbind(Species = species_data, data)
    write.table(data, paste0("~/datasets/dataset_", oo,"_pop_density.txt"), sep = "\t", row.names = FALSE, quote = FALSE)
    
    data_pre <- subset(data_full, Order.1.2 == oo)
    species_data <- data_pre$Binomial.1.2
    data <- data.frame(N = (log10(as.numeric(data_pre$Effective.size))), MR = (log10(data_pre$MR.kJ.day)),
                       B = (log10(data_pre$B.gram)), M = (log10(data_pre$M.gram)),
                       AD = (asin(sqrt(data_pre$AD.percentage/100))),
                       FS = (asin(sqrt(data_pre$FS.percentage/100))),
                       FM = (log10(data_pre$FM.days)), GS = (log10(data_pre$GS.days)),
                       II = (log10(data_pre$II.days)), WA = (log10(data_pre$WA.days)),
                       NO = (log10(data_pre$NO.count)), GL = (log10(data_pre$GL.days)))
    rownames(data) <- species_data
    data <- scale(data)
    data <- cbind(Species = species_data, data)
    write.table(data, paste0("~/datasets/dataset_", oo,"_ne_100_800kya.txt"), sep = "\t", row.names = FALSE, quote = FALSE)
  }else{
    data_pre <- subset(data_full, Population.density != "NA")
    species_data <- data_pre$Binomial.1.2
    data <- data.frame(N = (log10(as.numeric(data_pre$Population.density))), MR = (log10(data_pre$MR.kJ.day)),
                       B = (log10(data_pre$B.gram)), M = (log10(data_pre$M.gram)),
                       AD = (asin(sqrt(data_pre$AD.percentage/100))),
                       FS = (asin(sqrt(data_pre$FS.percentage/100))),
                       FM = (log10(data_pre$FM.days)), GS = (log10(data_pre$GS.days)),
                       II = (log10(data_pre$II.days)), WA = (log10(data_pre$WA.days)),
                       NO = (log10(data_pre$NO.count)), GL = (log10(data_pre$GL.days)))
    rownames(data) <- species_data
    data <- scale(data)
    data <- cbind(Species = species_data, data)
    write.table(data, paste0("~/datasets/dataset_", oo,"_pop_density.txt"), sep = "\t", row.names = FALSE, quote = FALSE)
    
    data_pre <- subset(data_full)
    species_data <- data_pre$Binomial.1.2
    data <- data.frame(N = (log10(as.numeric(data_pre$Effective.size))), MR = (log10(data_pre$MR.kJ.day)),
                       B = (log10(data_pre$B.gram)), M = (log10(data_pre$M.gram)),
                       AD = (asin(sqrt(data_pre$AD.percentage/100))),
                       FS = (asin(sqrt(data_pre$FS.percentage/100))),
                       FM = (log10(data_pre$FM.days)), GS = (log10(data_pre$GS.days)),
                       II = (log10(data_pre$II.days)), WA = (log10(data_pre$WA.days)),
                       NO = (log10(data_pre$NO.count)), GL = (log10(data_pre$GL.days)))
    rownames(data) <- species_data
    data <- scale(data)
    data <- cbind(Species = species_data, data)
    write.table(data, paste0("~/datasets/dataset_", oo,"_ne_100_800kya.txt"), sep = "\t", row.names = FALSE, quote = FALSE)
  }
}

#### make trophic level datasets
for(oo in c("Herbivore", "Omnivore", "Carnivore")){
  data_pre <- subset(data_full, Population.density != "NA" & Trophic.level == oo)
  species_data <- data_pre$Binomial.1.2
  data <- data.frame(N = (log10(as.numeric(data_pre$Population.density))), MR = (log10(data_pre$MR.kJ.day)),
                     B = (log10(data_pre$B.gram)), M = (log10(data_pre$M.gram)),
                     AD = (asin(sqrt(data_pre$AD.percentage/100))),
                     FS = (asin(sqrt(data_pre$FS.percentage/100))),
                     FM = (log10(data_pre$FM.days)), GS = (log10(data_pre$GS.days)),
                     II = (log10(data_pre$II.days)), WA = (log10(data_pre$WA.days)),
                     NO = (log10(data_pre$NO.count)), GL = (log10(data_pre$GL.days)))
  rownames(data) <- species_data
  data <- scale(data)
  data <- cbind(Species = species_data, data)
  write.table(data, paste0("~/datasets/dataset_", oo,"_pop_density.txt"), sep = "\t", row.names = FALSE, quote = FALSE)
  
  data_pre <- subset(data_full, Trophic.level == oo)
  species_data <- data_pre$Binomial.1.2
  data <- data.frame(N = (log10(as.numeric(data_pre$Effective.size))), MR = (log10(data_pre$MR.kJ.day)),
                     B = (log10(data_pre$B.gram)), M = (log10(data_pre$M.gram)),
                     AD = (asin(sqrt(data_pre$AD.percentage/100))),
                     FS = (asin(sqrt(data_pre$FS.percentage/100))),
                     FM = (log10(data_pre$FM.days)), GS = (log10(data_pre$GS.days)),
                     II = (log10(data_pre$II.days)), WA = (log10(data_pre$WA.days)),
                     NO = (log10(data_pre$NO.count)), GL = (log10(data_pre$GL.days)))
  rownames(data) <- species_data
  data <- scale(data)
  data <- cbind(Species = species_data, data)
  write.table(data, paste0("~/datasets/dataset_", oo,"_ne_100_800kya.txt"), sep = "\t", row.names = FALSE, quote = FALSE)
}

#### make biome level datasets
for(oo in c("Cold", "Arid", "Tropical")){
  data_pre <- subset(data_full, Population.density != "NA" & Biome == oo)
  species_data <- data_pre$Binomial.1.2
  data <- data.frame(N = (log10(as.numeric(data_pre$Population.density))), MR = (log10(data_pre$MR.kJ.day)),
                     B = (log10(data_pre$B.gram)), M = (log10(data_pre$M.gram)),
                     AD = (asin(sqrt(data_pre$AD.percentage/100))),
                     FS = (asin(sqrt(data_pre$FS.percentage/100))),
                     FM = (log10(data_pre$FM.days)), GS = (log10(data_pre$GS.days)),
                     II = (log10(data_pre$II.days)), WA = (log10(data_pre$WA.days)),
                     NO = (log10(data_pre$NO.count)), GL = (log10(data_pre$GL.days)))
  rownames(data) <- species_data
  data <- scale(data)
  data <- cbind(Species = species_data, data)
  write.table(data, paste0("~/datasets/dataset_", oo,"_pop_density.txt"), sep = "\t", row.names = FALSE, quote = FALSE)
  
  data_pre <- subset(data_full, Biome == oo)
  species_data <- data_pre$Binomial.1.2
  data <- data.frame(N = (log10(as.numeric(data_pre$Effective.size))), MR = (log10(data_pre$MR.kJ.day)),
                     B = (log10(data_pre$B.gram)), M = (log10(data_pre$M.gram)),
                     AD = (asin(sqrt(data_pre$AD.percentage/100))),
                     FS = (asin(sqrt(data_pre$FS.percentage/100))),
                     FM = (log10(data_pre$FM.days)), GS = (log10(data_pre$GS.days)),
                     II = (log10(data_pre$II.days)), WA = (log10(data_pre$WA.days)),
                     NO = (log10(data_pre$NO.count)), GL = (log10(data_pre$GL.days)))
  rownames(data) <- species_data
  data <- scale(data)
  data <- cbind(Species = species_data, data)
  write.table(data, paste0("~/datasets/dataset_", oo,"_ne_100_800kya.txt"), sep = "\t", row.names = FALSE, quote = FALSE)
}
