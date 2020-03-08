##-----------------------------------------------------------------------------------------------##
## The following script uses the "raustats" package to pull down estimate population data for 
## for Australia, published by the Australiab Bureau of Statistics (ABS), through the relevant API. 
## Pulling the data from the API can take several minutes to a half-hour due to URL restrictions
## and the iterative list-based filter used in the query call. The final data outputs create 
## several comma-separated text files for each level of geographic aggregation. SA2 is the
## most granular level pulled from the ABS API here. 
## 
## Further information for the levels of geographic aggregation can be found here:
## https://www.abs.gov.au/ausstats/abs@.nsf/Lookup/by%20Subject/1270.0.55.001~July%202016~Main%20Features~Main%20structure~10002
## 
## All Australian census data and the corresponding names for geographic dilineations are in line 
## with the Australian Statistical Geography Standard (ASGS). More information can be found here:
## https://www.abs.gov.au/websitedbs/D3310114.nsf/home/Australian+Statistical+Geography+Standard+(ASGS)
##
## The package documentation and function usecases/examples are found at the folloing link:
## https://cran.r-project.org/web/packages/raustats/vignettes/raustats_introduction.html
##-----------------------------------------------------------------------------------------------##

# install.packages("raustats")
# install.package("tidyverse")
library(raustats)
library(tidyverse)

## Estimated Resident Population (ERP) dataset ID
abs_ds_ERP <- abs_search(pattern="ABS_ERP_COMP_SA") %>%
                select(id) %>% unlist

## Create filter 
ds_filter_ERP <- abs_search(pattern=c("*"),
                        dataset=abs_ds_ERP, code_only=TRUE) %>%
              map(~ .x %>% split(., ceiling(seq_along(.)/75))) %>%
              cross

## Download June 2019 ERP 
erp <-
  lapply(ds_filter_ERP,
         function(i_filter)
           abs_stats(abs_ds_ERP,
                     filter=i_filter)) %>% 
  bind_rows

# Filter for the lastest population estimates available
erp_2018 <- erp %>% filter(time == 2018 & population_component == "Estimated Resident Population")

# Series of filters to save out separate datasets for each level of geographic aggregation
erp_2018_SA2 <- erp_2018 %>% filter(geography_level == "Statistical Area Level 2")
erp_2018_SA3 <- erp_2018 %>% filter(geography_level == "Statistical Area Level 3")
erp_2018_SA4 <- erp_2018 %>% filter(geography_level == "Statistical Area Level 4")
erp_2018_ST <- erp_2018 %>% filter(geography_level == "States and Territories")
erp_2018_GCCSA <- erp_2018 %>% filter(geography_level == "Greater Capital City Statistical Areas")

# Series of write calls to save the data out in comma-separated text files
write.csv(erp_2018_SA2, "erp_2018_2019_data/erp_2018_SA2")
write.csv(erp_2018_SA3, "erp_2018_2019_data/erp_2018_SA3")
write.csv(erp_2018_SA4, "erp_2018_2019_data/erp_2018_SA4")
write.csv(erp_2018_ST, "erp_2018_2019_data/erp_2018_ST")
write.csv(erp_2018_GCCSA, "erp_2018_2019_data/erp_2018_GCCSA")

##-----------------------------------------------------------------------------------------------##