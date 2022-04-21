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
                       imageOutput("myImage"))))
#img(src = "https://image.tmdb.org/t/p/original/1g0dhYtq4irTY1GPXvft6k4YLjm.jpg", height = 300, width = 250),
#img(src = "https://image.tmdb.org/t/p/original/74xTEgt7R36Fpooo50r9T25onhq.jpg", height = 300, width = 250))))

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


server <- function(input, output) {output$myImage <- renderImage({
    # A temp file to save the output.
    # This file will be removed later by renderImage
    movie_base_on_genre <- movie %>% 
      filter(Genre == input$inputId)
      #filter(str_detect(Genre, input$inputId))
    
    for(x in movie_base_on_genre$Poster_Url){
      img(src = x, height = 300, width = 250)
    }
    #dplyr::filter(movie, grepl(input$inputId, Genre))
    outfile <- tempfile(fileext = '.jpg')
    
    # Generate the PNG
    jpg(outfile, width = 400, height = 300)
    hist(rnorm(input$inputId), main = "Generated in renderImage()")
    dev.off()
    
    # Return a list containing the filename
    list(src = outfile,
         contentType = 'image/jpg',
         width = 400,
         height = 300,
         alt = "This is alternate text")
  }, deleteFile = TRUE)
}

shinyApp(ui = ui, server = server)
