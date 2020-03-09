##-----------------------------------------------------------------------------------------------##
## The following script serves to merge Australian Estimated Resident Population statistics
## at the Greater Capital Statistical Area geographic level into a shapefile for the relevant 
## areal units. The shapefile is the latest used for statistical measurements in 
## Australia, i.e. the 2016 version.
##
## The shapefile is produced and maintained by the Australian Bureau of Statistics. It can be
## downloaded, along with other shapefiles for Australia, for free from the following link
## under the name "Greater Capital Statistical Area (GCCSA) ASGS Ed 2016 Digital Boundaries in 
## ESRI Shapefile Format":
## https://www.abs.gov.au/AUSSTATS/abs@.nsf/DetailsPage/1270.0.55.001July%202016?OpenDocument
##-----------------------------------------------------------------------------------------------##

# install.packages("rgdal")
library(rgdal)

# Read in the shape file for the SA2 level of geographic aggregation
gccsa_shape <- readOGR("shapefiles/shape_aus_gccsa/GCCSA_2016_AUST.shp")

# Read in the SA2 level Estimated Resident Population Data
erp_2018_gccsa <- read.csv("erp_2018_2019_data/erp_2018_GCCSA")

# Comparing the names, it is clear that data is missing for only one area unit:
# "Other Territories"
shape_gccsa_names <- as.character(unique(gccsa_shape@data$GCC_NAME16))
erp_gccsa_names <- unique(erp_2018_gccsa$region)
shape_gccsa_names[which(!shape_gccsa_names %in% erp_gccsa_names)]

# Merge the SA2 population estimates into the shape file for analysis
gccsa_shape_merged <- merge(gccsa_shape, erp_2018_gccsa, by.x = "GCC_NAME16", by.y = "region") 

##-----------------------------------------------------------------------------------------------##
