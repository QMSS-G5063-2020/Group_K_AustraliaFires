##-----------------------------------------------------------------------------------------------##
## The following script serves to merge Australian Estimated Resident Population statistics
## at the SA3 geographic statistical level into a shapefile for all SA3 area units. The shapefile 
## is the latest used for statistical measurements in Australia, i.e. the 2016 version.
##
## The shapefile is produced and maintained by the Australian Bureau of Statistics. It can be
## downloaded, along with other shapefiles for Australia, for free from the following link
## under the name "Statistical Area Level 3 (SA3) ASGS Ed 2016 Digital Boundaries in ESRI Shapefile 
## Format":
## https://www.abs.gov.au/AUSSTATS/abs@.nsf/DetailsPage/1270.0.55.001July%202016?OpenDocument
##-----------------------------------------------------------------------------------------------##

# install.packages("rgdal")
library(rgdal)

# Read in the shape file for the SA2 level of geographic aggregation
sa3_shape <- readOGR("shapefiles/shape_aus_sa3/SA3_2016_AUST.shp")

# Read in the SA2 level Estimated Resident Population Data
erp_2018_sa3 <- read.csv("erp_2018_2019_data/erp_2018_SA3")

# Comparing the names, it is clear the data is missing for 4 SA3 area units:
# "Christmas Island", "Cocos (Keeling) Islands", "Jervis Bay", and "Norfolk Island"  
shape_sa3_names <- as.character(unique(sa3_shape@data$SA3_NAME16))
erp_sa3_names <- unique(erp_2018_sa3$region)
shape_sa3_names[which(!shape_sa3_names %in% erp_sa3_names)]

# Merge the SA2 population estimates into the shape file for analysis
sa3_shape_merged <- merge(sa3_shape, erp_2018_sa3, by.x = "SA3_NAME16", by.y = "region") 

##-----------------------------------------------------------------------------------------------##
