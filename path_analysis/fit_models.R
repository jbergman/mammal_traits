library(phylopath)
library(ape)

#### load trees
all_trees <- read.nexus("~/Complete_phylogeny.nex")

#### define models with M3
models_M3 <- define_model_set(
  C0_R1 = c(M ~ AD + FS, B ~ M + FS, MR ~ M + B + AD + FS, FS ~ AD, GS ~ FM, WA ~ GS, II ~ WA, NO ~ II, GL ~ NO),
  C1_R1 = c(M ~ AD + FS, B ~ M + FS, MR ~ M + B + AD + FS, FS ~ AD, FM ~ M, GS ~ FM, WA ~ GS, II ~ WA, NO ~ II, GL ~ NO),
  C2_R1 = c(M ~ AD + FS, B ~ M + FS, MR ~ M + B + AD + FS, FS ~ AD, FM ~ M + B, GS ~ FM, WA ~ GS, II ~ WA, NO ~ II, GL ~ NO),
  C3_R1 = c(M ~ AD + FS, B ~ M + FS, MR ~ M + B + AD + FS, FS ~ AD, FM ~ M + MR, GS ~ FM, WA ~ GS, II ~ WA, NO ~ II, GL ~ NO),
  C4_R1 = c(M ~ AD + FS, B ~ M + FS, MR ~ M + B + AD + FS, FS ~ AD, FM ~ M + B + MR, GS ~ FM, WA ~ GS, II ~ WA, NO ~ II, GL ~ NO),
  C5_R1 = c(M ~ AD + FS, B ~ M + FS, MR ~ M + B + AD + FS, FS ~ AD, FM ~ M, GS ~ M + FM, WA ~ M + GS, II ~ M + WA, NO ~ M + II, GL ~ M + NO),
  C6_R1 = c(M ~ AD + FS, B ~ M + FS, MR ~ M + B + AD + FS, FS ~ AD, FM ~ M + B, GS ~ M + B + FM, WA ~ M + B + GS, II ~ M + B + WA, NO ~ M + B + II, GL ~ M + B + NO),
  C7_R1 = c(M ~ AD + FS, B ~ M + FS, MR ~ M + B + AD + FS, FS ~ AD, FM ~ M + MR, GS ~ M + MR + FM, WA ~ M + MR + GS, II ~ M + MR + WA, NO ~ M + MR + II, GL ~ M + MR + NO),
  C8_R1 = c(M ~ AD + FS, B ~ M + FS, MR ~ M + B + AD + FS, FS ~ AD, FM ~ M + B + MR, GS ~ M + B + MR + FM, WA ~ M + B + MR + GS, II ~ M + B + MR + WA, NO ~ M + B + MR + II, GL ~ M + B + MR + NO),
  
  C0_R2 = c(M ~ AD + FS, B ~ M + FS, MR ~ M + B + AD + FS, FS ~ AD, GS ~ FM, WA ~ FM + GS, II ~ FM + GS + WA, NO ~ FM + GS + WA + II, GL ~ FM + GS + WA + II + NO),
  C1_R2 = c(M ~ AD + FS, B ~ M + FS, MR ~ M + B + AD + FS, FS ~ AD, FM ~ M, GS ~ FM, WA ~ FM + GS, II ~ FM + GS + WA, NO ~ FM + GS + WA + II, GL ~ FM + GS + WA + II + NO),
  C2_R2 = c(M ~ AD + FS, B ~ M + FS, MR ~ M + B + AD + FS, FS ~ AD, FM ~ M + B, GS ~ FM, WA ~ FM + GS, II ~ FM + GS + WA, NO ~ FM + GS + WA + II, GL ~ FM + GS + WA + II + NO),
  C3_R2 = c(M ~ AD + FS, B ~ M + FS, MR ~ M + B + AD + FS, FS ~ AD, FM ~ M + MR, GS ~ FM, WA ~ FM + GS, II ~ FM + GS + WA, NO ~ FM + GS + WA + II, GL ~ FM + GS + WA + II + NO),
  C4_R2 = c(M ~ AD + FS, B ~ M + FS, MR ~ M + B + AD + FS, FS ~ AD, FM ~ M + B + MR, GS ~ FM, WA ~ FM + GS, II ~ FM + GS + WA, NO ~ FM + GS + WA + II, GL ~ FM + GS + WA + II + NO),
  C5_R2 = c(M ~ AD + FS, B ~ M + FS, MR ~ M + B + AD + FS, FS ~ AD, FM ~ M, GS ~ M + FM, WA ~ M + FM + GS, II ~ M + FM + GS + WA, NO ~ M + FM + GS + WA + II, GL ~ M + FM + GS + WA + II + NO),
  C6_R2 = c(M ~ AD + FS, B ~ M + FS, MR ~ M + B + AD + FS, FS ~ AD, FM ~ M + B, GS ~ M + B + FM, WA ~ M + B + FM + GS, II ~ M + B + FM + GS + WA, NO ~ M + B + FM + GS + WA + II, GL ~ M + B + FM + GS + WA + II + NO),
  C7_R2 = c(M ~ AD + FS, B ~ M + FS, MR ~ M + B + AD + FS, FS ~ AD, FM ~ M + MR, GS ~ M + MR + FM, WA ~ M + MR + FM + GS, II ~ M + MR + FM + GS + WA, NO ~ M + MR + FM + GS + WA + II, GL ~ M + MR + FM + GS + WA + II + NO),
  C8_R2 = c(M ~ AD + FS, B ~ M + FS, MR ~ M + B + AD + FS, FS ~ AD, FM ~ M + B + MR, GS ~ M + B + MR + FM, WA ~ M + B + MR + FM + GS, II ~ M + B + MR + FM + GS + WA, NO ~ M + B + MR + FM + GS + WA + II, GL ~ M + B + MR + FM + GS + WA + II + NO),
  
  .common = c(N ~ M + MR + FM + GS + WA + II + NO + GL + FS)
)

#### define models with M8
models_M8 <- define_model_set(
  C0_R1 = c(M ~ AD + FS, B ~ M + FS, MR ~ M + B + AD + FS, FS ~ AD, GS ~ FM, WA ~ GS, II ~ WA, NO ~ II, GL ~ NO),
  C1_R1 = c(M ~ AD + FS, B ~ M + FS, MR ~ M + B + AD + FS, FS ~ AD, FM ~ M, GS ~ FM, WA ~ GS, II ~ WA, NO ~ II, GL ~ NO),
  C2_R1 = c(M ~ AD + FS, B ~ M + FS, MR ~ M + B + AD + FS, FS ~ AD, FM ~ M + B, GS ~ FM, WA ~ GS, II ~ WA, NO ~ II, GL ~ NO),
  C3_R1 = c(M ~ AD + FS, B ~ M + FS, MR ~ M + B + AD + FS, FS ~ AD, FM ~ M + MR, GS ~ FM, WA ~ GS, II ~ WA, NO ~ II, GL ~ NO),
  C4_R1 = c(M ~ AD + FS, B ~ M + FS, MR ~ M + B + AD + FS, FS ~ AD, FM ~ M + B + MR, GS ~ FM, WA ~ GS, II ~ WA, NO ~ II, GL ~ NO),
  C5_R1 = c(M ~ AD + FS, B ~ M + FS, MR ~ M + B + AD + FS, FS ~ AD, FM ~ M, GS ~ M + FM, WA ~ M + GS, II ~ M + WA, NO ~ M + II, GL ~ M + NO),
  C6_R1 = c(M ~ AD + FS, B ~ M + FS, MR ~ M + B + AD + FS, FS ~ AD, FM ~ M + B, GS ~ M + B + FM, WA ~ M + B + GS, II ~ M + B + WA, NO ~ M + B + II, GL ~ M + B + NO),
  C7_R1 = c(M ~ AD + FS, B ~ M + FS, MR ~ M + B + AD + FS, FS ~ AD, FM ~ M + MR, GS ~ M + MR + FM, WA ~ M + MR + GS, II ~ M + MR + WA, NO ~ M + MR + II, GL ~ M + MR + NO),
  C8_R1 = c(M ~ AD + FS, B ~ M + FS, MR ~ M + B + AD + FS, FS ~ AD, FM ~ M + B + MR, GS ~ M + B + MR + FM, WA ~ M + B + MR + GS, II ~ M + B + MR + WA, NO ~ M + B + MR + II, GL ~ M + B + MR + NO),
  
  C0_R2 = c(M ~ AD + FS, B ~ M + FS, MR ~ M + B + AD + FS, FS ~ AD, GS ~ FM, WA ~ FM + GS, II ~ FM + GS + WA, NO ~ FM + GS + WA + II, GL ~ FM + GS + WA + II + NO),
  C1_R2 = c(M ~ AD + FS, B ~ M + FS, MR ~ M + B + AD + FS, FS ~ AD, FM ~ M, GS ~ FM, WA ~ FM + GS, II ~ FM + GS + WA, NO ~ FM + GS + WA + II, GL ~ FM + GS + WA + II + NO),
  C2_R2 = c(M ~ AD + FS, B ~ M + FS, MR ~ M + B + AD + FS, FS ~ AD, FM ~ M + B, GS ~ FM, WA ~ FM + GS, II ~ FM + GS + WA, NO ~ FM + GS + WA + II, GL ~ FM + GS + WA + II + NO),
  C3_R2 = c(M ~ AD + FS, B ~ M + FS, MR ~ M + B + AD + FS, FS ~ AD, FM ~ M + MR, GS ~ FM, WA ~ FM + GS, II ~ FM + GS + WA, NO ~ FM + GS + WA + II, GL ~ FM + GS + WA + II + NO),
  C4_R2 = c(M ~ AD + FS, B ~ M + FS, MR ~ M + B + AD + FS, FS ~ AD, FM ~ M + B + MR, GS ~ FM, WA ~ FM + GS, II ~ FM + GS + WA, NO ~ FM + GS + WA + II, GL ~ FM + GS + WA + II + NO),
  C5_R2 = c(M ~ AD + FS, B ~ M + FS, MR ~ M + B + AD + FS, FS ~ AD, FM ~ M, GS ~ M + FM, WA ~ M + FM + GS, II ~ M + FM + GS + WA, NO ~ M + FM + GS + WA + II, GL ~ M + FM + GS + WA + II + NO),
  C6_R2 = c(M ~ AD + FS, B ~ M + FS, MR ~ M + B + AD + FS, FS ~ AD, FM ~ M + B, GS ~ M + B + FM, WA ~ M + B + FM + GS, II ~ M + B + FM + GS + WA, NO ~ M + B + FM + GS + WA + II, GL ~ M + B + FM + GS + WA + II + NO),
  C7_R2 = c(M ~ AD + FS, B ~ M + FS, MR ~ M + B + AD + FS, FS ~ AD, FM ~ M + MR, GS ~ M + MR + FM, WA ~ M + MR + FM + GS, II ~ M + MR + FM + GS + WA, NO ~ M + MR + FM + GS + WA + II, GL ~ M + MR + FM + GS + WA + II + NO),
  C8_R2 = c(M ~ AD + FS, B ~ M + FS, MR ~ M + B + AD + FS, FS ~ AD, FM ~ M + B + MR, GS ~ M + B + MR + FM, WA ~ M + B + MR + FM + GS, II ~ M + B + MR + FM + GS + WA, NO ~ M + B + MR + FM + GS + WA + II, GL ~ M + B + MR + FM + GS + WA + II + NO),
  
  .common = c(N ~ B + MR + FM + GS + WA + II + NO + GL + AD + FS)
)

#### define models with M12
models_M12 <- define_model_set(
  C0_R1 = c(M ~ AD + FS, B ~ M + FS, MR ~ M + B + AD + FS, FS ~ AD, GS ~ FM, WA ~ GS, II ~ WA, NO ~ II, GL ~ NO),
  C1_R1 = c(M ~ AD + FS, B ~ M + FS, MR ~ M + B + AD + FS, FS ~ AD, FM ~ M, GS ~ FM, WA ~ GS, II ~ WA, NO ~ II, GL ~ NO),
  C2_R1 = c(M ~ AD + FS, B ~ M + FS, MR ~ M + B + AD + FS, FS ~ AD, FM ~ M + B, GS ~ FM, WA ~ GS, II ~ WA, NO ~ II, GL ~ NO),
  C3_R1 = c(M ~ AD + FS, B ~ M + FS, MR ~ M + B + AD + FS, FS ~ AD, FM ~ M + MR, GS ~ FM, WA ~ GS, II ~ WA, NO ~ II, GL ~ NO),
  C4_R1 = c(M ~ AD + FS, B ~ M + FS, MR ~ M + B + AD + FS, FS ~ AD, FM ~ M + B + MR, GS ~ FM, WA ~ GS, II ~ WA, NO ~ II, GL ~ NO),
  C5_R1 = c(M ~ AD + FS, B ~ M + FS, MR ~ M + B + AD + FS, FS ~ AD, FM ~ M, GS ~ M + FM, WA ~ M + GS, II ~ M + WA, NO ~ M + II, GL ~ M + NO),
  C6_R1 = c(M ~ AD + FS, B ~ M + FS, MR ~ M + B + AD + FS, FS ~ AD, FM ~ M + B, GS ~ M + B + FM, WA ~ M + B + GS, II ~ M + B + WA, NO ~ M + B + II, GL ~ M + B + NO),
  C7_R1 = c(M ~ AD + FS, B ~ M + FS, MR ~ M + B + AD + FS, FS ~ AD, FM ~ M + MR, GS ~ M + MR + FM, WA ~ M + MR + GS, II ~ M + MR + WA, NO ~ M + MR + II, GL ~ M + MR + NO),
  C8_R1 = c(M ~ AD + FS, B ~ M + FS, MR ~ M + B + AD + FS, FS ~ AD, FM ~ M + B + MR, GS ~ M + B + MR + FM, WA ~ M + B + MR + GS, II ~ M + B + MR + WA, NO ~ M + B + MR + II, GL ~ M + B + MR + NO),
  
  C0_R2 = c(M ~ AD + FS, B ~ M + FS, MR ~ M + B + AD + FS, FS ~ AD, GS ~ FM, WA ~ FM + GS, II ~ FM + GS + WA, NO ~ FM + GS + WA + II, GL ~ FM + GS + WA + II + NO),
  C1_R2 = c(M ~ AD + FS, B ~ M + FS, MR ~ M + B + AD + FS, FS ~ AD, FM ~ M, GS ~ FM, WA ~ FM + GS, II ~ FM + GS + WA, NO ~ FM + GS + WA + II, GL ~ FM + GS + WA + II + NO),
  C2_R2 = c(M ~ AD + FS, B ~ M + FS, MR ~ M + B + AD + FS, FS ~ AD, FM ~ M + B, GS ~ FM, WA ~ FM + GS, II ~ FM + GS + WA, NO ~ FM + GS + WA + II, GL ~ FM + GS + WA + II + NO),
  C3_R2 = c(M ~ AD + FS, B ~ M + FS, MR ~ M + B + AD + FS, FS ~ AD, FM ~ M + MR, GS ~ FM, WA ~ FM + GS, II ~ FM + GS + WA, NO ~ FM + GS + WA + II, GL ~ FM + GS + WA + II + NO),
  C4_R2 = c(M ~ AD + FS, B ~ M + FS, MR ~ M + B + AD + FS, FS ~ AD, FM ~ M + B + MR, GS ~ FM, WA ~ FM + GS, II ~ FM + GS + WA, NO ~ FM + GS + WA + II, GL ~ FM + GS + WA + II + NO),
  C5_R2 = c(M ~ AD + FS, B ~ M + FS, MR ~ M + B + AD + FS, FS ~ AD, FM ~ M, GS ~ M + FM, WA ~ M + FM + GS, II ~ M + FM + GS + WA, NO ~ M + FM + GS + WA + II, GL ~ M + FM + GS + WA + II + NO),
  C6_R2 = c(M ~ AD + FS, B ~ M + FS, MR ~ M + B + AD + FS, FS ~ AD, FM ~ M + B, GS ~ M + B + FM, WA ~ M + B + FM + GS, II ~ M + B + FM + GS + WA, NO ~ M + B + FM + GS + WA + II, GL ~ M + B + FM + GS + WA + II + NO),
  C7_R2 = c(M ~ AD + FS, B ~ M + FS, MR ~ M + B + AD + FS, FS ~ AD, FM ~ M + MR, GS ~ M + MR + FM, WA ~ M + MR + FM + GS, II ~ M + MR + FM + GS + WA, NO ~ M + MR + FM + GS + WA + II, GL ~ M + MR + FM + GS + WA + II + NO),
  C8_R2 = c(M ~ AD + FS, B ~ M + FS, MR ~ M + B + AD + FS, FS ~ AD, FM ~ M + B + MR, GS ~ M + B + MR + FM, WA ~ M + B + MR + FM + GS, II ~ M + B + MR + FM + GS + WA, NO ~ M + B + MR + FM + GS + WA + II, GL ~ M + B + MR + FM + GS + WA + II + NO),
  
  .common = c(N ~ M + B + MR + FM + GS + WA + II + NO + GL + AD + FS)
)

#### write results
for(oo in c("All", "Cetartiodactyla", "Carnivora", "Primates", "Herbivore", "Omnivore", "Carnivore", "Arid", "Cold", "Tropical")){
  for(param in c("pop_density", "ne_100_800kya")){
    
    #### load data
    data_full <- read.table(paste0("~/datasets/dataset_", oo,"_", param ,".txt"), header = T)
    
    #### set data
    data <- data.frame(N = data_full$N, MR = data_full$MR,
                       B = data_full$B, M = data_full$M,
                       AD = data_full$AD,
                       FS = data_full$FS,
                       FM = data_full$FM, 
                       GS = data_full$GS,
                       II = data_full$II, 
                       WA = data_full$WA,
                       NO = data_full$NO, 
                       GL = data_full$GL)
    rownames(data) <- data_full$Species
    
    
    write.table("RESPONSE_NETWORK\tCONNECTION_NETWORK\tREPRODUCTION_NETWORK\tTRAIT_EVO_MODEL\tPHYLO_TREE_IDX\tk\tq\tC\tp\tCICc\tWARNING\tUSED_FOR_COEFF_EST", file=paste0("~/models/models_", oo,"_",param,".txt"), row.names = F, col.names = F, quote = F)
    for(ii in 1:1000){
      print(ii)
      
      # Reduce forest to the designated species list
      tree = all_trees[[ii]]
      species_tree <- tree$tip.label
      drop.species <- species_tree[!species_tree %in% rownames(data)]
      pruned_tree <- drop.tip(tree, drop.species)
      
      temp <- data.frame(matrix(ncol = 12, nrow = 0))
      colnames(temp) <- c("RESPONSE_NETWORK", "CONNECTION_NETWORK", "REPRODUCTION_NETWORK", "TRAIT_EVO_MODEL", "PHYLO_TREE_IDX", "k", "q", "C", "p", "CICc", "WARNING", "USED_FOR_COEFF_EST")
      
      for(model_name in names(models_M3)){
        result <- phylo_path(models_M3[model_name], data = data, tree = pruned_tree, model = 'lambda', lower.bound=0, upper.bound=1)
        result_summary <- summary(result)[,2:6]
        rownames(result_summary) <- NULL
        result_summary <- cbind(data.frame(RESPONSE_NETWORK = "M3", CONNECTION_NETWORK = unlist(strsplit(model_name, split = "_"))[1], REPRODUCTION_NETWORK = unlist(strsplit(model_name, split = "_"))[2],
                                           TRAIT_EVO_MODEL = "lambda", PHYLO_TREE_IDX = ii), result_summary)
        if(length(result$warnings) == 0){
          result_summary$WARNING <- "no"
          if(result_summary$p < 0.05){
            result_summary$USED_FOR_COEFF_EST <- "no"
          }else{
            result_summary$USED_FOR_COEFF_EST <- "yes"
          }
        }else{
          result_summary$WARNING <- "yes"
          result_summary$USED_FOR_COEFF_EST <- "no"
        }
        temp <- rbind(temp, result_summary)
        
        result <- phylo_path(models_M3[model_name], data = data, tree = pruned_tree, model = 'kappa', lower.bound=0, upper.bound=1)
        result_summary <- summary(result)[,2:6]
        rownames(result_summary) <- NULL
        result_summary <- cbind(data.frame(RESPONSE_NETWORK = "M3", CONNECTION_NETWORK = unlist(strsplit(model_name, split = "_"))[1], REPRODUCTION_NETWORK = unlist(strsplit(model_name, split = "_"))[2],
                                           TRAIT_EVO_MODEL = "kappa", PHYLO_TREE_IDX = ii), result_summary)
        if(length(result$warnings) == 0){
          result_summary$WARNING <- "no"
          if(result_summary$p < 0.05){
            result_summary$USED_FOR_COEFF_EST <- "no"
          }else{
            result_summary$USED_FOR_COEFF_EST <- "yes"
          }
        }else{
          result_summary$WARNING <- "yes"
          result_summary$USED_FOR_COEFF_EST <- "no"
        }
        temp <- rbind(temp, result_summary)
        
        result <- phylo_path(models_M3[model_name], data = data, tree = pruned_tree, model = 'delta', lower.bound=0, upper.bound=1)
        result_summary <- summary(result)[,2:6]
        rownames(result_summary) <- NULL
        result_summary <- cbind(data.frame(RESPONSE_NETWORK = "M3", CONNECTION_NETWORK = unlist(strsplit(model_name, split = "_"))[1], REPRODUCTION_NETWORK = unlist(strsplit(model_name, split = "_"))[2],
                                           TRAIT_EVO_MODEL = "delta", PHYLO_TREE_IDX = ii), result_summary)
        if(length(result$warnings) == 0){
          result_summary$WARNING <- "no"
          if(result_summary$p < 0.05){
            result_summary$USED_FOR_COEFF_EST <- "no"
          }else{
            result_summary$USED_FOR_COEFF_EST <- "yes"
          }
        }else{
          result_summary$WARNING <- "yes"
          result_summary$USED_FOR_COEFF_EST <- "no"
        }
        temp <- rbind(temp, result_summary)
      }
      
      for(model_name in names(models_M8)){
        result <- phylo_path(models_M8[model_name], data = data, tree = pruned_tree, model = 'lambda', lower.bound=0, upper.bound=1)
        result_summary <- summary(result)[,2:6]
        rownames(result_summary) <- NULL
        result_summary <- cbind(data.frame(RESPONSE_NETWORK = "M8", CONNECTION_NETWORK = unlist(strsplit(model_name, split = "_"))[1], REPRODUCTION_NETWORK = unlist(strsplit(model_name, split = "_"))[2],
                                           TRAIT_EVO_MODEL = "lambda", PHYLO_TREE_IDX = ii), result_summary)
        if(length(result$warnings) == 0){
          result_summary$WARNING <- "no"
          if(result_summary$p < 0.05){
            result_summary$USED_FOR_COEFF_EST <- "no"
          }else{
            result_summary$USED_FOR_COEFF_EST <- "yes"
          }
        }else{
          result_summary$WARNING <- "yes"
          result_summary$USED_FOR_COEFF_EST <- "no"
        }
        temp <- rbind(temp, result_summary)
        
        result <- phylo_path(models_M8[model_name], data = data, tree = pruned_tree, model = 'kappa', lower.bound=0, upper.bound=1)
        result_summary <- summary(result)[,2:6]
        rownames(result_summary) <- NULL
        result_summary <- cbind(data.frame(RESPONSE_NETWORK = "M8", CONNECTION_NETWORK = unlist(strsplit(model_name, split = "_"))[1], REPRODUCTION_NETWORK = unlist(strsplit(model_name, split = "_"))[2],
                                           TRAIT_EVO_MODEL = "kappa", PHYLO_TREE_IDX = ii), result_summary)
        if(length(result$warnings) == 0){
          result_summary$WARNING <- "no"
          if(result_summary$p < 0.05){
            result_summary$USED_FOR_COEFF_EST <- "no"
          }else{
            result_summary$USED_FOR_COEFF_EST <- "yes"
          }
        }else{
          result_summary$WARNING <- "yes"
          result_summary$USED_FOR_COEFF_EST <- "no"
        }
        temp <- rbind(temp, result_summary)
        
        result <- phylo_path(models_M8[model_name], data = data, tree = pruned_tree, model = 'delta', lower.bound=0, upper.bound=1)
        result_summary <- summary(result)[,2:6]
        rownames(result_summary) <- NULL
        result_summary <- cbind(data.frame(RESPONSE_NETWORK = "M8", CONNECTION_NETWORK = unlist(strsplit(model_name, split = "_"))[1], REPRODUCTION_NETWORK = unlist(strsplit(model_name, split = "_"))[2],
                                           TRAIT_EVO_MODEL = "delta", PHYLO_TREE_IDX = ii), result_summary)
        if(length(result$warnings) == 0){
          result_summary$WARNING <- "no"
          if(result_summary$p < 0.05){
            result_summary$USED_FOR_COEFF_EST <- "no"
          }else{
            result_summary$USED_FOR_COEFF_EST <- "yes"
          }
        }else{
          result_summary$WARNING <- "yes"
          result_summary$USED_FOR_COEFF_EST <- "no"
        }
        temp <- rbind(temp, result_summary)
      }
      
      for(model_name in names(models_M12)){
        result <- phylo_path(models_M12[model_name], data = data, tree = pruned_tree, model = 'lambda', lower.bound=0, upper.bound=1)
        result_summary <- summary(result)[,2:6]
        rownames(result_summary) <- NULL
        result_summary <- cbind(data.frame(RESPONSE_NETWORK = "M12", CONNECTION_NETWORK = unlist(strsplit(model_name, split = "_"))[1], REPRODUCTION_NETWORK = unlist(strsplit(model_name, split = "_"))[2],
                                           TRAIT_EVO_MODEL = "lambda", PHYLO_TREE_IDX = ii), result_summary)
        if(length(result$warnings) == 0){
          result_summary$WARNING <- "no"
          if(result_summary$p < 0.05){
            result_summary$USED_FOR_COEFF_EST <- "no"
          }else{
            result_summary$USED_FOR_COEFF_EST <- "yes"
          }
        }else{
          result_summary$WARNING <- "yes"
          result_summary$USED_FOR_COEFF_EST <- "no"
        }
        temp <- rbind(temp, result_summary)
        
        result <- phylo_path(models_M12[model_name], data = data, tree = pruned_tree, model = 'kappa', lower.bound=0, upper.bound=1)
        result_summary <- summary(result)[,2:6]
        rownames(result_summary) <- NULL
        result_summary <- cbind(data.frame(RESPONSE_NETWORK = "M12", CONNECTION_NETWORK = unlist(strsplit(model_name, split = "_"))[1], REPRODUCTION_NETWORK = unlist(strsplit(model_name, split = "_"))[2],
                                           TRAIT_EVO_MODEL = "kappa", PHYLO_TREE_IDX = ii), result_summary)
        if(length(result$warnings) == 0){
          result_summary$WARNING <- "no"
          if(result_summary$p < 0.05){
            result_summary$USED_FOR_COEFF_EST <- "no"
          }else{
            result_summary$USED_FOR_COEFF_EST <- "yes"
          }
        }else{
          result_summary$WARNING <- "yes"
          result_summary$USED_FOR_COEFF_EST <- "no"
        }
        temp <- rbind(temp, result_summary)
        
        result <- phylo_path(models_M12[model_name], data = data, tree = pruned_tree, model = 'delta', lower.bound=0, upper.bound=1)
        result_summary <- summary(result)[,2:6]
        rownames(result_summary) <- NULL
        result_summary <- cbind(data.frame(RESPONSE_NETWORK = "M12", CONNECTION_NETWORK = unlist(strsplit(model_name, split = "_"))[1], REPRODUCTION_NETWORK = unlist(strsplit(model_name, split = "_"))[2],
                                           TRAIT_EVO_MODEL = "delta", PHYLO_TREE_IDX = ii), result_summary)
        if(length(result$warnings) == 0){
          result_summary$WARNING <- "no"
          if(result_summary$p < 0.05){
            result_summary$USED_FOR_COEFF_EST <- "no"
          }else{
            result_summary$USED_FOR_COEFF_EST <- "yes"
          }
        }else{
          result_summary$WARNING <- "yes"
          result_summary$USED_FOR_COEFF_EST <- "no"
        }
        temp <- rbind(temp, result_summary)
      }
      rownames(temp) <- NULL
      write.table(temp, paste0("~/models/models_", oo,"_", param ,".txt"), sep="\t", row.names = F, col.names = F, quote = F, append=TRUE)
    }
  }
}