#This script is used to generate Figure 4 in
#"Drivers of Future Physical Water Scarcity and its Economic Impacts in Latin America and the Caribbean"

#Running this code produces a classification tree for the specified basin (variable "bs" - reurn the code with the basin 
#of your choice) 
#The binary classification threshold is whether a scenario is severe for the physical water scarcity metric

#Load required libraries
library(rpart) #CART
library(rpart.plot) #plot CART
library(dplyr)
library(magrittr)

#Set path (this should be changed for your local machine)
setwd("/cluster/tufts/lamontagnelab/gkim14/P2_Hydro_Climate/Final_Organization_paper/Results_Analysis/Final_Ensemble_2160")

#Load CSV of metrics data
metrics <- read.csv(file = 'hydro_gen_share_reg_2100.csv')

metrics$reg_hydro_gen <- round(metrics$reg_hydro_gen, digits=2)
metrics$hep_fut_prd <- round(metrics$hep_fut_prd, digits=2)
metrics$cf_fut_prd <- round(metrics$cf_fut_prd, digits=2)


#reg = "China"
reg = "Africa_Western"

metrics %>% filter(region==reg) -> df_filt

#make sure that the parameters are categorical variables!
df_filt$co2=as.factor(df_filt$co2)
df_filt$ccs=as.factor(df_filt$ccs)
df_filt$rt =as.factor(df_filt$rt)
df_filt$soc=as.factor(df_filt$soc)
df_filt$bl =as.factor(df_filt$bl)
df_filt$tr =as.factor(df_filt$tr)

#remove duplicates from dataset
df_filt %>% distinct(co2,ccs,rt,soc,tr,bl,hep_fut_prd,cf_fut_prd,reg_hydro_gen, .keep_all= TRUE) -> no_dups

#create pws_binary which is threshold for most severe scenarios (physical water scarcity > 0.4)
no_dups$hydro_binary <- no_dups$reg_hydro_gen > quantile(no_dups$reg_hydro_gen, 0.9)

#filter to just parameter assumptions and binary threshold (wta_binary)
df_class <- subset(no_dups, select = c("co2","ccs","rt","soc","bl","tr","cf_fut_prd","hep_fut_prd","hydro_binary"))

#run classification with max depth = 4
fit_class <- rpart(hydro_binary ~ .,
                   method="class", data=df_class,control=c(maxdepth=4),cp=.000001)

#plot classification tree
rpart.plot(fit_class, main = reg)
extreme_reg = no_dups[no_dups$hydro_binary==TRUE,]

write.csv(extreme_reg, paste0("CART_Results/CT_Western_Africa_hydro_gen_2100.csv"))


################## Regional Hydropower Share

#reg = "Canada"
#reg = "European Free Trade Association"
reg = "Colombia"

metrics %>% filter(region==reg) -> df_filt

#make sure that the parameters are categorical variables!
df_filt$co2=as.factor(df_filt$co2)
df_filt$ccs=as.factor(df_filt$ccs)
df_filt$rt =as.factor(df_filt$rt)
df_filt$soc=as.factor(df_filt$soc)
df_filt$bl =as.factor(df_filt$bl)
df_filt$tr =as.factor(df_filt$tr)

#remove duplicates from dataset
df_filt %>% distinct(co2,ccs,rt,soc,tr,bl,hep_fut_prd,cf_fut_prd,reg_hydro_share, .keep_all= TRUE) -> no_dups

#create pws_binary which is threshold for most severe scenarios (physical water scarcity > 0.4)
no_dups$hydro_binary <- no_dups$reg_hydro_share > quantile(no_dups$reg_hydro_share, 0.9)

#filter to just parameter assumptions and binary threshold (wta_binary)
df_class <- subset(no_dups, select = c("co2","ccs","rt","soc","bl","tr","cf_fut_prd","hep_fut_prd","hydro_binary"))

#run classification with max depth = 4
fit_class <- rpart(hydro_binary ~ .,
                   method="class", data=df_class,control=c(maxdepth=4),cp=.000001)

#plot classification tree
rpart.plot(fit_class, main = reg)
extreme_reg = no_dups[no_dups$hydro_binary==TRUE,]

write.csv(extreme_reg, paste0("CART_Results/CT_Colombia_hydro_share_2100.csv"))

