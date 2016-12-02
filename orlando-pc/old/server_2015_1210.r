#########################
# To run in RStudio: 
# library(shiny)
# library(leaflet)
# runApp("shiny")
#########################

library(shiny)
library(ggplot2)
library(ggmap)
library(leaflet)

shinyServer(function(input, output) {
    # Load the dataset of police calls
    calls <- read.csv("calls_2014.csv")
  
    dist_equi <- function (long1, lat1, long2, lat2) {
        # Equirectangular approximation of distance between 2 points
        # http://www.movable-type.co.uk/scripts/latlong.html
        # Not as accurate as Haversine or Spherical Law of Cosines methods but
        # for intra-city distance computations is good enough, I think,
        # and much less computationally intensive.
        
        R = 6371000 # radius of the Earth
        
        # Convert latitudes to radians
        theta1 = lat1 * pi / 180.0
        theta2 = lat2 * pi / 180.0
        
        # Compute difference between two points and convert to radians
        # delta_theta = (lat2 - lat1) * pi / 180.0 
        delta_theta = theta2 - theta1
        delta_lambda = (long2 - long1) * pi / 180.0
        
        x = delta_lambda * cos((theta1 + theta2)/2.0)
        y = delta_theta
        
        # Compute distance, convert it to miles and return it
        return(R * sqrt(x*x + y*y) / 1609.34)
    }
    output$map<-renderLeaflet({
        # vector of coordinates c(long, lat) from user input
        location <- as.numeric(geocode(input$address, source="google")) 
        #subsetting the dataset
        crimes_set <- input$crimes
        relevant_data <- subset(calls, (dist_equi(location[1], location[2], longitude, latitude) < input$radius) & categories == any(crime_set))
        relevant_data_markers <- relevant_data[5:3]
        # getMap <- get_googlemap(location,zoom=input$zoom, markers=relevant_data_markers)
        zoom_value <- if (input$radius == 0.5) 15 else if (input$radius <= 1.5) 14 else 13
        leaflet(data = relevant_data_markers) %>% addTiles() %>% addMarkers(~longitude, ~latitude, popup=~reason, clusterOptions = markerClusterOptions()) %>% setView(location[1], location[2], zoom=zoom_value) %>% addCircles(lng = location[1], lat =location[2], radius = input$radius * 1609.34)
        # ggmap(getMap,extent="panel")  
    })
    output$mytable <- renderDataTable({
        location <- as.numeric(geocode(input$address, source="google")) 
        #subsetting the dataset
        relevant_data <- subset(calls, dist_equi(location[1], location[2], longitude, latitude) < input$radius)
        relevant_data_markers <- relevant_data[5:3]
        relevant_data_markers
    })
    output$debug <- renderPrint({
        # summary(calls)
        # if (variable$cyl == TRUE) "was checked" else " was not checked"
        input$crimes
        # input$cars[["cyl"]]
        # str(input$variable)
    })
})