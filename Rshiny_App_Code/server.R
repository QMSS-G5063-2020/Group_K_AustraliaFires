#   ____________________________________________________________________________
#   Server                                                                  ####

library(leaflet)
library(tidyverse)
library(ggplot2)
library(rgdal)
library(spatialEco)
library(gdtools)
library(hrbrthemes)
library(plotly)
library(ggraph)
library(igraph)

shinyServer(function(input, output) {
    
##  ............................................................................
##  Maps                                                                    ####
    
    output$map <- renderLeaflet({
        leaflet(data.frame(lat = fire_data$latitude,lng = fire_data$longitude)) %>%
            addProviderTiles("CartoDB.Positron", options= providerTileOptions(opacity = 0.99)) %>% 
            addCircleMarkers(clusterOptions = markerClusterOptions())%>%
            setView(133.7751, -25.2744, zoom=4)
    })
    
    # ---------------------------
    # create color scheme for map
    pal1 <- colorBin("YlOrRd", domain = sa3_shape@data$values)
    
    output$map2 <- renderLeaflet({
        leaflet(sa3_shape) %>%
            addProviderTiles("CartoDB.Positron", options= providerTileOptions(opacity = 0.99)) %>%
            addPolygons(fillColor = ~pal1(sa3_shape@data$values),
                        weight = 2,
                        opacity = 1,
                        color = "black",
                        dashArray = "1",
                        fillOpacity = 0.7) %>%
            setView(133.7751, -25.2744, zoom=4) %>%
            leaflet::addLegend("bottomleft", pal = pal1, values = sa3_shape@data$values,
                               title = "Population of the SA3 Census Zones",
                               opacity = 1)
    })
    
    # ---------------------------------
    # create a new color scheme for map
    pal2 <- colorBin("YlOrRd", domain = sa4_shape@data$freq)
    
    output$map3 <- renderLeaflet({
        leaflet(sa4_shape) %>%
            addProviderTiles("CartoDB.Positron", options= providerTileOptions(opacity = 0.99)) %>%
            addPolygons(fillColor = ~pal2(sa4_shape@data$freq),
                        weight = 2,
                        opacity = 1,
                        color = "black",
                        dashArray = "2",
                        fillOpacity = 0.7) %>%
            setView(133.7751, -25.2744, zoom=4) %>%
            leaflet::addLegend("bottomleft", pal = pal2, values = sa4_shape@data$freq,
                               title = "Number of Fires",
                               opacity = 1)
    })
    
    # ---------------------------------
    # create interactive chart of Australian weather metrics
    
    output$wChart1 <- renderPlotly({
        chart_melt %>% ggplot(aes(x=YEAR, y=weather_index, colour=variable)) +
            geom_point(aes(text=paste(metric,":", weather_value))) +
            geom_line() +
            facet_grid(~variable) +
            xlab("Year") + ylab("Weather Index") + ggtitle("Australia Weather Metrics 2010-2019") + 
            theme_minimal() +
            theme(legend.position = "none",
                  plot.title = element_text(face = "bold", size = 20, hjust = 0.5), 
                  axis.text.x = element_text(angle = 60, size = 8, hjust = 10),
                  axis.title.x = element_text(vjust = 0.5)) +
            scale_x_continuous(breaks = c(2010, 2012, 2014, 2016, 2018))
    })
    
    # ---------------------------------
    # create interactive table of Australian weather metrics
    
    output$wTable1 <- DT::renderDataTable({
        dt %>% datatable(rownames = FALSE, 
                         colnames = c("Week", "Average Temperature (C)", "Total Precipitation (mm)", 
                                      "Average Humidity", "Max Wind (m/s)"),
                         filter = c("top"), options = list(language = list(sSearch = "Filter:"))) %>%
            formatRound(c('avg_temp', 'sum_precip', 'avg_humidity', 'max_wind'), 0) %>%  
            formatStyle('avg_temp',
                        background = styleColorBar(dt$avg_temp, 'tomato'),
                        backgroundPosition = 'right') %>%
            formatStyle('sum_precip',
                        background = styleColorBar(dt$sum_precip, 'lightblue'),
                        backgroundPosition = 'right') %>%
            formatStyle('avg_humidity',
                        background = styleColorBar(dt$avg_humidity, 'navajowhite'),
                        backgroundPosition = 'right') %>%
            formatStyle('max_wind',
                        background = styleColorBar(dt$max_wind, 'lightgrey'),
                        backgroundPosition = 'right')
    })
    
    # ---------------------------------
    # create interactive map of changes in Australian weather metrics
    
    # first initialize color palettes to use in the map call
    wPal1 = colorFactor("Reds", reverse = TRUE, domain = combined$temp_change)
    color_temp = wPal1(combined$temp_change)
    wPal2 = colorFactor("Blue", reverse = TRUE, domain = combined$precip_change)
    color_precip = wPal2(combined$precip_change)
    wPal3 = colorFactor("YlOrBr", reverse = TRUE, domain = combined$humidity_change)
    color_humidity = wPal3(combined$humidity_change)
    wPal4 = colorFactor("Greys", reverse = TRUE, domain = combined$wind_change)
    color_wind = wPal4(combined$wind_change)
    
    output$wMap1 <- renderLeaflet({
        combined %>% leaflet() %>% 
            addTiles('http://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png') %>% 
            addCircles(color = color_temp, group = "Temperature") %>%
            addCircles(color = color_precip, group = "Precipitation") %>%
            addCircles(color = color_humidity, group = "Humidity") %>%
            addCircles(color = color_wind, group = "Wind") %>%
            setView(lng = 135, lat = -28, zoom = 4.1) %>%
            addLayersControl(overlayGroups = c("Temperature", "Precipitation", "Humidity", 
                                               "Wind")) %>%
            clearBounds() %>%
            addLegend(pal = wPal1, values = combined$temp_change, title = "Temperature % Change", 
                      group = "Temperature") %>%
            addLegend(pal = wPal2, values = combined$precip_change, title = "Precipitation % Change", 
                      group = "Precipitation") %>%
            addLegend(pal = wPal3, values = combined$humidity_change, title = "Humidty % Change", 
                      group = "Humidity") %>%
            addLegend(pal = wPal4, values = combined$wind_change, title = "Wind % Change", 
                      group = "Wind")
    })
    
    output$sentiGraph <- renderPlot({
        senti_tweets %>%
            ggplot() + geom_boxplot(aes(x = date, y = ave_sentiment, group = date)) +
            theme_ipsum() +
            labs(title = "Distribution of the sentiments over time",
                 subtitle = "For individual Tweets",
                 caption = "Data source: Twitter") +
            theme(
                plot.title = element_text(hjust = 0, size = 12),     
                plot.caption = element_text(hjust = 0, face = "italic")) +
            labs(x = "Date", y = "Sentiment score")
    })
    
    output$spiderGraph <- renderPlot({
        set.seed(24)
        tweets_counts %>%
            graph_from_data_frame() %>%
            ggraph(layout = "fr") +
            geom_node_point(color = "blue", size = 2, alpha = 0.3) +
            geom_node_text(aes(label = name), vjust = 1.8, size = 3, check_overlap = TRUE) +
            labs(title = "Word network about Australian wildfires",
                 x = "Relative distance of words", y = "Relative distance of words") + 
            theme_ipsum()
    })
    
    output$tweetSentiments <- renderPlotly({
        tweets_emotions%>%
            ggplot(aes(as.factor(sentiment), fill = sentiment)) +
                geom_bar(stat="count", position = "dodge", alpha = 0.6) +
                theme_ipsum() +
                coord_flip() +
                labs(title = "Different sentiments in Tweets in Europe",
                     caption = "Data source: Survey of Consumer Finances (1989 - 2016)") +
                theme(
                    plot.title = element_text(hjust = 0, size = 12),     
                    plot.caption = element_text(hjust = 0, face = "italic")) +
                labs(x = "Sentiment category", y = "Proportion of sentiment words", colour = "Sentiments") +
                theme(legend.position = "none") +
                scale_fill_brewer(palette="Paired")
    })
    
    output$top30 <- renderPlot({
        top_30 %>%
            mutate(word = reorder(word, n)) %>%
            ggplot(aes(word, n, fill = sentiment)) + geom_col(show.legend = FALSE) + 
            facet_wrap(~sentiment, scales = "free_y") + 
            labs(title = "Top 30 negative and positive words in Tweets",
                 subtitle = "Classified based on Bing dictionaries",
                 y = "Number of words",
                 x = "") + coord_flip() + theme_ipsum() +
            theme(
                plot.title = element_text(hjust = 0, size = 10)) +
            theme_ipsum()
    })
    
    output$tweetsTime <- renderPlotly({
        x <- list(
            title = "Date")
        y <- list(
            title = "Number of Tweets (size based on the # of retweets)")
        fig <- tweets_time %>%
            plot_ly(
                type = 'scatter',
                mode = 'markers',
                x = ~date,
                y = ~count_per_day,
                marker = list(size = ~ave_retweet, sizemode = 'area'),
                hovertemplate = "<br>Number of Tweets: %{y} </br>Date: %{x}"
            )
        fig %>%
            layout(xaxis = x, yaxis = y, title = "Number of Tweets over time")
    }) 
})