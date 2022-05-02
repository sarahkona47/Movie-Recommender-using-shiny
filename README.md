# **Infinity♾Watch**

**Creators**: Kenny Nhan, Alex Shevchenko, Sarah Choi, Marshall Roll

## 🖥 Introduction & Background 

Everyone enjoys watching movies! Don't know what to watch next? Use our app, **Infinity♾Watch**, where we will supply you with recommendations and movie analytics! Want to explore a huge dataset of movies? Explore our visualizations using **Infinity♾Watch**!

**💡 Infinity♾Watch's mission is to provide accurate analytics and customized movie recommendations to its users 💡**

Our team felt that making a web app using Shiny was the one of most useful applications from this course. We envisioned a Movie Recommender App that has multiple tabs which also provides Movie recommendations while also providing data visualizations of the dataset. This project reflects the meaningful learning and collaboration in COMP/STAT 112. 

## 📊 Data 

Our app is built upon a movie dataset with 9000+ movies. This is a publicly accessible dataset and was retrieved from Kaggle.com. 

Variables in our dataset:
- Release_Date: Date when the movie was released.
- Title: Name of the movie.
- Overview: Brief summary of the movie.
- Popularity: It is a very important metric computed by TMDB developers based on the number of views per day, votes per day, number of users marked it as "favorite" and "watchlist" for the data, release date and more other metrics.
- Vote_Count: Total votes received from the viewers.
- Vote_Average: Average rating based on vote count and the number of viewers out of 10.
- Original_Language: Original language of the movies. Dubbed version is not considered to be original language.
- Genre: Categories the movie it can be classified as.
- Poster_Url: Url of the movie poster.

If you would like to explore or gain ddditional information regarding the dataset, you can visit dataset's original source. (Link: https://www.kaggle.com/datasets/disham993/9000-movies-dataset)

## 👩🏻‍💻 Navigating the App 

**Infinity♾Watch** is very easy to navigate! Anyone is able to access **Infinity♾Watch** and its features using the following link: **https://sarahkona47.shinyapps.io/Movie-Recommender-using-shiny/**

The **main features** of the app includes:

1. ***Tab 1***: Analytics 
- In this tab, you are able to explore the dataset and create interactive plots. The user is able to input parameters (Language, Genre, & Date). 
  - The first graph is a horizontal bar plot that displays the top movies depending on the user's input for Language and Genre(s). 
  - The second graph is a line graph that displays the amount of movies produced per year depending on the user's input for Language(s). 
  - The third graph is a point plot that displays the total number of movies per Genre depending on the user's input for a Language.

2. ***Tab 2***: Recommend by Genre
- In this tab, the user is able to chose Genre(s) and the posters and summaries of the top 4 movies in the chosen Genre(s) will be generated! (The recommendation will be based on popularity)
  - To see the movie summary, please hold your mouse on over the poster for at least 2 seconds. 

Upon utilizing our app, we hope that our users are able to gain and observe insightful information about the movies dataset while being suggested with good recommendations of what to watch next! Never let your movie-marathon end with **Infinity♾Watch**!

## 🧠 Acknowledgements 

The creators of the app would like to acknowledge Professor Lauren Milne for the insights, guidance, and feedback througout the app building process. 

