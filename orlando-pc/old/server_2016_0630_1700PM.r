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
    
    
    # Render Leaflet map
    # http://rstudio.github.io/leaflet/
    data <- reactiveValues(clickedMarker=NULL)
    output$map<-renderLeaflet({
        # Generate map
        leaflet() %>% addTiles() 
    })
    observeEvent(input$map_marker_click,{
               data$clickedMarker <- input$map_marker_click
               print(data$clickedMarker)}
  )
    observeEvent(input$map_click,{
               data$clickedMap <- input$map_click
               print(data$clickedMap)})
    
    
    
})