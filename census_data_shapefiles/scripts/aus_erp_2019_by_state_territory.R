##-----------------------------------------------------------------------------------------------##
## The following script uses the "raustats" package to pull down estimate population data for 
## for Australia, published by the Australiab Bureau of Statistics, through the relevant API. 
## The data set contains estimated population counts for each Australian state, broken out by 
## Age and Sex. 
## The package documentation and function usecases/examples are found at the folloing link:
## https://cran.r-project.org/web/packages/raustats/vignettes/raustats_introduction.html
##-----------------------------------------------------------------------------------------------##

# install.packages("raustats")
# install.package("tidyverse")
library(raustats)
library(tidyverse)

## Estimated Resident Population (ERP) dataset ID
abs_ds_ERP <- abs_search(pattern="quarterly.*population.*estimates") %>%
                select(id) %>% unlist

## Create filter (split into a list to avoid maximum query size issues)
ds_filter <- abs_search(pattern=c("Estimated Resident Population", "Males|Females|Persons",
                                  "^\\d{1,3}$", "Jun-2019"),
                        dataset=abs_ds_ERP, code_only=TRUE) %>%
              map(~ .x %>% split(., ceiling(seq_along(.)/26))) %>%
              cross

## Download June 2019 ERP (applied over the filter list)
erp_st_age_sex_2019 <-
  lapply(ds_filter,
         function(i_filter)
           abs_stats(abs_ds_ERP,
                     start_date="2019-Q2", end_date="2019-Q2",
                     filter=i_filter)) %>% 
  bind_rows

write.csv(erp_st_age_sex_2019, "erp_2018_2019_data/erp_st_age_sex_2019")
##-----------------------------------------------------------------------------------------------##