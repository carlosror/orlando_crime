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
    dataClicked <- reactiveValues()
    output$map<-renderLeaflet({
        # Generate map
        leaflet() %>% addTiles() 
    })
    observeEvent(input$map_click,{
               dataClicked$clickedMap <- input$map_click
               print(dataClicked$clickedMap$lat)
               print(dataClicked$clickedMap$lng)
               lat_clicked <- dataClicked$clickedMap$lat
               lng_clicked <- dataClicked$clickedMap$lng
               updateTextInput(session, inputId = "address", value=paste(lat_clicked, ",", lng_clicked))
               }
               )
    output$debug <- renderPrint({
        updateTextInput(session, inputId = "address", value=paste(lat_clicked, ",", lng_clicked))
        input$address
    })
    
    
})