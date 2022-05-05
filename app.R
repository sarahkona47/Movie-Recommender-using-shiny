library(shiny)
library(tidyverse)
library(ggplot2)
library(shinyBS)
library(rsconnect)
library(lubridate)

movie <- read_csv("https://raw.githubusercontent.com/sarahkona47/Movie-Recommender-using-shiny/datasetnew/movies_with_lang.csv")

movie <- movie %>%
  group_by(language) %>%
  mutate(count = n()) %>%
  filter(count >= 100) %>% 
  ungroup()

movies_by_genre <- movie %>%
  separate(Genre, into = c("Genre1", "Genre2", "Genre3",
                           "Genre4", "Genre5", "Genre6",
                           "Genre7"), 
           sep = ",")

genre_list <- movies_by_genre$Genre1 %>% 
  unique()

genre_df <- data.frame(genre_name = genre_list)
genre_df$genre_count <- replicate(nrow(genre_df), 0)


ui <- fluidPage(
  navbarPage(strong("Infinity Watch"),
             tabPanel("Analytics", h1("Explore the Movies",
                                      align = "center",
                                      style = "font-weight:bold"),
                      h4("Movie Popularity", 
                         align = "center",
                         style = "color:blue;font-weight:bold"),
                      sidebarLayout(
                        sidebarPanel(
                          selectInput(inputId = "lang", 
                                      label = "Language Choice", 
                                      choices = unique(movies_by_genre$language)), 
                          selectInput(inputId = "genre",
                                      label = "Genre",
                                      choices = unique(movies_by_genre$Genre1), 
                                      multiple = TRUE), 
                          submitButton(text = "Create my plot!", 
                                       icon = NULL, width = NULL), 
                        ),
                        mainPanel(
                          plotOutput(outputId = "movieplot"),
                        )
                      ),
                      br(),
                      br(),
                      h4("Movies over Time", 
                         align = "center",
                         style = "color:blue;font-weight:bold"),
                      sidebarLayout(
                        sidebarPanel(
                          selectInput(inputId = "language", 
                                      label = "Language Choice", 
                                      choices = unique(movies_by_genre$language),
                                      multiple = TRUE), 
                          sliderInput(inputId = "years",
                                      label = "Date Range",
                                      min = as.Date("1902-10-10"),
                                      max = as.Date("2024-10-10"),
                                      value = c(as.Date("1902-10-10"), 
                                                as.Date("2024-10-10"))),
                          submitButton(text = "Create my plot!", 
                                       icon = NULL, width = NULL)
                        ),
                        mainPanel(
                          plotOutput(outputId = "languageplot")
                        )
                      ),
                      br(),
                      br(),
                      h4("Genre Breakdown", 
                         align = "center",
                         style = "color:blue;font-weight:bold"),
                      sidebarLayout(
                        sidebarPanel(
                          selectInput(inputId = "langSelect",
                                      label = "Language",
                                      choices = unique(movies_by_genre$language)),
                          submitButton(text = "Create my plot!", 
                                       icon = NULL, width = NULL)
                        ),
                        mainPanel(plotOutput(outputId = "genreplot"))
                      ),
                    ),
                       
              tabPanel("Recommender", 
                       h1("Movie Recommender", 
                          align = "center",
                          style = "font-weight:bold"),
                       h5("Based on Popularity",
                          align = "center"),
                       selectInput(inputId = "Genre", 
                                   label = "Genre:",  
                                   unique(movies_by_genre$Genre1), 
                                   multiple = TRUE),
                       submitButton(text = "Search", 
                                    icon = NULL, 
                                    width = NULL),
                       htmlOutput("picture", inline = TRUE),
                       htmlOutput("picture2", inline = TRUE),
                       htmlOutput("picture3", inline = TRUE),
                       htmlOutput("picture4", inline = TRUE)
                
              )))

server <- function(input, output){

  output$movieplot <- renderPlot(
    movies_by_genre %>%
      filter(language == input$lang,
             Genre1 %in% input$genre) %>%
      arrange(desc(Popularity)) %>%
      select(Title, Popularity) %>%
      top_n(20) %>%
      ggplot(aes(x = Popularity, 
                 y = fct_reorder(Title, Popularity),
                 fill = Popularity)) +
      scale_fill_gradient(low = "#8cfbff",
                          high = "#095282") +
      geom_col() +
      labs(title = "Top Movies in Selected Language and Genre",
           y = "", caption = "Popularity metric is computed by TMDB developers based on the number of views per day, votes per day,\n number of users marked it as 'favorite' and 'watchlist' for the data, release date and more other metrics") +
      guides(fill = FALSE) +
      theme(plot.caption = element_text(hjust = 0.5))
  )
  
  output$languageplot <- renderPlot(
    if(length(c(input$language) > 0)){
      movie %>% 
        mutate(year = lubridate::year(Release_Date)) %>% 
        group_by(year, language) %>% 
        filter(language %in% input$language) %>% 
        mutate(count = n()) %>% 
        ungroup() %>% 
        ggplot(aes(x = Release_Date, y = count, color = language)) + 
        scale_x_date(limits = c(input$years)) + 
        facet_wrap(.~language) +
        geom_line() + 
        labs(x = "Release Date", y = "",
             title = "Release Dates of Movies in Selected Languages")
    }
  )
  
  output$genreplot <- renderPlot(
    movies_by_genre %>%  
      pivot_longer(Genre1:Genre7, names_to = "genre_num", values_to = "genre") %>% 
      filter(language %in% c(input$langSelect)) %>% 
      mutate(genre_str = str_squish(genre)) %>% 
      group_by(genre_str) %>% 
      mutate(count = n()) %>%
      na.omit() %>% 
      ggplot(aes(x = count,
                 y = fct_reorder(genre_str, count),
                 fill = count)) +
      scale_fill_gradient(low = "#8cffa5",
                           high = "#01420f") +
      geom_col() +
      guides(fill = FALSE) +
      labs(x = "Total Number of Movies", y = "",
           title = "Number of Movies in Each Genre for Selected Language")
  )
  
  output$picture <- renderText({

   link <- movies_by_genre %>%
      filter(Genre1 %in% input$Genre) %>%
      arrange(desc(Popularity)) %>%
      select(Poster_Url, Overview, Popularity) %>%
      slice_max(n = 4, order_by = Popularity)

   src = link$Poster_Url
   word = link$Overview
   c('<img src="',nth(src,1),'" width = 300, height = 400, title = "',nth(word,1),'">')})

  output$picture2 <- renderText({
    
    link <- movies_by_genre %>%
      filter(Genre1 %in% input$Genre) %>%
      arrange(desc(Popularity)) %>%
      select(Poster_Url, Overview, Popularity) %>%
      slice_max(n = 4, order_by = Popularity)
    
    src = link$Poster_Url
    word = link$Overview
    c('<img src="',nth(src,2),'" width = 300, height = 400, title = "',nth(word,2),'">')}) 
  
  output$picture3 <- renderText({
    
    link <- movies_by_genre %>%
      filter(Genre1 %in% input$Genre) %>%
      arrange(desc(Popularity)) %>%
      select(Poster_Url, Overview, Popularity) %>%
      slice_max(n = 4, order_by = Popularity)
    
    src = link$Poster_Url
    word = link$Overview
    c('<img src="',nth(src,3),'" width = 300, height = 400, title = "',nth(word,3),'">')}) 
  
  
  output$picture4 <- renderText({
    
    link <- movies_by_genre %>%
      filter(Genre1 %in% input$Genre) %>%
      arrange(desc(Popularity)) %>%
      select(Poster_Url, Overview, Popularity) %>%
      slice_max(n = 4, order_by = Popularity)
    
    src = link$Poster_Url
    word = link$Overview
    c('<img src="',nth(src,4),'" width = 300, height = 400, title = "',nth(word,4),'">')}) 
}                       

shinyApp(ui = ui, server = server)
