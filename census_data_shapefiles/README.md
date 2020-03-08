# Census Data Shape files and Scripts

The directories and project environment here are meant to facilitate downloading Australian census data as well as outputting the data as comma-separated text files and merging the text files with shape file data.

Best method for using the files contained here:

1) Download all directories, including the R project directory.

2) Open the Aus_Census.Rproj project directory. 

3a) If your goal is download a fresh copy of population estimate data from the Australian Census Bureau from 2018, open and run the 'aus'erp_2018.R' script, which will output fresh copies of the text files to the 'erp_2018_2019_data' directory.

3b) If your goal is to download fresh 2019 population estimates for Australia's states and territories, run the 'aus_erp_2019_by_state_territory' script, which will output a fresh copy of the data into the 'erp_2018_2019_data' directory.

4) If the goal is to work with the population estimates and the relevant shape file, open the script beginning with the statistical level of aggregation you are interested in (i.e. SA2, SA3, SA4, ST, GCCSA) and run the code. The script will read in the relevant data and shape file, as well as merge the two into a SpatialDataFrame ready for use.

	NOTE: You do not need to run the scripts for downloading and outputting data if you download all of the directories. The data output by the scripts in steps 3a and 3b are already present in the 'erp_2018_2019_data' directory.

### Scripts

The scripts directory contains a set of R scripts meant to download and output several datasets as well as facilitate merging. The following list provides  quick guide as to the purpose of each:

- aus_erp_2018 : connects to the Australian Census Bureau (ACP) API to download estimated population counts for Australia at the SA2, SA3, SA4, GCCSA, and ST levels of geographic statistical aggregation. The resulting data frames are written out into the text files contained under the 'scripts' directory.

- aus_erp_2019_by_state_territory : connects to ACP API to download estimated population counts for Australia at the State and Territory level, with the population counts broken out by gender and age.

- gccsa_shape_data_merge : merges population counts at the GCCSA statistical level with the shape file for the GCCSA areal units.

- sa2_shape_data_merge : merges SA2 population counts with SA2 shape file.

- sa3_shape_data_merge : merges SA3 population counts with SA3 shape file.

- sa4_shape_data_merge : merges SA4 population counts with SA4 shape file.

- st_shape_data_merge : merges state & territory (st) population counts with st shape file.

### Shapefiles

The shapefiles directory contains all of the components for the shape files for each level of statistical aggregation and are named appropriately to match. The shape files are produced and maintained in accordance with the Australian Statistical Geography Standard (ASGS). The shape files contained here are the latest used by the ABS, i.e. the 2016 edition, and are ESRI shape files. More information on the statistical levels of aggregation used by the ABS can be found at the following link:

https://www.abs.gov.au/websitedbs/D3310114.nsf/home/Australian+Statistical+Geography+Standard+(ASGS)

### erp_2018_2019_data

The erp_2018_2019_data directory contains the output comma-separated text files from the 'aus_erp_2018' and 'aus_erp_2019_by_state_territory' scripts in the scripts directory. 

- Text files beginning with "erp_2018" are written out by the 'aus_erp_2018' script and contain population estimates from the year 2018 for the relevant level of statistical aggregation in the name. 

- The 'erp_st_age_sex_2019' text file contains population estimate data for the states and territories level of aggregation for Australia from June 2019, broken out by age and sex.