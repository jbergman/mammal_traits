library(ggplot2)
library(ape)
library(phylopath)
library(dagitty)
library(readxl)
library(phylolm)

#### load phylogenetic trees
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

#### function to transform phylopath to daggity
phylopath_to_dagitty <- function(phylopath_model) {
  # Get node names
  nodes <- colnames(phylopath_model)
  # Build edge list
  edges <- which(phylopath_model == 1, arr.ind = TRUE)
  edge_list <- apply(edges, 1, function(x) {
    paste(nodes[x["row"]], "->", nodes[x["col"]])
  })
  # Construct dagitty string
  dagitty_string <- paste0("dag {", paste(edge_list, collapse = "; "), "}")
  return(dagitty(dagitty_string))
}

for(oo in c("All", "Cetartiodactyla", "Carnivora", "Primates")){
  for(param in c("pop_density")){
    
    ####--- load models and data ---####
    all_models <- read.table(paste0("~/models/models_", oo,"_",param,".txt"), sep = "\t", header = T)
    
    # keep only supported networks (p > 0.05) and exclude models that produced warnings and/or models where CICc is NA
    all_models <- subset(all_models, p > 0.05 & WARNING == "no" & !(is.na(CICc)))
    
    #### set data
    data_full <- read.table("~/supp_table_1.txt", sep = "\t", header = T)
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
    }
    
    ####--- run regression coefficient estimation for each trait evolution model separately ---####
    for(em in unique(all_models$TRAIT_EVO_MODEL)){
      print(paste(oo, param, em))
      all_models_temp <- subset(all_models, TRAIT_EVO_MODEL == em)
      
      ####--- run regression coefficient estimation ---####
      all_trees_coeffName <- c(); all_trees_coeffEst <- c(); all_trees_coeffStdErr <- c()
      all_trees_pval <- c(); all_warnings_yes_no <- c()
      all_tt <- c(); all_common_model <- c(); all_model <- c(); all_evo_model <- c(); all_evo_model_param <- c()
      all_k <- c(); all_q <- c(); all_fisher_C <- c(); all_fisher_C_p <- c();  all_CICc <- c()
      
      for(ii in 1:1000){
        print(ii)
        temp <- subset(all_models_temp, PHYLO_TREE_IDX == ii)
        if(dim(temp)[1] > 0){
          temp <- temp[order(temp$CICc),]
          
          #### get adjustement sets
          if(temp$RESPONSE_NETWORK[1] == "M3"){
            jj = which(names(models_M3) == paste0(temp$CONNECTION_NETWORK[1], "_", temp$REPRODUCTION_NETWORK[1]))
            adjsets <- list(M_N_total = adjustmentSets(phylopath_to_dagitty(models_M3[[jj]]),"M","N", effect="total", type = "minimal")[[1]],
                            M_MR_total = adjustmentSets(phylopath_to_dagitty(models_M3[[jj]]),"M","MR", effect="total", type = "minimal")[[1]])
          }else if(temp$RESPONSE_NETWORK[1] == "M8"){
            jj = which(names(models_M8) == paste0(temp$CONNECTION_NETWORK[1], "_", temp$REPRODUCTION_NETWORK[1]))
            adjsets <- list(M_N_total = adjustmentSets(phylopath_to_dagitty(models_M8[[jj]]),"M","N", effect="total", type = "minimal")[[1]],
                            M_MR_total = adjustmentSets(phylopath_to_dagitty(models_M8[[jj]]),"M","MR", effect="total", type = "minimal")[[1]])
          }else if(temp$RESPONSE_NETWORK[1] == "M12"){
            jj = which(names(models_M12) == paste0(temp$CONNECTION_NETWORK[1], "_", temp$REPRODUCTION_NETWORK[1]))
            adjsets <- list(M_N_total = adjustmentSets(phylopath_to_dagitty(models_M12[[jj]]),"M","N", effect="total", type = "minimal")[[1]],
                            M_MR_total = adjustmentSets(phylopath_to_dagitty(models_M12[[jj]]),"M","MR", effect="total", type = "minimal")[[1]])
          }
          
          tree = all_trees[[ii]]
          species_tree <- tree$tip.label
          drop.species <- species_tree[!species_tree %in% rownames(data)]
          pruned_tree <- drop.tip(tree, drop.species)
          
          coeffName <- c(); coeffEst <- c(); coeffStdErr <- c(); pval <- c()
          evo_model_param <- c()
          
          # Prepare regression components for M on N
          exposure = "M"
          effect_type = "total"
          adj_vars = adjsets[[1]]
          formula_str <- paste("N ~", paste(c(exposure, adj_vars), collapse = " + "))
          formula_obj <- as.formula(formula_str)
          model_type = temp$TRAIT_EVO_MODEL[1]
          
          # Run phylogenetic regression for M on N
          warn_msg <- "na"
          fit <- withCallingHandlers(
            phylolm(formula_obj, data = data.frame(data), phy = pruned_tree, model = model_type),
            warning = function(w){
              warn_msg <<- conditionMessage(w)
              invokeRestart("muffleWarning")
            }
          )

          # get coefficient Estimate, StdErr and p.value for M on N
          s <- summary(fit)
          if(model_type == "BM"){
            evo_model_param <- c(evo_model_param, NA)
          }else{
            evo_model_param <- c(evo_model_param, s$optpar)
          }
          coef_table <- s$coefficients
          coeff_index <- which(names(coef_table[, "Estimate"]) == exposure)
          coeffEst <- c(coeffEst, coef_table[coeff_index, "Estimate"])
          coeffStdErr <- c(coeffStdErr, coef_table[coeff_index, "StdErr"])
          pval <- c(pval, coef_table[coeff_index, "p.value"])
          coeffName <- c(coeffName,"M_N")
          
          # Prepare regression components for M on MR
          exposure = "M"
          effect_type = "total"
          adj_vars = adjsets[[2]]
          formula_str <- paste("MR ~", paste(c(exposure, adj_vars), collapse = " + "))
          formula_obj <- as.formula(formula_str)
          model_type = temp$TRAIT_EVO_MODEL[1]
          
          # Run phylogenetic regression for M on MR
          warn_msg <- "na"
          fit <- withCallingHandlers(
            phylolm(formula_obj, data = data.frame(data), phy = pruned_tree, model = model_type),
            warning = function(w){
              warn_msg <<- conditionMessage(w)
              invokeRestart("muffleWarning")
            }
          )

          # get coefficient Estimate, StdErr, p.value for M on MR
          s <- summary(fit)
          if(model_type == "BM"){
            evo_model_param <- c(evo_model_param, NA)
          }else{
            evo_model_param <- c(evo_model_param, s$optpar)
          }
          coef_table <- s$coefficients
          coeff_index <- which(names(coef_table[, "Estimate"]) == exposure)
          coeffEst <- c(coeffEst, coef_table[coeff_index, "Estimate"])
          coeffStdErr <- c(coeffStdErr, coef_table[coeff_index, "StdErr"])
          pval <- c(pval, coef_table[coeff_index, "p.value"])
          coeffName <- c(coeffName, "M_MR")
          
          all_trees_coeffEst <- c(all_trees_coeffEst, coeffEst)
          all_trees_coeffStdErr <- c(all_trees_coeffStdErr, coeffStdErr)
          all_trees_pval <- c(all_trees_pval, pval)
          all_trees_coeffName <- c(all_trees_coeffName, coeffName)
          all_evo_model_param <- c(all_evo_model_param, evo_model_param)
          all_tt <- c(all_tt, rep(ii, 2))
          all_common_model <- c(all_common_model, rep(temp$RESPONSE_NETWORK[1], 2))
          all_model <- c(all_model, rep(paste0(temp$CONNECTION_NETWORK[1], "_", temp$REPRODUCTION_NETWORK[1]), 2)) 
          all_evo_model <- c(all_evo_model, rep(temp$TRAIT_EVO_MODEL[1], 2))
          all_k <- c(all_k, rep(temp$k[1], 2))
          all_q <- c(all_q, rep(temp$q[1], 2))
          all_fisher_C <- c(all_fisher_C, rep(temp$C[1], 2))
          all_fisher_C_p <- c(all_fisher_C_p, rep(temp$p[1], 2))
          all_CICc <- c(all_CICc, rep(temp$CICc[1], 2))
          all_warnings_yes_no <- c(all_warnings_yes_no, rep(temp$WARNING[1], 2))
        }
      }
      if(length(all_trees_pval)[1] > 0){
        
        temp <- data.frame(RESPONSE_NETWORK = all_common_model,	CONNECTION_NETWORK = sub("_.*", "", all_model),	REPRODUCTION_NETWORK = sub(".*_", "", all_model),
                           TRAIT_EVO_MODEL = all_evo_model, TRAIT_EVO_MODEL_ESTIMATE = all_evo_model_param,	PHYLO_TREE_IDX = all_tt,
                           PREDICTOR = as.character(all_trees_coeffName), ESTIMATE = all_trees_coeffEst, STDERR = all_trees_coeffStdErr, PVAL = all_trees_pval)

        write.table(temp, paste0("~/coefficients/coefficients_", oo,"_", param, "_", em, "_energy_equivalence.txt"), sep = "\t", row.names = F, quote = F)     
      }
    }
  }
}
