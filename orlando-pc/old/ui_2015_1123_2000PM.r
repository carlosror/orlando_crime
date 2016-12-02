library(shiny)
library(ggmap)
shinyUI(fluidPage(
  titlePanel("Shiny Map"),
  sidebarLayout (
    sidebarPanel(
           textInput("address",label=h3("Location"),
                     value="3210 Escondido Dr, Orlando, FL" ),          
           submitButton("Search"),
           sliderInput("zoom",label=h3("zoom"),
                       min=5,max=20,value=16)
      ),

    mainPanel(
      leafletOutput("map",width="auto",height="640px"),
      dataTableOutput('mytable')
      )  
  )))