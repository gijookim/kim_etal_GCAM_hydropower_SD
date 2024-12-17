# kim_etal_GCAM_hydropower_SD

This repository contains the code used to generate the data and figures in the paper "Mapping the future role of hydropower under global low-carbon transitions through large ensemble scenario discovery" by Kim et al., which is currently in revision.

# Reproducing the results
This study consists of the following steps:
 1. **Compiling and building Global Change Analysis Model (GCAM)**, which represents the interactions between socioeconomic-climate-land-energy-water systems. In order to replicate our experiment, the user should use GCAM with endogenous representation of hydropower with climate change impact feature implemented which is available on a separate Zonodo repository.
 2. **Creating input files and running large ensemble GCAM runs.** The second step includes generating configuration files (xmls) that correspond to each GCAM run in the ensemble. We then run the simulation in parallel in a cluster-based HPC environment.
 3. **Querying relevant GCAM outputs** that are further used for analysis. After running GCAM, we query relevant outputs and process raw query results to a format that is convenient for later use.
 4. **Reproducing the figures** in the paper using the script in this repository.

# Detailed explanations for each step
1. To install and run GCAM scenarios, follow the instructions on https://github.com/JGCRI/gcam-core/releases/tag/gcam-v5.3. Be sure to download and compile the specific version of the model, available at 10.5281/zenodo.13863869.
2. After building GCAM, create input files a. Among 8 factors we vary in our ensemble, 6 factors are available and only 2 factors (HCF and EHP) should be created exogenously. Follow the steps from the script in the folder "HCF_EHP_Analysis" to fit regression models, project future HCF and EHP in 5-year time steps, and create xml files that are further used as input to GCAM. After creating xmls for HCF and EHP, create configuration files for each GCAM run (i.e., 2,160 configuration xmls) and run the ensemble. 
3. Using GCAM database and 

# Contents
The structure of this repository is as follows:
1. Data: 
2. 
3. Code

# Contact Information
Any questions regarding this repository should be directed to gijoo.kim@tufts.edu
