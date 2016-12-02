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
    calls <- read.csv("calls_2014_munged.csv")
  
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
    
    data_filter <- function(location, crimes_set, crimes_days, crimes_periods) {
        ###################################################################################################################################
        # Function that subsets the calls data frame based on the user inputs
        # 
        # Inputs:
        # location: vector of coordinates c(long, lat) from user input
        # crimes_set: vector of crime types from user, e.g., c("arson", "assault", "battery", ...)
        # crimes_days: vector of days of week selected by user, e.g., c("weekday"), or c("weekday", "weekend"), or c("weekend")
        # crimes_periods: vector of crime periods, e.g., c("early_morning", "morning", "afternoon", "evening"), or some combination thereof
        # 
        # Outputs:
        # relevant_data, a subset of the original calls data frame
        ###################################################################################################################################
        
        # Filter by distance:
        relevant_data <- subset(calls, (dist_equi(location[1], location[2], longitude, latitude) < input$radius)) 
        # Filter by crime types
        relevant_data <- subset(relevant_data, categories %in% crimes_set) 
        # Filter by days of week
        relevant_data <- subset(relevant_data, days %in% crimes_days) 
        # Filter by day period
        relevant_data <- subset(relevant_data, periods %in% crimes_periods) 
        
        relevant_data
    }
    # Render Leaflet map
    # http://rstudio.github.io/leaflet/
    output$map<-renderLeaflet({
        # vector of coordinates c(long, lat) from user input
        location <- as.numeric(geocode(input$address, source="google")) 
        # vector of crime types from user, e.g., c("arson", "assault", "battery", ...)
        # they are the crime types selected by the user
        crimes_set <- input$crimes
        # vector of days of week selected by user, e.g., c("weekday"), or c("weekday", "weekend"), or c("weekend")
        crimes_days <- input$days_of_week
        # vector of crime periods, e.g., c("early_morning", "morning", "afternoon", "evening"), or some combination thereof
        crimes_periods <- input$time_periods
        # Call function to filter data based on user inputs
        relevant_data <- data_filter(location, crimes_set, crimes_days, crimes_periods)
        # Use some of the columns as markers for the leaflet() function
        relevant_data_markers <- relevant_data[c("event_time", "longitude", "latitude", "reason")]
        zoom_value <- if (input$radius == 0.5) 15 else if (input$radius <= 1.5) 14 else 13 # set map zoom based on user-selected radius
        # Generate map
        leaflet(data = relevant_data_markers) %>% addTiles() %>% addMarkers(~longitude, ~latitude, popup=~paste("<b style='color:DarkRed;'>Event:</b>", reason, "<b style='color:DarkRed;'>Date & Time:</b>", event_time, sep = "<br/>"), clusterOptions = markerClusterOptions()) %>% setView(location[1], location[2], zoom=zoom_value) %>% addCircles(lng = location[1], lat =location[2], radius = input$radius * 1609.34)
    })
    # Render Data Table
    # http://rstudio.github.io/DT/
    output$DataTable <- renderDataTable({
        # vector of coordinates c(long, lat) from user input
        location <- as.numeric(geocode(input$address, source="google")) 
        # vector of crime types from user, e.g., c("arson", "assault", "battery", ...)
        # they are the crime types selected by the user
        crimes_set <- input$crimes
        # vector of days of week selected by user, e.g., c("weekday"), or c("weekday", "weekend"), or c("weekend")
        crimes_days <- input$days_of_week
        # vector of crime periods, e.g., c("early_morning", "morning", "afternoon", "evening"), or some combination thereof
        crimes_periods <- input$time_periods
        # Call function to filter data based on user inputs
        relevant_data <- data_filter(location, crimes_set, crimes_days, crimes_periods)
        
        # Use relevant columns for table
        relevant_data_table <- relevant_data[c("event_time", "reason", "categories", "days")]
        relevant_data_table
    })
    # Render barplots
    # "R in a Nutshell, Second Edition", Chapter 15
    output$barplots <- renderPlot({
        # vector of coordinates c(long, lat) from user input
        location <- as.numeric(geocode(input$address, source="google")) 
        # vector of crime types from user, e.g., c("arson", "assault", "battery", ...)
        # they are the crime types selected by the user
        crimes_set <- input$crimes
        # vector of days of week selected by user, e.g., c("weekday"), or c("weekday", "weekend"), or c("weekend")
        crimes_days <- input$days_of_week
        # vector of crime periods, e.g., c("early_morning", "morning", "afternoon", "evening"), or some combination thereof
        crimes_periods <- input$time_periods
        # Call function to filter data based on user inputs
        relevant_data <- data_filter(location, crimes_set, crimes_days, crimes_periods)
        
        levels(relevant_data$periods) <- c("early_morning", "morning", "afternoon", "evening")
        relevant_data$periods <- factor(relevant_data$periods, labels = c("Early AM", "Morning", "Afternoon", "Evening"))
        levels(relevant_data$days) <- c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday")
        
        # Find out top crime categories, will plot top 6 only
        categories_table_sorted <- table(relevant_data$categories) %>% sort(decreasing = TRUE)
        categories_top <- names(categories_table_sorted)
        relevant_data <- subset(relevant_data, categories %in% categories_top[1:6])
        
        # Use ggplot2's qplot to plot using days of week as facets
        # qplot(x=days, data=relevant_data, geom = "bar", fill=categories, position = "dodge", ylab = "Police calls") + facet_grid(periods ~.)
        
        crime_barplot <- ggplot(data = relevant_data, aes(x = days, fill = categories)) + geom_bar( position="dodge") 
        crime_barplot + facet_grid( periods~. )
    })
    # Summary table
    output$summary <- renderTable({
        # vector of coordinates c(long, lat) from user input
        location <- as.numeric(geocode(input$address, source="google")) 
        # vector of crime types from user, e.g., c("arson", "assault", "battery", ...)
        # they are the crime types selected by the user
        crimes_set <- input$crimes
        # vector of days of week selected by user, e.g., c("weekday"), or c("weekday", "weekend"), or c("weekend")
        crimes_days <- input$days_of_week
        # vector of crime periods, e.g., c("early_morning", "morning", "afternoon", "evening"), or some combination thereof
        crimes_periods <- input$time_periods
        # Call function to filter data based on user inputs
        relevant_data <- data_filter(location, crimes_set, crimes_days, crimes_periods)
        
        relevant_data$categories <- as.character(relevant_data$categories) #converts from factor levels characters for tabulation
        
        summary_table <- table(relevant_data$categories, relevant_data$periods)
        summary_table
    })
    # Render barplots
    # "R in a Nutshell, Second Edition", Chapter 15
    output$heatmaps <- renderPlot({
        # vector of coordinates c(long, lat) from user input
        location <- as.numeric(geocode(input$address, source="google")) 
        # vector of crime types from user, e.g., c("arson", "assault", "battery", ...)
        # they are the crime types selected by the user
        crimes_set <- input$crimes
        # vector of days of week selected by user, e.g., c("weekday"), or c("weekday", "weekend"), or c("weekend")
        crimes_days <- input$days_of_week
        # vector of crime periods, e.g., c("early_morning", "morning", "afternoon", "evening"), or some combination thereof
        crimes_periods <- input$time_periods
        # Call function to filter data based on user inputs
        relevant_data <- data_filter(location, crimes_set, crimes_days, crimes_periods)
        
        levels(relevant_data$periods) <- c("early_morning", "morning", "afternoon", "evening")
        relevant_data$periods <- factor(relevant_data$periods, labels = c("Early AM", "Morning", "Afternoon", "Evening"))
        levels(relevant_data$days) <- c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday")
        
        # Find out top crime categories, will plot top 6 only
        categories_table_sorted <- table(relevant_data$categories) %>% sort(decreasing = TRUE)
        categories_top <- names(categories_table_sorted)
        relevant_data <- subset(relevant_data, categories %in% categories_top[1:6])
        
        zoom_value <- if (input$radius == 0.5) 15 else if (input$radius <= 1.5) 14 else 13 # set map zoom based on user-selected radius
        
        
        location_map <- get_map(location = input$address, source= "google", zoom = zoom_value + 1, color = "color") %>% ggmap(extent = "panel")
        # location_map
        # ggmap(location_map, extent = "panel")
        # location_map <- qmap(input$address,  zoom = zoom_value, color = "bw", source = "osm", extent = "panel")
        # location_map + geom_point(aes(x = longitude, y = latitude, color = categories), data = relevant_data, size = 3) + facet_wrap(~ periods)
        location_map <- location_map + stat_density2d(aes(x = longitude, y = latitude, fill = ..level.., alpha = ..level..), bins = 20, geom = "polygon", data = relevant_data) + scale_fill_gradient(low = "yellow", high = "red") 
        location_map <- if (input$hm_facet[1] == "Categories") location_map + facet_wrap(~ categories) else if (input$hm_facet[1] == "Days") location_map + facet_wrap(~ days) else location_map + facet_wrap(~ periods)
        location_map <- location_map + theme(plot.title = element_text(size = 24, face = "bold"), strip.text.x = element_text(size = 16), legend.position = "none", axis.text.x = element_blank(), axis.title.x = element_blank(), axis.ticks.x = element_blank(),  axis.text.y = element_blank(), axis.title.y = element_blank(), axis.ticks.y = element_blank())
        location_map + ggtitle("Heat Maps")
        # location_map + stat_density2d(aes(x = longitude, y = latitude, fill = ..level.., alpha = ..level..), bins = 5, geom = "polygon", data = relevant_data) + facet_wrap(~ categories) + theme(legend.position = "none")
        
        # location_map + geom_point(aes(x = location[1], y = location[2], color = categories), data = relevant_data)
    })
    output$HTML <- renderUI({includeHTML("include.html")})
        
    output$debug <- renderPrint({
        # vector of coordinates c(long, lat) from user input
        location <- as.numeric(geocode(input$address, source="google")) 
        # vector of crime types from user, e.g., c("arson", "assault", "battery", ...)
        # they are the crime types selected by the user
        crimes_set <- input$crimes
        # vector of days of week selected by user, e.g., c("weekday"), or c("weekday", "weekend"), or c("weekend")
        crimes_days <- input$days_of_week
        # vector of crime periods, e.g., c("early_morning", "morning", "afternoon", "evening"), or some combination thereof
        crimes_periods <- input$time_periods
        # Call function to filter data based on user inputs
        relevant_data <- data_filter(location, crimes_set, crimes_days, crimes_periods)
        
        levels(relevant_data$periods) <- c("early_morning", "morning", "afternoon", "evening")
        str(relevant_data$periods)
        
        # input$hm_facet[1] == "categories" 
        
        # categories_table_sorted <- table(relevant_data$categories) %>% sort(decreasing = TRUE)
        # categories_top <- names(categories_table_sorted)
        # relevant_data <- subset(relevant_data, categories %in% categories_top[1;6])
        # categories_top[1:4]
        # relevant_data$categories <- as.character(relevant_data$categories)
        # temp_table3 <- table(relevant_data$categories, relevant_data$periods, relevant_data$days)
        # temp_table3
        # table_df <- as.data.frame(temp_table3)
        # table_df
        # levels(relevant_data$categories) <- categories_top[1:4]
        # levels(relevant_data$categories)
    })
})