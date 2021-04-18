library(shiny)
library(shinydashboard)

# Define UI for application that draws a histogram
shinyUI(
    dashboardPage(skin = "green",
        dashboardHeader(title = "Steam Charts"),
        dashboardSidebar(
            sidebarMenu(
                menuItem(text = "Trend Comparison", tabName = "menu1", icon = icon("th")),
                menuItem(text = "Games Statistics", tabName = "menu2", icon = icon("signal")),
                menuItem(text = "Source", tabName = "menu3", icon = icon("file-alt"))
            )
        ),
        dashboardBody(
            tabItems(
                tabItem(tabName = "menu1", h1("Trend Comparison of Steam Games"),
                        fluidRow(
                            valueBox(value = games$gamename %>% 
                                         unique() %>% 
                                         length(),
                                     subtitle = "Games in Total",
                                     color = "red",
                                     icon = icon("gamepad"),
                                     width = 4),
                            valueBox(value = games$year %>% 
                                         unique() %>% 
                                         length(),
                                     subtitle = "Years of Data Recorded",
                                     color = "green",
                                     icon = icon("file"),
                                     width = 4),
                            valueBox(value = "100%",
                                     subtitle = "Real Data",
                                     color = "blue",
                                     icon = icon("check"),
                                     width = 4)
                        ),
                        fluidRow(
                            box(height = 150, width = 4,title = "Select 1st Game", background = "black",
                                selectInput(inputId = "gamename1",label = "",choices = unique(games$gamename))),
                            box(height = 150, width = 4,title = "Select 2nd Game", background = "black",
                                selectInput(inputId = "gamename2",label = "",choices = unique(games$gamename))),
                            box(height = 150, width = 4,title = "Select 3rd Game", background = "black",
                                selectInput(inputId = "gamename3",label = "",choices = unique(games$gamename)))
                        ),
                        fluidRow(
                            box(width = 12, background = "green",
                                plotlyOutput(outputId = "combined", height = 700)
                                )
                        ),
                        fluidRow(
                            box(width = 4, background = "black",
                                plotlyOutput(outputId = "percentgain1")
                                ),
                            box(width = 4, background = "black",
                                plotlyOutput(outputId = "percentgain2")
                                ),
                            box(width = 4, background = "black",
                                plotlyOutput(outputId = "percentgain3")
                                )
                                )   
                        ),
                tabItem(tabName = "menu2", h1("Game Statistics"),
                        fluidRow(
                            box(width = 12, background = "black",align = "center",
                                shinyWidgets::sliderTextInput(
                                    inputId    = "slider",
                                    label      = "Select Month Year",
                                    choices    = sort(unique(games$date),decreasing = F),
                                    grid       = FALSE,
                                    width      = "100%",
                                    hide_min_max = TRUE,
                                    dragRange  = FALSE 
                                )
                            )
                        ),
                        fluidRow(
                            column(width = 4,
                                   box(height = 500,
                                       title = "Top 5 Gainers of The Month", width = NULL, solidHeader = TRUE, status = "success",
                                       DT::dataTableOutput("top5gainer")
                                      )
                                  ),
                            column(width = 8,
                                   box(width = NULL, height = 500, title = "Barplot of The Top 5 Gainers", solidHeader = TRUE, status = "success",
                                       plotlyOutput(outputId = "plot5gainer")
                                      )
                                  )
                                ),
                        fluidRow(
                            column(width = 8,
                                   box(width = NULL,
                                       plotlyOutput(outputId = "avgcum")
                                      )
                                
                                  ),
                            column(width = 4,
                                   box(width = NULL,
                                       "Box content here", br(),
                                       sliderInput("numberinput", "Number of Recorded Data:", 1, 120, 50),
                                       selectInput("selectgame", "Select Game Name", choices = unique(games$gamename), multiple = TRUE)
                                       
                                   )
                                
                                  )
                                )
                        ),
                tabItem(tabName = "menu3", width = 12,
                        DT::dataTableOutput("dataframe"),
                        "Source: github.com/rfordatascience/tidytuesday/blob/master/data/2021/2021-03-16/readme.md#gamescsv"
                    
                        )
                )
        )


    )
)
