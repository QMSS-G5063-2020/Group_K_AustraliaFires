##-----------------------------------------------------------------------------------------------##
## The following script serves to merge Australian Estimated Resident Population statistics
## at the SA2 geographic statistical level into a shapefile for all SA2 area units. The shapefile 
## is the latest used for statistical measurements in Australia, i.e. the 2016 version.
##
## The shapefile is produced and maintained by the Australian Bureau of Statistics. It can be
## downloaded, along with other shapefiles for Australia, for free from the following link
## under the name "Statistical Area Level 2 (SA2) ASGS Ed 2016 Digital Boundaries in ESRI Shapefile 
## Format":
## https://www.abs.gov.au/AUSSTATS/abs@.nsf/DetailsPage/1270.0.55.001July%202016?OpenDocument
##-----------------------------------------------------------------------------------------------##

# install.packages("rgdal")
library(rgdal)

# Read in the shape file for the SA2 level of geographic aggregation
sa2_shape <- readOGR("shapefiles/shape_aus_sa2/SA2_2016_AUST.shp")

# Read in the SA2 level Estimated Resident Population Data
erp_2018_sa2 <- read.csv("erp_2018_2019_data/erp_2018_SA2")

# Comparing the names, it is clear the data is missing for 4 SA2 area units:
# "Christmas Island", "Cocos (Keeling) Islands", "Jervis Bay", and "Norfolk Island"  
shape_sa2_names <- as.character(unique(sa2_shape@data$SA2_NAME16))
erp_sa2_names <- unique(erp_2018_sa2$region)
shape_sa2_names[which(!shape_sa2_names %in% erp_sa2_names)]

# Merge the SA2 population estimates into the shape file for analysis
sa2_shape_merged <- merge(sa2_shape, erp_2018_sa2, by.x = "SA2_NAME16", by.y = "region") 

##-----------------------------------------------------------------------------------------------##
