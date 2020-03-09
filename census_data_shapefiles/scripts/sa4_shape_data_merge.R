##-----------------------------------------------------------------------------------------------##
## The following script serves to merge Australian Estimated Resident Population statistics
## at the SA4 geographic statistical level into a shapefile for all SA4 area units. The shapefile 
## is the latest used for statistical measurements in Australia, i.e. the 2016 version.
##
## The shapefile is produced and maintained by the Australian Bureau of Statistics. It can be
## downloaded, along with other shapefiles for Australia, for free from the following link
## under the name "Statistical Area Level 4 (SA4) ASGS Ed 2016 Digital Boundaries in ESRI Shapefile 
## Format":
## https://www.abs.gov.au/AUSSTATS/abs@.nsf/DetailsPage/1270.0.55.001July%202016?OpenDocument
##-----------------------------------------------------------------------------------------------##

# install.packages("rgdal")
library(rgdal)

# Read in the shape file for the SA2 level of geographic aggregation
sa4_shape <- readOGR("shapefiles/shape_aus_sa4/SA4_2016_AUST.shp")

# Read in the SA2 level Estimated Resident Population Data
erp_2018_sa4 <- read.csv("erp_2018_2019_data/erp_2018_SA4")

# Comparing the names, it is clear the data is missing for 1 SA4 area unit:
# "Other Territories"  
shape_sa4_names <- as.character(unique(sa4_shape@data$SA4_NAME16))
erp_sa4_names <- unique(erp_2018_sa4$region)
shape_sa4_names[which(!shape_sa4_names %in% erp_sa4_names)]

# Merge the SA2 population estimates into the shape file for analysis
sa4_shape_merged <- merge(sa4_shape, erp_2018_sa4, by.x = "SA4_NAME16", by.y = "region") 

##-----------------------------------------------------------------------------------------------##
