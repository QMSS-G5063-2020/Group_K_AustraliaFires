#   ____________________________________________________________________________
#   Population and Fire Data                                                ####
firePopulationLocation <- function() {
    
    tagList(
        div(class = "container",
            h1("Fire Location and Census Data", class = "title fit-h1"),
            div(class = "row featurette center-on-xs",
                div(class = "col-md-7 col-md-push-5",
                    leafletOutput("map3")),
                div (class = "col-md-5 col-md-pull-7",
                     p("To understand the severity and the nature of the 2019-2020 wildfires, it helps to understand the fire locations as they relate to Australia's residents. To this end, NASA made data available in real-time as the fire season peaked. Here, the data is visualized using a choropleth map to show fire frequencies across the continent. The data used pertain to the month of January, which partly explains the concentration of fire frequencies in the West. However, it can be useful to visualize the actual point data to obtain a more granular understanding of fire locations.")
                )
            ),
            hr(class = "divider"),
            div(class = "row featurette center-on-xs",
                div(class = "col-md-7",
                    leafletOutput("map")),
                div (class = "col-md-5",
                     p("Using Leaflet's clustering layer, it is clear that the large shape of the western census zones used for the first choropleth map have somewhat skewed the picture of fire locations. As is evident here, the fires are concentrated around the coast, with the majority concentrated around the southeast portion of the continent and a significant number around the southwest portion.")
                )
            ),
            hr(class = "divider"),
            div(class = "row featurette center-on-xs",
                div(class = "col-md-7 col-md-push-5",
                    leafletOutput("map2")),
                div (class = "col-md-5 col-md-pull-7",
                     p("To understand the severe impact of the fire locations along the coastline (particularly the southeast around New South Wales and Victoria), the Australian Census Bureau provides census data at various levels of granularity. Using the SA3 level of aggregation (a bit more granular than the first map), it is clear that the bulk of australians live in four areas, three of which are along the east and southeast coast. Unfortunately, this means the bulk of Australian residents live immediately proximate to the wildfire locations.")
                )
            ),
            hr(),
            print("Census shapefiles and population were obtained from the Australian Bureau of Statistics using the R package 'raustats.' Fire satellite location data was collected by NASA through MODIS and VIIRS.")
        )
    )
}

#   ____________________________________________________________________________
#   Sentiment Data                                                          ####

sentimentAnalysis <- function() {
    
    tagList(
        div(class = "container",
            h1("Analysis of Public Discourse Using Twitter", class = "title fit-h1"),
            div(class = "row featurette center-on-xs",
                div(class = "col-md-7 col-md-push-5",
                    plotlyOutput("tweetsTime")),
                div (class = "col-md-5 col-md-pull-7",
                     p("Between November 2019 and March 2020, Twitter participation levels showed a significant increase related to the Australian fires. The increased activity level was a community response, both from individuals and from organizations, to the tragedies of the latest wildfires that had devastating effects on the wildlife across Australia. As the graph shows, the number of Tweets rose from near zero to 30,000 per day, and social interactions also increased in the form of reposts. This graph presents the scale of the changes in social interactions and the speed of changes in the online sphere. As seen from previous graphs, even though temperature change has been gradual over the past decade, events like large scale fires drive social focus. 
")
                )
            ),
            hr(class = "divider"),
            div(class = "row featurette center-on-xs",
                div(class = "col-md-7",
                    plotOutput("sentiGraph")),
                div (class = "col-md-5",
                     p("When it comes to online interactions, there are two main approaches to understand the content of the textual data. One is to screen the sentiment of the text and the other is to extract topical focuses. To create this graph, a sentiment score was assigned to each individual tweet and the distributions were plotted for each day between June 2019 and April 2020. Similar to the previous graph, changes started to occur in November 2019 but sentiments did not fluctuate on such a large scale as participation. Furthermore, as this graph presents, the results can lead to biased interpretations as until November 2019 the reader might conclude that sentiments did not fluctuate as much. However it could be due to the fact that not as many tweets were available and as a result, the scale was smaller.")
                )
            ),
            hr(class = "divider"),
            div(class = "row featurette center-on-xs",
                div(class = "col-md-7 col-md-push-5",
                    plotOutput("top30")),
                div (class = "col-md-5 col-md-pull-7",
                     p("To better understand how sentiments are captured in the text, this plot shows the 15 most frequently used positive and negative words. As we have understood from the previous graph, the sentiments are fairly balanced between positive and negative, while this graph shows that there are more negative words that are used. It is a biased interpretation, as it is only true for the top 15 negative and positive words, and so, negative words are more centered around a few specific terms while there is a larger spread of words expressing positive sentiments. The word 'support' is by far the most used word with positive sentiment while the words 'devastating' and 'smoke' drives the other end of the spectrum amongst the tweets.")
                )
            ),
            hr(class = "divider"),
            div(class = "row featurette center-on-xs",
                div(class = "col-md-7",
                    plotlyOutput("tweetSentiments")),
                div (class = "col-md-5",
                     p("To understand the sentiment of the Twitter dataset in more detail and go beyond a two-end spectrum, the following graph shows that fear and trust also played a key role in the online sphere. While sadness and anger also showed a stronger effect. 
As discussed earlier, temperature change has been gradual over the past decades and even though there has been a sudden increase in the online participation, least strong amongst all sentiments has been surprise.")
                )
            ),
            hr(class = "divider"),
            div(class = "row featurette center-on-xs",
                div(class = "col-md-7 col-md-push-5",
                    plotOutput("spiderGraph")),
                div (class = "col-md-5 col-md-pull-7",
                     p("And lastly, to better understand the topical nature of the tweets, the last graph presents an abstract interpretation of the topics in the tweets. It is derived from bigrams where word combinations that frequently appear together are observed and plotted. The distance between words is aligned with the frequency of the word given the word combination. This type of graph provides slightly more detail than a word cloud, yet, it is not as insightful as a Latent Dirichlet Allocation model. From the graph, we can still understand that point-in-time events and relief response plays a key role in the texts, but many also talk about climate change, air quality and wildlife.")
                )
            ),
            hr(),
            print("All text data was sourced from Twitter.")
        )
    )
}

#   ____________________________________________________________________________
#   Weather Metrics and Data                                                ####

weatherMetrics <- function() {
    
    tagList(
        div(class = "container",
            h1("Australian Weather Metrics", class = "title fit-h1"),
            div(class = "row featurette center-on-xs",
                div(class = "col-md-7",
                    plotlyOutput("wChart1")),
                div (class = "col-md-5",
                     p("We decided to look at high level temperature changes over time to show that from 2010 to 2019 temperature has risen in Australia coupled with a decline in precipitation and humidity. For this exercise we looked only at 2010-2019 because those were the only full years included in the reporting. We were given metrics for temperature, precipitation, wind and humidity. For wind we were given multiple heights at which it was measured but only considered looking at 10 meters based on research that fire winds are normally looked at around this height given it is high enough to get away from local changes at the ground level but close enough to indicate wind over a broad area. We have created an index to be able to compare how each weather metric is changing over time. 2010, the first year we have available data is being used as the baseline index (all metrics equal to 100 in 2010).")
                     )
            ),
            hr(class = "divider"),
            div(class = "row featurette center-on-xs",
                div(class = "col-md-3",
                    p("Taking a closer look at 2019-2020 Fire Season, September 2019 - March 2020 (latest date we have data for) by week. When we are able to look at the weather metrics by week for the 2019-2020 fire season we can see how conditions change in January. Weeks leading up to this point have high temperatures but very low precipitation, humidity and high winds. Mid-month we see preciptitation and humidty increase significantly even in weeks with high temperature and winds decline sharply. This aligns with when the fires began to let-up with the last fire being put out on March 2nd, 2020.")
                ),
                div (class = "col-md-7",
                     DT::dataTableOutput("wTable1", width = 800)
                )
            ),
            hr(class = "divider"),
            div(class = "row featurette center-on-xs",
                div(class = "col-md-5 col-md-push-7",
                    p("Here we mapped postal codes to latitude and longitude using geocoding. Some postal codes were not able to be mapped and those were excluded from the visualization. We wanted to display how temperature and preceiptation changed over time in Australia throughout the country.")
                    ),
                div (class = "col-md-7 col-md-pull-5",
                     leafletOutput("wMap1")
                )
            ),
            hr(),
            print("All weather data was sourced from the Weather Source company.")
        )
        
    )
}