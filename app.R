library(shiny)
library(tidyverse)
library(ggplot2)
movie <- read_csv("https://raw.githubusercontent.com/sarahkona47/Movie-Recommender-using-shiny/2992296bc6ebffdebe766acc1b4704edbc557478/mymoviedb.csv")

ui <- fluidPage(
  tabsetPanel(tabPanel("Tab 1", "Explore the Movies ",  
                       dateRangeInput(inputId = "date", 
                                      label = "Release Date Range",
                                      start = as.Date(min(movie$Release_Date)), 
                                      end = as.Date(max(movie$Release_Date)),
                                      min = as.Date(min(movie$Release_Date)), 
                                      max = as.Date(max(movie$Release_Date)), 
                                      format = "yyyy-mm-dd",
                                      startview = "month",
                                      weekstart = 0,
                                      language = "en",
                                      separator = " to ")), 
              tabPanel("Tab 2", "Movie Recommender", 
                       selectInput(inputId = "Genre", label = "Genre:",  unique(genre_df$genre_name), multiple = TRUE ),
                       submitButton(text = "Search", icon = NULL, width = NULL),
img(src = "https://image.tmdb.org/t/p/original/1g0dhYtq4irTY1GPXvft6k4YLjm.jpg", height = 300, width = 250),
img(src = "https://image.tmdb.org/t/p/original/74xTEgt7R36Fpooo50r9T25onhq.jpg", height = 300, width = 250))))

# sliderInput(inputId = "date", 
#             label = "Release Date Range",
#             min = as.Date(min(movie$Release_Date)), 
#             max = as.Date(max(movie$Release_Date)), 
#             value = c(as.Date(min(movie$Release_Date)), as.Date(max(movie$Release_Date)))),
# textInput("name", 
#           "Name", 
#           value = "", 
#           placeholder = "Lisa"),
# selectInput("sex", 
#             "Sex", 
#             choices = list(Female = "F", Male = "M")),
# submitButton(text = "Create my plot!")


server <- function(input, output) {
}

shinyApp(ui = ui, server = server)
