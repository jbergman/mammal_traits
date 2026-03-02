library(GGally)

#### load data
data_full <- read.table("~/supp_table_1.txt", sep = "\t", header = T)

################################################################################################################################################
##############################################################--- SUPP. FIG. 1 ---##############################################################
################################################################################################################################################
#### choose predictors
data <- data.frame(M = (log10(as.numeric(data_full$M.gram))), B = (log10(data_full$B.gram)), MR = (log10(data_full$MR.kJ.day)),
                   AD = (asin(sqrt(data_full$AD.percentage/100))), FS = (asin(sqrt(data_full$FS.percentage/100))),
                   FM = (log10(data_full$FM.days)), GS = (log10(data_full$GS.days)),
                   II = (log10(data_full$II.days)), WA = (log10(data_full$WA.days)),
                   NO = (log10(data_full$NO.count)), GL = (log10(data_full$GL.days)))

#### scale data
data <- data.frame(scale(data))

#### plot
p <- ggpairs(data, upper = list(continuous = wrap("cor", method = "spearman")))
p

#### save outputs
ggsave("~l/supp_fig_1.pdf", plot = p, width = 12, height = 10)

################################################################################################################################################
##############################################################--- SUPP. FIG. 2 ---##############################################################
################################################################################################################################################
#### choose predictors
data <- data.frame(N1 = (log10(as.numeric(data_full$Population.density))), 
                   N2 = (log10(as.numeric(data_full$Effective.size))))

#### scale data
data <- data.frame(scale(data))
colnames(data) <- c("Population density", "Effective population size")

#### plot
p <- ggpairs(data, upper = list(continuous = wrap("cor", method = "spearman")))
p

#### save outputs
ggsave("~/supp_fig_2.pdf", plot = p, width = 6, height = 5)
