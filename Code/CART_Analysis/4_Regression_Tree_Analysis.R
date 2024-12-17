#This script is used to generate Figure 2 in
#"Drivers of Future Physical Water Scarcity and its Economic Impacts in Latin America and the Caribbean"

#Running this code produces a list of parameter importance scores for all basins in the LAC region
#from running 500 bagged regression trees for the physical water scarcity metric.
setwd("/cluster/tufts/lamontagnelab/gkim14/P2_Hydro_Climate/Final_Organization_paper/Results_Analysis/Final_Ensemble_2160")

#load required libraries
library(dplyr)
library(randomForest)
library(magrittr)

#Load CSV of metrics data
#this has water price, crop profit, and physical water scarcity for the 40 LAC basins 
#from 2015 - 2100 (5 year increments)
metrics <- read.csv(file = 'hydro_gen_share_reg_2100.csv')
metrics[is.na(metrics)] <- 0

#initialize an empty dataframe to store the parameter importance scores
sum_importances = data.frame()

#specify basin(s) for regression analysis
region_list <- unique(metrics$region)

#loop through basins
for (reg in region_list) {
  
  #filter to single basin and year
  metrics %>% filter(region==reg) -> df_filt
  
  #make sure that the parameters are categorical variables!
  df_filt$co2=as.factor(df_filt$co2)
  df_filt$ccs=as.factor(df_filt$ccs)
  df_filt$rt=as.factor(df_filt$rt)
  df_filt$soc=as.factor(df_filt$soc)
  df_filt$tr=as.factor(df_filt$tr)
  df_filt$bl=as.factor(df_filt$bl)

  #remove duplicates from dataset
  df_filt %>% distinct(co2,ccs,rt,soc,tr,bl,hep_fut_prd,cf_fut_prd,reg_hydro_gen, .keep_all= TRUE) -> no_dups
  
  #filter data to just what's required for regression analysis (7 parameter assumptions,metric)
  #here the scarcity metric is physical water scarcity (pws)
  df_regr <- subset(no_dups, select = c("co2","ccs","rt","soc","tr","bl","hep_fut_prd","cf_fut_prd","reg_hydro_gen"))
  
  #regression using the randomforest package
  rf_regr <- randomForest(
    reg_hydro_gen~.,
    data=df_regr,mtry=7,importance=TRUE,ntree=500) #bagging (mtry = 7)
  
  #Put variable importance scores into dataframe
  importance_df <- as.data.frame(rf_regr %>% importance)
  importance_df$varnames <- rownames(importance_df)
  rownames(importance_df) <- NULL  
  importance_df$region <- reg
  importance_df$metric <- 'reg_hydro_gen'
  
  #add to the sum_importances storage dataframe
  sum_importances <- rbind(sum_importances,importance_df)
  print(reg)
}

#save sum_importances (variable importance scores for all regions) as csv
#make sure the save location is somewhere on your local machine
write.csv(sum_importances, paste0("CART_Results/RT_reg_hydro_gen_2100_Oct29.csv"))

