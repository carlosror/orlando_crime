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

shinyServer(function(input, output, session) {
    
    
    # Render Leaflet map
    # http://rstudio.github.io/leaflet/
    data <- reactiveValues()
    output$map<-renderLeaflet({
        # Generate map
        leaflet() %>% addTiles() 
    })
    observeEvent(input$map_click,{
               data$clickedMap <- input$map_click
               print(data$clickedMap$lat)
               print(data$clickedMap$lng)
               lat_clicked <- data$clickedMap$lat
               lng_clicked <- data$clickedMap$lng
               updateTextInput(session, inputId = "address", value=paste(lat_clicked, ",", lng_clicked))
               }
               )
    output$debug <- renderPrint({
        updateTextInput(session, inputId = "address", value=paste(lat_clicked, ",", lng_clicked))
        input$address
    })
    
    
})