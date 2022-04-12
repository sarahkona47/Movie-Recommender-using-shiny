library(shiny)
library(tidyverse)
library(ggplot2)
library(rsconnect)

Movie <- readr::read_csv("mymoviedb.csv")

ui <- fluidPage(textInput(inputId = "Genre", label = "Genre:",  unique(Movie$Genre), multiple = TRUE ),
                submitButton(text = "search", icon = NULL, width = NULL),
                plotOutput(outputId = "timeplot"))

server <- function(input, output) { output$timeplot <- renderPlot(Movie %>% 
                                                                   filter(Genre %in% input$Genre) %>% 
                                                                    ggplot(aes()))}
shinyApp(ui = ui, server = server)
