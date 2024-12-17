args = base::commandArgs(trailingOnly=TRUE)
LIB='/cluster/tufts/hpc/tools/R/4.0.0'
.libPaths(c("",LIB))
library(rgcam)
library(dplyr)


### TO RUN THIS SCRIPT: Rscript path-to-file $SLURM_ARRAY_TASK_ID name-of-query
### IT REQUIRES TWO ARGUMENTS: THE TASK ID FOR BATCH PROCESSING, AND THE NAME OF THE QUERY SO IT CAN BE LOOPED

###############################################################################################

# Name of query(must match filename of query xml)
queryName<-sub("\\..*", "", args[2])

# Path to GCAM outputs
db_path<-'/cluster/tufts/lamontagnelab/gkim14/GCAM/ying_hydro_cc_impacts_mod/gcam-core/output/db_ensemble_joo/ref/'

# Path to query XML file
query_file_path<-'query_xml/'

# Path to output results directory
results_path<-'query_results/'

# Path to temp data files
temp_path<-'temp_data_files/'

###############################################################################################


db_path1<-paste0(db_path,'')
dbs_unfiltered<-list.dirs(db_path1, recursive=FALSE)
dbs1<-substr(dbs_unfiltered,nchar(db_path)+1,nchar(dbs_unfiltered))

dbs<-c(dbs1)
dir.create(file.path(results_path, queryName), showWarnings = FALSE)

###############################################################################################

make_query<-function(scenario){
dbLoc<-paste0(db_path,scenario)
queryFile<-paste0(query_file_path,queryName,'.xml')
queryData=paste0(temp_path,queryName,"_",as.character(args[1]),'.dat')
queryResult<-rgcam::addScenario(dbLoc,queryData,queryFile=queryFile)
file.remove(queryData)
return(queryResult[[1]][[1]])
}

make_query(dbs[as.numeric(args[1])]) %>%
  readr::write_csv(paste0(results_path,queryName,'/',queryName,"-",as.character(sub(".*/", "", dbs[as.numeric(args[1])])),".csv"))
