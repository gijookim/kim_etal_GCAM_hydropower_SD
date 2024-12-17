# kim_etal_GCAM_hydropower_SD

This repository contains the code used to generate the data and figures in the paper "Mapping the future role of hydropower under global low-carbon transitions through large ensemble scenario discovery" by Kim et al., which is currently in revision.

# Reproducing the results
This study consists of the following steps:
 1. **Compiling and building Global Change Analysis Model (GCAM)**, which represents the interactions between socioeconomic-climate-land-energy-water systems. In order to replicate our experiment, the user should use GCAM with endogenous representation of hydropower with climate change impact feature implemented which is available on a separate Zenodo repository.
 2. **Creating input files and running large ensemble GCAM runs.** The second step includes generating configuration files (xmls) that correspond to each GCAM run in the ensemble. We then run the simulation in parallel in a cluster-based HPC environment.
 3. **Querying relevant GCAM outputs** that are further used for analysis. After running GCAM, we query relevant outputs and process raw query results to a format that is convenient for later use.
 4. **Reproducing the figures** in the paper using the script in this repository.

# Detailed explanations for each step
1. To install and run GCAM scenarios, follow the instructions on https://github.com/JGCRI/gcam-core/releases/tag/gcam-v5.3. Be sure to download and compile the specific version of the model, available at 10.5281/zenodo.13863869.
2. After building GCAM, create input xmls and configuration xml files that will be used when running GCAM ensemble.
   - Among 8 factors we vary in our ensemble, 6 factors are publically available and only 2 factors (HCF and EHP) are created exogenously from this study. The raw streamflow data used in this study to project future HCF and EHP is available at Zhao et al. (2023). Follow the steps from the script in "Code/HCF_EHP_Analysis" to fit regression models, project future HCF and EHP in 5-year time steps, and create csv files.
   - Transform csv files into xml files using the script in "Code/hydro_climate_impacts.R". The resulting files will be in "Code/addon_hydro."
   - After creating xmls for HCF and EHP, create configuration files for each GCAM run using the scripts in "Code/GCAM_Configuration" and run the ensemble (i.e., 2,160 configuration xmls). The resulting configuration xml files are in "Code/Configuration/config_ref" and "Code/Configuration/config_net."
3.  Using the GCAM output database and query_xmls, run queries and process them. The list of queries used in this study are in "Code/processing_queries/query_xml" and are listed below. 
   -  co2_emissions_by_sector_no_bio.xml, co2_emissions_by_tech.xml, elec_gen_by_gen_tech.xml, and luc_emissions_by_region.xml
4. Following the codes in "Code/Data_Processing," process raw query data and reproduce the figures using the scripts in "Code/Figure_Generation."

# Contents
The structure of this repository is as follows:
1. Data
   * mapping: folder containing shp files, csv files, and data used to make map figures
   * Processed_Data: folder containing 
   * ipcc_glb_hydro: folder containing global hydropower projections from IPCC reports, SR15 (Huppmann et al. 2018) and AR6 (Byers et al. 2022).
   * hist_HCF_EHP: folder containing historical hydropower capacity factor and exploitable hydropower potential
   * fut_HCF_EHP: folder containing projected historical hydropower capacity factor and exploitable hydropower potential for 30 scenarios
2. Code
   * HCF_EHP_Analysis: contains codes to 
   * GCAM_Configuration: folder containing 2 base configuration xmls and 2,160 configuration xml files used for ensemble generation
   * processing_queries: folder containing codes to run query outputs
   * Figure_Generation: folder containing codes used to generate figures in the paper
      * Figure1_HCF_EHP_Maps.ipynb: Code to generate Figure 1
      * Figure2_5_Hydro_Analysis.ipynb: Code to generate Figures 2-5
3. README.md: this document, which contains instructions for reproducing the results of this study and the contents of the data repository.

# Contact Information
Any questions regarding this repository should be directed to gijoo.kim@tufts.edu

# References
Byers E, Krey V, Kriegler E, Riahi K, Schaeffer R, Kikstra J, et al. (2022). AR6 Scenarios Database 2022. https://doi.org/10.5281/ZENODO.5886911.

Huppmann D, Kriegler E, Krey V, Riahi K, Rogelj J, Rose S, et al. (2018). IAMC 1.5°C Scenario Explorer and Data hosted by IIASA 2018. https://doi.org/10.22022/SR15/08-2018.15429.

Zhao, M., Wild, T., & Vernon, C. (2023). Xanthos Output Dataset Under ISIMIP3b Selected CMIP6 Scenarios: 1850 - 2100 (v1.1) [Data set]. MSD-LIVE Data Repository. https://doi.org/10.57931/2280839
