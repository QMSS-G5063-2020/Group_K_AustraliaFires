library(rgdal)
library(sp)
library(dplyr)
library(magrittr)
library(spatialEco)
library(htmlwidgets)
library(plotly)
library(DT)
library(RColorBrewer)

#   ____________________________________________________________________________
#   Read in Shapefiles                                                      ####

suppressMessages({
    
    # Reading in Australian shapefile data
    sa3_shape <- readOGR("data/geo_data/shapefiles/sa3_lightweight/sa3_light.shp")
    sa3_shape <- spTransform(sa3_shape, CRS("+proj=longlat +datum=WGS84"))
    
    # Reading in the shapefile for a greater level of aggregation
    sa4_shape <- readOGR("data/geo_data/shapefiles/sa4_lightweight/sa4_light.shp")
    sa4_shape <- spTransform(sa4_shape, CRS("+proj=longlat +datum=WGS84"))
    
})

#   ____________________________________________________________________________
#   Adding in Census Data to the Australian SA3 Census Shapefile            ####

# Reading in Australian Census data
erp_2018_sa3 <- read.csv("data/geo_data/erp_2018_2019_data/erp_2018_SA3")

# Merge the SA# population estimates into the shape file for analysis
sa3_shape <- sp::merge(sa3_shape, erp_2018_sa3, by.x = "SA3_NAME16", by.y = "region") 

print("Census data complete")

#   ____________________________________________________________________________
#   Read in the fire data for a cluster map                                 ####

# we want the nrt_v1_96617 file which has been pre-subset for confirmed fire measurements
fire_data <- read.csv("data/geo_data/fire_nrt_V1_96617_subset.csv") 

print("Fire data complete")

#   ____________________________________________________________________________
#   Read in the weather datasets                                            ####

chart_melt <- read.csv("data/weather_data/chart_melt.csv")
dt <- read.csv("data/weather_data/dt.csv")
combined <- read.csv("data/weather_data/combined.csv")

print("Weather data complete")

#   ____________________________________________________________________________
#   Read in the text datasets                                               ####

# Bring in the sentiment scores
senti_tweets <- read.csv("data/text_data/senti_tweets.csv")
senti_tweets$date <- as.Date(senti_tweets$date)

# Bring in count data for high frequency pairs of words
tweets_counts <- read.csv("data/text_data/tweets_counts.csv")[2:4]

# Bring in sentiment scores for specific emotions
tweets_emotions <- read.csv("data/text_data/tweets_emotions.csv")

# Bring in most frequent positive-negative score
top_30 <- read.csv("data/text_data/top_30.csv")

# Bring in data for tweet counts over time
tweets_time <- read.csv("data/text_data/tweet_time.csv")
tweets_time$date <- as.Date(tweets_time$date)

print("Text data complete")