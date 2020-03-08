##-----------------------------------------------------------------------------------------------##
## The following script serves to merge Australian Estimated Resident Population statistics
## at the States and Territories geographic statistical level into a shapefile for all States and 
## Territories (ST) area units. The shapefile is the latest used for statistical measurements in 
## Australia, i.e. the 2016 version.
##
## The shapefile is produced and maintained by the Australian Bureau of Statistics. It can be
## downloaded, along with other shapefiles for Australia, for free from the following link
## under the name "State and Territory (STE) ASGS Ed 2016 Digital Boundaries in ESRI Shapefile 
## Format":
## https://www.abs.gov.au/AUSSTATS/abs@.nsf/DetailsPage/1270.0.55.001July%202016?OpenDocument
##-----------------------------------------------------------------------------------------------##

# install.packages("rgdal")
library(rgdal)

# Read in the shape file for the SA2 level of geographic aggregation
st_shape <- readOGR("shapefiles/shape_aus_st/STE_2016_AUST.shp")

# Read in the SA2 level Estimated Resident Population Data
erp_2018_st <- read.csv("erp_2018_2019_data/erp_2018_ST")

# Comparing the names, it is clear the data is missing for 1 ST area unit:
# "Other Territories"  
shape_st_names <- as.character(unique(st_shape@data$STE_NAME16))
erp_st_names <- unique(erp_2018_st$region)
shape_st_names[which(!shape_st_names %in% erp_st_names)]

# Merge the SA2 population estimates into the shape file for analysis
st_shape_merged <- merge(st_shape, erp_2018_st, by.x = "STE_NAME16", by.y = "region") 

##-----------------------------------------------------------------------------------------------##
