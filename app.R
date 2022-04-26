library(shiny)
library(tidyverse)
library(ggplot2)
library(shinyBS)
library(rsconnect)
movie <- read_csv("https://raw.githubusercontent.com/sarahkona47/Movie-Recommender-using-shiny/2992296bc6ebffdebe766acc1b4704edbc557478/mymoviedb.csv")


movies_by_genre <- movie %>%
  separate(Genre, into = c("Genre1", "Genre2", "Genre3",
                           "Genre4", "Genre5", "Genre6",
                           "Genre7"), 
           sep = ",")

ui <- fluidPage(
  tabsetPanel(tabPanel("Popularity", "Explore the Movies ",
                       selectInput(inputId = "lang", 
                                   label = "Language Choice", 
                                   choices = unique(movies_by_genre$Original_Language)), 
                       # dateRangeInput(inputId = "date",
                       #                label = "Release Date Range",
                       #                start = as.Date(min(movies_by_genre$Release_Date)),
                       #                end = as.Date(max(movies_by_genre$Release_Date)),
                       #                min = as.Date(min(movies_by_genre$Release_Date)),
                       #                max = as.Date(max(movies_by_genre$Release_Date)),
                       #                format = "yyyy-mm-dd",
                       #                startview = "month",
                       #                weekstart = 0,
                       #                language = "en",
                       #                separator = " to "),
                       selectInput(inputId = "genre",
                                   label = "Genre",
                                   choices = unique(movies_by_genre$Genre1), 
                                   multiple = TRUE), 
                       submitButton(text = "Create my plot!", icon = NULL, width = NULL), 
                       plotOutput(outputId = "movieplot")
                       ), 
              tabPanel("Search By Genre", "Movie Recommender Based On Popularity", 
                       selectInput(inputId = "Genre", label = "Genre:",  unique(movies_by_genre$Genre1), multiple = TRUE ),
                       submitButton(text = "Search", icon = NULL, width = NULL),
                       #img(src = "https://image.tmdb.org/t/p/original/1g0dhYtq4irTY1GPXvft6k4YLjm.jpg", height = 300, width = 250),
                       #tipify(htmlOutput("picture", inline = TRUE), "Hello again! This is a click-able pop-up", placement="bottom", trigger = "click")
                       # bsTooltip(id = "someInput", title = "This is an input", 
                       #                                                 placement = "left", trigger = "hover")
                       tipify(htmlOutput("picture", inline = TRUE), textOutput("txt1"), placement="bottom", trigger = "hover"),
                       tipify(htmlOutput("picture2", inline = TRUE),"txt2", placement="bottom", trigger = "hover"),
                       tipify(htmlOutput("picture3", inline = TRUE), "txt3", placement="right", trigger = "hover")
              ))
          
                     
  )


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


server <- function(input, output, session) {
  output$movieplot <- renderPlot(
    movies_by_genre %>%
      filter(Original_Language == input$lang,
             Genre1 %in% input$genre) %>%
      arrange(desc(Popularity)) %>%
      select(Title, Popularity) %>%
      top_n(20) %>%
      ggplot(aes(x = Popularity, y = fct_reorder(Title, Popularity))) +
      geom_col(fill = "lightblue") +
      labs(title = "Top Movies in Selected Language and Genre", y = "", caption = "Popularity metric is computed by TMDB developers based on the number of views per day, \nvotes per day, number of users marked it as 'favorite' and 'watchlist' for the data, release date and more other metrics") +
      theme(plot.caption = element_text(hjust = 0.5)) +
      theme_minimal()
  )
  output$picture <- renderText({

   link <- movies_by_genre %>%
      filter(Genre1 %in% input$Genre) %>%
      arrange(desc(Popularity)) %>%
      select(Poster_Url, Overview, Popularity) %>%
      slice_max(n = 4, order_by = Popularity)

   src = link$Poster_Url
   #c('<img src="',nth(src,1),'" width = 300, height = 400> <img src="',nth(src,2),'" width = 300, height = 400> <img src="',nth(src,3),'" width = 300, height = 400> <img src="',nth(src,4),'" width = 300, height = 400>')})
   c('<img src="',nth(src,1),'" width = 300, height = 400>')})
  # addTooltip(session, id = "someInput", title = "This is an input.",
  #            placement = "left", trigger = "hover")})
  output$picture2 <- renderText({
    
    link <- movies_by_genre %>%
      filter(Genre1 %in% input$Genre) %>%
      arrange(desc(Popularity)) %>%
      select(Poster_Url, Popularity) %>%
      top_n(4)
    
    src = link$Poster_Url
    c('<img src="',nth(src,2),'" width = 300, height = 400>')}) 
  
  output$picture3 <- renderText({
    
    link <- movies_by_genre %>%
      filter(Genre1 %in% input$Genre) %>%
      arrange(desc(Popularity)) %>%
      select(Poster_Url, Popularity) %>%
      top_n(4)
    
    src = link$Poster_Url
    c('<img src="',nth(src,3),'" width = 300, height = 400>')}) 
  
  output$txt1  <- renderText({
    link <- movies_by_genre %>%
      filter(Genre1 %in% input$Genre) %>%
      arrange(desc(Popularity)) %>%
      select(Poster_Url, Popularity) %>%
      top_n(4)
    txt = link$Overview
    c(nth(txt,1))
  })
   
   
}                       

shinyApp(ui = ui, server = server)
